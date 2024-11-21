--------------------------------------------------------------------------------------------
--  SCRIPT:    Code from this script updates objects in Snowflake production account.
--             
--             
--
--   YY-MM-DD WHO          CHANGE DESCRIPTION
--   -------- ------------ -----------------------------------------------------------------

--------------------------------------------------------------------------------------------



-- SCHEMAS     

--------------------------------------------------------------------------------------------
-- -- Approach 1 - Include the SET variables WITH the build code:
--------------------------------------------------------------------------------------------
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/alerts/alerts_build.sql;

-- -- First 'EXECUTE IMMEDIATE FROM' fails with error:
--
-- Uncaught exception of  │
-- │"Unsupported feature 'session variables not supported during object dependencies backfill"     │
-- *******************************************************************************

-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/tags/tags_build.sql;
--------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------
-- Approach 2 - Put SET variables in a separate file and call the build code
--------------------------------------------------------------------------------------------
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/alerts/alerts_schema.sql;

-- First 'EXECUTE IMMEDIATE FROM' succeeds, but the Second statement fails with error:
--
-- Uncaught exception of  │
-- │ type 'STATEMENT_ERROR' in file                                               │
-- │ @SNOWFLAKE_GIT_REPO/branches/master/apps/sf_deploy_prd.sql on line 36 at     │
-- │ position 0:                                                                  │
-- │ Cannot perform operation. This session does not have a current database.     │
-- │ Call 'USE DATABASE', or use a qualified name.   
-- *******************************************************************************
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/tags/tags_schema.sql;
--------------------------------------------------------------------------------------------

-- SCHEMAS  
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/alerts/alerts_schema.sql;  
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/tags/tags_schema.sql; 
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/policies/policies_schema.sql; 
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/hr/snowflake_objects/databases/hr_people_db/schemas/employee/hr_people_employee_schema.sql; 
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/cpg/snowflake_objects/databases/cpg_assetavail_db/schemas/dbo/cpg_assetavail_dbo_schema.sql; 
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/bp/snowflake_objects/databases/bp_customer_db/schemas/cust360/bp_customer_cust360_schema.sql; 
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/pnc_sales_bronze_schema.sql;  
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/pnc_sales_silver_schema.sql; 
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/gold/pnc_sales_gold_schema.sql; 

-- TABLES
USE SCHEMA ADM_PLATFORM_DB.DEPLOY;
ALTER GIT REPOSITORY SNOWFLAKE_GIT_REPO FETCH;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/customer.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/product.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/customer.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/product.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/gold/tables/shipping.sql;
 
-- VIEWS

-- Uncaught exception of  │
-- │ type 'STATEMENT_ERROR' in file                                               │
-- │ @SNOWFLAKE_GIT_REPO/branches/master/apps/sf_deploy_prd.sql on line 56 at     │
-- │ position 0:                                                                  │
-- │ SQL compilation error:                                                       │
-- │ Stage 'PNC_SALES_DB.BRONZE.SNOWFLAKE_GIT_REPO' does not exist or not         │
-- │ authorized. 

-- I'm inserting FETCH command BELOW because of random error that keeps popping up ^
USE SCHEMA ADM_PLATFORM_DB.DEPLOY;
ALTER GIT REPOSITORY SNOWFLAKE_GIT_REPO FETCH;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/views/customer_orders.sql;
USE SCHEMA ADM_PLATFORM_DB.DEPLOY;
ALTER GIT REPOSITORY SNOWFLAKE_GIT_REPO FETCH;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/views/customer_orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/views/product_inventory.sql;

-- PROCEDURES
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/stored_procedures/load_bronze_customer_orders.sql;
