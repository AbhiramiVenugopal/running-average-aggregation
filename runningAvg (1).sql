\echo -- creating table "Stream"

drop table if exists Stream;
create table Stream (
    id      int,
    grp     int,
    measure int,
    constraint streamPK
        primary key (id),
    constraint idNotNeg
        check (id >= 0),
    constraint grpNotNeg
        check (grp >= 0)
);

\echo -- populating "Stream"

insert into Stream (id, grp, measure)
values
    ( 0, 0,  2),
    ( 1, 0,  3),
    ( 2, 1,  5),
    ( 3, 1,  7),
    ( 4, 1, 11),
    ( 5, 0, 13),
    ( 6, 0, 17),
    ( 7, 0, 19),
    ( 8, 0, 23),
    ( 9, 2, 29),
    (10, 2, 31),
    (11, 5, 37),
    (12, 3, 41),
    (13, 3, 43);

CREATE TYPE avgState AS (
    sum     NUMERIC,
    count   INT
);

CREATE OR REPLACE FUNCTION runningAvg_state(state avgState, val INT, b BOOLEAN)
RETURNS avgState AS $$
BEGIN
    IF b THEN
        state.sum := val;
        state.count := 1;
    ELSE
        state.sum := state.sum + val;
        state.count := state.count + 1;
    END IF;
    RETURN state;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION runningAvg_final(state avgState)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
   
    IF state.count = 0 THEN
        
        RETURN NULL;
    ELSE
        
        RETURN state.sum / state.count;
    END IF;
END;
$$;

DROP AGGREGATE IF EXISTS runningAvg(INT, BOOLEAN);
CREATE AGGREGATE runningAvg(INT, BOOLEAN) (
    SFUNC = runningAvg_state,
    STYPE = avgState,
    FINALFUNC = runningAvg_final,
    INITCOND = '(0,0)'
);



WITH thing1 AS (
    SELECT
        id,
        grp,
        measure,
        CASE WHEN LAG(grp) OVER (ORDER BY id) IS DISTINCT FROM grp THEN 1 ELSE 0 END AS is_new_group
    FROM Stream
),

thing2 AS (
    SELECT
        id,
        grp,
        measure,
        SUM(is_new_group) OVER (ORDER BY id) AS partition_id
    FROM thing1
),

thing3 AS (
    SELECT
        id,
        grp,
        measure,
        AVG(measure) OVER (
            PARTITION BY grp, partition_id
            ORDER BY id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_avg
    FROM thing2
)
SELECT
    id,
    grp,
    measure,
    running_avg
FROM thing3
ORDER BY id;


