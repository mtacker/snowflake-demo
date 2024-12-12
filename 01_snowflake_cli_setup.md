
# Snowflake CLI

## Install the Snowflake CLI Locally

- [Install](https://docs.snowflake.com/developer-guide/snowflake-cli/installation/installation#label-snowcli-install-macos-installer) Snowflake CLI
- [Configure](https://docs.snowflake.com/developer-guide/snowflake-cli/connecting/configure-cli) Snowflake CLI (including connections.toml file)
- [Mac users](https://github.com/snowflakedb/snowflake-cli):  
```
brew tap snowflakedb/snowflake-cli;
brew install snowflake-cli;
snow --help;
```

## Configure your Snowflake CLI

-  Update connections.toml with entries from [Step 1](./00_snowflake_cicd_setup.md#step-1-create-snowflake-trial-accounts):  

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

