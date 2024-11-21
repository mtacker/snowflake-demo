/****************************************************************************************\
 SCRIPT:    Environment Creation Script

  -- Desc:  generic script showing how to manually maintain privileges to access roles
  --        Below script sets context for naming convention
  --        Creates platform administration roles (platform admin, local admin)
  --        Creates database
  --        creates schema
  --        creates roles (access roles)
  --        creates role heirarchy (access roles)
  --        creates 3 functional roles (analyst, datascience, developer as examples)
  --        assigns access roles to functional roles
  --        grants access to roles (read, read/write, full/create)
  --        creates warehouses
  --        creates warehouse access roles
  --        grants roles for warehouse to access roles

  --        CLEAN UP scripts

  -- 
  -- Note:  The below scripts are account-level roles and can be modified to include 
  --        database roles where appropriate

  
  YY-MM-DD WHO          CHANGE DESCRIPTION
  -------- ------------ -----------------------------------------------------------------
  -- 24-08-15           Yvonne Ramage, create script
  -- 24-10-30           Yvonnw Ramage, added functional roles
  -- 24-11-16           Y Ramage, changed name of FULL role (sarFULL), replaced sarC
\****************************************************************************************/

---------------------------------------------------------------
-- 1. USERADMIN: CREATE the account-level maint functional roles
---------------------------------------------------------------
USE ROLE USERADMIN; 

-- Create roles 
CREATE ROLE IF NOT EXISTS IDENTIFIER($pltfrAdmin);
CREATE ROLE IF NOT EXISTS IDENTIFIER($localfrAdmin);
CREATE ROLE IF NOT EXISTS IDENTIFIER($sarR);
CREATE ROLE IF NOT EXISTS IDENTIFIER($sarW);
CREATE ROLE IF NOT EXISTS IDENTIFIER($sarFULL);
--
CREATE ROLE IF NOT EXISTS IDENTIFIER($sfrANALYST);
CREATE ROLE IF NOT EXISTS IDENTIFIER($sfrDSCIENCE);
CREATE ROLE IF NOT EXISTS IDENTIFIER($sfrDEVELOPER);

-- review roles created
show roles;
---------------------------------------------------------------
-- 2. SECURITYADMIN: create roles for hierarchy
---------------------------------------------------------------
USE ROLE SECURITYADMIN;

-- to ensure Central Admin has ability to manage the delegated permissions
-- grant all functional roles up to local and platform admin, platform admin up to SYSADMIN

