-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2021 at 02:44 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `setstats`
--

-- --------------------------------------------------------

--
-- Table structure for table `current_lift`
--

DROP TABLE IF EXISTS `current_lift`;
CREATE TABLE `current_lift` (
  `lift_id` int(50) NOT NULL,
  `session_id` int(50) NOT NULL,
  `xy` geometry NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `current_lift`
--

INSERT INTO `current_lift` (`lift_id`, `session_id`, `xy`) VALUES
(1, 1, 0x000000000102000000080000000000000000000000000000000000f03f000000000000e0bf0000000000000040333333333333e3bf0000000000000840666666666666e6bf0000000000001040333333333333e3bf0000000000001440cdccccccccccdcbf00000000000018409a9999999999c9bf0000000000001c4000000000000000000000000000002040),
(2, 1, 0x000000000102000000080000000000000000000000000000000000f03f000000000000e0bf0000000000000040333333333333e3bf0000000000000840666666666666e6bf0000000000001040333333333333e3bf0000000000001440cdccccccccccdcbf00000000000018409a9999999999c9bf0000000000001c4000000000000000000000000000002040),
(3, 1, 0x000000000102000000080000000000000000000000000000000000f03f000000000000e0bf0000000000000040333333333333e3bf0000000000000840666666666666e6bf0000000000001040333333333333e3bf0000000000001440cdccccccccccdcbf00000000000018409a9999999999c9bf0000000000001c4000000000000000000000000000002040);

-- --------------------------------------------------------

--
-- Table structure for table `current_session`
--

DROP TABLE IF EXISTS `current_session`;
CREATE TABLE `current_session` (
  `session_id` int(50) NOT NULL,
  `trainee_id` int(50) NOT NULL,
  `rep_num` int(50) NOT NULL,
  `set_num` int(50) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `current_session`
--

INSERT INTO `current_session` (`session_id`, `trainee_id`, `rep_num`, `set_num`, `time`, `date`) VALUES
(1, 1, 3, 2, '18:11:00', '2021-11-03');

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `trainee_id` int(50) NOT NULL,
  `session_id` int(50) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`trainee_id`, `session_id`, `date`) VALUES
(1, 1, '2021-11-01'),
(1, 2, '2021-11-04'),
(2, 1, '2021-11-15');

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `session_id` int(50) NOT NULL,
  `best_xy` geometry NOT NULL,
  `worst_xy` geometry NOT NULL,
  `time` time(6) NOT NULL,
  `rep_num` int(50) NOT NULL,
  `set_num` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `trainee`
--

DROP TABLE IF EXISTS `trainee`;
CREATE TABLE `trainee` (
  `trainee_id` int(50) NOT NULL,
  `trainer_id` int(50) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trainee`
--

INSERT INTO `trainee` (`trainee_id`, `trainer_id`, `username`, `password`) VALUES
(1, 1, 'Trainee1', 'password1'),
(2, 2, 'Trainee2', 'password2');

-- --------------------------------------------------------

--
-- Table structure for table `trainer`
--

DROP TABLE IF EXISTS `trainer`;
CREATE TABLE `trainer` (
  `trainer_id` int(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trainer`
--

INSERT INTO `trainer` (`trainer_id`, `username`, `password`, `email`) VALUES
(1, 'Trainer1', 'password1', 'trainer1@gmail.com'),
(2, 'Trainer2', 'password2', 'trainer2@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `current_lift`
--
ALTER TABLE `current_lift`
  ADD PRIMARY KEY (`lift_id`),
  ADD KEY `foreign` (`session_id`);

--
-- Indexes for table `current_session`
--
ALTER TABLE `current_session`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `Foreign` (`trainee_id`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD KEY `session_id` (`session_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `trainee`
--
ALTER TABLE `trainee`
  ADD PRIMARY KEY (`trainee_id`),
  ADD KEY `trainer_id` (`trainer_id`);

--
-- Indexes for table `trainer`
--
ALTER TABLE `trainer`
  ADD PRIMARY KEY (`trainer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `current_lift`
--
ALTER TABLE `current_lift`
  MODIFY `lift_id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `current_session`
--
ALTER TABLE `current_session`
  MODIFY `session_id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `session`
--
ALTER TABLE `session`
  MODIFY `session_id` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trainee`
--
ALTER TABLE `trainee`
  MODIFY `trainee_id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `trainer`
--
ALTER TABLE `trainer`
  MODIFY `trainer_id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `current_lift`
--
ALTER TABLE `current_lift`
  ADD CONSTRAINT `current_lift_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `current_session` (`session_id`) ON DELETE CASCADE;

--
-- Constraints for table `current_session`
--
ALTER TABLE `current_session`
  ADD CONSTRAINT `current_session_ibfk_1` FOREIGN KEY (`trainee_id`) REFERENCES `trainee` (`trainee_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`trainee_id`) REFERENCES `trainee` (`trainee_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `session_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `history` (`session_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `trainee`
--
ALTER TABLE `trainee`
  ADD CONSTRAINT `trainee_ibfk_1` FOREIGN KEY (`trainee_id`) REFERENCES `trainer` (`trainer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
