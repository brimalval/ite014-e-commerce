from flask import Flask, render_template, request, redirect, url_for, session

import psycopg2
from psycopg2.extras import RealDictCursor

from datetime import datetime

import os
from concurrent.futures import ThreadPoolExecutor
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = "Lazopee"
app.config["UPLOAD_FOLDER"] = "C:/Users/brian/Desktop/FlaskApp/static/uplimg"

#--------PSYCOPG2 TEST---------#
conn = psycopg2.connect(
	   host = "localhost",
	   database = "ecommerce_db",
	   user = "brian",
	   password = "password123")

#---CURSOR SYNTAX W/ NAMED INDICES---#
# cur = conn.cursor(cursor_factory=RealDictCursor)

# @app.route("/", methods=["POST", "GET"])
# def index():
# 	data = None
# 	if request.method == 'POST':
# 		result = request.form
# 		cur.execute(f"{request.form['query']}")
# 		conn.commit()

# 	cur.execute("SELECT * FROM test_tbl")
# 	data = cur.fetchall()
# 	return render_template("test.html", data=data)
#------------------------------#
 
# HOME PAGE #
@app.route("/", methods=["POST", "GET"])
def index():
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
	cursor = conn.cursor(cursor_factory = RealDictCursor)
	sql = "SELECT DISTINCT ON (p.product_id, date_updated) * FROM products AS p LEFT JOIN product_images AS pi ON p.product_id = pi.product_id ORDER BY date_updated DESC"
	cursor.execute(sql)
	products = cursor.fetchall()

	sql = "SELECT product_id FROM products ORDER BY date_updated DESC"
	cursor.execute(sql)
	product_ids = cursor.fetchall()
	cursor.close()

	return render_template("index.html", products=products, product_ids = product_ids)

# SEARCH RESULTS #
@app.route("/search", methods=["POST","GET"])
def search():
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
	key = None
	if request.args.get("key") != None:
		key = request.args.get("key")
		cursor = conn.cursor(cursor_factory=RealDictCursor)
		sql = f"SELECT DISTINCT ON (p.product_id, date_updated) * FROM products AS p LEFT JOIN product_images AS pi ON p.product_id = pi.product_id WHERE name ILIKE '%{key}%' OR brand ILIKE '%{key}%' ORDER BY date_updated DESC"
		cursor.execute(sql)
		products = cursor.fetchall()
	
		sql = f"SELECT COUNT(*) FROM products WHERE name ILIKE '%{key}%' OR brand ILIKE '%{key}%'"
		cursor.execute(sql)
		count = cursor.fetchone()

		sql = f"SELECT product_id FROM products WHERE name ILIKE '%{key}%' OR brand ILIKE '%{key}%' ORDER BY date_updated DESC"
		cursor.execute(sql)
		product_ids = cursor.fetchall()

		cursor.close()
	return render_template("search.html", key=key, products=products, count=count, product_ids=product_ids
	)

