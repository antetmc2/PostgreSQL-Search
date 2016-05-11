--
-- PostgreSQL database cluster dump
--

-- Started on 2015-10-28 17:16:04

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md5e5b63e560a8e6302d8d5f658134cf0a4';






--
-- Database creation
--

CREATE DATABASE "Projekt" WITH TEMPLATE = template0 OWNER = postgres;
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM postgres;
GRANT ALL ON DATABASE template1 TO postgres;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect "Projekt"

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta1
-- Dumped by pg_dump version 9.5beta1

-- Started on 2015-10-28 17:16:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 259 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2261 (class 0 OID 0)
-- Dependencies: 259
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 262 (class 3079 OID 16524)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 2262 (class 0 OID 0)
-- Dependencies: 262
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- TOC entry 261 (class 3079 OID 16535)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 2263 (class 0 OID 0)
-- Dependencies: 261
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 260 (class 3079 OID 16586)
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- TOC entry 2264 (class 0 OID 0)
-- Dependencies: 260
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 257 (class 1259 OID 16607)
-- Name: Queries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "Queries" (
    id integer NOT NULL,
    query character varying(500) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE "Queries" OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 16610)
-- Name: Queries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Queries_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Queries_id_seq" OWNER TO postgres;

--
-- TOC entry 2265 (class 0 OID 0)
-- Dependencies: 258
-- Name: Queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Queries_id_seq" OWNED BY "Queries".id;


--
-- TOC entry 252 (class 1259 OID 16500)
-- Name: SeriesMovies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "SeriesMovies" (
    id integer NOT NULL,
    title character varying(500) NOT NULL,
    titletsv tsvector
);


ALTER TABLE "SeriesMovies" OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16503)
-- Name: Series_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "Series_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Series_id_seq" OWNER TO postgres;

--
-- TOC entry 2266 (class 0 OID 0)
-- Dependencies: 253
-- Name: Series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "Series_id_seq" OWNED BY "SeriesMovies".id;


--
-- TOC entry 2127 (class 2604 OID 16619)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Queries" ALTER COLUMN id SET DEFAULT nextval('"Queries_id_seq"'::regclass);


--
-- TOC entry 2126 (class 2604 OID 16515)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SeriesMovies" ALTER COLUMN id SET DEFAULT nextval('"Series_id_seq"'::regclass);


--
-- TOC entry 2252 (class 0 OID 16607)
-- Dependencies: 257
-- Data for Name: Queries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "Queries" (id, query, "timestamp") FROM stdin;
1	'orphan' & 'black'	2015-10-25 20:26:43
2	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-25 20:55:42
3	'Black'	2015-10-25 20:56:04
4	'Black'	2015-10-25 21:06:36
5	'Black'	2015-10-25 21:45:52
6	'Theory' | 'Black'	2015-10-26 00:39:48
7	'Black'	2015-10-26 00:40:05
8	'Black'	2015-10-26 02:30:17
9	'orphan' & 'black'	2015-10-26 02:39:02
10	'orphan' & 'black'	2015-10-26 02:39:34
11	'big' | 'black'	2015-10-26 03:31:02
12	'big' | 'black'	2015-10-26 03:32:07
13	'big' | 'black'	2015-10-26 03:32:46
14	'list'	2015-10-26 03:33:00
15	'Game'	2015-10-26 03:35:11
16	'Game'	2015-10-26 03:36:00
17	'Game'	2015-10-26 03:36:04
18	'Game'	2015-10-26 03:36:07
19	'Catch'	2015-10-26 03:48:50
20	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-26 19:14:47
21	'The' | 'Big' | 'Bang' | 'Theory'	2015-10-26 19:14:51
22	'Black'	2015-10-27 00:30:33
23	'Black'	2015-10-27 21:36:33
24	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-27 22:05:56
25	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-27 22:06:06
26	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-27 22:06:10
27	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-27 22:06:14
28	'Big' & 'Bang' & 'Theory'	2015-10-27 22:06:17
29	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-27 22:06:29
30	'The' & 'Big' & 'Bang' & 'Theory'	2015-10-27 22:07:23
31	'The Big Bang Theory'	2015-10-27 22:07:42
32	'The Big Bang Theory'	2015-10-27 22:07:47
33	'The Big Bang Theory' & 'big'	2015-10-27 22:08:57
34	'Orphan Black'	2015-10-27 22:10:01
35	'Orphan Black'	2015-10-27 22:10:03
36	'Orphan Black'	2015-10-27 22:12:35
37	'orphan' & 'black'	2015-10-27 22:14:03
38	'Orphan Black'	2015-10-27 22:14:31
39	'Orphan Black'	2015-10-27 22:23:25
40	'Orphan Black'	2015-10-27 22:23:40
41	'Orphan Black' & 'black'	2015-10-27 22:23:55
42	'Orphan Black' & 'black' & 'big'	2015-10-27 22:23:58
43	'Orphan Black' | 'black' | 'big'	2015-10-27 22:24:02
44	'Orphan Black' | 'big'	2015-10-27 22:24:04
45	'Orphan Black' | 'big' | 'bang'	2015-10-27 22:24:10
46	'Orphan Black' | 'big' | 'bang' | 'box'	2015-10-27 22:24:17
47	'Orphan Black'	2015-10-27 22:25:49
48	'Orphan Black'	2015-10-27 22:34:15
49	'The Big Bang Theory'	2015-10-27 22:34:52
50	'The Big Bang Theory'	2015-10-27 22:45:10
51	'The Big Bang Theory' & 'black' & 'box'	2015-10-27 22:45:19
52	'The Big Bang Theory' | 'black' | 'box'	2015-10-27 22:45:23
53	'The Big Bang Theory' | 'black' | 'box'	2015-10-27 22:45:32
54	'The Big Bang Theory' | 'black' | 'box'	2015-10-27 22:45:38
55	'Orphan Black'	2015-10-27 22:46:05
56	'Orphan Black'	2015-10-27 22:46:10
57	'every'	2015-10-27 22:46:20
58	'every'	2015-10-27 22:46:22
59	'every'	2015-10-27 22:46:25
60	'big' | 'bang'	2015-10-28 08:55:30
61	'big' | 'bang'	2015-10-28 08:55:37
62	'black'	2015-10-28 08:55:41
63	'Black' | 'big' | 'bang' | 'box'	2015-10-28 09:30:45
64	'The Big Bang Theory'	2015-10-28 09:31:05
65	'black'	2015-10-28 09:31:18
66	'Black'	2015-10-28 09:31:30
\.


