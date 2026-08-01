CREATE USER 'bigred'@'%' IDENTIFIED BY 'bigred';
ALTER USER 'bigred' IDENTIFIED WITH caching_sha2_password BY 'bigred';
GRANT ALL PRIVILEGES ON *.* TO 'bigred'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