# BROWSE PRODUCTS #
@app.route("/products")
@app.route("/products/<category>")
@app.route("/products/<category>/<subcategory>")
@app.route("/products/<category>/<subcategory>/<sscategory>")
def products(category=None, subcategory=None, sscategory=None):
	categories = ["mouse", "keyboard", "mousepad", "earphones", "headphones"]
	subcategories = ["wireless", "wired", "true_wireless", "membrane", "mechanical", "regular", "extended"]
	sscategories = ["wireless", "wired"]
	if category is None:
		return redirect(url_for('index'))
	if category not in categories or (subcategory not in subcategories and subcategory is not None) or (sscategory not in sscategories and sscategory is not None):
		return redirect(url_for('index'))

	catTitle = category[0].upper() + category[1:]
	ssTitle = None
	subcatTitle = None
	sql = f"SELECT DISTINCT ON (p.product_id) * FROM products AS p LEFT JOIN product_images AS pi ON p.product_id = pi.product_id WHERE p.product_id IN (SELECT p.product_id FROM products AS p RIGHT JOIN product_category AS cp ON p.product_id = cp.product_id LEFT JOIN categories AS c ON cp.category_id = c.category_id WHERE category_name = '{category}')"
	if subcategory is not None:
		subcatTitle = subcategory[0].upper() + subcategory[1:]
		sql += f" AND p.product_id IN (SELECT p.product_id FROM products AS p RIGHT JOIN product_category AS cp ON p.product_id = cp.product_id LEFT JOIN categories AS c ON cp.category_id = c.category_id WHERE category_name = '{subcategory}')"
	if sscategory is not None:
		ssTitle = sscategory[0].upper() + sscategory[1:]
		sql += f" AND p.product_id IN (SELECT p.product_id FROM products AS p RIGHT JOIN product_category AS cp ON p.product_id = cp.product_id LEFT JOIN categories AS c ON cp.category_id = c.category_id WHERE category_name = '{sscategory}');"
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	cursor.execute(sql)
	products = cursor.fetchall()

	sql = f"SELECT product_id FROM products WHERE product_id IN (SELECT p.product_id FROM products AS p RIGHT JOIN product_category AS cp ON p.product_id = cp.product_id LEFT JOIN categories AS c ON cp.category_id = c.category_id WHERE category_name = '{category}')"
	if subcategory is not None:
		subcatTitle = subcategory[0].upper() + subcategory[1:]
		sql += f" AND product_id IN (SELECT p.product_id FROM products AS p RIGHT JOIN product_category AS cp ON p.product_id = cp.product_id LEFT JOIN categories AS c ON cp.category_id = c.category_id WHERE category_name = '{subcategory}')"
	if sscategory is not None:
		ssTitle = sscategory[0].upper() + sscategory[1:]
		sql += f" AND product_id IN (SELECT p.product_id FROM products AS p RIGHT JOIN product_category AS cp ON p.product_id = cp.product_id LEFT JOIN categories AS c ON cp.category_id = c.category_id WHERE category_name = '{sscategory}');"
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	cursor.execute(sql)
	product_ids = cursor.fetchall()
	return render_template('browse-products.html', category=catTitle, subcategory=subcatTitle, sscategory = ssTitle, products = products, product_ids=product_ids)
	

