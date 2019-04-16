Microsoft SQL Server
====================

## 1. Docker images
* Repo [Microsoft/mssql-docker](https://github.com/Microsoft/mssql-docker)
* Linux base:
  * `mcr.microsoft.com/mssql/server`
  * `microsoft/mssql-server-linux`
  * `microsoft/mssql-server`
* Windows base:
  * `microsoft/mssql-server-windows-developer`
  * `microsoft/mssql-server-windows-express`

## 2. MSSQL engine
### 2.1 Startup options
[ref](https://docs.microsoft.com/sql/database-engine/configure-windows/database-engine-service-startup-options)

### 2.2 initdb
Example from:
* [shanegenschaw/mssql-server-linux](https://github.com/shanegenschaw/mssql-server-linux/blob/master/docker-entrypoint-initdb.sh)
* [Microsoft/sql-server-samples](https://github.com/Microsoft/sql-server-samples)

### 2.3 MSSQL Configure
* [Configure with mssql-conf](https://docs.microsoft.com/sql/linux/sql-server-linux-configure-mssql-conf)
* [Environment variables](https://docs.microsoft.com/sql/linux/sql-server-linux-configure-environment-variables)
* [Configure Docker containers](https://docs.microsoft.com/sql/linux/sql-server-linux-configure-docker)
