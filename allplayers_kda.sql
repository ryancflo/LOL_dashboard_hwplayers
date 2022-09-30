CREATE OR REPLACE VIEW allplayers_kda AS
(
  SELECT
    ROUND(AVG(ap.T1P1_KILLS), 2) AS average_kills,
    ROUND(AVG(ap.T1P1_ASSISTS), 2) AS average_assists,
    ROUND(AVG(ap.T1P1_DEATHS), 2) AS average_deaths,
    CASE
        WHEN (AVG(ap.T1P1_KILLS) + AVG(ap.T1P1_ASSISTS)) > 0 AND AVG(ap.T1P1_DEATHS) = 0 THEN ROUND((AVG(ap.T1P1_KILLS) + AVG(ap.T1P1_ASSISTS))/ 1, 2)
        WHEN (AVG(ap.T1P1_KILLS) + AVG(ap.T1P1_ASSISTS)) = 0 AND AVG(ap.T1P1_DEATHS) = 0 THEN 1
        ELSE ROUND((AVG(ap.T1P1_KILLS) + AVG(ap.T1P1_ASSISTS))/ AVG(ap.T1P1_DEATHS), 2) END AS kda_ratio
  FROM all_players ap
)