#VIEW SINGLE PRODUCT
@app.route("/product", methods=["POST", "GET"])
def single_product():
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		if "transact-type" in request.form:
			if "uid" not in session:
				return redirect(url_for('login'))
			if request.form['address_id'] == '-1':
				return "<script>alert('No shipping address available!'); window.location = '/address';</script>"
			if request.form['payment_id'] == '-1':
				return "<script>alert('No payment options available!'); window.location = '/payment-options';</script>"

			if request.form["transact-type"] == "buy":
				now = datetime.now().timestamp()
				# Increments date by a week
				now += 604800
				deldate = datetime.utcfromtimestamp(now).strftime('%m-%d-%Y')
				cursor = conn.cursor()
				sql = "INSERT INTO orders (customer_id, status, address_id, product_id, payment_id, delivery_date, quantity) VALUES (%s, %s, %s, %s, %s, %s, %s)"
				data = (session['uid'], 'DELIVERING', request.form['address_id'], request.args.get('id'), request.form['payment_id'], deldate, request.form['qty'])
				cursor.execute(sql, data)
				conn.commit()

				sql = f"UPDATE products SET stock = stock - {request.form['qty']}, date_updated = NOW() WHERE product_id = {request.args.get('id')}"
				cursor.execute(sql)
				conn.commit()
				cursor.close()
				return "<script>alert('Order placed successfully.'); window.location = '/';</script>"
			elif request.form['transact-type'] == "cart":
				cursor = conn.cursor()
				sql = "SELECT * FROM cart WHERE product_id = %s AND customer_id = %s"
				data = (request.args.get("id"), session['uid'])
				cursor.execute(sql, data)
				row = cursor.fetchone()
				# IF THE ORDER ALREADY EXISTS, INCREMENT QUANTITY
				if row:
					# IF ATTEMPTED QUANTITY + CURRENT QUANTITY IS GREATER THAN AVAILABLE STOCK, THROW ALERT
					sql = f"SELECT stock FROM products WHERE product_id = {request.args.get('id')}"
					cursor.execute(sql)
					stock = cursor.fetchone()[0]

					sql = f"SELECT quantity FROM cart WHERE product_id={request.args.get('id')} AND customer_id={session['uid']}"
					cursor.execute(sql)
					quantity = cursor.fetchone()[0]

					if(int(request.form['qty']) + quantity > stock):
						return "<script>alert('Order quantity exceeds available stock!'); window.location = '/';</script>"

					sql = "UPDATE cart SET quantity = quantity + %s WHERE product_id = %s AND customer_id = %s"
					data = (request.form['qty'], request.args.get('id'), session['uid'])
					cursor.execute(sql, data)
					conn.commit()
					cursor.close()
					return "<script>alert('Sucessfully added to cart.'); window.location = '/'; </script>"
				sql = "INSERT INTO cart VALUES (%s, %s, %s)"
				data = (session['uid'], request.args.get('id'), request.form['qty'])
				cursor.execute(sql, data)
				conn.commit()
				cursor.close()
				return "<script>alert('Sucessfully added to cart.'); window.location = '/'; </script>"
			else:
				cursor = conn.cursor()
				sql = f"UPDATE products SET stock = stock + {request.form['add-stock']} WHERE product_id = {request.args.get('id')}"
				cursor.execute(sql)
				conn.commit()
				cursor.close()
	if request.args.get("id") == None:
		return redirect(url_for("index"))

	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = f"SELECT * FROM products WHERE product_id = {request.args.get('id')}"
	cursor.execute(sql)
	product_details = cursor.fetchone()
	if product_details is None:
		return redirect(url_for("index"))
	product_details['price'] = round(product_details['price'],2)
	addresses = None
	first_address = None
	payment_options = None
	if "uid" in session:
		sql = f"SELECT * FROM countries AS co RIGHT JOIN addresses AS a ON co.country_code = a.country_code LEFT JOIN customers AS c ON a.customer_id = c.customer_id WHERE a.customer_id = {session['uid']}"
		cursor.execute(sql)
		addresses = cursor.fetchall()

		sql = f"SELECT * FROM addresses AS a LEFT JOIN customers AS c ON a.customer_id = c.customer_id WHERE a.customer_id = {session['uid']} LIMIT 1"
		cursor.execute(sql)
		first_address = cursor.fetchone()

		sql = f"SELECT * FROM payment_type WHERE customer_id = {session['uid']}"
		cursor.execute(sql)
		payment_options = cursor.fetchall()

	sql = f"SELECT image_name FROM product_images WHERE product_id = {request.args.get('id')}"
	cursor.execute(sql)
	images = cursor.fetchall()

	sql = f"select * from products as p left join product_category as pc on p.product_id = pc.product_id left join categories as c on pc.category_id = c.category_id where p.product_id = {request.args.get('id')} order by c.category_id asc"
	cursor.execute(sql)
	categories = cursor.fetchall()

	sql = f"select carrier.price from products left join carrier on products.carrier_id = carrier.carrier_id where product_id = {request.args.get('id')}"
	cursor.execute(sql)
	carrier_price = cursor.fetchone()
	
	cursor.close()
	print(payment_options)
	return render_template('product-page.html', carrier_price = carrier_price, categories = categories, product_details = product_details, images = images, addresses = addresses, first_address = first_address, payment_options = payment_options)

# REGISTER ACCOUNT #
@app.route("/register", methods=["POST", "GET"])
def signup():
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		user = request.form["user"]

		if "user" in request.form:
			form = request.form.to_dict()
			
			cursor = conn.cursor(cursor_factory=RealDictCursor)
			sql = f"SELECT username FROM customers WHERE username='{form['user']}'"
			cursor.execute(sql)
			exist_check_user = cursor.fetchone()

			sql = f"SELECT email_address FROM customers WHERE email_address='{form['email']}'"
			cursor.execute(sql)
			exist_check_email = cursor.fetchone()

			if exist_check_user is not None:
				return "<script>alert('Username already in use!'); window.location='/register';</script>"
			if exist_check_email is not None:
				return "<script>alert('E-Mail address already in use!'); window.location='/register';</script>"

			cursor = conn.cursor()
			data = (form["fn"], form["ln"], form["gender"], form["user"], form["pass"], form["email"], form["contact"], form["bday"])
			sql = "INSERT INTO customers (first_name, last_name, gender, username, password, email_address, contact, birthday) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
			cursor.execute(sql, data)
			conn.commit()
			cursor.close()
		return redirect(url_for("login", user=user))
	return render_template("register.html")

