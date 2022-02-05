--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.addresses (
    postal_code character varying(50),
    customer_id integer,
    city character varying(255),
    address_id integer NOT NULL,
    address2 character varying(255),
    address1 character varying(255),
    country_code character varying(50)
);


ALTER TABLE public.addresses OWNER TO brian;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.addresses_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_address_id_seq OWNER TO brian;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;


--
-- Name: carrier; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.carrier (
    carrier_id integer NOT NULL,
    name character varying(255),
    price numeric(13,6),
    logo character varying(255)
);


ALTER TABLE public.carrier OWNER TO brian;

--
-- Name: carrier_carrier_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.carrier_carrier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carrier_carrier_id_seq OWNER TO brian;

--
-- Name: carrier_carrier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.carrier_carrier_id_seq OWNED BY public.carrier.carrier_id;


--
-- Name: cart; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.cart (
    customer_id integer,
    product_id integer,
    quantity integer
);


ALTER TABLE public.cart OWNER TO brian;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(50)
);


ALTER TABLE public.categories OWNER TO brian;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_category_id_seq OWNER TO brian;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.countries (
    country_code character varying(50) NOT NULL,
    name character varying(255)
);


ALTER TABLE public.countries OWNER TO brian;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.currency (
    currency_code character varying(50) NOT NULL,
    name character varying(50)
);


ALTER TABLE public.currency OWNER TO brian;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    gender smallint,
    birthday date,
    email_address character varying(255),
    username character varying(255),
    password character varying(255),
    contact character varying(50)
);


ALTER TABLE public.customers OWNER TO brian;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customer_id_seq OWNER TO brian;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer,
    status character varying(10),
    address_id integer,
    product_id integer,
    payment_id integer,
    delivery_date date,
    quantity integer,
    date_added timestamp without time zone
);


ALTER TABLE public.orders OWNER TO brian;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO brian;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: payment_type; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.payment_type (
    payment_id integer NOT NULL,
    payment_method character varying(50),
    credit_card_number character varying(50),
    currency_code character varying(50),
    customer_id integer
);


ALTER TABLE public.payment_type OWNER TO brian;

--
-- Name: payment_type_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.payment_type_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_type_payment_id_seq OWNER TO brian;

--
-- Name: payment_type_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.payment_type_payment_id_seq OWNED BY public.payment_type.payment_id;


--
-- Name: product_category; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.product_category (
    category_id integer,
    product_id integer
);


ALTER TABLE public.product_category OWNER TO brian;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.product_images (
    product_id integer,
    image_name character varying(255)
);


ALTER TABLE public.product_images OWNER TO brian;

--
-- Name: products; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    name character varying(255),
    description text,
    price numeric(13,6),
    sku character varying(50),
    stock integer,
    brand character varying(50),
    carrier_id integer,
    date_updated timestamp without time zone
);


ALTER TABLE public.products OWNER TO brian;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: brian
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_product_id_seq OWNER TO brian;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: brian
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: sellers; Type: TABLE; Schema: public; Owner: brian
--

CREATE TABLE public.sellers (
    customer_id integer
);


ALTER TABLE public.sellers OWNER TO brian;

--
-- Name: addresses address_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);


