/*
120 YEARS OF OLYMPIC HISTORY: ATHLETES AND RESULTS - DATA EXPLORATION

Skills Used: JOINS, CTE, WINDOW FUNCTIONS, AGGREGATE FUNCTIONS, CREATING VIEWS, CONVERTING DATA TYPES, ETC.
Written In: MYSQL WORKBENCH

*/

/*CREATE DATABASE AND TABLES USED FOR QUERIES*/

CREATE DATABASE olympics_info;

DROP TABLE IF EXISTS olympics_history

CREATE TABLE olympics_history (
	id INT(5),
	name VARCHAR(255),
	sex VARCHAR(255),
	age VARCHAR (255),
	height VARCHAR(255),
	weight VARCHAR(255),
	team VARCHAR(255),
	noc VARCHAR(255),
	games VARCHAR(255),
	year VARCHAR(255),
	season VARCHAR(255),
	city VARCHAR(255),
	sport VARCHAR(255),
	event VARCHAR(255),
	medal VARCHAR(255))
	
DROP TABLE IF EXISTS olympics_history_noc_region

CREATE TABLE olympics_history_noc_region(
	noc VARCHAR(5),
	region VARCHAR(255),
	notes VARCHAR(255))
	
/*Query 1: How many olympic games have been held so far?*/
SELECT COUNT(DISTINCT games) AS total_olympic_games FROM olympics_history;

/*Query 2: List down all olympic games held so far (with its year, season, and city)*/
SELECT DISTINCT year, season, city FROM olympics_history
ORDER BY year;

/*Query 3: Get the total no. of countries particpating in each olympic game*/
SELECT games, COUNT(DISTINCT region) AS total_countries FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
	GROUP BY games;

/*Query 4: List the years that saw the highest and lowest no. of countries participating in olympic history*/
WITH games_country AS (
		SELECT games, region FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
		GROUP BY games, region
		ORDER BY games),
     total_countries AS (
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

/*Query 5: List the countries that particpated in ALL olympic games*/
WITH t1 AS (
	SELECT COUNT(DISTINCT games) AS total_games FROM olympics_history),
     t2 AS (
	SELECT oh.games, nr.region FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
            	GROUP BY oh.games, nr.region),
     t3 AS (
	SELECT region, COUNT(1) AS total_participated_games FROM t2
		GROUP BY region)
		
SELECT t3.* FROM t3
	JOIN t1 ON (t1.total_games = t3.total_participated_games)
	ORDER BY 1;

/*Query 6: List all the sports that was played in ALL summer olympic games*/
WITH total_summer_games AS (
		SELECT COUNT(DISTINCT games) AS num_summer_games FROM olympics_history
			WHERE season = 'Summer'),
     summer_olympics AS (
		SELECT DISTINCT games, sport FROM olympics_history
			WHERE season = 'Summer'
            		ORDER BY games),
     total_summer_participation AS (
		SELECT sport, COUNT(1) AS summer_participation FROM summer_olympics
			GROUP BY sport)
			
SELECT tsp.* FROM total_summer_participation tsp
	JOIN total_summer_games tsg ON (tsg.num_summer_games = tsp.summer_participation)
    	ORDER BY sport;
    
/*Query 7: List all the sports played just ONCE in olympics*/
WITH t1 AS (
	SELECT DISTINCT games, sport FROM olympics_history
		GROUP BY games, sport),
     t2 AS (
	SELECT sport, COUNT(sport) AS total_participation FROM t1
		GROUP BY sport
        	ORDER BY sport)
		
SELECT t2.*, t1.games FROM t2
	JOIN t1 ON (t1.sport = t2.sport)
	WHERE t2.total_participation = 1
    	ORDER BY t1.sport;

/*Query 8: Find the total no. of of sports played in each olympic games*/
WITH t1 AS (
	SELECT DISTINCT games, sport FROM olympics_history
		GROUP BY games, sport),
     t2 AS (
	SELECT games, COUNT(sport) AS cnt FROM t1
		GROUP BY games)
		
SELECT * FROM t2
ORDER BY games;

/*Query 9: Fetch the oldest athelete to win a gold medal*/
WITH t1 AS (
	SELECT * FROM olympics_history
		WHERE age != 'NA'
		ORDER BY age DESC),
     t2 AS (
	SELECT * FROM t1
		WHERE medal = 'Gold')
		
SELECT * FROM t2
LIMIT 1;

/*Query 10: Find the ratio of male/female atheletes for all olympic games*/
WITH t1 AS (
	SELECT sex, COUNT(1) AS cnt FROM olympics_history
		GROUP BY sex),
     t2 AS (
	SELECT *, ROW_NUMBER() OVER (ORDER BY cnt) AS row_num FROM t1),
     t3 AS (
	SELECT cnt FROM t2 WHERE row_num = 1),
     t4 AS 
     	SELECT cnt FROM t2 WHERE row_num = 2)
	