# LOGIN ACCOUNT #
@app.route("/login", methods=["POST", "GET"])
def login():
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		if "user" in request.form:
			cursor = conn.cursor(cursor_factory=RealDictCursor)
			sql = f"SELECT * FROM customers WHERE username = '{request.form['user']}'"
			cursor.execute(sql)
			user_details = cursor.fetchone()
			if user_details is None:
				return "<script>alert('Username/password is invalid!'); window.location = '/login';</script>"
			cursor.close()
			if request.form["pass"] == user_details["password"]:
				session["user"] = request.form["user"]
				session["uid"] = user_details['customer_id']
				session["fullname"] = f"{user_details['first_name']} {user_details['last_name']}"
				return redirect(url_for("index"))
			else:
				return "<script>alert('Username/password is invalid!'); window.location = '/login';</script>"
	if "user" not in session:
		return render_template("login.html", uname=request.args.get("user"))
	else:
		return redirect(url_for("index"))

# PROFILE #
@app.route("/user")
def user():
	if "user" not in session or "uid" not in session:
		return redirect(url_for("login"))

	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))

	if "user" in session:
		cursor = conn.cursor(cursor_factory=RealDictCursor)
		sql = f"SELECT * FROM customers WHERE username = '{session['user']}'"
		cursor.execute(sql)
		user_details = cursor.fetchone()
		#fetches default billing address
		sql = f"SELECT * FROM addresses AS a LEFT JOIN countries AS c ON a.country_code = c.country_code WHERE customer_id = {user_details['customer_id']}"
		cursor.execute(sql)
		addresses = cursor.fetchall()
		cursor.close()
		return render_template("profile.html", contact=user_details["contact"], ud = f"{user_details['first_name']} {user_details['last_name']}", addresses=addresses)
	else:
		return redirect(url_for("login"))

@app.route("/profile", methods=["POST", "GET"])
def profile():
	if "user" not in session or "uid" not in session:
		return redirect(url_for("login"))

	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		if "fn" in request.form:
			data = (request.form['fn'], request.form['ln'], request.form['bday'], request.form['contact'], request.form['gender'], session['user'])
			sql = "UPDATE customers SET first_name = %s, last_name = %s, birthday = %s, contact = %s, gender = %s WHERE username = %s"
			print(sql)
			cursor = conn.cursor()
			cursor.execute(sql, data)
			conn.commit()
			cursor.close()
			return "<script>alert('Information successfully updated!'); window.location = '/user';</script>"
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = f"SELECT * FROM customers WHERE username = '{session['user']}'"
	cursor.execute(sql)
	user_details = cursor.fetchone()
	fullname = f"{user_details['first_name']} {user_details['last_name']}"
	cursor.close()
	
	return render_template("edit-profile.html", user_details = user_details, ud = fullname)

@app.route("/address", methods=["POST", "GET"])
def address():
	if "user" not in session or "uid" not in session:
		return redirect(url_for("login"))
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		if "submit-type" not in request.form:
			data = (session['uid'], request.form['address1'], request.form['address2'], request.form['city'], request.form['postal'], request.form['country'])
			sql = "INSERT INTO addresses (customer_id, address1, address2, city, postal_code, country_code) VALUES (%s, %s, %s, %s, %s, %s)"
			cursor = conn.cursor()
			cursor.execute(sql, data)
			conn.commit()
			cursor.close()
		else:
			if request.form['submit-type'] == "delete":
				sql = "DELETE FROM addresses WHERE address_id = %s"
				data = (request.form['address_id'])
				cursor = conn.cursor()
				cursor.execute(sql, data)
				conn.commit()
				cursor.close()
			else:
				form = request.form
				sql = "UPDATE addresses SET address1=%s, address2=%s, country_code=%s, city=%s, postal_code=%s WHERE customer_id=%s AND address_id=%s"
				data = (form['address1'], form['address2'], form['country'], form['city'], form['postal'], session['uid'], form['address_id'])
				cursor = conn.cursor()
				cursor.execute(sql, data)
				conn.commit()
				cursor.close()
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = f"SELECT * FROM addresses as a LEFT JOIN countries as c ON a.country_code = c.country_code WHERE customer_id = {session['uid']}"
	cursor.execute(sql)
	addresses = cursor.fetchall()

	sql = "SELECT * FROM countries"
	cursor.execute(sql)
	countries = cursor.fetchall()
	cursor.close()
	return render_template("address.html", addresses = addresses, countries = countries)