--
-- Name: carrier carrier_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.carrier ALTER COLUMN carrier_id SET DEFAULT nextval('public.carrier_carrier_id_seq'::regclass);


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: payment_type payment_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.payment_type ALTER COLUMN payment_id SET DEFAULT nextval('public.payment_type_payment_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.addresses (postal_code, customer_id, city, address_id, address2, address1, country_code) FROM stdin;
123123	1	dsafdsfas	6	dsfasfadsg	134152532	AT
6969	12	Quezon	7	Aurora Blvd.	TIP	PH
4290	12	asdfas	8	asdfaf	dfsafd	PH
\.


--
-- Data for Name: carrier; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.carrier (carrier_id, name, price, logo) FROM stdin;
1	Air 21	50.000000	img/air21.jpg
2	LBC	70.500000	\N
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.cart (customer_id, product_id, quantity) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.categories (category_id, category_name) FROM stdin;
1	earphones
2	headphones
3	mouse
4	mousepad
5	keyboard
6	wired
7	wireless
8	true_wireless
9	regular
10	extended
11	membrane
12	mechanical
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.countries (country_code, name) FROM stdin;
AF	Afghanistan
AX	Ã…land Islands
AL	Albania
DZ	Algeria
AS	American Samoa
AD	Andorra
AO	Angola
AI	Anguilla
AQ	Antarctica
AG	Antigua and Barbuda
AR	Argentina
AM	Armenia
AW	Aruba
AU	Australia
AT	Austria
AZ	Azerbaijan
BS	Bahamas
BH	Bahrain
BD	Bangladesh
BB	Barbados
BY	Belarus
BE	Belgium
BZ	Belize
BJ	Benin
BM	Bermuda
BT	Bhutan
BO	Bolivia, Plurinational State of
BQ	Bonaire, Sint Eustatius and Saba
BA	Bosnia and Herzegovina
BW	Botswana
BV	Bouvet Island
BR	Brazil
IO	British Indian Ocean Territory
BN	Brunei Darussalam
BG	Bulgaria
BF	Burkina Faso
BI	Burundi
KH	Cambodia
CM	Cameroon
CA	Canada
CV	Cape Verde
KY	Cayman Islands
CF	Central African Republic
TD	Chad
CL	Chile
CN	China
CX	Christmas Island
CC	Cocos (Keeling), Islands
CO	Colombia
KM	Comoros
CG	Congo
CD	Congo, the Democratic Republic of the
CK	Cook Islands
CR	Costa Rica
CI	CÃ´te d'Ivoire
HR	Croatia
CU	Cuba
CW	CuraÃ§ao
CY	Cyprus
CZ	Czech Republic
DK	Denmark
DJ	Djibouti
DM	Dominica
DO	Dominican Republic
EC	Ecuador
EG	Egypt
SV	El Salvador
GQ	Equatorial Guinea
ER	Eritrea
EE	Estonia
ET	Ethiopia
FK	Falkland Islands (Malvinas)
FO	Faroe Islands
FJ	Fiji
FI	Finland
FR	France
GF	French Guiana
PF	French Polynesia
TF	French Southern Territories
GA	Gabon
GM	Gambia
GE	Georgia
DE	Germany
GH	Ghana
GI	Gibraltar
GR	Greece
GL	Greenland
GD	Grenada
GP	Guadeloupe
GU	Guam
GT	Guatemala
GG	Guernsey
GN	Guinea
GW	Guinea-Bissau
GY	Guyana
HT	Haiti
HM	Heard Island and McDonald Islands
VA	Holy See (Vatican City State)
HN	Honduras
HK	Hong Kong
HU	Hungary
IS	Iceland
IN	India
ID	Indonesia
IR	Iran, Islamic Republic of
IQ	Iraq
IE	Ireland
IM	Isle of Man
IL	Israel
IT	Italy
JM	Jamaica
JP	Japan
JE	Jersey
JO	Jordan
KZ	Kazakhstan
KE	Kenya
KI	Kiribati
KP	Korea, Democratic People's Republic of
KR	Korea, Republic of
KW	Kuwait
KG	Kyrgyzstan
LA	Lao People's Democratic Republic
LV	Latvia
LB	Lebanon
LS	Lesotho
LR	Liberia
LY	Libya
LI	Liechtenstein
LT	Lithuania
LU	Luxembourg
MO	Macao
MK	Macedonia, the former Yugoslav Republic of
MG	Madagascar
MW	Malawi
MY	Malaysia
MV	Maldives
ML	Mali
MT	Malta
MH	Marshall Islands
MQ	Martinique
MR	Mauritania
MU	Mauritius
YT	Mayotte
MX	Mexico
FM	Micronesia, Federated States of
MD	Moldova, Republic of
MC	Monaco
MN	Mongolia
ME	Montenegro
MS	Montserrat
MA	Morocco
MZ	Mozambique
MM	Myanmar
NA	Namibia
NR	Nauru
NP	Nepal
NL	Netherlands
NC	New Caledonia
NZ	New Zealand
NI	Nicaragua
NE	Niger
NG	Nigeria
NU	Niue
NF	Norfolk Island
MP	Northern Mariana Islands
NO	Norway
OM	Oman
PK	Pakistan
PW	Palau
PS	Palestinian Territory, Occupied
PA	Panama
PG	Papua New Guinea
PY	Paraguay
PE	Peru
PH	Philippines
PN	Pitcairn
PL	Poland
PT	Portugal
PR	Puerto Rico
QA	Qatar
RE	RÃ©union
RO	Romania
RU	Russian Federation
RW	Rwanda
BL	Saint BarthÃ©lemy
SH	Saint Helena, Ascension and Tristan da Cunha
KN	Saint Kitts and Nevis
LC	Saint Lucia
MF	Saint Martin (French part)
PM	Saint Pierre and Miquelon
VC	Saint Vincent and the Grenadines
WS	Samoa
SM	San Marino
ST	Sao Tome and Principe
SA	Saudi Arabia
SN	Senegal
RS	Serbia
SC	Seychelles
SL	Sierra Leone
SG	Singapore
SX	Sint Maarten (Dutch part)
SK	Slovakia
SI	Slovenia
SB	Solomon Islands
SO	Somalia
ZA	South Africa
GS	South Georgia and the South Sandwich Islands
SS	South Sudan
ES	Spain
LK	Sri Lanka
SD	Sudan
SR	Suriname
SJ	Svalbard and Jan Mayen
SZ	Swaziland
SE	Sweden
CH	Switzerland
SY	Syrian Arab Republic
TW	Taiwan, Province of China
TJ	Tajikistan
TZ	Tanzania, United Republic of
TH	Thailand
TL	Timor-Leste
TG	Togo
TK	Tokelau
TO	Tonga
TT	Trinidad and Tobago
TN	Tunisia
TR	Turkey
TM	Turkmenistan
TC	Turks and Caicos Islands
TV	Tuvalu
UG	Uganda
UA	Ukraine
AE	United Arab Emirates
GB	United Kingdom
US	United States
UM	United States Minor Outlying Islands
UY	Uruguay
UZ	Uzbekistan
VU	Vanuatu
VE	Venezuela, Bolivarian Republic of
VN	Viet Nam
VG	Virgin Islands, British
VI	Virgin Islands, U.S.
WF	Wallis and Futuna
EH	Western Sahara
YE	Yemen
ZM	Zambia
ZW	Zimbabwe
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.currency (currency_code, name) FROM stdin;
USD	United States Dollars
EUR	Euro
GBP	United Kingdom Pounds
LBP	Lebanon Pounds
LUF	Luxembourg Francs
MYR	Malaysia Ringgit
MXP	Mexico Pesos
NLG	Netherlands Guilders
NZD	New Zealand Dollars
NOK	Norway Kroner
PKR	Pakistan Rupees
XPD	Palladium Ounces
PHP	Philippines Pesos
XPT	Platinum Ounces
PLZ	Poland Zloty
PTE	Portugal Escudo
ROL	Romania Leu
RUR	Russia Rubles
SAR	Saudi Arabia Riyal
XAG	Silver Ounces
SGD	Singapore Dollars
SKK	Slovakia Koruna
ZAR	South Africa Rand
KRW	South Korea Won
ESP	Spain Pesetas
XDR	Special Drawing Right (IMF)
SDD	Sudan Dinar
SEK	Sweden Krona
CHF	Switzerland Francs
TWD	Taiwan Dollars
THB	Thailand Baht
TTD	Trinidad and Tobago Dollars
TRL	Turkey Lira
VEB	Venezuela Bolivar
ZMK	Zambia Kwacha
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.customers (customer_id, first_name, last_name, gender, birthday, email_address, username, password, contact) FROM stdin;
1	admin	admin	0	2020-03-28	admin@tip.edu.ph	admin	pass123	0969 696 6969
10	Brian	Valencia	0	2020-03-06	dskflafdskafjdsk@tip.edu.ph	user	pass	123213214
11	zaira	ganda	1	2020-03-03	zairaganda@gmail.com	gandako	mamamo	666666666666
12	Brian	Valencia	0	2020-03-06	dsjafldsjfkf@mail.mailmail.com	user123	pass123	54943864396830
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.orders (order_id, customer_id, status, address_id, product_id, payment_id, delivery_date, quantity, date_added) FROM stdin;
33	12	DELIVERING	7	35	13	2020-03-13	5	\N
34	12	DELIVERING	7	33	13	2020-03-13	10	2020-03-06 14:31:05.984777
35	12	DELIVERING	7	34	13	2020-03-13	15	2020-03-06 14:31:50.78981
36	12	DELIVERING	7	36	13	2020-03-13	10	\N
37	12	DELIVERING	8	35	13	2020-03-13	4	\N
\.


--
-- Data for Name: payment_type; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.payment_type (payment_id, payment_method, credit_card_number, currency_code, customer_id) FROM stdin;
11	paypal	1231 2415 3425 4421	PTE	1
13	paypal	5423 9014 3019 4720	USD	12
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.product_category (category_id, product_id) FROM stdin;
2	33
7	33
2	34
6	34
3	35
6	35
1	36
7	36
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.product_images (product_id, image_name) FROM stdin;
33	uplimg/download_6.jpg
33	uplimg/download_7.jpg
35	uplimg/download.jpg
35	uplimg/download.png
36	uplimg/download_4.jpg
36	uplimg/download_5.jpg
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.products (product_id, name, description, price, sku, stock, brand, carrier_id, date_updated) FROM stdin;
33	AKG Wireless Earphones	earphones na wireless at gawa ng AKG	690.500000	AKGWHP-100432	50	AKG	2	2020-03-06 10:18:22.036798
34	JBL Headset	headphones na wired at gawa ng JBL maganda naman	950.500000	JBLFDJSF	75	JBL	1	2020-03-06 10:24:39.573523
36	Earphones na wireless	wireless earphones	6596.500000	FKDSOAFJDSKA-439204	0	Apple	2	2020-03-06 14:34:07.156026
35	Razer DeathAdder	mouse na wired\r\n\r\npwede na	1000.000000	RZR-PH	191	Razer	2	2020-03-06 14:35:10.966819
\.


--
-- Data for Name: sellers; Type: TABLE DATA; Schema: public; Owner: brian
--

COPY public.sellers (customer_id) FROM stdin;
\.


--
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 8, true);


