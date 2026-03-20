
--             CREO IL DATABASE DEL CAPSTONE
-- =====================================================

CREATE DATABASE capstone_calcio_2024_2025;


--           SELEZIONO IL DATABASE DEL CAPSTONE
-- =====================================================

USE capstone_calcio_2024_2025;


--        CREO LA TABELLA DELLA SERIE A CLEAN
-- =====================================================

CREATE TABLE matches_serie_a_clean (

    Date TEXT,
    HomeTeam TEXT,
    AwayTeam TEXT,
    FTHG INT,
    FTAG INT,
    FTR TEXT,
    HS INT,
    `AS` INT,
    HST INT,
    AST INT

);


--     CREO LA TABELLA DELLA PREMIER LEAGUE CLEAN
-- =====================================================

CREATE TABLE matches_premier_league_clean
LIKE matches_serie_a_clean;


--         CREO LA TABELLA DELLA LA LIGA CLEAN
-- =====================================================

CREATE TABLE matches_la_liga_clean
LIKE matches_serie_a_clean;


--     VERIFICO IL NUMERO DI PARTITE IMPORTATE
-- =====================================================

SELECT COUNT(*) AS numero_partite
FROM matches_serie_a_clean;

SELECT COUNT(*) AS numero_partite
FROM matches_premier_league_clean;

SELECT COUNT(*) AS numero_partite
FROM matches_la_liga_clean;

--           CREO I RISULTATI IN CASA PREMIER LEAGUE
-- =====================================================

SELECT
    HomeTeam AS squadra,
    FTHG AS goal_fatti,
    FTAG AS goal_subiti,

    CASE
        WHEN FTR = 'H' THEN 3
        WHEN FTR = 'D' THEN 1
        ELSE 0
    END AS punti

FROM matches_premier_league_clean;

--        CREO I RISULTATI IN TRASFERTA PREMIER LEAGUE
-- =====================================================

SELECT
    AwayTeam AS squadra,
    FTAG AS goal_fatti,
    FTHG AS goal_subiti,

    CASE
        WHEN FTR = 'A' THEN 3
        WHEN FTR = 'D' THEN 1
        ELSE 0
    END AS punti

FROM matches_premier_league_clean;

--             CREO LA CLASSIFICA PREMIER LEAGUE
-- =====================================================

SELECT
    squadra,
    SUM(punti) AS punti,
    SUM(goal_fatti) AS goal_fatti,
    SUM(goal_subiti) AS goal_subiti

FROM (

    SELECT
        HomeTeam AS squadra,
        FTHG AS goal_fatti,
        FTAG AS goal_subiti,

        CASE
            WHEN FTR = 'H' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS punti

    FROM matches_premier_league_clean


    UNION ALL


    SELECT
        AwayTeam AS squadra,
        FTAG AS goal_fatti,
        FTHG AS goal_subiti,

        CASE
            WHEN FTR = 'A' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS punti
        
	FROM matches_premier_league_clean

) AS risultati

GROUP BY squadra

ORDER BY punti DESC;

--            CREO I RISULTATI IN CASA LA LIGA
-- =====================================================

SELECT
    HomeTeam AS squadra,
    FTHG AS goal_fatti,
    FTAG AS goal_subiti,

    CASE
        WHEN FTR = 'H' THEN 3
        WHEN FTR = 'D' THEN 1
        ELSE 0
    END AS punti

FROM matches_la_liga_clean;

--         CREO I RISULTATI IN TRASFERTA LA LIGA
-- =====================================================

SELECT
    AwayTeam AS squadra,
    FTAG AS goal_fatti,
    FTHG AS goal_subiti,

    CASE
        WHEN FTR = 'A' THEN 3
        WHEN FTR = 'D' THEN 1
        ELSE 0
    END AS punti

FROM matches_la_liga_clean;

--              CREO LA CLASSIFICA LA LIGA
-- =====================================================

SELECT
    squadra,
    SUM(punti) AS punti,
    SUM(goal_fatti) AS goal_fatti,
    SUM(goal_subiti) AS goal_subiti

FROM (

    SELECT
        HomeTeam AS squadra,
        FTHG AS goal_fatti,
        FTAG AS goal_subiti,

        CASE
            WHEN FTR = 'H' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS punti

    FROM matches_la_liga_clean


    UNION ALL


    SELECT
        AwayTeam AS squadra,
        FTAG AS goal_fatti,
        FTHG AS goal_subiti,

        CASE
            WHEN FTR = 'A' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS punti

    FROM matches_la_liga_clean

) AS risultati

GROUP BY squadra

ORDER BY punti DESC;

--     SELEZIONO TUTTE LE PARTITE SERIE A PER POWER BI
-- =====================================================

SELECT *
FROM matches_serie_a_clean;

