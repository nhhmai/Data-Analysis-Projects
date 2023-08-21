CREATE DATABASE student_exams;

CREATE TABLE student_info (
	id INT(10),
	gender VARCHAR(10),
	ethnic_group VARCHAR(10),
    parent_edu VARCHAR(20),
    lunch_type VARCHAR(20),
    test_prep VARCHAR(20),
    parent_marital_status VARCHAR(10),
    practice_sports VARCHAR(20),
    first_child VARCHAR(10),
    siblings INT(2),
    means_of_transport VARCHAR(15),
    weekly_study_hrs VARCHAR(8),
    math_score INT(3),
    reading_score INT(3),
    writing_score INT(3)
    );

## Parent education background - masters, bachelors, hs, unknown ##
## Insight - depending on education, test scores are proportionate (no outliers) ##

#Masters: 72 - M, 76 - R, 76 - W
SELECT ROUND(AVG(math_score)) AS avg_masters_math,
	   ROUND(AVG(reading_score)) AS avg_ms_reading,
       ROUND(AVG(writing_score)) AS avg_ms_writing FROM student_info
			WHERE parent_edu = "master's degree";

#Bachelors: 70 - M, 73 - R, 73 - W            
SELECT ROUND(AVG(math_score)) AS avg_bachelors_math,
	   ROUND(AVG(reading_score)) AS avg_bs_reading,
       ROUND(AVG(writing_score)) AS avg_b_writing FROM student_info
			WHERE parent_edu = "bachelor's degree";
            
#High School: 64 - M, 67 - R, 65 - W
SELECT ROUND(AVG(math_score)) AS avg_hs_math,
	   ROUND(AVG(reading_score)) AS avg_hs_reading,
       ROUND(AVG(writing_score)) AS avg_hs_writing FROM student_info
			WHERE parent_edu = "high school";
            
#Unknown: 67 - M, 69 - R, 68 - W
SELECT ROUND(AVG(math_score)) AS avg_unkwn_math,
	   ROUND(AVG(reading_score)) AS avg_unkwn_reading,
       ROUND(AVG(writing_score)) AS avg_unkwn_writing FROM student_info
			WHERE parent_edu = "unknown";
            
## Marital status - test scores ##
## Married, single, divorced ##
## Insight - Similar averages but kids with divorced parents have higher averages in all subjects ##

#Married: 67 - M, 69 - R, 68 - W
SELECT ROUND(AVG(math_score)) AS avg_married_math,
	   ROUND(AVG(reading_score)) AS avg_married_reading,
       ROUND(AVG(writing_score)) AS avg_married_writing FROM student_info
			WHERE parent_marital_status = "married";

#Single: 66 - M, 69 - R, 68 - W
SELECT ROUND(AVG(math_score)) AS avg_single_math,
	   ROUND(AVG(reading_score)) AS avg_single_reading,
       ROUND(AVG(writing_score)) AS avg_single_writing FROM student_info
			WHERE parent_marital_status = "single";

#Divorced: 67 - M, 70 - R, 69 - W            
SELECT ROUND(AVG(math_score)) AS avg_divorced_math,
	   ROUND(AVG(reading_score)) AS avg_divorced_reading,
       ROUND(AVG(writing_score)) AS avg_divorced_writing FROM student_info
			WHERE parent_marital_status = "divorced";
            
## First child - test scores ##
## Insight - Kids who are not first born score lower than first borns ##

#First child: 67 - M, 70 - R, 69 - W
SELECT ROUND(AVG(math_score)) AS firstchild_math,
	   ROUND(AVG(reading_score)) AS firstchild_reading,
       ROUND(AVG(writing_score)) AS firstchild_writing FROM student_info
			WHERE first_child = 'yes';

#Not first child: 66 - M, 69 - R, 68 - W            
SELECT ROUND(AVG(math_score)) AS not_firstchild_math,
	   ROUND(AVG(reading_score)) AS not_firstchild_reading,
       ROUND(AVG(writing_score)) AS not_firstchild_writing FROM student_info
			WHERE first_child = 'no';

