#how many olympic games have been held#
SELECT COUNT(DISTINCT games) AS total_olympic_games FROM olympics_history;

#list down all olympic games held so far#
SELECT DISTINCT year, season, city FROM olympics_history
ORDER BY year;

#total no of countries particpating in each olympic game#
SELECT games, COUNT(DISTINCT region) AS total_countries FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
	GROUP BY games;

#year that saw the highest and lowest no of countries participating in olympics#
WITH games_country AS ( #getting all the games and all the countries particpating
		SELECT games, region FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
		GROUP BY games, region
		ORDER BY games),
	total_countries AS ( #getting the previous table info + total of countries for DISTINCT game
		SELECT games, region, COUNT(region) OVER (PARTITION BY games) AS total_co FROM games_country
		GROUP BY games, region)
        
SELECT DISTINCT
	CONCAT(FIRST_VALUE(games) OVER (ORDER BY total_co),
    ' - ',
    FIRST_VALUE(total_co) OVER (ORDER BY total_co)) AS lowest_country,
    CONCAT(FIRST_VALUE(games) OVER (ORDER BY total_co DESC),
    ' - ',
    FIRST_VALUE(total_co) OVER (ORDER BY total_co DESC)) AS highest_country
FROM total_countries;

#countries that particpated in ALL olympic games#
WITH t1 AS #no. of total olympic games DISTINCT
		(SELECT COUNT(DISTINCT games) AS total_games FROM olympics_history),
	 t2 AS #table of games, DISTINCT country for all olympic games
		(SELECT oh.games, nr.region FROM olympics_history oh
			JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
            GROUP BY oh.games, nr.region),
	 t3 AS #total count of each country's particpation
		(SELECT region, COUNT(1) AS total_participated_games FROM t2
			GROUP BY region)
SELECT t3.* FROM t3
	JOIN t1 ON (t1.total_games = t3.total_participated_games)
    ORDER BY 1;

#sport that was played in ALL summer olympic games#
WITH total_summer_games AS #no. of total summer olympic games - 29
		(SELECT COUNT(DISTINCT games) AS num_summer_games FROM olympics_history
			WHERE season = 'Summer'),
	summer_olympics AS #table of all summer games, sport DISTINCT
		(SELECT DISTINCT games, sport FROM olympics_history
			WHERE season = 'Summer'
            ORDER BY games),
	total_summer_participation AS #no. of total participation for each sport
		(SELECT sport, COUNT(1) AS summer_participation FROM summer_olympics
			GROUP BY sport)
SELECT tsp.* FROM total_summer_participation tsp
	JOIN total_summer_games tsg ON (tsg.num_summer_games = tsp.summer_participation)
    ORDER BY sport;
    
#sports played just ONCE in olympics#
WITH t1 AS #table of all the games, and DISTINCT sports
	(SELECT DISTINCT games, sport FROM olympics_history
		GROUP BY games, sport),
	 t2 AS #each sport and the number of how many times the sport is being played
	(SELECT sport, COUNT(sport) AS total_participation FROM t1
		GROUP BY sport
        ORDER BY sport)
SELECT t2.*, t1.games FROM t2
	JOIN t1 ON (t1.sport = t2.sport)
	WHERE t2.total_participation = 1
    ORDER BY t1.sport;

#total no. of of sports played in each olympic games#
WITH t1 AS #list of all games, sport in list DISTINCT
	(SELECT DISTINCT games, sport FROM olympics_history
		GROUP BY games, sport),
	 t2 AS #taking previous list and counting each sport listed
     (SELECT games, COUNT(sport) AS cnt FROM t1
		GROUP BY games)
SELECT * FROM t2
ORDER BY games;

#fetch oldest athelete to win gold medal#
WITH t1 AS #list returning all info with oldest at front
		(SELECT * FROM olympics_history
			WHERE age != 'NA'
			ORDER BY age DESC),
	 t2 AS #list returning all the atheletes info who won gold
		(SELECT * FROM t1
			WHERE medal = 'Gold')
SELECT * FROM t2
LIMIT 1;

#find ratio of male/female atheletes for all olympic games#
WITH t1 AS #getting the total cnt for how many males/females
		(SELECT sex, COUNT(1) AS cnt FROM olympics_history
			GROUP BY sex),
	 t2 AS #giving each row a number - EITHER 1 OR 2
		(SELECT *, ROW_NUMBER() OVER (ORDER BY cnt) AS row_num FROM t1),
	 t3 AS #getting the count for F
		(SELECT cnt FROM t2 WHERE row_num = 1),
	 t4 AS #getting the count for M
		(SELECT cnt FROM t2 WHERE row_num = 2)
SELECT CONCAT('1: ', ROUND(t4.cnt/t3.cnt, 2)) AS ratio FROM t3, t4;

