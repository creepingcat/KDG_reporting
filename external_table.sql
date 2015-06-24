Set ECHO ON
SET TIMING ON
SET TIME ON
SET VERIFY OFF
SET SERVEROUTPUT ON

column file_name new_value file_name
select 'LOGS\'||user||'_at_'||global_name||'_on_'||to_char(sysdate,'yyyymmdd_hh24miss')||'.log' as file_name from global_name;

SPOOL &file_name

DROP TABLE KDGDoorEvents;
CREATE TABLE KDGDoorEvents
  (
    TimeReceived    DATE,
    Type            VARCHAR(100),
    LogCode         VARCHAR(100),
    Description     VARCHAR(100),
    Device          VARCHAR(100),
    ParentDevice    VARCHAR(100),
    Address         VARCHAR(100),
    PersonnelRecord VARCHAR(100),
    Credential      DECIMAL(38,0),
    Data_string     VARCHAR(1000),
    Location        VARCHAR(100)
  )
  ORGANIZATION EXTERNAL
  (
    TYPE ORACLE_LOADER DEFAULT DIRECTORY KDG_REPORTING_DATA ACCESS PARAMETERS
    (
    records delimited BY newline
    skip 1
    badfile KDG_REPORTING_BAD:'kdg_rep_%a_%p.bad'
    logfile KDG_REPORTING_LOGS:'kdg_rep_%a_%p.log'
    fields terminated BY ',' OPTIONALLY ENCLOSED BY '"'
    missing field VALUES are NULL
    (
    TimeReceived CHAR DATE_FORMAT DATE MASK "mm/dd/yyyy hh24:mi:ss",
    Type ,
    LogCode ,
    Description ,
    Device ,
    ParentDevice ,
    Address ,
    PersonnelRecord ,
    Credential ,
    Data_string,
    Location
    )
    ) LOCATION ('KDG_Reporting_all.csv')
  )
  reject limit UNLIMITED ;

commit;

SPOOL OFF
SET VERIFY ON
SET SERVEROUTPUT OFF
DISCONNECT
EXIT
