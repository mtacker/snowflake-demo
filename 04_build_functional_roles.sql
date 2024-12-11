----------------------------------------------------------------------------------------
  -- SCRIPT:    Environment Creation Script - Functional Roles
  -- 

  -- Desc:  The below scripts are building out the functional roles needed which will be
  --        granted Account Level Access roles for building personas in Snowflake.

  
  -- YY-MM-DD WHO          CHANGE DESCRIPTION
  -------- ------------ -----------------------------------------------------------------
  -- ToDO:
  -- Add default functional roles to build script and remove from here.
----------------------------------------------------------------------------------------


---------------------------------------------------------------
-- Set up parameters
---------------------------------------------------------------

set pltfrAdmin = 'PDE_SYSADMIN_FR';     -- PDE_SYSADMIN_FR is a Platform admin FR currently created by the schema_setup script.
                                        -- Platform admin can create and drop databases across the entire account.
                                        -- Equates to account sysadmin role but prevents everyone from needing SYSADMIN access!!

SET admSysAdmin = 'ADM_SYSADMIN_FR';     -- Admin role that can make changes to all schemas in ADM_PLATFORM_DB.

set dnaSysAdmin = 'DNA_SYSADMIN_FR';    -- DNA_SYSADMIN_FR is currently envisioned to have some or all LOCAL SYSADMIN roles
                                        -- roll up to it. Think of it as a DBA role. But STILL must have PDE_SYSADMIN_FR
                                        -- in order to drop and create databases.

set bpSysAdmin = 'BP_SYSADMIN_FR';      -- For testing, BP_SYSADMIN_FR WILL roll up to DNA_SYSADMIN_FR.

set cpgSysAdmin = 'CPG_SYSADMIN_FR';    -- For testing, CPG_SYSADMIN_FR WILL roll up to DNA_SYSADMIN_FR.

set pncSysAdmin = 'PNC_SYSADMIN_FR';    -- For testing, PNC_SYSADMIN_FR will NOT roll up to DNA_SYSADMIN_FR.

set hrSysAdmin = 'HR_SYSADMIN_FR';      -- For testing, HR_SYSADMIN_FR will not roll up to DNA_SYSADMIN_FR, and I'm going to try having
                                        -- it not roll up to PDE_SYSADMIN_FR! This should create a "dead-end" such that even ACCOUNTADMIN
                                        -- people won't have access to sensitive HR data.
                                        -- Does not roll up to PDE_SYSADMIN_FR.

SET dnaEngC = 'DNA_ENGINEER_FR';        -- Highly priviledged DNA Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.

SET bpEngC = 'BP_ENGINEER_FR';          -- Highly priviledged BP Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.
                                        -- BP_ENGINEER_FR will roll up DNA_ENGINEER_FR.  DNA_ENGINEER_FR will be assigned to users so they have 
                                        -- access to BP database.

SET cpgEngC = 'CPG_ENGINEER_FR';        -- Highly priviledged CPG Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.
                                        -- CPG_ENGINEER_FR will roll up DNA_ENGINEER_FR.  DNA_ENGINEER_FR will be assigned to users so they have 
                                        -- access to CPG database.

SET pncEngC = 'PNC_ENGINEER_FR';        -- Highly priviledged PNC Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.
                                        -- Does not roll up to DNA_ENGINEER_FR.
                                        -- BRONZE, SILVER, GOLD schemas roll up to PNC_ENGINEER_FR.

SET hrEngC = 'HR_ENGINEER_FR';          -- Highly priviledged PNC Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.
                                        -- Does not roll up to DNA_ENGINEER_FR.

SET dnaAnaR = 'DNA_ANALYST_FR';         -- Analysts are read-only, potentially across multiple segments, 
                                        -- but their costs should roll up to the segment they are working in!


SET hrAnaR = 'HR_ANALYST_FR';          -- Analysts are read-only, potentially across multiple segments, 
                                       -- but their costs should roll up to the segment they are working in!


