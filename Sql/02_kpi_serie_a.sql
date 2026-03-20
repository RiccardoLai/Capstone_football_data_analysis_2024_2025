CREATE DATABASE capstone_calcio_24_25;

USE capstone_calcio_2425;

--                                                   VERIFICA NUMERO PARTITE IMPORTATE SERIE A

SELECT COUNT(*) AS numero_partite
FROM matches_serie_a_clean;

--                                                   CLASSIFICA SERIE A (PUNTI + GOAL FATTI/SUBITI)

SELECT
    Team,
    SUM(Points) AS punti,
    SUM(GoalScored) AS goal_fatti,
    SUM(GoalConceded) AS goal_subiti,
    SUM(GoalScored) - SUM(GoalConceded) AS differenza_goal
FROM (

    -- PARTITE IN CASA
    SELECT
        HomeTeam AS Team,
        FTHG AS GoalScored,
        FTAG AS GoalConceded,
        CASE
            WHEN FTR = 'H' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS Points
    FROM matches_serie_a_clean

    UNION ALL

    -- PARTITE IN TRASFERTA
    SELECT
        AwayTeam AS Team,
        FTAG AS GoalScored,
        FTHG AS GoalConceded,
        CASE
            WHEN FTR = 'A' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS Points
    FROM matches_serie_a_clean

) AS all_matches

GROUP BY Team

ORDER BY punti DESC, differenza_goal DESC, goal_fatti DESC; 

--                                                 TOP ATTACCHI SERIE A: GOAL FATTI PER SQUADRA

SELECT
    Team,
    SUM(GoalScored) AS goal_fatti
FROM (
    SELECT HomeTeam AS Team, FTHG AS GoalScored
    FROM matches_serie_a_clean

    UNION ALL

    SELECT AwayTeam AS Team, FTAG AS GoalScored
    FROM matches_serie_a_clean
) AS x
GROUP BY Team
ORDER BY goal_fatti DESC;

--                                                MIGLIORI DIFESE SERIE A: GOAL SUBITI PER SQUADRA

SELECT
    Team,
    SUM(GoalConceded) AS goal_subiti
FROM (
    SELECT HomeTeam AS Team, FTAG AS GoalConceded
    FROM matches_serie_a_clean

    UNION ALL

    SELECT AwayTeam AS Team, FTHG AS GoalConceded
    FROM matches_serie_a_clean
) AS x
GROUP BY Team
ORDER BY goal_subiti ASC;

--                                                       GOAL PER PARTITA NAPOLI vs CAGLIARI

WITH all_matches AS (
    -- Casa
    SELECT
        HomeTeam AS Team,
        FTHG AS GoalScored,
        1 AS MatchesPlayed
    FROM matches_serie_a_clean

    UNION ALL

    -- Trasferta
    SELECT
        AwayTeam AS Team,
        FTAG AS GoalScored,
        1 AS MatchesPlayed
    FROM matches_serie_a_clean
)
SELECT
    Team,
    SUM(GoalScored) AS goal_fatti,
    SUM(MatchesPlayed) AS partite,
    ROUND(SUM(GoalScored) / SUM(MatchesPlayed), 3) AS goal_per_partita
FROM all_matches
WHERE Team IN ('Napoli', 'Cagliari')
GROUP BY Team
ORDER BY goal_per_partita DESC;

--                                                         GOAL PER TIRO IN PORTA

WITH all_stats AS (

    SELECT
        HomeTeam AS Team,
        FTHG AS Goals,
        HST AS ShotsOnTarget
    FROM matches_serie_a_clean

    UNION ALL

    SELECT
        AwayTeam AS Team,
        FTAG AS Goals,
        AST AS ShotsOnTarget
    FROM matches_serie_a_clean

)

SELECT
    Team,
    SUM(Goals) AS goal_totali,
    SUM(ShotsOnTarget) AS tiri_in_porta,
    ROUND(SUM(Goals) / SUM(ShotsOnTarget), 3) AS efficienza
FROM all_stats
WHERE Team IN ('Napoli', 'Cagliari')
GROUP BY Team
ORDER BY efficienza DESC;

--                                                      CLASSIFICA COMPLETA SERIE A

WITH risultati AS (

    SELECT
        HomeTeam AS Team,
        FTHG AS goal_fatti,
        FTAG AS goal_subiti,
        CASE
            WHEN FTR = 'H' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS punti
    FROM matches_serie_a_clean

    UNION ALL

    SELECT
        AwayTeam AS Team,
        FTAG AS goal_fatti,
        FTHG AS goal_subiti,
        CASE
            WHEN FTR = 'A' THEN 3
            WHEN FTR = 'D' THEN 1
            ELSE 0
        END AS punti
    FROM matches_serie_a_clean

)

SELECT
    Team,
    SUM(punti) AS punti,
    SUM(goal_fatti) AS goal_fatti,
    SUM(goal_subiti) AS goal_subiti,
    SUM(goal_fatti) - SUM(goal_subiti) AS differenza_reti
FROM risultati
GROUP BY Team
ORDER BY punti DESC, differenza_reti DESC;

--                                                      CREO TABELLA PREMIER LEAGUE

CREATE TABLE MATCHES_PREMIER_LEAGUE_CLEAN
LIKE MATCHES_SERIE_A_CLEAN;

--                                                         CREO TABELLA LA LIGA

CREATE TABLE MATCHES_LA_LIGA_CLEAN
LIKE MATCHES_SERIE_A_CLEAN;