--
-- Name: carrier_carrier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.carrier_carrier_id_seq', 2, true);


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 12, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 12, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 37, true);


--
-- Name: payment_type_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.payment_type_payment_id_seq', 13, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: brian
--

SELECT pg_catalog.setval('public.products_product_id_seq', 36, true);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);


--
-- Name: carrier carrier_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.carrier
    ADD CONSTRAINT carrier_pkey PRIMARY KEY (carrier_id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_code);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (currency_code);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: payment_type payment_type_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.payment_type
    ADD CONSTRAINT payment_type_pkey PRIMARY KEY (payment_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: customers user_email_uniq; Type: CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT user_email_uniq UNIQUE (username, email_address);


--
-- Name: cart cart_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: cart cart_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: product_category categories_fk_category_id; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT categories_fk_category_id FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: addresses country_code; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT country_code FOREIGN KEY (country_code) REFERENCES public.countries(country_code);


--
-- Name: addresses customer_id; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: orders orders_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(address_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: orders orders_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payment_type(payment_id);


--
-- Name: orders orders_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: payment_type payment_type_currency_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.payment_type
    ADD CONSTRAINT payment_type_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES public.currency(currency_code);


--
-- Name: payment_type payment_type_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.payment_type
    ADD CONSTRAINT payment_type_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: product_images product_images_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: products products_carrier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_carrier_id_fkey FOREIGN KEY (carrier_id) REFERENCES public.carrier(carrier_id);


--
-- Name: product_category products_fk_product_id; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT products_fk_product_id FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: sellers sellers_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: brian
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO brian;


--
-- PostgreSQL database dump complete
--

