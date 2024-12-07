-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 14, 2024 at 12:32 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tuju_database`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `newCustomerRegistration` (IN `customerName` VARCHAR(100), IN `phoneNumber` VARCHAR(16), IN `emailAddress` VARCHAR(100), IN `userName` VARCHAR(50), IN `password` VARCHAR(100))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_available_hotel_rooms` (IN `thisOutletID` INT, IN `checkInDate` DATE, IN `checkOutDate` DATE)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_available_special_rooms` (IN `thisOutletID` INT, IN `thisDate` DATE)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateHotelGuestInfo` (IN `p_reservationID` INT, IN `p_hotelRoomBookedID` INT, IN `newGuestName` VARCHAR(100), IN `newPhoneNumber` VARCHAR(16))   BEGIN
    UPDATE hotel_room_booked
    SET
        guestName = newGuestName,
        phoneNumber = newPhoneNumber
    WHERE
        reservationID = p_reservationID
        AND hotelRoomBookedID = p_hotelRoomBookedID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateReservationAndInsertPayment` (IN `status` ENUM('cart','pending','complete'), IN `paymentTypeID` VARCHAR(255), IN `thisReservationID` INT, IN `totalPaid` DOUBLE)   BEGIN
  -- Update existing data
  UPDATE reservation SET reservationStatus = status WHERE reservationID = thisReservationID;

  -- Insert new data
  INSERT INTO payment(reservationID, paymentTypeID, totalPaid) VALUES (reservationID, paymentTypeID, totalPaid);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateReservationPending` (IN `p_reservationID` INT, IN `p_status` ENUM('cart','pending','complete'))   BEGIN
    UPDATE Reservation
    SET
        reservationStatus = p_status
    WHERE
        reservationID = p_reservationID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSpecialGuestInfo` (IN `reservationID` INT, IN `specialRoomBookedID` INT, IN `newGuestName` VARCHAR(100), IN `newPhoneNumber` VARCHAR(16))   BEGIN
    UPDATE special_room_booked
    SET
        guestName = newGuestName,
        phoneNumber = newPhoneNumber
    WHERE
        reservationID = reservationID
        AND specialRoomBookedID = specialRoomBookedID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerID` int(11) NOT NULL,
  `customerName` varchar(100) NOT NULL,
  `phoneNumber` varchar(16) NOT NULL,
  `emailAddress` varchar(100) NOT NULL,
  `userName` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerID`, `customerName`, `phoneNumber`, `emailAddress`, `userName`, `password`) VALUES
(1, 'Syahluna A', '098765432', 'syahluna@gmail.com', 'loona', '1234'),
(2, 'catherine', '+628373829', 'catherine@gmail.com', 'cath', '12345');

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `update_customer_dimension_after_insert` AFTER INSERT ON `customer` FOR EACH ROW BEGIN

    INSERT INTO tuju_dw.customer_dimension (customerID, customerName, phoneNumber, emailAddress, userName, password)
    VALUES (NEW.customerID, NEW.customerName, NEW.phoneNumber, NEW.emailAddress, NEW.userName, NEW.password);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_customer_dimension_after_update` AFTER UPDATE ON `customer` FOR EACH ROW BEGIN

    UPDATE tuju_dw.customer_dimension
        SET tuju_dw.customer_dimension.customerName = NEW.customerName,
            tuju_dw.customer_dimension.phoneNumber = NEW.phoneNumber,
            tuju_dw.customer_dimension.emailAddress = NEW.emailAddress,
            tuju_dw.customer_dimension.userName = NEW.userName,
            tuju_dw.customer_dimension.password = NEW.password
        WHERE tuju_dw.customer_dimension.customerID = NEW.customerID;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

