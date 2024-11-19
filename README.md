# This Repo Intends to Demonstrate the Following  
- RBAC/Security Model using Custom Roles together with Functional Roles  
- Use of Github Actions for CI/CD  
- Automated deployments to multiple Snowflake Accounts (DEV/QA/PRD) using Github Secrets  
- Orchestration using Snowflake's new ```EXECUTE IMMEDIATE FROM``` feature  
- Git Integration with Snowflake using a local stage  

## Git repository in Snowflake
<p align="center">
    <img src=".images/git_integration.png" alt="Git Integration with Snowflake using a local stage" width="600" height="600">
</p>

## Current RBAC Model

![RBAC Model](.images/rbac_diagram.png)
--------------------------------------------------------------  
## Local Directory Structure 





Our proposed directory structure is inpired by the Snowflake Object Hierarchy:  
![Snowflake Object Hierarchy](./.images/snowflakeObjectHierarchy.png)

For Example:  
![Resulting Directory Structure](./.images/directoryStructure.png)

Actual for this repo:
![Our Current Directory Structure](./.images/actualDirectoryStructure.png)

