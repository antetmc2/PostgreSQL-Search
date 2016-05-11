CREATE TABLE public."SeriesMovies"
(
  id integer NOT NULL DEFAULT nextval('"Series_id_seq"'::regclass),
  title character varying(500) NOT NULL,
  titletsv tsvector,
  CONSTRAINT "Series_pkey" PRIMARY KEY (id),
  CONSTRAINT "Series_ukey" UNIQUE (title)
);

CREATE TABLE public."Queries"
(
  id integer NOT NULL DEFAULT nextval('"Queries_id_seq"'::regclass),
  query character varying(500) NOT NULL,
  "timestamp" timestamp without time zone NOT NULL,
  CONSTRAINT "Queries_pkey" PRIMARY KEY (id)
)

CREATE INDEX titletsvind
  ON public."SeriesMovies"
  USING gin
  (titletsv);
  
CREATE TRIGGER seriesmovies_insupd_trigg
  BEFORE INSERT OR UPDATE
  ON public."SeriesMovies"
  FOR EACH ROW
  EXECUTE PROCEDURE tsvector_update_trigger('titletsv', 'pg_catalog.english', 'title');

SELECT *
FROM crosstab('SELECT CAST(query AS character varying(500)) AS query,
	    CAST(to_date(to_char("timestamp", ''YYYY-mm-dd''), ''YYYY-mm-dd'') AS date) AS chosenDate,
        CAST(COUNT(*) AS integer) AS brUpita
        FROM public."Queries"
        WHERE "timestamp" BETWEEN ''2015-10-25 0:00:00''
        AND ''2015-10-28 23:59:59''
	    GROUP BY query, chosenDate
        ORDER BY query, chosenDate',
	'SELECT DateInt FROM dates ORDER BY DateInt')
AS pivotTable(query character varying(500), d25102015 integer, d26102015 integer, d27102015 integer, d28102015 integer);

SELECT *
FROM crosstab('SELECT CAST(query AS character varying(500)) AS query,
	    CAST(EXTRACT(hour FROM "timestamp") AS integer) AS hour,
        CAST(COUNT(*) AS integer) AS brUpita
        FROM public."Queries"
        WHERE "timestamp" BETWEEN ''2015-10-25 0:00:00''
        AND ''2015-10-28 23:59:59''
        GROUP BY query, hour
        ORDER BY query, hour',
    'SELECT brHour FROM hour ORDER BY brHour')
AS pivotTable(query character varying(500), h_00_01 integer, h_01_02 integer, h_02_03 integer, h_03_04 integer, h_04_05 integer, h_05_06 integer, h_06_07 integer, h_07_08 integer, h_08_09 integer, h_09_10 integer, h_10_11 integer, h_11_12 integer, h_12_13 integer, h_13_14 integer, h_14_15 integer, h_15_16 integer, h_16_17 integer, h_17_18 integer, h_18_19 integer, h_19_20 integer, h_20_21 integer, h_21_22 integer, h_22_23 integer, h_23_24 integer)
ORDER BY query; --ukloniti

SELECT title, ts_headline(title, to_tsquery('(Black) | big | bang | box')),
		ts_rank(to_tsvector(title), to_tsquery('(Black) | big | bang | box')) rank 
	FROM public."SeriesMovies" 
	WHERE LOWER(title) LIKE LOWER('%Black%')
	OR LOWER(title) LIKE LOWER('%big%')
	OR LOWER(title) LIKE LOWER('%bang%')
	OR LOWER(title) LIKE LOWER('%box%')
	ORDER BY rank DESC;
	
SELECT title, ts_headline(title, to_tsquery('(The & Big & Bang & Theory)')),
		ts_rank(to_tsvector(title), to_tsquery('(The & Big & Bang & Theory)')) rank 
	FROM public."SeriesMovies" 
	WHERE titletsv @@ to_tsquery('english',LOWER('The & Big & Bang & Theory'))
	ORDER BY rank DESC;
	
SELECT title, ts_headline(title, to_tsquery('black')),
		ts_rank(to_tsvector(title), to_tsquery('black')) rank 
	FROM public."SeriesMovies" 
	WHERE LOWER(title) % LOWER('black')
	ORDER BY rank DESC;
	
ALTER TABLE public."SeriesMovies" ADD COLUMN id BIGSERIAL PRIMARY KEY;
ALTER TABLE public."Queries" ADD COLUMN id BIGSERIAL PRIMARY KEY;