## Means of transportation values: school_bus, private, unknown ##
## Insight - no major outliers, similar test scores in all subjects ##

#Private: 67 - M, 69 - R, 69 - W
SELECT ROUND(AVG(math_score)) AS avg_private_math,
	   ROUND(AVG(reading_score)) AS avg_private_reading,
       ROUND(AVG(writing_score)) AS avg_private_writing FROM student_info
			WHERE means_of_transport = 'private';
            
#School bus : 67 - M, 69 - R, 68 - W            
SELECT ROUND(AVG(math_score)) AS avg_bus_math,
	   ROUND(AVG(reading_score)) AS avg_bus_reading,
       ROUND(AVG(writing_score)) AS avg_bus_writing FROM student_info
			WHERE means_of_transport = 'school_bus';
            
#Unknown: 66 - M, 69 - R, 68 - W            
SELECT ROUND(AVG(math_score)) AS avg_unkwn_math,
	   ROUND(AVG(reading_score)) AS avg_unkwn_reading,
       ROUND(AVG(writing_score)) AS avg_unkwn_writing FROM student_info
			WHERE means_of_transport = 'unknown';
            
## Ethnic Group values - A, B, C, D, E, unknown ##
## Insight - Scores are linear in respective to Group letter - Group E highest scores ##
## Inisght - performed count of ids for each group (large range 2000-7000) ##

#Group A: 63 - M, 67 - R, 65 - W
SELECT ROUND(AVG(math_score)) AS avg_groupa_math,
	   ROUND(AVG(reading_score)) AS avg_groupa_reading,
       ROUND(AVG(writing_score)) AS avg_groupa_writing FROM student_info
			WHERE ethnic_group = 'group A';

#Group B: 63 - M, 67 - R, 66 - W            
SELECT ROUND(AVG(math_score)) AS avg_groupb_math,
	   ROUND(AVG(reading_score)) AS avg_groupb_reading,
       ROUND(AVG(writing_score)) AS avg_groupb_writing FROM student_info
			WHERE ethnic_group = 'group B';  

#Group C: 65 - M, 68 - R, 67 - W            
SELECT ROUND(AVG(math_score)) AS avg_groupc_math,
	   ROUND(AVG(reading_score)) AS avg_groupc_reading,
       ROUND(AVG(writing_score)) AS avg_groupc_writing FROM student_info
			WHERE ethnic_group = 'group C';
            
#Group D: 68 - M, 70 - R, 71 - W            
SELECT ROUND(AVG(math_score)) AS avg_groupd_math,
	   ROUND(AVG(reading_score)) AS avg_groupd_reading,
       ROUND(AVG(writing_score)) AS avg_groupd_writing FROM student_info
			WHERE ethnic_group = 'group D';
            
#Group E: 75 - M, 74 - R, 73 - W           
SELECT ROUND(AVG(math_score)) AS avg_groupe_math,
	   ROUND(AVG(reading_score)) AS avg_groupe_reading,
       ROUND(AVG(writing_score)) AS avg_groupe_writing FROM student_info
			WHERE ethnic_group = 'group E';

#Unknown: 66 - M, 69 - R, 68 - W            
SELECT ROUND(AVG(math_score)) AS avg_unknwn_math,
	   ROUND(AVG(reading_score)) AS avg_unkwn_reading,
       ROUND(AVG(writing_score)) AS avg_unknwn_writing FROM student_info
			WHERE ethnic_group = 'unknown';

## Count of Gender - 15242 F, 15217 M ##
SELECT gender, COUNT(1) AS students FROM student_info
	GROUP BY gender;
    
## Lunch type - standard, free/reduced ##
## Insight: Free/reduced lunch students significant difference in test scores ##