--
-- TOC entry 2267 (class 0 OID 0)
-- Dependencies: 258
-- Name: Queries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Queries_id_seq"', 66, true);


--
-- TOC entry 2250 (class 0 OID 16500)
-- Dependencies: 252
-- Data for Name: SeriesMovies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "SeriesMovies" (id, title, titletsv) FROM stdin;
1	The Big Bang Theory	'bang':3 'big':2 'theori':4
91	The Theory Of Everything	'everyth':4 'theori':2
92	Django Unchained	'django':1 'unchain':2
93	Edge Of Tomorrow	'edg':1 'tomorrow':3
94	In Time	'time':2
95	Inception	'incept':1
7	The Walking Dead	'dead':3 'walk':2
96	Straight Outta Compton	'compton':3 'outta':2 'straight':1
9	Modern Family	'famili':2 'modern':1
97	The Wolf Of Wall Street	'street':5 'wall':4 'wolf':2
10	Orphan Black	'black':2 'orphan':1
11	The Blacklist	'blacklist':2
12	Black-Ish	'black':2 'black-ish':1 'ish':3
13	The Middle	'middl':2
14	The Wire	'wire':2
98	We're The Millers	'miller':4 're':2
16	Once Upon A Time	'time':4 'upon':2
17	Fresh Off The Boat	'boat':4 'fresh':1
5	Game Of Thrones	'game':1 'throne':3
18	Black Box	'black':1 'box':2
19	Agent Carter	'agent':1 'carter':2
20	How I Met Your Mother	'met':3 'mother':5
21	How To Get Away With Murder	'away':4 'get':3 'murder':6
22	Two Broke Girls	'broke':2 'girl':3 'two':1
23	Prison Break	'break':2 'prison':1
24	Sleepy Hollow	'hollow':2 'sleepi':1
25	Mom	'mom':1
26	The Good Wife	'good':2 'wife':3
27	The Odd Couple	'coupl':3 'odd':2
28	Game Of Silence	'game':1 'silenc':3
29	Chicago Fire	'chicago':1 'fire':2
30	Hannibal	'hannib':1
31	American Horror Story	'american':1 'horror':2 'stori':3
32	True Detective	'detect':2 'true':1
33	My Name Is Earl	'earl':4 'name':2
34	Full House	'full':1 'hous':2
35	Dancing With The Stars	'danc':1 'star':4
36	Dance Moms	'danc':1 'mom':2
37	Days Of Our Lives	'day':1 'live':4
38	Life As We Know It	'know':4 'life':1
39	Living With Fran	'fran':3 'live':1
40	Lost	'lost':1
41	Married With Children	'children':3 'marri':1
42	Malcolm In The Middle	'malcolm':1 'middl':4
43	Mike And Molly	'mike':1 'molli':3
44	The Nanny	'nanni':2
45	Nurse Jackie	'jacki':2 'nurs':1
46	Nurses	'nurs':1
47	Parenthood	'parenthood':1
48	Secrets And Lies	'lie':3 'secret':1
49	Arrow	'arrow':1
50	The Flash	'flash':2
51	Law & Order: Special Victims Unit	'law':1 'order':2 'special':3 'unit':5 'victim':4
52	Chicago PD	'chicago':1 'pd':2
53	Chicago Med	'chicago':1 'med':2
54	You The Jury	'juri':3
55	Saturday Night Live	'live':3 'night':2 'saturday':1
56	Empire	'empir':1
57	So You Think You Can Dance	'danc':6 'think':3
58	Brooklyn Nine-Nine	'brooklyn':1 'nine':3,4 'nine-nin':2
59	The Last Man On Earth	'earth':5 'last':2 'man':3
60	The X Files	'file':3 'x':2
61	Code Black	'black':2 'code':1
62	Person Of Interest	'interest':3 'person':1
63	The Amazing Race	'amaz':2 'race':3
64	The Young and the Restless	'restless':5 'young':2
65	The Bold and the Beautiful	'beauti':5 'bold':2
66	Damage Control	'control':2 'damag':1
67	Damages	'damag':1
68	The Returned	'return':2
69	The Forgotten	'forgotten':2
70	Do Not Forget The Lyrics	'forget':3 'lyric':5
71	Drop Dead Diva	'dead':2 'diva':3 'drop':1
72	Million Dollar Money Drop	'dollar':2 'drop':4 'million':1 'money':3
73	Mission: Hill	'hill':2 'mission':1
74	Mission: Impossible	'imposs':2 'mission':1
75	Missing	'miss':1
76	Mr. Robot	'mr':1 'robot':2
77	Monster Squad	'monster':1 'squad':2
78	Monsters	'monster':1
79	The New Adventures of Old Christine	'adventur':3 'christin':6 'new':2 'old':5
80	New Girl	'girl':2 'new':1
81	No Ordinary Family	'famili':3 'ordinari':2
82	The Office	'offic':2
83	Off The Map	'map':3
84	The Love Boat	'boat':3 'love':2
85	Love Story	'love':1 'stori':2
86	I Love Lucy	'love':2 'luci':3
87	The Lucy Show	'luci':2 'show':3
88	Madam Secretary	'madam':1 'secretari':2
89	Mad About You	'mad':1
90	Grey's Anatomy	'anatomi':3 'grey':1
99	The Millers	'miller':2
100	The Imitation Game	'game':3 'imit':2
101	The Impossible	'imposs':2
102	Limitless	'limitless':1
103	The Hunger Games	'game':3 'hunger':2
104	The Catch	'catch':2
105	The Avengers	'aveng':2
116	Supergirl	'supergirl':1
119	Mr. Bean	'bean':2 'mr':1
\.


