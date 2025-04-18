-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: home_elderly_care_db
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `blood_pressure`
--

DROP TABLE IF EXISTS `blood_pressure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_pressure` (
  `blood_pressure_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `systolic` int DEFAULT NULL,
  `diastolic` int DEFAULT NULL,
  `pulse` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`blood_pressure_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `blood_pressure_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_pressure`
--

LOCK TABLES `blood_pressure` WRITE;
/*!40000 ALTER TABLE `blood_pressure` DISABLE KEYS */;
INSERT INTO `blood_pressure` VALUES (1,6,150,98,99,'2025-04-09 14:03:26'),(2,6,150,98,99,'2025-04-09 14:07:01'),(3,6,150,98,99,'2025-04-09 14:08:56'),(4,6,150,98,99,'2025-04-10 05:37:08'),(5,6,150,98,99,'2025-04-10 06:38:51'),(6,6,150,98,99,'2025-04-10 06:48:30'),(7,6,150,98,99,'2025-04-10 06:51:13'),(8,6,150,98,99,'2025-04-10 07:23:40'),(9,6,150,98,99,'2025-04-10 08:14:51'),(10,8,150,98,99,'2025-04-10 08:19:36'),(11,8,150,98,99,'2025-04-10 08:21:08'),(12,8,150,98,99,'2025-04-10 09:05:54'),(13,8,150,98,99,'2025-04-10 09:35:09'),(14,8,150,98,99,'2025-04-10 10:01:47'),(15,8,150,98,99,'2025-04-10 10:15:54'),(16,8,150,98,99,'2025-04-10 10:20:45');
/*!40000 ALTER TABLE `blood_pressure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_sugar`
--

DROP TABLE IF EXISTS `blood_sugar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_sugar` (
  `blood_sugar_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `value` decimal(5,2) DEFAULT NULL,
  `time` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`blood_sugar_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `blood_sugar_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_sugar`
--

LOCK TABLES `blood_sugar` WRITE;
/*!40000 ALTER TABLE `blood_sugar` DISABLE KEYS */;
INSERT INTO `blood_sugar` VALUES (1,6,5.70,NULL,'2025-04-10 05:53:41'),(2,6,5.70,NULL,'2025-04-10 06:01:11'),(3,6,5.70,NULL,'2025-04-10 06:41:49'),(4,8,5.70,NULL,'2025-04-10 06:42:47'),(5,6,5.70,NULL,'2025-04-10 06:47:27'),(6,6,5.70,NULL,'2025-04-10 08:24:08'),(7,8,5.70,NULL,'2025-04-10 08:29:12'),(8,6,5.70,NULL,'2025-04-10 09:04:39'),(9,8,6.60,NULL,'2025-04-10 09:29:57'),(10,8,6.60,NULL,'2025-04-10 09:34:07'),(11,8,6.60,NULL,'2025-04-10 10:02:12'),(12,8,6.60,NULL,'2025-04-10 10:21:22');
/*!40000 ALTER TABLE `blood_sugar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_knowledge`
--

DROP TABLE IF EXISTS `health_knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_knowledge` (
  `health_knowledge_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `category` varchar(50) NOT NULL,
  `author` varchar(100) DEFAULT NULL,
  `publish_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `image_url` varchar(255) DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`health_knowledge_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `health_knowledge_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_knowledge`
--

LOCK TABLES `health_knowledge` WRITE;
/*!40000 ALTER TABLE `health_knowledge` DISABLE KEYS */;
INSERT INTO `health_knowledge` VALUES (1,'test','test','health','admin','2025-04-11 06:46:37','www.baidu1.com','www.baidu1.com',9,'2025-04-11 06:46:37','2025-04-13 05:13:54'),(3,'Health Science | Say goodbye to the \"one size fits all\" approach, and tailor cardiovascular medication accordingly from now on','Have you ever encountered such a situation? \nThe same medication is effective for others, but not for oneself, and may even have side effects? \nDespite changing multiple medications, the condition remains poorly controlled? \nWorried about the side effects of medication and afraid to take it for a long time? \nWant to adjust the dosage of medication, but suffer from the lack of scientific basis, can only \"feel the stones and cross the river\"? \nIn fact, all of these answers may be hidden in your genes. \nRecently, our pathology department launched a personalized genetic testing project for cardiovascular disease medication guidance, allowing vascular medication to be tailored to individual needs and bidding farewell to the \"one size fits all\" approach. \nWhat is personalized medication guidance genetic testing for cardiovascular disease? \nSimply put, it is to detect genes related to drug metabolism, efficacy, and adverse reactions, predict patients\' reactions to different drugs, and help doctors develop more accurate and personalized medication plans for you. \nThe speed of drug metabolism affects the duration of drug efficacy, and the sensitivity of drugs determines the dosage and risk of adverse reactions, such as clopidogrel resistance and statin induced muscle toxicity. \nThe traditional \"one size fits all\" medication model can easily lead to differences in efficacy, while molecular pathological genetic testing can decode individual genetic codes and provide scientific basis for medication plans. \nWhat population is this test suitable for? \nPatients who are taking cardiovascular disease medication but have poor efficacy or adverse reactions. \nPatients who require long-term use of multiple cardiovascular disease medications. \nPatients with a history of adverse drug reactions or family history. \nPatients who hope to understand their own drug metabolism and achieve precise medication. \nWhat are the advantages of this test? \nPrecision: Analyzing individual differences in drug response at the genetic level to provide scientific basis for precision medicine. \nSafety: Predict the risk of adverse drug reactions and avoid medication risks in advance. \nEfficient: Assist doctors in quickly developing personalized medication plans to improve treatment outcomes. \nConvenience: Only a small amount of blood needs to be drawn to complete the test. \nPrecision medicine starts with \'genes\'. \nIndividualized medication guidance for cardiovascular disease through genetic testing, safeguarding your health.','health','admin','2025-04-11 08:46:24','www.baidu.com','www.baidu.com',9,'2025-04-11 08:46:24','2025-04-11 08:46:24'),(4,'Health Science | Say goodbye to the \"one size fits all\" approach, and tailor cardiovascular medication accordingly from now on','Have you ever encountered such a situation?\n\nThe same medication is effective for others, but not for oneself, and may even have side effects?\n\nDespite changing multiple medications, the condition remains poorly controlled?\n\nWorried about the side effects of medication and afraid to take it for a long time?\n\nWant to adjust the dosage of medication, but suffer from the lack of scientific basis, can only \"feel the stones and cross the river\"?\n\nIn fact, all of these answers may be hidden in your genes.\n\nRecently, our pathology department launched a personalized genetic testing project for cardiovascular disease medication guidance, allowing vascular medication to be tailored to individual needs and bidding farewell to the \"one size fits all\" approach.\n\nWhat is personalized medication guidance genetic testing for cardiovascular disease?\n\nSimply put, it is to detect genes related to drug metabolism, efficacy, and adverse reactions, predict patients\' reactions to different drugs, and help doctors develop more accurate and personalized medication plans for you.\n\nThe speed of drug metabolism affects the duration of drug efficacy, and the sensitivity of drugs determines the dosage and risk of adverse reactions, such as clopidogrel resistance and statin induced muscle toxicity.\n\nThe traditional \"one size fits all\" medication model can easily lead to differences in efficacy, while molecular pathological genetic testing can decode individual genetic codes and provide scientific basis for medication plans.\n\nWhat population is this test suitable for?\n\nPatients who are taking cardiovascular disease medication but have poor efficacy or adverse reactions.\n\nPatients who require long-term use of multiple cardiovascular disease medications.\n\nPatients with a history of adverse drug reactions or family history.\n\nPatients who hope to understand their own drug metabolism and achieve precise medication.\n\nWhat are the advantages of this test?\n\nPrecision: Analyzing individual differences in drug response at the genetic level to provide scientific basis for precision medicine.\n\nSafety: Predict the risk of adverse drug reactions and avoid medication risks in advance.\n\nEfficient: Assist doctors in quickly developing personalized medication plans to improve treatment outcomes.\n\nConvenience: Only a small amount of blood needs to be drawn to complete the test.\n\nPrecision medicine starts with \'genes\'.\n\nIndividualized medication guidance for cardiovascular disease through genetic testing, safeguarding your health.','health','admin','2025-04-11 08:49:49','www.baidu.com','www.baidu.com',9,'2025-04-11 08:49:49','2025-04-11 08:49:49'),(5,'如何预防老年痴呆症','老年痴呆症是一种常见的神经退行性疾病，影响着全球数百万老年人。虽然目前尚无治愈方法，但通过积极的生活方式干预，可以有效降低患病风险。以下是一些建议：\n\n1. 保持积极的认知活动：阅读、写作、玩益智游戏、学习新技能等，都有助于刺激大脑，增强认知储备。\n\n2. 坚持体育锻炼：每周至少进行 150 分钟的中等强度有氧运动，如散步、游泳、骑自行车等。体育锻炼可以改善血液循环，促进大脑健康。\n\n3. 均衡饮食：多摄入富含抗氧化剂、维生素和健康脂肪的食物，如蔬菜、水果、全谷物、鱼类和坚果。限制高糖、高盐和高脂肪食物的摄入。\n\n4. 保持社交互动：积极参与社交活动，与家人、朋友保持联系，有助于减轻孤独感，增强心理健康。\n\n5. 控制慢性疾病：高血压、糖尿病、高胆固醇等慢性疾病会增加患老年痴呆症的风险。积极控制这些疾病，有助于保护大脑健康。\n\n6. 戒烟限酒：吸烟和过量饮酒都会损害大脑健康，增加患老年痴呆症的风险。戒烟限酒有助于降低患病风险。\n\n7. 保证充足睡眠：每晚保持 7-8 小时的睡眠，有助于大脑清除有害物质，促进认知功能。\n\n8. 定期体检：定期进行体检，及时发现和处理潜在的健康问题，有助于保护大脑健康。\n\n通过采取这些积极的生活方式干预措施，您可以有效降低患老年痴呆症的风险，保持大脑健康，享受幸福的晚年生活。','疾病预防','健康专家','2025-04-11 16:04:35','https://baidu.com','https://baidu.com',6,'2025-04-11 16:04:35','2025-04-11 16:04:35'),(7,'Is blood sugar prone to fluctuations in spring?  Diabetes prevention and treatment knowledge that \"sugar friends\" must know','The temperature in spring is changeable\\. For patients with diabetes\\, this is a time when they need to pay special attention to blood sugar fluctuations\\, so it is very important to do a good job in prevention and treatment\\. Here are some common sense about prevention and treatment of diabetes in spring\\.\\nAs the saying goes\\, \"spring covers autumn\"\\, diabetes patients have weak resistance and are insensitive to temperature\\. If they do not pay attention to keeping warm\\, they will easily catch a cold\\, which will increase blood sugar\\. Patients should adjust their clothing in a timely manner according to changes in external temperature\\. Pay special attention to keeping the lower body\\, abdomen\\, back\\, and feet warm\\.\\nIn spring\\, the liver qi is strong\\, so it should be less sour and more sweet\\. On the basis of controlling total calories every day\\, maintain a diversified diet and eat more sweet\\, warm\\, and light foods\\. The combination of coarse and fine staple foods\\, such as oats\\, buckwheat\\, brown rice\\, etc\\; Eating foods rich in high\\-quality protein\\, vitamins\\, and trace elements such as chicken and milk can help control blood sugar and blood lipids and prevent complications\\. Eat more spring leafy vegetables such as spinach and shepherd\'s purse\\, and choose low sugar fruits such as strawberries and cherries\\.\\nWhen the temperature rises in spring\\, diabetes patients who love sweating are prone to tinea pedis\\, and patients with vascular disease and foot skin damage should pay more attention\\. Check your feet every day and change your shoes and socks frequently\\.\\nAppropriate exercise can accelerate blood flow\\, improve disease resistance\\, enhance insulin sensitivity\\, and help maintain blood sugar stability\\. You can choose to engage in outdoor activities such as walking\\, walking\\, etc\\. one hour after meals\\, to avoid fasting and prolonged intense exercise\\. Negative emotions can cause blood sugar fluctuations\\, which can be relieved through activities such as calligraphy\\, painting\\, gardening\\, etc\\.\\nIn short\\, diabetes patients should maintain good living habits in spring\\, which can effectively control blood sugar and prevent complications\\.','health','admin','2025-04-12 05:44:27','www.baidu.com','www.baidu.com',9,'2025-04-12 05:44:27','2025-04-12 05:44:27'),(8,'Is blood sugar prone to fluctuations in spring?  Diabetes prevention and treatment knowledge that \"sugar friends\" must know','The temperature in spring is changeable. For patients with diabetes, this is a time when they need to pay special attention to blood sugar fluctuations, so it is very important to do a good job in prevention and treatment.\n Here are some common sense about prevention and treatment of diabetes in spring.\nAs the saying goes, \"spring covers autumn\", diabetes patients have weak resistance and are insensitive to temperature. If they do not pay attention to keeping warm, they will easily catch a cold, which will increase blood sugar.\n Patients should adjust their clothing in a timely manner according to changes in external temperature.\n Pay special attention to keeping the lower body, abdomen, back, and feet warm.\nIn spring, the liver qi is strong, so it should be less sour and more sweet.\n On the basis of controlling total calories every day, maintain a diversified diet and eat more sweet, warm, and light foods.\n The combination of coarse and fine staple foods, such as oats, buckwheat, brown rice, etc;\n Eating foods rich in high-quality protein, vitamins, and trace elements such as chicken and milk can help control blood sugar and blood lipids and prevent complications.\n Eat more spring leafy vegetables such as spinach and shepherd\'s purse, and choose low sugar fruits such as strawberries and cherries.\nWhen the temperature rises in spring, diabetes patients who love sweating are prone to tinea pedis, and patients with vascular disease and foot skin damage should pay more attention.\n Check your feet every day and change your shoes and socks frequently.\nAppropriate exercise can accelerate blood flow, improve disease resistance, enhance insulin sensitivity, and help maintain blood sugar stability.\n You can choose to engage in outdoor activities such as walking, walking, etc. one hour after meals, to avoid fasting and prolonged intense exercise.\n Negative emotions can cause blood sugar fluctuations, which can be relieved through activities such as calligraphy, painting, gardening, etc.\nIn short, diabetes patients should maintain good living habits in spring, which can effectively control blood sugar and prevent complications.','health','admin','2025-04-12 05:47:38','','',9,'2025-04-12 05:47:38','2025-04-12 05:47:38'),(9,'test','test','health','admin','2025-04-17 09:23:43','','',9,'2025-04-17 09:23:43','2025-04-17 09:23:43');
/*!40000 ALTER TABLE `health_knowledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `user_type` enum('admin','social_worker','elderly') NOT NULL DEFAULT 'elderly',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip_code` varchar(20) DEFAULT NULL,
  `emergency_contact_name` varchar(255) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `allergies` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (6,'testuser1','$2b$10$fkx7agZXrYwQJ0tSIemPt.kKqoEujw8Z732IrRSltun0VuK9J7dh6','test1@example.com','1234567890','elderly','2025-04-01 11:37:56','San','Zhang','2025-04-02','male','123 Main Street','Anytown','CA','91234','Jane Doe','555-123-4567','penicillin'),(8,'user1','$2b$10$RkeLHL.oIgwDhn2L8lXcruyloRG3.8p0dlaILGu7VS0F3gLgU.ELq','123@example.com','1234567890','elderly','2025-04-08 08:03:22','John','Doe','2025-04-01','male','123 Street','Liuzhou','Guangxi','12345','1234','12345','No'),(9,'user2','$2b$10$4H/HFeLEGhLT8TFlmfOvSOWh4HhM/5PtV9P77TBXJKd84FsVjbATG','user2@user.com','1234567890','admin','2025-04-08 08:18:01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,'swuser1','$2b$10$1eNgWhoVRmgO6o1upbD/i.eVFqeV8y4KsPQvxxLO87Tb7e2SgvDMm','123@123.com','1234567890','social_worker','2025-04-13 13:19:16',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'swuser2','$2b$10$KHCGduwWGeAwfvB52Tz1Dux6l7QlBwSkX1B6urM.fr1U/917fkOl.','123@qwe.com','1234567890','social_worker','2025-04-13 13:59:46',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-18 17:07:22