--        TROVO I TOP ATTACCHI PREMIER (GOAL FATTI)
-- =====================================================

SELECT
    squadra,
    SUM(goal_fatti) AS goal_fatti
FROM (

    SELECT
        HomeTeam AS squadra,
        FTHG AS goal_fatti
    FROM matches_premier_league_clean

    UNION ALL

    SELECT
        AwayTeam AS squadra,
        FTAG AS goal_fatti
    FROM matches_premier_league_clean

) AS x
GROUP BY squadra
ORDER BY goal_fatti DESC;

--        TROVO LE MIGLIORI DIFESE PREMIER (GOAL SUBITI)
-- =====================================================

SELECT
    squadra,
    SUM(goal_subiti) AS goal_subiti
FROM (

    SELECT
        HomeTeam AS squadra,
        FTAG AS goal_subiti
    FROM matches_premier_league_clean

    UNION ALL

    SELECT
        AwayTeam AS squadra,
        FTHG AS goal_subiti
    FROM matches_premier_league_clean

) AS x
GROUP BY squadra
ORDER BY goal_subiti ASC;

--          TROVO I TOP ATTACCHI LA LIGA (GOAL FATTI)
-- =====================================================

SELECT
    squadra,
    SUM(goal_fatti) AS goal_fatti
FROM (

    SELECT
        HomeTeam AS squadra,
        FTHG AS goal_fatti
    FROM matches_la_liga_clean

    UNION ALL

    SELECT
        AwayTeam AS squadra,
        FTAG AS goal_fatti
    FROM matches_la_liga_clean

) AS x
GROUP BY squadra
ORDER BY goal_fatti DESC;

--          TROVO LE MIGLIORI DIFESE LA LIGA (GOAL SUBITI)
-- =====================================================

SELECT
    squadra,
    SUM(goal_subiti) AS goal_subiti
FROM (

    SELECT
        HomeTeam AS squadra,
        FTAG AS goal_subiti
    FROM matches_la_liga_clean

    UNION ALL

    SELECT
        AwayTeam AS squadra,
        FTHG AS goal_subiti
    FROM matches_la_liga_clean

) AS x
GROUP BY squadra
ORDER BY goal_subiti ASC;

--          TROVO I TOP ATTACCHI SERIE A (GOAL FATTI)
-- =====================================================

SELECT
    squadra,
    SUM(goal_fatti) AS goal_fatti
FROM (

    SELECT
        HomeTeam AS squadra,
        FTHG AS goal_fatti
    FROM matches_serie_a_clean

    UNION ALL

    SELECT
        AwayTeam AS squadra,
        FTAG AS goal_fatti
    FROM matches_serie_a_clean

) AS x
GROUP BY squadra
ORDER BY goal_fatti DESC;

--         TROVO LE MIGLIORI DIFESE SERIE A (GOAL SUBITI)
-- =====================================================

SELECT
    squadra,
    SUM(goal_subiti) AS goal_subiti
FROM (

    SELECT
        HomeTeam AS squadra,
        FTAG AS goal_subiti
    FROM matches_serie_a_clean

    UNION ALL

    SELECT
        AwayTeam AS squadra,
        FTHG AS goal_subiti
    FROM matches_serie_a_clean

) AS x
GROUP BY squadra
ORDER BY goal_subiti ASC;

--          TROVO IL NUMERO DI VITTORIE SERIE A
-- =====================================================

SELECT
    squadra,
    COUNT(*) AS vittorie
FROM (

    SELECT
        HomeTeam AS squadra
    FROM matches_serie_a_clean
    WHERE FTR = 'H'

    UNION ALL

    SELECT
        AwayTeam AS squadra
    FROM matches_serie_a_clean
    WHERE FTR = 'A'

) AS x

GROUP BY squadra
ORDER BY vittorie DESC;

--        TROVO IL NUMERO DI VITTORIE PREMIER LEAGUE
-- =====================================================

SELECT
    squadra,
    COUNT(*) AS vittorie
FROM (

    SELECT
        HomeTeam AS squadra
    FROM matches_premier_league_clean
    WHERE FTR = 'H'

    UNION ALL

    SELECT
        AwayTeam AS squadra
    FROM matches_premier_league_clean
    WHERE FTR = 'A'

) AS x

GROUP BY squadra
ORDER BY vittorie DESC;

--          TROVO IL NUMERO DI VITTORIE LA LIGA
-- =====================================================

SELECT
    squadra,
    COUNT(*) AS vittorie
FROM (

    SELECT
        HomeTeam AS squadra
    FROM matches_la_liga_clean
    WHERE FTR = 'H'

    UNION ALL

    SELECT
        AwayTeam AS squadra
    FROM matches_la_liga_clean
    WHERE FTR = 'A'

) AS x

GROUP BY squadra
ORDER BY vittorie DESC;