@app.route("/payment-options", methods=["POST", "GET"])
def payment_options():
	if "user" not in session or "uid" not in session:
		return redirect(url_for("login"))
	payment_options = None
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		if "pt_id" in request.form:
			sql = f"DELETE FROM payment_type WHERE payment_id = {request.form['pt_id']}"
			cursor = conn.cursor()
			cursor.execute(sql)
			conn.commit()
			cursor.close()
			return "<script>alert('Payment method deleted.'); window.location = '/user';</script>"
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = f"SELECT * FROM payment_type AS pt LEFT JOIN currency AS c ON pt.currency_code = c.currency_code WHERE customer_id = {session['uid']}"
	cursor.execute(sql)
	payment_options = cursor.fetchall()
	cursor.close()
	return render_template("payment-options.html", payment_options = payment_options)


#SELECT * FROM orders AS o LEFT JOIN products AS p ON o.product_id = p.product_id LEFT JOIN carrier AS c ON p.carrier_id = c.carrier_id;
@app.route("/orders", methods=["POST", "GET"])
def orders():
	if "user" not in session or "uid" not in session:
		return redirect(url_for("login"))
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = ("SELECT *, p.price as pprice, c.price as cprice, p.name as pname FROM orders AS o LEFT JOIN products AS p ON o.product_id = p.product_id " +
			"LEFT JOIN addresses AS a ON o.address_id = a.address_id "+
			"LEFT JOIN carrier AS c ON p.carrier_id = c.carrier_id " +
			f"WHERE o.customer_id = {session['uid']} ORDER BY date_added DESC")
	cursor.execute(sql)
	orders = cursor.fetchall()
	cursor.close()
	return render_template("orders.html", orders=orders)

@app.route("/add-payment-option", methods=["POST","GET"])
def add_po():
	if "user" not in session or "uid" not in session:
		return redirect(url_for("login"))
	if request.method == "POST":
		if "search" in request.form:
			return redirect(url_for("search", key=request.form["search"]))
		else:
			form = request.form
			full_cc_num = f"{form['cc-num-1']} {form['cc-num-2']} {form['cc-num-3']} {form['cc-num-4']}"
			data = (form['po-type'], full_cc_num, form['currency_code'], session['uid'])
			sql = "INSERT INTO payment_type (payment_method, credit_card_number, currency_code, customer_id) VALUES (%s, %s, %s, %s)"
			cursor = conn.cursor()
			cursor.execute(sql, data)
			conn.commit()
			cursor.close()
			return "<script>alert('Successfully added payment method!'); window.location = '/payment-options';</script>"
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = "SELECT * FROM currency"
	cursor.execute(sql)
	currencies = cursor.fetchall()
	cursor.close()
	return render_template("add-payment-option-form.html", currencies = currencies)

# # BUY PRODUCT #
# @app.route("/buy-now", methods=["POST","GET"])
# def buy_now():
# 	if "user" not in session or "uid" not in session:
# 		return redirect(url_for("login"))
# 	if request.method == "POST":
# 		if "search" in request.form:
# 			return redirect(url_for("search", key=request.form["search"]))
# 	return render_template("buy-now.html")

