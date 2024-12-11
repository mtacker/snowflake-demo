
# Snowflake CLI

## Installing the Snowflake CLI Locally

- How to install the [Snowflake CLI](https://docs.snowflake.com/developer-guide/snowflake-cli/installation/installation#label-snowcli-install-macos-installer)  

- Or, [for Mac users](https://github.com/snowflakedb/snowflake-cli):  
```
brew tap snowflakedb/snowflake-cli;
brew install snowflake-cli;
snow --help;
```

## Set your Snowflake CLI

- From /Users/MY_MAC_USERNAME/.snowflake/connections.toml your connections.toml will have entries like this:  

```
[DEV]
account = "nub12345.us-east-1"
user = "some SF user"
authenticator = "snowflake"
password = "*******"

[QA]
account = "udb12345.us-east-1"
user = "some SF user"
authenticator = "snowflake"
password = "*******"

[PRD]
account = "isb12345.us-east-1"
user = "some SF user"
authenticator = "snowflake"
password = "*******"
```

Last, set your local Snowflake CLI to point to a specific account by default:    
```
snow connection set-default DEV;  
snow sql -q "SHOW DATABASES;"
```

