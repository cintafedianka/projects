/* Create Triggers In The Database */
-------------------------------------


/* Create trigger to insert data into hotel_room_occupied when reservationStatus changes to "complete" */
USE tuju_database;
DROP TRIGGER IF EXISTS insert_into_hotel_room_occupied;

DELIMITER $$
CREATE TRIGGER insert_into_hotel_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
    -- DECLARE necessary variables
    DECLARE currentRow INT;
    DECLARE currentHotelRoomID INT;
    DECLARE currentDate DATE;

    -- IF STATEMENT to check if status have updated to 'complete'
    IF NEW.reservationStatus = 'complete' THEN

        -- CREATE temporary table to store queried data
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_table
        (
            rowNumber INT,
            thisHotelRoomID INT,
            thisCheckInDate DATE,
            thisCheckOutDate DATE
        );

        -- INSERT INTO temporary table all necessary data
        SET @row_number = 0;
        INSERT INTO temp_table (rowNumber, thisHotelRoomID, thisCheckInDate, thisCheckOutDate)
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

        -- LOOP for every row of data from the temporary table
        SET currentRow = 1;
        WHILE currentRow <= (SELECT COUNT(*) FROM temp_table)
        DO
            SET currentHotelRoomID = (SELECT thisHotelRoomID FROM temp_table WHERE rowNumber = currentRow);
            SET currentDate = (SELECT thisCheckInDate FROM temp_table WHERE rowNumber = currentRow);

            -- NESTED LOOP for every single date between check-in and check-out for each row of data
            WHILE currentDate < (SELECT thisCheckOutDate FROM temp_table WHERE rowNumber = currentRow) --!!!!! checkout date i think harusnya not occupied right? if occupied then <= if not occupied then <  !!!!!--
            DO
                INSERT INTO hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);

                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 day);
            END WHILE;

            SET currentRow = (currentRow + 1);
        END WHILE;

        DROP TEMPORARY TABLE IF EXISTS temp_table;

    END IF;
END $$
DELIMITER ;


/* Create trigger to insert data into special_room_occupied when reservationStatus changes to "complete" */
USE tuju_database;
DROP TRIGGER IF EXISTS insert_into_special_room_occupied;

DELIMITER $$
CREATE TRIGGER insert_into_special_room_occupied AFTER UPDATE ON tuju_database.reservation FOR EACH ROW
BEGIN
    -- DECLARE Necessary Variables
    DECLARE currentRow INT;
    DECLARE currentSpecialRoomID INT;
    DECLARE currentSpecialRoomTypeID INT;
    DECLARE currentDate DATE;
    DECLARE dayCounter INT;

    -- IF STATEMENT to check if status have updated to 'complete'
    IF NEW.reservationStatus = 'complete' THEN

        -- Create temporary table to store queried data
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_table
        (
            rowNumber INT,
            thisSpecialRoomID INT,
            thisSpecialRoomTypeID INT,
            thisDateBooked DATE
        );

        -- INSERT INTO temporary table all necessary data
        SET @row_number = 0;
        INSERT INTO temp_table (rowNumber, thisSpecialRoomID, thisSpecialRoomTypeID, thisDateBooked)
        SELECT
            (@row_number:=@row_number + 1) AS rowNumber,
            specialRoomID AS thisSpecialRoomID,
            specialRoomTypeID AS thisSpecialRoomTypeID,
            dateBooked AS thisDateBooked
        FROM
            reservation r
        INNER JOIN
            special_room_booked sr USING (reservationID)
        WHERE 
            reservationID = NEW.reservationID;

         -- LOOP for every row of data from the temporary table
        SET currentRow = 1;
        WHILE currentRow <= (SELECT COUNT(*) FROM temp_table)
        DO
            SET currentSpecialRoomID = (SELECT thisSpecialRoomID FROM temp_table WHERE rowNumber = currentRow);
            SET currentSpecialRoomTypeID = (SELECT thisSpecialRoomTypeID FROM temp_table WHERE rowNumber = currentRow);
            SET currentDate = (SELECT thisDateBooked FROM temp_table WHERE rowNumber = currentRow);

            -- IF STATEMENT to check if the special room type is for 1 day or 1 month

            -- IF special room type is 1 month
            IF (SELECT priceType FROM special_room_type WHERE specialRoomTypeID = currentSpecialRoomTypeID) = 'month' THEN
                SET dayCounter = 1;

                -- LOOP to insert data 30 times into special_room_occupied
                WHILE dayCounter <= 30 -- !!!!! ini mau berapa hari kedepannya kalo month? !!!!! --
                DO
                    INSERT INTO special_room_occupied(specialRoomID, dateOccupied)
                    VALUES(currentSpecialRoomID, currentDate);
                    SET currentDate = DATE_ADD(currentDate, INTERVAL 1 day);
                    SET dayCounter = (dayCounter + 1);
                END WHILE;

            -- IF special room type is 1 day
            ELSE
                INSERT INTO special_room_occupied(specialRoomID, dateOccupied)
                VALUES(currentSpecialRoomID, currentDate);
            END IF;

            SET currentRow = (currentRow + 1);
        END WHILE;

        DROP TEMPORARY TABLE IF EXISTS temp_table;

    END IF;
END $$
DELIMITER ;

