-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION base36" to load this file. \quit

CREATE FUNCTION bigbase36_in(cstring)
RETURNS bigbase36
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION bigbase36_out(bigbase36)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE bigbase36 (
  INPUT          = bigbase36_in,
  OUTPUT         = bigbase36_out,
  LIKE           = bigint
);

CREATE FUNCTION bigbase36_eq(bigbase36, bigbase36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int8eq';

CREATE FUNCTION bigbase36_ne(bigbase36, bigbase36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int8ne';

CREATE FUNCTION bigbase36_lt(bigbase36, bigbase36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int8lt';

CREATE FUNCTION bigbase36_le(bigbase36, bigbase36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int8le';

CREATE FUNCTION bigbase36_gt(bigbase36, bigbase36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int8gt';

CREATE FUNCTION bigbase36_ge(bigbase36, bigbase36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int8ge';

CREATE FUNCTION bigbase36_cmp(bigbase36, bigbase36)
RETURNS integer LANGUAGE internal IMMUTABLE AS 'btint8cmp';

CREATE FUNCTION hash_bigbase36(bigbase36)
RETURNS integer LANGUAGE internal IMMUTABLE AS 'hashint8';

CREATE OPERATOR = (
  LEFTARG = bigbase36,
  RIGHTARG = bigbase36,
  PROCEDURE = bigbase36_eq,
  COMMUTATOR = '=',
  NEGATOR = '<>',
  RESTRICT = eqsel,
  JOIN = eqjoinsel,
  HASHES, MERGES
);

CREATE OPERATOR <> (
  LEFTARG = bigbase36,
  RIGHTARG = bigbase36,
  PROCEDURE = bigbase36_ne,
  COMMUTATOR = '<>',
  NEGATOR = '=',
  RESTRICT = neqsel,
  JOIN = neqjoinsel
);

CREATE OPERATOR < (
  LEFTARG = bigbase36,
  RIGHTARG = bigbase36,
  PROCEDURE = bigbase36_lt,
  COMMUTATOR = > ,
  NEGATOR = >= ,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);

CREATE OPERATOR <= (
  LEFTARG = bigbase36,
  RIGHTARG = bigbase36,
  PROCEDURE = bigbase36_le,
  COMMUTATOR = >= ,
  NEGATOR = > ,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);

CREATE OPERATOR > (
  LEFTARG = bigbase36,
  RIGHTARG = bigbase36,
  PROCEDURE = bigbase36_gt,
  COMMUTATOR = < ,
  NEGATOR = <= ,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);

CREATE OPERATOR >= (
  LEFTARG = bigbase36,
  RIGHTARG = bigbase36,
  PROCEDURE = bigbase36_ge,
  COMMUTATOR = '<=' ,
  NEGATOR = '<' ,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);

CREATE OPERATOR CLASS btree_bigbase36_ops
DEFAULT FOR TYPE bigbase36 USING btree
AS
        OPERATOR        1       <  ,
        OPERATOR        2       <= ,
        OPERATOR        3       =  ,
        OPERATOR        4       >= ,
        OPERATOR        5       >  ,
        FUNCTION        1       bigbase36_cmp(bigbase36, bigbase36);

CREATE OPERATOR CLASS hash_bigbase36_ops
DEFAULT FOR TYPE bigbase36 USING hash AS
        OPERATOR        1       = ,
        FUNCTION        1       hash_bigbase36(bigbase36);

CREATE CAST (bigint as bigbase36) WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (bigbase36 as bigint) WITHOUT FUNCTION AS ASSIGNMENT;
