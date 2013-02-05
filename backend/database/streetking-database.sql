--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- Name: pg_freespacemap; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_freespacemap WITH SCHEMA public;


--
-- Name: EXTENSION pg_freespacemap; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_freespacemap IS 'examine the free space map (FSM)';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: tsearch2; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS tsearch2 WITH SCHEMA public;


--
-- Name: EXTENSION tsearch2; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tsearch2 IS 'compatibility package for pre-8.3 text search functions';


--
-- Name: xml2; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS xml2 WITH SCHEMA public;


--
-- Name: EXTENSION xml2; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION xml2 IS 'XPath querying and XSLT';


SET search_path = public, pg_catalog;

--
-- Name: car_properties; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE car_properties AS (
	top_speed double precision,
	acceleration double precision,
	handling double precision,
	braking double precision,
	nos double precision,
	power double precision,
	traction double precision,
	stopping double precision,
	cornering double precision,
	aero double precision,
	nitrous double precision
);


ALTER TYPE public.car_properties OWNER TO postgres;

--
-- Name: part_properties; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE part_properties AS (
	power double precision,
	power_m double precision,
	traction double precision,
	traction_m double precision,
	braking double precision,
	braking_m double precision,
	handling double precision,
	handling_m double precision,
	aero double precision,
	aero_m double precision,
	nos double precision,
	nos_m double precision
);


ALTER TYPE public.part_properties OWNER TO postgres;

--
-- Name: task_trigger_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE task_trigger_type AS ENUM (
    'user',
    'car',
    'track'
);


ALTER TYPE public.task_trigger_type OWNER TO postgres;