CREATE TABLE `facility` (
  `facilityID` int(11) NOT NULL,
  `facilityName` varchar(50) NOT NULL,
  `facilityDetails` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hotel_room`
--

CREATE TABLE `hotel_room` (
  `hotelRoomID` int(11) NOT NULL,
  `roomNumber` int(50) NOT NULL,
  `hotelRoomTypeID` int(11) NOT NULL,
  `roomStatus` enum('occupied','vacant') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_room`
--

INSERT INTO `hotel_room` (`hotelRoomID`, `roomNumber`, `hotelRoomTypeID`, `roomStatus`) VALUES
(1, 1, 1, 'occupied'),
(2, 2, 1, 'occupied'),
(3, 3, 1, 'occupied'),
(4, 4, 1, 'occupied'),
(5, 5, 1, 'occupied'),
(6, 6, 1, 'vacant'),
(7, 7, 2, 'vacant'),
(8, 8, 2, 'vacant'),
(9, 9, 2, 'vacant'),
(10, 10, 2, 'vacant'),
(11, 11, 2, 'vacant'),
(12, 12, 2, 'vacant'),
(13, 13, 3, 'vacant'),
(14, 14, 3, 'vacant'),
(15, 15, 3, 'vacant'),
(16, 16, 3, 'vacant'),
(17, 17, 3, 'vacant'),
(18, 18, 3, 'vacant'),
(20, 1, 4, 'occupied'),
(21, 2, 4, 'occupied'),
(22, 3, 4, 'occupied'),
(23, 4, 4, 'vacant'),
(24, 5, 4, 'vacant'),
(25, 6, 4, 'vacant'),
(26, 7, 4, 'vacant'),
(27, 8, 4, 'vacant'),
(28, 9, 4, 'vacant'),
(29, 10, 4, 'vacant'),
(30, 11, 4, 'vacant'),
(31, 12, 5, 'vacant'),
(32, 13, 5, 'vacant'),
(33, 14, 5, 'vacant'),
(34, 15, 5, 'vacant'),
(35, 16, 5, 'vacant'),
(36, 17, 5, 'vacant'),
(37, 18, 5, 'vacant'),
(38, 19, 5, 'vacant'),
(39, 20, 5, 'vacant'),
(40, 21, 5, 'vacant'),
(41, 22, 5, 'vacant'),
(42, 23, 6, 'vacant'),
(43, 24, 6, 'vacant'),
(44, 25, 6, 'vacant'),
(45, 26, 6, 'vacant'),
(46, 27, 6, 'vacant'),
(47, 28, 6, 'vacant'),
(48, 29, 6, 'vacant'),
(49, 30, 6, 'vacant'),
(50, 31, 6, 'vacant'),
(51, 32, 6, 'vacant'),
(52, 33, 6, 'vacant'),
(53, 1, 7, 'vacant'),
(54, 2, 7, 'vacant'),
(55, 3, 7, 'vacant'),
(56, 4, 7, 'vacant'),
(57, 5, 7, 'vacant'),
(58, 6, 7, 'vacant'),
(59, 7, 8, 'vacant'),
(60, 8, 8, 'vacant'),
(61, 9, 8, 'vacant'),
(62, 10, 8, 'vacant'),
(63, 11, 8, 'vacant'),
(64, 12, 8, 'vacant');

-- --------------------------------------------------------

--
-- Table structure for table `hotel_room_booked`
--

CREATE TABLE `hotel_room_booked` (
  `hotelRoomBookedID` int(11) NOT NULL,
  `reservationID` int(11) NOT NULL,
  `hotelRoomID` int(11) NOT NULL,
  `checkInDate` date NOT NULL,
  `checkOutDate` date NOT NULL,
  `guestName` varchar(100) NOT NULL,
  `phoneNumber` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_room_booked`
--

INSERT INTO `hotel_room_booked` (`hotelRoomBookedID`, `reservationID`, `hotelRoomID`, `checkInDate`, `checkOutDate`, `guestName`, `phoneNumber`) VALUES
(1, 2, 2, '2024-01-01', '2024-01-31', 'ajhe ray', '+62123456'),
(2, 2, 1, '2024-01-01', '2024-01-31', 'ojo', '123');

-- --------------------------------------------------------

--
-- Table structure for table `hotel_room_facility`
--

CREATE TABLE `hotel_room_facility` (
  `hotelRoomTypeID` int(11) NOT NULL,
  `facilityID` int(11) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hotel_room_occupied`
--

CREATE TABLE `hotel_room_occupied` (
  `hotelRoomID` int(11) NOT NULL,
  `dateOccupied` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_room_occupied`
--

INSERT INTO `hotel_room_occupied` (`hotelRoomID`, `dateOccupied`) VALUES
(1, '2024-01-01'),
(1, '2024-01-02'),
(1, '2024-01-03'),
(1, '2024-01-04'),
(1, '2024-01-05'),
(1, '2024-01-06'),
(1, '2024-01-07'),
(1, '2024-01-08'),
(1, '2024-01-09'),
(1, '2024-01-10'),
(1, '2024-01-11'),
(1, '2024-01-12'),
(1, '2024-01-13'),
(1, '2024-01-14'),
(1, '2024-01-15'),
(1, '2024-01-16'),
(1, '2024-01-17'),
(1, '2024-01-18'),
(1, '2024-01-19'),
(1, '2024-01-20'),
(1, '2024-01-21'),
(1, '2024-01-22'),
(1, '2024-01-23'),
(1, '2024-01-24'),
(1, '2024-01-25'),
(1, '2024-01-26'),
(1, '2024-01-27'),
(1, '2024-01-28'),
(1, '2024-01-29'),
(1, '2024-01-30'),
(2, '2024-01-01'),
(2, '2024-01-02'),
(2, '2024-01-03'),
(2, '2024-01-04'),
(2, '2024-01-05'),
(2, '2024-01-06'),
(2, '2024-01-07'),
(2, '2024-01-08'),
(2, '2024-01-09'),
(2, '2024-01-10'),
(2, '2024-01-11'),
(2, '2024-01-12'),
(2, '2024-01-13'),
(2, '2024-01-14'),
(2, '2024-01-15'),
(2, '2024-01-16'),
(2, '2024-01-17'),
(2, '2024-01-18'),
(2, '2024-01-19'),
(2, '2024-01-20'),
(2, '2024-01-21'),
(2, '2024-01-22'),
(2, '2024-01-23'),
(2, '2024-01-24'),
(2, '2024-01-25'),
(2, '2024-01-26'),
(2, '2024-01-27'),
(2, '2024-01-28'),
(2, '2024-01-29'),
(2, '2024-01-30');

-- --------------------------------------------------------

--
-- Table structure for table `hotel_room_type`
--

CREATE TABLE `hotel_room_type` (
  `hotelRoomTypeID` int(11) NOT NULL,
  `hotelRoomTypeName` varchar(50) NOT NULL,
  `maxOccupancy` int(11) NOT NULL,
  `roomPrice` double NOT NULL,
  `breakfastIncluded` tinyint(1) NOT NULL,
  `outletID` int(11) NOT NULL,
  `roomImage` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_room_type`
--

INSERT INTO `hotel_room_type` (`hotelRoomTypeID`, `hotelRoomTypeName`, `maxOccupancy`, `roomPrice`, `breakfastIncluded`, `outletID`, `roomImage`) VALUES
(1, 'Standard', 2, 190000, 0, 1, ''),
(2, 'Superior', 2, 200000, 0, 1, ''),
(3, 'Triple Studio', 3, 520000, 0, 1, ''),
(4, 'Superior Single', 1, 180000, 0, 2, ''),
(5, 'Superior Double', 2, 205000, 0, 2, ''),
(6, 'Deluxe Double', 2, 230000, 0, 2, ''),
(7, 'Male Capsule', 1, 160000, 0, 3, ''),
(8, 'Female Capsule', 1, 160000, 0, 3, '');

--
-- Triggers `hotel_room_type`
--
DELIMITER $$
CREATE TRIGGER `hotel_room_price_change_fact_on_insert` AFTER INSERT ON `hotel_room_type` FOR EACH ROW BEGIN
    INSERT INTO tuju_dw.hotel_room_price_change_fact(timecode, hotelRoomTypeID, outletID, updatedPrice)
    VALUES(DATE_FORMAT(NOW(), "%Y%m%d"), new.hotelRoomTypeID, new.outletID, new.roomPrice);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hotel_room_price_change_fact_on_update` AFTER UPDATE ON `hotel_room_type` FOR EACH ROW BEGIN
    IF OLD.roomPrice <> new.roomPrice THEN

    INSERT INTO tuju_dw.hotel_room_price_change_fact(timecode, hotelRoomTypeID, outletID, updatedPrice)
    VALUES(DATE_FORMAT(NOW(), "%Y%m%d"), new.hotelRoomTypeID, new.outletID, new.roomPrice);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_hotel_room_type_dimension_after_insert` AFTER INSERT ON `hotel_room_type` FOR EACH ROW BEGIN

    INSERT INTO tuju_dw.hotel_room_type_dimension (hotelRoomTypeID, hotelRoomTypeName, maxOccupancy, roomPrice, breakfastIncluded, outletID, roomImage)
    VALUES (NEW.hotelRoomTypeID, NEW.hotelRoomTypeName, NEW.maxOccupancy, NEW.roomPrice, NEW.breakfastIncluded, NEW.outletID, NEW.roomImage);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_hotel_room_type_dimension_after_update` AFTER UPDATE ON `hotel_room_type` FOR EACH ROW BEGIN

    UPDATE tuju_dw.hotel_room_type_dimension
        SET tuju_dw.hotel_room_type_dimension.hotelRoomTypeName = NEW.hotelRoomTypeName,
            tuju_dw.hotel_room_type_dimension.maxOccupancy = NEW.maxOccupancy,
            tuju_dw.hotel_room_type_dimension.roomPrice = NEW.roomPrice,
            tuju_dw.hotel_room_type_dimension.breakfastIncluded = NEW.breakfastIncluded,
            tuju_dw.hotel_room_type_dimension.outletID = NEW.outletID,
            tuju_dw.hotel_room_type_dimension.roomImage = NEW.roomImage
        WHERE tuju_dw.hotel_room_type_dimension.hotelRoomTypeID = NEW.hotelRoomTypeID;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `hotel_room_type_count`
-- (See below for the actual view)
--
CREATE TABLE `hotel_room_type_count` (
`hotelRoomTypeID` int(11)
,`COUNT(*)` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `occupied_hotel_rooms_count`
-- (See below for the actual view)
--
CREATE TABLE `occupied_hotel_rooms_count` (
`outletID` int(11)
,`outletName` varchar(50)
,`COUNT(*)` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `occupied_special_rooms_count`
-- (See below for the actual view)
--
CREATE TABLE `occupied_special_rooms_count` (
`outletID` int(11)
,`outletName` varchar(50)
,`COUNT(*)` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `outlet`
--

CREATE TABLE `outlet` (
  `outletID` int(11) NOT NULL,
  `outletName` varchar(50) NOT NULL,
  `outletPhoneNumber` varchar(16) NOT NULL,
  `location` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outlet`
--

INSERT INTO `outlet` (`outletID`, `outletName`, `outletPhoneNumber`, `location`) VALUES
(1, 'Wijaya Kusuma Homes Syariah', '+629374629103', 'Jl. Wijaya Kusuma No.10, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Jakarta, Indonesia 12430'),
(2, 'Abuserin Syariah', '+627183746233', 'Jl. Abuserin No. 11, Kel. Gandaria Selatan, Kec. Cilandak, , Kebayoran Baru, Gandaria, Jakarta, Indonesia, 12420'),
(3, 'Arteri Pods', '+6212345678876', 'Jl. Iskandar Muda (Arteri Pondok Indah) No. 75B, Kel. Kebayoran Lama Selatan, Kec. Kebayoran Lama, Kota Jakarta Selatan, Jakarta, Indonesia 12240');

--
-- Triggers `outlet`
--
DELIMITER $$
CREATE TRIGGER `update_outlet_dimension_after_insert` AFTER INSERT ON `outlet` FOR EACH ROW BEGIN

    INSERT INTO tuju_dw.outlet_dimension(outletID, outletName, outletPhoneNumber, location)
    VALUES (NEW.outletID, NEW.outletName, NEW.outletPhoneNumber, NEW.location);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_outlet_dimension_after_update` AFTER UPDATE ON `outlet` FOR EACH ROW BEGIN

    UPDATE tuju_dw.outlet_dimension
        SET tuju_dw.outlet_dimension.outletName = NEW.outletName,
            tuju_dw.outlet_dimension.outletPhoneNumber = NEW.outletPhoneNumber,
            tuju_dw.outlet_dimension.location = NEW.location
        WHERE tuju_dw.outlet_dimension.outletID = NEW.outletID;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `paymentID` int(11) NOT NULL,
  `reservationID` int(11) NOT NULL,
  `paymentTypeID` int(11) NOT NULL,
  `totalPaid` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`paymentID`, `reservationID`, `paymentTypeID`, `totalPaid`) VALUES
(1, 1, 1, 100000),
(3, 1, 1, 100000),
(4, 1, 2, 200000);

--
-- Triggers `payment`
--
DELIMITER $$
CREATE TRIGGER `customer_payments_fact_on_insert` AFTER INSERT ON `payment` FOR EACH ROW BEGIN
    DECLARE thisCustomerID INT;

    SET thisCustomerID = (SELECT customerID FROM tuju_database.reservation
                                            WHERE tuju_database.reservation.reservationID = new.reservationID);
    
    INSERT INTO tuju_dw.customer_payments_fact(timecode, customerID, paymentTypeID, totalPaid)
    VALUES(DATE_FORMAT(NOW(), "%Y%m%d"), thisCustomerID, new.paymentTypeID, new.totalPaid);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payment_type`
--

CREATE TABLE `payment_type` (
  `paymentTypeID` int(11) NOT NULL,
  `typeName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_type`
--

INSERT INTO `payment_type` (`paymentTypeID`, `typeName`) VALUES
(1, 'Visa'),
(2, 'Mastercard'),
(3, 'JCB'),
(4, 'Bank BCA'),
(5, 'Bank BNI'),
(6, 'Bank Mandiri'),
(7, 'Bank Permata'),
(8, 'GoPay'),
(9, 'GoPay Later'),
(10, 'QRIS');

--
-- Triggers `payment_type`
--
DELIMITER $$
CREATE TRIGGER `update_payment_type_dimension_after_insert` AFTER INSERT ON `payment_type` FOR EACH ROW BEGIN

    INSERT INTO tuju_dw.payment_type_dimension(paymentTypeID, typeName)
    VALUES (NEW.paymentTypeID, NEW.typeName);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_payment_type_dimension_after_update` AFTER UPDATE ON `payment_type` FOR EACH ROW BEGIN
    UPDATE tuju_dw.payment_type_dimension
        SET tuju_dw.payment_type_dimension.typeName = NEW.typeName
        WHERE tuju_dw.payment_type_dimension.paymentTypeID = NEW.paymentTypeID;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `reservationID` int(11) NOT NULL,
  `totalPrice` double NOT NULL,
  `reservationDateTime` datetime NOT NULL,
  `customerID` int(11) NOT NULL,
  `reservationStatus` enum('cart','pending','complete') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`reservationID`, `totalPrice`, `reservationDateTime`, `customerID`, `reservationStatus`) VALUES
(1, 100000, '2023-12-25 11:49:41', 1, 'complete'),
(2, 100000, '2023-12-27 16:43:54', 2, 'complete');

--
-- Triggers `reservation`
--
DELIMITER $$
CREATE TRIGGER `insert_into_hotel_room_occupied` AFTER UPDATE ON `reservation` FOR EACH ROW BEGIN
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
            WHILE currentDate < (SELECT thisCheckOutDate FROM temp_table WHERE rowNumber = currentRow)
            DO
                INSERT INTO hotel_room_occupied(hotelRoomID, dateOccupied)
                VALUES (currentHotelRoomID, currentDate);

                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 day);
            END WHILE;

            SET currentRow = (currentRow + 1);
        END WHILE;

        DROP TEMPORARY TABLE IF EXISTS temp_table;

    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_into_special_room_occupied` AFTER UPDATE ON `reservation` FOR EACH ROW BEGIN
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
        INNER JOIN
            special_room s USING (specialRoomID)
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `special_room`
--

CREATE TABLE `special_room` (
  `specialRoomID` int(11) NOT NULL,
  `specialRoomNumber` int(11) NOT NULL,
  `specialRoomTypeID` int(11) NOT NULL,
  `roomStatus` enum('occupied','vacant') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `special_room`
--

INSERT INTO `special_room` (`specialRoomID`, `specialRoomNumber`, `specialRoomTypeID`, `roomStatus`) VALUES
(3, 1, 10, 'occupied'),
(4, 2, 11, 'occupied'),
(5, 3, 7, 'occupied'),
(6, 4, 7, 'vacant'),
(7, 5, 7, 'vacant'),
(8, 6, 7, 'vacant'),
(9, 7, 7, 'vacant'),
(10, 8, 8, 'vacant'),
(11, 9, 8, 'vacant'),
(12, 10, 8, 'vacant'),
(13, 11, 8, 'vacant'),
(14, 12, 8, 'vacant'),
(15, 13, 9, 'vacant'),
(16, 14, 9, 'vacant'),
(17, 15, 9, 'vacant'),
(18, 16, 9, 'vacant'),
(19, 17, 9, 'vacant'),
(20, 18, 12, 'occupied'),
(21, 1, 13, 'occupied'),
(22, 2, 14, 'occupied'),
(23, 3, 15, 'occupied'),
(24, 4, 17, 'vacant'),
(25, 5, 17, 'vacant'),
(26, 6, 17, 'vacant'),
(27, 7, 17, 'vacant'),
(28, 8, 17, 'vacant'),
(29, 9, 18, 'vacant'),
(30, 10, 18, 'vacant'),
(31, 11, 18, 'vacant'),
(32, 12, 18, 'vacant'),
(33, 13, 18, 'vacant'),
(34, 14, 19, 'vacant'),
(35, 15, 19, 'vacant'),
(36, 16, 19, 'vacant'),
(37, 17, 19, 'vacant'),
(38, 18, 19, 'vacant'),
(39, 19, 16, 'vacant');

-- --------------------------------------------------------

--
-- Table structure for table `special_room_booked`
--

CREATE TABLE `special_room_booked` (
  `specialRoomBookedID` int(11) NOT NULL,
  `reservationID` int(11) NOT NULL,
  `specialRoomID` int(11) NOT NULL,
  `dateBooked` date NOT NULL,
  `guestName` varchar(50) NOT NULL,
  `phoneNumber` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `special_room_booked`
--

INSERT INTO `special_room_booked` (`specialRoomBookedID`, `reservationID`, `specialRoomID`, `dateBooked`, `guestName`, `phoneNumber`) VALUES
(1, 2, 26, '2023-12-29', 'ajhe ray', '+62123456'),
(2, 2, 3, '2024-01-01', 'ajhe', '123');

-- --------------------------------------------------------

--
-- Table structure for table `special_room_facility`
--

CREATE TABLE `special_room_facility` (
  `specialRoomTypeID` int(11) NOT NULL,
  `facilityID` int(11) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `special_room_occupied`
--

CREATE TABLE `special_room_occupied` (
  `specialRoomID` int(11) NOT NULL,
  `dateOccupied` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `special_room_occupied`
--

INSERT INTO `special_room_occupied` (`specialRoomID`, `dateOccupied`) VALUES
(3, '2024-01-01'),
(3, '2024-01-02'),
(3, '2024-01-03'),
(3, '2024-01-04'),
(3, '2024-01-05'),
(3, '2024-01-06'),
(3, '2024-01-07'),
(3, '2024-01-08'),
(3, '2024-01-09'),
(3, '2024-01-10'),
(3, '2024-01-11'),
(3, '2024-01-12'),
(3, '2024-01-13'),
(3, '2024-01-14'),
(3, '2024-01-15'),
(3, '2024-01-16'),
(3, '2024-01-17'),
(3, '2024-01-18'),
(3, '2024-01-19'),
(3, '2024-01-20'),
(3, '2024-01-21'),
(3, '2024-01-22'),
(3, '2024-01-23'),
(3, '2024-01-24'),
(3, '2024-01-25'),
(3, '2024-01-26'),
(3, '2024-01-27'),
(3, '2024-01-28'),
(3, '2024-01-29'),
(3, '2024-01-30'),
(26, '2023-12-29');

-- --------------------------------------------------------

--
-- Table structure for table `special_room_type`
--

CREATE TABLE `special_room_type` (
  `specialRoomTypeID` int(10) NOT NULL,
  `specialRoomTypeName` varchar(50) NOT NULL,
  `capacity` int(10) NOT NULL,
  `price` double NOT NULL,
  `priceType` enum('day','month','year') NOT NULL,
  `serviceCharge` double NOT NULL,
  `fnbincluded` tinyint(1) DEFAULT NULL,
  `outletID` int(10) NOT NULL,
  `roomImage` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `special_room_type`
--

INSERT INTO `special_room_type` (`specialRoomTypeID`, `specialRoomTypeName`, `capacity`, `price`, `priceType`, `serviceCharge`, `fnbincluded`, `outletID`, `roomImage`) VALUES
(7, 'Dedicated Desk', 1, 140000, 'day', 0, 1, 2, ''),
(8, 'Individual Pods', 1, 140000, 'day', 0, 1, 2, ''),
(9, 'Individual Space', 1, 145000, 'day', 0, 1, 2, ''),
(10, 'Meeting Room', 8, 4200000, 'month', 0, 0, 2, ''),
(11, 'Meeting Pods', 6, 3200000, 'month', 0, 0, 2, ''),
(12, 'Small Private Event', 20, 4300000, 'day', 0, 1, 2, ''),
(13, 'Service Office (2-4 Pax)', 4, 2500000, 'month', 250000, 0, 3, ''),
(14, 'Service Office (4-6 Pax)', 6, 4000000, 'month', 300000, 0, 3, ''),
(15, 'Service Room (8-12 Pax)', 12, 6000000, 'month', 300000, 0, 3, ''),
(16, 'Meeting Pods', 4, 300000, 'month', 0, 0, 3, ''),
(17, 'Dedicated Desk', 1, 150000, 'day', 0, 0, 3, ''),
(18, 'Individual Pods', 1, 85000, 'day', 0, 0, 3, ''),
(19, 'Individual Space', 1, 85000, 'day', 0, 0, 3, '');

--
-- Triggers `special_room_type`
--
DELIMITER $$
CREATE TRIGGER `special_room_price_change_fact_on_insert` AFTER INSERT ON `special_room_type` FOR EACH ROW BEGIN
    INSERT INTO tuju_dw.special_room_price_change_fact(timecode, specialRoomTypeID, outletID, updatedPrice)
    VALUES(DATE_FORMAT(NOW(), "%Y%m%d"), new.specialRoomTypeID, new.outletID, new.price);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `special_room_price_change_fact_on_update` AFTER UPDATE ON `special_room_type` FOR EACH ROW BEGIN
    IF OLD.price <> new.price THEN

    INSERT INTO tuju_dw.special_room_price_change_fact(timecode, specialRoomTypeID, outletID, updatedPrice)
    VALUES(DATE_FORMAT(NOW(), "%Y%m%d"), new.specialRoomTypeID, new.outletID, new.price);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_special_room_type_dimension_after_insert` AFTER INSERT ON `special_room_type` FOR EACH ROW BEGIN

    INSERT INTO tuju_dw.special_room_type_dimension(specialRoomTypeID, specialRoomTypeName, capacity, price, priceType, serviceCharge, fnbincluded, outletID, roomImage)
    VALUES (NEW.specialRoomTypeID, NEW.specialRoomTypeName, NEW.capacity, NEW.price, NEW.priceType, NEW.serviceCharge, NEW.fnbincluded, NEW.outletID, NEW.roomImage);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_special_room_type_dimension_after_update` AFTER UPDATE ON `special_room_type` FOR EACH ROW BEGIN

    UPDATE tuju_dw.special_room_type_dimension
        SET
            tuju_dw.special_room_type_dimension.specialRoomTypeName = NEW.specialRoomTypeName,
            tuju_dw.special_room_type_dimension.capacity = NEW.capacity,
            tuju_dw.special_room_type_dimension.price = NEW.price,
            tuju_dw.special_room_type_dimension.priceType = NEW.priceType,
            tuju_dw.special_room_type_dimension.serviceCharge = NEW.serviceCharge,
            tuju_dw.special_room_type_dimension.fnbincluded = NEW.fnbincluded,
            tuju_dw.special_room_type_dimension.outletID = NEW.outletID,
            tuju_dw.special_room_type_dimension.roomImage = NEW.roomImage
        WHERE tuju_dw.special_room_type_dimension.specialRoomTypeID = NEW.specialRoomTypeID;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `special_room_type_count`
-- (See below for the actual view)
--
CREATE TABLE `special_room_type_count` (
`specialRoomTypeID` int(11)
,`COUNT(*)` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `hotel_room_type_count`
--
DROP TABLE IF EXISTS `hotel_room_type_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hotel_room_type_count`  AS SELECT `hotel_room`.`hotelRoomTypeID` AS `hotelRoomTypeID`, count(0) AS `COUNT(*)` FROM `hotel_room` GROUP BY `hotel_room`.`hotelRoomTypeID` ;

-- --------------------------------------------------------

--
-- Structure for view `occupied_hotel_rooms_count`
--
DROP TABLE IF EXISTS `occupied_hotel_rooms_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `occupied_hotel_rooms_count`  AS SELECT `outlet`.`outletID` AS `outletID`, `outlet`.`outletName` AS `outletName`, count(0) AS `COUNT(*)` FROM ((`hotel_room` join `hotel_room_type` on(`hotel_room`.`hotelRoomTypeID` = `hotel_room_type`.`hotelRoomTypeID`)) join `outlet` on(`hotel_room_type`.`outletID` = `outlet`.`outletID`)) WHERE `hotel_room`.`roomStatus` <> 'vacant' GROUP BY `outlet`.`outletID` ;

-- --------------------------------------------------------

--
-- Structure for view `occupied_special_rooms_count`
--
DROP TABLE IF EXISTS `occupied_special_rooms_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `occupied_special_rooms_count`  AS SELECT `outlet`.`outletID` AS `outletID`, `outlet`.`outletName` AS `outletName`, count(0) AS `COUNT(*)` FROM ((`special_room` join `special_room_type` on(`special_room`.`specialRoomTypeID` = `special_room_type`.`specialRoomTypeID`)) join `outlet` on(`special_room_type`.`outletID` = `outlet`.`outletID`)) WHERE `special_room`.`roomStatus` <> 'vacant' GROUP BY `outlet`.`outletID` ;

-- --------------------------------------------------------

--
-- Structure for view `special_room_type_count`
--
DROP TABLE IF EXISTS `special_room_type_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `special_room_type_count`  AS SELECT `special_room`.`specialRoomTypeID` AS `specialRoomTypeID`, count(0) AS `COUNT(*)` FROM `special_room` GROUP BY `special_room`.`specialRoomTypeID` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerID`);

--
-- Indexes for table `facility`
--
ALTER TABLE `facility`
  ADD PRIMARY KEY (`facilityID`);

--
-- Indexes for table `hotel_room`
--
ALTER TABLE `hotel_room`
  ADD PRIMARY KEY (`hotelRoomID`),
  ADD KEY `hotelRoomTypeID` (`hotelRoomTypeID`);

--
-- Indexes for table `hotel_room_booked`
--
ALTER TABLE `hotel_room_booked`
  ADD PRIMARY KEY (`hotelRoomBookedID`),
  ADD KEY `reservationID` (`reservationID`),
  ADD KEY `hotelRoomID` (`hotelRoomID`);

--
-- Indexes for table `hotel_room_facility`
--
ALTER TABLE `hotel_room_facility`
  ADD PRIMARY KEY (`hotelRoomTypeID`,`facilityID`),
  ADD KEY `FK_roomfacility_facilityID` (`facilityID`);

--
-- Indexes for table `hotel_room_occupied`
--
ALTER TABLE `hotel_room_occupied`
  ADD PRIMARY KEY (`hotelRoomID`,`dateOccupied`);

--
-- Indexes for table `hotel_room_type`
--
ALTER TABLE `hotel_room_type`
  ADD PRIMARY KEY (`hotelRoomTypeID`),
  ADD KEY `outletID` (`outletID`);

--
-- Indexes for table `outlet`
--
ALTER TABLE `outlet`
  ADD PRIMARY KEY (`outletID`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`paymentID`),
  ADD KEY `reservationID` (`reservationID`),
  ADD KEY `paymentTypeID` (`paymentTypeID`);

--
-- Indexes for table `payment_type`
--
ALTER TABLE `payment_type`
  ADD PRIMARY KEY (`paymentTypeID`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`reservationID`),
  ADD KEY `customerID` (`customerID`);

--
-- Indexes for table `special_room`
--
ALTER TABLE `special_room`
  ADD PRIMARY KEY (`specialRoomID`),
  ADD KEY `specialRoomTypeID` (`specialRoomTypeID`);

--
-- Indexes for table `special_room_booked`
--
ALTER TABLE `special_room_booked`
  ADD PRIMARY KEY (`specialRoomBookedID`),
  ADD KEY `reservationID` (`reservationID`),
  ADD KEY `specialRoomID` (`specialRoomID`);

--
-- Indexes for table `special_room_facility`
--
ALTER TABLE `special_room_facility`
  ADD PRIMARY KEY (`specialRoomTypeID`,`facilityID`),
  ADD KEY `FK_specialfacility_facilityID` (`facilityID`);

--
-- Indexes for table `special_room_occupied`
--
ALTER TABLE `special_room_occupied`
  ADD PRIMARY KEY (`specialRoomID`,`dateOccupied`);

--
-- Indexes for table `special_room_type`
--
ALTER TABLE `special_room_type`
  ADD PRIMARY KEY (`specialRoomTypeID`),
  ADD KEY `outletID` (`outletID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `facility`
--
ALTER TABLE `facility`
  MODIFY `facilityID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hotel_room`
--
ALTER TABLE `hotel_room`
  MODIFY `hotelRoomID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `hotel_room_booked`
--
ALTER TABLE `hotel_room_booked`
  MODIFY `hotelRoomBookedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hotel_room_type`
--
ALTER TABLE `hotel_room_type`
  MODIFY `hotelRoomTypeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `outlet`
--
ALTER TABLE `outlet`
  MODIFY `outletID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `paymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `payment_type`
--
ALTER TABLE `payment_type`
  MODIFY `paymentTypeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `reservationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `special_room`
--
ALTER TABLE `special_room`
  MODIFY `specialRoomID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `special_room_booked`
--
ALTER TABLE `special_room_booked`
  MODIFY `specialRoomBookedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `special_room_type`
--
ALTER TABLE `special_room_type`
  MODIFY `specialRoomTypeID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hotel_room`
--
ALTER TABLE `hotel_room`
  ADD CONSTRAINT `hotel_room_ibfk_1` FOREIGN KEY (`hotelRoomTypeID`) REFERENCES `hotel_room_type` (`hotelRoomTypeID`);

--
-- Constraints for table `hotel_room_booked`
--
ALTER TABLE `hotel_room_booked`
  ADD CONSTRAINT `hotel_room_booked_ibfk_1` FOREIGN KEY (`reservationID`) REFERENCES `reservation` (`reservationID`),
  ADD CONSTRAINT `hotel_room_booked_ibfk_2` FOREIGN KEY (`hotelRoomID`) REFERENCES `hotel_room` (`hotelRoomID`);

--
-- Constraints for table `hotel_room_facility`
--
ALTER TABLE `hotel_room_facility`
  ADD CONSTRAINT `FK_roomfacility_HotelRoomTypeID` FOREIGN KEY (`hotelRoomTypeID`) REFERENCES `hotel_room_type` (`hotelRoomTypeID`),
  ADD CONSTRAINT `FK_roomfacility_facilityID` FOREIGN KEY (`facilityID`) REFERENCES `facility` (`facilityID`),
  ADD CONSTRAINT `FK_roomfacility_roomTypeID` FOREIGN KEY (`hotelRoomTypeID`) REFERENCES `hotel_room_type` (`hotelRoomTypeID`);

--
-- Constraints for table `hotel_room_occupied`
--
ALTER TABLE `hotel_room_occupied`
  ADD CONSTRAINT `FK_hotelOccupied_hotelroomID` FOREIGN KEY (`hotelRoomID`) REFERENCES `hotel_room` (`hotelRoomID`);

--
-- Constraints for table `hotel_room_type`
--
ALTER TABLE `hotel_room_type`
  ADD CONSTRAINT `hotel_room_type_ibfk_1` FOREIGN KEY (`outletID`) REFERENCES `outlet` (`outletID`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`reservationID`) REFERENCES `reservation` (`reservationID`),
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`paymentTypeID`) REFERENCES `payment_type` (`paymentTypeID`);

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `special_room`
--
ALTER TABLE `special_room`
  ADD CONSTRAINT `special_room_ibfk_1` FOREIGN KEY (`specialRoomTypeID`) REFERENCES `special_room_type` (`specialRoomTypeID`);

--
-- Constraints for table `special_room_booked`
--
ALTER TABLE `special_room_booked`
  ADD CONSTRAINT `special_room_booked_ibfk_1` FOREIGN KEY (`reservationID`) REFERENCES `reservation` (`reservationID`),
  ADD CONSTRAINT `special_room_booked_ibfk_2` FOREIGN KEY (`specialRoomID`) REFERENCES `special_room` (`specialRoomID`);

--
-- Constraints for table `special_room_facility`
--
ALTER TABLE `special_room_facility`
  ADD CONSTRAINT `FK_specialfacility_facilityID` FOREIGN KEY (`facilityID`) REFERENCES `facility` (`facilityID`),
  ADD CONSTRAINT `FK_specialfacility_specialRoomTypeID` FOREIGN KEY (`specialRoomTypeID`) REFERENCES `special_room_type` (`specialRoomTypeID`);

--
-- Constraints for table `special_room_occupied`
--
ALTER TABLE `special_room_occupied`
  ADD CONSTRAINT `FK_specialOccupied_hotelroomID` FOREIGN KEY (`specialRoomID`) REFERENCES `special_room` (`specialRoomID`);

--
-- Constraints for table `special_room_type`
--
ALTER TABLE `special_room_type`
  ADD CONSTRAINT `special_room_type_ibfk_1` FOREIGN KEY (`outletID`) REFERENCES `outlet` (`outletID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