#Standard lunch: 71 - M, 72 - R, 72 - W
SELECT ROUND(AVG(math_score)) AS avg_standardlunch_math,
	   ROUND(AVG(reading_score)) AS avg_standardlunch_reading,
       ROUND(AVG(writing_score)) AS avg_standardlunch_writing FROM student_info
			WHERE lunch_type = 'standard';

#Free/reduced lunch: 59 - M, 64 - R, 63 - W            
SELECT ROUND(AVG(math_score)) AS avg_standardlunch_math,
	   ROUND(AVG(reading_score)) AS avg_standardlunch_reading,
       ROUND(AVG(writing_score)) AS avg_standardlunch_writing FROM student_info
			WHERE lunch_type = 'free/reduced';
            
## Practice sports - regularly, sometimes, never, unknown ##
## Insight - linear test scores, students who do not participate in sports score lowest ##

#Regular sports: 68 - M, 70 - R, 70 - W
SELECT ROUND(AVG(math_score)) AS avg_regsports_math,
	   ROUND(AVG(reading_score)) AS avg_regsports_reading,
       ROUND(AVG(writing_score)) AS avg_regsports_writing FROM student_info
			WHERE practice_sports = 'regularly';
            
#Sometimes sports: 66 - M, 69 - R, 68 - W 		
SELECT ROUND(AVG(math_score)) AS avg_st_sports_math,
	   ROUND(AVG(reading_score)) AS avg_st_sports_reading,
       ROUND(AVG(writing_score)) AS avg_st_sports_writing FROM student_info
			WHERE practice_sports = 'sometimes';
            
#Never sports: 64 - M, 68 - R, 67 - W
SELECT ROUND(AVG(math_score)) AS avg_neversports_math,
	   ROUND(AVG(reading_score)) AS avg_neversports_reading,
       ROUND(AVG(writing_score)) AS avg_neversports_writing FROM student_info
			WHERE practice_sports = 'never';
            
#Unknown sports: 67 - M, 70 - R, 69 - W
SELECT ROUND(AVG(math_score)) AS avg_unkwnsports_math,
	   ROUND(AVG(reading_score)) AS avg_unknwnsports_reading,
       ROUND(AVG(writing_score)) AS avg_unknwnsports_writing FROM student_info
			WHERE practice_sports = 'unknown';

## Weekly study hrs - < 5, 5 - 10, > 10, unknown            

#Less than 5: 65 - M, 68 - R, 67 - W
SELECT ROUND(AVG(math_score)) AS avg_lessfivehrs_math,
	   ROUND(AVG(reading_score)) AS avg_lessfivehrs_reading,
       ROUND(AVG(writing_score)) AS avg_lessfivehrs_writing FROM student_info
			WHERE weekly_study_hrs = '< 5';

#Five to Ten hrs: 67 - M, 70 - R, 69 - W            
SELECT ROUND(AVG(math_score)) AS avg_fivetotenhrs_math,
	   ROUND(AVG(reading_score)) AS avg_fivetotenhrs_reading,
       ROUND(AVG(writing_score)) AS avg_fivetotenhrs_writing FROM student_info
			WHERE weekly_study_hrs = '5 - 10';
            
#More than 10 hrs: 69 - M, 70 - R, 70 - W
SELECT ROUND(AVG(math_score)) AS avg_morethantenhrs_math,
	   ROUND(AVG(reading_score)) AS avg_morethantenhrs_reading,
       ROUND(AVG(writing_score)) AS avg_morethantenhrs_writing FROM student_info
			WHERE weekly_study_hrs = '> 10';
            
#Sibling numbers - similar test scores in the rangfe of 67-69 in all areas
SELECT ROUND(AVG(math_score)) AS avg_morethantenhrs_math,
	   ROUND(AVG(reading_score)) AS avg_morethantenhrs_reading,
       ROUND(AVG(writing_score)) AS avg_morethantenhrs_writing FROM student_info
			WHERE siblings = '0';
