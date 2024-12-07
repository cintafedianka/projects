/* Functions, Procedures, and Views for tuju database */
------------------------------------------------


/* Procedure for customer registration */
DELIMITER $$
CREATE PROCEDURE newCustomerRegistration(
  IN customerName VARCHAR(100),
  IN phoneNumber VARCHAR(16),
  IN emailAddress VARCHAR(100),
  IN userName VARCHAR(50),
  IN password VARCHAR(100)
)
BEGIN
    INSERT INTO Customer (
        customerName,
        phoneNumber,
        emailAddress,
	username,
	password

    ) VALUES (
        customerName,
        phoneNumber,
        emailAddress,
	username,
	password
    );
END$$
DELIMITER ;


/* Procedure to show avaiable hotel rooms */
DELIMITER $$

CREATE PROCEDURE show_available_hotel_rooms(IN thisOutletID INT, IN checkInDate DATE, IN checkOutDate DATE)
BEGIN
  SELECT hotelRoomID
  FROM hotel_room
  WHERE 
    hotelRoomTypeID IN (
      SELECT hotelRoomTypeID
      FROM hotel_room_type
      WHERE outletID = thisOutletID
    )
    AND NOT EXISTS (
      SELECT *
      FROM hotel_room_occupied
      WHERE hotelRoomID = hotel_room.hotelRoomID
      AND dateOccupied BETWEEN checkInDate AND checkOutDate
    );
END $$
DELIMITER ;

/* Procedure to show available special rooms */
DELIMITER $$

CREATE PROCEDURE show_available_special_rooms(IN thisOutletID INT, IN thisDate DATE)
BEGIN
  SELECT specialRoomID
  FROM special_room
  WHERE
    specialRoomTypeID IN (
        SELECT specialRoomTypeID
        FROM special_room_type
        WHERE outletID = thisOutletID
      )
  AND NOT EXISTS (
    SELECT *
    FROM special_room_occupied
    WHERE specialRoomID = special_room.specialRoomID
    AND dateOccupied = thisDate
  );
END $$
DELIMITER ;


/* Procedure to update hotel room guest information */
DELIMITER $$
CREATE PROCEDURE UpdateHotelGuestInfo(
  IN p_reservationID INT,
  IN p_hotelRoomBookedID INT,
  IN newGuestName VARCHAR(100),
  IN newPhoneNumber VARCHAR(16)
  )
BEGIN
    UPDATE hotel_room_booked
    SET
        guestName = newGuestName,
        phoneNumber = newPhoneNumber
    WHERE
        reservationID = p_reservationID
        AND hotelRoomBookedID = p_hotelRoomBookedID;
END$$
DELIMITER ;


/* Procedure to update special room guest information */
DELIMITER $$
CREATE PROCEDURE UpdateSpecialGuestInfo(
    IN reservationID INT,
    IN specialRoomBookedID INT,
    IN newGuestName VARCHAR(100),
    IN newPhoneNumber VARCHAR(16)
)
BEGIN
    UPDATE special_room_booked
    SET
        guestName = newGuestName,
        phoneNumber = newPhoneNumber
    WHERE
        reservationID = reservationID
        AND specialRoomBookedID = specialRoomBookedID;
END$$
DELIMITER ;


/* Procedure to update reservation status to pending */
DELIMITER $$
CREATE PROCEDURE update_reservation_status_to_pending2(IN thisReservationID INT)
BEGIN
    UPDATE reservation
    SET
        reservationStatus = 'pending'
    WHERE
        reservationID = thisReservationID;
END$$
DELIMITER ;

/* Procedure to update reservation status to complete and insert into payment table when payment has been completed */
DELIMITER $$
CREATE PROCEDURE UpdateReservationAndInsertPayment(
  IN status ENUM('cart', 'pending', 'complete'),
  IN paymentTypeID VARCHAR(255),
  IN reservationID INT,
  totalPaid DOUBLE
  )
BEGIN
  -- Update existing data
  UPDATE reservation SET reservationStatus = status WHERE reservationID = reservationID;

  -- Insert new data
  INSERT INTO payment(reservationID, paymentTypeID, totalPaid) VALUES (reservationID, paymentTypeID, totalPaid);
END $$
DELIMITER ;

-------------

/* Procedure to populate table special_room_occupancy_fact_archive */
DROP PROCEDURE IF EXISTS archive_special_room_occupancy_fact;
DELIMITER $$
CREATE PROCEDURE archive_special_room_occupancy_fact ()
BEGIN

    TRUNCATE TABLE tuju_dw.special_room_occupancy_fact_archive;
    INSERT INTO tuju_dw.special_room_occupancy_fact_archive
        SELECT * FROM tuju_dw.special_room_occupancy_fact;

END$$
DELIMITER ;

/* View Tables */

/* View table to see the total count of all hotel rooms per type*/
DROP VIEW IF EXISTS hotel_room_type_count;
CREATE VIEW hotel_room_type_count AS
    SELECT
      hotel_room.hotelRoomTypeID,
      COUNT(*)
    FROM
      tuju_database.hotel_room
    GROUP BY
      hotel_room.hotelRoomTypeID;

/* View table to see the total count of all special rooms per type*/
DROP VIEW IF EXISTS special_room_type_count;
CREATE VIEW special_room_type_count AS
    SELECT
      special_room.specialRoomTypeID,
      COUNT(*)
    FROM
      tuju_database.special_room
    GROUP BY
      special_room.specialRoomTypeID;

/* View table to see the total occupied hotel rooms today per outlet*/
DROP VIEW IF EXISTS occupied_hotel_rooms_count;
CREATE VIEW occupied_hotel_rooms_count AS
    SELECT
      outlet.outletID,
      outlet.outletName,
      COUNT(*)
      FROM
        tuju_database.hotel_room
      INNER JOIN
        tuju_database.hotel_room_type USING (hotelRoomTypeID)
      INNER JOIN
        tuju_database.outlet USING (outletID)
      WHERE
        hotel_room.roomStatus <> 'vacant'
      GROUP BY
        outlet.outletID;



