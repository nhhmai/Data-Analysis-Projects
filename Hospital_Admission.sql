CREATE DATABASE hospital_admission;

DROP TABLE IF EXISTS admission_data;

CREATE TABLE admission_data (
    sno INT(6) PRIMARY KEY,
    mrd_no INT(6),
    doa VARCHAR(10),
    dod VARCHAR(10),
    age INT(3),
    gender VARCHAR(10),
    rural_urban VARCHAR(10),
    type_of_admission VARCHAR(10),
    month_year VARCHAR(10),
    stay_duration INT(5),
    outcome VARCHAR(10),
    smoking VARCHAR(10),
    alcohol VARCHAR(10),
    diabetes_mellitus VARCHAR(10),
    hypertension VARCHAR(10),
    coronary_artery_disease VARCHAR(10),
    prior_cardiomyopathy VARCHAR(10),
    chronic_kidney_disease VARCHAR(10),
    hemoglobin VARCHAR(10),
    leukocytes_count VARCHAR(10),
    platelets_count VARCHAR(10),
    glucose_count VARCHAR(10));
    
DROP TABLE IF EXISTS morality_data;

CREATE TABLE morality_data (
    sno INT(6) PRIMARY KEY,
    mrd VARCHAR(10),
    age INT(3),
    gender VARCHAR(10),
    rural_urban VARCHAR(10),
    date_of_death VARCHAR(10));
    
DROP TABLE IF EXISTS pollution_data;
    
CREATE TABLE pollution_data (
    pollution_date VARCHAR(10),
    aqi INT(4),
    pm_twoptfive_avg INT(4),
    pm_ten_avg INT(4),
    prominent_pollution VARCHAR(10));

    
