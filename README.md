# Snowflake Example Code Demonstrating:  
- RBAC model fully fleshed out demonstrating the use of Functional Roles  
- 5 hypothetical databases to illustrate security across multiple teams (i.e. Functional Roles)    
- Use of Github Actions for CI/CD  
- Automated deployments to multiple Snowflake Accounts (DEV/QA/PRD) using Github Secrets  
- Orchestration using Snowflake's new ```EXECUTE IMMEDIATE FROM``` feature  
- Git Integration with Snowflake using a local stage  

## Git repository in Snowflake
https://docs.snowflake.com/en/developer-guide/git/git-overview
<!-- <p align="center"> -->
    <img src=".images/git_integration.png" alt="Git Integration with Snowflake using a local stage" width="600" height="600">
<!-- </p> -->

## Current RBAC Model

![RBAC Model](.images/rbac_diagram.png)
--------------------------------------------------------------  
## Local Directory Structure 





Our proposed directory structure is inpired by the Snowflake Object Hierarchy:  
![Snowflake Object Hierarchy](./.images/snowflakeObjectHierarchy.png)

For Example:  
```
mkdir -p ./apps/adm/{snowflake_objects/databases/adm_platform_db/schemas/alerts/{externalTables,fileFormats,maskingPolicies,pipes,stages,streams,tables,tasks,views,sequences,storedProcedures,udf,streams,tasks},scripts};  
mkdir -p ./apps/adm/{snowflake_objects/databases/adm_platform_db/schemas/tags/{externalTables,fileFormats,maskingPolicies,pipes,stages,streams,tables,tasks,views,sequences,storedProcedures,udf,streams,tasks},scripts};  
```

![Resulting Directory Structure](./.images/directoryStructure.png)

Actual for this repo:
![Our Current Directory Structure](./.images/actualDirectoryStructure.png)