SELECT CONCAT('1: ', ROUND(t4.cnt/t3.cnt, 2)) AS ratio FROM t3, t4;

/*Query 11: Get the Top 5 atheletes that have won the most gold medals*/
WITH t1 AS (
	SELECT name, team, COUNT(medal) AS cnt
		FROM olympics_history
		WHERE medal = 'Gold' AND medal != 'NA'
            	GROUP BY name, team
            	ORDER BY cnt DESC)
		
SELECT * FROM t1
LIMIT 5;

/*Query 12: Fetch the Top 5 atheletes who won the most medals*/
WITH t1 AS (
	SELECT name, team, COUNT(medal) AS total_medals FROM olympics_history
		WHERE medal IN ('Gold', 'Silver', 'Bronze') AND medal != 'NA'
            	GROUP BY name, team
            	ORDER BY total_medals DESC),
     t2 AS (
	SELECT *, DENSE_RANK() OVER (ORDER BY total_medals DESC) AS rnk FROM t1)

SELECT * FROM t2
WHERE rnk <= 5;

/*Query 13: Fetch the 5 most successful countries - meaning who has the most medals*/
SELECT nr.region, COUNT(medal) AS total_medals FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
    	WHERE medal != 'NA' AND medal IN ('Gold', 'Silver', 'Bronze')
    	GROUP BY nr.region
    	ORDER BY total_medals DESC
LIMIT 5;

/*Query 14: Get the total gold, silver, bronze for each country*/
SELECT region,
	SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS total_gold,
    	SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS total_silver,
    	SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS total_bronze
    	FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
    	GROUP BY region
    	ORDER BY total_gold DESC;

/*Query 15: Find the total gold, silver, bronze for each olympic game for each country*/
SELECT games, region,
	SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
    	SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
    	SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze
    	FROM olympics_history oh
	JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
    	GROUP BY games, region
    	ORDER BY games;
    
/*Query 16: Which country won the most gold, silver, bronze - list game, country - no. of medals*/
WITH t1 AS (
	SELECT games, region,
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

/*Query 17: Fetch the countries that won the most gold, silver, bronze medals and the most medals in each olympic games*/
WITH t1 AS (
	SELECT games, region,
		SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold,
		SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver,
		SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze,
            	SUM(CASE WHEN medal != 'NA' THEN 1 ELSE 0 END) AS total_medals
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

/*Query 18: List the countries that never won gold but have won silver and bronze*/
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

/*Query 19: List the sport where India has won the most medals*/
WITH t1 AS (
	SELECT DISTINCT sport, region, COUNT(1) AS Total_Medals FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
		WHERE medal != 'NA' AND region = 'India'
        	GROUP BY sport, region)
		
SELECT * FROM t1
LIMIT 1;

/*Query 20: Breakdown all olympic games where India won medal for Hockey and how many medals in each olympic games*/
WITH t1 AS (
	SELECT region, sport, games,
		SUM(CASE WHEN medal != 'NA' THEN 1 ELSE 0 END) AS total_medals
	FROM olympics_history oh
		JOIN olympics_history_noc_region nr ON (nr.noc = oh.noc)
        	GROUP BY region, sport, games
        	ORDER BY games)
		
SELECT * FROM t1
	WHERE region = 'India' AND sport = 'Hockey' AND total_medals != 0
    ORDER BY total_medals DESC;
