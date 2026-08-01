drop database IF EXISTS mydb;
create database mydb;

CREATE TABLE mydb.employees (
    id bigint primary key auto_increment, 
    first_name varchar(100), 
    last_name varchar(100)
)ENGINE NDB;

CREATE TABLE mydb.birthdays (
    emp_id bigint,
    birthday date,
    constraint foreign key (emp_id) references employees(id)
)ENGINE NDB;

delimiter //
CREATE procedure mydb.new_employee(
    first char(100), 
    last char(100), 
    birthday date)
BEGIN
    INSERT INTO mydb.employees (first_name, last_name) VALUES (first, last);
    SET @id = (SELECT last_insert_id());
    INSERT INTO mydb.birthdays (emp_id, birthday) VALUES (@id, birthday);
END
//
delimiter ;
CALL mydb.new_employee("tim", "sehn", "1980-02-03");