--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 253
-- Name: Series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"Series_id_seq"', 119, true);


--
-- TOC entry 2134 (class 2606 OID 16621)
-- Name: Queries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "Queries"
    ADD CONSTRAINT "Queries_pkey" PRIMARY KEY (id);


--
-- TOC entry 2129 (class 2606 OID 16517)
-- Name: Series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SeriesMovies"
    ADD CONSTRAINT "Series_pkey" PRIMARY KEY (id);


--
-- TOC entry 2131 (class 2606 OID 16523)
-- Name: Series_ukey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "SeriesMovies"
    ADD CONSTRAINT "Series_ukey" UNIQUE (title);


--
-- TOC entry 2132 (class 1259 OID 17234)
-- Name: titletsvind; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX titletsvind ON "SeriesMovies" USING gin (titletsv);


--
-- TOC entry 2135 (class 2620 OID 17232)
-- Name: seriesmovies_insupd_trigg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER seriesmovies_insupd_trigg BEFORE INSERT OR UPDATE ON "SeriesMovies" FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('titletsv', 'pg_catalog.english', 'title');


--
-- TOC entry 2260 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-10-28 17:16:05

--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta1
-- Dumped by pg_dump version 9.5beta1

-- Started on 2015-10-28 17:16:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2095 (class 1262 OID 12373)
-- Dependencies: 2094
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 181 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2098 (class 0 OID 0)
-- Dependencies: 181
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 180 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2099 (class 0 OID 0)
-- Dependencies: 180
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-10-28 17:16:06

--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta1
-- Dumped by pg_dump version 9.5beta1

-- Started on 2015-10-28 17:16:06

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2094 (class 1262 OID 1)
-- Dependencies: 2093
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- TOC entry 180 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2097 (class 0 OID 0)
-- Dependencies: 180
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 2096 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-10-28 17:16:08

--
-- PostgreSQL database dump complete
--

-- Completed on 2015-10-28 17:16:08

--
-- PostgreSQL database cluster dump complete
--

