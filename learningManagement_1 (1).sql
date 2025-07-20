-- MySQL dump 10.13  Distrib 8.0.42, for macos15 (x86_64)
--
-- Host: localhost    Database: learning_management
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Assignments`
--

DROP TABLE IF EXISTS `Assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `lecture_id` int DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `due_date` datetime NOT NULL,
  `status` varchar(100) DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `lecture_id` (`lecture_id`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`id`),
  CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`lecture_id`) REFERENCES `Lectures` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Assignments`
--

LOCK TABLES `Assignments` WRITE;
/*!40000 ALTER TABLE `Assignments` DISABLE KEYS */;
INSERT INTO `Assignments` VALUES (1,1,1,'Python Exercise 1','Write a simple Python script','2025-07-31 23:59:00','pending'),(2,2,2,'Java Exercise 1','Create a Java class','2025-07-31 23:59:00','pending'),(3,3,3,'C++ Exercise 1','Implement a C++ function','2025-07-31 23:59:00','pending'),(4,4,4,'JavaScript Exercise 1','Build a JS function','2025-07-31 23:59:00','pending'),(5,5,5,'Ruby Exercise 1','Create a Ruby model','2025-07-31 23:59:00','pending'),(6,6,6,'PHP Exercise 1','Write a PHP script','2025-07-31 23:59:00','pending'),(7,7,7,'Go Exercise 1','Code a Go program','2025-07-31 23:59:00','pending'),(8,8,8,'Swift Exercise 1','Develop a Swift app','2025-07-31 23:59:00','pending'),(9,9,9,'Kotlin Exercise 1','Create a Kotlin app','2025-07-31 23:59:00','pending'),(10,10,10,'Rust Exercise 1','Write a Rust program','2025-07-31 23:59:00','pending');
/*!40000 ALTER TABLE `Assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `teacher_id` int DEFAULT NULL,
  `image` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Courses`
--

LOCK TABLES `Courses` WRITE;
/*!40000 ALTER TABLE `Courses` DISABLE KEYS */;
INSERT INTO `Courses` VALUES (1,'Python Basics','Introduction to Python programming',2,'image/python.png'),(2,'Java Fundamentals','Core concepts of Java',4,'image/javaf.png'),(3,'C++ Programming','Advanced C++ techniques',5,'image/c.png'),(4,'JavaScript Essentials','Basics of JavaScript',13,'image/js.png'),(5,'Ruby on Rails','Web development with Ruby',17,'image/ra.png'),(6,'PHP Basics','Introduction to PHP',2,'image/php.png'),(7,'Go Programming','Learning Go language',4,'image/go.png'),(8,'Swift for iOS','iOS development with Swift',5,'image/swift.png'),(9,'Kotlin Basics','Introduction to Kotlin',13,'image/ko.png'),(10,'Rust Programming','Safe and concurrent Rust',17,'image/Rus.png'),(16,'Java Programming','a',4,'image/javaf.png');
/*!40000 ALTER TABLE `Courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Enrollments`
--

DROP TABLE IF EXISTS `Enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Enrollments` (
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`course_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `Users` (`id`),
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Enrollments`
--

LOCK TABLES `Enrollments` WRITE;
/*!40000 ALTER TABLE `Enrollments` DISABLE KEYS */;
/*!40000 ALTER TABLE `Enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Lectures`
--

DROP TABLE IF EXISTS `Lectures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lectures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `video_url` varchar(255) NOT NULL,
  `status` varchar(100) DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `lectures_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lectures`
--

