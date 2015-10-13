-- simple input
SELECT '120'::base36;
SELECT '3c'::base36;
-- case insensitivity
SELECT '3C'::base36;
SELECT 'FoO'::base36;
-- invalid characters
SELECT 'foo bar'::base36;
SELECT 'abc$%2'::base36;
-- negative values
SELECT '-10'::base36;
-- to big values
SELECT 'abcdefghi'::base36;

-- storage
BEGIN;
CREATE TABLE base36_test(val base36);
INSERT INTO base36_test VALUES ('123'), ('3c'), ('5A'), ('zZz');
SELECT * FROM base36_test;
UPDATE base36_test SET val = '567a' where val = '123';
SELECT * FROM base36_test;
UPDATE base36_test SET val = '-aa' where val = '3c';
SELECT * FROM base36_test;
ROLLBACK;