#top 5 atheletes that have won the most gold medals#
WITH t1 AS
		(SELECT name, team, COUNT(medal) AS cnt
			FROM olympics_history
			WHERE medal = 'Gold' AND medal != 'NA'
            GROUP BY name, team
            ORDER BY cnt DESC)
SELECT * FROM t1
LIMIT 5;

#fetch top 5 atheletes who won the most medals#
WITH t1 AS #list of atheletes' info ordered by most medals
		(SELECT name, team, COUNT(medal) AS total_medals FROM olympics_history
			WHERE medal IN ('Gold', 'Silver', 'Bronze') AND medal != 'NA'
            GROUP BY name, team
            ORDER BY total_medals DESC),
	 t2 AS #ranking each athelete from most medals
		(SELECT *, DENSE_RANK() OVER (ORDER BY total_medals DESC) AS rnk FROM t1)
SELECT * FROM t2
WHERE rnk <= 5;

#fetch 5 most successful countries - meaning who has the most medals#
SELECT nr.region, COUNT(medal) AS total_medals FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
    WHERE medal != 'NA' AND medal IN ('Gold', 'Silver', 'Bronze')
    GROUP BY nr.region
    ORDER BY total_medals DESC
LIMIT 5;

#total gold, silver, bronze for each country#
SELECT region,
	SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS total_gold,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS total_silver,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS total_bronze
    FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
    GROUP BY region
    ORDER BY total_gold DESC;

#total gold, silver, bronze for each olympic game for each country#
SELECT games, region,
	SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
    FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
    GROUP BY games, region
    ORDER BY games;
    
#which country won the most gold, silver, bronze - list game, country - no. of medals#
WITH t1 AS #getting the count of all countries' gold, silver, bronze medals
		(SELECT games, region,
			SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
			SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
			SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
		FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
		GROUP BY games, region
		ORDER BY games)
SELECT games,
	CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY gold DESC),
    ' - ',
    FIRST_VALUE(gold) OVER (PARTITION BY games ORDER BY gold DESC)) AS max_gold,
    CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY silver DESC),
    ' - ',
    FIRST_VALUE(silver) OVER (PARTITION BY games ORDER BY silver DESC)) AS max_silver,
    CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY bronze DESC),
	' - ',
    FIRST_VALUE(bronze) OVER (PARTITION BY games ORDER BY bronze DESC)) AS max_bronze
FROM t1;

#fetch the countries that won the most gold, silver, bronze medals and the most medals in each olympic games#
WITH t1 AS #getting the count of all countries' gold, silver, bronze medals - same as previous query
		(SELECT games, region,
			SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
			SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
			SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze,
            SUM(CASE WHEN medal != 'NA' THEN 1 ELSE 0 END) AS total_medals #added the total_medals
		FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
		GROUP BY games, region
		ORDER BY games)
SELECT games,
	CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY gold DESC),
    ' - ',
    FIRST_VALUE(gold) OVER (PARTITION BY games ORDER BY gold DESC)) AS max_gold,
    CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY silver DESC),
    ' - ',
    FIRST_VALUE(silver) OVER (PARTITION BY games ORDER BY silver DESC)) AS max_silver,
    CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY bronze DESC),
	' - ',
    FIRST_VALUE(bronze) OVER (PARTITION BY games ORDER BY bronze DESC)) AS max_bronze,
    CONCAT(FIRST_VALUE(region) OVER (PARTITION BY games ORDER BY total_medals DESC),
    ' - ',
    FIRST_VALUE(total_medals) OVER (PARTITION BY games ORDER by total_medals DESC)) AS max_medal
FROM t1;

#countries that never won gold but have won silver and bronze#
WITH t1 AS (
		SELECT DISTINCT region, 
			SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
			SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
			SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze
			FROM olympics_history oh
			JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
			GROUP BY region
			ORDER BY region),
	t2 AS (
		SELECT * FROM t1
			WHERE Gold = 0 AND (Silver >= 1 OR Bronze >= 1))
SELECT * FROM t2;

#sport where India has won the most medals#
WITH t1 AS
	(SELECT DISTINCT sport, region, COUNT(1) AS Total_Medals FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
		WHERE medal != 'NA' AND region = 'India'
        GROUP BY sport, region)
SELECT * FROM t1
LIMIT 1;

#breakdown all olympic games where India won medal for Hockey and how many medals in each olympic games#
WITH t1 AS
	(SELECT region, sport, games,
		SUM(CASE WHEN medal != 'NA' THEN 1 ELSE 0 END) AS total_medals
		FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
        GROUP BY region, sport, games
        ORDER BY games)
SELECT * FROM t1
	WHERE region = 'India' AND sport = 'Hockey' AND total_medals != 0
    ORDER BY total_medals DESC;