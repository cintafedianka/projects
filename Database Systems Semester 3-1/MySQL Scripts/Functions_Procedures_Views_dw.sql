
/* Procedure to fill time_dimension table */
DROP PROCEDURE IF EXISTS fill_date_dimension;
DELIMITER //
CREATE PROCEDURE fill_date_dimension(IN startdate DATE,IN stopdate DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate <= stopdate DO
        INSERT INTO time_dimension VALUES (
            YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
            currentdate,
            YEAR(currentdate),
            MONTH(currentdate),
            DAY(currentdate),
            QUARTER(currentdate),
            WEEKOFYEAR(currentdate),
            DATE_FORMAT(currentdate,'%W'),
            DATE_FORMAT(currentdate,'%M'),
            'f',
            CASE DAYOFWEEK(currentdate) WHEN 1 THEN 't' WHEN 7 then 't' ELSE 'f' END
            );
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END
//
DELIMITER ;
-- Execute procedure
TRUNCATE TABLE time_dimension;
CALL fill_date_dimension('2020-01-01','2030-01-01');
OPTIMIZE TABLE time_dimension;


/* Procedure to populate table special_room_price_change_fact_archive */
DROP PROCEDURE IF EXISTS archive_special_room_price_change_fact;
DELIMITER $$
CREATE PROCEDURE archive_special_room_price_change_fact ()
BEGIN

    TRUNCATE TABLE tuju_dw.special_room_price_change_fact_archive;
    INSERT INTO tuju_dw.special_room_price_change_fact_archive
        SELECT * FROM tuju_dw.special_room_price_change_fact;

END$$
DELIMITER ;


/* Procedure to see all hotel room price changes based on inputted date range */
DROP PROCEDURE IF EXISTS get_hotel_room_price_change_fact_by_date;
DELIMITER $$
CREATE PROCEDURE get_hotel_room_price_change_fact_by_date (
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    SELECT *
        FROM
            tuju_dw.hotel_room_price_change_fact
        WHERE
            timecode
        BETWEEN
            startDate
        AND
            endDate;
END$$
DELIMITER ;


/* Procedure to see all special room price changes based on inputted date range */
DROP PROCEDURE IF EXISTS get_special_room_price_change_fact_by_date;
DELIMITER $$
CREATE PROCEDURE get_special_room_price_change_fact_by_date (
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    SELECT *
        FROM
            tuju_dw.special_room_price_change_fact
        WHERE
            timecode
        BETWEEN
            startDate
        AND
            endDate;
END$$
DELIMITER ;


/* Procedure to see a customer's payment between inputted date range */
DROP PROCEDURE IF EXISTS get_customer_payments_fact_by_date;
DELIMITER $$
CREATE PROCEDURE get_customer_payments_fact_by_date (
    IN thisCustomerID INT,
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    SELECT *
        FROM
            tuju_dw.customer_payments_fact
        WHERE
            customerID = thisCustomerID
        AND
            timecode
        BETWEEN
            startDate
        AND
            endDate;
END$$
DELIMITER ;

-- VIEW TABLES

/* View table to see how many hotel room price changes per outlet*/
DROP VIEW IF EXISTS hotel_room_price_changes_per_outlet;
CREATE VIEW hotel_room_price_changes_per_outlet AS
    SELECT
        outletID,
        COUNT(*)
    FROM
        tuju_dw.hotel_room_price_change_fact
    GROUP BY
        outletID;

/* View table to see how many special room price changes per outlet*/
DROP VIEW IF EXISTS special_room_price_changes_per_outlet;
CREATE VIEW special_room_price_changes_per_outlet AS
    SELECT
        outletID,
        COUNT(*)
    FROM
        tuju_dw.special_room_price_change_fact
    GROUP BY
        outletID;