---------------------------------------------------------------
-- CREATE FUNCTIONAL ROLES
-- Functional roles are the roles that actually get assigned to users.
-- They will contain the bucket of permissions on the database(s) granted to them.
---------------------------------------------------------------
USE ROLE USERADMIN; 
CREATE ROLE IF NOT EXISTS IDENTIFIER($pltfrAdmin);  -- PDE_SYSADMIN_FR - Create/Drop Databases
CREATE ROLE IF NOT EXISTS IDENTIFIER($admSysAdmin); -- ADM_SYSADMIN_FR - Create/Drop Schemas
CREATE ROLE IF NOT EXISTS IDENTIFIER($dnaSysAdmin); -- DNA_SYSADMIN_FR - Create/Drop Schemas for BP & CPG
CREATE ROLE IF NOT EXISTS IDENTIFIER($dnaEngC);     -- DNA_ENGINEER_FR - FULL (except DB/Schema) for BP & CPG
CREATE ROLE IF NOT EXISTS IDENTIFIER($bpSysAdmin);  -- BP_SYSADMIN_FR - Create/Drop Schemas 
CREATE ROLE IF NOT EXISTS IDENTIFIER($bpEngC);      -- BP_ENGINEER_FR - FULL (except DB/Schema) 
CREATE ROLE IF NOT EXISTS IDENTIFIER($cpgSysAdmin); -- CPG_SYSADMIN_FR - Create/Drop Schemas 
CREATE ROLE IF NOT EXISTS IDENTIFIER($cpgEngC);     -- CPG_ENGINEER_FR - FULL (except DB/Schema) 
CREATE ROLE IF NOT EXISTS IDENTIFIER($pncSysAdmin); -- PNC_SYSADMIN_FR - Create/Drop Schemas 
CREATE ROLE IF NOT EXISTS IDENTIFIER($pncEngC);     -- PNC_ENGINEER_FR - FULL (except DB/Schema) 
CREATE ROLE IF NOT EXISTS IDENTIFIER($hrSysAdmin);  -- HR_SYSADMIN_FR - Create/Drop Schemas 
CREATE ROLE IF NOT EXISTS IDENTIFIER($hrEngC);      -- HR_ENGINEER_FR - FULL (except DB/Schema) 
CREATE ROLE IF NOT EXISTS IDENTIFIER($dnaAnaR);     -- DNA_ANALYST_FR - Read-only for BP & CPG
CREATE ROLE IF NOT EXISTS IDENTIFIER($hrAnaR);      -- HR_ANALYST_FR - Read-only


