----------------------------------------------------------------------------------------
  -- SCRIPT:    Environment Creation Script - Functional Roles
  -- 

  -- Desc:  The below scripts are building out the functional roles needed which will be
  --        granted Account Level Access roles for building personas in Snowflake.

  
  -- YY-MM-DD WHO          CHANGE DESCRIPTION
  -------- ------------ -----------------------------------------------------------------
  -- ToDO:
  --
  -- Ask Yvonne the best way to have a "sensitive data" custom role "deadend" at the 
  -- local sysadmin role so that even ACCOUNTADMIN cannot access the database!
  -- This is a capability I want to make sure I understand when we have say, an HR db.
  -- I believe that is easily accomplished in the hierarchy rollup. Just don't connect it 
  -- to SYSADMIN ?
----------------------------------------------------------------------------------------


---------------------------------------------------------------
-- 0. INPUT the components of the names and other parameters
---------------------------------------------------------------

set pltfrAdmin = 'PDE_SYSADMIN_FR';     -- PDE_SYSADMIN_FR is a Platform admin FR currently created by the schema_setup script.
                                        -- Platform admin can create and drop databases across the entire account.
                                        -- Equates to account sysadmin role but prevents everyone from needing SYSADMIN access!!

set dnaSysAdmin = 'DNA_SYSADMIN_FR';    -- DNA_SYSADMIN_FR is currently envisioned to have all LOCAL SYSADMIN roles
                                        -- roll up to it. Think of it as a DBA role. But STILL must have PDE_SYSADMIN_FR
                                        -- in order to drop and create databases.

set cpgSysAdmin = 'CPG_SYSADMIN_FR';    -- DNA_SYSADMIN_FR is currently envisioned to have all LOCAL SYSADMIN roles
                                        -- roll up to it. Think of it as a DBA role. But STILL must have PDE_SYSADMIN_FR
                                        -- in order to drop and create databases.