-- functional role hierarchy
GRANT ROLE IDENTIFIER($pltfrAdmin) TO ROLE SYSADMIN;
GRANT ROLE IDENTIFIER($localfrAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
GRANT ROLE IDENTIFIER($sfrANALYST) TO ROLE IDENTIFIER($localfrAdmin);
GRANT ROLE IDENTIFIER($sfrDSCIENCE) TO ROLE IDENTIFIER($localfrAdmin);
GRANT ROLE IDENTIFIER($sfrDEVELOPER) TO ROLE IDENTIFIER($localfrAdmin);

-- access role hierarchy
GRANT ROLE IDENTIFIER($sarW) TO ROLE IDENTIFIER($sarFULL); 
GRANT ROLE IDENTIFIER($sarR) TO ROLE IDENTIFIER($sarW);  


-- Access roles to functional roles 
GRANT ROLE IDENTIFIER($sarR) TO ROLE IDENTIFIER($sfrANALYST);
GRANT ROLE IDENTIFIER($sarW) TO ROLE IDENTIFIER($sfrDSCIENCE);
GRANT ROLE IDENTIFIER($sarFULL) TO ROLE IDENTIFIER($sfrDEVELOPER);

-------------------------------------------------------------
-- 6. Grant OWNERSHIP OF FUNCTIONAL ROLE to provisioning SCIM role
-------------------------------------------------------------
-- To manage functional role assignment outside of snowflake (3rd party tool: Sailpoint, Azure AD, etc)
-- it may require tranfering the ownership of functional roles to SCIM PROVISIONER role  (SailPoint, Azure AD, etc)
/*
set scimRl = '';    -- name of role used in SCIM provisioning
GRANT OWNERSHIP ON ROLE IDENTIFIER($pltfrAdmin)  TO ROLE IDENTIFIER($scimRl) COPY CURRENT GRANTS;
GRANT OWNERSHIP ON ROLE IDENTIFIER($localfrAdmin)  TO ROLE IDENTIFIER($scimRl) COPY CURRENT GRANTS;
GRANT OWNERSHIP ON ROLE IDENTIFIER($sfrANALYST) TO ROLE IDENTIFIER($scimRl) COPY CURRENT GRANTS;
GRANT OWNERSHIP ON ROLE IDENTIFIER($sfrDSCIENCE) TO ROLE IDENTIFIER($scimRl) COPY CURRENT GRANTS;
GRANT OWNERSHIP ON ROLE IDENTIFIER($sfrDEVELOPER) TO ROLE IDENTIFIER($scimRl) COPY CURRENT GRANTS;
*/

show roles;

-------------------------------------------------------------
-- 3. Create Database and Schema using DELEGATED ADMIN roles
-------------------------------------------------------------
USE ROLE ACCOUNTADMIN;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE IDENTIFIER($pltfrAdmin);

-- create database with platform admin.  Optional:  create with localfrAdmin and transfer ownership to pltfrm sysadmin
--USE ROLE IDENTIFIER($pltfrAdmin);
CREATE DATABASE IF NOT EXISTS IDENTIFIER($databaseNm);
USE DATABASE IDENTIFIER($databaseNm);


--- Grants for delegated admins;
USE ROLE SECURITYADMIN;
-- platform admin (owner of databases)
GRANT OWNERSHIP ON DATABASE IDENTIFIER($databaseNm) TO ROLE IDENTIFIER($pltfrAdmin) REVOKE CURRENT GRANTS;

-- local admin (owner of schemas)
GRANT USAGE ON DATABASE IDENTIFIER($databaseNm)  TO ROLE IDENTIFIER($localfrAdmin)  ;
GRANT USAGE ON ALL SCHEMAS in DATABASE IDENTIFIER($databaseNm)  TO ROLE IDENTIFIER($localfrAdmin)  ;
GRANT CREATE SCHEMA ON DATABASE IDENTIFIER($databaseNm)  TO ROLE IDENTIFIER($localfrAdmin)  ;       --- optional.  
                    -- above "create schema grant" may be replaced by a stored proc, example: sp_CREATE_SCHEMA(dbname, schemaname);

--- create schema using local sysadmin
USE ROLE IDENTIFIER($localfrAdmin);
CREATE SCHEMA IF NOT EXISTS IDENTIFIER($scNm);
USE SCHEMA IDENTIFIER($scNm);


-- local sysadmin is othe owner of the schema and can create tables and insert data.
create or replace table MY_TEST_TABLE (id numeric);


-------------------------------------------------------------
-- 4. ACCESS ROLES:  grants
-------------------------------------------------------------
use role securityadmin;

GRANT USAGE, MONITOR                    ON DATABASE IDENTIFIER($databaseNm)                       TO ROLE IDENTIFIER($sarR);
GRANT USAGE, MONITOR                    ON SCHEMA IDENTIFIER($schemaNm)                               TO ROLE IDENTIFIER($sarR);

GRANT SELECT                            ON ALL TABLES                IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON FUTURE TABLES             IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON ALL VIEWS                 IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON FUTURE VIEWS              IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT USAGE                             ON ALL FUNCTIONS             IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT USAGE                             ON FUTURE FUNCTIONS          IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON ALL EXTERNAL TABLES       IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON FUTURE EXTERNAL TABLES    IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON ALL DYNAMIC TABLES        IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON FUTURE DYNAMIC TABLES     IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON ALL MATERIALIZED VIEWS    IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT SELECT                            ON FUTURE MATERIALIZED VIEWS IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
-- below are grants that may be appropriate, determine if appropriate per organizational requirements
GRANT USAGE, READ                       ON ALL STAGES                IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);
GRANT USAGE, READ                       ON FUTURE STAGES             IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarR);


