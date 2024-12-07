-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 03, 2024 at 05:45 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
(1, 1, 1, 'vacant'),
(2, 2, 1, 'vacant'),
(3, 3, 1, 'vacant'),
(4, 4, 1, 'vacant'),
(5, 5, 1, 'vacant'),
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
(20, 1, 4, 'vacant'),
(21, 2, 4, 'vacant'),
(22, 3, 4, 'vacant'),
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
(1, 2, 46, '2023-12-29', '2023-12-30', 'ajhe ray', '+62123456');

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
(1, 'Standard', 2, 180000, 0, 1, ''),
(2, 'Superior', 2, 190000, 0, 1, ''),
(3, 'Triple Studio', 3, 515000, 0, 1, ''),
(4, 'Superior Single', 1, 180000, 0, 2, ''),
(5, 'Superior Double', 2, 205000, 0, 2, ''),
(6, 'Deluxe Double', 2, 225000, 0, 2, ''),
(7, 'Male Capsule', 1, 155000, 0, 3, ''),
(8, 'Female Capsule', 1, 155000, 0, 3, '');

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
(2, 2, 1, 100000),
(3, 1, 1, 100000),
(4, 1, 2, 200000);

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
(2, 100000, '2023-12-27 16:43:54', 2, 'pending');

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
(3, 1, 10, 'vacant'),
(4, 2, 11, 'vacant'),
(5, 3, 7, 'vacant'),
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
(20, 18, 12, 'vacant'),
(21, 1, 13, 'vacant'),
(22, 2, 14, 'vacant'),
(23, 3, 15, 'vacant'),
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
(1, 2, 26, '2023-12-29', 'ajhe ray', '+62123456');

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
(7, 'Dedicated Desk', 1, 135000, 'day', 0, 1, 2, ''),
(8, 'Individual Pods', 1, 135000, 'day', 0, 1, 2, ''),
(9, 'Individual Space', 1, 135000, 'day', 0, 1, 2, ''),
(10, 'Meeting Room', 8, 4000000, 'month', 0, 0, 2, ''),
(11, 'Meeting Pods', 6, 3000000, 'month', 0, 0, 2, ''),
(12, 'Small Private Event', 20, 4000000, 'day', 0, 1, 2, ''),
(13, 'Service Office (2-4 Pax)', 4, 2500000, 'month', 250000, 0, 3, ''),
(14, 'Service Office (4-6 Pax)', 6, 4000000, 'month', 300000, 0, 3, ''),
(15, 'Service Room (8-12 Pax)', 12, 6000000, 'month', 300000, 0, 3, ''),
(16, 'Meeting Pods', 4, 275000, 'month', 0, 0, 3, ''),
(17, 'Dedicated Desk', 1, 100000, 'day', 0, 0, 3, ''),
(18, 'Individual Pods', 1, 85000, 'day', 0, 0, 3, ''),
(19, 'Individual Space', 1, 85000, 'day', 0, 0, 3, '');

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
  MODIFY `paymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  MODIFY `specialRoomBookedID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
