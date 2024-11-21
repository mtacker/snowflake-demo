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
-- 0. INPUT the components of the names and other parameters
---------------------------------------------------------------
SET beNm = 'HR';           -- Business Entity
-- SET evNm = 'DEV';               -- Environment Name (Dev | Tst | Prd)
SET dbNm = 'PEOPLE';          -- Data Product Name
-- SET znNm = 'RAW';               -- Zone Name (RAW | Integration | Presentation,  Bronze/Silver/Gold, other names such as: EDW | Curated, Enriched)
SET scNm = 'EMPLOYEE';

-- construct the database name and delegated admin role
-- ORIGINAL -------------------------------------------
-- SET prefixNm = $evNm || IFF(($znNm = ''), '', '_' || $znNm) || IFF(($beNm = ''), '', '_' || $beNm);
-- SET dbNm = $prefixNm;                                                --  If Domain defined at account level, append:  || IFF(($dbNm = ''), '', '_' || $dbNm ); 
-- SET databaseNm = $dbNm || '_DB';
-- ORIGINAL -------------------------------------------
SET prefixNm = $beNm;
SET dbNm = $prefixNm || '_' || $dbNm;                                                
SET databaseNm = $dbNm || '_DB';

SET schemaNm = $databaseNm || '.' || $scNm;
SET pltfrAdmin  = 'PLATFORM_SYSADMIN_FR';                                     --- Platform sysadmin,  delegated role granted up to SYSADMIN. Create only once.
--SET localfrAdmin  = $prefixNm || '_SYSADMIN';                        --- Local sysadmin,  delegated role granted up to Platform sysadmin
-- SET localfrAdmin  =  $evNm || IFF(($beNm = ''), '', '_' || $beNm) || '_SYSADMIN_FR';
SET localfrAdmin  =  $dbNm || '_SYSADMIN_FR';

/* ----- Account RBAC Heirarchy -------------------------
    -- Note: the below script includes account-level roles, and may be modified to include database roles.

    ACCOUNTADMIN
        SECURITYADMIN
        SYSADMIN
            PLATFORM_SYSADMIN   (grants, create tasks, notifications, create database, create schema,  access/grants to a GOVERNANCE DB, PLATFORM_DB - contain the account_usage views persisted locally, 
                                    write reporting, governance reporting, platform management, replication management, fail-over DR,  )
                LOCAL_SYSADMIN   (create tags in database only, manage users, manage grants create local tags, apply policies,  DATABASE LEVEL)
                    DEVELOPER_FR
                    ANALYST_FR
                    --- grant the following access roles as per the least-access privs up to the Functional Roles
                    FULL_AR
                        WR_AR
                            R_AR


 */

-- construct the 3 Access Role SCHEMA LEVEL, for Read, Write & Create
-- construct the 2 Functional Roles SCHEMA LEVEL, sample: analyst and developer
SET sarR =  $dbNm || '_' || $scNm || '_R_AR';       -- READ access role
SET sarW =  $dbNm || '_' || $scNm || '_RW_AR';      -- WRITE access role
SET sarFULL =  $dbNm || '_' || $scNm || '_FULL_AR';    -- FULL access role

-- -------------------------------------------------------------
-- WAREHOUSE GRANTS
-- -------------------------------------------------------------
SET whNm  = $databaseNm || '_WH';
SET whComment = 'Warehouse for ' || $databaseNm ;   -- comments for warehouse

-- construct the 2 Access Role names for Usage and Operate
SET warU = $whNm || '_WU_AR';  -- Monitor & Usage
SET warO = $whNm || '_WO_AR';  -- Operate & Modify (so WH can be resized operationally if needed)
-- -------------------------------------------------------------

-- functional roles
SET sfrANALYST =  $dbNm || '_' || $scNm || '_ANALYST_FR';               -- ANALYST Functional Role (FR)
SET sfrDSCIENCE =  $dbNm || '_' || $scNm || '_DATASCIENCE_FR';          -- DATASCIENCE Functional Role (FR)
SET sfrDEVELOPER =  $dbNm || '_' || $scNm || '_DEVELOPER_FR';           -- DEVELOPER Functional Role (FR)

-- Review context
-- Select 
--     $evNm as Environ_name
--     , $beNm as BusinessEntity
--     , $znNm as Zone_name
--     , $databaseNm as Database_name
--     , $scNm as SchemaName
--     , $schemaNm as DB_and_Schema_Name      -- fully qualified
--     , $pltfrAdmin as Platform_Sysadmin_role
--     , $localfrAdmin as local_Sysadmin_role
--     , $sarR as Read_Role
--     , $sarW as Write_Role
--     , $sarFULL as FULL_Role
--     , $sfrANALYST as ANALYST_FR
--     , $sfrDSCIENCE as DATASCIENCE_FR
--     , $sfrDEVELOPER as DEVELOPER_FR
--     ;

---------------------------------------------------------------------------------
-- build_schema.sql is a generic script that creates any schema:
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/build_schema.sql;
---------------------------------------------------------------------------------