SET admSysAdmin = 'ADM_SYSADMIN_FR';     -- Admin role that can make changes to all schemas in adm_platform_DB.
                                         -- (Yvonne, I'm going to change adm_platform_DB to ADM_PLATFORM_DB after your session yesterday). 

SET dnaEngC = 'DNA_ENGINEER_FR';        -- Highly priviledged DNA Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.
SET cpgEngC = 'CPG_ENGINEER_FR';        -- Highly priviledged DNA Engineer. Inherits ALL permissions from Read and Read/Write 
                                        -- but can also has access to a ton of other stuff in the schema. Full Engineers can resize Warehouses.
                                        -- The only thing it can't do is drop and create schemas or databases.

SET dnaAnaR = 'DNA_ANALYST_FR';         -- Analysts are read-only, potentially across multiple segments, 
                                        -- but their costs should roll up to the segment they are working in!
SET cpgAnaR = 'CPG_ANALYST_FR';         -- Analysts are read-only, potentially across multiple segments, 
                                        -- but their costs should roll up to the segment they are working in!



---------------------------------------------------------------
-- 1. CREATE FUNCTIONAL ROLES
-- Functional roles are the roles that actually get assigned to users.
-- They contain the bucket of permissions on the database(s) granted to them.
---------------------------------------------------------------
USE ROLE USERADMIN; 
CREATE ROLE IF NOT EXISTS IDENTIFIER($dnaSysAdmin); -- DNA_SYSADMIN_FR
CREATE ROLE IF NOT EXISTS IDENTIFIER($dnaEngC);     -- DNA_ENGINEER_FR
CREATE ROLE IF NOT EXISTS IDENTIFIER($dnaAnaR);     -- DNA_ANALYST_FR
CREATE ROLE IF NOT EXISTS IDENTIFIER($cpgSysAdmin); -- CPG_SYSADMIN_FR
CREATE ROLE IF NOT EXISTS IDENTIFIER($cpgEngC);     -- CPG_ENGINEER_FR
CREATE ROLE IF NOT EXISTS IDENTIFIER($cpgAnaR);     -- CPG_ANALYST_FR
CREATE ROLE IF NOT EXISTS IDENTIFIER($admSysAdmin);     -- ADM_SYSADMIN_FR

---------------------------------------------------------------
-- 2. CREATE OUR FUNCTIONAL ROLE HIERARCHIES
---------------------------------------------------------------
USE ROLE SECURITYADMIN;
-- DNA FUNCTIONAL ROLE HIERARCHY (WILL HAVE NO ACCESS TO CPG OBJECTS):
-- this wasn't here before:
GRANT ROLE IDENTIFIER($pltfrAdmin) TO ROLE SYSADMIN;
GRANT ROLE IDENTIFIER($dnaSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
GRANT ROLE IDENTIFIER($dnaEngC) TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE IDENTIFIER($dnaAnaR) TO ROLE IDENTIFIER($dnaEngC); 
-- CPG FUNCTIONAL ROLE HIERARCHY (WILL HAVE NO ACCESS TO DNA OBJECTS):
GRANT ROLE IDENTIFIER($cpgSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
GRANT ROLE IDENTIFIER($cpgEngC) TO ROLE IDENTIFIER($cpgSysAdmin);
GRANT ROLE IDENTIFIER($cpgAnaR) TO ROLE IDENTIFIER($cpgEngC); 
GRANT ROLE IDENTIFIER($admSysAdmin) TO ROLE IDENTIFIER($pltfrAdmin);
 

---------------------------------------------------------------
-- 3. GRANT OUR VARIOUS LOCAL SYSADMIN ROLES TO HIGHER LEVEL FUNCTIONAL ROLES
---------------------------------------------------------------
GRANT ROLE BP_CUSTOMER_SYSADMIN_FR TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE HR_PEOPLE_SYSADMIN_FR TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE PNC_SALES_SYSADMIN_FR TO ROLE IDENTIFIER($dnaSysAdmin);
GRANT ROLE CPG_ASSETAVAIL_SYSADMIN_FR TO ROLE IDENTIFIER($cpgSysAdmin);
-- CREATE ROLE HEIRARCHY FOR adm_platform_DB
GRANT ROLE adm_platform_SYSADMIN_FR TO ROLE IDENTIFIER($admSysAdmin);
GRANT ROLE BP_CUSTOMER_SYSADMIN_FR TO ROLE IDENTIFIER($admSysAdmin);
GRANT ROLE HR_PEOPLE_SYSADMIN_FR TO ROLE IDENTIFIER($admSysAdmin);
GRANT ROLE PNC_SALES_SYSADMIN_FR TO ROLE IDENTIFIER($admSysAdmin);
GRANT ROLE CPG_ASSETAVAIL_SYSADMIN_FR TO ROLE IDENTIFIER($admSysAdmin);

---------------------------------------------------------------
-- 4. GRANT OUR VARIOUS LOCAL FULL ENGINEERIN ROLES TO HIGHER LEVEL FUNCTIONAL ROLES
---------------------------------------------------------------
GRANT ROLE BP_CUSTOMER_CUST360_FULL_AR TO ROLE IDENTIFIER($dnaEngC);
GRANT ROLE HR_PEOPLE_EMPLOYEE_FULL_AR TO ROLE IDENTIFIER($dnaEngC);
GRANT ROLE PNC_SALES_BRONZE_FULL_AR TO ROLE IDENTIFIER($dnaEngC);
GRANT ROLE PNC_SALES_SILVER_FULL_AR TO ROLE IDENTIFIER($dnaEngC);
GRANT ROLE PNC_SALES_GOLD_FULL_AR TO ROLE IDENTIFIER($dnaEngC);
-- Note> For fun we're not going to give DNA_ENGINEER_FR access to read the CPG database
GRANT ROLE CPG_ASSETAVAIL_DBO_FULL_AR TO ROLE IDENTIFIER($cpgEngC);


---------------------------------------------------------------
-- 5. CREATE GRANTS TO ANALYST FUNCTIONAL ROLES
---------------------------------------------------------------
GRANT ROLE BP_CUSTOMER_CUST360_R_AR TO ROLE IDENTIFIER($dnaAnaR) ;
GRANT ROLE HR_PEOPLE_EMPLOYEE_R_AR TO ROLE IDENTIFIER($dnaAnaR);
GRANT ROLE PNC_SALES_BRONZE_R_AR TO ROLE IDENTIFIER($dnaAnaR);
GRANT ROLE PNC_SALES_SILVER_R_AR TO ROLE IDENTIFIER($dnaAnaR);
GRANT ROLE PNC_SALES_GOLD_R_AR TO ROLE IDENTIFIER($dnaAnaR);
GRANT ROLE CPG_ASSETAVAIL_DBO_R_AR TO ROLE IDENTIFIER($cpgAnaR);

----------------------------------------------------------------------
-- END OF FUNCTIONAL ROLE CREATION. OPTIONAL, CONTINUE TO TESTS BELOW.
----------------------------------------------------------------------

USE ROLE PDE_SYSADMIN_FR;
USE ROLE DNA_SYSADMIN_FR;
USE ROLE CPG_SYSADMIN_FR;
USE ROLE ADM_SYSADMIN_FR;
USE ROLE DNA_ENGINEER_FR;


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