LOCK TABLES `Lectures` WRITE;
/*!40000 ALTER TABLE `Lectures` DISABLE KEYS */;
INSERT INTO `Lectures` VALUES (1,1,'Introduction to Python','https://www.youtube.com/watch?v=python_intro','active'),(2,2,'Java Basics','https://www.youtube.com/watch?v=java_basics','active'),(3,3,'C++ Overview','https://www.youtube.com/watch?v=cpp_overview','active'),(4,4,'JavaScript Fundamentals','https://www.youtube.com/watch?v=js_fundamentals','active'),(5,5,'Ruby on Rails Intro','https://www.youtube.com/watch?v=ruby_intro','active'),(6,6,'PHP Basics','https://www.youtube.com/watch?v=php_basics','active'),(7,7,'Go Language Intro','https://www.youtube.com/watch?v=go_intro','active'),(8,8,'Swift for iOS','https://www.youtube.com/watch?v=swift_ios','active'),(9,9,'Kotlin Basics','https://www.youtube.com/watch?v=kotlin_basics','active'),(10,10,'Rust Programming Intro','https://www.youtube.com/watch?v=rust_intro','active');
/*!40000 ALTER TABLE `Lectures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Submissions`
--

DROP TABLE IF EXISTS `Submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assignment_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `submission_date` datetime DEFAULT NULL,
  `grade` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assignment_id` (`assignment_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `Assignments` (`id`),
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Submissions`
--

LOCK TABLES `Submissions` WRITE;
/*!40000 ALTER TABLE `Submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activity`
--

DROP TABLE IF EXISTS `user_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `login_time` datetime NOT NULL,
  `logout_time` datetime DEFAULT NULL,
  `duration_minutes` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity`
--

LOCK TABLES `user_activity` WRITE;
/*!40000 ALTER TABLE `user_activity` DISABLE KEYS */;
INSERT INTO `user_activity` VALUES (1,'lvd27012004@gmail.com','2025-07-13 00:28:44','2025-07-13 16:17:25',948),(2,'lvd27012004@gmail.com','2025-07-13 00:28:47','2025-07-13 16:17:25',948),(3,'lvd27012004@gmail.com','2025-07-13 00:51:07','2025-07-13 16:17:25',926),(4,'lvd27012004@gmail.com','2025-07-13 00:51:09','2025-07-13 16:17:25',926),(5,'lvd27012004@gmail.com','2025-07-13 01:01:59','2025-07-13 16:17:25',915),(6,'lvd27012004@gmail.com','2025-07-13 01:02:02','2025-07-13 16:17:25',915),(7,'datlvde180983','2025-07-13 01:19:45','2025-07-13 01:40:01',20),(8,'datlvde180983','2025-07-13 01:19:46','2025-07-13 01:40:01',20),(9,'lvd27012004@gmail.com','2025-07-13 01:30:56','2025-07-13 16:17:25',886),(10,'lvd27012004@gmail.com','2025-07-13 01:30:58','2025-07-13 16:17:25',886),(11,'datlvde180983','2025-07-13 01:37:36','2025-07-13 01:40:01',2),(12,'datlvde180983','2025-07-13 01:37:38','2025-07-13 01:40:01',2),(13,'datlvde180983','2025-07-13 01:40:29','2025-07-13 02:18:35',38),(14,'datlvde180983','2025-07-13 01:40:31','2025-07-13 02:18:35',38),(15,'datlvde180983','2025-07-13 01:49:17','2025-07-13 02:18:35',29),(16,'datlvde180983','2025-07-13 02:12:49','2025-07-13 02:18:35',5),(17,'datlvde180983','2025-07-13 02:16:30','2025-07-13 02:18:35',2),(18,'datlvde180983','2025-07-13 02:18:42','2025-07-13 16:21:44',25),(19,'lvd27012004@gmail.com','2025-07-13 16:17:11','2025-07-13 16:17:25',0),(20,'datlvde180983','2025-07-13 16:17:31','2025-07-13 16:21:44',4),(21,'lvd27012004@gmail.com','2025-07-13 16:22:03','2025-07-13 16:22:13',0),(22,'user01','2025-07-13 16:23:06','2025-07-13 16:23:31',0),(23,'lvd27012004@gmail.com','2025-07-13 16:25:20','2025-07-13 17:20:07',54),(24,'lvd27012004@gmail.com','2025-07-13 17:10:53','2025-07-13 17:20:07',9),(25,'lvd27012004@gmail.com','2025-07-13 17:19:31','2025-07-13 17:20:07',0),(26,'teacher1','2025-07-13 17:30:58','2025-07-13 17:40:31',9),(27,'lvd27012004@gmail.com','2025-07-13 17:40:45','2025-07-14 13:26:24',1185),(28,'datlvde180983','2025-07-13 17:41:10','2025-07-14 11:23:45',1062),(29,'datlvde180983','2025-07-13 18:01:44','2025-07-14 11:23:45',1042),(30,'lvd27012004@gmail.com','2025-07-13 18:05:49','2025-07-14 13:26:24',1160),(31,'lvd27012004@gmail.com','2025-07-13 18:12:09','2025-07-14 13:26:24',1154),(32,'lvd27012004@gmail.com','2025-07-13 19:14:56','2025-07-14 13:26:24',1091),(33,'lvd27012004@gmail.com','2025-07-13 19:28:30','2025-07-14 13:26:24',1077),(34,'lvd27012004@gmail.com','2025-07-13 19:40:27','2025-07-14 13:26:24',1065),(35,'datlvde180983','2025-07-14 11:22:53','2025-07-14 11:23:45',0),(36,'datlvde180983','2025-07-14 12:11:29','2025-07-14 13:23:43',72),(37,'datlvde180983','2025-07-14 12:18:34','2025-07-14 13:23:43',65),(38,'datlvde180983','2025-07-14 13:21:40','2025-07-14 13:23:43',2),(39,'datlvde180983','2025-07-14 13:23:41','2025-07-14 13:23:43',0),(40,'lvd27012004@gmail.com','2025-07-14 13:26:18','2025-07-14 13:26:24',0),(41,'lvd27012004@gmail.com','2025-07-14 13:27:39','2025-07-14 13:28:14',0),(42,'datlvde180983','2025-07-14 13:49:10','2025-07-14 13:49:15',0),(43,'lvd27012004@gmail.com','2025-07-14 13:50:34','2025-07-14 13:54:17',3),(44,'datlvde180983','2025-07-14 13:53:36','2025-07-14 13:53:41',0),(45,'lvd27012004@gmail.com','2025-07-14 13:53:48','2025-07-14 13:54:17',0),(46,'datlvde180983','2025-07-14 13:55:05','2025-07-14 13:55:10',0),(47,'lvd27012004@gmail.com','2025-07-14 13:55:16','2025-07-14 13:56:22',1),(48,'datlvde180983','2025-07-14 13:56:28','2025-07-14 14:02:22',5),(49,'datlvde180983','2025-07-14 14:05:08','2025-07-14 15:05:32',60),(50,'user01','2025-07-14 14:07:49','2025-07-14 14:07:52',0),(51,'lvd27012004@gmail.com','2025-07-14 14:23:29','2025-07-14 14:23:41',0),(52,'user01','2025-07-14 14:33:42','2025-07-14 14:42:07',8),(53,'datlvde180983','2025-07-14 14:42:14','2025-07-14 15:05:32',23),(54,'teacher1','2025-07-14 14:43:00','2025-07-14 21:46:27',423),(55,'user01','2025-07-14 15:01:29','2025-07-14 15:01:31',0),(56,'datlvde180983','2025-07-14 15:01:38','2025-07-14 15:05:32',3),(57,'datlvde180983','2025-07-14 15:05:29','2025-07-14 15:05:32',0),(58,'user01','2025-07-14 20:28:07','2025-07-14 20:28:09',0),(59,'user01','2025-07-14 20:28:24','2025-07-14 20:28:27',0),(60,'huy','2025-07-14 20:41:26','2025-07-17 01:28:37',3167),(61,'user01','2025-07-14 21:00:03','2025-07-14 21:23:33',23),(62,'user02','2025-07-14 21:22:59','2025-07-14 21:23:02',0),(63,'user01','2025-07-14 21:23:29','2025-07-14 21:23:33',0),(64,'dat','2025-07-14 21:26:16','2025-07-14 21:26:21',0),(65,'user01','2025-07-14 21:40:16','2025-07-14 21:40:28',0),(66,'user01','2025-07-14 21:40:23','2025-07-14 21:40:28',0),(67,'user01','2025-07-14 21:46:02','2025-07-14 21:46:05',0),(68,'teacher1','2025-07-14 21:46:17','2025-07-14 21:46:27',0),(69,'datlvde180983','2025-07-14 21:46:45','2025-07-14 21:50:25',3),(70,'datlvde180983','2025-07-14 21:50:21','2025-07-14 21:50:25',0),(71,'asd','2025-07-14 21:51:19','2025-07-17 01:23:02',3091),(72,'datlvde180983','2025-07-14 21:55:19','2025-07-16 16:34:24',2559),(73,'lvd27012004@gmail.com','2025-07-14 21:58:28','2025-07-16 16:28:17',2549),(74,'lvd27012004@gmail.com','2025-07-14 22:06:58','2025-07-16 16:28:17',2541),(75,'datlvde180983','2025-07-14 22:08:23','2025-07-16 16:34:24',2546),(76,'lvd27012004@gmail.com','2025-07-14 22:24:37','2025-07-16 16:28:17',2523),(77,'lvd27012004@gmail.com','2025-07-14 22:28:12','2025-07-16 16:28:17',2520),(78,'datlvde180983','2025-07-14 22:31:20','2025-07-16 16:34:24',2523),(79,'datlvde180983','2025-07-14 22:36:26','2025-07-16 16:34:24',2517),(80,'lvd27012004@gmail.com','2025-07-14 22:52:06','2025-07-16 16:28:17',2496),(81,'datlvde180983','2025-07-14 23:36:59','2025-07-16 16:34:24',2457),(82,'datlvde180983','2025-07-14 23:58:26','2025-07-16 16:34:24',2435),(83,'datlvde180983','2025-07-15 00:04:00','2025-07-16 16:34:24',2430),(84,'lvd27012004@gmail.com','2025-07-15 14:55:32','2025-07-16 16:28:17',1532),(85,'user02','2025-07-15 14:58:31',NULL,NULL),(86,'datlvde180983','2025-07-15 15:27:56','2025-07-16 16:34:24',1506),(87,'datlvde180983','2025-07-15 15:29:06','2025-07-16 16:34:24',1505),(88,'datlvde180983','2025-07-15 22:12:23','2025-07-16 16:34:24',1102),(89,'user01','2025-07-15 22:30:51','2025-07-15 22:31:00',0),(90,'lvd27012004@gmail.com','2025-07-15 22:31:06','2025-07-16 16:28:17',1077),(91,'lvd27012004@gmail.com','2025-07-15 22:44:35','2025-07-16 16:28:17',1063),(92,'datlvde180983','2025-07-15 22:55:06','2025-07-16 16:34:24',1059),(93,'datlvde180983','2025-07-15 23:03:00','2025-07-16 16:34:24',1051),(94,'datlvde180983','2025-07-15 23:15:29','2025-07-16 16:34:24',1038),(95,'datlvde180983','2025-07-15 23:19:33','2025-07-16 16:34:24',1034),(96,'datlvde180983','2025-07-15 23:31:36','2025-07-16 16:34:24',1022),(97,'datlvde180983','2025-07-15 23:49:12','2025-07-16 16:34:24',1005),(98,'datlvde180983','2025-07-15 23:56:35','2025-07-16 16:34:24',997),(99,'lvd27012004@gmail.com','2025-07-16 00:02:17','2025-07-16 16:28:17',986),(100,'lvd27012004@gmail.com','2025-07-16 00:09:15','2025-07-16 16:28:17',979),(101,'lvd27012004@gmail.com','2025-07-16 00:20:57','2025-07-16 16:28:17',967),(102,'datlvde180983','2025-07-16 00:22:17','2025-07-16 16:34:24',972),(103,'datlvde180983','2025-07-16 00:25:56','2025-07-16 16:34:24',968),(104,'lvd27012004@gmail.com','2025-07-16 00:47:27','2025-07-16 16:28:17',940),(105,'datlvde180983','2025-07-16 00:47:43','2025-07-16 16:34:24',946),(106,'lvd27012004@gmail.com','2025-07-16 00:49:01','2025-07-16 16:28:17',939),(107,'lvd27012004@gmail.com','2025-07-16 00:49:13','2025-07-16 16:28:17',939),(108,'datlvde180983','2025-07-16 00:54:59','2025-07-16 16:34:24',939),(109,'datlvde180983','2025-07-16 00:55:08','2025-07-16 16:34:24',939),(110,'datlvde180983','2025-07-16 00:59:17','2025-07-16 16:34:24',935),(111,'datlvde180983','2025-07-16 00:59:34','2025-07-16 16:34:24',934),(112,'datlvde180983','2025-07-16 01:02:13','2025-07-16 16:34:24',932),(113,'datlvde180983','2025-07-16 01:07:11','2025-07-16 16:34:24',927),(114,'datlvde180983','2025-07-16 01:15:55','2025-07-16 16:34:24',918),(115,'datlvde180983','2025-07-16 01:25:11','2025-07-16 16:34:24',909),(116,'datlvde180983','2025-07-16 01:29:14','2025-07-16 16:34:24',905),(117,'lvd27012004@gmail.com','2025-07-16 01:48:44','2025-07-16 16:28:17',879),(118,'lvd27012004@gmail.com','2025-07-16 01:54:04','2025-07-16 16:28:17',874),(119,'lvd27012004@gmail.com','2025-07-16 01:55:23','2025-07-16 16:28:17',872),(120,'datlvde180983','2025-07-16 01:56:54','2025-07-16 16:34:24',877),(121,'lvd27012004@gmail.com','2025-07-16 02:07:10','2025-07-16 16:28:17',861),(122,'datlvde180983','2025-07-16 02:11:17','2025-07-16 16:34:24',863),(123,'datlvde180983','2025-07-16 02:16:12','2025-07-16 16:34:24',858),(124,'lvd27012004@gmail.com','2025-07-16 02:26:25','2025-07-16 16:28:17',841),(125,'lvd27012004@gmail.com','2025-07-16 02:40:13','2025-07-16 16:28:17',828),(126,'datlvde180983','2025-07-16 02:47:55','2025-07-16 16:34:24',826),(127,'datlvde180983','2025-07-16 02:52:52','2025-07-16 16:34:24',821),(128,'datlvde180983','2025-07-16 02:58:26','2025-07-16 16:34:24',815),(129,'lvd27012004@gmail.com','2025-07-16 02:59:11','2025-07-16 16:28:17',809),(130,'lvd27012004@gmail.com','2025-07-16 14:39:11','2025-07-16 16:28:17',109),(131,'datlvde180983','2025-07-16 14:53:52','2025-07-16 16:34:24',100),(132,'datlvde180983','2025-07-16 14:56:22','2025-07-16 16:34:24',98),(133,'datlvde180983','2025-07-16 14:59:14','2025-07-16 16:34:24',95),(134,'datlvde180983','2025-07-16 15:20:40','2025-07-16 16:34:24',73),(135,'datlvde180983','2025-07-16 15:26:49','2025-07-16 16:34:24',67),(136,'datlvde180983','2025-07-16 15:43:35','2025-07-16 16:34:24',50),(137,'datlvde180983','2025-07-16 15:53:23','2025-07-16 16:34:24',41),(138,'datlvde180983','2025-07-16 16:18:52','2025-07-16 16:34:24',15),(139,'lvd27012004@gmail.com','2025-07-16 16:27:57','2025-07-16 16:28:17',0),(140,'datlvde180983','2025-07-16 16:28:33','2025-07-16 16:34:24',5),(141,'datlvde180983','2025-07-16 16:31:00','2025-07-16 16:34:24',3),(142,'datlvde180983','2025-07-16 16:33:40','2025-07-16 16:34:24',0),(143,'datlvde180983','2025-07-16 16:34:31','2025-07-16 17:48:06',73),(144,'datlvde180983','2025-07-16 16:38:09','2025-07-16 17:48:06',69),(145,'datlvde180983','2025-07-16 16:43:25','2025-07-16 17:48:06',64),(146,'datlvde180983','2025-07-16 16:45:00','2025-07-16 17:48:06',63),(147,'datlvde180983','2025-07-16 16:46:44','2025-07-16 17:48:06',61),(148,'datlvde180983','2025-07-16 16:50:03','2025-07-16 17:48:06',58),(149,'datlvde180983','2025-07-16 16:51:37','2025-07-16 17:48:06',56),(150,'datlvde180983','2025-07-16 17:13:33','2025-07-16 17:48:06',34),(151,'datlvde180983','2025-07-16 17:36:34','2025-07-16 17:48:06',11),(152,'datlvde180983','2025-07-16 17:42:25','2025-07-16 17:48:06',5),(153,'lvd27012004@gmail.com','2025-07-16 17:44:28','2025-07-16 17:47:40',3),(154,'datlvde180983','2025-07-16 17:47:49','2025-07-16 17:48:06',0),(155,'datlvde180983','2025-07-16 17:48:12','2025-07-17 01:17:09',448),(156,'lvd27012004@gmail.com','2025-07-16 17:53:49','2025-07-16 17:53:53',0),(157,'lvd27012004@gmail.com','2025-07-16 17:55:46','2025-07-17 01:19:47',444),(158,'datlvde180983','2025-07-16 18:20:43','2025-07-17 01:17:09',416),(159,'datlvde180983','2025-07-16 18:41:54','2025-07-17 01:17:09',395),(160,'datlvde180983','2025-07-16 18:46:02','2025-07-17 01:17:09',391),(161,'lvd27012004@gmail.com','2025-07-16 20:57:02','2025-07-17 01:19:47',262),(162,'datlvde180983','2025-07-16 21:28:53','2025-07-17 01:17:09',228),(163,'datlvde180983','2025-07-16 21:47:45','2025-07-17 01:17:09',209),(164,'datlvde180983','2025-07-16 22:46:40','2025-07-17 01:17:09',150),(165,'datlvde180983','2025-07-16 23:20:56','2025-07-17 01:17:09',116),(166,'datlvde180983','2025-07-16 23:41:01','2025-07-17 01:17:09',96),(167,'datlvde180983','2025-07-16 23:48:42','2025-07-17 01:17:09',88),(168,'datlvde180983','2025-07-17 00:41:55','2025-07-17 01:17:09',35),(169,'datlvde180983','2025-07-17 01:02:57','2025-07-17 01:17:09',14),(170,'datlvde180983','2025-07-17 01:08:00','2025-07-17 01:17:09',9),(171,'datlvde180983','2025-07-17 01:10:41','2025-07-17 01:17:09',6),(172,'lvd27012004@gmail.com','2025-07-17 01:17:15','2025-07-17 01:19:47',2),(173,'teacher1','2025-07-17 01:20:28','2025-07-17 01:21:34',1),(174,'asd','2025-07-17 01:21:44','2025-07-17 01:23:02',1),(175,'huy','2025-07-17 01:23:17','2025-07-17 01:28:37',5),(176,'user01','2025-07-17 11:25:17','2025-07-17 11:25:39',0),(177,'lvd27012004@gmail.com','2025-07-17 11:25:44',NULL,NULL),(178,'lvd27012004@gmail.com','2025-07-17 13:08:49',NULL,NULL),(179,'lvd27012004@gmail.com','2025-07-17 15:48:02',NULL,NULL),(180,'lvd27012004@gmail.com','2025-07-17 16:28:39',NULL,NULL),(181,'datlvde180983','2025-07-17 16:45:33',NULL,NULL);
/*!40000 ALTER TABLE `user_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('student','teacher','admin') NOT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `google_id` (`google_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'admin','$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2','admin@example.com','admin',NULL),(2,'teacher1','$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2','teacher1@example.com','teacher',NULL),(3,'student1','$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2','student1@example.com','student',NULL),(4,'lvd27012004@gmail.com','','lvd27012004@gmail.com','teacher','104275197933380558868'),(5,'datlvde180983','','datlvde180983@fpt.edu.vn','teacher','109653592243158745281'),(6,'user01','$2a$10$Qc2iIzqZo/2W/LGUoEqPfuoCrIWwbbS2schBVAmMB/iPT8eCh/sPa','a@gmail.com','student',NULL),(7,'a','123','dat@gmail.com','student',NULL),(8,'hoang','$2a$10$nZid.RsJg8vO5uPk994.Cuu0UUWRJbjPNcD0JWGctyJFTomq2NR12','hoang@gmail.com','student',NULL),(12,'user09','$2a$10$lvGrGyqK2Ka0KtrwqxWI7O4wbNrP0YDBv6nppWLyXPCT2MJM8Wur2','wirenvahd@hotmail.com','student',NULL),(13,'asd','$2a$10$nkMdcCVtDjlOZiKmBLMvzuHNWbHlQUsZY/gfMufIMC8ebmJkgMtU6','asdasd@gmail.com','teacher',NULL),(17,'huy','$2a$10$Nvt9/PLxdO4y6poyHAQLIeOrOcrK7cH5Zfa5t.ou/OzNDcRqXh7v.','huy@gmail.com','teacher',NULL),(18,'dat','$2a$10$VXkeStchcyxu57JLG2YVcuUcX8BIsQOQS5yYeODh3wLLiOScclAw6','123a@gmail.com','student',NULL),(19,'user02','$2a$10$AqvSAr1TtuMYP/H6dtAYn./dQ5eNQtDc3SpPVpmt0P2vbsUo/KTwS','user02@gmail.com','student',NULL),(20,'user05','$2a$10$s7SS1DJ3prb37QAyGMcLJuC793SKz.YjslDzeV.hL918OOOtk/6Lq','user05@gmail.com','student',NULL);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-17 17:01:40
