-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION base36" to load this file. \quit

CREATE FUNCTION base36_in(cstring)
RETURNS base36
AS '$libdir/base36'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION base36_out(base36)
RETURNS cstring
AS '$libdir/base36'
LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE base36 (
  INPUT          = base36_in,
  OUTPUT         = base36_out,
  LIKE           = integer
);

CREATE FUNCTION base36_eq(base36, base36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4eq';

CREATE FUNCTION base36_ne(base36, base36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4ne';

CREATE FUNCTION base36_lt(base36, base36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4lt';

CREATE FUNCTION base36_le(base36, base36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4le';

CREATE FUNCTION base36_gt(base36, base36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4gt';

CREATE FUNCTION base36_ge(base36, base36)
RETURNS boolean LANGUAGE internal IMMUTABLE AS 'int4ge';

CREATE FUNCTION base36_cmp(base36, base36)
RETURNS integer LANGUAGE internal IMMUTABLE AS 'btint4cmp';

CREATE FUNCTION hash_base36(base36)
RETURNS integer LANGUAGE internal IMMUTABLE AS 'hashint4';

CREATE OPERATOR = (
  LEFTARG = base36,
  RIGHTARG = base36,
  PROCEDURE = base36_eq,
  COMMUTATOR = '=',
  NEGATOR = '<>',
  RESTRICT = eqsel,
  JOIN = eqjoinsel,
  HASHES, MERGES
);

CREATE OPERATOR <> (
  LEFTARG = base36,
  RIGHTARG = base36,
  PROCEDURE = base36_ne,
  COMMUTATOR = '<>',
  NEGATOR = '=',
  RESTRICT = neqsel,
  JOIN = neqjoinsel
);

CREATE OPERATOR < (
  LEFTARG = base36,
  RIGHTARG = base36,
  PROCEDURE = base36_lt,
  COMMUTATOR = > ,
  NEGATOR = >= ,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);

CREATE OPERATOR <= (
  LEFTARG = base36,
  RIGHTARG = base36,
  PROCEDURE = base36_le,
  COMMUTATOR = >= ,
  NEGATOR = > ,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel
);

CREATE OPERATOR > (
  LEFTARG = base36,
  RIGHTARG = base36,
  PROCEDURE = base36_gt,
  COMMUTATOR = < ,
  NEGATOR = <= ,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);

CREATE OPERATOR >= (
  LEFTARG = base36,
  RIGHTARG = base36,
  PROCEDURE = base36_ge,
  COMMUTATOR = <= ,
  NEGATOR = < ,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel
);

CREATE OPERATOR CLASS btree_base36_ops
DEFAULT FOR TYPE base36 USING btree
AS
        OPERATOR        1       <  ,
        OPERATOR        2       <= ,
        OPERATOR        3       =  ,
        OPERATOR        4       >= ,
        OPERATOR        5       >  ,
        FUNCTION        1       base36_cmp(base36, base36);

CREATE OPERATOR CLASS hash_base36_ops
    DEFAULT FOR TYPE base36 USING hash AS
        OPERATOR        1       = ,
        FUNCTION        1       hash_base36(base36);