-- Change as need to point to your Github UserName, URL, and Personal Access Token
USE ROLE SYSADMIN;
CREATE DATABASE IF NOT EXISTS ADM_PLATFORM_DB;
CREATE SCHEMA IF NOT EXISTS DEPLOY;
==============================================
--   Build a local repository stage for github 
==============================================
USE ROLE ACCOUNTADMIN;
USE DATABASE ADM_PLATFORM_DB;
USE SCHEMA DEPLOY;
CREATE OR REPLACE USER SVC_DEPLOY
PASSWORD = '[SF service account pwd]'
DEFAULT_ROLE = ACCOUNTADMIN;
GRANT ROLE ACCOUNTADMIN TO USER SVC_DEPLOY;
CREATE OR REPLACE SECRET GITHUB_SECRET
	TYPE = PASSWORD
	USERNAME = '[github user name]' 
	PASSWORD = 'github_pat_*******************************'  -- Github Personal Access Token 
 
CREATE OR REPLACE API INTEGRATION GITHUB_API_INTEGRATION
	API_PROVIDER = GIT_HTTPS_API
	API_ALLOWED_PREFIXES = ('https://github.com/[root]')
	ALLOWED_AUTHENTICATION_SECRETS = (GITHUB_SECRET)
	ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY SNOWFLAKE_GIT_REPO
	API_INTEGRATION = GITHUB_API_INTEGRATION
	GIT_CREDENTIALS = GITHUB_SECRET
	ORIGIN = 'https://github.com/[root]/[your repo]';