-- WRITE Access ROLE

GRANT SELECT                            ON ALL STREAMS           IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT SELECT                            ON FUTURE STREAMS        IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT INSERT, UPDATE, DELETE, TRUNCATE  ON ALL TABLES            IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT INSERT, UPDATE, DELETE, TRUNCATE  ON FUTURE TABLES         IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE                             ON ALL PROCEDURES        IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE                             ON FUTURE PROCEDURES     IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE                             ON ALL SEQUENCES         IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE                             ON FUTURE SEQUENCES      IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT MONITOR, OPERATE                  ON ALL TASKS             IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT MONITOR, OPERATE                  ON FUTURE TASKS          IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE                             ON ALL FILE FORMATS      IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE                             ON FUTURE FILE FORMATS   IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE, READ, WRITE                ON ALL STAGES            IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT USAGE, READ, WRITE                ON FUTURE STAGES         IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT MONITOR, OPERATE                  ON ALL DYNAMIC TABLES    IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT MONITOR, OPERATE                  ON FUTURE DYNAMIC TABLES IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT MONITOR, OPERATE                  ON ALL ALERTS            IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
GRANT MONITOR, OPERATE                  ON FUTURE ALERTS         IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);

-- below are grants that may be appropriate, determine if appropriate per organizational requirements
--GRANT MONITOR, OPERATE                  ON ALL PIPES             IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);
--GRANT MONITOR, OPERATE                  ON FUTURE PIPES          IN SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarW);

-- CREATE or FULL Access ROLE

GRANT CREATE TABLE             ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE VIEW              ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE STREAM            ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE FUNCTION          ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE PROCEDURE         ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE SEQUENCE          ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE TASK              ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE FILE FORMAT       ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE STAGE             ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE EXTERNAL TABLE    ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE PIPE              ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE DYNAMIC TABLE     ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE MATERIALIZED VIEW ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE STREAMLIT         ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE ALERT             ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE TAG               ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE MASKING POLICY    ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);
GRANT CREATE ROW ACCESS POLICY ON SCHEMA IDENTIFIER($schemaNm)  TO ROLE IDENTIFIER($sarFULL);



-- review grants
show grants to role IDENTIFIER($sarR);
show grants to role IDENTIFIER($sarW);
show grants to role IDENTIFIER($sarFULL);
show grants to role IDENTIFIER($sfrANALYST);
show grants to role IDENTIFIER($sfrDSCIENCE);
show grants to role IDENTIFIER($sfrDEVELOPER);
show grants to role IDENTIFIER($localfrAdmin);
show grants to role IDENTIFIER($pltfrAdmin);


show grants on role IDENTIFIER($sarR);
show grants on role IDENTIFIER($sarW);
show grants on role IDENTIFIER($sarFULL);
show grants on role IDENTIFIER($sfrANALYST);
show grants on role IDENTIFIER($sfrDSCIENCE);
show grants on role IDENTIFIER($sfrDEVELOPER);
show grants on role IDENTIFIER($localfrAdmin);
show grants on role IDENTIFIER($pltfrAdmin);

-------------------------------------------------------------
-- 5. GRANT schema access roles to DB level access roles, if database roles are utilized
-------------------------------------------------------------
-- simple example below
--GRANT ROLE IDENTIFIER($sarR) TO ROLE << insert role name >>;
--GRANT ROLE IDENTIFIER($sarW) TO ROLE << insert role name >>;
--GRANT ROLE IDENTIFIER($sarFULL) TO ROLE << insert role name >>;





