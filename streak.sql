CREATE OR REPLACE VIEW players_with_highest_winstreaks AS (
  WITH augment_matches AS (
    SELECT 
      GAMEID AS gameid,
      T1P1_SUMMONERID AS summonerid,
      T1P1_SUMMONERNAME AS summonername,
      TEAM,
      T1P1_LP AS leaguepoints,
      T1P1_KILLS AS kills,
      T1P1_ASSISTS AS assists,
      T1P1_DEATHS AS deaths,
      T1P1_GOLDEARNED AS goldearned,
      T1P1_TOTALDAMAGEDEALTTOCHAMPIONS AS totaldmgdealttochampions,
      T1P1_BAN_CHAMPID AS banchampid,
      T1P1_CHAMPID AS champid,
      AVERAGE_LP AS averagelp,
      T1P1_ROLE AS role,
      T1_TEAMID AS teamid,
      CASE 
        WHEN TEAM = 'team1' AND T1_WIN = 0 THEN 0  
        WHEN TEAM = 'team2' AND T1_WIN = 0 THEN 1
        WHEN TEAM = 'team1' AND T1_WIN = 1 THEN 1  
        WHEN TEAM = 'team2' AND T1_WIN = 1 THEN 0
      ELSE 0 END AS win,
      GAMECREATION AS gamecreation
    FROM all_players
  ),
  lagged AS (
    SELECT 
        *, 
        LAG(win, 1) OVER (PARTITION BY summonerid ORDER BY gamecreation) AS did_win
    FROM augment_matches
  ),
  streak_groups AS(
    SELECT 
    *,
    CASE WHEN win != did_win THEN 1 else 0 END as streak_changed
    FROM lagged
  ),
  grouped AS (
    SELECT 
          *,
          SUM(streak_changed) OVER(PARTITION BY summonerid ORDER BY gamecreation) AS streak_group
    FROM streak_groups
  ),
  lengths AS (
    SELECT 
          summonerid,
          summonername,
          gamecreation,
          did_win,
          gameid,
          ROW_NUMBER() OVER(PARTITION BY summonerid, streak_group ORDER BY gamecreation, did_win) as streak_length
    FROM grouped
  )
  ,
  augmented_streaks AS (
    SELECT 
          summonerid,
          summonername,
          CASE WHEN did_win = 0 THEN 'losing' ELSE 'winning' END AS streak_type,
          streak_length,
          gamecreation AS last_match_date
    FROM lengths
    ORDER BY streak_length DESC
  )

  SELECT 
      summonerid,
      summonername,
      streak_type,
      MAX(streak_length) AS longest_streak
  FROm augmented_streaks
  WHERE summonerid != '#NAME?' AND streak_type = 'winning'
  GROUP BY summonerid, summonername, streak_type
  ORDER BY MAX(streak_length) DESC
)


