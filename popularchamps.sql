CREATE OR REPLACE VIEW mostplayedchampions AS
(
    SELECT
        T1P1_CHAMPID AS champion,
        COUNT(*) AS total_count,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS ranking
    FROM players_with_highest_winstreaks awhp
    JOIN all_players ap
    ON awhp.summonerid = ap.T1P1_SUMMONERID AND awhp.summonername = ap.T1P1_SUMMONERNAME
    WHERE longest_streak >= 10
    GROUP BY T1P1_CHAMPID
)