-------------------------------------------------------------
-- 6. Maintain only necessary objects - DROP public if applicable (optional)
-------------------------------------------------------------
--DROP SCHEMA <database name>.PUBLIC; -- assume this schema isn't needed/wanted so remove



-- -------------------------------------------------------------
-- -- 7. WAREHOUSE GRANTS
-- -------------------------------------------------------------
-- SET whNm  = $databaseNm || '_WH';
-- SET whComment = 'Warehouse for ' || $databaseNm ;   -- comments for warehouse

    
-- -- construct the 2 Access Role names for Usage and Operate
-- SET warU = $whNm || '_WU_AR';  -- Monitor & Usage
-- SET warO = $whNm || '_WO_AR';  -- Operate & Modify (so WH can be resized operationally if needed)

-- -- Optional, review context
--     -- select $whNm warehouse_name, $warU Warehouse_role_Usage, $warO Warehouse_role_wu;

---------------------------------------------------------------
-- 3. CREATE Warehouse
---------------------------------------------------------------
USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS IDENTIFIER($whNm) WITH
  WAREHOUSE_SIZE                = XSMALL
  INITIALLY_SUSPENDED           = TRUE 
  AUTO_RESUME                   = TRUE
  AUTO_SUSPEND                  = 60
  STATEMENT_TIMEOUT_IN_SECONDS  = 1800
  COMMENT                       = $whComment;

-- Assume Delegated Admin, so transfer ownership
-- Can grant to either platform sysadmin or local sysadmin. Grant to local domains if require autonomy in maintaining/managing warehouses.
GRANT OWNERSHIP ON WAREHOUSE IDENTIFIER($whNm) TO ROLE IDENTIFIER($pltfrAdmin);

---------------------------------------------------------------
-- 3. USERADMIN CREATE the maint account-level maint roles
---------------------------------------------------------------
USE ROLE USERADMIN;

CREATE ROLE IF NOT EXISTS IDENTIFIER($warU);
CREATE ROLE IF NOT EXISTS IDENTIFIER($warO);
---------------------------------------------------------------
-- 4. SECURITYADMIN grants privileges and wire roles hierarchy
---------------------------------------------------------------
USE ROLE SECURITYADMIN;

GRANT MONITOR, USAGE  ON WAREHOUSE IDENTIFIER($whNm) TO ROLE IDENTIFIER($warU);
GRANT OPERATE, MODIFY ON WAREHOUSE IDENTIFIER($whNm) TO ROLE IDENTIFIER($warO);

--- role heirarchy
GRANT ROLE IDENTIFIER($warU) TO ROLE IDENTIFIER($warO);

-- Assume Delegated Admin, so transfer ownership of these access roles
GRANT OWNERSHIP ON ROLE IDENTIFIER($warU) TO ROLE IDENTIFIER($pltfrAdmin) COPY CURRENT GRANTS;
GRANT OWNERSHIP ON ROLE IDENTIFIER($warO) TO ROLE IDENTIFIER($pltfrAdmin) COPY CURRENT GRANTS;


-- Assign warehouse user to FUNCTIONAL roles
GRANT ROLE IDENTIFIER($warU) TO ROLE IDENTIFIER($sfrANALYST);
GRANT ROLE IDENTIFIER($warU) TO ROLE IDENTIFIER($sfrDSCIENCE);
GRANT ROLE IDENTIFIER($warU) TO ROLE IDENTIFIER($sfrDEVELOPER);

GRANT ROLE IDENTIFIER($warO) TO ROLE IDENTIFIER($localfrAdmin);


-- ---------------------------------------------------------------
-- -- 100. TEST
-- ---------------------------------------------------------------
-- --          Grant all three roles to your user.  Review what is visible.
-- grant role IDENTIFIER($pltfrAdmin) to user <your username>;
-- grant role IDENTIFIER($localfrAdmin) to user <your username>;
-- grant role IDENTIFIER($sfrANALYST) to user <your username>;
-- grant role IDENTIFIER($sfrDSCIENCE) to user <your username>;
-- grant role IDENTIFIER($sfrDEVELOPER) to user <your username>;

