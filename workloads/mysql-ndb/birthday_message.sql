DELIMITER //

CREATE procedure birthday_message(
    bday date,
    OUT message varchar(100))
BEGIN
    DECLARE counter int;
    DECLARE name varchar(100);
    SELECT count(*) INTO counter FROM birthdays WHERE birthday = bday;
    CASE counter
        WHEN 0 THEN
            SET message = "Nobody has this birthday";
        WHEN 1 THEN
            SELECT concat(first_name, " ", last_name) INTO name
                FROM employees join birthdays
                on emp_id = id
                WHERE birthday = bday;
            SET message = (SELECT concat("It's ", name, "'s birthday"));
        ELSE
            SET message = "More than one employee has this birthday";
    END CASE;
END
//

