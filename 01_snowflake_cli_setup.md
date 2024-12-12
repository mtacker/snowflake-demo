
# Snowflake CLI

## Installing the Snowflake CLI Locally

- Install the [Snowflake CLI](https://docs.snowflake.com/developer-guide/snowflake-cli/installation/installation#label-snowcli-install-macos-installer)  
- [Configure](https://docs.snowflake.com/developer-guide/snowflake-cli/connecting/configure-cli) the Snowflake CLI (including connections.toml file)
- [Mac users](https://github.com/snowflakedb/snowflake-cli):  
```
brew tap snowflakedb/snowflake-cli;
brew install snowflake-cli;
snow --help;
```

## Set your Snowflake CLI

-  your connections.toml should have entries from Step 1 like this:  
[click on this link](#my-multi-word-header)
[run this code](00_snowflake_cicd_setup.md##-Step-1:-Create-Snowflake-trial-accounts) 
[sub-section](./child.md#sub-section) 

```
[DEV]
account = "csb*****.us-east-1 "
user = "some SF user"
authenticator = "snowflake"
password = "*******"

[QA]
account = "frb*****.us-east-1  "
user = "some SF user"
authenticator = "snowflake"
password = "*******"

[PRD]
account = "sab*****.us-east-1 "
user = "some SF user"
authenticator = "snowflake"
password = "*******"
```
Last, set your local Snowflake CLI to point to a specific account by default:    
```
snow connection set-default DEV;  
snow sql -q "SHOW DATABASES;"
```