-- grant role IDENTIFIER($pltfrAdmin) to user yramage;
-- grant role IDENTIFIER($localfrAdmin) to user yramage;
-- grant role IDENTIFIER($sfrANALYST) to user yramage;
-- grant role IDENTIFIER($sfrDSCIENCE) to user yramage;
-- grant role IDENTIFIER($sfrDEVELOPER) to user yramage;


-- -- use each role and notice what you can see in the database explorer.
-- use role IDENTIFIER($pltfrAdmin);
-- use role IDENTIFIER($localfrAdmin);
-- use role IDENTIFIER($sfrANALYST);
-- use role IDENTIFIER($sfrDSCIENCE);
-- use role IDENTIFIER($sfrDEVELOPER);
-- use role sysadmin;

-- -- use each role and run DDL on table.
-- use role IDENTIFIER($pltfrAdmin);
--     alter table MY_TEST_TABLE add column Addr string;
    
-- use role IDENTIFIER($localfrAdmin);
--     alter table MY_TEST_TABLE rename column Addr to Address;
    
-- use role IDENTIFIER($sfrDEVELOPER);
--     alter table MY_TEST_TABLE rename column Address to Addr_1;       -- should FAIL with: is not owner, doesn't have access to alter table.
--     -- can create table, is the owner NOTE: DO NOT CREATE OBJECTS WITH THIS ROLE.  ONLY CREATE objects WITH FUNCTIONAL ROLES
--     --                                      THAT HAVE THIS ROLE GRANTED TO SAID ROLE!
--     create table cust_city (city string);  
--     alter table cust_city set comment ='Testing if owner can alter their own tables';
--     insert into cust_city values ('chicago');     -- works, as full role inherits R-> W -> FULL
    
-- use role IDENTIFIER($localfrAdmin);
--     alter table cust_city add column state string;  -- works
--     select * from cust_city;
--     describe table cust_city;
--     select get_ddl('table', 'cust_city');
--     update cust_city set state = 'IL' where city ='chicago';

-- use role IDENTIFIER($sfrDSCIENCE);
--      insert into cust_city values ('Dallas', 'TX'); 
--      update cust_city set city = 'Springfield' where state = 'IL';
--      select * from cust_city;
     
-- use role IDENTIFIER($sfrANALYST);
--      select * from cust_city;
--      update cust_city set state = 'IL' where city ='Springfield';       -- fails, insufficient privileges

-- -- IN REVIEW:  review all that was created
-- use role IDENTIFIER($pltfrAdmin);
-- show databases;                 -- review the OWNER of database as platform sysadmin (delegated admin for full platform, all databases)
-- show schemas;                   -- review the OWNER of schema as local sysadmin (delegated admin for database only)
-- show roles;                     -- review the roles created (functional roles and access roles)


-- --- clean up script 
-- /*
-- use role securityadmin;
-- DROP ROLE if exists IDENTIFIER($localfrAdmin);
-- DROP ROLE if exists IDENTIFIER($pltfrAdmin);
-- DROP ROLE if exists IDENTIFIER($sfrANALYST);
-- DROP ROLE if exists IDENTIFIER($sfrDSCIENCE);
-- DROP ROLE if exists IDENTIFIER($sfrDEVELOPER);
-- DROP ROLE if exists IDENTIFIER($sarR);
-- DROP ROLE if exists IDENTIFIER($sarW);
-- DROP ROLE if exists IDENTIFIER($sarFULL);
-- DROP ROLE if exists IDENTIFIER($warO);
-- DROP ROLE if exists IDENTIFIER($warU);
-- --
-- use role accountadmin;
-- drop database IDENTIFIER($databaseNm);
-- drop warehouse IDENTIFIER($whNm);
-- */