--
-- Name: account_update_energy(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION account_update_energy(account_id bigint) RETURNS boolean
    LANGUAGE plpgsql STRICT SECURITY DEFINER COST 10
    AS $_$DECLARE 
account_id ALIAS FOR $1;
account_full account; 
ret account_current_energy;

energy_progress INTEGER;
updated_energy INTEGER;
newtime INTEGER;
deltatime INTEGER;
til INTEGER;
BEGIN

SELECT * INTO STRICT account_full FROM account WHERE id = account_id LIMIT 1;
IF NOT FOUND THEN 
	RAISE EXCEPTION 'account does not exist';
END IF;



-- Constant
-- energy per second
energy_progress := (account_full.energy_recovery * 100) / 60;

-- Calculate new energy 

newtime := EXTRACT(epoch FROM now()) :: Integer;
deltatime := newtime - account_full.energy_updated;
updated_energy := LEAST(account_full.max_energy, round(account_full.energy + deltatime * energy_progress));

-- Calculate till it is filled
IF account_full.max_energy = updated_energy THEN 
	til := 0;
ELSE 
	til := (1000 - updated_energy % 1000  )  / energy_progress;
END IF;


UPDATE account SET energy = updated_energy, energy_updated = newtime, till = til WHERE id = account_id; 
RETURN TRUE;
END
$_$;


ALTER FUNCTION public.account_update_energy(account_id bigint) OWNER TO postgres;

--
-- Name: addauth(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addauth(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
	lockid alias for $1;
	okay boolean;
	myrec record;
BEGIN
	-- check to see if table exists
	--  if not, CREATE TEMP TABLE mylock (transid xid, lockcode text)
	okay := 'f';
	FOR myrec IN SELECT * FROM pg_class WHERE relname = 'temp_lock_have_table' LOOP
		okay := 't';
	END LOOP; 
	IF (okay <> 't') THEN 
		CREATE TEMP TABLE temp_lock_have_table (transid xid, lockcode text);
			-- this will only work from pgsql7.4 up
			-- ON COMMIT DELETE ROWS;
	END IF;

	--  INSERT INTO mylock VALUES ( $1)
--	EXECUTE 'INSERT INTO temp_lock_have_table VALUES ( '||
--		quote_literal(getTransactionID()) || ',' ||
--		quote_literal(lockid) ||')';

	INSERT INTO temp_lock_have_table VALUES (getTransactionID(), lockid);

	RETURN true::boolean;
END;
$_$;


ALTER FUNCTION public.addauth(text) OWNER TO postgres;

--
-- Name: addgeometrycolumn(character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('','',$1,$2,$3,$4,$5) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.addgeometrycolumn(character varying, character varying, integer, character varying, integer) OWNER TO postgres;

--
-- Name: addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STABLE STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('',$1,$2,$3,$4,$5,$6) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.addgeometrycolumn(character varying, character varying, character varying, integer, character varying, integer) OWNER TO postgres;

--
-- Name: addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	new_type alias for $6;
	new_dim alias for $7;
	rec RECORD;
	sr varchar;
	real_schema name;
	sql text;

BEGIN

	-- Verify geometry type
	IF ( NOT ( (new_type = 'GEOMETRY') OR
			   (new_type = 'GEOMETRYCOLLECTION') OR
			   (new_type = 'POINT') OR
			   (new_type = 'MULTIPOINT') OR
			   (new_type = 'POLYGON') OR
			   (new_type = 'MULTIPOLYGON') OR
			   (new_type = 'LINESTRING') OR
			   (new_type = 'MULTILINESTRING') OR
			   (new_type = 'GEOMETRYCOLLECTIONM') OR
			   (new_type = 'POINTM') OR
			   (new_type = 'MULTIPOINTM') OR
			   (new_type = 'POLYGONM') OR
			   (new_type = 'MULTIPOLYGONM') OR
			   (new_type = 'LINESTRINGM') OR
			   (new_type = 'MULTILINESTRINGM') OR
			   (new_type = 'CIRCULARSTRING') OR
			   (new_type = 'CIRCULARSTRINGM') OR
			   (new_type = 'COMPOUNDCURVE') OR
			   (new_type = 'COMPOUNDCURVEM') OR
			   (new_type = 'CURVEPOLYGON') OR
			   (new_type = 'CURVEPOLYGONM') OR
			   (new_type = 'MULTICURVE') OR
			   (new_type = 'MULTICURVEM') OR
			   (new_type = 'MULTISURFACE') OR
			   (new_type = 'MULTISURFACEM')) )
	THEN
		RAISE EXCEPTION 'Invalid type name - valid ones are:
	POINT, MULTIPOINT,
	LINESTRING, MULTILINESTRING,
	POLYGON, MULTIPOLYGON,
	CIRCULARSTRING, COMPOUNDCURVE, MULTICURVE,
	CURVEPOLYGON, MULTISURFACE,
	GEOMETRY, GEOMETRYCOLLECTION,
	POINTM, MULTIPOINTM,
	LINESTRINGM, MULTILINESTRINGM,
	POLYGONM, MULTIPOLYGONM,
	CIRCULARSTRINGM, COMPOUNDCURVEM, MULTICURVEM
	CURVEPOLYGONM, MULTISURFACEM,
	or GEOMETRYCOLLECTIONM';
		RETURN 'fail';
	END IF;


	-- Verify dimension
	IF ( (new_dim >4) OR (new_dim <0) ) THEN
		RAISE EXCEPTION 'invalid dimension';
		RETURN 'fail';
	END IF;

	IF ( (new_type LIKE '%M') AND (new_dim!=3) ) THEN
		RAISE EXCEPTION 'TypeM needs 3 dimensions';
		RETURN 'fail';
	END IF;


	-- Verify SRID
	IF ( new_srid != -1 ) THEN
		SELECT SRID INTO sr FROM spatial_ref_sys WHERE SRID = new_srid;
		IF NOT FOUND THEN
			RAISE EXCEPTION 'AddGeometryColumns() - invalid SRID';
			RETURN 'fail';
		END IF;
	END IF;


	-- Verify schema
	IF ( schema_name IS NOT NULL AND schema_name != '' ) THEN
		sql := 'SELECT nspname FROM pg_namespace ' ||
			'WHERE text(nspname) = ' || quote_literal(schema_name) ||
			'LIMIT 1';
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Schema % is not a valid schemaname', quote_literal(schema_name);
			RETURN 'fail';
		END IF;
	END IF;

	IF ( real_schema IS NULL ) THEN
		RAISE DEBUG 'Detecting schema';
		sql := 'SELECT n.nspname AS schemaname ' ||
			'FROM pg_catalog.pg_class c ' ||
			  'JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace ' ||
			'WHERE c.relkind = ' || quote_literal('r') ||
			' AND n.nspname NOT IN (' || quote_literal('pg_catalog') || ', ' || quote_literal('pg_toast') || ')' ||
			' AND pg_catalog.pg_table_is_visible(c.oid)' ||
			' AND c.relname = ' || quote_literal(table_name);
		RAISE DEBUG '%', sql;
		EXECUTE sql INTO real_schema;

		IF ( real_schema IS NULL ) THEN
			RAISE EXCEPTION 'Table % does not occur in the search_path', quote_literal(table_name);
			RETURN 'fail';
		END IF;
	END IF;


	-- Add geometry column to table
	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD COLUMN ' || quote_ident(column_name) ||
		' geometry ';
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Delete stale record in geometry_columns (if any)
	sql := 'DELETE FROM geometry_columns WHERE
		f_table_catalog = ' || quote_literal('') ||
		' AND f_table_schema = ' ||
		quote_literal(real_schema) ||
		' AND f_table_name = ' || quote_literal(table_name) ||
		' AND f_geometry_column = ' || quote_literal(column_name);
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Add record in geometry_columns
	sql := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema,f_table_name,' ||
										  'f_geometry_column,coord_dimension,srid,type)' ||
		' VALUES (' ||
		quote_literal('') || ',' ||
		quote_literal(real_schema) || ',' ||
		quote_literal(table_name) || ',' ||
		quote_literal(column_name) || ',' ||
		new_dim::text || ',' ||
		new_srid::text || ',' ||
		quote_literal(new_type) || ')';
	RAISE DEBUG '%', sql;
	EXECUTE sql;


	-- Add table CHECKs
	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD CONSTRAINT '
		|| quote_ident('enforce_srid_' || column_name)
		|| ' CHECK (ST_SRID(' || quote_ident(column_name) ||
		') = ' || new_srid::text || ')' ;
	RAISE DEBUG '%', sql;
	EXECUTE sql;

	sql := 'ALTER TABLE ' ||
		quote_ident(real_schema) || '.' || quote_ident(table_name)
		|| ' ADD CONSTRAINT '
		|| quote_ident('enforce_dims_' || column_name)
		|| ' CHECK (ST_NDims(' || quote_ident(column_name) ||
		') = ' || new_dim::text || ')' ;
	RAISE DEBUG '%', sql;
	EXECUTE sql;

	IF ( NOT (new_type = 'GEOMETRY')) THEN
		sql := 'ALTER TABLE ' ||
			quote_ident(real_schema) || '.' || quote_ident(table_name) || ' ADD CONSTRAINT ' ||
			quote_ident('enforce_geotype_' || column_name) ||
			' CHECK (GeometryType(' ||
			quote_ident(column_name) || ')=' ||
			quote_literal(new_type) || ' OR (' ||
			quote_ident(column_name) || ') is null)';
		RAISE DEBUG '%', sql;
		EXECUTE sql;
	END IF;

	RETURN
		real_schema || '.' ||
		table_name || '.' || column_name ||
		' SRID:' || new_srid::text ||
		' TYPE:' || new_type ||
		' DIMS:' || new_dim::text || ' ';
END;
$_$;


ALTER FUNCTION public.addgeometrycolumn(character varying, character varying, character varying, character varying, integer, character varying, integer) OWNER TO postgres;

--
-- Name: asserty(text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asserty(text, boolean) RETURNS void
    LANGUAGE plpgsql IMMUTABLE COST 10
    AS $_$DECLARE 
	e alias for $1;
	v alias for $2;
BEGIN

	if not v then
		raise exception '%', e;
	end if;

END$_$;


ALTER FUNCTION public.asserty(text, boolean) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: part_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE part_type (
    id bigint NOT NULL,
    name text,
    sort integer,
    use_3d text,
    required boolean DEFAULT false,
    fixed boolean DEFAULT false,
    hidden boolean DEFAULT false
);


ALTER TABLE public.part_type OWNER TO postgres;

--
-- Name: car_get_missing_parts(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_get_missing_parts(bigint) RETURNS SETOF part_type
    LANGUAGE plpgsql STABLE ROWS 5
    AS $_$DECLARE 
	cid alias for $1;
	p part_type;
BEGIN

	for p in select * from part_type where required = true and id not in (select part_type_id from car_instance_parts where car_instance_id = cid) loop
		return next p;
	end loop;

END$_$;


ALTER FUNCTION public.car_get_missing_parts(bigint) OWNER TO postgres;

--
-- Name: car_instance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE car_instance (
    id bigint NOT NULL,
    car_id bigint NOT NULL,
    garage_id bigint,
    top_speed integer,
    acceleration integer,
    stopping integer,
    cornering integer,
    nitrous integer,
    price integer,
    weight integer,
    deleted boolean DEFAULT false,
    wear integer DEFAULT 0,
    improvement integer DEFAULT 0,
    active boolean DEFAULT false,
    ready boolean DEFAULT false,
    car_color text DEFAULT '255,255,255'::text,
    power integer,
    traction integer,
    handling integer,
    braking integer,
    aero integer,
    nos integer,
    prototype boolean DEFAULT false NOT NULL,
    prototype_name text DEFAULT ''::text NOT NULL,
    prototype_available boolean DEFAULT false NOT NULL,
    prototype_claimable boolean DEFAULT false NOT NULL,
    immutable integer DEFAULT 0
);


ALTER TABLE public.car_instance OWNER TO postgres;

--
-- Name: garage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE garage (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name text
);


ALTER TABLE public.garage OWNER TO postgres;

--
-- Name: part_instance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE part_instance (
    id bigint NOT NULL,
    part_id bigint NOT NULL,
    garage_id bigint,
    car_instance_id bigint,
    improvement integer DEFAULT 0,
    wear integer DEFAULT 0,
    account_id bigint,
    deleted boolean DEFAULT false,
    immutable integer DEFAULT 0
);


ALTER TABLE public.part_instance OWNER TO postgres;

--
-- Name: part_model; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE part_model (
    id bigint NOT NULL,
    part_type_id bigint NOT NULL,
    weight integer,
    parameter1 integer,
    car_id bigint DEFAULT 0 NOT NULL,
    d3d_model_id integer DEFAULT 0 NOT NULL,
    level integer,
    price integer DEFAULT 10,
    parameter2 integer,
    parameter3 integer,
    parameter1_type_id integer,
    parameter2_type_id integer,
    parameter3_type_id integer,
    part_modifier_id bigint,
    "unique" boolean DEFAULT false
);


ALTER TABLE public.part_model OWNER TO postgres;

--
-- Name: part_trash_price; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW part_trash_price AS
    SELECT pi.id, (((((1 + (pi.improvement / 100000)) * (1 - (pi.wear / 100000))))::numeric * 0.9) * (pm.price)::numeric) AS trash_price FROM (part_instance pi JOIN part_model pm ON ((pi.part_id = pm.id))) WHERE (pi.deleted = false);


ALTER TABLE public.part_trash_price OWNER TO postgres;

--
-- Name: parts_details_mat; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parts_details_mat (
    id bigint NOT NULL,
    name text,
    part_type_id bigint,
    weight integer,
    parameter1 integer,
    parameter1_name text,
    parameter1_unit text,
    parameter2 integer,
    parameter2_name text,
    parameter2_unit text,
    parameter3 integer,
    parameter3_name text,
    parameter3_unit text,
    car_id bigint,
    d3d_model_id integer,
    level integer,
    price integer,
    car_model text,
    manufacturer_name text,
    part_modifier text,
    "unique" boolean,
    sort_part_type integer,
    required boolean DEFAULT false,
    fixed boolean DEFAULT false,
    hidden boolean DEFAULT false,
    parameter1_is_modifier boolean,
    parameter2_is_modifier boolean,
    parameter3_is_modifier boolean
);


ALTER TABLE public.parts_details_mat OWNER TO postgres;

--
-- Name: parts_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW parts_details AS
    SELECT parts_details_mat.id, parts_details_mat.name, parts_details_mat.part_type_id, parts_details_mat.weight, parts_details_mat.parameter1, parts_details_mat.parameter1_name, parts_details_mat.parameter1_unit, parts_details_mat.parameter2, parts_details_mat.parameter2_name, parts_details_mat.parameter2_unit, parts_details_mat.parameter3, parts_details_mat.parameter3_name, parts_details_mat.parameter3_unit, parts_details_mat.car_id, parts_details_mat.d3d_model_id, parts_details_mat.level, parts_details_mat.price, parts_details_mat.car_model, parts_details_mat.manufacturer_name, parts_details_mat.part_modifier, parts_details_mat."unique", parts_details_mat.sort_part_type, parts_details_mat.required, parts_details_mat.fixed, parts_details_mat.hidden, parts_details_mat.parameter1_is_modifier, parts_details_mat.parameter2_is_modifier, parts_details_mat.parameter3_is_modifier FROM parts_details_mat;


ALTER TABLE public.parts_details OWNER TO postgres;

--
-- Name: car_instance_parts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_instance_parts AS
    SELECT pi.id AS part_instance_id, ci.id AS car_instance_id, pd.id AS part_id, pd.name, pd.part_type_id, pd.weight, pd.parameter1, pd.parameter1_name, pd.parameter1_unit, pd.parameter2, pd.parameter2_name, pd.parameter2_unit, pd.parameter3, pd.parameter3_name, pd.parameter3_unit, pd.car_id, pd.d3d_model_id, pd.level, pd.price, pd.car_model, pd.manufacturer_name, pd.part_modifier, pd."unique", pd.sort_part_type, pd.price AS new_price, g.account_id, pi.improvement, pi.wear, pd.required, pd.fixed, pd.hidden, pd.parameter1_is_modifier, pd.parameter2_is_modifier, pd.parameter3_is_modifier FROM ((((parts_details pd JOIN part_instance pi ON ((pi.part_id = pd.id))) JOIN part_trash_price ptp ON ((ptp.id = pi.id))) JOIN car_instance ci ON ((pi.car_instance_id = ci.id))) LEFT JOIN garage g ON ((ci.garage_id = g.id)));


ALTER TABLE public.car_instance_parts OWNER TO postgres;

--
-- Name: car_get_worn_parts(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_get_worn_parts(bigint) RETURNS SETOF car_instance_parts
    LANGUAGE plpgsql STABLE ROWS 5
    AS $_$DECLARE 
	cid alias for $1;
	p car_instance_parts;
BEGIN

	for p in select * from car_instance_parts where car_instance_id = cid and wear > 9999 loop
		return next p;
	end loop;

END$_$;


ALTER FUNCTION public.car_get_worn_parts(bigint) OWNER TO postgres;

--
-- Name: car_has_required_parts(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_has_required_parts(bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 
	cid alias for $1;
BEGIN
	perform asserty('car instance not found', (select count(*) > 0 from car_instance where id = cid and deleted = false));

	return not (select count(*) > 0 from part_type where required = true and id not in (
		select part_type_id from car_instance_parts where car_instance_id = cid
	));
	
END$_$;


ALTER FUNCTION public.car_has_required_parts(bigint) OWNER TO postgres;

--
-- Name: car_instance_update_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_instance_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

	t integer;

BEGIN
	NEW = get_updated_car_instance(NEW);


	NEW.ready =
--		(select not count(*) > 0 from part_type where required = true and id not in (select part_type_id from car_instance_parts where car_instance_id = NEW.id))
--		and
--		(select not count(*) > 0 from part_type where id in (select part_type_id from car_instance_parts where car_instance_id = NEW.id and wear > 99999));
		(select not (count(*) > 0) from car_get_missing_parts(NEW.id))
		and
		(select not (count(*) > 0) from car_get_worn_parts(NEW.id));
	
	t := (select wear from car_instance_parts where name = 'car' and car_instance_id = NEW.id);
	NEW.wear = (case when t is null then 0 else t end);
	
	t := (select improvement from car_instance_parts where name = 'car' and car_instance_id = NEW.id);
	NEW.improvement = (case when t is null then 0 else t end);
	
	RETURN NEW;
END$$;


ALTER FUNCTION public.car_instance_update_trigger() OWNER TO postgres;

--
-- Name: car_model_update_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_model_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

BEGIN
	NEW = get_updated_car_model(NEW);
	RETURN NEW;
END$$;


ALTER FUNCTION public.car_model_update_trigger() OWNER TO postgres;

--
-- Name: car_model_update_trigger_after(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_model_update_trigger_after() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

BEGIN

	-- perform bogus updates on car_instance rows to trigger triggers
	
	if (TG_OP = 'UPDATE') then
		update car_instance
		set car_id = NEW.id
		where car_id = NEW.id;
        end if;
	
	return NEW;

END$$;


ALTER FUNCTION public.car_model_update_trigger_after() OWNER TO postgres;

--
-- Name: car_parts_not_too_worn(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_parts_not_too_worn(bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 
	cid alias for $1;
BEGIN
	perform asserty('car instance not found', (select count(*) > 0 from car_instance where id = cid and deleted = false));
	return not (select count(*) > 0 from car_instance_parts where car_instance_id = cid and wear > 99999);
END$_$;


ALTER FUNCTION public.car_parts_not_too_worn(bigint) OWNER TO postgres;

--
-- Name: car_properties(double precision, part_properties); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_properties(double precision, part_properties) RETURNS car_properties
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 

	weight alias for $1;
	props alias for $2;

	res car_properties;
    
BEGIN

	select * into res from car_properties_empty();

	res.power = props.power * props.power_m;
	res.traction = props.traction * props.traction_m;
	res.handling = props.handling * props.handling_m;
	res.braking = props.braking * props.braking_m;
	res.aero = props.aero * props.aero_m;
	res.nos = props.nos * props.nos_m;

	return res;

END$_$;


ALTER FUNCTION public.car_properties(double precision, part_properties) OWNER TO postgres;

--
-- Name: car_properties_empty(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION car_properties_empty() RETURNS car_properties
    LANGUAGE plpgsql IMMUTABLE
    AS $$DECLARE 

    res car_properties;
    
BEGIN

    res.top_speed = 0;
    res.acceleration = 0;
    res.cornering = 0;
    res.stopping = 0;
    res.nitrous = 0;
    
    res.power = 0;
    res.traction = 0;
    res.handling = 0;
    res.braking = 0;
    res.aero = 0;
    res.nos = 0;
    
    return res;
    

END$$;


ALTER FUNCTION public.car_properties_empty() OWNER TO postgres;

--
-- Name: checkauth(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkauth(text, text) RETURNS integer
    LANGUAGE sql
    AS $_$ SELECT CheckAuth('', $1, $2) $_$;


ALTER FUNCTION public.checkauth(text, text) OWNER TO postgres;

--
-- Name: checkauth(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkauth(text, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
	schema text;
BEGIN
	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
	END IF;

	if ( $1 != '' ) THEN
		schema = $1;
	ELSE
		SELECT current_schema() into schema;
	END IF;

	-- TODO: check for an already existing trigger ?

	EXECUTE 'CREATE TRIGGER check_auth BEFORE UPDATE OR DELETE ON ' 
		|| quote_ident(schema) || '.' || quote_ident($2)
		||' FOR EACH ROW EXECUTE PROCEDURE CheckAuthTrigger('
		|| quote_literal($3) || ')';

	RETURN 0;
END;
$_$;


ALTER FUNCTION public.checkauth(text, text, text) OWNER TO postgres;

--
-- Name: task; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task (
    id bigint NOT NULL,
    "time" bigint,
    data text,
    deleted boolean DEFAULT false,
    claim bigint DEFAULT 0
);


ALTER TABLE public.task OWNER TO postgres;

--
-- Name: claim_tasks(bigint, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION claim_tasks(bigint, integer, bigint) RETURNS SETOF task
    LANGUAGE plpgsql
    AS $_$DECLARE 
	r task;
	c bigint;
BEGIN
	
	c := nextval('task_claim_seq');
	
	update "task" set claim = c
		where deleted = false
			and claim = 0
			and time <= $1
			and id in (select task_id from task_trigger where type = $2 and $3 in (0, target_id));

	for r in select * from task where claim = c loop
		return next r;
	end loop;
	
END$_$;


ALTER FUNCTION public.claim_tasks(bigint, integer, bigint) OWNER TO postgres;

--
-- Name: disablelongtransactions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION disablelongtransactions() RETURNS text
    LANGUAGE plpgsql
    AS $$ 
DECLARE
	rec RECORD;

BEGIN

	--
	-- Drop all triggers applied by CheckAuth()
	--
	FOR rec IN
		SELECT c.relname, t.tgname, t.tgargs FROM pg_trigger t, pg_class c, pg_proc p
		WHERE p.proname = 'checkauthtrigger' and t.tgfoid = p.oid and t.tgrelid = c.oid
	LOOP
		EXECUTE 'DROP TRIGGER ' || quote_ident(rec.tgname) ||
			' ON ' || quote_ident(rec.relname);
	END LOOP;

	--
	-- Drop the authorization_table table
	--
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorization_table' LOOP
		DROP TABLE authorization_table;
	END LOOP;

	--
	-- Drop the authorized_tables view
	--
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorized_tables' LOOP
		DROP VIEW authorized_tables;
	END LOOP;

	RETURN 'Long transactions support disabled';
END;
$$;


ALTER FUNCTION public.disablelongtransactions() OWNER TO postgres;

--
-- Name: dropgeometrycolumn(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrycolumn(character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret text;
BEGIN
	SELECT DropGeometryColumn('','',$1,$2) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.dropgeometrycolumn(character varying, character varying) OWNER TO postgres;

--
-- Name: dropgeometrycolumn(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrycolumn(character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret text;
BEGIN
	SELECT DropGeometryColumn('',$1,$2,$3) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.dropgeometrycolumn(character varying, character varying, character varying) OWNER TO postgres;

--
-- Name: dropgeometrycolumn(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrycolumn(character varying, character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	myrec RECORD;
	okay boolean;
	real_schema name;

BEGIN


	-- Find, check or fix schema_name
	IF ( schema_name != '' ) THEN
		okay = 'f';

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := 't';
		END LOOP;

		IF ( okay <> 't' ) THEN
			RAISE NOTICE 'Invalid schema name - using current_schema()';
			SELECT current_schema() into real_schema;
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT current_schema() into real_schema;
	END IF;

	-- Find out if the column is in the geometry_columns table
	okay = 'f';
	FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := 't';
	END LOOP;
	IF (okay <> 't') THEN
		RAISE EXCEPTION 'column not found in geometry_columns table';
		RETURN 'f';
	END IF;

	-- Remove ref from geometry_columns table
	EXECUTE 'delete from geometry_columns where f_table_schema = ' ||
		quote_literal(real_schema) || ' and f_table_name = ' ||
		quote_literal(table_name)  || ' and f_geometry_column = ' ||
		quote_literal(column_name);

	-- Remove table column
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) || '.' ||
		quote_ident(table_name) || ' DROP COLUMN ' ||
		quote_ident(column_name);

	RETURN real_schema || '.' || table_name || '.' || column_name ||' effectively removed.';

END;
$_$;


ALTER FUNCTION public.dropgeometrycolumn(character varying, character varying, character varying, character varying) OWNER TO postgres;

--
-- Name: dropgeometrytable(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrytable(character varying) RETURNS text
    LANGUAGE sql STRICT
    AS $_$ SELECT DropGeometryTable('','',$1) $_$;


ALTER FUNCTION public.dropgeometrytable(character varying) OWNER TO postgres;

--
-- Name: dropgeometrytable(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrytable(character varying, character varying) RETURNS text
    LANGUAGE sql STRICT
    AS $_$ SELECT DropGeometryTable('',$1,$2) $_$;


ALTER FUNCTION public.dropgeometrytable(character varying, character varying) OWNER TO postgres;

--
-- Name: dropgeometrytable(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropgeometrytable(character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	real_schema name;

BEGIN

	IF ( schema_name = '' ) THEN
		SELECT current_schema() into real_schema;
	ELSE
		real_schema = schema_name;
	END IF;

	-- Remove refs from geometry_columns table
	EXECUTE 'DELETE FROM geometry_columns WHERE ' ||
		'f_table_schema = ' || quote_literal(real_schema) ||
		' AND ' ||
		' f_table_name = ' || quote_literal(table_name);

	-- Remove table
	EXECUTE 'DROP TABLE '
		|| quote_ident(real_schema) || '.' ||
		quote_ident(table_name);

	RETURN
		real_schema || '.' ||
		table_name ||' dropped.';

END;
$_$;


ALTER FUNCTION public.dropgeometrytable(character varying, character varying, character varying) OWNER TO postgres;

--
-- Name: empty_trigger_for_instead_of(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION empty_trigger_for_instead_of() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

return NEW;

END
$$;


ALTER FUNCTION public.empty_trigger_for_instead_of() OWNER TO postgres;

--
-- Name: enablelongtransactions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION enablelongtransactions() RETURNS text
    LANGUAGE plpgsql
    AS $$ 
DECLARE
	"query" text;
	exists bool;
	rec RECORD;

BEGIN

	exists = 'f';
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorization_table'
	LOOP
		exists = 't';
	END LOOP;

	IF NOT exists
	THEN
		"query" = 'CREATE TABLE authorization_table (
			toid oid, -- table oid
			rid text, -- row id
			expires timestamp,
			authid text
		)';
		EXECUTE "query";
	END IF;

	exists = 'f';
	FOR rec IN SELECT * FROM pg_class WHERE relname = 'authorized_tables'
	LOOP
		exists = 't';
	END LOOP;

	IF NOT exists THEN
		"query" = 'CREATE VIEW authorized_tables AS ' ||
			'SELECT ' ||
			'n.nspname as schema, ' ||
			'c.relname as table, trim(' ||
			quote_literal(chr(92) || '000') ||
			' from t.tgargs) as id_column ' ||
			'FROM pg_trigger t, pg_class c, pg_proc p ' ||
			', pg_namespace n ' ||
			'WHERE p.proname = ' || quote_literal('checkauthtrigger') ||
			' AND c.relnamespace = n.oid' ||
			' AND t.tgfoid = p.oid and t.tgrelid = c.oid';
		EXECUTE "query";
	END IF;

	RETURN 'Long transactions support enabled';
END;
$$;


ALTER FUNCTION public.enablelongtransactions() OWNER TO postgres;

--
-- Name: find_srid(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_srid(character varying, character varying, character varying) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schem text;
	tabl text;
	sr int4;
BEGIN
	IF $1 IS NULL THEN
	  RAISE EXCEPTION 'find_srid() - schema is NULL!';
	END IF;
	IF $2 IS NULL THEN
	  RAISE EXCEPTION 'find_srid() - table name is NULL!';
	END IF;
	IF $3 IS NULL THEN
	  RAISE EXCEPTION 'find_srid() - column name is NULL!';
	END IF;
	schem = $1;
	tabl = $2;
-- if the table contains a . and the schema is empty
-- split the table into a schema and a table
-- otherwise drop through to default behavior
	IF ( schem = '' and tabl LIKE '%.%' ) THEN
	 schem = substr(tabl,1,strpos(tabl,'.')-1);
	 tabl = substr(tabl,length(schem)+2);
	ELSE
	 schem = schem || '%';
	END IF;

	select SRID into sr from geometry_columns where f_table_schema like schem and f_table_name = tabl and f_geometry_column = $3;
	IF NOT FOUND THEN
	   RAISE EXCEPTION 'find_srid() - couldnt find the corresponding SRID - is the geometry registered in the GEOMETRY_COLUMNS table?  Is there an uppercase/lowercase missmatch?';
	END IF;
	return sr;
END;
$_$;


ALTER FUNCTION public.find_srid(character varying, character varying, character varying) OWNER TO postgres;

--
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	UPDATE geometry_columns SET f_table_schema = n.nspname
		FROM pg_namespace n, pg_class c, pg_attribute a,
			pg_constraint sridcheck, pg_constraint typecheck
			WHERE ( f_table_schema is NULL
		OR f_table_schema = ''
			OR f_table_schema NOT IN (
					SELECT nspname::varchar
					FROM pg_namespace nn, pg_class cc, pg_attribute aa
					WHERE cc.relnamespace = nn.oid
					AND cc.relname = f_table_name::name
					AND aa.attrelid = cc.oid
					AND aa.attname = f_geometry_column::name))
			AND f_table_name::name = c.relname
			AND c.oid = a.attrelid
			AND c.relnamespace = n.oid
			AND f_geometry_column::name = a.attname

			AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(srid(% = %)'
			AND sridcheck.consrc ~ textcat(' = ', srid::text)

			AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype(%) = ''%''::text) OR (% IS NULL))'
			AND typecheck.consrc ~ textcat(' = ''', type::text)

			AND NOT EXISTS (
					SELECT oid FROM geometry_columns gc
					WHERE c.relname::varchar = gc.f_table_name
					AND n.nspname::varchar = gc.f_table_schema
					AND a.attname::varchar = gc.f_geometry_column
			);

	GET DIAGNOSTICS foundschema = ROW_COUNT;

	-- no linkage to system table needed
	return 'fixed:'||foundschema::text;

END;
$$;


ALTER FUNCTION public.fix_geometry_columns() OWNER TO postgres;

--
-- Name: garage_actions(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_actions(bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	gid alias for $1;
BEGIN

	-- update personnel tasks
	perform personnel_update_task(personnel_instance_id) from personnel_instance_details where garage_id = gid;

	return true;
END$_$;


ALTER FUNCTION public.garage_actions(bigint) OWNER TO postgres;

--
-- Name: garage_actions_account(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_actions_account(bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	gid bigint;
BEGIN
	select id into gid from garage where account_id = $1 limit 1;
	return garage_actions(gid);
END$_$;


ALTER FUNCTION public.garage_actions_account(bigint) OWNER TO postgres;

--
-- Name: garage_active_car_ready(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_active_car_ready(bigint) RETURNS SETOF text
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 
	gid alias for $1;
	cid bigint;
	t part_type;
BEGIN

	perform asserty('garage not found', (select count(*) > 0 from garage where id = gid));
	
	if not (select count(*) > 0 from car_instance where garage_id = gid and deleted = false and active = true) then
		return next 'no active car';
		return;
	end if;
	
	select id into cid from car_instance where garage_id = gid and deleted = false and active = true limit 1;
	
--	return query select * from garage_car_ready(gid, cid);

	for t in select * from part_type where required = true and id not in (select part_type_id from car_instance_parts where car_instance_id = cid) loop
		return next 'a vital part is missing';
	end loop;

	for t in select * from part_type where id in (select part_type_id from car_instance_parts where car_instance_id = cid and wear > 99999) loop
		return next 'one of the parts is too worn';
	end loop;

	return;

END$_$;


ALTER FUNCTION public.garage_active_car_ready(bigint) OWNER TO postgres;

--
-- Name: garage_car_ready(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_car_ready(bigint, bigint) RETURNS SETOF text
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 
	gid alias for $1;
	cid alias for $2;
	t part_type;
BEGIN

	perform asserty('garage not found', (select count(*) > 0 from garage where id = gid));
	perform asserty('car instance not found', (select count(*) > 0 from car_instance where garage_id = gid and id = cid and deleted = false));
	
	for t in select * from part_type where required = true and id not in (select part_type_id from car_instance_parts where car_instance_id = cid) loop
		return next 'a vital part is missing';
	end loop;

	for t in select * from part_type where id in (select part_type_id from car_instance_parts where car_instance_id = cid and wear > 99999) loop
		return next 'one of the parts is too worn';
	end loop;

	return;

END$_$;


ALTER FUNCTION public.garage_car_ready(bigint, bigint) OWNER TO postgres;

--
-- Name: garage_car_unset_active(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_car_unset_active(bigint, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 

	gid alias for $1;
	cid alias for $2;

	n integer;
BEGIN
	perform asserty('garage not found', (select count(*) > 0 from garage where id = gid));
	perform asserty('car instance not found', (select count(*) > 0 from car_instance where garage_id = gid and id = cid and deleted = false));

	update car_instance set active = false where id = cid;

	return true;

END$_$;


ALTER FUNCTION public.garage_car_unset_active(bigint, bigint) OWNER TO postgres;

--
-- Name: garage_set_active_car(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_set_active_car(bigint, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	gid alias for $1;
	cid alias for $2;
BEGIN

	perform asserty('garage not found', (select count(*) > 0 from garage where id = gid));
	perform asserty('car instance not found', (select count(*) > 0 from car_instance where garage_id = gid and id = cid and deleted = false));
	
	perform garage_set_active_car_none(gid);
	update car_instance set active = true where id = cid;

	return true;

END$_$;


ALTER FUNCTION public.garage_set_active_car(bigint, bigint) OWNER TO postgres;

--
-- Name: garage_set_active_car_none(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_set_active_car_none(bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	gid alias for $1;
BEGIN
	perform asserty('garage not found', (select count(*) > 0 from garage where id = gid));
	update car_instance set active = false where garage_id = gid;
	return true;

END$_$;


ALTER FUNCTION public.garage_set_active_car_none(bigint) OWNER TO postgres;

--
-- Name: garage_unset_active_car(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION garage_unset_active_car(bigint, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 

	gid alias for $1;
	cid alias for $2;
BEGIN
	perform asserty('garage not found', (select count(*) > 0 from garage where id = gid));
	perform asserty('car instance not found', (select count(*) > 0 from car_instance where garage_id = gid and id = cid and deleted = false));

	update car_instance set active = false where id = cid;

	return true;

END$_$;


ALTER FUNCTION public.garage_unset_active_car(bigint, bigint) OWNER TO postgres;

--
-- Name: gen_part_instance_3d_model(bigint, text, bigint, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_part_instance_3d_model(bigint, text, bigint, text, text, text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE COST 10
    AS $_$DECLARE 

	ptid alias for $1;
	ptname alias for $2;
	d3dmid alias for $3;
	d3dname alias for $4;
	cmname alias for $5;
	mfname alias for $6;
	

BEGIN
	if ptid = 11 then -- body kit
		return replace(lower(d3dname || '/'::text || btrim(mfname) || ' '::text || btrim(cmname) || '/body_kit_'::text || d3dmid || '.unity3d'::text), ' '::text, '_'::text);
	elseif ptid = 20 then -- car
		return replace(lower(d3dname || '/'::text || btrim(mfname) || ' '::text || btrim(cmname) || '/car.unity3d'::text), ' '::text, '_'::text);
	else
		return replace(lower(d3dname || '/'::text || btrim(ptname) || '_'::text || d3dmid || '.unity3d'::text), ' '::text, '_'::text);
	end if;
	
END$_$;


ALTER FUNCTION public.gen_part_instance_3d_model(bigint, text, bigint, text, text, text) OWNER TO postgres;

--
-- Name: get_car_stock_parts(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_car_stock_parts(bigint) RETURNS SETOF part_model
    LANGUAGE plpgsql STABLE ROWS 10
    AS $_$DECLARE 

	cid alias for $1;
	cmr car_model;
	pmr part_model;
	ptr part_type;

BEGIN

	-- for each car with id = cid, i.e. zero or one times
	for cmr in select * from car_model where id = cid loop

		-- for each required part type
		for ptr in select * from part_type t where t.required = true loop

			-- get single highest level stock part below car level and return this record
			for pmr in
				select * from part_model where part_type_id = ptr.id and part_modifier_id = 1 and
				(
						(car_id = cid)
					or
						(car_id = 0 and level in (
							select max(p.level) as level
							from part_model p
							where p.part_type_id = ptr.id
							and p.level <= cmr.level
						))
				)
				order by car_id desc limit 1
			loop
				return next pmr;
			end loop;
		end loop;
	end loop;

END$_$;


ALTER FUNCTION public.get_car_stock_parts(bigint) OWNER TO postgres;

--
-- Name: get_proj4_from_srid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_proj4_from_srid(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
BEGIN
	RETURN proj4text::text FROM spatial_ref_sys WHERE srid= $1;
END;
$_$;


ALTER FUNCTION public.get_proj4_from_srid(integer) OWNER TO postgres;

--
-- Name: get_updated_car_instance(car_instance); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_updated_car_instance(car_instance) RETURNS car_instance
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 

	ins alias for $1;

	res car_instance;

	pt part_properties;
	p part_properties;
	m car_model;
	cip car_instance_parts;
	carp car_properties;

BEGIN

	res = ins;
	
	res.weight = 0;
	res.price = 0;

	-- get car model
	select * into m from car_model where id = ins.car_id;

	-- get part instances
	for cip in
		select * from car_instance_parts where car_instance_id = ins.id
	loop
		res.weight = res.weight + cip.weight;
		res.price = res.price + cip.price;
	end loop;
	
	-- get all part parameters for part instances
	p = part_properties_empty();
	for pt in
		select (part_properties(parameter, parameter_type_id, improvement, wear)).* from car_instance_parameter_list where id = ins.id
	loop
		p = part_properties_add(p, pt);
	end loop;

	-- get car properties from cumulative weight and part properties
	carp = car_properties(res.weight, p);

	res.top_speed = -1;
	res.acceleration = -1;
	res.stopping = -1;
	res.cornering = -1;
	res.nitrous = -1;

	res.power = (10000 * carp.power) :: bigint;
	res.traction = (10000 * carp.traction) :: bigint;
	res.braking = (10000 * carp.braking) :: bigint;
	res.handling = (10000 * carp.handling) :: bigint;
	res.aero = (10000 * carp.aero) :: bigint;
	res.nos = (10000 * carp.nos) :: bigint;
	

	return res;

END$_$;


ALTER FUNCTION public.get_updated_car_instance(car_instance) OWNER TO postgres;

--
-- Name: car_model; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE car_model (
    id bigint NOT NULL,
    manufacturer_id bigint NOT NULL,
    top_speed integer,
    acceleration integer,
    braking integer,
    nos integer,
    handling integer,
    name text,
    use_3d text,
    level integer,
    year integer,
    price integer DEFAULT 10,
    weight integer DEFAULT 10
);


ALTER TABLE public.car_model OWNER TO postgres;

--
-- Name: get_updated_car_model(car_model); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_updated_car_model(car_model) RETURNS car_model
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 

	ins alias for $1;

	res car_model;

	pt part_properties;
	p part_properties;
	cip part_model;
	carp car_properties;

BEGIN

	res = ins;

	res.weight = 0;
	res.price = 0;

	p = part_properties_empty();
	
	-- get part models, add up properties
	for cip in
		select * from get_car_stock_parts(ins.id)
	loop
		res.weight = res.weight + cip.weight;
		res.price = res.price + cip.price;

		if(cip.parameter1 is not null) then
			p = part_properties_add(p, part_properties(cip.parameter1, cip.parameter1_type_id));
		end if;
		
		if(cip.parameter2 is not null) then
			p = part_properties_add(p, part_properties(cip.parameter2, cip.parameter2_type_id));
		end if;
		
		if(cip.parameter3 is not null) then
			p = part_properties_add(p, part_properties(cip.parameter3, cip.parameter3_type_id));
		end if;
	end loop;

	-- get car properties from cumulative weight and part properties
	carp = car_properties(res.weight, p);

	res.top_speed = carp.top_speed :: integer;
	res.acceleration = carp.acceleration :: integer;
	res.braking = carp.braking :: integer;
	res.handling = carp.handling :: integer;
	res.nos = carp.nos :: integer;

	return res;

END$_$;


ALTER FUNCTION public.get_updated_car_model(car_model) OWNER TO postgres;

--
-- Name: lockrow(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow(current_schema(), $1, $2, $3, now()::timestamp+'1:00'); $_$;


ALTER FUNCTION public.lockrow(text, text, text) OWNER TO postgres;

--
-- Name: lockrow(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text, text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow($1, $2, $3, $4, now()::timestamp+'1:00'); $_$;


ALTER FUNCTION public.lockrow(text, text, text, text) OWNER TO postgres;

--
-- Name: lockrow(text, text, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text, timestamp without time zone) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$ SELECT LockRow(current_schema(), $1, $2, $3, $4); $_$;


ALTER FUNCTION public.lockrow(text, text, text, timestamp without time zone) OWNER TO postgres;

--
-- Name: lockrow(text, text, text, text, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lockrow(text, text, text, text, timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE
	myschema alias for $1;
	mytable alias for $2;
	myrid   alias for $3;
	authid alias for $4;
	expires alias for $5;
	ret int;
	mytoid oid;
	myrec RECORD;
	
BEGIN

	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
	END IF;

	EXECUTE 'DELETE FROM authorization_table WHERE expires < now()'; 

	SELECT c.oid INTO mytoid FROM pg_class c, pg_namespace n
		WHERE c.relname = mytable
		AND c.relnamespace = n.oid
		AND n.nspname = myschema;

	-- RAISE NOTICE 'toid: %', mytoid;

	FOR myrec IN SELECT * FROM authorization_table WHERE 
		toid = mytoid AND rid = myrid
	LOOP
		IF myrec.authid != authid THEN
			RETURN 0;
		ELSE
			RETURN 1;
		END IF;
	END LOOP;

	EXECUTE 'INSERT INTO authorization_table VALUES ('||
		quote_literal(mytoid::text)||','||quote_literal(myrid)||
		','||quote_literal(expires::text)||
		','||quote_literal(authid) ||')';

	GET DIAGNOSTICS ret = ROW_COUNT;

	RETURN ret;
END;
$_$;


ALTER FUNCTION public.lockrow(text, text, text, text, timestamp without time zone) OWNER TO postgres;

--
-- Name: longtransactionsenabled(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION longtransactionsenabled() RETURNS boolean
    LANGUAGE plpgsql
    AS $$ 
DECLARE
	rec RECORD;
BEGIN
	FOR rec IN SELECT oid FROM pg_class WHERE relname = 'authorized_tables'
	LOOP
		return 't';
	END LOOP;
	return 'f';
END;
$$;


ALTER FUNCTION public.longtransactionsenabled() OWNER TO postgres;

--
-- Name: mat_snapshot_create(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mat_snapshot_create(src text, "table" text, primkey text) RETURNS void
    LANGUAGE plpgsql
    AS $_$DECLARE

srctbl ALIAS FOR $1;
dsttbl ALIAS FOR $2;
prmkey ALIAS FOR $3;

BEGIN

-- Create new table 


EXECUTE ('CREATE TABLE ' || dsttbl || ' AS SELECT * FROM ' || srctbl); 

-- Create primary key 

EXECUTE ('ALTER TABLE ' || dsttbl || ' ADD PRIMARY KEY(' || prmkey || ')');



END;
$_$;


ALTER FUNCTION public.mat_snapshot_create(src text, "table" text, primkey text) OWNER TO postgres;

--
-- Name: mat_update_market_parts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mat_update_market_parts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

qry TEXT;

BEGIN 

/*
 Trigger table, U means updates corresponding entry. D means delete corresponding entry. I means insert corresponding entry. 

 This keeps the market_parts_mat/parts_details_mat table in sync with the other tables. These two tables are structurally the same. 
 
        | part_modifier | manufacturer | car_model | part_model | parameter_table | part_type |
--------+---------------+--------------+-----------+------------+-----------------+-----------+
INSERT  |               |              |           |      I     |                 |           |
--------+---------------+--------------+-----------+------------+-----------------+-----------+
UPDATE  |       U       |       U      |     U     |     DU     |                 |     U     |
--------+---------------+--------------+-----------+------------+-----------------+-----------+
DELETE  |       D       |       D      |     D     |      D     |                 |     D     |
--------+---------------+--------------+-----------+------------+-----------------+-----------+


*/
IF TG_RELNAME = 'part_modifier' THEN 
	IF TG_OP = 'INSERT' THEN 
	END IF;
	IF TG_OP = 'DELETE' THEN 
		DELETE FROM market_parts_mat where part_modifier = OLD.name;
		DELETE FROM parts_details_mat where part_modifier = OLD.name;

		
	END IF;
	
	IF TG_OP = 'UPDATE' THEN 
		update market_parts_mat set part_modifier = NEW.name where part_modifier = OLD.name;
		update parts_details_mat set part_modifier = NEW.name where part_modifier = OLD.name;

	END IF;
END IF;

IF TG_RELNAME = 'part_type' THEN 
	IF TG_OP = 'INSERT' THEN 
	END IF;
	IF TG_OP = 'DELETE' THEN 
		delete from market_parts_mat where part_type_id = OLD.id;
		delete from parts_details_mat where part_type_id = OLD.id;

	END IF;
	IF TG_OP = 'UPDATE' THEN 
	        update market_parts_mat set sort_part_type = NEW.sort, name = NEW.name, hidden = NEW.hidden, fixed = NEW.fixed where part_type_id = NEW.id;
	        update parts_details_mat set sort_part_type = NEW.sort, name = NEW.name , hidden = NEW.hidden, fixed = NEW.fixed where part_type_id = NEW.id;


	END IF;
END IF;

IF TG_RELNAME = 'manufacturer' THEN 
	IF TG_OP = 'INSERT' THEN 
	END IF;
	IF TG_OP = 'DELETE' THEN 
		delete from market_parts_mat where manufacturer_name = OLD.name;
		delete from parts_details_mat where manufacturer_name = OLD.name;

	END IF;
	IF TG_OP = 'UPDATE' THEN 
		update market_parts_mat set manufacturer_name = NEW.name where  manufacturer_name = OLD.name;
		update parts_details_mat set manufacturer_name = NEW.name where  manufacturer_name = OLD.name;


	END IF;
END IF;

IF TG_RELNAME = 'car_model' THEN 
	IF TG_OP = 'INSERT' THEN 
	END IF;
	IF TG_OP = 'DELETE' THEN 
		delete from market_parts_mat where car_model = OLD.name;
		delete from parts_details_mat where car_model = OLD.name;

	END IF;
	IF TG_OP = 'UPDATE' THEN 
		update market_parts_mat set car_model = NEW.name where car_model = OLD.name;
		update parts_details_mat set car_model = NEW.name where car_model = OLD.name;

	END IF;
END IF;

-- Cannot do jackshit here
IF TG_RELNAME = 'parameter_table' THEN 
	IF TG_OP = 'INSERT' THEN 
	END IF;
	IF TG_OP = 'DELETE' THEN 
	END IF;
	IF TG_OP = 'UPDATE' THEN 
	END IF;
END IF;

IF TG_RELNAME = 'part_model' THEN
	
		IF TG_OP = 'INSERT' THEN 
			IF NEW.id IS NULL THEN 

				RAISE EXCEPTION 'no id';
                        END IF;
			INSERT INTO market_parts_mat SELECT pm.id, pt.name, pm.part_type_id, pm.weight, pmt.parameter1, 
				pmt.parameter1_name, pmt.parameter1_unit, pmt.parameter2, 
				pmt.parameter2_name, pmt.parameter2_unit, pmt.parameter3, 
				pmt.parameter3_name, pmt.parameter3_unit, pm.car_id, pm.d3d_model_id, 
				pm.level, pm.price, cm.name AS car_model, m.name AS manufacturer_name, 
					mod.name AS part_modifier, pm."unique", pt.sort AS sort_part_type,
					pt.required, pt.fixed, pt.hidden
				FROM part_type pt
				JOIN part_model pm ON pt.id = pm.part_type_id
				JOIN part_modifier mod ON pm.part_modifier_id = mod.id
				JOIN part_model_parameter pmt ON pmt.id = pm.id
				LEFT JOIN car_model cm ON cm.id = pm.car_id
				LEFT JOIN manufacturer m ON m.id = cm.manufacturer_id
				WHERE pm.id = NEW.id and pm."unique" = false;
			INSERT INTO parts_details_mat SELECT pm.id, pt.name, pm.part_type_id, pm.weight, pmt.parameter1, 
				pmt.parameter1_name, pmt.parameter1_unit, pmt.parameter2, 
				pmt.parameter2_name, pmt.parameter2_unit, pmt.parameter3, 
				pmt.parameter3_name, pmt.parameter3_unit, pm.car_id, pm.d3d_model_id, 
				pm.level, pm.price, cm.name AS car_model, m.name AS manufacturer_name, 
					mod.name AS part_modifier, pm."unique", pt.sort AS sort_part_type,
					pt.required, pt.fixed, pt.hidden,
					pmt.parameter1_is_modifier, pmt.parameter2_is_modifier, pmt.parameter3_is_modifier
				FROM part_type pt
				JOIN part_model pm ON pt.id = pm.part_type_id
				JOIN part_modifier mod ON pm.part_modifier_id = mod.id
				JOIN part_model_parameter pmt ON pmt.id = pm.id
				LEFT JOIN car_model cm ON cm.id = pm.car_id
				LEFT JOIN manufacturer m ON m.id = cm.manufacturer_id
				WHERE pm.id = NEW.id;
		END IF;
		IF TG_OP = 'DELETE' THEN 
                       DELETE FROM market_parts_mat where id = OLD.id;
		END IF;
		IF TG_OP = 'UPDATE' THEN 
                        IF NEW.id IS NULL THEN 


				RAISE EXCEPTION 'no id';
			END IF;

			DELETE FROM market_parts_mat where id = NEW.id;
			INSERT INTO market_parts_mat SELECT pm.id, pt.name, pm.part_type_id, pm.weight, pmt.parameter1, 
				pmt.parameter1_name, pmt.parameter1_unit, pmt.parameter2, 
				pmt.parameter2_name, pmt.parameter2_unit, pmt.parameter3, 
				pmt.parameter3_name, pmt.parameter3_unit, pm.car_id, pm.d3d_model_id, 
				pm.level, pm.price, cm.name AS car_model, m.name AS manufacturer_name, 
				mod.name AS part_modifier, pm."unique", pt.sort AS sort_part_type,
					pt.required, pt.fixed, pt.hidden
				FROM part_type pt
				JOIN part_model pm ON pt.id = pm.part_type_id
				JOIN part_modifier mod ON pm.part_modifier_id = mod.id
				JOIN part_model_parameter pmt ON pmt.id = pm.id
				LEFT JOIN car_model cm ON cm.id = pm.car_id
				LEFT JOIN manufacturer m ON m.id = cm.manufacturer_id
				WHERE pm.id = NEW.id and pm."unique" = false;	
				
			DELETE FROM parts_details_mat where id = NEW.id;
			INSERT INTO parts_details_mat SELECT pm.id, pt.name, pm.part_type_id, pm.weight, pmt.parameter1, 
				pmt.parameter1_name, pmt.parameter1_unit, pmt.parameter2, 
				pmt.parameter2_name, pmt.parameter2_unit, pmt.parameter3, 
				pmt.parameter3_name, pmt.parameter3_unit, pm.car_id, pm.d3d_model_id, 
				pm.level, pm.price, cm.name AS car_model, m.name AS manufacturer_name, 
					mod.name AS part_modifier, pm."unique", pt.sort AS sort_part_type,
					pt.required, pt.fixed, pt.hidden,
					pmt.parameter1_is_modifier, pmt.parameter2_is_modifier, pmt.parameter3_is_modifier
				FROM part_type pt
				JOIN part_model pm ON pt.id = pm.part_type_id
				JOIN part_modifier mod ON pm.part_modifier_id = mod.id
				JOIN part_model_parameter pmt ON pmt.id = pm.id
				LEFT JOIN car_model cm ON cm.id = pm.car_id
				LEFT JOIN manufacturer m ON m.id = cm.manufacturer_id
				WHERE pm.id = NEW.id;
		END IF;
END IF;

RETURN NULL;

END
	

$$;


ALTER FUNCTION public.mat_update_market_parts() OWNER TO postgres;

--
-- Name: FUNCTION mat_update_market_parts(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION mat_update_market_parts() IS 'CREATE OR REPLACE VIEW market_parts AS 
 SELECT pm.id, pt.name, pm.part_type_id, pm.weight, pmt.parameter1, 
 pmt.parameter1_name, pmt.parameter1_unit, pmt.parameter2, 
 pmt.parameter2_name, pmt.parameter2_unit, pmt.parameter3, 
 pmt.parameter3_name, pmt.parameter3_unit, pm.car_id, pm.d3d_model_id, 
 pm.level, pm.price, cm.name AS car_model, m.name AS manufacturer_name, 
 mod.name AS part_modifier, pm."unique", pt.sort AS sort_part_type,
					pt.required, pt.fixed, pt.hidden
   FROM part_type pt
   JOIN part_model pm ON pt.id = pm.part_type_id
   JOIN part_modifier mod ON pm.part_modifier_id = mod.id
   JOIN part_model_parameter pmt ON pmt.id = pm.id
   LEFT JOIN car_model cm ON cm.id = pm.car_id
   LEFT JOIN manufacturer m ON m.id = cm.manufacturer_id
  WHERE pm."unique" = false
  ORDER BY pm.level DESC, pm.price;

ALTER TABLE market_parts
  OWNER TO deosx;
';


--
-- Name: part_instance_update_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION part_instance_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

BEGIN

	-- perform bogus updates on car_instance rows to trigger triggers
	
	if (TG_OP = 'INSERT' or TG_OP = 'UPDATE') and (NEW.car_instance_id is not null) then
		update car_instance
		set id = NEW.car_instance_id
		where id = NEW.car_instance_id;
	end if;

	if (TG_OP = 'UPDATE' or TG_OP = 'DELETE') and (OLD.car_instance_id is not null) then
		update car_instance
		set id = OLD.car_instance_id
		where id = OLD.car_instance_id;
	end if;
	
	return NEW;

END$$;


ALTER FUNCTION public.part_instance_update_trigger() OWNER TO postgres;

--
-- Name: part_model_update_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION part_model_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

	hlvl integer;
	llvl integer;

BEGIN

	-- perform bogus updates on part_instance rows to trigger triggers
	
	if (TG_OP = 'UPDATE') then
		update part_instance
		set part_id = NEW.id
		where part_id = NEW.id;
        end if;

	if (TG_OP = 'UPDATE') or (TG_OP = 'DELETE') then
		update part_instance
		set part_id = OLD.id
		where part_id = OLD.id;
	end if;

	-- perform bogus updates on car_model rows that may be affected
	
	if (TG_OP = 'UPDATE') or (TG_OP = 'INSERT') then
		select level into llvl from part_model where level < NEW.level;
		select level into hlvl from part_model where level > NEW.level;
		update car_model set id = id where level >= llvl and level <= hlvl;
        end if;
	
	if (TG_OP = 'UPDATE') or (TG_OP = 'DELETE') then
		select level into llvl from part_model where level < OLD.level;
		select level into hlvl from part_model where level > OLD.level;
		update car_model set id = id where level >= llvl and level <= hlvl;
	end if;
	
	return NEW;

END$$;


ALTER FUNCTION public.part_model_update_trigger() OWNER TO postgres;

--
-- Name: part_properties(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION part_properties(bigint, bigint) RETURNS part_properties
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 

	parameter alias for $1;
	parameter_type_id alias for $2;
	
	res part_properties;

BEGIN

	res = part_properties_empty();

	if parameter_type_id = 1 then		-- 1;"Power";""
		res.power = (parameter :: double precision / 10000);
	elseif parameter_type_id = 6 then	-- 6;"Power modifier";""
		res.power_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 2 then	-- 2;"Handling";""
		res.handling = (parameter :: double precision / 10000);
	elseif parameter_type_id = 4 then	-- 4;"Handling modifier";""
		res.handling_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 3 then	-- 3;"Traction";""
		res.traction = (parameter :: double precision / 10000);
	elseif parameter_type_id = 10 then	-- 10;"Traction modifier";""
		res.traction_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 5 then	-- 5;"Braking";""
		res.braking = (parameter :: double precision / 10000);
	elseif parameter_type_id = 11 then	-- 11;"Braking modifier";""
		res.braking_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 8 then	-- 8;"NOS";""
		res.nos = (parameter :: double precision / 10000);
	elseif parameter_type_id = 12 then	-- 12;"NOS modifier";""
		res.nos_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 13 then	-- 13;"Aerodynamics";""
		res.aero = (parameter :: double precision / 10000);
	elseif parameter_type_id = 9 then	-- 9;"Aerodynamics modifier";""
		res.aero_m = 1 + (parameter :: double precision / 10000);
	else 					-- unknown parameter
		raise exception 'part_properties: unknown parameter type';
	end if;


RETURN res;

END$_$;


ALTER FUNCTION public.part_properties(bigint, bigint) OWNER TO postgres;

--
-- Name: part_properties(bigint, bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION part_properties(bigint, bigint, bigint, bigint) RETURNS part_properties
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 

	parameter0 alias for $1;
	parameter double precision;
	parameter_type_id alias for $2;
	improvement alias for $3;
	wear alias for $4;
	improvement_car double precision;
	wear_car double precision;
	res part_properties;

BEGIN
	SELECT "value" FROM game_config WHERE "key" = 'improvement_car' INTO improvement_car;
	SELECT "value" FROM game_config WHERE "key" = 'wear_car' INTO wear_car;

	parameter = parameter0 * (1 + improvement_car * (improvement / 10000.0)) * (1 - wear_car * (wear / 10000.0));

	res = part_properties_empty();

	if parameter_type_id = 1 then		-- 1;"Power";""
		res.power = (parameter :: double precision / 10000);
	elseif parameter_type_id = 6 then	-- 6;"Power modifier";""
		res.power_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 2 then	-- 2;"Handling";""
		res.handling = (parameter :: double precision / 10000);
	elseif parameter_type_id = 4 then	-- 4;"Handling modifier";""
		res.handling_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 3 then	-- 3;"Traction";""
		res.traction = (parameter :: double precision / 10000);
	elseif parameter_type_id = 10 then	-- 10;"Traction modifier";""
		res.traction_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 5 then	-- 5;"Braking";""
		res.braking = (parameter :: double precision / 10000);
	elseif parameter_type_id = 11 then	-- 11;"Braking modifier";""
		res.braking_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 8 then	-- 8;"NOS";""
		res.nos = (parameter :: double precision / 10000);
	elseif parameter_type_id = 12 then	-- 12;"NOS modifier";""
		res.nos_m = 1 + (parameter :: double precision / 10000);
	elseif parameter_type_id = 13 then	-- 13;"Aerodynamics";""
		res.aero = (parameter :: double precision / 10000);
	elseif parameter_type_id = 9 then	-- 9;"Aerodynamics modifier";""
		res.aero_m = 1 + (parameter :: double precision / 10000);
	else 					-- unknown parameter
		raise exception 'part_properties: unknown parameter type';
	end if;


RETURN res;

END$_$;


ALTER FUNCTION public.part_properties(bigint, bigint, bigint, bigint) OWNER TO postgres;

--
-- Name: part_properties_add(part_properties, part_properties); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION part_properties_add(part_properties, part_properties) RETURNS part_properties
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 

	l alias for $1;
	r alias for $2;
	
	res part_properties;

BEGIN

	res.power = l.power + r.power;
	res.power_m = l.power_m * r.power_m;

	res.traction = l.traction + r.traction;
	res.traction_m = l.traction_m * r.traction_m;

	res.braking = l.braking + r.braking;
	res.braking_m = l.braking_m * r.braking_m;

	res.handling = l.handling + r.handling;
	res.handling_m = l.handling_m * r.handling_m;

	res.aero = l.aero + r.aero;
	res.aero_m = l.aero_m * r.aero_m;

	res.nos = l.nos + r.nos;
	res.nos_m = l.nos_m * r.nos_m;

RETURN res;

END$_$;


ALTER FUNCTION public.part_properties_add(part_properties, part_properties) OWNER TO postgres;

--
-- Name: part_properties_empty(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION part_properties_empty() RETURNS part_properties
    LANGUAGE plpgsql IMMUTABLE
    AS $$DECLARE 
	res part_properties;
BEGIN
	res.power = 0;
	res.power_m = 1;

	res.traction = 0;
	res.traction_m = 1;

	res.braking = 0;
	res.braking_m = 1;

	res.handling = 0;
	res.handling_m = 1;

	res.aero = 0;
	res.aero_m = 1;

	res.nos = 0;
	res.nos_m = 1;

RETURN res;

END$$;


ALTER FUNCTION public.part_properties_empty() OWNER TO postgres;

--
-- Name: perform_car_repair(bigint, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perform_car_repair(bigint, integer, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	pid alias for $1;
	skill alias for $2;
	ms alias for $3;
	p car_instance_parts;
BEGIN
	
	select * into p from car_instance_parts where car_instance_id = pid and "name" = 'car';

	if p.wear > 0 then
		p.wear = greatest(0, p.wear - skill * ms);
		update part_instance set wear = p.wear where id = p.part_instance_id;
	end if;

	return not (p.wear > 0);
END$_$;


ALTER FUNCTION public.perform_car_repair(bigint, integer, bigint) OWNER TO postgres;

--
-- Name: perform_part_improve(bigint, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perform_part_improve(bigint, integer, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	pid alias for $1;
	skill alias for $2;
	ms alias for $3;
	p part_instance;
BEGIN
	
	select * into p from part_instance where id = pid;

	if p.improvement < 100000 then
		p.improvement = least(100000, p.improvement + skill * ms);
		update part_instance set improvement = p.improvement where id = p.id;
	end if;

	return not (p.improvement < 100000);
END$_$;


ALTER FUNCTION public.perform_part_improve(bigint, integer, bigint) OWNER TO postgres;

--
-- Name: perform_part_repair(bigint, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perform_part_repair(bigint, integer, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	pid alias for $1;
	skill alias for $2;
	ms alias for $3;
	p part_instance;
BEGIN
	
	select * into p from part_instance where id = pid;

	if p.wear > 0 then
		p.wear = greatest(0, p.wear - skill * ms);
		update part_instance set wear = p.wear where id = p.id;
	end if;

	return not (p.wear > 0);
END$_$;


ALTER FUNCTION public.perform_part_repair(bigint, integer, bigint) OWNER TO postgres;

--
-- Name: personnel_before(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_before() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

BEGIN

	-- on insert / update personnel or personnel_instance
	-- + calculate salary and price from skill
	-- + calculate training cost from skill
	-- + set one week paid for newly hired personnel

	NEW.salary = personnel_salary(NEW.skill_repair, NEW.skill_engineering);
	
	IF TG_RELNAME = 'personnel' THEN
		NEW.price = personnel_price(NEW.skill_repair, NEW.skill_engineering);
	END IF;

	IF TG_RELNAME = 'personnel_instance' THEN
		NEW.training_cost_repair = personnel_training_cost_repair(NEW.skill_repair);
		NEW.training_cost_engineering = personnel_training_cost_engineering(NEW.skill_engineering);

		IF TG_OP = 'INSERT' THEN
			NEW.paid_until = unix_timestamp() + 7 * 24 * 3600;
		END IF;
	END IF;
	
	RETURN NEW;
END$$;


ALTER FUNCTION public.personnel_before() OWNER TO postgres;

--
-- Name: personnel_cancel_task(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_cancel_task(bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
BEGIN

	perform personnel_update_task($1);
	perform personnel_stop_task($1);

	return true;
END$_$;


ALTER FUNCTION public.personnel_cancel_task(bigint) OWNER TO postgres;

--
-- Name: personnel_price(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_price(integer, integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 
BEGIN

	return round(personnel_salary($1, $2) / 2);

END$_$;


ALTER FUNCTION public.personnel_price(integer, integer) OWNER TO postgres;

--
-- Name: personnel_salary(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_salary(integer, integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 
	rep alias for $1;
	eng alias for $2;
BEGIN

	return 2500 + (250 * rep + 500 * eng + 5 * rep * eng);

END$_$;


ALTER FUNCTION public.personnel_salary(integer, integer) OWNER TO postgres;

--
-- Name: personnel_start_task(bigint, text, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_start_task(bigint, text, bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	pid alias for $1;
	task alias for $2;
	sid alias for $3;
	n integer;
	p personnel_instance_details;
	t personnel_task_type;
	u bigint;
	task_duration integer;
	part part_instance;
BEGIN

	-- check if task exists
	select count(*) into n from personnel_task_type where name = task;
	if not (n > 0) then
		raise exception 'task not found';
	end if;

	-- check if personnel with this id exists
	select count(*) into n from personnel_instance_details where personnel_instance_id = pid;
	if not (n > 0) then
		raise exception 'personnel not found';
	end if;

	-- check if personnel is available
	select * into p from personnel_instance_details where personnel_instance_id = pid;
	if p.task_name != 'idle' then
		raise exception 'personnel is busy';
	end if;

	-- check if subject item exists with id; ensure garage matches personnel
	if task = 'repair_part' then

--		select count(*) into n from part_instance where id = sid and (garage_id = p.garage_id or car_instance_id in (select "id" from car_instance where garage_id = p.garage_id)) and deleted = false;
		select count(*) into n from part_instance where id = sid and garage_id = p.garage_id and deleted = false;
		if not (n > 0) then
			raise exception 'part not found';
		end if;
	
	elseif task = 'improve_part' then
	
--		select count(*) into n from part_instance where id = sid and (garage_id = p.garage_id or car_instance_id in (select "id" from car_instance where garage_id = p.garage_id)) and deleted = false;
		select count(*) into n from part_instance where id = sid and garage_id = p.garage_id and deleted = false;
		if not (n > 0) then
			raise exception 'part not found';
		end if;
		
	elseif task = 'repair_car' then
	
		select count(*) into n from car_instance where id = sid and garage_id = p.garage_id and deleted = false;
		if not (n > 0) then
			raise exception 'car not found';
		end if;
	
--	elseif task = 'improve_car' then

	end if;

	-- get task
	select * into t from personnel_task_type where name = task;

	-- assign task
--	task_duration = 2 * 3600;
	task_duration = 60 * 1000;
	select (extract(epoch from now()) * 1000) :: bigint into u ;
	update personnel_instance set
		task_id = t.id,
		task_subject_id = sid,
		task_started = u,
		task_updated = u,
		task_end = u + task_duration
	where id = pid;
	
	return true;
	
END$_$;


ALTER FUNCTION public.personnel_start_task(bigint, text, bigint) OWNER TO postgres;

--
-- Name: personnel_stop_task(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_stop_task(bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	pid alias for $1;
	n integer;
	subjectid bigint;
BEGIN
	
	select count(*) into n from personnel_instance where id = pid;
	if not (n > 0) then
		raise exception 'personnel not found';
	end if;
	
	select task_subject_id from personnel_instance where id = pid into subjectid;

	update personnel_instance set
		task_id = 1,
		task_subject_id = 0,
		task_started = 0,
		task_updated = 0,
		task_end = 0
	where id = pid;
	
	insert into garage_reports (part_instance_id, personnel_instance_id) values (subjectid, pid);
	return true;
	
END$_$;


ALTER FUNCTION public.personnel_stop_task(bigint) OWNER TO postgres;

--
-- Name: personnel_train(bigint, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_train(bigint, text, text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 
	pid alias for $1;
	fld alias for $2;
	lev alias for $3;
	lo double precision;
	hi double precision;
	imp integer;
	t integer;
BEGIN

	select count(*) into t from personnel_instance where id = pid;
	if not (t > 0) then
		raise exception 'personnel not found';
	end if;

	if lev = 'low' then
		lo = 1;
		hi = 4;
	elseif lev = 'medium' then
		lo = 3;
		hi = 6;
	elseif lev = 'high' then
		lo = 5;
		hi = 8;
	else
		raise exception 'unknown training level';
	end if;

	imp := lo + floor((hi - lo + 1) * random());

	if fld = 'repair' then
		update personnel_instance set skill_repair = least(90, skill_repair + imp) where id = pid;
	elseif fld = 'engineering' then
		update personnel_instance set skill_engineering = least(90, skill_engineering + imp) where id = pid;
	else
		raise exception 'unknown training skill';
	end if;

	return true;
	
END$_$;


ALTER FUNCTION public.personnel_train(bigint, text, text) OWNER TO postgres;

--
-- Name: personnel_training_cost_engineering(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_training_cost_engineering(integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 
	skill alias for $1;
BEGIN

	return 1500 * skill;

END$_$;


ALTER FUNCTION public.personnel_training_cost_engineering(integer) OWNER TO postgres;

--
-- Name: personnel_training_cost_repair(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION personnel_training_cost_repair(integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 
	skill alias for $1;
BEGIN

	return 500 * skill;

END$_$;


ALTER FUNCTION public.personnel_training_cost_repair(integer) OWNER TO postgres;

--
-- Name: populate_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION populate_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted    integer;
	oldcount    integer;
	probed      integer;
	stale       integer;
	gcs         RECORD;
	gc          RECORD;
	gsrid       integer;
	gndims      integer;
	gtype       text;
	query       text;
	gc_is_valid boolean;

BEGIN
	SELECT count(*) INTO oldcount FROM geometry_columns;
	inserted := 0;

	EXECUTE 'TRUNCATE geometry_columns';

	-- Count the number of geometry columns in all tables and views
	SELECT count(DISTINCT c.oid) INTO probed
	FROM pg_class c,
		 pg_attribute a,
		 pg_type t,
		 pg_namespace n
	WHERE (c.relkind = 'r' OR c.relkind = 'v')
	AND t.typname = 'geometry'
	AND a.attisdropped = false
	AND a.atttypid = t.oid
	AND a.attrelid = c.oid
	AND c.relnamespace = n.oid
	AND n.nspname NOT ILIKE 'pg_temp%';

	-- Iterate through all non-dropped geometry columns
	RAISE DEBUG 'Processing Tables.....';

	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'r'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
	LOOP

	inserted := inserted + populate_geometry_columns(gcs.oid);
	END LOOP;

	-- Add views to geometry columns table
	RAISE DEBUG 'Processing Views.....';
	FOR gcs IN
	SELECT DISTINCT ON (c.oid) c.oid, n.nspname, c.relname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'v'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
	LOOP

	inserted := inserted + populate_geometry_columns(gcs.oid);
	END LOOP;

	IF oldcount > inserted THEN
	stale = oldcount-inserted;
	ELSE
	stale = 0;
	END IF;

	RETURN 'probed:' ||probed|| ' inserted:'||inserted|| ' conflicts:'||probed-inserted|| ' deleted:'||stale;
END

$$;


ALTER FUNCTION public.populate_geometry_columns() OWNER TO postgres;

--
-- Name: populate_geometry_columns(oid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION populate_geometry_columns(tbl_oid oid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	gcs         RECORD;
	gc          RECORD;
	gsrid       integer;
	gndims      integer;
	gtype       text;
	query       text;
	gc_is_valid boolean;
	inserted    integer;

BEGIN
	inserted := 0;

	-- Iterate through all geometry columns in this table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'r'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP

	RAISE DEBUG 'Processing table %.%.%', gcs.nspname, gcs.relname, gcs.attname;

	DELETE FROM geometry_columns
	  WHERE f_table_schema = gcs.nspname
	  AND f_table_name = gcs.relname
	  AND f_geometry_column = gcs.attname;

	gc_is_valid := true;

	-- Try to find srid check from system tables (pg_constraint)
	gsrid :=
		(SELECT replace(replace(split_part(s.consrc, ' = ', 2), ')', ''), '(', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%srid(% = %');
	IF (gsrid IS NULL) THEN
		-- Try to find srid from the geometry itself
		EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gsrid := gc.srid;

		-- Try to apply srid check to column
		IF (gsrid IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						 ADD CONSTRAINT ' || quote_ident('enforce_srid_' || gcs.attname) || '
						 CHECK (srid(' || quote_ident(gcs.attname) || ') = ' || gsrid || ')';
			EXCEPTION
				WHEN check_violation THEN
					RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (srid(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gsrid;
					gc_is_valid := false;
			END;
		END IF;
	END IF;

	-- Try to find ndims check from system tables (pg_constraint)
	gndims :=
		(SELECT replace(split_part(s.consrc, ' = ', 2), ')', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%ndims(% = %');
	IF (gndims IS NULL) THEN
		-- Try to find ndims from the geometry itself
		EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gndims := gc.ndims;

		-- Try to apply ndims check to column
		IF (gndims IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
						 ADD CONSTRAINT ' || quote_ident('enforce_dims_' || gcs.attname) || '
						 CHECK (ndims(' || quote_ident(gcs.attname) || ') = '||gndims||')';
			EXCEPTION
				WHEN check_violation THEN
					RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not apply constraint CHECK (ndims(%) = %)', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname), quote_ident(gcs.attname), gndims;
					gc_is_valid := false;
			END;
		END IF;
	END IF;

	-- Try to find geotype check from system tables (pg_constraint)
	gtype :=
		(SELECT replace(split_part(s.consrc, '''', 2), ')', '')
		 FROM pg_class c, pg_namespace n, pg_attribute a, pg_constraint s
		 WHERE n.nspname = gcs.nspname
		 AND c.relname = gcs.relname
		 AND a.attname = gcs.attname
		 AND a.attrelid = c.oid
		 AND s.connamespace = n.oid
		 AND s.conrelid = c.oid
		 AND a.attnum = ANY (s.conkey)
		 AND s.consrc LIKE '%geometrytype(% = %');
	IF (gtype IS NULL) THEN
		-- Try to find geotype from the geometry itself
		EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
				 FROM ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gtype := gc.geometrytype;
		--IF (gtype IS NULL) THEN
		--    gtype := 'GEOMETRY';
		--END IF;

		-- Try to apply geometrytype check to column
		IF (gtype IS NOT NULL) THEN
			BEGIN
				EXECUTE 'ALTER TABLE ONLY ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				ADD CONSTRAINT ' || quote_ident('enforce_geotype_' || gcs.attname) || '
				CHECK ((geometrytype(' || quote_ident(gcs.attname) || ') = ' || quote_literal(gtype) || ') OR (' || quote_ident(gcs.attname) || ' IS NULL))';
			EXCEPTION
				WHEN check_violation THEN
					-- No geometry check can be applied. This column contains a number of geometry types.
					RAISE WARNING 'Could not add geometry type check (%) to table column: %.%.%', gtype, quote_ident(gcs.nspname),quote_ident(gcs.relname),quote_ident(gcs.attname);
			END;
		END IF;
	END IF;

	IF (gsrid IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSIF (gndims IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the number of dimensions', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSIF (gtype IS NULL) THEN
		RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine the geometry type', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
	ELSE
		-- Only insert into geometry_columns if table constraints could be applied.
		IF (gc_is_valid) THEN
			INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
			VALUES ('', gcs.nspname, gcs.relname, gcs.attname, gndims, gsrid, gtype);
			inserted := inserted + 1;
		END IF;
	END IF;
	END LOOP;

	-- Add views to geometry columns table
	FOR gcs IN
	SELECT n.nspname, c.relname, a.attname
		FROM pg_class c,
			 pg_attribute a,
			 pg_type t,
			 pg_namespace n
		WHERE c.relkind = 'v'
		AND t.typname = 'geometry'
		AND a.attisdropped = false
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND n.nspname NOT ILIKE 'pg_temp%'
		AND c.oid = tbl_oid
	LOOP
		RAISE DEBUG 'Processing view %.%.%', gcs.nspname, gcs.relname, gcs.attname;

	DELETE FROM geometry_columns
	  WHERE f_table_schema = gcs.nspname
	  AND f_table_name = gcs.relname
	  AND f_geometry_column = gcs.attname;
	  
		EXECUTE 'SELECT ndims(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gndims := gc.ndims;

		EXECUTE 'SELECT srid(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gsrid := gc.srid;

		EXECUTE 'SELECT geometrytype(' || quote_ident(gcs.attname) || ')
				 FROM ' || quote_ident(gcs.nspname) || '.' || quote_ident(gcs.relname) || '
				 WHERE ' || quote_ident(gcs.attname) || ' IS NOT NULL LIMIT 1'
			INTO gc;
		gtype := gc.geometrytype;

		IF (gndims IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine ndims', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSIF (gsrid IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine srid', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSIF (gtype IS NULL) THEN
			RAISE WARNING 'Not inserting ''%'' in ''%.%'' into geometry_columns: could not determine gtype', quote_ident(gcs.attname), quote_ident(gcs.nspname), quote_ident(gcs.relname);
		ELSE
			query := 'INSERT INTO geometry_columns (f_table_catalog,f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type) ' ||
					 'VALUES ('''', ' || quote_literal(gcs.nspname) || ',' || quote_literal(gcs.relname) || ',' || quote_literal(gcs.attname) || ',' || gndims || ',' || gsrid || ',' || quote_literal(gtype) || ')';
			EXECUTE query;
			inserted := inserted + 1;
		END IF;
	END LOOP;

	RETURN inserted;
END

$$;


ALTER FUNCTION public.populate_geometry_columns(tbl_oid oid) OWNER TO postgres;

--
-- Name: postgis_full_version(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_full_version() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
	libver text;
	projver text;
	geosver text;
	libxmlver text;
	usestats bool;
	dbproc text;
	relproc text;
	fullver text;
BEGIN
	SELECT postgis_lib_version() INTO libver;
	SELECT postgis_proj_version() INTO projver;
	SELECT postgis_geos_version() INTO geosver;
	SELECT postgis_libxml_version() INTO libxmlver;
	SELECT postgis_uses_stats() INTO usestats;
	SELECT postgis_scripts_installed() INTO dbproc;
	SELECT postgis_scripts_released() INTO relproc;

	fullver = 'POSTGIS="' || libver || '"';

	IF  geosver IS NOT NULL THEN
		fullver = fullver || ' GEOS="' || geosver || '"';
	END IF;

	IF  projver IS NOT NULL THEN
		fullver = fullver || ' PROJ="' || projver || '"';
	END IF;

	IF  libxmlver IS NOT NULL THEN
		fullver = fullver || ' LIBXML="' || libxmlver || '"';
	END IF;

	IF usestats THEN
		fullver = fullver || ' USE_STATS';
	END IF;

	-- fullver = fullver || ' DBPROC="' || dbproc || '"';
	-- fullver = fullver || ' RELPROC="' || relproc || '"';

	IF dbproc != relproc THEN
		fullver = fullver || ' (procs from ' || dbproc || ' need upgrade)';
	END IF;

	RETURN fullver;
END
$$;


ALTER FUNCTION public.postgis_full_version() OWNER TO postgres;

--
-- Name: postgis_scripts_build_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_scripts_build_date() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '2011-10-05 11:47:27'::text AS version$$;


ALTER FUNCTION public.postgis_scripts_build_date() OWNER TO postgres;

--
-- Name: postgis_scripts_installed(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION postgis_scripts_installed() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '1.5 r7360'::text AS version$$;


ALTER FUNCTION public.postgis_scripts_installed() OWNER TO postgres;

--
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN

	SELECT count(*) INTO oldcount FROM geometry_columns;

	SELECT count(*) INTO probed
		FROM pg_class c, pg_attribute a, pg_type t,
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck

		WHERE t.typname = 'geometry'
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(srid('||a.attname||') = %)'
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'
		;

	INSERT INTO geometry_columns SELECT
		''::varchar as f_table_catalogue,
		n.nspname::varchar as f_table_schema,
		c.relname::varchar as f_table_name,
		a.attname::varchar as f_geometry_column,
		2 as coord_dimension,
		trim(both  ' =)' from
			replace(replace(split_part(
				sridcheck.consrc, ' = ', 2), ')', ''), '(', ''))::integer AS srid,
		trim(both ' =)''' from substr(typecheck.consrc,
			strpos(typecheck.consrc, '='),
			strpos(typecheck.consrc, '::')-
			strpos(typecheck.consrc, '=')
			))::varchar as type
		FROM pg_class c, pg_attribute a, pg_type t,
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck
		WHERE t.typname = 'geometry'
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE '(st_srid('||a.attname||') = %)'
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
		'((geometrytype('||a.attname||') = ''%''::text) OR (% IS NULL))'

			AND NOT EXISTS (
					SELECT oid FROM geometry_columns gc
					WHERE c.relname::varchar = gc.f_table_name
					AND n.nspname::varchar = gc.f_table_schema
					AND a.attname::varchar = gc.f_geometry_column
			);

	GET DIAGNOSTICS inserted = ROW_COUNT;

	IF oldcount > probed THEN
		stale = oldcount-probed;
	ELSE
		stale = 0;
	END IF;

	RETURN 'probed:'||probed::text||
		' inserted:'||inserted::text||
		' conflicts:'||(probed-inserted)::text||
		' stale:'||stale::text;
END

$$;


ALTER FUNCTION public.probe_geometry_columns() OWNER TO postgres;

--
-- Name: release_task(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION release_task(bigint) RETURNS void
    LANGUAGE plpgsql COST 10
    AS $_$DECLARE 
BEGIN
	update "task" set claim = 0 where id = $1;
END$_$;


ALTER FUNCTION public.release_task(bigint) OWNER TO postgres;

--
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


ALTER FUNCTION public.rename_geometry_table_constraints() OWNER TO postgres;

--
-- Name: rule_to_event_stream(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rule_to_event_stream() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 
rule_ids BIGINT;
BEGIN 

rule_ids = NEW.id;
INSERT INTO event_stream (account_id, rule_id,stream,active)
SELECT id, rule_ids, NULL, true FROM account;
return NEW;

END$$;


ALTER FUNCTION public.rule_to_event_stream() OWNER TO postgres;

--
-- Name: save_report(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION save_report() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 
part_pid bigint;
p personnel_instance_details;
pmodel part_model;
pinstance part_instance;
cmodel car_model;
cinstance car_instance;
pm text;
cman text;
pman text;
pcmodel car_model;
parttype part_type;
p1 parameter_table;
p2 parameter_table;
p3 parameter_table;
grold garage_report;
psd parts_details;
ppsd personnel_instance_details;
pidr part_instance;
BEGIN

IF TG_RELNAME = 'garage_reports' THEN 
	IF TG_OP = 'UPDATE' THEN 
	END IF;

	IF TG_OP = 'INSERT' THEN
		IF NEW.part_instance_id is null or NEW.part_instance_id = 0 then
			return null;
		END IF;
		-- Find a previous report by part_instance_id and personnel_instance_id, which is not ready.
		SELECT * from garage_report where part_instance_id = NEW.part_instance_id and personnel_instance_id = NEW.personnel_instance_id and ready = false INTO grold;
		IF grold IS NULL THEN 		
			-- get part_instance_id 
			SELECT * from part_instance where id = NEW.part_instance_id INTO pidr;
			SELECT * from parts_details where id = pidr.part_id INTO psd;
			
			SELECT * from personnel_instance_details where personnel_instance_id = NEW.personnel_instance_id INTO ppsd;
			select * from part_type where id = psd.part_type_id into parttype;

			INSERT INTO garage_report (account_id, report_type_id, personnel_instance_id, part_instance_id, ready, data, task, report_descriptor, time) VALUES
			(NEW.account_id, 3, NEW.personnel_instance_id, NEW.part_instance_id, false, hstore(psd) || hstore(ppsd) || hstore(pidr) || hstore('part_type', parttype.name) , NEW.task,
			NEW.report_descriptor, extract(epoch from now()));
			
		ELSE 
			SELECT * from part_instance where id = NEW.part_instance_id INTO pidr;
			
			UPDATE garage_report set ready = true, data = data || hstore('improvement_change', (pidr.improvement - ((grold.data -> 'improvement') :: numeric)) :: text ) || hstore('wear_change', (pidr.wear - ((grold.data -> 'wear') :: numeric)) :: text) where id = grold.id;
			RETURN null;
		END IF;
		
	END IF;

	IF TG_OP = 'DELETE' THEN 

	END IF;
END IF;

IF TG_RELNAME = 'shopping_reports' THEN
	IF TG_OP = 'UPDATE' THEN 
		RAISE EXCEPTION 'suck on that';
	END IF;
	IF TG_OP = 'INSERT' THEN 
		-- get part_instance and model with: 
		-- NEW.part_instance_id -> part_id <|> New.part_id
		SELECT part_id from part_instance where id = NEW.part_instance_id INTO part_pid;
		SELECT * from part_instance where id = NEW.part_instance_id INTO pinstance;
		SELECT * from part_model where id = coalesce(pinstance.part_id, NEW.part_id) INTO pmodel;
		select * from part_type where id = pmodel.part_type_id into parttype;
		
		SELECT name from part_modifier where id = pmodel.part_modifier_id INTO pm;

		select * from parameter_table where id = pmodel.parameter1_type_id INTO p1;
		select * from parameter_table where id = pmodel.parameter2_type_id  INTO p2;
		select * from parameter_table where id = pmodel.parameter3_type_id  INTO p3;
		
		select * from car_model where id = pmodel.car_id into pcmodel;
		select name from manufacturer where id = pcmodel.manufacturer_id into pman;
		

		
		SELECT * from car_instance where id = NEW.car_instance_id INTO cinstance;
		SELECT * from car_model where id = coalesce(cinstance.car_id, NEW.car_id) INTO cmodel;
		
		SELECT name from manufacturer where id = cmodel.manufacturer_id INTO cman;
		
		INSERT INTO shop_report (account_id, report_type_id, time, report_descriptor, part_instance_id, part_id,amount,car_instance_id, data, car_data) 
			VALUES (NEW.account_id, 1, extract(epoch from NOW()), NEW.report_descriptor, NEW.part_instance_id, 
			coalesce(part_pid, NEW.part_id),NEW.amount,NEW.car_instance_id, 
			hstore(pmodel) 
			|| hstore(pinstance) 
			|| hstore('part_modifier', pm) 
			|| hstore('car_model', pcmodel.name) 
			|| hstore('manufacturer_name', pman) 
			|| hstore('part_type' , parttype.name)
			|| hstore('parameter1_name' , p1.name)
			|| hstore('parameter1_type' , p1.unit)
			|| hstore('parameter2_name' , p2.name)
			|| hstore('parameter2_type' , p2.unit)
			|| hstore('parameter3_name' , p3.name)
			|| hstore('parameter3_type' , p3.unit)
			|| hstore('parameter1_modifier' , p1.modifier :: text)
			|| hstore('parameter2_modifier' , p2.modifier :: text)
			|| hstore('parameter3_modifier' , p3.modifier :: text)
			, 
			hstore(cmodel) || hstore(cinstance) || hstore('manufacturer_name',cman)
			 );
	END IF;

	IF TG_OP = 'DELETE' THEN 
		RAISE EXCEPTION 'suck on that';
	END IF; 
	
END IF;


IF TG_RELNAME = 'personnel_reports' THEN
	IF TG_OP = 'UPDATE' THEN 
		RAISE EXCEPTION 'suck on that';
	END IF;
	IF TG_OP = 'INSERT' THEN 
	         SELECT * from personnel_instance_details where personnel_instance_id = NEW.personnel_instance_id INTO p;
		 INSERT INTO personnel_report (account_id, report_type_id, time,  report_descriptor, part_instance_id, personnel_instance_id, cost, result, data) 
		 VALUES (NEW.account_id, 2, extract(epoch from NOW()),  NEW.report_descriptor, NEW.part_instance_id, 
				NEW.personnel_instance_id, NEW.cost, NEW.result, 
				hstore(p) || hstore('type' , NEW.data));
	END IF;

	IF TG_OP = 'DELETE' THEN 
		RAISE EXCEPTION 'suck on that';
	END IF; 
	
END IF;
RETURN null;
END $$;


ALTER FUNCTION public.save_report() OWNER TO postgres;

--
-- Name: save_travel_report(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION save_travel_report() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

kanker1 text;
kanker2 text;
kenker3 text;
kenker4 text;

BEGIN 

IF NEW.city <> OLD.city THEN

	SELECT name FROM city WHERE id = NEW.city INTO kanker2;
	SELECT name FROM city WHERE id = OLD.city INTO kanker1;
	SELECT continent.name FROM continent JOIN city on city.continent_id = continent.id where city.id = NEW.city INTO kenker3;
	SELECT continent.name FROM continent JOIN city on city.continent_id = continent.id where city.id = OLD.city INTO kenker4;
	INSERT INTO travel_report (account_id, report_type_id, time, report_descriptor, 
					city_to, city_from, continent_to, continent_from) VALUES 
					(NEW.id, 4, extract(epoch from now()), 'travel_report', kanker2, kanker1, kenker3, kenker4);
END IF;

RETURN NEW;

END$$;


ALTER FUNCTION public.save_travel_report() OWNER TO postgres;

--
-- Name: set_default_values_account(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_default_values_account() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

DEF account; 

BEGIN

SELECT * INTO DEF FROM account WHERE id = 0;

NEW.level := DEF.level;
NEW.skill_acceleration := DEF.skill_acceleration;
NEW.skill_braking := DEF.skill_braking;
NEW.skill_control := DEF.skill_control;
NEW.skill_reactions := DEF.skill_reactions;
NEW.skill_intelligence := DEF.skill_intelligence;
NEW.money := DEF.money;
NEW.respect := DEF.respect;
NEW.energy := DEF.energy;
NEW.max_energy = DEF.max_energy;
NEW.energy_recovery = DEF.energy_recovery;
NEW.energy_updated = DEF.energy_updated;
NEW.busy_until = DEF.busy_until;
NEW.skill_unused := DEF.skill_unused;
NEW.city := DEF.city;
NEW.busy_type := DEF.busy_type;
NEW.free_car := DEF.free_car;

RETURN NEW;

END$$;


ALTER FUNCTION public.set_default_values_account() OWNER TO postgres;

--
-- Name: st_area(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_area(text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Area($1::geometry);  $_$;


ALTER FUNCTION public.st_area(text) OWNER TO postgres;

--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);  $_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO postgres;

--
-- Name: st_asgeojson(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgeojson(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsGeoJson($1::geometry);  $_$;


ALTER FUNCTION public.st_asgeojson(text) OWNER TO postgres;

--
-- Name: st_asgml(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asgml(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsGML($1::geometry);  $_$;


ALTER FUNCTION public.st_asgml(text) OWNER TO postgres;

--
-- Name: st_askml(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_askml(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsKML($1::geometry);  $_$;


ALTER FUNCTION public.st_askml(text) OWNER TO postgres;

--
-- Name: st_assvg(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_assvg(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsSVG($1::geometry);  $_$;


ALTER FUNCTION public.st_assvg(text) OWNER TO postgres;

--
-- Name: st_astext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_astext(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);  $_$;


ALTER FUNCTION public.st_astext(text) OWNER TO postgres;

--
-- Name: st_coveredby(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_coveredby(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_CoveredBy($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_coveredby(text, text) OWNER TO postgres;

--
-- Name: st_covers(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_covers(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_Covers($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_covers(text, text) OWNER TO postgres;

--
-- Name: st_distance(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_distance(text, text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Distance($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_distance(text, text) OWNER TO postgres;

--
-- Name: st_dwithin(text, text, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_dwithin(text, text, double precision) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_DWithin($1::geometry, $2::geometry, $3);  $_$;


ALTER FUNCTION public.st_dwithin(text, text, double precision) OWNER TO postgres;

--
-- Name: st_intersects(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_intersects(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$ SELECT ST_Intersects($1::geometry, $2::geometry);  $_$;


ALTER FUNCTION public.st_intersects(text, text) OWNER TO postgres;

--
-- Name: st_length(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length(text) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_Length($1::geometry);  $_$;


ALTER FUNCTION public.st_length(text) OWNER TO postgres;

--
-- Name: tasks_in_progress(bigint, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tasks_in_progress(bigint, integer, bigint) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $_$DECLARE 
BEGIN
	
	return (select count(*) > 0 from task
		where deleted = false
			and claim = 0
			and time <= $1
			and id in (select task_id from task_trigger where type = $2 and $3 in (0, target_id)));

END$_$;


ALTER FUNCTION public.tasks_in_progress(bigint, integer, bigint) OWNER TO postgres;

--
-- Name: temp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION temp() RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE
	t integer;
	r part_model;
BEGIN
	FOR r IN SELECT * from part_model where part_type_id = 16 limit 100
		LOOP
			delete from part_model where id = r.id;
		END LOOP;
END$$;


ALTER FUNCTION public.temp() OWNER TO postgres;

--
-- Name: temp_asd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION temp_asd() RETURNS boolean
    LANGUAGE plpgsql
    AS $$ 
BEGIN
FOR i IN 55641 .. 60717 LOOP 

update part_model set d3d_model_id = random()*5 where id = i; 


RETURN 1;
COMMIT;

END LOOP;

END;
$$;


ALTER FUNCTION public.temp_asd() OWNER TO postgres;

--
-- Name: test1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION test1() RETURNS SETOF text
    LANGUAGE plpgsql STABLE
    AS $$DECLARE 
BEGIN

	return next 'lala';
	return next 'blabla';
	return next 'barz';
	return;

END$$;


ALTER FUNCTION public.test1() OWNER TO postgres;

--
-- Name: trigger_track_time_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION trigger_track_time_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 
BEGIN
	-- update top time for this track if appropriate
	if (select (not top_time_exists) or (top_time > NEW.time) as test from track_master where track_id = NEW.track_id) then
		update track set top_time_id = NEW.id where id = NEW.track_id;
	end if;

	-- delete old records
	
	return NEW;
END$$;


ALTER FUNCTION public.trigger_track_time_insert() OWNER TO postgres;

--
-- Name: unix_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION unix_timestamp() RETURNS bigint
    LANGUAGE sql STABLE
    AS $$select extract(epoch FROM now())::bigint;$$;


ALTER FUNCTION public.unix_timestamp() OWNER TO postgres;

--
-- Name: unlockrows(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION unlockrows(text) RETURNS integer
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE
	ret int;
BEGIN

	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION 'Long transaction support disabled, use EnableLongTransaction() to enable.';
	END IF;

	EXECUTE 'DELETE FROM authorization_table where authid = ' ||
		quote_literal($1);

	GET DIAGNOSTICS ret = ROW_COUNT;

	RETURN ret;
END;
$_$;


ALTER FUNCTION public.unlockrows(text) OWNER TO postgres;

--
-- Name: update_car_instance(car_instance); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_car_instance(car_instance) RETURNS car_instance
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE 

	ins alias for $1;

	res car_instance;

	pt part_properties;
	p part_properties;
	m car_model;
	cip car_instance_parts;
	carp car_properties;

	weight double precision;
	price double precision;

BEGIN

	res = ins;

	-- get car model
	select * into m from car_model where id = ins.car_id;
	res.weight = m.base_weight;
	res.price = m.base_price;

	-- get part instances
	for cip in
		select * from car_instance_parts where car_instance_id = ins.id
	loop
		res.weight = res.weight + cip.weight;
		res.price = res.price + cip.price;
	end loop;
	
	-- get all part parameters for part instances
	p = part_properties_empty();
	for pt in
		select (part_properties(parameter, parameter_type_id)).* from car_instance_parameter_list where id = ins.id
	loop
		p = part_properties_add(p, pt);
	end loop;

	-- get car properties from cumulative weight and part properties
	carp = car_properties(res.weight, p);

	res.top_speed = carp.top_speed :: integer;
	res.acceleration = carp.acceleration :: integer;
	res.braking = carp.braking :: integer;
	res.handling = carp.handling :: integer;
	res.nos = carp.nos :: integer;

	return res;

END$_$;


ALTER FUNCTION public.update_car_instance(car_instance) OWNER TO postgres;

--
-- Name: update_car_instance(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_car_instance(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE 

	i alias for $1;
	ci car_instance;

BEGIN

	ci = get_updated_car_instance(i);
	update car_instance
		set
			weight = ci.weight,
			price = ci.price,
			top_speed = ci.top_speed,
			acceleration = ci.acceleration,
			handling = ci.handling,
			braking = ci.braking,
			nos = ci.nos
		where id = i;

END$_$;


ALTER FUNCTION public.update_car_instance(integer) OWNER TO postgres;

--
-- Name: update_car_model(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_car_model() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

	pmr part_model;
	plr car_instance_parameter_list;
	
	weight integer;
	price integer;

	power double precision;
	power_m double precision;
	traction double precision;
	traction_m double precision;
	handling double precision;
	handling_m double precision;
	aero double precision;
	aero_m double precision;
	braking double precision;
	braking_m double precision;
	nos double precision;
	nos_m double precision;
    
BEGIN

	weight = NEW.base_weight;
	price = NEW.base_price;

	power = 0;
	traction = 0;
	braking = 0;
	handling = 0;
	aero = 0;
	nos = 0;

	power_m = 1;
	traction_m = 1;
	braking_m = 1;
	handling_m = 1;
	aero_m = 1;
	nos_m = 1;

    	-- get stock parts for current car
	for pmr in select * from get_car_stock_parts(NEW.id) loop
		weight = weight + pmr.weight;
		price = price + pmr.price;
	end loop;

	-- get parameters for current car's stock parts
	for plr in select * from get_car_model_param_list(NEW.id) loop

		if plr.parameter_type_id = 1 then -- 1;"Power";""
			power = power + plr.parameter;
		elseif plr.parameter_type_id = 6 then	-- 6;"Power modifier";""
			power_m = power_m * (1 + (plr.parameter :: double precision / 100.0));
		elseif plr.parameter_type_id = 2 then	-- 2;"Handling";""
			handling = handling + plr.parameter;
		elseif plr.parameter_type_id = 4 then	-- 4;"Handling modifier";""
			handling_m = handling_m * (1 + (plr.parameter :: double precision / 100.0));
		elseif plr.parameter_type_id = 3 then	-- 3;"Traction";""
			traction = traction + plr.parameter;
		elseif plr.parameter_type_id = 10 then	-- 10;"Traction modifier";""
			traction_m = traction_m * (1 + (plr.parameter :: double precision / 100.0));
		elseif plr.parameter_type_id = 5 then	-- 5;"Braking";""
			braking = braking + plr.parameter;
		elseif plr.parameter_type_id = 11 then	-- 11;"Braking modifier";""
			braking_m = braking_m * (1 + (plr.parameter :: double precision / 100.0));
		elseif plr.parameter_type_id = 8 then	-- 8;"NOS";""
			nos = nos + plr.parameter;
		elseif plr.parameter_type_id = 12 then	-- 12;"NOS modifier";""
			nos_m = nos_m * (1 + (plr.parameter :: double precision / 100.0));
		elseif plr.parameter_type_id = 13 then	-- 13;"Aerodynamics";""
			aero = aero * plr.parameter;
		elseif plr.parameter_type_id = 9 then	-- 9;"Aerodynamics modifier";""
			aero_m = aero_m * (1 + (plr.parameter :: double precision / 100.0));
		else -- unknown parameter
			raise exception 'car_instance_parameter_list: unknown parameter type';
		end if;
			
	end loop;
	
	-- calculate real values
	power = power * power_m;
	traction = traction * traction_m;
	braking = braking * braking_m;
	handling = handling * handling_m;
	aero = aero * aero_m;
	nos = nos * nos_m;
	
	-- put car stats
	NEW.weight = weight;
	NEW.price = price;

	NEW.top_speed = car_top_speed(weight, power, traction, braking, handling, aero, nos) :: integer;
	NEW.acceleration = car_acceleration(weight, power, traction, braking, handling, aero, nos) :: integer;
	NEW.braking = car_braking(weight, power, traction, braking, handling, aero, nos) :: integer;
	NEW.handling = car_handling(weight, power, traction, braking, handling, aero, nos) :: integer;
	NEW.nos = car_nos(weight, power, traction, braking, handling, aero, nos) :: integer;

RETURN NEW;

END$$;


ALTER FUNCTION public.update_car_model() OWNER TO postgres;

--
-- Name: update_car_stats(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_car_stats(bigint) RETURNS boolean
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
    car alias for $1;
BEGIN

    update car_instance
    set
        top_speed = round(100 * random()),
        acceleration = round(100 * random()),
        braking = round(100 * random()),
        handling = round(100 * random()),
        nos = round(100 * random())
    where id = car;

    return true;
END;
$_$;


ALTER FUNCTION public.update_car_stats(bigint) OWNER TO postgres;

--
-- Name: update_label_manufacturer(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_label_manufacturer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN 

IF NEW.name  is NULL THEN 
  RAISE EXCEPTION 'name cannot be null';
END IF; 

NEW.label := lower(replace(NEW.name, ' ', '_'));

RETURN NEW;

END$$;


ALTER FUNCTION public.update_label_manufacturer() OWNER TO postgres;

--
-- Name: update_market_part_instance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_market_part_instance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

aid bigint;

BEGIN 

IF NEW.part_instance_id  is NULL THEN 
  RAISE EXCEPTION 'part_instance cannot be null';
END IF; 

SELECT account_id FROM part_instance WHERE id = NEW.part_instance_id INTO aid;


NEW.account_id = aid;


RETURN NEW;

END$$;


ALTER FUNCTION public.update_market_part_instance() OWNER TO postgres;

--
-- Name: update_part_instance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_part_instance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

aid bigint;

BEGIN 

IF NEW.garage_id  is NULL THEN 
  RAISE EXCEPTION 'garage cannot be null';
END IF; 

SELECT account_id FROM garage WHERE id = NEW.garage_id INTO aid;


NEW.account_id = aid;


RETURN NEW;

END$$;


ALTER FUNCTION public.update_part_instance() OWNER TO postgres;

--
-- Name: update_track_length(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_track_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 
trackid BIGINT;
track_length FLOAT;

BEGIN

trackid := NEW.track_id;

SELECT sum(length) FROM track_section WHERE track_id = trackid INTO track_length;

UPDATE track SET length=track_length where id = trackid;

return NEW;

END$$;


ALTER FUNCTION public.update_track_length() OWNER TO postgres;

--
-- Name: updategeometrysrid(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT UpdateGeometrySRID('','',$1,$2,$3) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.updategeometrysrid(character varying, character varying, integer) OWNER TO postgres;

--
-- Name: updategeometrysrid(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	ret  text;
BEGIN
	SELECT UpdateGeometrySRID('',$1,$2,$3,$4) into ret;
	RETURN ret;
END;
$_$;


ALTER FUNCTION public.updategeometrysrid(character varying, character varying, character varying, integer) OWNER TO postgres;

--
-- Name: updategeometrysrid(character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION updategeometrysrid(character varying, character varying, character varying, character varying, integer) RETURNS text
    LANGUAGE plpgsql STRICT
    AS $_$
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	myrec RECORD;
	okay boolean;
	cname varchar;
	real_schema name;

BEGIN


	-- Find, check or fix schema_name
	IF ( schema_name != '' ) THEN
		okay = 'f';

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := 't';
		END LOOP;

		IF ( okay <> 't' ) THEN
			RAISE EXCEPTION 'Invalid schema name';
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT INTO real_schema current_schema()::text;
	END IF;

	-- Find out if the column is in the geometry_columns table
	okay = 'f';
	FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := 't';
	END LOOP;
	IF (okay <> 't') THEN
		RAISE EXCEPTION 'column not found in geometry_columns table';
		RETURN 'f';
	END IF;

	-- Update ref from geometry_columns table
	EXECUTE 'UPDATE geometry_columns SET SRID = ' || new_srid::text ||
		' where f_table_schema = ' ||
		quote_literal(real_schema) || ' and f_table_name = ' ||
		quote_literal(table_name)  || ' and f_geometry_column = ' ||
		quote_literal(column_name);

	-- Make up constraint name
	cname = 'enforce_srid_'  || column_name;

	-- Drop enforce_srid constraint
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
		'.' || quote_ident(table_name) ||
		' DROP constraint ' || quote_ident(cname);

	-- Update geometries SRID
	EXECUTE 'UPDATE ' || quote_ident(real_schema) ||
		'.' || quote_ident(table_name) ||
		' SET ' || quote_ident(column_name) ||
		' = setSRID(' || quote_ident(column_name) ||
		', ' || new_srid::text || ')';

	-- Reset enforce_srid constraint
	EXECUTE 'ALTER TABLE ' || quote_ident(real_schema) ||
		'.' || quote_ident(table_name) ||
		' ADD constraint ' || quote_ident(cname) ||
		' CHECK (srid(' || quote_ident(column_name) ||
		') = ' || new_srid::text || ')';

	RETURN real_schema || '.' || table_name || '.' || column_name ||' SRID changed to ' || new_srid::text;

END;
$_$;


ALTER FUNCTION public.updategeometrysrid(character varying, character varying, character varying, character varying, integer) OWNER TO postgres;

--
-- Name: access; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE access (
    id bigint NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.access OWNER TO postgres;

--
-- Name: access_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE access_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_id_seq OWNER TO postgres;

--
-- Name: access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE access_id_seq OWNED BY access.id;


--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE account (
    id bigint NOT NULL,
    firstname text,
    lastname text,
    nickname text NOT NULL,
    picture_small text,
    picture_medium text,
    picture_large text,
    level integer,
    skill_acceleration integer,
    skill_braking integer,
    skill_control integer,
    skill_reactions integer,
    skill_intelligence integer,
    money bigint,
    respect integer,
    diamonds integer NOT NULL,
    energy integer,
    max_energy integer,
    energy_recovery integer NOT NULL,
    energy_updated integer NOT NULL,
    busy_until bigint NOT NULL,
    password text NOT NULL,
    email text NOT NULL,
    skill_unused integer DEFAULT 0 NOT NULL,
    till integer DEFAULT 0,
    city bigint DEFAULT 1 NOT NULL,
    busy_type bigint DEFAULT 1 NOT NULL,
    busy_subject_id bigint DEFAULT 0 NOT NULL,
    free_car boolean DEFAULT true NOT NULL,
    bot boolean DEFAULT false NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: account_busy_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE account_busy_type (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.account_busy_type OWNER TO postgres;

--
-- Name: account_busy_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE account_busy_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_busy_type_id_seq OWNER TO postgres;

--
-- Name: account_busy_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE account_busy_type_id_seq OWNED BY account_busy_type.id;


--
-- Name: account_current_energy; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW account_current_energy AS
    SELECT account.id AS account_id, (account.energy / 1000) AS current_energy, account.till, (account.max_energy / 1000) AS max_energy FROM account;


ALTER TABLE public.account_current_energy OWNER TO postgres;

--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE city (
    id bigint NOT NULL,
    continent_id bigint,
    level integer,
    name text NOT NULL,
    "default" boolean DEFAULT false,
    data text DEFAULT ''::text
);


ALTER TABLE public.city OWNER TO postgres;

--
-- Name: continent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE continent (
    id bigint NOT NULL,
    name text NOT NULL,
    data text DEFAULT ''::text
);


ALTER TABLE public.continent OWNER TO postgres;

--
-- Name: account_garage; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW account_garage AS
    SELECT a.id, a.firstname, a.lastname, a.nickname, a.picture_small, a.picture_medium, a.picture_large, a.level, a.skill_acceleration, a.skill_braking, a.skill_control, a.skill_reactions, a.skill_intelligence, a.money, a.respect, a.diamonds, (a.energy / 1000) AS energy, (a.max_energy / 1000) AS max_energy, a.energy_recovery, a.energy_updated, a.busy_until, a.email, a.skill_unused, a.till, cy.id AS city_id, cy.name AS city_name, cn.id AS continent_id, cn.name AS continent_name, cy.data AS city_data, cn.data AS continent_data, a.busy_subject_id, bt.name AS busy_type, GREATEST((0)::bigint, (a.busy_until - unix_timestamp())) AS busy_timeleft, a.free_car, g.id AS garage_id FROM ((((account a LEFT JOIN city cy ON ((a.city = cy.id))) LEFT JOIN continent cn ON ((cy.continent_id = cn.id))) LEFT JOIN account_busy_type bt ON ((a.busy_type = bt.id))) LEFT JOIN garage g ON ((g.account_id = a.id)));


ALTER TABLE public.account_garage OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_id_seq OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE account_id_seq OWNED BY account.id;


--
-- Name: account_profile; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW account_profile AS
    SELECT a.id, a.firstname, a.lastname, a.nickname, a.picture_small, a.picture_medium, a.picture_large, a.level, a.skill_acceleration, a.skill_braking, a.skill_control, a.skill_reactions, a.skill_intelligence, a.money, a.respect, a.diamonds, (a.energy / 1000) AS energy, (a.max_energy / 1000) AS max_energy, a.energy_recovery, a.energy_updated, a.busy_until, a.email, a.skill_unused, a.till, cy.id AS city_id, cy.name AS city_name, cn.id AS continent_id, cn.name AS continent_name, cy.data AS city_data, cn.data AS continent_data, a.busy_subject_id, bt.name AS busy_type, GREATEST((0)::bigint, (a.busy_until - unix_timestamp())) AS busy_timeleft, a.free_car FROM (((account a LEFT JOIN city cy ON ((a.city = cy.id))) LEFT JOIN continent cn ON ((cy.continent_id = cn.id))) LEFT JOIN account_busy_type bt ON ((a.busy_type = bt.id)));


ALTER TABLE public.account_profile OWNER TO postgres;

--
-- Name: action; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE action (
    id bigint NOT NULL,
    reward_id bigint,
    rule_id bigint,
    change bigint,
    name text
);


ALTER TABLE public.action OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_id_seq OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE action_id_seq OWNED BY action.id;


--
-- Name: application; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE application (
    id bigint NOT NULL,
    platform text,
    token text
);


ALTER TABLE public.application OWNER TO postgres;

--
-- Name: application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.application_id_seq OWNER TO postgres;

--
-- Name: application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE application_id_seq OWNED BY application.id;


--
-- Name: manufacturer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE manufacturer (
    id bigint NOT NULL,
    name text,
    picture text,
    text text,
    label text
);


ALTER TABLE public.manufacturer OWNER TO postgres;

--
-- Name: car_3d_model; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_3d_model AS
    SELECT ci.id, pt.name, gen_part_instance_3d_model(pt.id, pt.name, (pm.d3d_model_id)::bigint, pt.use_3d, cm.name, mf.name) AS use_3d, pi.id AS part_instance_id, pm.id AS part_model_id, pm.part_type_id FROM (((((part_instance pi LEFT JOIN part_model pm ON ((pm.id = pi.part_id))) LEFT JOIN part_type pt ON ((pt.id = pm.part_type_id))) LEFT JOIN car_model cm ON ((pm.car_id = cm.id))) LEFT JOIN manufacturer mf ON ((cm.manufacturer_id = mf.id))) LEFT JOIN car_instance ci ON ((pi.car_instance_id = ci.id))) WHERE (pi.deleted = false);


ALTER TABLE public.car_3d_model OWNER TO postgres;

--
-- Name: car_instance_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_instance_details AS
    SELECT ci.id, ci.car_id, ci.garage_id, ci.top_speed, ci.acceleration, ci.stopping AS braking, ci.cornering AS handling, ci.nitrous AS nos, ci.price, ci.weight, ci.deleted, m.name AS manufacturer_name, cm.year, cm.name, cm.level, ci.wear, ci.improvement, ci.active FROM ((car_instance ci JOIN car_model cm ON ((ci.car_id = cm.id))) JOIN manufacturer m ON ((cm.manufacturer_id = m.id)));


ALTER TABLE public.car_instance_details OWNER TO postgres;

--
-- Name: car_3d_model_backup; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_3d_model_backup AS
    (SELECT ci.id, pt.name, (((((pt.use_3d || '/'::text) || btrim(pt.name)) || '_'::text) || pm.d3d_model_id) || '.unity3d'::text) AS use_3d, pi.id AS part_instance_id, pm.part_type_id FROM (((car_instance ci JOIN part_instance pi ON ((pi.car_instance_id = ci.id))) JOIN part_model pm ON ((pm.id = pi.part_id))) JOIN part_type pt ON ((pt.id = pm.part_type_id))) WHERE (pt.use_3d <> ''::text) UNION SELECT ci.id, 'car'::text AS name, (('cars'::text || '/'::text) || replace(btrim(lower(((((ci.manufacturer_name || ' '::text) || btrim(cm.name)) || '/'::text) || 'car.unity3d'::text))), ' '::text, '_'::text)) AS use_3d, 0 AS part_instance_id, 0 AS part_type_id FROM (car_instance_details ci JOIN car_model cm ON ((ci.car_id = cm.id)))) UNION SELECT ci.id, 'body_kit'::text AS name, (('cars'::text || '/'::text) || replace(btrim(lower(((((ci.manufacturer_name || ' '::text) || btrim(cm.name)) || '/'::text) || 'body_kit_0.unity3d'::text))), ' '::text, '_'::text)) AS use_3d, 0 AS part_instance_id, 99 AS part_type_id FROM (car_instance_details ci JOIN car_model cm ON ((ci.car_id = cm.id)));


ALTER TABLE public.car_3d_model_backup OWNER TO postgres;

--
-- Name: car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_id_seq OWNER TO postgres;

--
-- Name: car_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE car_id_seq OWNED BY car_model.id;


--
-- Name: car_in_garage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE car_in_garage (
    id bigint,
    car_id bigint,
    garage_id bigint,
    top_speed integer,
    acceleration integer,
    stopping integer,
    cornering integer,
    nitrous integer,
    manufacturer_name text,
    name text,
    parts_price numeric,
    total_price numeric,
    manufacturer_picture text,
    account_id bigint,
    level integer,
    year integer,
    wear integer,
    improvement integer,
    active boolean,
    ready boolean,
    car_color text,
    power integer,
    traction integer,
    handling integer,
    braking integer,
    aero integer,
    nos integer,
    weight integer,
    car_label text,
    prototype boolean,
    prototype_name text,
    prototype_claimable boolean,
    prototype_available boolean,
    manufacturer_id bigint,
    parts_level integer
);


ALTER TABLE public.car_in_garage OWNER TO postgres;

--
-- Name: car_instance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE car_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_instance_id_seq OWNER TO postgres;

--
-- Name: car_instance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE car_instance_id_seq OWNED BY car_instance.id;


--
-- Name: parameter_table; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE parameter_table (
    id bigint NOT NULL,
    name text,
    unit text,
    modifier boolean
);


ALTER TABLE public.parameter_table OWNER TO postgres;

--
-- Name: part_model_parameter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW part_model_parameter AS
    SELECT pm.id, pm.parameter1, pt1.name AS parameter1_name, pt1.unit AS parameter1_unit, pm.parameter2, pt2.name AS parameter2_name, pt2.unit AS parameter2_unit, pm.parameter3, pt3.name AS parameter3_name, pt3.unit AS parameter3_unit, pt1.id AS parameter1_type_id, pt2.id AS parameter2_type_id, pt3.id AS parameter3_type_id, pt1.modifier AS parameter1_is_modifier, pt2.modifier AS parameter2_is_modifier, pt3.modifier AS parameter3_is_modifier FROM (((part_model pm LEFT JOIN parameter_table pt1 ON ((pt1.id = pm.parameter1_type_id))) LEFT JOIN parameter_table pt2 ON ((pt2.id = pm.parameter2_type_id))) LEFT JOIN parameter_table pt3 ON ((pt3.id = pm.parameter3_type_id)));


ALTER TABLE public.part_model_parameter OWNER TO postgres;

--
-- Name: car_instance_parameter; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_instance_parameter AS
    SELECT ci.id, ci.car_id, pi.part_id, pmp.parameter1, pmp.parameter1_type_id, pmp.parameter1_name, pmp.parameter2, pmp.parameter2_type_id, pmp.parameter2_name, pmp.parameter3, pmp.parameter3_type_id, pmp.parameter3_name, pi.improvement, pi.wear FROM ((car_instance ci JOIN part_instance pi ON ((pi.car_instance_id = ci.id))) LEFT JOIN part_model_parameter pmp ON ((pi.part_id = pmp.id)));


ALTER TABLE public.car_instance_parameter OWNER TO postgres;

--
-- Name: car_instance_parameter_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_instance_parameter_list AS
    (SELECT c.id, c.car_id, c.part_id, c.improvement, c.wear, c.parameter1 AS parameter, c.parameter1_type_id AS parameter_type_id, c.parameter1_name AS parameter_name FROM car_instance_parameter c WHERE (c.parameter1 IS NOT NULL) UNION SELECT c.id, c.car_id, c.part_id, c.improvement, c.wear, c.parameter2 AS parameter, c.parameter2_type_id AS parameter_type_id, c.parameter2_name AS parameter_name FROM car_instance_parameter c WHERE (c.parameter2 IS NOT NULL)) UNION SELECT c.id, c.car_id, c.part_id, c.improvement, c.wear, c.parameter3 AS parameter, c.parameter3_type_id AS parameter_type_id, c.parameter3_name AS parameter_name FROM car_instance_parameter c WHERE (c.parameter3 IS NOT NULL);


ALTER TABLE public.car_instance_parameter_list OWNER TO postgres;

--
-- Name: market_parts_mat; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE market_parts_mat (
    id bigint NOT NULL,
    name text,
    part_type_id bigint,
    weight integer,
    parameter1 integer,
    parameter1_name text,
    parameter1_unit text,
    parameter2 integer,
    parameter2_name text,
    parameter2_unit text,
    parameter3 integer,
    parameter3_name text,
    parameter3_unit text,
    car_id bigint,
    d3d_model_id integer,
    level integer,
    price integer,
    car_model text,
    manufacturer_name text,
    part_modifier text,
    "unique" boolean,
    sort_part_type integer,
    required boolean DEFAULT false,
    fixed boolean DEFAULT false,
    hidden boolean DEFAULT false
);


ALTER TABLE public.market_parts_mat OWNER TO postgres;

--
-- Name: TABLE market_parts_mat; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE market_parts_mat IS 'Marterialized lazy view';


--
-- Name: market_part_types; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_part_types AS
    SELECT market_parts.car_id, market_parts.name, min(market_parts.level) AS level, market_parts.sort_part_type FROM market_parts_mat market_parts WHERE (market_parts.hidden = false) GROUP BY market_parts.car_id, market_parts.name, market_parts.sort_part_type;


ALTER TABLE public.market_part_types OWNER TO postgres;

--
-- Name: car_market; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_market AS
    SELECT m.name AS manufacturer_name, c.id, c.manufacturer_id, c.top_speed, c.acceleration, c.braking, c.nos, c.handling, c.name, c.use_3d, c.level, c.year, m.label, c.price, btrim(lower(replace(c.name, ' '::text, '_'::text)), ' '::text) AS car_label, e.models_available FROM (((manufacturer m JOIN car_model c ON ((m.id = c.manufacturer_id))) JOIN (SELECT market_part_types.car_id, min(market_part_types.level) AS level FROM market_part_types GROUP BY market_part_types.car_id) a ON ((a.car_id = c.id))) JOIN (SELECT car_instance.car_id, count(*) AS models_available FROM car_instance WHERE ((car_instance.prototype = true) AND (car_instance.prototype_available = true)) GROUP BY car_instance.car_id) e ON ((e.car_id = c.id))) ORDER BY c.name;


ALTER TABLE public.car_market OWNER TO postgres;

--
-- Name: car_options; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE car_options (
    id bigint NOT NULL,
    car_instance_id bigint NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE public.car_options OWNER TO postgres;

--
-- Name: car_options_extended; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_options_extended AS
    SELECT co.car_instance_id, co.key, co.value, g.account_id FROM ((car_options co JOIN car_instance ci ON ((co.car_instance_id = ci.id))) JOIN garage g ON ((g.id = ci.garage_id)));


ALTER TABLE public.car_options_extended OWNER TO postgres;

--
-- Name: car_options_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE car_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.car_options_id_seq OWNER TO postgres;

--
-- Name: car_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE car_options_id_seq OWNED BY car_options.id;


--
-- Name: car_owners; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_owners AS
    SELECT ci.id, g.account_id FROM (car_instance ci JOIN garage g ON ((ci.garage_id = g.id)));


ALTER TABLE public.car_owners OWNER TO postgres;

--
-- Name: car_prototype; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_prototype AS
    SELECT m.name AS manufacturer_name, ci.id, c.manufacturer_id, ci.power, ci.braking, ci.aero, ci.nos, ci.handling, ci.top_speed, ci.acceleration, ci.stopping, ci.cornering, ci.nitrous, ci.prototype_name, ci.prototype_available, c.name, c.use_3d, c.level, c.year, m.label, c.price, btrim(lower(replace(c.name, ' '::text, '_'::text)), ' '::text) AS car_label, c.id AS car_model_id, ci.prototype_claimable FROM (((manufacturer m JOIN car_model c ON ((m.id = c.manufacturer_id))) JOIN car_instance ci ON ((c.id = ci.car_id))) JOIN (SELECT market_part_types.car_id, min(market_part_types.level) AS level FROM market_part_types GROUP BY market_part_types.car_id) a ON ((a.car_id = c.id))) WHERE ((ci.prototype = true) AND (ci.deleted = false)) ORDER BY c.name;


ALTER TABLE public.car_prototype OWNER TO postgres;

--
-- Name: car_stock_parts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW car_stock_parts AS
    SELECT c.id AS car_id, (get_car_stock_parts(c.id)).id AS id, (get_car_stock_parts(c.id)).part_type_id AS part_type_id, (get_car_stock_parts(c.id)).weight AS weight, (get_car_stock_parts(c.id)).parameter1 AS parameter1, (get_car_stock_parts(c.id)).d3d_model_id AS d3d_model_id, (get_car_stock_parts(c.id)).level AS level, (get_car_stock_parts(c.id)).price AS price, (get_car_stock_parts(c.id)).parameter2 AS parameter2, (get_car_stock_parts(c.id)).parameter3 AS parameter3, (get_car_stock_parts(c.id)).parameter1_type_id AS parameter1_type_id, (get_car_stock_parts(c.id)).parameter2_type_id AS parameter2_type_id, (get_car_stock_parts(c.id)).parameter3_type_id AS parameter3_type_id, (get_car_stock_parts(c.id)).part_modifier_id AS part_modifier_id, (get_car_stock_parts(c.id))."unique" AS "unique" FROM car_model c;


ALTER TABLE public.car_stock_parts OWNER TO postgres;

--
-- Name: challenge; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE challenge (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    track_id bigint NOT NULL,
    participants integer DEFAULT 2,
    type bigint NOT NULL,
    account_min text NOT NULL,
    deleted boolean DEFAULT false,
    car_min text NOT NULL,
    amount integer DEFAULT 0,
    challenger text NOT NULL
);


ALTER TABLE public.challenge OWNER TO postgres;

--
-- Name: challenge_accept; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE challenge_accept (
    id bigint NOT NULL,
    challenge_id bigint,
    account_id bigint
);


ALTER TABLE public.challenge_accept OWNER TO postgres;

--
-- Name: challenge_accept_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE challenge_accept_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.challenge_accept_id_seq OWNER TO postgres;

--
-- Name: challenge_accept_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE challenge_accept_id_seq OWNED BY challenge_accept.id;


--
-- Name: challenge_extended; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE challenge_extended (
    challenge_id bigint,
    account_id bigint,
    track_id bigint,
    participants integer,
    type_id bigint,
    type text,
    accepts bigint,
    deleted boolean,
    user_nickname text,
    user_level integer,
    track_name text,
    track_level integer,
    city_id bigint,
    city_name text,
    continent_id bigint,
    continent_name text,
    profile text,
    car text,
    track_length double precision,
    top_time_exists boolean,
    top_time double precision,
    top_time_id bigint,
    top_time_account_id bigint,
    top_time_name text,
    top_time_picture_small text,
    top_time_picture_medium text,
    top_time_picture_large text,
    amount integer
);


ALTER TABLE public.challenge_extended OWNER TO postgres;

--
-- Name: challenge_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE challenge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.challenge_id_seq OWNER TO postgres;

--
-- Name: challenge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE challenge_id_seq OWNED BY challenge.id;


--
-- Name: challenge_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE challenge_type (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.challenge_type OWNER TO postgres;

--
-- Name: challenge_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE challenge_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.challenge_type_id_seq OWNER TO postgres;

--
-- Name: challenge_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE challenge_type_id_seq OWNED BY challenge_type.id;


--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_id_seq OWNER TO postgres;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE city_id_seq OWNED BY city.id;


--
-- Name: continent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE continent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.continent_id_seq OWNER TO postgres;

--
-- Name: continent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE continent_id_seq OWNED BY continent.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE country (
    id bigint NOT NULL,
    shortname text,
    name text
);


ALTER TABLE public.country OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_id_seq OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: dealer_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dealer_item (
    id bigint NOT NULL,
    car_id bigint,
    part_id bigint
);


ALTER TABLE public.dealer_item OWNER TO postgres;

--
-- Name: dealer_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE dealer_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dealer_item_id_seq OWNER TO postgres;

--
-- Name: dealer_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE dealer_item_id_seq OWNED BY dealer_item.id;


--
-- Name: diamond_transaction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE diamond_transaction (
    id bigint NOT NULL,
    amount bigint,
    current bigint,
    type text,
    type_id bigint,
    "time" bigint,
    account_id bigint
);


ALTER TABLE public.diamond_transaction OWNER TO postgres;

--
-- Name: diamond_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE diamond_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.diamond_transaction_id_seq OWNER TO postgres;

--
-- Name: diamond_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE diamond_transaction_id_seq OWNED BY diamond_transaction.id;


--
-- Name: escrow; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE escrow (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    amount bigint NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.escrow OWNER TO postgres;

--
-- Name: escrow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE escrow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.escrow_id_seq OWNER TO postgres;

--
-- Name: escrow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE escrow_id_seq OWNED BY escrow.id;


--
-- Name: event_stream; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE event_stream (
    id bigint NOT NULL,
    account_id bigint,
    rule_id bigint,
    stream text,
    active boolean
);


ALTER TABLE public.event_stream OWNER TO postgres;

--
-- Name: event_stream_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE event_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_stream_id_seq OWNER TO postgres;

--
-- Name: event_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE event_stream_id_seq OWNED BY event_stream.id;


--
-- Name: game_config; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE game_config (
    key text NOT NULL,
    value text NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.game_config OWNER TO postgres;

--
-- Name: game_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE game_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_config_id_seq OWNER TO postgres;

--
-- Name: game_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE game_config_id_seq OWNED BY game_config.id;


--
-- Name: garage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE garage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.garage_id_seq OWNER TO postgres;

--
-- Name: garage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE garage_id_seq OWNED BY garage.id;


--
-- Name: personnel_instance; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_instance (
    id bigint NOT NULL,
    garage_id bigint NOT NULL,
    skill_repair integer,
    skill_engineering integer,
    personnel_id bigint,
    salary integer,
    paid_until integer,
    busy_until integer,
    training_cost_repair integer,
    training_cost_engineering integer,
    task_id bigint DEFAULT 1,
    task_started bigint DEFAULT 0,
    task_end bigint DEFAULT 0,
    task_updated bigint DEFAULT 0,
    task_subject_id bigint DEFAULT 0,
    deleted boolean DEFAULT false
);


ALTER TABLE public.personnel_instance OWNER TO postgres;

--
-- Name: garage_parts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW garage_parts AS
    SELECT a.id AS account_id, mp.id, mp.name, mp.part_type_id, mp.weight, mp.parameter1, mp.parameter1_name, mp.parameter1_unit, mp.parameter2, mp.parameter2_name, mp.parameter2_unit, mp.parameter3, mp.parameter3_name, mp.parameter3_unit, mp.car_id, mp.d3d_model_id, mp.level, mp.price, mp.car_model, mp.manufacturer_name, mp.part_modifier, pi.wear, pi.improvement, mp."unique", pi.id AS part_instance_id, ptp.trash_price, mp.required, mp.fixed, mp.hidden, CASE WHEN (psi.id IS NULL) THEN false ELSE true END AS task_subject, g.id AS garage_id, mp.parameter1_is_modifier, mp.parameter2_is_modifier, mp.parameter3_is_modifier FROM (((((parts_details mp JOIN part_instance pi ON ((pi.part_id = mp.id))) LEFT JOIN garage g ON ((g.id = pi.garage_id))) JOIN account a ON ((g.account_id = a.id))) JOIN part_trash_price ptp ON ((ptp.id = pi.id))) LEFT JOIN personnel_instance psi ON ((((psi.task_subject_id = pi.id) AND (psi.deleted = false)) AND ((psi.task_id = 2) OR (psi.task_id = 3))))) WHERE (pi.deleted = false);


ALTER TABLE public.garage_parts OWNER TO postgres;

--
-- Name: general_report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE general_report (
    id bigint NOT NULL,
    account_id bigint,
    report_type_id bigint,
    "time" integer DEFAULT trunc(date_part('epoch'::text, now())),
    report_descriptor text
);


ALTER TABLE public.general_report OWNER TO postgres;

--
-- Name: garage_report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE garage_report (
    personnel_instance_id bigint,
    part_instance_id bigint,
    ready boolean DEFAULT false,
    data hstore,
    task text
)
INHERITS (general_report);


ALTER TABLE public.garage_report OWNER TO postgres;

--
-- Name: garage_reports; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW garage_reports AS
    SELECT (gr.data -> 'part_type'::text) AS part_type, (gr.data -> 'weight'::text) AS weight, (gr.data -> 'parameter1'::text) AS parameter1, (gr.data -> 'parameter2'::text) AS parameter2, (gr.data -> 'parameter3'::text) AS parameter3, (gr.data -> 'parameter1_name'::text) AS parameter1_name, (gr.data -> 'parameter2_name'::text) AS parameter2_name, (gr.data -> 'parameter3_name'::text) AS parameter3_name, (gr.data -> 'parameter1_unit'::text) AS parameter1_unit, (gr.data -> 'parameter2_unit'::text) AS parameter2_unit, (gr.data -> 'parameter3_unit'::text) AS parameter3_unit, (gr.data -> 'level'::text) AS level, (gr.data -> 'price'::text) AS price, (gr.data -> 'part_modifier'::text) AS modifier, (gr.data -> 'car_model'::text) AS car_model, (gr.data -> 'unique'::text) AS "unique", (gr.data -> 'improvement'::text) AS improvement, (gr.data -> 'wear'::text) AS wear, (gr.data -> 'wear_change'::text) AS wear_change, (gr.data -> 'improvement_change'::text) AS improvement_change, (gr.data -> 'manufacturer_name'::text) AS manufacturer_name, gr.id, gr.account_id, gr.report_type_id, gr."time", gr.report_descriptor, gr.part_instance_id, gr.ready, gr.data, gr.personnel_instance_id, (gr.data -> 'personnel_id'::text) AS personnel_id, (gr.data -> 'name'::text) AS name, (gr.data -> 'country_name'::text) AS country_name, (gr.data -> 'country_shortname'::text) AS country_shortname, (gr.data -> 'gender'::text) AS gender, (gr.data -> 'picture'::text) AS picture, (gr.data -> 'salary'::text) AS salary, (gr.data -> 'skill_repair'::text) AS skill_repair, (gr.data -> 'skill_engineering'::text) AS skill_engineering, (gr.data -> 'busy_until'::text) AS busy_until, (gr.data -> 'paid_until'::text) AS paid_until, (gr.data -> 'training_cost_repair'::text) AS training_cost_repair, (gr.data -> 'training_cost_engineering'::text) AS training_cost_engineering, gr.task, (gr.data -> 'part_modifier'::text) AS part_modifier, (gr.data -> 'part_id'::text) AS part_id FROM garage_report gr WHERE (gr.ready = true);


ALTER TABLE public.garage_reports OWNER TO postgres;

--
-- Name: general_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE general_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.general_report_id_seq OWNER TO postgres;

--
-- Name: general_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE general_report_id_seq OWNED BY general_report.id;


--
-- Name: report_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE report_type (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.report_type OWNER TO postgres;

--
-- Name: general_reports; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW general_reports AS
    SELECT pr.id, pr.account_id, pr.report_type_id, rt.name AS report_type, pr."time", pr.report_descriptor FROM (general_report pr JOIN report_type rt ON ((rt.id = pr.report_type_id)));


ALTER TABLE public.general_reports OWNER TO postgres;

--
-- Name: letters; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE letters (
    id bigint NOT NULL,
    ttl bigint,
    message text NOT NULL,
    title text NOT NULL,
    sendat bigint NOT NULL,
    "to" bigint NOT NULL,
    "from" bigint,
    read boolean DEFAULT false NOT NULL,
    archive boolean DEFAULT false NOT NULL,
    type text,
    data text
);


ALTER TABLE public.letters OWNER TO postgres;

--
-- Name: letters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE letters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.letters_id_seq OWNER TO postgres;

--
-- Name: letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE letters_id_seq OWNED BY letters.id;


--
-- Name: manufacturer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE manufacturer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manufacturer_id_seq OWNER TO postgres;

--
-- Name: manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE manufacturer_id_seq OWNED BY manufacturer.id;


--
-- Name: manufacturer_level; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW manufacturer_level AS
    SELECT cm.manufacturer_id, min(cm.level) AS level FROM (manufacturer m JOIN car_market cm ON ((cm.manufacturer_id = m.id))) GROUP BY cm.manufacturer_id;


ALTER TABLE public.manufacturer_level OWNER TO postgres;

--
-- Name: manufacturer_market; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW manufacturer_market AS
    SELECT m.id, m.name, m.picture, m.text, m.label, ml.level FROM (manufacturer_level ml JOIN manufacturer m ON ((m.id = ml.manufacturer_id))) ORDER BY m.name;


ALTER TABLE public.manufacturer_market OWNER TO postgres;

--
-- Name: market_item; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE market_item (
    id bigint NOT NULL,
    car_instance_id bigint,
    part_instance_id bigint,
    price integer,
    account_id bigint
);


ALTER TABLE public.market_item OWNER TO postgres;

--
-- Name: market_car_instance_parts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_car_instance_parts AS
    SELECT pi.id AS part_instance_id, ci.id AS car_instance_id, pd.id AS part_id, pd.name, pd.part_type_id, pd.weight, pd.parameter1, pd.parameter1_name, pd.parameter1_unit, pd.parameter2, pd.parameter2_name, pd.parameter2_unit, pd.parameter3, pd.parameter3_name, pd.parameter3_unit, pd.car_id, pd.d3d_model_id, pd.level, pd.price, pd.car_model, pd.manufacturer_name, pd.part_modifier, pd."unique", pd.sort_part_type, pd.price AS new_price, m.account_id, pi.improvement, pi.wear, pd.required, pd.fixed, pd.hidden FROM ((((parts_details pd JOIN part_instance pi ON ((pi.part_id = pd.id))) JOIN part_trash_price ptp ON ((ptp.id = pi.id))) JOIN car_instance_details ci ON ((pi.car_instance_id = ci.id))) JOIN market_item m ON ((ci.id = m.car_instance_id)));


ALTER TABLE public.market_car_instance_parts OWNER TO postgres;

--
-- Name: market_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE market_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.market_item_id_seq OWNER TO postgres;

--
-- Name: market_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE market_item_id_seq OWNED BY market_item.id;


--
-- Name: market_part_type; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_part_type AS
    SELECT t.id, t.name, t.sort, t.use_3d, t.required, t.fixed, t.hidden, min(m.level) AS min_level, max(m.level) AS max_level, min(m.price) AS min_price, max(m.price) AS max_price FROM (market_parts_mat m JOIN part_type t ON (((m.part_type_id = t.id) AND (m.car_id = 0)))) GROUP BY m.part_type_id, t.id, t.name, t.sort, t.use_3d, t.required, t.fixed, t.hidden ORDER BY m.part_type_id;


ALTER TABLE public.market_part_type OWNER TO postgres;

--
-- Name: market_parts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_parts AS
    SELECT market_parts_mat.id, market_parts_mat.name, market_parts_mat.part_type_id, market_parts_mat.weight, market_parts_mat.parameter1, market_parts_mat.parameter1_name, market_parts_mat.parameter1_unit, market_parts_mat.parameter2, market_parts_mat.parameter2_name, market_parts_mat.parameter2_unit, market_parts_mat.parameter3, market_parts_mat.parameter3_name, market_parts_mat.parameter3_unit, market_parts_mat.car_id, market_parts_mat.d3d_model_id, market_parts_mat.level, market_parts_mat.price, market_parts_mat.car_model, market_parts_mat.manufacturer_name, market_parts_mat.part_modifier, market_parts_mat."unique", market_parts_mat.sort_part_type, market_parts_mat.required, market_parts_mat.fixed, market_parts_mat.hidden FROM market_parts_mat ORDER BY market_parts_mat.level DESC, market_parts_mat.price;


ALTER TABLE public.market_parts OWNER TO postgres;

--
-- Name: market_place; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_place AS
    SELECT pi.id, pm.name, pm.part_type_id, pm.weight, pm.parameter1, pm.parameter1_name, pm.parameter1_unit, pm.parameter2, pm.parameter2_name, pm.parameter2_unit, pm.parameter3, pm.parameter3_name, pm.parameter3_unit, pm.car_id, pm.d3d_model_id, pm.level, mi.price, pm.car_model, pm.manufacturer_name, pm.part_modifier, pm."unique", pi.improvement, pi.wear, pm.sort_part_type, mi.account_id, pm.id AS part_id FROM ((market_item mi JOIN part_instance pi ON ((pi.id = mi.part_instance_id))) JOIN parts_details pm ON ((pi.part_id = pm.id))) ORDER BY pm.level DESC, mi.price;


ALTER TABLE public.market_place OWNER TO postgres;

--
-- Name: market_place_car; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_place_car AS
    SELECT mi.car_instance_id, mi.price, ci.top_speed, ci.acceleration, ci.braking, ci.handling, ci.nos, ci.weight, ci.manufacturer_name, ci.level, ci.year, mi.account_id, ci.name AS model, ci.wear, ci.improvement, (-1) AS stopping, (-1) AS cornering, (-1) AS nitrous FROM (market_item mi JOIN car_instance_details ci ON ((mi.car_instance_id = ci.id))) WHERE (NOT (mi.car_instance_id IS NULL));


ALTER TABLE public.market_place_car OWNER TO postgres;

--
-- Name: market_place_part_type; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW market_place_part_type AS
    SELECT t.id, t.name, t.sort, t.use_3d, t.required, t.fixed, t.hidden, min(m.level) AS min_level, max(m.level) AS max_level, min(i.price) AS min_price, max(i.price) AS max_price FROM (((market_item i JOIN part_instance p ON ((i.part_instance_id = p.id))) JOIN part_model m ON ((p.part_id = m.id))) JOIN part_type t ON ((m.part_type_id = t.id))) GROUP BY m.part_type_id, t.id, t.name, t.sort, t.use_3d, t.required, t.fixed, t.hidden ORDER BY m.part_type_id;


ALTER TABLE public.market_place_part_type OWNER TO postgres;

--
-- Name: menu; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE menu (
    id bigint NOT NULL,
    parent bigint,
    number bigint,
    type text DEFAULT ''::text,
    label text DEFAULT ''::text,
    module text DEFAULT ''::text,
    class text DEFAULT ''::text,
    menu_type text
);


ALTER TABLE public.menu OWNER TO postgres;

--
-- Name: menu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_id_seq OWNER TO postgres;

--
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE menu_id_seq OWNED BY menu.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE notifications (
    id bigint NOT NULL,
    name text,
    string text,
    language bigint DEFAULT 1,
    type text,
    body text,
    title text
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: parameter_table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE parameter_table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parameter_table_id_seq OWNER TO postgres;

--
-- Name: parameter_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE parameter_table_id_seq OWNED BY parameter_table.id;


--
-- Name: part_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE part_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.part_id_seq OWNER TO postgres;

--
-- Name: part_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE part_id_seq OWNED BY part_model.id;


--
-- Name: part_instance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE part_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.part_instance_id_seq OWNER TO postgres;

--
-- Name: part_instance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE part_instance_id_seq OWNED BY part_instance.id;


--
-- Name: part_modifier; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE part_modifier (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.part_modifier OWNER TO postgres;

--
-- Name: part_modifier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE part_modifier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.part_modifier_id_seq OWNER TO postgres;

--
-- Name: part_modifier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE part_modifier_id_seq OWNED BY part_modifier.id;


--
-- Name: part_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE part_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.part_type_id_seq OWNER TO postgres;

--
-- Name: part_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE part_type_id_seq OWNED BY part_type.id;


--
-- Name: personnel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel (
    id bigint NOT NULL,
    name text,
    country_id bigint,
    gender boolean,
    picture text,
    salary integer,
    price integer,
    sort integer,
    skill_repair integer,
    skill_engineering integer
);


ALTER TABLE public.personnel OWNER TO postgres;

--
-- Name: personnel_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW personnel_details AS
    SELECT p.id AS personnel_id, p.name, c.name AS country_name, c.shortname AS country_shortname, p.gender, p.picture, p.salary, p.price, p.skill_repair, p.skill_engineering, p.sort FROM (personnel p JOIN country c ON ((c.id = p.country_id))) ORDER BY p.sort;


ALTER TABLE public.personnel_details OWNER TO postgres;

--
-- Name: personnel_id_seq2; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_id_seq2
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_id_seq2 OWNER TO postgres;

--
-- Name: personnel_id_seq2; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_id_seq2 OWNED BY personnel.id;


--
-- Name: personnel_task_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_task_type (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.personnel_task_type OWNER TO postgres;

--
-- Name: personnel_instance_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW personnel_instance_details AS
    SELECT p.id AS personnel_instance_id, d.personnel_id, d.name, d.country_name, d.country_shortname, d.gender, d.picture, p.salary, p.skill_repair, p.skill_engineering, p.busy_until, p.paid_until, p.garage_id, p.training_cost_repair, p.training_cost_engineering, p.task_id, t.name AS task_name, p.task_started, p.task_end, p.task_updated, p.task_subject_id, CASE WHEN (p.task_end = 0) THEN (0)::bigint ELSE (p.task_end - unix_timestamp()) END AS task_time_left FROM ((personnel_instance p JOIN personnel_details d ON ((p.personnel_id = d.personnel_id))) JOIN personnel_task_type t ON ((p.task_id = t.id))) WHERE (p.deleted = false);


ALTER TABLE public.personnel_instance_details OWNER TO postgres;

--
-- Name: personnel_instance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_instance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_instance_id_seq OWNER TO postgres;

--
-- Name: personnel_instance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_instance_id_seq OWNED BY personnel_instance.id;


--
-- Name: personnel_report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE personnel_report (
    result text,
    cost integer,
    part_instance_id bigint,
    data hstore,
    personnel_instance_id bigint
)
INHERITS (general_report);


ALTER TABLE public.personnel_report OWNER TO postgres;

--
-- Name: personnel_reports; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW personnel_reports AS
    SELECT pr.id, pr.account_id, pr.report_type_id, pr."time", pr.report_descriptor, pr.result, pr.cost, pr.part_instance_id, pr.personnel_instance_id, (populate_record(NULL::personnel_details, pr.data)).personnel_id AS personnel_id, (populate_record(NULL::personnel_details, pr.data)).name AS name, (populate_record(NULL::personnel_details, pr.data)).country_name AS country_name, (populate_record(NULL::personnel_details, pr.data)).country_shortname AS country_shortname, (populate_record(NULL::personnel_details, pr.data)).gender AS gender, (populate_record(NULL::personnel_details, pr.data)).picture AS picture, (populate_record(NULL::personnel_details, pr.data)).salary AS salary, (populate_record(NULL::personnel_details, pr.data)).price AS price, (populate_record(NULL::personnel_details, pr.data)).skill_repair AS skill_repair, (populate_record(NULL::personnel_details, pr.data)).skill_engineering AS skill_engineering, (populate_record(NULL::personnel_details, pr.data)).sort AS sort, (pr.data -> 'type'::text) AS type, rt.name AS report_type, ''::text AS data FROM (personnel_report pr JOIN report_type rt ON ((pr.report_type_id = rt.id))) ORDER BY pr."time" DESC;


ALTER TABLE public.personnel_reports OWNER TO postgres;

--
-- Name: personnel_task_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW personnel_task_details AS
    SELECT pi.id AS personnel_instance_id, t.name AS task_name, pi.task_id, pi.task_started, pi.task_end, pi.task_updated, pi.task_subject_id FROM (personnel_instance pi JOIN personnel_task_type t ON ((pi.task_id = t.id)));


ALTER TABLE public.personnel_task_details OWNER TO postgres;

--
-- Name: personnel_task_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE personnel_task_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personnel_task_type_id_seq OWNER TO postgres;

--
-- Name: personnel_task_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE personnel_task_type_id_seq OWNED BY personnel_task_type.id;


--
-- Name: race_types; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE race_types (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.race_types OWNER TO postgres;

--
-- Name: races; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE races (
    id bigint NOT NULL,
    track_id bigint,
    start_time bigint,
    end_time bigint,
    type bigint,
    data text COLLATE pg_catalog."C"
);


ALTER TABLE public.races OWNER TO postgres;

--
-- Name: race_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW race_details AS
    SELECT r.id AS race_id, r.track_id, r.start_time, r.end_time, GREATEST((0)::bigint, (r.end_time - unix_timestamp())) AS time_left, t.name AS type, r.data FROM (races r JOIN race_types t ON ((r.type = t.id)));


ALTER TABLE public.race_details OWNER TO postgres;

--
-- Name: race_rewards; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE race_rewards (
    id bigint NOT NULL,
    race_id bigint,
    account_id bigint,
    "time" bigint NOT NULL,
    rewards text NOT NULL
);


ALTER TABLE public.race_rewards OWNER TO postgres;

--
-- Name: race_rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE race_rewards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.race_rewards_id_seq OWNER TO postgres;

--
-- Name: race_rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE race_rewards_id_seq OWNED BY race_rewards.id;


--
-- Name: race_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE race_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.race_types_id_seq OWNER TO postgres;

--
-- Name: race_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE race_types_id_seq OWNED BY race_types.id;


--
-- Name: races_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE races_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.races_id_seq OWNER TO postgres;

--
-- Name: races_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE races_id_seq OWNED BY races.id;


--
-- Name: report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE report (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    type integer NOT NULL,
    data text NOT NULL,
    "time" bigint NOT NULL
);


ALTER TABLE public.report OWNER TO postgres;

--
-- Name: report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_id_seq OWNER TO postgres;

--
-- Name: report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE report_id_seq OWNED BY report.id;


--
-- Name: report_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE report_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_type_id_seq OWNER TO postgres;

--
-- Name: report_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE report_type_id_seq OWNED BY report_type.id;


--
-- Name: reward; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE reward (
    id bigint NOT NULL,
    money bigint,
    experience bigint,
    name text
);


ALTER TABLE public.reward OWNER TO postgres;

--
-- Name: reward_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE reward_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reward_id_seq OWNER TO postgres;

--
-- Name: reward_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE reward_id_seq OWNED BY reward.id;


--
-- Name: reward_log; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE reward_log (
    id bigint NOT NULL,
    account_id bigint,
    rule text,
    name text,
    viewed boolean DEFAULT false,
    experience bigint,
    money bigint
);


ALTER TABLE public.reward_log OWNER TO postgres;

--
-- Name: reward_log_events; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE reward_log_events (
    id bigint NOT NULL,
    type text,
    type_id bigint NOT NULL,
    reward_log_id bigint,
    "time" bigint DEFAULT unix_timestamp()
);


ALTER TABLE public.reward_log_events OWNER TO postgres;

--
-- Name: reward_log_event; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW reward_log_event AS
    SELECT rl.id, rl.account_id, rl.rule, rl.name, rl.viewed, rl.experience, rl.money, rle.type_id, rle.type, rle."time" FROM (reward_log_events rle JOIN reward_log rl ON ((rle.reward_log_id = rl.id)));


ALTER TABLE public.reward_log_event OWNER TO postgres;

--
-- Name: reward_log_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE reward_log_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reward_log_events_id_seq OWNER TO postgres;

--
-- Name: reward_log_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE reward_log_events_id_seq OWNED BY reward_log_events.id;


--
-- Name: reward_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE reward_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reward_log_id_seq OWNER TO postgres;

--
-- Name: reward_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE reward_log_id_seq OWNED BY reward_log.id;


--
-- Name: rule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rule (
    id bigint NOT NULL,
    rule text,
    name text,
    once boolean DEFAULT false NOT NULL
);


ALTER TABLE public.rule OWNER TO postgres;

--
-- Name: rule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_id_seq OWNER TO postgres;

--
-- Name: rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rule_id_seq OWNED BY rule.id;


--
-- Name: rule_reward; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW rule_reward AS
    SELECT r.id, r.rule, r.name, r.once, a.change, rw.money, rw.experience FROM ((rule r JOIN action a ON ((a.rule_id = r.id))) JOIN reward rw ON ((a.reward_id = rw.id)));


ALTER TABLE public.rule_reward OWNER TO postgres;

--
-- Name: shop_report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_report (
    part_instance_id bigint,
    part_id bigint,
    amount integer,
    car_instance_id bigint,
    data hstore,
    car_data hstore,
    car_id bigint
)
INHERITS (general_report);


ALTER TABLE public.shop_report OWNER TO postgres;

--
-- Name: COLUMN shop_report.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN shop_report.amount IS '
';


--
-- Name: shopping_reports; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW shopping_reports AS
    SELECT shop_report.id, shop_report.account_id, shop_report.report_type_id, report_type.name AS report_type, shop_report."time", shop_report.report_descriptor, shop_report.part_instance_id, shop_report.part_id, shop_report.amount, shop_report.car_instance_id, (shop_report.car_data -> 'manufacturer_name'::text) AS car_manufacturer_name, (shop_report.car_data -> 'top_speed'::text) AS car_top_speed, (shop_report.car_data -> 'acceleration'::text) AS car_acceleration, (shop_report.car_data -> 'braking'::text) AS car_braking, (shop_report.car_data -> 'nos'::text) AS car_nos, (shop_report.car_data -> 'handling'::text) AS car_handling, (shop_report.car_data -> 'name'::text) AS car_name, (shop_report.car_data -> 'level'::text) AS car_level, (shop_report.car_data -> 'year'::text) AS car_year, (shop_report.car_data -> 'price'::text) AS car_price, (shop_report.car_data -> 'weight'::text) AS car_weight, (shop_report.car_data -> 'wear'::text) AS car_wear, (shop_report.car_data -> 'improvement'::text) AS car_improvement, (shop_report.data -> 'weight'::text) AS part_weight, (shop_report.data -> 'car_model'::text) AS part_car_model, (shop_report.data -> 'level'::text) AS part_level, (shop_report.data -> 'price'::text) AS part_price, (shop_report.data -> 'parameter1'::text) AS part_parameter1, (shop_report.data -> 'parameter2'::text) AS part_parameter2, (shop_report.data -> 'parameter3'::text) AS part_parameter3, (shop_report.data -> 'parameter1_type'::text) AS part_parameter1_type, (shop_report.data -> 'parameter2_type'::text) AS part_parameter2_type, (shop_report.data -> 'parameter3_type'::text) AS part_parameter3_type, (shop_report.data -> 'part_modifier'::text) AS part_modifier, (shop_report.data -> 'unique'::text) AS part_unique, (shop_report.data -> 'improvement'::text) AS part_improvement, (shop_report.data -> 'wear'::text) AS part_wear, shop_report.car_id, (shop_report.data -> 'part_type'::text) AS part_type, (shop_report.data -> 'parameter1_name'::text) AS part_parameter1_name, (shop_report.data -> 'parameter2_name'::text) AS part_parameter2_name, (shop_report.data -> 'parameter3_name'::text) AS part_parameter3_name, (shop_report.data -> 'manufacturer_name'::text) AS part_manufacturer_name, (shop_report.data -> 'parameter1_modifier'::text) AS part_parameter1_modifier, (shop_report.data -> 'parameter2_modifier'::text) AS part_parameter2_modifier, (shop_report.data -> 'parameter3_modifier'::text) AS part_parameter3_modifier FROM (shop_report JOIN report_type ON ((shop_report.report_type_id = report_type.id))) ORDER BY shop_report."time" DESC;


ALTER TABLE public.shopping_reports OWNER TO postgres;

--
-- Name: support; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE support (
    id bigint NOT NULL,
    account_id bigint,
    message text,
    data text,
    processed boolean DEFAULT false,
    created bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision)
);


ALTER TABLE public.support OWNER TO postgres;

--
-- Name: support_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE support_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.support_id_seq OWNER TO postgres;

--
-- Name: support_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE support_id_seq OWNED BY support.id;


--
-- Name: task_claim_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE task_claim_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_claim_seq OWNER TO postgres;

--
-- Name: task_trigger; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE task_trigger (
    id bigint NOT NULL,
    type integer NOT NULL,
    task_id bigint NOT NULL,
    target_id bigint NOT NULL
);


ALTER TABLE public.task_trigger OWNER TO postgres;

--
-- Name: task_extended; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW task_extended AS
    SELECT t.id AS task_id, t."time", t.data, s.type, s.target_id, t.claim FROM (task t JOIN task_trigger s ON ((s.task_id = t.id))) WHERE (t.deleted = false);


ALTER TABLE public.task_extended OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_id_seq OWNER TO postgres;

--
-- Name: task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE task_id_seq OWNED BY task.id;


--
-- Name: task_trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE task_trigger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_trigger_id_seq OWNER TO postgres;

--
-- Name: task_trigger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE task_trigger_id_seq OWNED BY task_trigger.id;


--
-- Name: tournament; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament (
    id bigint NOT NULL,
    car_id bigint,
    start_time bigint,
    costs bigint,
    rewards text,
    minlevel integer,
    maxlevel integer,
    track_id bigint,
    players integer NOT NULL,
    name text NOT NULL,
    done boolean DEFAULT false NOT NULL,
    image text,
    running boolean DEFAULT false NOT NULL,
    tournament_type_id bigint DEFAULT 1 NOT NULL,
    tournament_prices text
);


ALTER TABLE public.tournament OWNER TO postgres;

--
-- Name: tournament_players; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament_players (
    id bigint NOT NULL,
    account_id bigint,
    tournament_id bigint,
    car_instance_id bigint,
    deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.tournament_players OWNER TO postgres;

--
-- Name: tournament_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament_type (
    id bigint NOT NULL,
    name text
);


ALTER TABLE public.tournament_type OWNER TO postgres;

--
-- Name: track; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE track (
    id bigint NOT NULL,
    city_id bigint,
    name text DEFAULT ''::text,
    level integer DEFAULT 1,
    data text DEFAULT ''::text,
    loop boolean DEFAULT false,
    length double precision DEFAULT 0,
    top_time_id bigint,
    energy_cost integer DEFAULT 0
);


ALTER TABLE public.track OWNER TO postgres;

--
-- Name: tournament_extended; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW tournament_extended AS
    SELECT tournament.id, tournament.car_id, tournament.start_time, tournament.costs, tournament.rewards, tournament.minlevel, tournament.maxlevel, tournament.track_id, tournament.players, tournament.name, (SELECT count(*) AS count FROM tournament_players WHERE ((tournament_players.tournament_id = tournament.id) AND (tournament_players.deleted = false))) AS current_players, tournament.done, tournament.running, t.city_id AS city, tt.name AS tournament_type, tournament.tournament_type_id FROM ((tournament LEFT JOIN track t ON ((tournament.track_id = t.id))) LEFT JOIN tournament_type tt ON ((tournament.tournament_type_id = tt.id)));


ALTER TABLE public.tournament_extended OWNER TO postgres;

--
-- Name: tournament_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_id_seq OWNER TO postgres;

--
-- Name: tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_id_seq OWNED BY tournament.id;


--
-- Name: tournament_players_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_players_id_seq OWNER TO postgres;

--
-- Name: tournament_players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_players_id_seq OWNED BY tournament_players.id;


--
-- Name: tournament_report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament_report (
    id bigint NOT NULL,
    tournament_id bigint,
    tournament_result text,
    tournament text,
    account_id bigint,
    players text,
    created bigint DEFAULT (date_part('epoch'::text, now()) * (1000)::double precision)
);


ALTER TABLE public.tournament_report OWNER TO postgres;

--
-- Name: tournament_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_report_id_seq OWNER TO postgres;

--
-- Name: tournament_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_report_id_seq OWNED BY tournament_report.id;


--
-- Name: tournament_result; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tournament_result (
    id bigint NOT NULL,
    race_id bigint,
    tournament_id bigint,
    round integer,
    participant1_id bigint,
    participant2_id bigint,
    race_time1 double precision,
    race_time2 double precision,
    car1_id bigint,
    car2_id bigint
);


ALTER TABLE public.tournament_result OWNER TO postgres;

--
-- Name: tournament_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_result_id_seq OWNER TO postgres;

--
-- Name: tournament_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_result_id_seq OWNED BY tournament_result.id;


--
-- Name: tournament_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tournament_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_type_id_seq OWNER TO postgres;

--
-- Name: tournament_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tournament_type_id_seq OWNED BY tournament_type.id;


--
-- Name: track_time; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE track_time (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    track_id bigint,
    "time" double precision
);


ALTER TABLE public.track_time OWNER TO postgres;

--
-- Name: track_master; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW track_master AS
    SELECT tr.id AS track_id, tr.name AS track_name, tr.data AS track_data, tr.level AS track_level, cy.id AS city_id, cy.name AS city_name, cy.data AS city_data, cn.id AS continent_id, cn.name AS continent_name, cn.data AS continent_data, tr.length, CASE WHEN (tr.top_time_id IS NULL) THEN false ELSE true END AS top_time_exists, CASE WHEN (tr.top_time_id IS NULL) THEN (0)::bigint ELSE tr.top_time_id END AS top_time_id, CASE WHEN (tt."time" IS NULL) THEN (0)::double precision ELSE tt."time" END AS top_time, CASE WHEN (a.id IS NULL) THEN (0)::bigint ELSE a.id END AS top_time_account_id, CASE WHEN (a.nickname IS NULL) THEN ''::text ELSE a.nickname END AS top_time_name, CASE WHEN (a.picture_small IS NULL) THEN ''::text ELSE a.picture_small END AS top_time_picture_small, CASE WHEN (a.picture_medium IS NULL) THEN ''::text ELSE a.picture_medium END AS top_time_picture_medium, CASE WHEN (a.picture_large IS NULL) THEN ''::text ELSE a.picture_large END AS top_time_picture_large, tr.energy_cost FROM ((((track tr LEFT JOIN city cy ON ((tr.city_id = cy.id))) LEFT JOIN continent cn ON ((cy.continent_id = cn.id))) LEFT JOIN track_time tt ON ((tt.id = tr.top_time_id))) LEFT JOIN account a ON ((a.id = tt.account_id)));


ALTER TABLE public.track_master OWNER TO postgres;

--
-- Name: track_city; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW track_city AS
    SELECT track_master.city_id, track_master.city_name, track_master.city_data, min(track_master.track_level) AS city_level, track_master.continent_id, track_master.continent_name, track_master.continent_data, count(*) AS city_tracks FROM track_master GROUP BY track_master.city_id, track_master.city_name, track_master.city_data, track_master.continent_id, track_master.continent_name, track_master.continent_data;


ALTER TABLE public.track_city OWNER TO postgres;

--
-- Name: track_continent; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW track_continent AS
    SELECT track_city.continent_id, track_city.continent_name, track_city.continent_data, min(track_city.city_level) AS continent_level, count(*) AS continent_cities, sum(track_city.city_tracks) AS continent_tracks FROM track_city GROUP BY track_city.continent_id, track_city.continent_name, track_city.continent_data;


ALTER TABLE public.track_continent OWNER TO postgres;

--
-- Name: track_section; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE track_section (
    id bigint NOT NULL,
    track_id bigint NOT NULL,
    radius double precision,
    length double precision,
    segment text
);


ALTER TABLE public.track_section OWNER TO postgres;

--
-- Name: track_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW track_details AS
    SELECT ts.id, ts.track_id, ts.radius, ts.length, ts.segment FROM (track t JOIN track_section ts ON ((t.id = ts.track_id))) ORDER BY ts.id;


ALTER TABLE public.track_details OWNER TO postgres;

--
-- Name: track_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.track_id_seq OWNER TO postgres;

--
-- Name: track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE track_id_seq OWNED BY track.id;


--
-- Name: track_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE track_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.track_section_id_seq OWNER TO postgres;

--
-- Name: track_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE track_section_id_seq OWNED BY track_section.id;


--
-- Name: track_top_time_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE track_top_time_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.track_top_time_id_seq OWNER TO postgres;

--
-- Name: track_top_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE track_top_time_id_seq OWNED BY track_time.id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE transaction (
    id bigint NOT NULL,
    amount integer NOT NULL,
    current integer NOT NULL,
    type text NOT NULL,
    type_id integer NOT NULL,
    "time" integer NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Name: transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_id_seq OWNER TO postgres;

--
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transaction_id_seq OWNED BY transaction.id;


--
-- Name: travel_report; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE travel_report (
    city_to text,
    city_from text,
    continent_to text,
    continent_from text
)
INHERITS (general_report);


ALTER TABLE public.travel_report OWNER TO postgres;

--
-- Name: travel_reports; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW travel_reports AS
    SELECT travel_report.id, travel_report.account_id, travel_report.report_type_id, travel_report."time", travel_report.report_descriptor, travel_report.city_to, travel_report.city_from, travel_report.continent_to, travel_report.continent_from FROM travel_report ORDER BY travel_report."time" DESC;


ALTER TABLE public.travel_reports OWNER TO postgres;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY access ALTER COLUMN id SET DEFAULT nextval('access_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY account ALTER COLUMN id SET DEFAULT nextval('account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY account_busy_type ALTER COLUMN id SET DEFAULT nextval('account_busy_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY action ALTER COLUMN id SET DEFAULT nextval('action_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY application ALTER COLUMN id SET DEFAULT nextval('application_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_instance ALTER COLUMN id SET DEFAULT nextval('car_instance_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_model ALTER COLUMN id SET DEFAULT nextval('car_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_options ALTER COLUMN id SET DEFAULT nextval('car_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge ALTER COLUMN id SET DEFAULT nextval('challenge_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge_accept ALTER COLUMN id SET DEFAULT nextval('challenge_accept_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge_type ALTER COLUMN id SET DEFAULT nextval('challenge_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY city ALTER COLUMN id SET DEFAULT nextval('city_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY continent ALTER COLUMN id SET DEFAULT nextval('continent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dealer_item ALTER COLUMN id SET DEFAULT nextval('dealer_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY diamond_transaction ALTER COLUMN id SET DEFAULT nextval('diamond_transaction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY escrow ALTER COLUMN id SET DEFAULT nextval('escrow_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY event_stream ALTER COLUMN id SET DEFAULT nextval('event_stream_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY game_config ALTER COLUMN id SET DEFAULT nextval('game_config_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY garage ALTER COLUMN id SET DEFAULT nextval('garage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY garage_report ALTER COLUMN id SET DEFAULT nextval('general_report_id_seq'::regclass);


--
-- Name: time; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY garage_report ALTER COLUMN "time" SET DEFAULT trunc(date_part('epoch'::text, now()));


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY general_report ALTER COLUMN id SET DEFAULT nextval('general_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY letters ALTER COLUMN id SET DEFAULT nextval('letters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY manufacturer ALTER COLUMN id SET DEFAULT nextval('manufacturer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY market_item ALTER COLUMN id SET DEFAULT nextval('market_item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY menu ALTER COLUMN id SET DEFAULT nextval('menu_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY parameter_table ALTER COLUMN id SET DEFAULT nextval('parameter_table_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_instance ALTER COLUMN id SET DEFAULT nextval('part_instance_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_model ALTER COLUMN id SET DEFAULT nextval('part_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_modifier ALTER COLUMN id SET DEFAULT nextval('part_modifier_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_type ALTER COLUMN id SET DEFAULT nextval('part_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel ALTER COLUMN id SET DEFAULT nextval('personnel_id_seq2'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_instance ALTER COLUMN id SET DEFAULT nextval('personnel_instance_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_report ALTER COLUMN id SET DEFAULT nextval('general_report_id_seq'::regclass);


--
-- Name: time; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_report ALTER COLUMN "time" SET DEFAULT trunc(date_part('epoch'::text, now()));


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_task_type ALTER COLUMN id SET DEFAULT nextval('personnel_task_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY race_rewards ALTER COLUMN id SET DEFAULT nextval('race_rewards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY race_types ALTER COLUMN id SET DEFAULT nextval('race_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY races ALTER COLUMN id SET DEFAULT nextval('races_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY report ALTER COLUMN id SET DEFAULT nextval('report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY report_type ALTER COLUMN id SET DEFAULT nextval('report_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reward ALTER COLUMN id SET DEFAULT nextval('reward_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reward_log ALTER COLUMN id SET DEFAULT nextval('reward_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reward_log_events ALTER COLUMN id SET DEFAULT nextval('reward_log_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rule ALTER COLUMN id SET DEFAULT nextval('rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_report ALTER COLUMN id SET DEFAULT nextval('general_report_id_seq'::regclass);


--
-- Name: time; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_report ALTER COLUMN "time" SET DEFAULT trunc(date_part('epoch'::text, now()));


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY support ALTER COLUMN id SET DEFAULT nextval('support_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task ALTER COLUMN id SET DEFAULT nextval('task_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_trigger ALTER COLUMN id SET DEFAULT nextval('task_trigger_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament ALTER COLUMN id SET DEFAULT nextval('tournament_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_players ALTER COLUMN id SET DEFAULT nextval('tournament_players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_report ALTER COLUMN id SET DEFAULT nextval('tournament_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_result ALTER COLUMN id SET DEFAULT nextval('tournament_result_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_type ALTER COLUMN id SET DEFAULT nextval('tournament_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track ALTER COLUMN id SET DEFAULT nextval('track_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track_section ALTER COLUMN id SET DEFAULT nextval('track_section_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track_time ALTER COLUMN id SET DEFAULT nextval('track_top_time_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transaction ALTER COLUMN id SET DEFAULT nextval('transaction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY travel_report ALTER COLUMN id SET DEFAULT nextval('general_report_id_seq'::regclass);


--
-- Name: time; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY travel_report ALTER COLUMN "time" SET DEFAULT trunc(date_part('epoch'::text, now()));


--
-- Name: access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY access
    ADD CONSTRAINT access_pkey PRIMARY KEY (id);


--
-- Name: account_busy_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY account_busy_type
    ADD CONSTRAINT account_busy_type_pkey PRIMARY KEY (id);


--
-- Name: account_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_email_unique UNIQUE (email);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY action
    ADD CONSTRAINT action_pkey PRIMARY KEY (id);


--
-- Name: car_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY car_instance
    ADD CONSTRAINT car_instance_pkey PRIMARY KEY (id);


--
-- Name: car_options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY car_options
    ADD CONSTRAINT car_options_pkey PRIMARY KEY (id);


--
-- Name: car_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY car_model
    ADD CONSTRAINT car_pkey PRIMARY KEY (id);


--
-- Name: challenge_accept_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY challenge_accept
    ADD CONSTRAINT challenge_accept_pkey PRIMARY KEY (id);


--
-- Name: challenge_tyoe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY challenge_type
    ADD CONSTRAINT challenge_tyoe_pkey PRIMARY KEY (id);


--
-- Name: challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY challenge
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: continent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY continent
    ADD CONSTRAINT continent_pkey PRIMARY KEY (id);


--
-- Name: dealer_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dealer_item
    ADD CONSTRAINT dealer_item_pkey PRIMARY KEY (id);


--
-- Name: diamond_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY diamond_transaction
    ADD CONSTRAINT diamond_transaction_pkey PRIMARY KEY (id);


--
-- Name: escrow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY escrow
    ADD CONSTRAINT escrow_pkey PRIMARY KEY (id);


--
-- Name: event_stream_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY event_stream
    ADD CONSTRAINT event_stream_pkey PRIMARY KEY (id);


--
-- Name: game_config_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game_config
    ADD CONSTRAINT game_config_key_key UNIQUE (key);


--
-- Name: game_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game_config
    ADD CONSTRAINT game_config_pkey PRIMARY KEY (id);


--
-- Name: garage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY garage
    ADD CONSTRAINT garage_pkey PRIMARY KEY (id);


--
-- Name: garage_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY garage_report
    ADD CONSTRAINT garage_reports_pkey PRIMARY KEY (id);


--
-- Name: general_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY general_report
    ADD CONSTRAINT general_report_pkey PRIMARY KEY (id);


--
-- Name: letters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT letters_pkey PRIMARY KEY (id);


--
-- Name: manufacturer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (id);


--
-- Name: market_parts_mat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY market_parts_mat
    ADD CONSTRAINT market_parts_mat_pkey PRIMARY KEY (id);


--
-- Name: notifications_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_name_key UNIQUE (name);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: parameter_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY parameter_table
    ADD CONSTRAINT parameter_table_pkey PRIMARY KEY (id);


--
-- Name: part_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY part_instance
    ADD CONSTRAINT part_instance_pkey PRIMARY KEY (id);


--
-- Name: part_modifier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY part_modifier
    ADD CONSTRAINT part_modifier_pkey PRIMARY KEY (id);


--
-- Name: part_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY part_model
    ADD CONSTRAINT part_pkey PRIMARY KEY (id);


--
-- Name: part_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY part_type
    ADD CONSTRAINT part_type_pkey PRIMARY KEY (id);


--
-- Name: parts_details_mat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY parts_details_mat
    ADD CONSTRAINT parts_details_mat_pkey PRIMARY KEY (id);


--
-- Name: personnel_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_instance
    ADD CONSTRAINT personnel_instance_pkey PRIMARY KEY (id);


--
-- Name: personnel_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_report
    ADD CONSTRAINT personnel_report_pkey PRIMARY KEY (id);


--
-- Name: personnel_task_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel_task_type
    ADD CONSTRAINT personnel_task_type_pkey PRIMARY KEY (id);


--
-- Name: pk_account_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY application
    ADD CONSTRAINT pk_account_id PRIMARY KEY (id);


--
-- Name: pk_country_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT pk_country_id PRIMARY KEY (id);


--
-- Name: pk_menu_id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT pk_menu_id PRIMARY KEY (id);


--
-- Name: pk_support; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY support
    ADD CONSTRAINT pk_support PRIMARY KEY (id);


--
-- Name: prk_personnel; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personnel
    ADD CONSTRAINT prk_personnel PRIMARY KEY (id);


--
-- Name: race_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY race_rewards
    ADD CONSTRAINT race_rewards_pkey PRIMARY KEY (id);


--
-- Name: race_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY race_types
    ADD CONSTRAINT race_types_pkey PRIMARY KEY (id);


--
-- Name: races_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY races
    ADD CONSTRAINT races_pkey PRIMARY KEY (id);


--
-- Name: report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY report
    ADD CONSTRAINT report_pkey PRIMARY KEY (id);


--
-- Name: report_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY report_type
    ADD CONSTRAINT report_type_pkey PRIMARY KEY (id);


--
-- Name: reward_log_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reward_log_events
    ADD CONSTRAINT reward_log_events_pkey PRIMARY KEY (id);


--
-- Name: reward_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reward_log
    ADD CONSTRAINT reward_log_pkey PRIMARY KEY (id);


--
-- Name: reward_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reward
    ADD CONSTRAINT reward_pkey PRIMARY KEY (id);


--
-- Name: rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rule
    ADD CONSTRAINT rule_pkey PRIMARY KEY (id);


--
-- Name: section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY track_section
    ADD CONSTRAINT section_pkey PRIMARY KEY (id);


--
-- Name: shop_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY market_item
    ADD CONSTRAINT shop_item_pkey PRIMARY KEY (id);


--
-- Name: shop_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_report
    ADD CONSTRAINT shop_report_pkey PRIMARY KEY (id);


--
-- Name: task_trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task_trigger
    ADD CONSTRAINT task_trigger_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: tournament_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament
    ADD CONSTRAINT tournament_pkey PRIMARY KEY (id);


--
-- Name: tournament_players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament_players
    ADD CONSTRAINT tournament_players_pkey PRIMARY KEY (id);


--
-- Name: tournament_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament_report
    ADD CONSTRAINT tournament_report_pkey PRIMARY KEY (id);


--
-- Name: tournament_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament_result
    ADD CONSTRAINT tournament_result_pkey PRIMARY KEY (id);


--
-- Name: tournament_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tournament_type
    ADD CONSTRAINT tournament_type_pkey PRIMARY KEY (id);


--
-- Name: track_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY track
    ADD CONSTRAINT track_pkey PRIMARY KEY (id);


--
-- Name: track_top_time_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY track_time
    ADD CONSTRAINT track_top_time_pkey PRIMARY KEY (id);


--
-- Name: transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: travel_report_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY travel_report
    ADD CONSTRAINT travel_report_pkey PRIMARY KEY (id);


--
-- Name: account_level_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX account_level_idx ON account USING btree (level);


--
-- Name: car_key_index; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX car_key_index ON car_options USING btree (car_instance_id, key);


--
-- Name: fki_account_support; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_account_support ON support USING btree (account_id);


--
-- Name: fki_pi_account_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_pi_account_id ON part_instance USING btree (account_id);


--
-- Name: garage_report_account_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX garage_report_account_id_idx ON garage_report USING btree (account_id);


--
-- Name: garage_reports_personnel_instance_id_part_instance_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX garage_reports_personnel_instance_id_part_instance_id_idx ON garage_report USING btree (personnel_instance_id, part_instance_id);


--
-- Name: idx_number; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_number ON menu USING btree (number);


--
-- Name: index_car_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_car_id ON part_model USING btree (car_id);


--
-- Name: index_car_instance_car_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_car_instance_car_id ON car_instance USING btree (car_id);


--
-- Name: index_car_instance_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_car_instance_id ON part_instance USING btree (car_instance_id);


--
-- Name: index_car_instancegarage_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_car_instancegarage_id ON car_instance USING btree (garage_id);


--
-- Name: index_garage_account; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_garage_account ON garage USING btree (account_id);


--
-- Name: index_part_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_part_id ON part_instance USING btree (part_id);


--
-- Name: index_part_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_part_type_id ON part_model USING btree (part_type_id);


--
-- Name: index_part_typename; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX index_part_typename ON part_type USING btree (name);


--
-- Name: market_parts_mat_car_model_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_car_model_idx ON market_parts_mat USING btree (car_model);


--
-- Name: market_parts_mat_level_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_level_idx ON market_parts_mat USING btree (level DESC);


--
-- Name: market_parts_mat_manufacturer_name_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_manufacturer_name_idx ON market_parts_mat USING btree (manufacturer_name);


--
-- Name: market_parts_mat_part_type_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_part_type_id_idx ON market_parts_mat USING btree (part_type_id);


--
-- Name: market_parts_mat_price_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_price_idx ON market_parts_mat USING btree (price);


--
-- Name: market_parts_mat_sort_part_type_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_sort_part_type_idx ON market_parts_mat USING btree (sort_part_type);


--
-- Name: market_parts_mat_unique_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX market_parts_mat_unique_idx ON market_parts_mat USING btree ("unique");


--
-- Name: part_model_level_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX part_model_level_idx ON part_model USING btree (level);


--
-- Name: parts_details_mat_car_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_details_mat_car_id_idx ON parts_details_mat USING btree (car_id);


--
-- Name: parts_details_mat_level_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_details_mat_level_idx ON parts_details_mat USING btree (level);


--
-- Name: parts_details_mat_part_type_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_details_mat_part_type_id_idx ON parts_details_mat USING btree (part_type_id);


--
-- Name: parts_details_mat_price_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_details_mat_price_idx ON parts_details_mat USING btree (price);


--
-- Name: parts_details_mat_sort_part_type_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_details_mat_sort_part_type_idx ON parts_details_mat USING btree (sort_part_type);


--
-- Name: parts_details_mat_unique_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX parts_details_mat_unique_idx ON parts_details_mat USING btree ("unique");


--
-- Name: personnel_report_data_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX personnel_report_data_idx ON personnel_report USING gist (data);


--
-- Name: personnel_sort_indx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX personnel_sort_indx ON personnel USING btree (sort, country_id, skill_repair, skill_engineering);


--
-- Name: tournament_report_account_id_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX tournament_report_account_id_idx ON tournament_report USING btree (account_id);


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE "_RETURN" AS ON SELECT TO car_in_garage DO INSTEAD SELECT ci.id, ci.car_id, ci.garage_id, ci.top_speed, ci.acceleration, ci.stopping, ci.cornering, ci.nitrous, m.name AS manufacturer_name, cm.name, COALESCE(ct.parts_price, (0)::numeric) AS parts_price, COALESCE(ct.parts_price, (0)::numeric) AS total_price, m.picture AS manufacturer_picture, g.account_id, cm.level, cm.year, ci.wear, ci.improvement, ci.active, ci.ready, ci.car_color, ci.power, ci.traction, ci.handling, ci.braking, ci.aero, ci.nos, ci.weight, btrim(lower(replace(cm.name, ' '::text, '_'::text)), ' '::text) AS car_label, ci.prototype, ci.prototype_name, ci.prototype_claimable, ci.prototype_available, cm.manufacturer_id, ct.level AS parts_level FROM ((((car_instance ci JOIN car_model cm ON ((ci.car_id = cm.id))) LEFT JOIN garage g ON ((g.id = ci.garage_id))) JOIN manufacturer m ON ((cm.manufacturer_id = m.id))) LEFT JOIN (SELECT ci.id, ci.car_id, sum(ptc.trash_price) AS parts_price, max(m.level) AS level FROM (((car_instance ci LEFT JOIN part_instance pi ON ((pi.car_instance_id = ci.id))) JOIN part_trash_price ptc ON ((pi.id = ptc.id))) JOIN part_model m ON ((pi.part_id = m.id))) WHERE ((ci.deleted = false) AND (pi.deleted = false)) GROUP BY ci.id) ct ON ((ci.id = ct.id))) WHERE (ci.deleted = false);


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE "_RETURN" AS ON SELECT TO challenge_extended DO INSTEAD SELECT c.id AS challenge_id, c.account_id, c.track_id, c.participants, c.type AS type_id, ct.name AS type, count(ca.id) AS accepts, c.deleted, a.nickname AS user_nickname, a.level AS user_level, t.track_name, t.track_level, t.city_id, t.city_name, t.continent_id, t.continent_name, c.account_min AS profile, c.car_min AS car, t.length AS track_length, t.top_time_exists, t.top_time, t.top_time_id, t.top_time_account_id, t.top_time_name, t.top_time_picture_small, t.top_time_picture_medium, t.top_time_picture_large, c.amount FROM ((((challenge c LEFT JOIN challenge_type ct ON ((ct.id = c.type))) LEFT JOIN challenge_accept ca ON ((ca.challenge_id = c.id))) LEFT JOIN track_master t ON ((t.track_id = c.track_id))) LEFT JOIN account a ON ((a.id = c.account_id))) WHERE (c.deleted = false) GROUP BY c.id, c.account_id, c.track_id, c.participants, c.type, ct.name, c.deleted, a.nickname, a.level, t.track_name, t.track_level, t.city_id, t.city_name, t.continent_id, t.continent_name, c.car_min, t.length, c.amount, t.top_time_exists, t.top_time, t.top_time_id, t.top_time_account_id, t.top_time_name, t.top_time_picture_small, t.top_time_picture_medium, t.top_time_picture_large;


--
-- Name: Set name to label; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "Set name to label" BEFORE INSERT OR UPDATE ON manufacturer FOR EACH ROW EXECUTE PROCEDURE update_label_manufacturer();


--
-- Name: empty_trigger_account_current_energy; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_account_current_energy INSTEAD OF INSERT OR UPDATE ON account_current_energy FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_account_garage; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_account_garage INSTEAD OF INSERT OR UPDATE ON account_garage FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_account_profile; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_account_profile INSTEAD OF INSERT OR UPDATE ON account_profile FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_3d_model; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_3d_model INSTEAD OF INSERT OR UPDATE ON car_3d_model FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_3d_model_backup; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_3d_model_backup INSTEAD OF INSERT OR UPDATE ON car_3d_model_backup FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_in_garage; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_in_garage INSTEAD OF INSERT OR UPDATE ON car_in_garage FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_instance_details; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_instance_details INSTEAD OF INSERT OR UPDATE ON car_instance_details FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_instance_parameter; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_instance_parameter INSTEAD OF INSERT OR UPDATE ON car_instance_parameter FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_instance_parameter_list; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_instance_parameter_list INSTEAD OF INSERT OR UPDATE ON car_instance_parameter_list FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_instance_parts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_instance_parts INSTEAD OF INSERT OR UPDATE ON car_instance_parts FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_market; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_market INSTEAD OF INSERT OR UPDATE ON car_market FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_options_extended; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_options_extended INSTEAD OF INSERT OR UPDATE ON car_options_extended FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_owners; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_owners INSTEAD OF INSERT OR UPDATE ON car_owners FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_car_prototype; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_car_prototype INSTEAD OF INSERT OR UPDATE ON car_prototype FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_challenge_extended; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_challenge_extended INSTEAD OF INSERT OR UPDATE ON challenge_extended FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_garage_parts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_garage_parts INSTEAD OF INSERT OR UPDATE ON garage_parts FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_general_reports; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_general_reports INSTEAD OF INSERT OR UPDATE ON general_reports FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_manufacturer_level; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_manufacturer_level INSTEAD OF INSERT OR UPDATE ON manufacturer_level FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_manufacturer_market; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_manufacturer_market INSTEAD OF INSERT OR UPDATE ON manufacturer_market FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_market_car_instance_parts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_market_car_instance_parts INSTEAD OF INSERT OR UPDATE ON market_car_instance_parts FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_market_part_type; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_market_part_type INSTEAD OF INSERT OR UPDATE ON market_part_type FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_market_part_types; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_market_part_types INSTEAD OF INSERT OR UPDATE ON market_part_types FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_market_parts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_market_parts INSTEAD OF INSERT OR UPDATE ON market_parts FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_market_place; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_market_place INSTEAD OF INSERT OR UPDATE ON market_place FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_market_place_car; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_market_place_car INSTEAD OF INSERT OR UPDATE ON market_place_car FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_part_trash_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_part_trash_price INSTEAD OF INSERT OR UPDATE ON part_trash_price FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_parts_details; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_parts_details INSTEAD OF INSERT OR UPDATE ON parts_details FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_personnel_instance_details; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_personnel_instance_details INSTEAD OF INSERT OR UPDATE ON personnel_instance_details FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_personnel_task_details; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_personnel_task_details INSTEAD OF INSERT OR UPDATE ON personnel_task_details FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_rule_reward; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_rule_reward INSTEAD OF INSERT OR UPDATE ON rule_reward FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_task_extended; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_task_extended INSTEAD OF INSERT OR UPDATE ON task_extended FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_tournament_extended; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_tournament_extended INSTEAD OF INSERT OR UPDATE ON tournament_extended FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_track_city; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_track_city INSTEAD OF INSERT OR UPDATE ON track_city FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: empty_trigger_track_master; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER empty_trigger_track_master INSTEAD OF INSERT OR UPDATE ON track_master FOR EACH ROW EXECUTE PROCEDURE empty_trigger_for_instead_of();


--
-- Name: event_stream_rules_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER event_stream_rules_trigger AFTER INSERT ON rule FOR EACH ROW EXECUTE PROCEDURE rule_to_event_stream();


--
-- Name: event_stream_rules_trigger_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER event_stream_rules_trigger_update AFTER UPDATE ON rule FOR EACH ROW EXECUTE PROCEDURE rule_to_event_stream();

ALTER TABLE rule DISABLE TRIGGER event_stream_rules_trigger_update;


--
-- Name: mat_update_market_parts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER mat_update_market_parts AFTER INSERT OR DELETE OR UPDATE ON part_type FOR EACH ROW EXECUTE PROCEDURE mat_update_market_parts();


--
-- Name: mat_update_market_parts_la; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER mat_update_market_parts_la AFTER INSERT OR DELETE OR UPDATE ON car_model FOR EACH ROW EXECUTE PROCEDURE mat_update_market_parts();


--
-- Name: on_update_car_instance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_car_instance BEFORE INSERT OR UPDATE ON car_instance FOR EACH ROW EXECUTE PROCEDURE car_instance_update_trigger();


--
-- Name: on_update_car_model; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_car_model BEFORE INSERT OR UPDATE ON car_model FOR EACH ROW EXECUTE PROCEDURE car_model_update_trigger();


--
-- Name: on_update_car_model_after; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_car_model_after AFTER INSERT OR DELETE OR UPDATE ON car_model FOR EACH ROW EXECUTE PROCEDURE car_model_update_trigger_after();


--
-- Name: on_update_part_instance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_part_instance AFTER INSERT OR DELETE OR UPDATE ON part_instance FOR EACH ROW EXECUTE PROCEDURE part_instance_update_trigger();


--
-- Name: on_update_part_model; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER on_update_part_model AFTER INSERT OR DELETE OR UPDATE ON part_model FOR EACH ROW EXECUTE PROCEDURE part_model_update_trigger();


--
-- Name: part_modifer_update_mat; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER part_modifer_update_mat AFTER INSERT OR DELETE OR UPDATE ON part_modifier FOR EACH ROW EXECUTE PROCEDURE mat_update_market_parts();


--
-- Name: personnel_before; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER personnel_before BEFORE INSERT OR UPDATE ON personnel FOR EACH ROW EXECUTE PROCEDURE personnel_before();


--
-- Name: personnel_instance_before; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER personnel_instance_before BEFORE INSERT OR UPDATE ON personnel_instance FOR EACH ROW EXECUTE PROCEDURE personnel_before();


--
-- Name: save_garage_rport; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER save_garage_rport INSTEAD OF INSERT OR DELETE OR UPDATE ON garage_reports FOR EACH ROW EXECUTE PROCEDURE save_report();


--
-- Name: save_shop_report; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER save_shop_report INSTEAD OF INSERT OR DELETE OR UPDATE ON shopping_reports FOR EACH ROW EXECUTE PROCEDURE save_report();


--
-- Name: save_travel_report_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER save_travel_report_update BEFORE UPDATE ON account FOR EACH ROW EXECUTE PROCEDURE save_travel_report();


--
-- Name: set_default_values_account; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_default_values_account BEFORE INSERT ON account FOR EACH ROW EXECUTE PROCEDURE set_default_values_account();


--
-- Name: tracker_length_shit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tracker_length_shit AFTER INSERT OR UPDATE ON track_section FOR EACH ROW EXECUTE PROCEDURE update_track_length();


--
-- Name: trigger_track_time_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_track_time_insert AFTER INSERT OR UPDATE ON track_time FOR EACH ROW EXECUTE PROCEDURE trigger_track_time_insert();


--
-- Name: trigger_update_market_parts; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_market_parts AFTER INSERT OR DELETE OR UPDATE ON part_model FOR EACH ROW EXECUTE PROCEDURE mat_update_market_parts();


--
-- Name: update_market_parts_mat; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_market_parts_mat AFTER INSERT OR DELETE OR UPDATE ON manufacturer FOR EACH ROW EXECUTE PROCEDURE mat_update_market_parts();


--
-- Name: update_personnel_report; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_personnel_report INSTEAD OF INSERT OR DELETE OR UPDATE ON personnel_reports FOR EACH ROW EXECUTE PROCEDURE save_report();


--
-- Name: access_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY access
    ADD CONSTRAINT access_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: account_city_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_city_fkey FOREIGN KEY (city) REFERENCES city(id);


--
-- Name: car_instance_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_instance
    ADD CONSTRAINT car_instance_car_id_fkey FOREIGN KEY (car_id) REFERENCES car_model(id);


--
-- Name: car_instance_garage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_instance
    ADD CONSTRAINT car_instance_garage_id_fkey FOREIGN KEY (garage_id) REFERENCES garage(id);


--
-- Name: car_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_model
    ADD CONSTRAINT car_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id);


--
-- Name: challenge_accept_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge_accept
    ADD CONSTRAINT challenge_accept_account_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: challenge_accept_challenge_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge_accept
    ADD CONSTRAINT challenge_accept_challenge_fkey FOREIGN KEY (challenge_id) REFERENCES challenge(id);


--
-- Name: challenges_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge
    ADD CONSTRAINT challenges_account_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: challenges_challenge_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge
    ADD CONSTRAINT challenges_challenge_type_fkey FOREIGN KEY (type) REFERENCES challenge_type(id);


--
-- Name: challenges_track_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY challenge
    ADD CONSTRAINT challenges_track_fkey FOREIGN KEY (track_id) REFERENCES track(id);


--
-- Name: city_continent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_continent_id_fkey FOREIGN KEY (continent_id) REFERENCES continent(id);


--
-- Name: dealer_item_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dealer_item
    ADD CONSTRAINT dealer_item_car_id_fkey FOREIGN KEY (car_id) REFERENCES car_model(id);


--
-- Name: dealer_item_part_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY dealer_item
    ADD CONSTRAINT dealer_item_part_id_fkey FOREIGN KEY (part_id) REFERENCES part_model(id);


--
-- Name: diamond_transaction_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY diamond_transaction
    ADD CONSTRAINT diamond_transaction_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: escrow_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY escrow
    ADD CONSTRAINT escrow_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: fk_account_support; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY support
    ADD CONSTRAINT fk_account_support FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: fk_car_instance_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY car_options
    ADD CONSTRAINT fk_car_instance_id FOREIGN KEY (car_instance_id) REFERENCES car_instance(id);


--
-- Name: fk_pi_account_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_instance
    ADD CONSTRAINT fk_pi_account_id FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: garage_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY garage
    ADD CONSTRAINT garage_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: market_item_car_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY market_item
    ADD CONSTRAINT market_item_car_instance_id_fkey FOREIGN KEY (car_instance_id) REFERENCES car_instance(id);


--
-- Name: market_item_part_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY market_item
    ADD CONSTRAINT market_item_part_instance_id_fkey FOREIGN KEY (part_instance_id) REFERENCES part_instance(id);


--
-- Name: part_instance_car_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_instance
    ADD CONSTRAINT part_instance_car_instance_id_fkey FOREIGN KEY (car_instance_id) REFERENCES car_instance(id);


--
-- Name: part_instance_garage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_instance
    ADD CONSTRAINT part_instance_garage_id_fkey FOREIGN KEY (garage_id) REFERENCES garage(id);


--
-- Name: part_instance_part_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_instance
    ADD CONSTRAINT part_instance_part_id_fkey FOREIGN KEY (part_id) REFERENCES part_model(id);


--
-- Name: part_part_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY part_model
    ADD CONSTRAINT part_part_type_id_fkey FOREIGN KEY (part_type_id) REFERENCES part_type(id);


--
-- Name: personnel_instance_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_instance
    ADD CONSTRAINT personnel_instance_fkey1 FOREIGN KEY (task_id) REFERENCES personnel_task_type(id);


--
-- Name: personnel_instance_garage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY personnel_instance
    ADD CONSTRAINT personnel_instance_garage_id_fkey FOREIGN KEY (garage_id) REFERENCES garage(id);


--
-- Name: race_rewards_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY race_rewards
    ADD CONSTRAINT race_rewards_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: race_rewards_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY race_rewards
    ADD CONSTRAINT race_rewards_race_id_fkey FOREIGN KEY (race_id) REFERENCES races(id);


--
-- Name: report_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY report
    ADD CONSTRAINT report_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: section_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track_section
    ADD CONSTRAINT section_track_id_fkey FOREIGN KEY (track_id) REFERENCES track(id);


--
-- Name: task_trigger_task_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY task_trigger
    ADD CONSTRAINT task_trigger_task_fkey FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE;


--
-- Name: tournament_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament
    ADD CONSTRAINT tournament_car_id_fkey FOREIGN KEY (car_id) REFERENCES car_model(id);


--
-- Name: tournament_players_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_players
    ADD CONSTRAINT tournament_players_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: tournament_players_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_players
    ADD CONSTRAINT tournament_players_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES tournament(id);


--
-- Name: tournament_report_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_report
    ADD CONSTRAINT tournament_report_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES tournament(id);


--
-- Name: tournament_result_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_result
    ADD CONSTRAINT tournament_result_account_id_fkey FOREIGN KEY (participant1_id) REFERENCES account(id);


--
-- Name: tournament_result_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_result
    ADD CONSTRAINT tournament_result_race_id_fkey FOREIGN KEY (race_id) REFERENCES races(id);


--
-- Name: tournament_result_tournament_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament_result
    ADD CONSTRAINT tournament_result_tournament_id_fkey FOREIGN KEY (tournament_id) REFERENCES tournament(id);


--
-- Name: tournament_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament
    ADD CONSTRAINT tournament_track_id_fkey FOREIGN KEY (track_id) REFERENCES track(id);


--
-- Name: tournament_type->tournament; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tournament
    ADD CONSTRAINT "tournament_type->tournament" FOREIGN KEY (tournament_type_id) REFERENCES tournament_type(id);


--
-- Name: track_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track
    ADD CONSTRAINT track_city_id_fkey FOREIGN KEY (city_id) REFERENCES city(id);


--
-- Name: track_top_time_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY track_time
    ADD CONSTRAINT track_top_time_account_id_fkey FOREIGN KEY (account_id) REFERENCES account(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