---------------------------------------------------------------
-- CREATE OUR DNA FUNCTIONAL ROLE HIERARCHY
-- DNA WILL HAVE NO ACCESS TO PNC OR HR DATABASES
USE ROLE SECURITYADMIN;
GRANT ROLE IDENTIFIER($pltfrAdmin) TO ROLE SYSADMIN;
GRANT ROLE IDENTIFIER($dnaSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
GRANT ROLE IDENTIFIER($dnaEngC) TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE IDENTIFIER($dnaAnaR) TO ROLE IDENTIFIER($dnaEngC); 
GRANT ROLE IDENTIFIER($bpSysAdmin) TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE IDENTIFIER($bpEngC) TO ROLE IDENTIFIER($bpSysAdmin); 
GRANT ROLE IDENTIFIER($cpgSysAdmin) TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE IDENTIFIER($cpgEngC) TO ROLE IDENTIFIER($cpgSysAdmin); 
GRANT ROLE IDENTIFIER($admSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);

---------------------------------------------------------------
-- CREATE OUR PNC & HR FUNCTIONAL ROLE HIERARCHY
-- PNC & HR FUNCTIONAL ROLE HIERARCHY WILL HAVE NO ACCESS TO DNA DATABASES:
GRANT ROLE IDENTIFIER($pncSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
GRANT ROLE IDENTIFIER($pncEngC) TO ROLE IDENTIFIER($pncSysAdmin);
GRANT ROLE IDENTIFIER($hrSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
GRANT ROLE IDENTIFIER($hrEngC) TO ROLE IDENTIFIER($hrSysAdmin);
GRANT ROLE IDENTIFIER($hrAnaR) TO ROLE IDENTIFIER($hrEngC); 
 

---------------------------------------------------------------
-- GRANT OUR VARIOUS LOCAL FULL ENGINEERING ROLES TO FUNCTIONAL ROLES
---------------------------------------------------------------
GRANT ROLE BP_CUSTOMER_CUST360_FULL_AR TO ROLE IDENTIFIER($bpEngC);
GRANT ROLE CPG_ASSETAVAIL_DBO_FULL_AR TO ROLE IDENTIFIER($cpgEngC);
GRANT ROLE HR_PEOPLE_EMPLOYEE_FULL_AR TO ROLE IDENTIFIER($hrEngC);
GRANT ROLE PNC_SALES_BRONZE_FULL_AR TO ROLE IDENTIFIER($pncEngC);
GRANT ROLE PNC_SALES_SILVER_FULL_AR TO ROLE IDENTIFIER($pncEngC);
GRANT ROLE PNC_SALES_GOLD_FULL_AR TO ROLE IDENTIFIER($pncEngC);
GRANT ROLE ADM_PLATFORM_DEPLOY_FULL_AR TO ROLE IDENTIFIER($admSysAdmin);
GRANT ROLE ADM_PLATFORM_ALERTS_FULL_AR TO ROLE IDENTIFIER($admSysAdmin);
GRANT ROLE ADM_PLATFORM_TAGS_FULL_AR TO ROLE IDENTIFIER($admSysAdmin);
 

---------------------------------------------------------------
-- CREATE GRANTS TO ANALYST FUNCTIONAL ROLES
---------------------------------------------------------------
GRANT ROLE BP_CUSTOMER_CUST360_R_AR TO ROLE IDENTIFIER($dnaAnaR) ;
GRANT ROLE CPG_ASSETAVAIL_DBO_R_AR TO ROLE IDENTIFIER($dnaAnaR);
GRANT ROLE HR_PEOPLE_EMPLOYEE_R_AR TO ROLE IDENTIFIER($hrAnaR);

----------------------------------------------------------------------
-- END OF FUNCTIONAL ROLE CREATION. OPTIONAL, CONTINUE TO TESTS BELOW.
----------------------------------------------------------------------

USE ROLE PDE_SYSADMIN_FR;
USE ROLE ADM_SYSADMIN_FR; 
DROP DATABASE BP_CUSTOMER_DB;
USE ROLE DNA_SYSADMIN_FR;
USE ROLE DNA_ENGINEER_FR;
USE DATABASE BP_CUSTOMER_DB;
DROP SCHEMA CUST360;

USE ROLE CPG_SYSADMIN_FR; 
USE ROLE CPG_ENGINEER_FR;
USE ROLE BP_SYSADMIN_FR; 
USE ROLE BP_CUSTOMER_SYSADMIN_FR;
USE DATABASE BP_CUSTOMER_DB;
DROP SCHEMA CUST360;
USE ROLE BP_ENGINEER_FR;
USE DATABASE BP_CUSTOMER_DB;
DROP SCHEMA CUST360;
USE ROLE PNC_SYSADMIN_FR;
USE ROLE PNC_ENGINEER_FR;
USE ROLE DNA_ANALYST_FR;
USE ROLE HR_SYSADMIN_FR; 
USE ROLE HR_ENGINEER_FR; 
USE ROLE HR_ANALYST_FR; 

SHOW GRANTS TO ROLE PDE_SYSADMIN_FR;
SHOW GRANTS ON ROLE PDE_SYSADMIN_FR;
SHOW GRANTS TO ROLE ADM_SYSADMIN_FR; 
SHOW GRANTS ON ROLE ADM_SYSADMIN_FR; 
SHOW GRANTS TO ROLE DNA_SYSADMIN_FR;
SHOW GRANTS ON ROLE DNA_SYSADMIN_FR;
SHOW GRANTS TO ROLE DNA_ENGINEER_FR;
SHOW GRANTS ON ROLE DNA_ENGINEER_FR;
SHOW GRANTS TO ROLE CPG_SYSADMIN_FR; 
SHOW GRANTS ON ROLE CPG_SYSADMIN_FR; 
SHOW GRANTS TO ROLE CPG_ENGINEER_FR;
SHOW GRANTS ON ROLE CPG_ENGINEER_FR;
SHOW GRANTS TO ROLE BP_SYSADMIN_FR; 
SHOW GRANTS ON ROLE BP_SYSADMIN_FR; 
SHOW GRANTS TO ROLE BP_ENGINEER_FR;
SHOW GRANTS ON ROLE BP_ENGINEER_FR;
SHOW GRANTS TO ROLE PNC_SYSADMIN_FR;
SHOW GRANTS ON ROLE PNC_SYSADMIN_FR;
SHOW GRANTS TO ROLE PNC_ENGINEER_FR;
SHOW GRANTS ON ROLE PNC_ENGINEER_FR;
SHOW GRANTS TO ROLE DNA_ANALYST_FR;
SHOW GRANTS ON ROLE DNA_ANALYST_FR;
SHOW GRANTS TO ROLE HR_SYSADMIN_FR; 
SHOW GRANTS ON ROLE HR_SYSADMIN_FR; 
SHOW GRANTS TO ROLE HR_ENGINEER_FR; 
SHOW GRANTS ON ROLE HR_ENGINEER_FR; 
SHOW GRANTS TO ROLE HR_ANALYST_FR; 
SHOW GRANTS ON ROLE HR_ANALYST_FR; 


-- From this website. I just think this is worth reviewing as possible additional Functional Roles!
-- https://handbook.gitlab.com/handbook/enterprise-data/platform/#warehouse-access
-- Functional Role Assignment
-- This list of functional roles gives a high level understanding of what the role entails. If missing or to know in all detail what a role entails check this YAML file.

-- Functional Role	Description	SAFE Data Y/N
-- data_team_analyst	Access to all PROD data, sensitive marketing data, Data Platform metadata and some sources.	Yes
-- analyst_core	Access to all PROD data and meta data in the Data Platform	No
-- analyst_engineering	Access to all PROD data, meta data in the Data Platform and Engineering related data sources.	Yes
-- analyst_growth	Access to all PROD data, meta data in the Data Platform and various data sources.	Yes
-- analyst_finance	Access to all PROD data, meta data in the Data Platform and finance related data sources.	Yes
-- analyst_marketing	Access to all PROD data, meta data in the Data Platform and marketing related data sources.	Yes
-- analyst_people	Access to all PROD data, meta data in the Data Platform and various related data sources, including sensitive people data.	Yes
-- analyst_sales	Access to all PROD data, meta data in the Data Platform and various related data sources	Yes
-- analyst_support	Access to PROD data, meta data in the Data Platform and raw / prep Zendesk data, including sensitive Zendesk data	No
-- analytics_engineer_core	A combination of analyst_core, data_team_analyst role with some additions	Yes
-- data_manager	Extension access to Snowflake data	Yes
-- engineer	Extension access to Snowflake data to perform data operation tasks in Snowflake	Yes
-- snowflake_analyst	Access to PROD data in Snowflake, EDM schema and workspaces	No
-- snowflake_analyst_safe	Access to PROD data in Snowflake, EDM schema and workspaces including SAFE data	Yes