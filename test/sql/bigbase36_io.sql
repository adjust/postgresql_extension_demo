-- simple input
SELECT '120'::bigbase36;
SELECT '3c'::bigbase36;
-- case insensitivity
SELECT '3C'::bigbase36;
SELECT 'FoO'::bigbase36;
-- invalid characters
SELECT 'foo bar'::bigbase36;
SELECT 'abc$%2'::bigbase36;
-- negative values
SELECT '-10'::bigbase36;
-- to big values
SELECT 'abcdefghijklmn'::bigbase36;

-- storage
BEGIN;
CREATE TABLE base36_test(val bigbase36);
INSERT INTO base36_test VALUES ('123'), ('3c'), ('5A'), ('zZz');
SELECT * FROM base36_test;
UPDATE base36_test SET val = '567a' where val = '123';
SELECT * FROM base36_test;
UPDATE base36_test SET val = '-aa' where val = '3c';
SELECT * FROM base36_test;
ROLLBACK;
