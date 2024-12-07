!!ARCHIVED!!

/* Create Triggers In The Database */
-------------------------------------

--- nested loop. Pertama loop each of the rows yang keluar dari query 'inner join reservation sama hotelroombooked sama specialroombooked abis itu select * where reservation status = complete.
--- kedua, loop for every date between checkindate checkoutdate and then insert into hotelroomoccupied dan specialroomoccupied

/* Create trigger to insert data into hotel_room_occupied when reservationStatus changes to "complete" */
DROP TRIGGER IF EXISTS insert_into_hotel_room_occupied;

DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
    IF tuju_database.reservation.reservationStatus = 'complete'
    
    SET @row_number = 0;

        CREATE VIEW hotel_room_occupied_trigger(hotelRoomID, checkInDate, checkOutDate) AS
        SELECT
            (@row_number:=@row_number + 1) AS rowNumber, hotelRoomID, checkInDate, checkOutDate
            FROM reservation r INNER JOIN hotel_room_booked hr USING (reservationID)
            WHERE reservationStatus = 'complete';
    
    END IF
END $$
DELIMITER ;

---Lets try from scratch

DROP TRIGGER IF EXISTS insert_into_hotel_room_occupied;

DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN

    DECLARE currentRow INT;
    DECLARE currentHotelRoomID INT;
    DECLARE currentDate DATE;

    IF NEW.reservationStatus = 'complete' THEN
        
        CREATE TEMPORARY TABLE temp_table (
        rowNumber INT,
        thisHotelRoomID INT,
        thisCheckInDate DATE,
        thisCheckOutDate DATE
        );

        SET @row_number = 0;
        INSERT INTO temp_table(rowNumber, thisHotelRoomID, thisCheckInDate, thisCheckOutDate)
        SELECT
            (@row_number:=@row_number + 1) AS rowNumber,
            hotelRoomID AS thisHotelRoomID,
            checkInDate AS thisCheckInDate,
            checkOutDate AS thisCheckOutDate
        FROM
            reservation r
        INNER JOIN
            hotel_room_booked hr USING (reservationID)
        WHERE 
            reservationID = NEW.reservationID;
        

        SET currentRow = 1;
        WHILE currentRow <= (SELECT COUNT(*) FROM temp_table)
        DO
            SET currentHotelRoomID = (SELECT thisHotelRoomID FROM temp_table WHERE temp_table.rowNumber = currentRow);
            SET currentDate = (SELECT thisCheckInDate FROM temp_table WHERE temp_table.rowNumber = currentRow);
            
            WHILE currentDate <= temp_table.thisCheckOutDate
            DO
                INSERT INTO hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);

                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 day);
            END WHILE;
            
            SET currentRow = (currentRow + 1);
        END WHILE;
        DROP TEMPORARY TABLE temp_table;
    END IF;
END $$
DELIMITER ;



---chatgpt no temporary table
DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN

    DECLARE currentRow INT;
    DECLARE currentHotelRoomID INT;
    DECLARE currentDate DATE;

    IF NEW.reservationStatus = 'complete' THEN

        CREATE TEMPORARY TABLE IF NOT EXISTS temp_table_session_specific
        (
            rowNumber INT,
            thisHotelRoomID INT,
            thisCheckInDate DATE,
            thisCheckOutDate DATE
        );

        SET @row_number = 0;
        INSERT INTO temp_table_session_specific (rowNumber, thisHotelRoomID, thisCheckInDate, thisCheckOutDate)
        SELECT
            (@row_number:=@row_number + 1) AS rowNumber,
            hotelRoomID AS thisHotelRoomID,
            checkInDate AS thisCheckInDate,
            checkOutDate AS thisCheckOutDate
        FROM
            reservation r
        INNER JOIN
            hotel_room_booked hr USING (reservationID)
        WHERE 
            reservationID = NEW.reservationID;

        SET currentRow = 1;
        WHILE currentRow <= (SELECT COUNT(*) FROM temp_table_session_specific)
        DO
            SET currentHotelRoomID = (SELECT thisHotelRoomID FROM temp_table_session_specific WHERE rowNumber = currentRow);
            SET currentDate = (SELECT thisCheckInDate FROM temp_table_session_specific WHERE rowNumber = currentRow);

            WHILE currentDate <= (SELECT thisCheckOutDate FROM temp_table_session_specific WHERE rowNumber = currentRow)
            DO
                INSERT INTO hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);

                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 day);
            END WHILE;

            SET currentRow = (currentRow + 1);
        END WHILE;

        DROP TEMPORARY TABLE IF EXISTS temp_table_session_specific;

    END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_into_hotel_room_occupied;

DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN

    IF NEW.reservationStatus = 'complete' THEN

        SET @row_number = 0;

        DECLARE currentRow INT;
        DECLARE currentHotelRoomID INT;
        DECLARE currentDate DATE;

        
        SELECT
            (@row_number:=@row_number + 1) AS rowNumber,
            hotelRoomID AS thisHotelRoomID,
            checkInDate AS thisCheckInDate,
            checkOutDate AS thisCheckOutDate
        FROM reservation r
        INNER JOIN hotel_room_booked hr USING (reservationID)
        WHERE reservationStatus = 'complete';

        
        WHILE (SELECT COUNT(*) FROM hotel_room_occupied_trigger) > currentRow
        DO
            SET currentHotelRoomID = SELECT thisHotelRoomID WHERE rowNumber = currentRow;
            SET currentDate = thisCheckInDate WHERE rowNumber = currentRow;
            WHILE thisCheckOutDate >= currentDate
                DO
                INSERT INTO hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);
                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 day);
            END WHILE

            SET currentRow = (currentRow + 1);
        END WHILE
    END IF;
END $$
DELIMITER ;

---chatgpt select
DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
    INSERT INTO debug_log_table(log_message) VALUES ('triggered');
    DECLARE currentRow INT DEFAULT 0;
    DECLARE currentHotelRoomID INT;
    DECLARE currentDate DATE;
    DECLARE thisCheckInDate DATE;
    DECLARE thisCheckOutDate DATE;
    DECLARE thisHotelRoomID INT;

    -- Declare a new variable for user-defined row number
    DECLARE rowNumber INT DEFAULT 0;

    IF NEW.reservationStatus = 'complete' THEN
        -- Initialize user-defined row number after declaration
        SET rowNumber = 0;

        -- Use different variable for user-defined row number
        SELECT 
            MAX(rowNumber := rowNumber + 1) AS rowNumber,
            MAX(hotelRoomID) AS thisHotelRoomID,
            MAX(checkInDate) AS thisCheckInDate,
            MAX(checkOutDate) AS thisCheckOutDate
        INTO 
            rowNumber, thisHotelRoomID, thisCheckInDate, thisCheckOutDate
        FROM 
            reservation r
        INNER JOIN 
            hotel_room_booked hr USING (reservationID)
        WHERE 
            reservationStatus = 'complete'
        ORDER BY 
            reservationID;

        WHILE currentRow < rowNumber DO
            -- Fetch values into variables using INTO clause
            SELECT thisHotelRoomID, thisCheckInDate INTO currentHotelRoomID, currentDate
            FROM hotel_room_occupied_trigger
            WHERE rowNumber = currentRow;

            WHILE thisCheckOutDate >= currentDate DO
                INSERT INTO tuju_database.hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);
                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
            END WHILE;

            SET currentRow = (currentRow + 1);
        END WHILE;
    END IF;

END $$

DELIMITER ;

-----------------------

DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
    DECLARE currentRow INT DEFAULT 0;
    DECLARE currentHotelRoomID INT;
    DECLARE currentDate DATE;

    -- Declare a new variable for user-defined row number
    DECLARE rowNumber INT DEFAULT 0;
    DECLARE thisHotelRoomID INT;
    DECLARE thisCheckInDate DATE;
    DECLARE thisCheckOutDate DATE;

    IF NEW.reservationStatus = 'complete' THEN
        -- Initialize user-defined row number after declaration
        SET rowNumber = 0;

        -- Use different variable for user-defined row number
        SELECT 
            MAX(rowNumber := rowNumber + 1),
            MAX(hotelRoomID),
            MAX(checkInDate),
            MAX(checkOutDate)
        INTO 
            rowNumber, thisHotelRoomID, thisCheckInDate, thisCheckOutDate
        FROM 
            reservation r
        INNER JOIN 
            hotel_room_booked hr USING (reservationID)
        WHERE 
            reservationStatus = 'complete'
            AND reservationID = NEW.reservationID
        ORDER BY 
            reservationID;

        WHILE currentRow < rowNumber DO
            WHILE thisCheckOutDate >= currentDate DO
                INSERT INTO tuju_database.hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (thisHotelRoomID, currentDate);
                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
            END WHILE;

            SET currentRow = (currentRow + 1);
        END WHILE;
    END IF;

