-- comparison
SELECT '120'::bigbase36 > '3c'::bigbase36;
SELECT '120'::bigbase36 >= '3c'::bigbase36;
SELECT '120'::bigbase36 < '3c'::bigbase36;
SELECT '120'::bigbase36 <= '3c'::bigbase36;
SELECT '120'::bigbase36 <> '3c'::bigbase36;
SELECT '120'::bigbase36 = '3c'::bigbase36;

-- comparison equals
SELECT '120'::bigbase36 > '120'::bigbase36;
SELECT '120'::bigbase36 >= '120'::bigbase36;
SELECT '120'::bigbase36 < '120'::bigbase36;
SELECT '120'::bigbase36 <= '120'::bigbase36;
SELECT '120'::bigbase36 <> '120'::bigbase36;
SELECT '120'::bigbase36 = '120'::bigbase36;

-- comparison negation
SELECT NOT '120'::bigbase36 > '120'::bigbase36;
SELECT NOT '120'::bigbase36 >= '120'::bigbase36;
SELECT NOT '120'::bigbase36 < '120'::bigbase36;
SELECT NOT '120'::bigbase36 <= '120'::bigbase36;
SELECT NOT '120'::bigbase36 <> '120'::bigbase36;
SELECT NOT '120'::bigbase36 = '120'::bigbase36;

--commutator and negator
BEGIN;
CREATE TABLE base36_test AS
SELECT i::base36 as val FROM generate_series(1,10000) i;
CREATE INDEX ON base36_test(val);
ANALYZE;
SET enable_seqscan TO off;
EXPLAIN (COSTS OFF) SELECT * FROM base36_test where NOT val < 'c1';
EXPLAIN (COSTS OFF) SELECT * FROM base36_test where NOT 'c1' > val;
EXPLAIN (COSTS OFF) SELECT * FROM base36_test where 'c1' > val;
-- hash aggregate
SET enable_seqscan TO on;
EXPLAIN (COSTS OFF) SELECT val, COUNT(*) FROM base36_test GROUP BY 1;
ROLLBACK;