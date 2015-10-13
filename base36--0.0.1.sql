-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION base36" to load this file. \quit
CREATE FUNCTION base36_encode(digits int)
RETURNS text
LANGUAGE plpgsql IMMUTABLE STRICT
  AS $$
    DECLARE
      chars char[];
      ret varchar;
      val int;
    BEGIN
      chars := ARRAY[
                '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h',
                'i','j','k','l','m','n','o','p','q','r','s','t', 'u','v','w','x','y','z'
              ];

      val := digits;
      ret := '';

    WHILE val != 0 LOOP
      ret := chars[(val % 36)+1] || ret;
      val := val / 36;
    END LOOP;

    RETURN(ret);
    END;
  $$;