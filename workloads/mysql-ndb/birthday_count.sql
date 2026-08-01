delimiter //

CREATE PROCEDURE birthday_count(
    IN bday date,
    OUT count int)
BEGIN
    SET count = (SELECT count(*) FROM birthdays WHERE birthday = bday);
END
//

delimiter ;
