#!/bin/sh

cd /home/oracle;

setup/dockerInit.sh;
sqlplus sys/Oradoc_db1@ORCLCDB as sysdba @run;
