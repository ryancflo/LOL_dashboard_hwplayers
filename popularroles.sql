CREATE OR REPLACE VIEW roles_percentage AS
(
    SELECT
        T1P1_ROLE AS role,
        COUNT(*) AS total_count
    FROM players_with_highest_winstreaks awhp
    JOIN all_players ap
    ON awhp.summonerid = ap.T1P1_SUMMONERID AND awhp.summonername = ap.T1P1_SUMMONERNAME
    WHERE longest_streak >= 10
    GROUP BY T1P1_ROLE
)