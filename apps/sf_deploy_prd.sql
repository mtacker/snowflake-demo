--------------------------------------------------------------------------------------------
--  SCRIPT:    Code from this script updates objects in Snowflake production account.
--             
--             
--
--   YY-MM-DD WHO          CHANGE DESCRIPTION
--   -------- ------------ -----------------------------------------------------------------

--------------------------------------------------------------------------------------------



-- SCHEMAS     

-- --------------------------------------------------------------------------------------------
-- -- Approach 1 - Include SET variables WITH the build code  
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm_control/snowflake_objects/databases/adm_control_db/schemas/tags/tags_build.sql;
-- -- Results in error:
-- -- "Unsupported feature 'session variables not supported during object dependencies backfill"
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm_control/snowflake_objects/databases/adm_control_db/schemas/alerts/alerts_build.sql;
-- --------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
-- Approach 2 - Separate SET variables FROM the build code
--------------------------------------------------------------------------------------------
-- tags.sql SUCCEEDS
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm_control/snowflake_objects/databases/adm_control_db/schemas/alerts/alerts.sql;

-- Alerts.sql FAILS with:
--
-- Uncaught exception of  │
-- │ type 'STATEMENT_ERROR' in file                                               │
-- │ @SNOWFLAKE_GIT_REPO/branches/master/apps/sf_deploy_prd.sql on line 36 at     │
-- │ position 0:                                                                  │
-- │ Cannot perform operation. This session does not have a current database.     │
-- │ Call 'USE DATABASE', or use a qualified name.   
-- *******************************************************************************
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm_control/snowflake_objects/databases/adm_control_db/schemas/tags/tags.sql;
--------------------------------------------------------------------------------------------



-- TABLES
USE SCHEMA ADM_CONTROL_DB.DEPLOY;
ALTER GIT REPOSITORY SNOWFLAKE_GIT_REPO FETCH;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/customer.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/product.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/orders.sql;

EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/customer.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/product.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/gold/tables/shipping.sql;
 
-- VIEWS

-- Uncaught exception of  │
-- │ type 'STATEMENT_ERROR' in file                                               │
-- │ @SNOWFLAKE_GIT_REPO/branches/master/apps/sf_deploy_prd.sql on line 56 at     │
-- │ position 0:                                                                  │
-- │ SQL compilation error:                                                       │
-- │ Stage 'PNC_SALES_DB.BRONZE.SNOWFLAKE_GIT_REPO' does not exist or not         │
-- │ authorized. 
-- inserting FETCH command because of weird error that keeps popping up ^
USE SCHEMA ADM_CONTROL_DB.DEPLOY;
ALTER GIT REPOSITORY SNOWFLAKE_GIT_REPO FETCH;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/bronze/views/customer_orders.sql;
USE SCHEMA ADM_CONTROL_DB.DEPLOY;
ALTER GIT REPOSITORY SNOWFLAKE_GIT_REPO FETCH;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/silver/views/customer_orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/silver/views/product_inventory.sql;

-- PROCEDURES
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc_sales/snowflake_objects/databases/pnc_sales_db/schemas/bronze/storedProcedures/load_bronze_customer_orders.sql;
