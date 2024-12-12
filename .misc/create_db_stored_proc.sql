-- https://community.snowflake.com/s/article/How-to-allow-users-to-create-shared-databases-without-the-CREATE-DATABASE-account-privilege


use role accountadmin;
drop database if exists db
drop database if exists SHARED_DB_DB;
drop ROLE if exists r_sp;
drop role if exists r_priv;
set user = current_user();

// CONFIGURE A ROLE r_sp THAT SHOULD BE ABLE TO CREATE A DB FROM A SHARE
// THE ROLE r_sp SHOULD NOT HOLD THE CREATE DATABASE ON ACCOUNT 
  create or replace role r_sp;
  grant role r_sp to user identifier($user);

// COFNIGURE A ROLE CALLED r_priv WITH PRIVILEGES TO CREATE DATABASES ON ACCOUNT
// ROLE r_priv SHOULD ALSO HAVE THE IMPORT SHARE PRIVILEGE
  create or replace role r_priv;
  grant create database on account to role r_priv;
  grant import share on account to role r_priv;
  grant role r_priv to user identifier($user);
GRANT MONITOR, USAGE  ON WAREHOUSE compute_wh TO ROLE r_sp;
GRANT MONITOR, USAGE  ON WAREHOUSE compute_wh TO ROLE r_priv;

//USE THE ROLE r_priv TO CREATE THE ENVIRONMENT

  use role r_priv;
  create database if not exists db;
  create schema if not exists db.s1;

// ROLE r_priv CREATES AN SP THAT TAKES MULTIPLE ARGUMENTS: 
// 1. NAME OF THE NEWLY CREATED SHARED DATABASE
// 2. NAME OF THE SHARE FROM WHICH CREATING THE DATABASE
// 3. NAME OF THE ROLE THAT SHOULD HAVE IMPORTED PRIVILEGES ON THAT DATABASE
  create or replace procedure db.s1.createdbfromshare(db_name varchar, role_name varchar)
    returns string
    language javascript
    strict
    execute as owner
    as
    $$
    var create_db = "CREATE OR REPLACE DATABASE " + DB_NAME + "_db";
    
    try {
        snowflake.execute ({sqlText: create_db});
        
    return "Succeeded.";   // Return a success/error indicator.
        }
    catch (err)  {
        return "Failed: " + err;   // Return a success/error indicator.
        }
    $$
    ; 

// ALLOW THE ROLE r_sp TO USE THIS NEW STORED PROCEDURE
grant usage on database db to role r_sp;
grant usage on schema db.s1 to role r_sp;
grant usage on procedure db.s1.createdbfromshare(varchar, varchar) to role r_sp;

// ROLE r_sp CALLS THIS NEW PROCEDURE
// THE SHARE NAME CAN BE FOUND FROM 'SHOW SHARES'
use role r_sp;
call db.s1.createdbfromshare('SHARED_DB','R_SP'); --succeeded
use role accountadmin;

// ROLE r_sp COULD THEN SELECT FROM THE NEW SHARED DB
-- select * from shared_db.public.customer; -- succeeded