END $$

DELIMITER ;


------- NO ERROR BUT NOT WORKING
DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
---INSERT INTO payment_type(paymentTypeID, typeName) VALUES (10, 'triggered');
    DECLARE currentRow INT;
    DECLARE currentHotelRoomID INT;
    DECLARE currentDate DATE;
    DECLARE thisCheckInDate DATE;  -- Declare thisCheckInDate
    DECLARE thisCheckOutDate DATE; -- Declare thisCheckOutDate
    DECLARE thisHotelRoomID INT;

    -- Declare @row_number here
    DECLARE row_number INT;

    IF NEW.reservationStatus = 'complete' THEN


        -- Initialize @row_number after declaration
        SET row_number = 0;

        -- Use INTO clause in the SELECT statement to fetch values into variables
        SELECT 
            MAX(@row_number := @row_number + 1) AS rowNumber,
            MAX(hotelRoomID) AS thisHotelRoomID,
            MAX(checkInDate) AS thisCheckInDate,
            MAX(checkOutDate) AS thisCheckOutDate
        INTO 
            row_number, thisHotelRoomID, thisCheckInDate, thisCheckOutDate
        FROM 
            reservation r
        INNER JOIN 
            hotel_room_booked hr USING (reservationID)
        WHERE 
            reservationStatus = 'complete'
        ORDER BY 
            reservationID;

        -- Use @row_number in the loop condition
        WHILE currentRow < row_number DO
            -- Fetch values into variables using INTO clause
            SELECT thisHotelRoomID, thisCheckInDate INTO currentHotelRoomID, currentDate
            FROM hotel_room_occupied_trigger
            WHERE rowNumber = currentRow;

            WHILE thisCheckOutDate >= currentDate DO
                INSERT INTO tuju_database.hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);
                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
            END WHILE;

            SET currentRow = (currentRow + 1);
        END WHILE;
    END IF;

END $$

DELIMITER ;





---chatgpt cursor
DELIMITER $$

CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
    IF NEW.reservationStatus = 'complete' THEN

        SET @row_number = 0;

        DECLARE currentRow INT DEFAULT 0;
        DECLARE currentHotelRoomID INT;
        DECLARE currentDate DATE;

        -- Use a cursor to fetch rows
        DECLARE cursor_name CURSOR FOR
            SELECT
                (@row_number := @row_number + 1) AS rowNumber,
                hotelRoomID AS thisHotelRoomTypeID,
                checkInDate AS thisCheckInDate,
                checkOutDate AS thisCheckOutDate
            FROM reservation r INNER JOIN hotel_room_booked hr USING (reservationID)
            WHERE reservationStatus = 'complete';

        -- Declare a handler for when no more rows are found
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET currentRow = -1;

        OPEN cursor_name;

        -- Start the loop
        my_loop: LOOP
            FETCH cursor_name INTO currentRow, currentHotelRoomID, thisCheckInDate, thisCheckOutDate;

            -- Check if there are still rows to process
            IF currentRow = -1 THEN
                LEAVE my_loop;
            END IF;

            -- Process the current row
            WHILE thisCheckOutDate >= currentDate DO
                INSERT INTO hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);
                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
            END WHILE;
        END LOOP;

        -- Close the cursor
        CLOSE cursor_name;

    END IF;
END $$

DELIMITER ;






SET @rowNumber = 0;
DROP VIEW IF EXISTS hotel_room_occupied_trigger;
CREATE VIEW hotel_room_occupied_trigger AS
SELECT
hotelRoomID, checkInDate, checkOutDate, rowNumber()
FROM reservation r INNER JOIN hotel_room_booked hr USING (reservationID)
WHERE reservationStatus = 'complete';

ROW_NUMBER() OVER (ORDER BY some_column) AS row_numbe

DECLARE currentRow INT DEFAULT 0;
WHILE (SELECT COUNT(*) FROM hotel_room_occupied_trigger) > currentRow
DO








END WHILE




delimiter //

CREATE FUNCTION `row_number`() RETURNS int
    NO SQL
    NOT DETERMINISTIC
     begin
      SET @rowNumber := @rowNumber + 1;
      return @rowNumber;
     end
     //

delimiter ;




