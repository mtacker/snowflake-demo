---------------------------------------------------------------------------------------------
--  SCRIPT:    Initial Environment Creation Script

--   -- Desc:
--   --        This script is run manually to create the following objects:
--   --
--   --        Admin platform database 
--   --        .DEPLOY schema is where the following objects will be created:
--   --        GITHUB_SECRET, GITHUB_API_INTEGRATION & SNOWFLAKE_GIT_REPO
--   --        This script also initializes roles and role hierarchies to support
--   --        our basic RBAC & Security model.
--   --        Also creates _WH, the warehouse dedicated to .
--   --        
--   -- Execution Options:
--   --         snow sql -f "./apps/01_manual_account_setup.sql"; 
--   --         snow sql -f "./apps/02_git_integration.sql";
--   --         Above requires Snowflake CLI to be installed locally first. See:
--   --         04_snowflake_cli_setup.md on how to do that.
--   --
--   -- Or you can simply:
--   --         Copy/Paste THIS ENTIRE script into a Worksheet in a Snowflake Trial Account 
--   --         and run manually! No other setups required.
--   -- 
--   --         NOTE> This script is intended to be idempotent with the use 
--   --         of 'CREATE [object] IF NOT EXISTS' statments.
--   -- 
--   YY-MM-DD WHO          CHANGE DESCRIPTION
--   -------- ------------ -----------------------------------------------------------------

---------------------------------------------------------------------------------------------
SET beNm = 'pnc';        -- Business Entity / Segment
SET dbNm = 'sales';    -- Database Name
SET scNm = 'silver';     -- Schema Name

-- construct the database name and delegated admin role
SET prefixNm = $beNm;
SET dbNm = $prefixNm || '_' || $dbNm;                                                
SET databaseNm = $dbNm || '_DB';
SET schemaNm = $databaseNm || '.' || $scNm;
SET publicSchemaNm = $databaseNm || '.' || 'public';
SET pltfrAdmin  = 'PDE_SYSADMIN_FR';  --- Platform sysadmin,  delegated role granted up to SYSADMIN. Create only once.

SET localfrAdmin  =  $dbNm || '_SYSADMIN_FR';

-- construct the 3 Access Role SCHEMA LEVEL, for Read, Write & Create
SET sarR =  $dbNm || '_' || $scNm || '_R_AR';  -- READ access role
SET sarW =  $dbNm || '_' || $scNm || '_RW_AR';  -- WRITE access role
SET sarC =  $dbNm || '_' || $scNm || '_FULL_AR';  -- CREATE or FULL access role

SET whNm  = $databaseNm || '_WH';
SET whComment = 'Warehouse for ' || $databaseNm ;   -- comments for warehouse

    
-- construct the 2 Access Role names for Usage and Operate
SET warU = $whNm || '_WU_AR';  -- Monitor & Usage
SET warO = $whNm || '_WO_AR';  -- Operate & Modify (so WH can be resized operationally if needed)



---------------------------------------------------------------------------------
-- build_schema.sql is a generic script to create any schema:
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/build_schema.sql;
---------------------------------------------------------------------------------

---------------------------------------------------------------
-- END SCHEMA CREATION. OPTIONAL, CONTINUE TO TESTS BELOW.
---------------------------------------------------------------



---------------------------------------------------------------
-- 100. TEST
---------------------------------------------------------------
-- Grant all three roles to your user.  Review what is visible.
-- grant role IDENTIFIER($pltfrAdmin) to user <your username>;
-- grant role IDENTIFIER($localfrAdmin) to user <your username>;
-- grant role IDENTIFIER($sarR) to user <your username>;
-- grant role IDENTIFIER($sarW) to user <your username>;
-- grant role IDENTIFIER($sarC) to user <your username>;

-- Uncomment, and use each role and notice what you can see in the database explorer:
-- use role IDENTIFIER($pltfrAdmin);
-- use role IDENTIFIER($localfrAdmin);
-- use role IDENTIFIER($sarC);
-- use role IDENTIFIER($sarW);
-- use role IDENTIFIER($sarR);
-- use role sysadmin;