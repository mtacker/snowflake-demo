
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

-  your connections.toml should have entries from [Step 1](./00_snowflake_cicd_setup.md#step-1-create-snowflake-trial-accounts) like this:  

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

Set your Snowflake CLI to point to a specific account by default:    
```
snow connection set-default DEV;  
snow sql -q "SHOW DATABASES;"
```