@app.route("/cart", methods=["POST","GET"])
def cart():
	if "uid" not in session:
		return redirect(url_for('login'))
	if request.method == "POST":
		if "remove_ind" in request.form:
			sql = "DELETE FROM cart WHERE product_id = %s AND customer_id = %s"
			data = (request.form['remove_ind'], session['uid'])
			cursor = conn.cursor()
			cursor.execute(sql, data)
			conn.commit()
			cursor.close()
		elif "prod_index" in request.form:
			cursor = conn.cursor(cursor_factory = RealDictCursor)
			sql = ("SELECT *, p.name as pname, ca.name as cname, p.price as pprice, ca.price as cprice FROM cart AS c LEFT JOIN products AS p ON c.product_id = p.product_id "+
				"LEFT JOIN carrier AS ca ON p.carrier_id = ca.carrier_id"
				f" WHERE c.customer_id = {session['uid']}")
			cursor.execute(sql)
			cart_orders = cursor.fetchall()
			
			sql = f"SELECT address_id FROM customers AS c INNER JOIN addresses AS a ON c.customer_id = a.customer_id WHERE c.customer_id = {session['uid']}"
			cursor.execute(sql)
			address_id = cursor.fetchone()['address_id']

			sql = f"SELECT payment_id FROM customers AS c INNER JOIN payment_type AS pt ON c.customer_id = pt.customer_id WHERE c.customer_id = {session['uid']}"
			cursor.execute(sql)
			payment_id = cursor.fetchone()['payment_id']

			if address_id is None:
				return "<script>alert('You don't have a shipping address yet!');</script>"
			if payment_id is None:
				return "<script>alert('You don't have any payment options yet!')"

			now = datetime.now().timestamp()
			# Increments date by a week
			now += 604800
			deldate = datetime.utcfromtimestamp(now).strftime('%m-%d-%Y')

			for index in request.form.getlist('prod_index'):
				sql = ("INSERT INTO orders (customer_id, status, address_id, product_id, payment_id, delivery_date, quantity, date_added) "+
					   "VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())")
				data = (session['uid'], 'DELIVERING', address_id, cart_orders[int(index)]['product_id'], payment_id, deldate, cart_orders[int(index)]['quantity'])
				cursor.execute(sql, data)
				conn.commit()

				sql = "UPDATE products SET stock = stock - %s WHERE product_id = %s"
				data = (cart_orders[int(index)]['quantity'], cart_orders[int(index)]['product_id'])
				cursor.execute(sql, data)
				conn.commit()

				sql = f"DELETE FROM cart WHERE product_id = {cart_orders[int(index)]['product_id']} AND customer_id = {session['uid']}"
				cursor.execute(sql)
				conn.commit()
				
	cursor = conn.cursor(cursor_factory = RealDictCursor)
	sql = ("SELECT *, p.name as pname, ca.name as cname, p.price as pprice, ca.price as cprice FROM cart AS c LEFT JOIN products AS p ON c.product_id = p.product_id "+
		   "LEFT JOIN carrier AS ca ON p.carrier_id = ca.carrier_id"
		  f" WHERE c.customer_id = {session['uid']}")
	cursor.execute(sql)
	cart_orders = cursor.fetchall()

	sql = ("SELECT image_name FROM cart AS c LEFT JOIN products AS p ON c.product_id = p.product_id"+
		   " LEFT JOIN product_images AS pi ON p.product_id = pi.product_id"+
		   " LEFT JOIN carrier AS ca ON p.carrier_id = ca.carrier_id"
		  f" WHERE c.customer_id = {session['uid']}")
	cursor.execute(sql)
	product_images = cursor.fetchall()
	cursor.close()
	return render_template('cart.html', cart_orders = cart_orders, thumbs = product_images)

@app.route("/log-out")
def logout():
	session.clear()
	return "<script>alert('Successfully logged out.'); window.location='/login';</script>"

@app.route("/add-product", methods=["POST", "GET"])
def add_product():
	if request.method == "POST":
		cursor = conn.cursor(cursor_factory=RealDictCursor)
		sql = ("INSERT INTO products (name, description, price, sku, stock, brand, carrier_id, date_updated) VALUES " +
			   "(%s, %s, %s, %s, %s, %s, %s, NOW())")
		data = (request.form['product_name'], request.form['desc'], request.form['price'], request.form['sku'], request.form['stock'], request.form['brand'], request.form['carrier'])
		cursor.execute(sql, data)
		conn.commit()

		sql = "SELECT currval(pg_get_serial_sequence('products', 'product_id')) AS next_id"
		cursor.execute(sql)
		next_id = cursor.fetchone()['next_id']

		sql = "INSERT INTO product_category VALUES (%s, %s)"
		data = (request.form['category'], next_id)
		cursor.execute(sql, data)

		sql = "INSERT INTO product_category VALUES (%s, %s)"
		data = (request.form['subcategory'], next_id)
		cursor.execute(sql, data)
		if 'sscategory' in request.form:
			sql = "INSERT INTO product_category VALUES (%s, %s)"
			data = (request.form['sscategory'], next_id)
			cursor.execute(sql, data)
			conn.commit()

		files = request.files.getlist('thumbs')
		pool = ThreadPoolExecutor(max_workers=1)
		for file in files:
			if file:
				file_name = secure_filename(file.filename)
				sql = "INSERT INTO product_images (product_id, image_name) VALUES (%s, %s)"
				data = (next_id, f"uplimg/{file_name}")
				cursor.execute(sql, data)
				conn.commit()
				file.save(os.path.join(app.config['UPLOAD_FOLDER'], file_name))
		pool.shutdown(wait=True)
	if session['uid'] != 1:
		return redirect(url_for('index'))
	
	cursor = conn.cursor(cursor_factory=RealDictCursor)
	sql = "SELECT * FROM carrier"
	cursor.execute(sql)
	carriers = cursor.fetchall()
	return render_template('add-product.html', carriers=carriers)

app.run(debug=True)