-- MySQL dump 10.13  Distrib 8.1.0, for macos14.0 (arm64)
--
-- Host: localhost    Database: hously
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activations`
--

DROP TABLE IF EXISTS `activations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `code` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activations_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activations`
--

LOCK TABLES `activations` WRITE;
/*!40000 ALTER TABLE `activations` DISABLE KEYS */;
INSERT INTO `activations` VALUES (1,1,'O1zFE58f5i9OWGdka6iwhbtO6luxkCsO',1,'2023-12-22 03:30:40','2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,2,'VB3stjv0Ge8FpshDG6t3xIEn0WvUWGo1',1,'2023-12-22 03:30:40','2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `activations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_notifications`
--

DROP TABLE IF EXISTS `admin_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `permission` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_notifications`
--

LOCK TABLES `admin_notifications` WRITE;
/*!40000 ALTER TABLE `admin_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_histories`
--

DROP TABLE IF EXISTS `audit_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `module` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `request` longtext COLLATE utf8mb4_unicode_ci,
  `action` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_user` bigint unsigned NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `reference_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_histories_user_id_index` (`user_id`),
  KEY `audit_histories_module_index` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_histories`
--

LOCK TABLES `audit_histories` WRITE;
/*!40000 ALTER TABLE `audit_histories` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint unsigned NOT NULL DEFAULT '0',
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `author_id` bigint unsigned DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Botble\\ACL\\Models\\User',
  `icon` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` tinyint NOT NULL DEFAULT '0',
  `is_featured` tinyint NOT NULL DEFAULT '0',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_parent_id_index` (`parent_id`),
  KEY `categories_status_index` (`status`),
  KEY `categories_created_at_index` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Design',0,'Alice after it, \'Mouse dear! Do come back and see how the Dodo managed it.) First it marked out a new kind of rule, \'and vinegar that makes them bitter--and--and barley-sugar and such things that.','published',2,'Botble\\ACL\\Models\\User',NULL,0,1,0,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'Lifestyle',0,'Alice thought), and it put the Lizard as she said these words her foot as far as they lay sprawling about, reminding her very much what would happen next. The first thing I\'ve got to go from here?\'.','published',2,'Botble\\ACL\\Models\\User',NULL,0,1,0,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'Travel Tips',0,'YOUR adventures.\' \'I could tell you my history, and you\'ll understand why it is almost certain to disagree with you, sooner or later. However, this bottle was a very curious to see the Mock Turtle.','published',1,'Botble\\ACL\\Models\\User',NULL,0,1,0,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'Healthy',0,'Alice, who felt very curious sensation, which puzzled her too much, so she took courage, and went on in a natural way. \'I thought you did,\' said the King. The White Rabbit put on her lap as if his.','published',2,'Botble\\ACL\\Models\\User',NULL,0,0,0,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'Travel Tips',0,'March Hare. \'I didn\'t mean it!\' pleaded poor Alice. \'But you\'re so easily offended!\' \'You\'ll get used to do:-- \'How doth the little--\"\' and she jumped up in such long curly brown hair! And it\'ll.','published',2,'Botble\\ACL\\Models\\User',NULL,0,1,0,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(6,'Hotel',0,'MINE.\' The Queen turned crimson with fury, and, after waiting till she was near enough to try the first question, you know.\' It was, no doubt: only Alice did not like to hear her try and say \"Who am.','published',2,'Botble\\ACL\\Models\\User',NULL,0,1,0,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(7,'Nature',0,'I\'m doubtful about the whiting!\' \'Oh, as to bring but one; Bill\'s got to the shore. CHAPTER III. A Caucus-Race and a large ring, with the day and night! You see the Mock Turtle Soup is made from,\'.','published',1,'Botble\\ACL\\Models\\User',NULL,0,0,0,'2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories_translations`
--

DROP TABLE IF EXISTS `categories_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `categories_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`categories_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories_translations`
--

LOCK TABLES `categories_translations` WRITE;
/*!40000 ALTER TABLE `categories_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state_id` bigint unsigned DEFAULT NULL,
  `country_id` bigint unsigned DEFAULT NULL,
  `record_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` tinyint NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cities_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES (1,'Paris','paris',1,1,NULL,0,'cities/location-1.jpg',0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'London','london',2,2,NULL,0,'cities/location-2.jpg',0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'New York','new-york',3,3,NULL,0,'cities/location-3.jpg',0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'Copenhagen','copenhagen',4,4,NULL,0,'cities/location-4.jpg',0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'Berlin','berlin',5,5,NULL,0,'cities/location-5.jpg',0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cities_translations`
--

DROP TABLE IF EXISTS `cities_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cities_id` bigint unsigned NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`cities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities_translations`
--

LOCK TABLES `cities_translations` WRITE;
/*!40000 ALTER TABLE `cities_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `cities_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_replies`
--

DROP TABLE IF EXISTS `contact_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_replies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_replies`
--

LOCK TABLES `contact_replies` WRITE;
/*!40000 ALTER TABLE `contact_replies` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unread',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nationality` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` tinyint NOT NULL DEFAULT '0',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'France','French',0,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40','FRA'),(2,'England','English',0,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40','UK'),(3,'USA','Americans',0,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40','US'),(4,'Holland','Dutch',0,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40','HL'),(5,'Denmark','Danish',0,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40','DN'),(6,'Germany','Danish',0,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40','DN');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries_translations`
--

DROP TABLE IF EXISTS `countries_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `countries_id` bigint unsigned NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nationality` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`countries_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries_translations`
--

LOCK TABLES `countries_translations` WRITE;
/*!40000 ALTER TABLE `countries_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `countries_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_widget_settings`
--

DROP TABLE IF EXISTS `dashboard_widget_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard_widget_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `settings` text COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned NOT NULL,
  `widget_id` bigint unsigned NOT NULL,
  `order` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dashboard_widget_settings_user_id_index` (`user_id`),
  KEY `dashboard_widget_settings_widget_id_index` (`widget_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_widget_settings`
--

LOCK TABLES `dashboard_widget_settings` WRITE;
/*!40000 ALTER TABLE `dashboard_widget_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `dashboard_widget_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dashboard_widgets`
--

DROP TABLE IF EXISTS `dashboard_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dashboard_widgets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dashboard_widgets`
--

LOCK TABLES `dashboard_widgets` WRITE;
/*!40000 ALTER TABLE `dashboard_widgets` DISABLE KEYS */;
/*!40000 ALTER TABLE `dashboard_widgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faq_categories`
--

DROP TABLE IF EXISTS `faq_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` tinyint NOT NULL DEFAULT '0',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `description` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq_categories`
--

LOCK TABLES `faq_categories` WRITE;
/*!40000 ALTER TABLE `faq_categories` DISABLE KEYS */;
INSERT INTO `faq_categories` VALUES (1,'General',0,'published','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(2,'Buying',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(3,'Payment',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(4,'Support',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL);
/*!40000 ALTER TABLE `faq_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faq_categories_translations`
--

DROP TABLE IF EXISTS `faq_categories_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faq_categories_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `faq_categories_id` bigint unsigned NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`faq_categories_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faq_categories_translations`
--

LOCK TABLES `faq_categories_translations` WRITE;
/*!40000 ALTER TABLE `faq_categories_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `faq_categories_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faqs`
--

DROP TABLE IF EXISTS `faqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faqs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `question` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `answer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faqs`
--

LOCK TABLES `faqs` WRITE;
/*!40000 ALTER TABLE `faqs` DISABLE KEYS */;
INSERT INTO `faqs` VALUES (1,'Where does it come from?','If several languages coalesce, the grammar of the resulting language is more simple and regular than that of the individual languages. The new common language will be more simple and regular than the existing European languages.',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(2,'How JobBox Work?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(3,'What is your shipping policy?','Everyone realizes why a new common language would be desirable: one could refuse to pay expensive translators. To achieve this, it would be necessary to have uniform grammar, pronunciation and more common words.',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(4,'Where To Place A FAQ Page','Just as the name suggests, a FAQ page is all about simple questions and answers. Gather common questions your customers have asked from your support team and include them in the FAQ, Use categories to organize questions related to specific topics.',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(5,'Why do we use it?','It will be as simple as Occidental; in fact, it will be Occidental. To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental.',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(6,'Where can I get some?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',1,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(7,'Where does it come from?','If several languages coalesce, the grammar of the resulting language is more simple and regular than that of the individual languages. The new common language will be more simple and regular than the existing European languages.',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(8,'How JobBox Work?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(9,'What is your shipping policy?','Everyone realizes why a new common language would be desirable: one could refuse to pay expensive translators. To achieve this, it would be necessary to have uniform grammar, pronunciation and more common words.',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(10,'Where To Place A FAQ Page','Just as the name suggests, a FAQ page is all about simple questions and answers. Gather common questions your customers have asked from your support team and include them in the FAQ, Use categories to organize questions related to specific topics.',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(11,'Why do we use it?','It will be as simple as Occidental; in fact, it will be Occidental. To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental.',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(12,'Where can I get some?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',2,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(13,'Where does it come from?','If several languages coalesce, the grammar of the resulting language is more simple and regular than that of the individual languages. The new common language will be more simple and regular than the existing European languages.',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(14,'How JobBox Work?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(15,'What is your shipping policy?','Everyone realizes why a new common language would be desirable: one could refuse to pay expensive translators. To achieve this, it would be necessary to have uniform grammar, pronunciation and more common words.',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(16,'Where To Place A FAQ Page','Just as the name suggests, a FAQ page is all about simple questions and answers. Gather common questions your customers have asked from your support team and include them in the FAQ, Use categories to organize questions related to specific topics.',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(17,'Why do we use it?','It will be as simple as Occidental; in fact, it will be Occidental. To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental.',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(18,'Where can I get some?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',3,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(19,'Where does it come from?','If several languages coalesce, the grammar of the resulting language is more simple and regular than that of the individual languages. The new common language will be more simple and regular than the existing European languages.',4,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(20,'How JobBox Work?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',4,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(21,'What is your shipping policy?','Everyone realizes why a new common language would be desirable: one could refuse to pay expensive translators. To achieve this, it would be necessary to have uniform grammar, pronunciation and more common words.',4,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(22,'Where To Place A FAQ Page','Just as the name suggests, a FAQ page is all about simple questions and answers. Gather common questions your customers have asked from your support team and include them in the FAQ, Use categories to organize questions related to specific topics.',4,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(23,'Why do we use it?','It will be as simple as Occidental; in fact, it will be Occidental. To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental.',4,'published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(24,'Where can I get some?','To an English person, it will seem like simplified English, as a skeptical Cambridge friend of mine told me what Occidental is. The European languages are members of the same family. Their separate existence is a myth.',4,'published','2023-12-22 03:30:41','2023-12-22 03:30:41');
/*!40000 ALTER TABLE `faqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faqs_translations`
--

DROP TABLE IF EXISTS `faqs_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `faqs_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `faqs_id` bigint unsigned NOT NULL,
  `question` text COLLATE utf8mb4_unicode_ci,
  `answer` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`lang_code`,`faqs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faqs_translations`
--

LOCK TABLES `faqs_translations` WRITE;
/*!40000 ALTER TABLE `faqs_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `faqs_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `language_meta`
--

DROP TABLE IF EXISTS `language_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `language_meta` (
  `lang_meta_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `lang_meta_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lang_meta_origin` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `reference_type` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`lang_meta_id`),
  KEY `language_meta_reference_id_index` (`reference_id`),
  KEY `meta_code_index` (`lang_meta_code`),
  KEY `meta_origin_index` (`lang_meta_origin`),
  KEY `meta_reference_type_index` (`reference_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `language_meta`
--

LOCK TABLES `language_meta` WRITE;
/*!40000 ALTER TABLE `language_meta` DISABLE KEYS */;
INSERT INTO `language_meta` VALUES (1,'en_US','4cde5985054f831418d4cce536cd1b3d',1,'Botble\\Menu\\Models\\MenuLocation'),(2,'en_US','356b90105872e1206c5bd5875eba1de8',1,'Botble\\Menu\\Models\\Menu'),(3,'en_US','b17bf5c7ed37572b116da7dba65b09e9',2,'Botble\\Menu\\Models\\Menu'),(4,'en_US','e7e3133e726de1b56fa262ae0925152e',3,'Botble\\Menu\\Models\\Menu');
/*!40000 ALTER TABLE `language_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `languages` (
  `lang_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `lang_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lang_locale` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lang_flag` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lang_is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `lang_order` int NOT NULL DEFAULT '0',
  `lang_is_rtl` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`lang_id`),
  KEY `lang_locale_index` (`lang_locale`),
  KEY `lang_code_index` (`lang_code`),
  KEY `lang_is_default_index` (`lang_is_default`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'English','en','en_US','us',1,0,0);
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_files`
--

DROP TABLE IF EXISTS `media_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_files` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `folder_id` bigint unsigned NOT NULL DEFAULT '0',
  `mime_type` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` int NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `media_files_user_id_index` (`user_id`),
  KEY `media_files_index` (`folder_id`,`user_id`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_files`
--

LOCK TABLES `media_files` WRITE;
/*!40000 ALTER TABLE `media_files` DISABLE KEYS */;
INSERT INTO `media_files` VALUES (1,0,'location-1','location-1',1,'image/jpeg',4881,'cities/location-1.jpg','[]','2023-12-22 03:30:40','2023-12-22 03:30:40',NULL),(2,0,'location-2','location-2',1,'image/jpeg',4881,'cities/location-2.jpg','[]','2023-12-22 03:30:40','2023-12-22 03:30:40',NULL),(3,0,'location-3','location-3',1,'image/jpeg',4881,'cities/location-3.jpg','[]','2023-12-22 03:30:40','2023-12-22 03:30:40',NULL),(4,0,'location-4','location-4',1,'image/jpeg',4881,'cities/location-4.jpg','[]','2023-12-22 03:30:40','2023-12-22 03:30:40',NULL),(5,0,'location-5','location-5',1,'image/jpeg',4881,'cities/location-5.jpg','[]','2023-12-22 03:30:40','2023-12-22 03:30:40',NULL),(6,0,'1','1',2,'image/jpeg',9730,'accounts/1.jpg','[]','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(7,0,'10','10',2,'image/jpeg',9730,'accounts/10.jpg','[]','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(8,0,'2','2',2,'image/jpeg',9730,'accounts/2.jpg','[]','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(9,0,'3','3',2,'image/jpeg',9730,'accounts/3.jpg','[]','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(10,0,'4','4',2,'image/jpeg',9730,'accounts/4.jpg','[]','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(11,0,'5','5',2,'image/jpeg',9730,'accounts/5.jpg','[]','2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(12,0,'6','6',2,'image/jpeg',9730,'accounts/6.jpg','[]','2023-12-22 03:30:42','2023-12-22 03:30:42',NULL),(13,0,'7','7',2,'image/jpeg',9730,'accounts/7.jpg','[]','2023-12-22 03:30:42','2023-12-22 03:30:42',NULL),(14,0,'8','8',2,'image/jpeg',9730,'accounts/8.jpg','[]','2023-12-22 03:30:42','2023-12-22 03:30:42',NULL),(15,0,'9','9',2,'image/jpeg',9730,'accounts/9.jpg','[]','2023-12-22 03:30:42','2023-12-22 03:30:42',NULL),(16,0,'01','01',3,'image/jpeg',34111,'backgrounds/01.jpg','[]','2023-12-22 03:30:50','2023-12-22 03:30:50',NULL),(17,0,'02','02',3,'image/jpeg',34111,'backgrounds/02.jpg','[]','2023-12-22 03:30:50','2023-12-22 03:30:50',NULL),(18,0,'03','03',3,'image/jpeg',34111,'backgrounds/03.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(19,0,'04','04',3,'image/jpeg',34111,'backgrounds/04.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(20,0,'hero','hero',3,'image/jpeg',12672,'backgrounds/hero.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(21,0,'map','map',3,'image/png',25344,'backgrounds/map.png','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(22,0,'01','01',4,'image/jpeg',5306,'clients/01.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(23,0,'02','02',4,'image/jpeg',5306,'clients/02.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(24,0,'03','03',4,'image/jpeg',5306,'clients/03.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(25,0,'04','04',4,'image/jpeg',5306,'clients/04.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(26,0,'05','05',4,'image/jpeg',5306,'clients/05.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(27,0,'06','06',4,'image/jpeg',5306,'clients/06.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(28,0,'07','07',4,'image/jpeg',5306,'clients/07.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(29,0,'08','08',4,'image/jpeg',5306,'clients/08.jpg','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(30,0,'amazon','amazon',4,'image/png',1180,'clients/amazon.png','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(31,0,'google','google',4,'image/png',1180,'clients/google.png','[]','2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(32,0,'lenovo','lenovo',4,'image/png',1180,'clients/lenovo.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(33,0,'paypal','paypal',4,'image/png',1180,'clients/paypal.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(34,0,'shopify','shopify',4,'image/png',1180,'clients/shopify.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(35,0,'spotify','spotify',4,'image/png',1180,'clients/spotify.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(36,0,'about','about',5,'image/jpeg',11053,'general/about.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(37,0,'error','error',5,'image/png',7124,'general/error.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(38,0,'favicon','favicon',5,'image/png',6145,'general/favicon.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(39,0,'logo-authentication-page','logo-authentication-page',5,'image/png',2683,'general/logo-authentication-page.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(40,0,'logo-dark','logo-dark',5,'image/png',2597,'general/logo-dark.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(41,0,'logo-light','logo-light',5,'image/png',2626,'general/logo-light.png','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(42,0,'1','1',6,'image/jpeg',9730,'properties/1.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(43,0,'10','10',6,'image/jpeg',9730,'properties/10.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(44,0,'11','11',6,'image/jpeg',9730,'properties/11.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(45,0,'12','12',6,'image/jpeg',9730,'properties/12.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(46,0,'2','2',6,'image/jpeg',9730,'properties/2.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(47,0,'3','3',6,'image/jpeg',9730,'properties/3.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(48,0,'4','4',6,'image/jpeg',9730,'properties/4.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(49,0,'5','5',6,'image/jpeg',9730,'properties/5.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(50,0,'6','6',6,'image/jpeg',9730,'properties/6.jpg','[]','2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(51,0,'7','7',6,'image/jpeg',9730,'properties/7.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(52,0,'8','8',6,'image/jpeg',9730,'properties/8.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(53,0,'9','9',6,'image/jpeg',9730,'properties/9.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(54,0,'1-1','1-1',6,'image/jpeg',9730,'properties/1-1.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(55,0,'2-1','2-1',6,'image/jpeg',9730,'properties/2-1.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(56,0,'3-1','3-1',6,'image/jpeg',9730,'properties/3-1.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(57,0,'4-1','4-1',6,'image/jpeg',9730,'properties/4-1.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(58,0,'5-1','5-1',6,'image/jpeg',9730,'properties/5-1.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(59,0,'1','1',7,'image/jpeg',9730,'news/1.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(60,0,'10','10',7,'image/jpeg',9730,'news/10.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(61,0,'11','11',7,'image/jpeg',9730,'news/11.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(62,0,'12','12',7,'image/jpeg',9730,'news/12.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(63,0,'13','13',7,'image/jpeg',9730,'news/13.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(64,0,'14','14',7,'image/jpeg',9730,'news/14.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(65,0,'15','15',7,'image/jpeg',9730,'news/15.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(66,0,'16','16',7,'image/jpeg',9730,'news/16.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(67,0,'2','2',7,'image/jpeg',9730,'news/2.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(68,0,'3','3',7,'image/jpeg',9730,'news/3.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(69,0,'4','4',7,'image/jpeg',9730,'news/4.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(70,0,'5','5',7,'image/jpeg',9730,'news/5.jpg','[]','2023-12-22 03:30:53','2023-12-22 03:30:53',NULL),(71,0,'6','6',7,'image/jpeg',9730,'news/6.jpg','[]','2023-12-22 03:30:54','2023-12-22 03:30:54',NULL),(72,0,'7','7',7,'image/jpeg',9730,'news/7.jpg','[]','2023-12-22 03:30:54','2023-12-22 03:30:54',NULL),(73,0,'8','8',7,'image/jpeg',9730,'news/8.jpg','[]','2023-12-22 03:30:54','2023-12-22 03:30:54',NULL),(74,0,'9','9',7,'image/jpeg',9730,'news/9.jpg','[]','2023-12-22 03:30:54','2023-12-22 03:30:54',NULL);
/*!40000 ALTER TABLE `media_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_folders`
--

DROP TABLE IF EXISTS `media_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_folders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` bigint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `media_folders_user_id_index` (`user_id`),
  KEY `media_folders_index` (`parent_id`,`user_id`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_folders`
--

LOCK TABLES `media_folders` WRITE;
/*!40000 ALTER TABLE `media_folders` DISABLE KEYS */;
INSERT INTO `media_folders` VALUES (1,0,'cities',NULL,'cities',0,'2023-12-22 03:30:40','2023-12-22 03:30:40',NULL),(2,0,'accounts',NULL,'accounts',0,'2023-12-22 03:30:41','2023-12-22 03:30:41',NULL),(3,0,'backgrounds',NULL,'backgrounds',0,'2023-12-22 03:30:50','2023-12-22 03:30:50',NULL),(4,0,'clients',NULL,'clients',0,'2023-12-22 03:30:51','2023-12-22 03:30:51',NULL),(5,0,'general',NULL,'general',0,'2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(6,0,'properties',NULL,'properties',0,'2023-12-22 03:30:52','2023-12-22 03:30:52',NULL),(7,0,'news',NULL,'news',0,'2023-12-22 03:30:53','2023-12-22 03:30:53',NULL);
/*!40000 ALTER TABLE `media_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_settings`
--

DROP TABLE IF EXISTS `media_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `media_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_settings`
--

LOCK TABLES `media_settings` WRITE;
/*!40000 ALTER TABLE `media_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_locations`
--

DROP TABLE IF EXISTS `menu_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_locations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `menu_id` bigint unsigned NOT NULL,
  `location` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_locations_menu_id_created_at_index` (`menu_id`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_locations`
--

LOCK TABLES `menu_locations` WRITE;
/*!40000 ALTER TABLE `menu_locations` DISABLE KEYS */;
INSERT INTO `menu_locations` VALUES (1,1,'main-menu','2023-12-22 03:30:50','2023-12-22 03:30:50');
/*!40000 ALTER TABLE `menu_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_nodes`
--

DROP TABLE IF EXISTS `menu_nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_nodes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `menu_id` bigint unsigned NOT NULL,
  `parent_id` bigint unsigned NOT NULL DEFAULT '0',
  `reference_id` bigint unsigned DEFAULT NULL,
  `reference_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_font` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` tinyint unsigned NOT NULL DEFAULT '0',
  `title` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `css_class` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '_self',
  `has_child` tinyint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_nodes_menu_id_index` (`menu_id`),
  KEY `menu_nodes_parent_id_index` (`parent_id`),
  KEY `reference_id` (`reference_id`),
  KEY `reference_type` (`reference_type`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_nodes`
--

LOCK TABLES `menu_nodes` WRITE;
/*!40000 ALTER TABLE `menu_nodes` DISABLE KEYS */;
INSERT INTO `menu_nodes` VALUES (1,1,0,NULL,NULL,NULL,NULL,0,'Home',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(2,1,1,1,'Botble\\Page\\Models\\Page','/home-one',NULL,0,'Home One',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(3,1,1,2,'Botble\\Page\\Models\\Page','/home-two',NULL,0,'Home Two',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(4,1,1,3,'Botble\\Page\\Models\\Page','/home-three',NULL,0,'Home Three',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(5,1,1,4,'Botble\\Page\\Models\\Page','/home-four',NULL,0,'Home Four',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(6,1,0,NULL,NULL,'/projects',NULL,0,'Projects',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(7,1,6,5,'Botble\\Page\\Models\\Page','/projects',NULL,0,'Projects List',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(8,1,6,NULL,NULL,'/projects/walnut-park-apartments',NULL,0,'Project Detail',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(9,1,0,6,'Botble\\Page\\Models\\Page','/properties',NULL,0,'Properties',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(10,1,9,6,'Botble\\Page\\Models\\Page','/properties',NULL,0,'Properties List',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(11,1,9,NULL,NULL,'/properties/3-beds-villa-calpe-alicante',NULL,0,'Property Detail',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(12,1,0,NULL,NULL,'/page',NULL,0,'Page',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(13,1,12,NULL,NULL,'/agents',NULL,0,'Agents',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(14,1,12,16,'Botble\\Page\\Models\\Page','/wishlist',NULL,0,'Wishlist',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(15,1,12,7,'Botble\\Page\\Models\\Page','/about-us',NULL,0,'About Us',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(16,1,12,8,'Botble\\Page\\Models\\Page','/features',NULL,0,'Features',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(17,1,12,9,'Botble\\Page\\Models\\Page','/pricing-plans',NULL,0,'Pricing',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(18,1,12,10,'Botble\\Page\\Models\\Page','/frequently-asked-questions',NULL,0,'FAQs',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(19,1,12,15,'Botble\\Page\\Models\\Page','/contact',NULL,0,'Contact',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(20,1,12,NULL,NULL,'/auth-pages',NULL,0,'Auth Pages',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(21,1,20,NULL,NULL,'/login',NULL,0,'Login',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(22,1,20,NULL,NULL,'/register',NULL,0,'Signup',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(23,1,20,NULL,NULL,'/password/request',NULL,0,'Reset Password',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(24,1,12,NULL,NULL,'/utility',NULL,0,'Utility',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(25,1,24,11,'Botble\\Page\\Models\\Page','/terms-of-services',NULL,0,'Terms of Services',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(26,1,24,12,'Botble\\Page\\Models\\Page','/privacy-policy',NULL,0,'Privacy Policy',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(27,1,12,NULL,NULL,'/special',NULL,0,'Special',NULL,'_self',1,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(28,1,27,13,'Botble\\Page\\Models\\Page','/coming-soon',NULL,0,'Coming soon',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(29,1,27,NULL,NULL,'/404',NULL,0,'404 Error',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(30,2,0,7,'Botble\\Page\\Models\\Page','/about-us',NULL,0,'About Us',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(31,2,0,NULL,NULL,'#',NULL,0,'Services',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(32,2,0,9,'Botble\\Page\\Models\\Page','/pricing-plans',NULL,0,'Pricing',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(33,2,0,14,'Botble\\Page\\Models\\Page','/news',NULL,0,'News',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(34,2,0,NULL,NULL,'/login',NULL,0,'Login',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(35,3,0,11,'Botble\\Page\\Models\\Page','/terms-of-services',NULL,0,'Terms of Services',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(36,3,0,12,'Botble\\Page\\Models\\Page','/privacy-policy',NULL,0,'Privacy Policy',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(37,3,0,6,'Botble\\Page\\Models\\Page','/properties',NULL,0,'Listing',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50'),(38,3,0,14,'Botble\\Page\\Models\\Page','/news',NULL,0,'Contact',NULL,'_self',0,'2023-12-22 03:30:50','2023-12-22 03:30:50');
/*!40000 ALTER TABLE `menu_nodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `menus_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'Main menu','main-menu','published','2023-12-22 03:30:50','2023-12-22 03:30:50'),(2,'Company','company','published','2023-12-22 03:30:50','2023-12-22 03:30:50'),(3,'Useful Links','useful-links','published','2023-12-22 03:30:50','2023-12-22 03:30:50');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meta_boxes`
--

DROP TABLE IF EXISTS `meta_boxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meta_boxes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meta_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_value` text COLLATE utf8mb4_unicode_ci,
  `reference_id` bigint unsigned NOT NULL,
  `reference_type` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meta_boxes_reference_id_index` (`reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meta_boxes`
--

LOCK TABLES `meta_boxes` WRITE;
/*!40000 ALTER TABLE `meta_boxes` DISABLE KEYS */;
INSERT INTO `meta_boxes` VALUES (1,'navbar_style','[\"dark\"]',1,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'navbar_style','[\"light\"]',2,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'navbar_style','[\"dark\"]',3,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'navbar_style','[\"dark\"]',4,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'navbar_style','[\"light\"]',5,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(6,'navbar_style','[\"light\"]',6,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(7,'navbar_style','[\"light\"]',7,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(8,'navbar_style','[\"light\"]',8,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(9,'navbar_style','[\"light\"]',9,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(10,'navbar_style','[\"light\"]',10,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(11,'navbar_style','[\"light\"]',16,'Botble\\Page\\Models\\Page','2023-12-22 03:30:40','2023-12-22 03:30:40'),(12,'social_facebook','[\"facebook.com\"]',2,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:42','2023-12-22 03:30:42'),(13,'social_instagram','[\"instagram.com\"]',2,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:42','2023-12-22 03:30:42'),(14,'social_linkedin','[\"linkedin.com\"]',2,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:42','2023-12-22 03:30:42'),(15,'social_facebook','[\"facebook.com\"]',3,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(16,'social_instagram','[\"instagram.com\"]',3,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(17,'social_linkedin','[\"linkedin.com\"]',3,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(18,'social_facebook','[\"facebook.com\"]',4,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(19,'social_instagram','[\"instagram.com\"]',4,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(20,'social_linkedin','[\"linkedin.com\"]',4,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(21,'social_facebook','[\"facebook.com\"]',5,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(22,'social_instagram','[\"instagram.com\"]',5,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(23,'social_linkedin','[\"linkedin.com\"]',5,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(24,'social_facebook','[\"facebook.com\"]',6,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(25,'social_instagram','[\"instagram.com\"]',6,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(26,'social_linkedin','[\"linkedin.com\"]',6,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:43','2023-12-22 03:30:43'),(27,'social_facebook','[\"facebook.com\"]',7,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(28,'social_instagram','[\"instagram.com\"]',7,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(29,'social_linkedin','[\"linkedin.com\"]',7,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(30,'social_facebook','[\"facebook.com\"]',8,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(31,'social_instagram','[\"instagram.com\"]',8,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(32,'social_linkedin','[\"linkedin.com\"]',8,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(33,'social_facebook','[\"facebook.com\"]',9,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(34,'social_instagram','[\"instagram.com\"]',9,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(35,'social_linkedin','[\"linkedin.com\"]',9,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(36,'social_facebook','[\"facebook.com\"]',10,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(37,'social_instagram','[\"instagram.com\"]',10,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(38,'social_linkedin','[\"linkedin.com\"]',10,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:44','2023-12-22 03:30:44'),(39,'social_facebook','[\"facebook.com\"]',11,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:45','2023-12-22 03:30:45'),(40,'social_instagram','[\"instagram.com\"]',11,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:45','2023-12-22 03:30:45'),(41,'social_linkedin','[\"linkedin.com\"]',11,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:45','2023-12-22 03:30:45'),(42,'social_facebook','[\"facebook.com\"]',12,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:45','2023-12-22 03:30:45'),(43,'social_instagram','[\"instagram.com\"]',12,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:45','2023-12-22 03:30:45'),(44,'social_linkedin','[\"linkedin.com\"]',12,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:45','2023-12-22 03:30:45'),(45,'social_facebook','[\"facebook.com\"]',13,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:46','2023-12-22 03:30:46'),(46,'social_instagram','[\"instagram.com\"]',13,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:46','2023-12-22 03:30:46'),(47,'social_linkedin','[\"linkedin.com\"]',13,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:46','2023-12-22 03:30:46'),(48,'social_facebook','[\"facebook.com\"]',14,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:46','2023-12-22 03:30:46'),(49,'social_instagram','[\"instagram.com\"]',14,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:46','2023-12-22 03:30:46'),(50,'social_linkedin','[\"linkedin.com\"]',14,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:46','2023-12-22 03:30:46'),(51,'social_facebook','[\"facebook.com\"]',15,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(52,'social_instagram','[\"instagram.com\"]',15,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(53,'social_linkedin','[\"linkedin.com\"]',15,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(54,'social_facebook','[\"facebook.com\"]',16,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(55,'social_instagram','[\"instagram.com\"]',16,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(56,'social_linkedin','[\"linkedin.com\"]',16,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(57,'social_facebook','[\"facebook.com\"]',17,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(58,'social_instagram','[\"instagram.com\"]',17,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(59,'social_linkedin','[\"linkedin.com\"]',17,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:47','2023-12-22 03:30:47'),(60,'social_facebook','[\"facebook.com\"]',18,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(61,'social_instagram','[\"instagram.com\"]',18,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(62,'social_linkedin','[\"linkedin.com\"]',18,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(63,'social_facebook','[\"facebook.com\"]',19,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(64,'social_instagram','[\"instagram.com\"]',19,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(65,'social_linkedin','[\"linkedin.com\"]',19,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(66,'social_facebook','[\"facebook.com\"]',20,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(67,'social_instagram','[\"instagram.com\"]',20,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(68,'social_linkedin','[\"linkedin.com\"]',20,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:48','2023-12-22 03:30:48'),(69,'social_facebook','[\"facebook.com\"]',21,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:49','2023-12-22 03:30:49'),(70,'social_instagram','[\"instagram.com\"]',21,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:49','2023-12-22 03:30:49'),(71,'social_linkedin','[\"linkedin.com\"]',21,'Botble\\RealEstate\\Models\\Account','2023-12-22 03:30:49','2023-12-22 03:30:49');
/*!40000 ALTER TABLE `meta_boxes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2013_04_09_032329_create_base_tables',1),(2,'2013_04_09_062329_create_revisions_table',1),(3,'2014_10_12_000000_create_users_table',1),(4,'2014_10_12_100000_create_password_reset_tokens_table',1),(5,'2016_06_10_230148_create_acl_tables',1),(6,'2016_06_14_230857_create_menus_table',1),(7,'2016_06_28_221418_create_pages_table',1),(8,'2016_10_05_074239_create_setting_table',1),(9,'2016_11_28_032840_create_dashboard_widget_tables',1),(10,'2016_12_16_084601_create_widgets_table',1),(11,'2017_05_09_070343_create_media_tables',1),(12,'2017_11_03_070450_create_slug_table',1),(13,'2019_01_05_053554_create_jobs_table',1),(14,'2019_08_19_000000_create_failed_jobs_table',1),(15,'2019_12_14_000001_create_personal_access_tokens_table',1),(16,'2021_08_05_134214_fix_social_link_theme_options',1),(17,'2022_04_20_100851_add_index_to_media_table',1),(18,'2022_04_20_101046_add_index_to_menu_table',1),(19,'2022_07_10_034813_move_lang_folder_to_root',1),(20,'2022_08_04_051940_add_missing_column_expires_at',1),(21,'2022_09_01_000001_create_admin_notifications_tables',1),(22,'2022_10_14_024629_drop_column_is_featured',1),(23,'2022_11_18_063357_add_missing_timestamp_in_table_settings',1),(24,'2022_12_02_093615_update_slug_index_columns',1),(25,'2023_01_30_024431_add_alt_to_media_table',1),(26,'2023_02_16_042611_drop_table_password_resets',1),(27,'2023_04_23_005903_add_column_permissions_to_admin_notifications',1),(28,'2023_05_10_075124_drop_column_id_in_role_users_table',1),(29,'2023_07_18_040500_convert_cities_is_featured_to_selecting_locations_from_shortcode',1),(30,'2023_07_25_032204_update_search_tabs_hero_banner_shortcode',1),(31,'2023_08_21_090810_make_page_content_nullable',1),(32,'2023_09_14_021936_update_index_for_slugs_table',1),(33,'2023_12_06_100448_change_random_hash_for_media',1),(34,'2023_12_07_095130_add_color_column_to_media_folders_table',1),(35,'2023_12_17_162208_make_sure_column_color_in_media_folders_nullable',1),(36,'2023_12_20_034718_update_invoice_amount',1),(37,'2015_06_29_025744_create_audit_history',2),(38,'2023_11_14_033417_change_request_column_in_table_audit_histories',2),(39,'2015_06_18_033822_create_blog_table',3),(40,'2021_02_16_092633_remove_default_value_for_author_type',3),(41,'2021_12_03_030600_create_blog_translations',3),(42,'2022_04_19_113923_add_index_to_table_posts',3),(43,'2023_08_29_074620_make_column_author_id_nullable',3),(44,'2016_06_17_091537_create_contacts_table',4),(45,'2023_11_10_080225_migrate_contact_blacklist_email_domains_to_core',4),(46,'2018_07_09_221238_create_faq_table',5),(47,'2021_12_03_082134_create_faq_translations',5),(48,'2023_11_17_063408_add_description_column_to_faq_categories_table',5),(49,'2016_10_03_032336_create_languages_table',6),(50,'2023_09_14_022423_add_index_for_language_table',6),(51,'2021_10_25_021023_fix-priority-load-for-language-advanced',7),(52,'2021_12_03_075608_create_page_translations',7),(53,'2023_07_06_011444_create_slug_translations_table',7),(54,'2019_11_18_061011_create_country_table',8),(55,'2021_12_03_084118_create_location_translations',8),(56,'2021_12_03_094518_migrate_old_location_data',8),(57,'2021_12_10_034440_switch_plugin_location_to_use_language_advanced',8),(58,'2022_01_16_085908_improve_plugin_location',8),(59,'2022_08_04_052122_delete_location_backup_tables',8),(60,'2023_04_23_061847_increase_state_translations_abbreviation_column',8),(61,'2023_07_26_041451_add_more_columns_to_location_table',8),(62,'2023_07_27_041451_add_more_columns_to_location_translation_table',8),(63,'2023_08_15_073307_drop_unique_in_states_cities_translations',8),(64,'2023_10_21_065016_make_state_id_in_table_cities_nullable',8),(65,'2017_10_24_154832_create_newsletter_table',9),(66,'2017_05_18_080441_create_payment_tables',10),(67,'2021_03_27_144913_add_customer_type_into_table_payments',10),(68,'2021_05_24_034720_make_column_currency_nullable',10),(69,'2021_08_09_161302_add_metadata_column_to_payments_table',10),(70,'2021_10_19_020859_update_metadata_field',10),(71,'2022_06_28_151901_activate_paypal_stripe_plugin',10),(72,'2022_07_07_153354_update_charge_id_in_table_payments',10),(73,'2018_06_22_032304_create_real_estate_table',11),(74,'2021_02_11_031126_update_price_column_in_projects_and_properties',11),(75,'2021_03_08_024049_add_lat_long_into_real_estate_tables',11),(76,'2021_06_10_091950_add_column_is_featured_to_table_re_accounts',11),(77,'2021_07_07_021757_update_table_account_activity_logs',11),(78,'2021_09_29_042758_create_re_categories_multilevel_table',11),(79,'2021_10_31_031254_add_company_to_accounts_table',11),(80,'2021_12_10_034807_create_real_estate_translation_tables',11),(81,'2021_12_18_081636_add_property_project_views_count',11),(82,'2022_05_04_033044_update_column_images_in_real_estate_tables',11),(83,'2022_07_02_081723_fix_expired_date_column',11),(84,'2022_08_01_090213_update_table_properties_and_projects',11),(85,'2023_01_31_023233_create_re_custom_fields_table',11),(86,'2023_02_06_000000_add_location_to_re_accounts_table',11),(87,'2023_02_06_024257_add_package_translations',11),(88,'2023_02_08_062457_add_custom_fields_translation_table',11),(89,'2023_02_15_024644_create_re_reviews_table',11),(90,'2023_02_20_072604_create_re_invoices_table',11),(91,'2023_02_20_081251_create_re_account_packages_table',11),(92,'2023_04_04_030709_add_unique_id_to_properties_and_projects_table',11),(93,'2023_04_14_164811_make_phone_and_email_in_table_re_consults_nullable',11),(94,'2023_05_09_062031_unique_reviews_table',11),(95,'2023_05_26_034353_fix_properties_projects_image',11),(96,'2023_05_27_004215_add_column_ip_into_table_re_consults',11),(97,'2023_07_25_034513_create_re_coupons_table',11),(98,'2023_07_25_034672_add_coupon_code_column_to_jb_invoices_table',11),(99,'2023_08_02_074208_change_square_column_to_float',11),(100,'2023_08_07_000001_add_is_public_profile_column_to_re_accounts_table',11),(101,'2023_08_09_004607_make_column_project_id_nullable',11),(102,'2023_09_11_084630_update_mandatory_fields_in_consult_form_table',11),(103,'2023_11_21_071820_add_missing_slug_for_agents',11),(104,'2018_07_09_214610_create_testimonial_table',12),(105,'2021_12_03_083642_create_testimonials_translations',12),(106,'2016_10_07_193005_create_translations_table',13),(107,'2023_12_12_105220_drop_translations_table',13);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletters`
--

DROP TABLE IF EXISTS `newsletters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `newsletters` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'subscribed',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletters`
--

LOCK TABLES `newsletters` WRITE;
/*!40000 ALTER TABLE `newsletters` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `user_id` bigint unsigned DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pages_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages`
--

LOCK TABLES `pages` WRITE;
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` VALUES (1,'Home One','<div>[hero-banner style=&quot;1&quot; title=&quot;We will help you find &lt;br&gt; your Wonderful home&quot; title_highlight=&quot;Wonderful&quot; subtitle=&quot;A great platform to buy, sell and rent your properties without any agent or commissions.&quot; background_images=&quot;backgrounds/01.jpg,backgrounds/02.jpg,backgrounds/03.jpg,backgrounds/04.jpg&quot; enabled_search_box=&quot;1&quot; search_tabs=&quot;projects,sale,rent&quot; search_type=&quot;properties&quot;][/hero-banner]</div><div>[intro-about-us title=\"Efficiency. Transparency. Control.\" description=\"Hously developed a platform for the Real Estate marketplace that allows buyers and sellers to easily execute a transaction on their own. The platform drives efficiency, cost transparency and control into the hands of the consumers. Hously is Real Estate Redefined.\" text_button_action=\"Learn More\" url_button_action=\"#\" image=\"general/about.jpg\" youtube_video_url=\"https://www.youtube.com/watch?v=y9j-BL5ocW8\"][/intro-about-us]</div><div>[how-it-works title=\"How It Works\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" icon_1=\"mdi mdi-home-outline\" title_1=\"Evaluate Property\" description_1=\"If the distribution of letters and \'words\' is random, the reader will not be distracted from making.\" icon_2=\"mdi mdi-bag-personal-outline\" title_2=\"Meeting with Agent\" description_2=\"If the distribution of letters and \'words\' is random, the reader will not be distracted from making.\" icon_3=\"mdi mdi-key-outline\" title_3=\"Close the Deal\" description_3=\"If the distribution of letters and \'words\' is random, the reader will not be distracted from making.\"][/how-it-works]</div><div>[properties-by-locations title=\"Find your inspiration with Hously\" title_highlight_text=\"inspiration with\" subtitle=\"Properties By Location and Country\" city=\"1,2,3,4,5,6\"][/properties-by-locations]</div><div>[featured-projects title=\"Featured Projects\" subtitle=\"We make the best choices with the hottest and most prestigious projects, please visit the details below to find out more.\" limit=\"6\"][/featured-projects]</div><div>[featured-properties title=\"Featured Properties\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\"][/featured-properties]</div><div>[recently-viewed-properties title=\"Recently Viewed Properties\" subtitle=\"Your currently viewed properties.\" limit=\"3\"][/recently-viewed-properties]</div><div>[testimonials title=\"What Our Client Say?\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\"][/testimonials]</div><div>[featured-agents title=\"Featured Agents\" subtitle=\"Below is the featured agent.\" limit=\"6\"][/featured-agents]</div><div>[featured-posts title=\"Latest News\" subtitle=\"Below is the latest real estate news we get regularly updated from reliable sources.\" limit=\"3\"][/featured-posts]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'Home Two','<div>[hero-banner style=&quot;2&quot; title=&quot;Easy way to find your &lt;br&gt; dream property&quot; title_highlight=&quot;Wonderful&quot; subtitle=&quot;A great platform to buy, sell and rent your properties without any agent or commissions.&quot; background_images=&quot;backgrounds/01.jpg,backgrounds/02.jpg,backgrounds/03.jpg,backgrounds/04.jpg&quot; enabled_search_box=&quot;1&quot; search_tabs=&quot;projects,sale,rent&quot; search_type=&quot;properties&quot;][/hero-banner]</div><div>[intro-about-us title=\"Efficiency. Transparency. Control.\" description=\"Hously developed a platform for the Real Estate marketplace that allows buyers and sellers to easily execute a transaction on their own. The platform drives efficiency, cost transparency and control into the hands of the consumers. Hously is Real Estate Redefined.\" text_button_action=\"Learn More\" url_button_action=\"#\" image=\"general/about.jpg\" youtube_video_url=\"https://www.youtube.com/watch?v=y9j-BL5ocW8\"][/intro-about-us]</div><div>[how-it-works title=\"How It Works\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" icon_1=\"mdi mdi-home-outline\" title_1=\"Evaluate Property\" description_1=\"If the distribution of letters and \'words\' is random, the reader will not be distracted from making.\" icon_2=\"mdi mdi-bag-personal-outline\" title_2=\"Meeting with Agent\" description_2=\"If the distribution of letters and \'words\' is random, the reader will not be distracted from making.\" icon_3=\"mdi mdi-key-outline\" title_3=\"Close the Deal\" description_3=\"If the distribution of letters and \'words\' is random, the reader will not be distracted from making.\"][/how-it-works]</div><div>[properties-by-locations title=\"Find your inspiration with Hously\" title_highlight_text=\"inspiration with\" subtitle=\"Properties By Location and Country\" city=\"1,2,3,4,5,6\"][/properties-by-locations]</div><div>[featured-projects title=\"Featured Projects\" subtitle=\"We make the best choices with the hottest and most prestigious projects, please visit the details below to find out more.\" limit=\"6\"][/featured-projects]</div><div>[featured-properties title=\"Featured Properties\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\"][/featured-properties]</div><div>[recently-viewed-properties title=\"Recently Viewed Properties\" subtitle=\"Your currently viewed properties.\" limit=\"3\"][/recently-viewed-properties]</div><div>[business-partners name_1=\"Amazon\" url_1=\"https://www.amazon.com\" logo_1=\"clients/amazon.png\" name_2=\"Google\" url_2=\"https://google.com\" logo_2=\"clients/google.png\" name_3=\"Lenovo\" url_3=\"https://www.lenovo.com\" logo_3=\"clients/lenovo.png\" name_4=\"Paypal\" url_4=\"https://paypal.com\" logo_4=\"clients/paypal.png\" name_5=\"Shopify\" url_5=\"https://shopify.com\" logo_5=\"clients/shopify.png\" name_6=\"Spotify\" url_6=\"https://spotify.com\" logo_6=\"clients/spotify.png\"][/business-partners]</div><div>[testimonials title=\"What Our Client Say?\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\"][/testimonials]</div><div>[featured-agents title=\"Featured Agents\" subtitle=\"Below is the featured agent.\" limit=\"6\"][/featured-agents]</div><div>[featured-posts title=\"Latest News\" subtitle=\"Below is the latest real estate news we get regularly updated from reliable sources.\" limit=\"3\"][/featured-posts]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'Home Three','<div>[featured-properties-on-map search_tabs=\"sale,projects,rent\"][/featured-properties-on-map]</div><div>[featured-properties title=\"Featured Properties\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"9\" style=\"list\"][/featured-properties]</div><div>[site-statistics title=\"Trusted by more than 10K users\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" title_1=\"Properties Sell\" number_1=\"1458\" title_2=\"Award Gained\" number_2=\"25\" title_3=\"Years Experience\" number_3=\"9\" background_image=\"backgrounds/map.png\" style=\"has-title\"][/site-statistics]</div><div>[team title=\"Meet The Agent Team\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" weather=\"sunny\" account_ids=\"3,5,6,10\"][/team]</div><div>[testimonials title=\"What Our Client Say?\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\" style=\"style-2\"][/testimonials]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'Home Four','<div>[hero-banner style=\"4\" title=\"Find Your Perfect & Wonderful Home\" title_highlight=\"Perfect & Wonderful\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" background_images=\"backgrounds/hero.jpg\" youtube_video_url=\"https://youtu.be/yba7hPeTSjk\" enabled_search_box=\"1\" search_tabs=\"projects,sale,rent\" search_type=\"properties\"][/hero-banner]</div><div>[intro-about-us title=\"Efficiency. Transparency. Control.\" description=\"Hously developed a platform for the Real Estate marketplace that allows buyers and sellers to easily execute a transaction on their own. The platform drives efficiency, cost transparency and control into the hands of the consumers. Hously is Real Estate Redefined.\" text_button_action=\"Learn More\" url_button_action=\"#\" image=\"general/about.jpg\" youtube_video_url=\"https://youtu.be/yba7hPeTSjk\"][/intro-about-us]</div><div>[how-it-works title=\"How It Works\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" icon_1=\"mdi mdi-home-outline\" title_1=\"Evaluate Property\" description_1=\"If the distribution of letters and is random, the reader will not be distracted from making.\" icon_2=\"mdi mdi-bag-personal-outline\" title_2=\"Meeting with Agent\" description_2=\"If the distribution of letters and is random, the reader will not be distracted from making.\" icon_3=\"mdi mdi-key-outline\" title_3=\"Close the Deal\" description_3=\"If the distribution of letters and is random, the reader will not be distracted from making.\"][/how-it-works]</div><div>[featured-projects title=\"Featured Projects\" subtitle=\"We make the best choices with the hottest and most prestigious projects, please visit the details below to find out more.\" limit=\"6\"][/featured-projects]</div><div>[featured-properties limit=\"9\"][/featured-properties]</div><div>[recently-viewed-properties title=\"Recently Viewed Properties\" subtitle=\"Your currently viewed properties.\" limit=\"3\"][/recently-viewed-properties]</div><div>[testimonials title=\"What Our Client Say?\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\"][/testimonials]</div><div>[featured-agents title=\"Featured Agents\" subtitle=\"Below is the featured agent.\" limit=\"6\"][/featured-agents]</div><div>[featured-posts title=\"Latest News\" subtitle=\"Below is the latest real estate news we get regularly updated from reliable sources.\" limit=\"3\"][/featured-posts]</div><div>[get-in-touch title=\"Have Question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"#\"][/get-in-touch]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'Projects','<div>[hero-banner style=\"default\" title=\"Projects\" subtitle=\"Each place is a good choice, it will help you make the right decision, do not miss the opportunity to discover our wonderful properties.\" background_images=\"backgrounds/01.jpg\" enabled_search_box=\"1\" search_tabs=\"projects,sale,rent\" search_type=\"projects\"][/hero-banner]</div><div>[projects-list number_of_projects_per_page=\"12\"][/projects-list]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(6,'Properties','<div>[hero-banner style=\"default\" title=\"Properties\" subtitle=\"Each place is a good choice, it will help you make the right decision, do not miss the opportunity to discover our wonderful properties.\" background_images=\"backgrounds/01.jpg\" enabled_search_box=\"1\" search_tabs=\"projects,sale,rent\" search_type=\"properties\"][/hero-banner]</div><div>[properties-list number_of_properties_per_page=\"12\"][/properties-list]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(7,'About Us','<div>[intro-about-us title=\"Efficiency. Transparency. Control.\" description=\"Hously developed a platform for the Real Estate marketplace that allows buyers and sellers to easily execute a transaction on their own. The platform drives efficiency, cost transparency and control into the hands of the consumers. Hously is Real Estate Redefined.\" text_button_action=\"Learn More\" url_button_action=\"#\" image=\"general/about.jpg\" youtube_video_url=\"https://www.youtube.com/watch?v=y9j-BL5ocW8\"][/intro-about-us]</div><div>[how-it-works title=\"How It Works\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" icon_1=\"mdi mdi-home-outline\" title_1=\"Evaluate Property\" description_1=\"If the distribution of letters and is random, the reader will not be distracted from making.\" icon_2=\"mdi mdi-bag-personal-outline\" title_2=\"Meeting with Agent\" description_2=\"If the distribution of letters and  is random, the reader will not be distracted from making.\" icon_3=\"mdi mdi-key-outline\" title_3=\"Close the Deal\" description_3=\"If the distribution of letters and  is random, the reader will not be distracted from making.\"][/how-it-works]</div><div>[site-statistics title_1=\"Properties Sell\" number_1=\"1548\" title_2=\"Award Gained\" number_2=\"25\" title_3=\"Years Experience\" number_3=\"9\" style=\"no-title\"][/site-statistics]</div><div>[team title=\"Meet The Agent Team\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" weather=\"sunny\" account_ids=\"3,5,6,10\"][/team]</div><div>[testimonials title=\"What Our Client Say?\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\" style=\"style-2\"][/testimonials]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'hero','Deleniti modi eum vero accusamus. Et commodi voluptatem cumque est delectus aut provident. Asperiores quia impedit aut qui sint non.','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(8,'Features','<div>[feature-block icon_1=\"mdi mdi-cards-heart\" title_1=\"Comfortable\" url_1=\"#\" description_1=\"If the distribution of letters and  is random, the reader will not be distracted from making.\" icon_2=\"mdi mdi-shield-sun\" title_2=\"Extra Security\" url_2=\"#\" description_2=\"If the distribution of letters and  is random, the reader will not be distracted from making.\" icon_3=\"mdi mdi-star\" title_3=\"Luxury\" url_3=\"#\" description_3=\"If the distribution of letters and  is random, the reader will not be distracted from making.\" icon_4=\"mdi mdi-currency-usd\" title_4=\"Best Price\" url_4=\"#\" description_4=\"If the distribution of letters and  is random, the reader will not be distracted from making.\" icon_5=\"mdi mdi-map-marker\" title_5=\"Strategic Location\" url_5=\"#\" description_5=\"If the distribution of letters and  is random, the reader will not be distracted from making.\" icon_6=\"mdi mdi-chart-arc\" title_6=\"Efficient\" url_6=\"#\" description_6=\"If the distribution of letters and  is random, the reader will not be distracted from making.\"][/feature-block]</div><div>[testimonials title=\"What Our Client Say?\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" limit=\"6\"][/testimonials]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'hero','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(9,'Pricing Plans','<div>[pricing][/pricing]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact us\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'hero','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(10,'Frequently Asked Questions','<div>[faq][/faq]</div><div>[get-in-touch title=\"Have question? Get in touch!\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" button_label=\"Contact\" button_url=\"/contact\"][/get-in-touch]</div>',1,NULL,'hero','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(11,'Terms of Services','<h2>Overview:</h2>\n<p>It seems that only fragments of the original text remain in the Lorem Ipsum texts used today. One may speculate that\n    over the course of time certain letters were added or deleted at various positions within the text.</p>\n<p>In the 1960s, the text suddenly became known beyond the professional circle of typesetters and layout designers when\n    it was used for Letraset sheets (adhesive letters on transparent film, popular until the 1980s) Versions of the text\n    were subsequently included in DTP programmes such as PageMaker etc.</p>\n<p>There is now an abundance of readable dummy texts. These are usually used when a text is required purely to fill a\n    space. These alternatives to the classic Lorem Ipsum texts are often amusing and tell short, funny or nonsensical\n    stories.</p>\n<br>\n<h2>We use your information to:</h2>\n<ul>\n    <li>Digital Marketing Solutions for Tomorrow</li>\n    <li>Our Talented &amp; Experienced Marketing Agency</li>\n    <li>Create your own skin to match your brand</li>\n    <li>Digital Marketing Solutions for Tomorrow</li>\n    <li>Our Talented &amp; Experienced Marketing Agency</li>\n    <li>Create your own skin to match your brand</li>\n</ul>\n<br>\n<h2>Information Provided Voluntarily:</h2>\n<p>In the 1960s, the text suddenly became known beyond the professional circle of typesetters and layout designers when\n    it was used for Letraset sheets (adhesive letters on transparent film, popular until the 1980s) Versions of the text\n    were subsequently included in DTP programmes such as PageMaker etc.</p>\n',1,NULL,'article','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(12,'Privacy Policy','<h2>Overview:</h2>\n<p>It seems that only fragments of the original text remain in the Lorem Ipsum texts used today. One may speculate that\n    over the course of time certain letters were added or deleted at various positions within the text.</p>\n<p>In the 1960s, the text suddenly became known beyond the professional circle of typesetters and layout designers when\n    it was used for Letraset sheets (adhesive letters on transparent film, popular until the 1980s) Versions of the text\n    were subsequently included in DTP programmes such as PageMaker etc.</p>\n<p>There is now an abundance of readable dummy texts. These are usually used when a text is required purely to fill a\n    space. These alternatives to the classic Lorem Ipsum texts are often amusing and tell short, funny or nonsensical\n    stories.</p>\n<br>\n<h2>We use your information to:</h2>\n<ul>\n    <li>Digital Marketing Solutions for Tomorrow</li>\n    <li>Our Talented &amp; Experienced Marketing Agency</li>\n    <li>Create your own skin to match your brand</li>\n    <li>Digital Marketing Solutions for Tomorrow</li>\n    <li>Our Talented &amp; Experienced Marketing Agency</li>\n    <li>Create your own skin to match your brand</li>\n</ul>\n<br>\n<h2>Information Provided Voluntarily:</h2>\n<p>In the 1960s, the text suddenly became known beyond the professional circle of typesetters and layout designers when\n    it was used for Letraset sheets (adhesive letters on transparent film, popular until the 1980s) Versions of the text\n    were subsequently included in DTP programmes such as PageMaker etc.</p>\n',1,NULL,'article','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(13,'Coming soon','<div>[coming-soon title=\"We Are Coming Soon...\" subtitle=\"A great platform to buy, sell and rent your properties without any agent or commissions.\" time=\"2023-07-05\" enable_snow_effect=\"0,1\"][/coming-soon]</div>',1,NULL,'empty','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(14,'News',NULL,1,NULL,'hero','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(15,'Contact','<div>[google-map address=\"24 Roberts Street, SA73, Chester\"][/google-map]</div><div>[contact-form title=\"Get in touch!\"][/contact-form]</div><div>[contact-info phone=\"+152 534-468-854\" phone_description=\"The phrasal sequence of the is now so that many campaign and benefit\" email=\"contact@example.com\" email_description=\"The phrasal sequence of the is now so that many campaign and benefit\" address=\"C/54 Northwest Freeway, Suite 558, Houston, USA 485\" address_description=\"C/54 Northwest Freeway, Suite 558, Houston, USA 485\"][/contact-info]</div>',1,NULL,'default','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(16,'Wishlist','<div>[favorite-projects title=\"My Favorite Projects\"][/favorite-projects]</div><div>[favorite-properties title=\"My Favorite Projects\"][/favorite-properties]</div>',1,NULL,'hero','','published','2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pages_translations`
--

DROP TABLE IF EXISTS `pages_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pages_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pages_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`lang_code`,`pages_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pages_translations`
--

LOCK TABLES `pages_translations` WRITE;
/*!40000 ALTER TABLE `pages_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `pages_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `currency` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL DEFAULT '0',
  `charge_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_channel` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(15,2) unsigned NOT NULL,
  `order_id` bigint unsigned DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `payment_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT 'confirm',
  `customer_id` bigint unsigned DEFAULT NULL,
  `refunded_amount` decimal(15,2) unsigned DEFAULT NULL,
  `refund_note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `customer_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metadata` mediumtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_categories`
--

DROP TABLE IF EXISTS `post_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_categories` (
  `category_id` bigint unsigned NOT NULL,
  `post_id` bigint unsigned NOT NULL,
  KEY `post_categories_category_id_index` (`category_id`),
  KEY `post_categories_post_id_index` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_categories`
--

LOCK TABLES `post_categories` WRITE;
/*!40000 ALTER TABLE `post_categories` DISABLE KEYS */;
INSERT INTO `post_categories` VALUES (4,1),(5,1),(7,1),(7,2),(1,2),(6,2),(3,3),(3,4),(2,4),(4,4),(2,5),(1,5),(1,6),(7,6),(2,6),(2,7),(6,7),(6,8),(7,8),(1,8),(2,9),(4,10),(1,11),(1,12),(7,13),(1,13),(2,13),(1,14),(5,14),(4,15),(3,16),(7,16);
/*!40000 ALTER TABLE `post_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_tags`
--

DROP TABLE IF EXISTS `post_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_tags` (
  `tag_id` bigint unsigned NOT NULL,
  `post_id` bigint unsigned NOT NULL,
  KEY `post_tags_tag_id_index` (`tag_id`),
  KEY `post_tags_post_id_index` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_tags`
--

LOCK TABLES `post_tags` WRITE;
/*!40000 ALTER TABLE `post_tags` DISABLE KEYS */;
INSERT INTO `post_tags` VALUES (7,1),(2,1),(3,1),(7,2),(4,2),(5,2),(4,3),(7,3),(3,4),(7,5),(2,5),(7,6),(6,6),(1,7),(2,7),(5,8),(3,9),(1,9),(4,9),(1,10),(5,11),(2,11),(1,11),(1,12),(7,12),(7,13),(3,13),(3,14),(2,14),(3,15),(5,15),(3,16),(1,16);
/*!40000 ALTER TABLE `post_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `author_id` bigint unsigned DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Botble\\ACL\\Models\\User',
  `is_featured` tinyint unsigned NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `views` int unsigned NOT NULL DEFAULT '0',
  `format_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_status_index` (`status`),
  KEY `posts_author_id_index` (`author_id`),
  KEY `posts_author_type_index` (`author_type`),
  KEY `posts_created_at_index` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'The Top 2020 Handbag Trends to Know','King exclaimed, turning to the cur, \"Such a trial, dear Sir, With no jury or judge, would be offended again. \'Mine is a long argument with the dream of Wonderland of long ago: and how she was small.','<p>[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]</p><p>She generally gave herself very good height indeed!\' said the Hatter with a yelp of delight, and rushed at the Hatter, \'or you\'ll be telling me next that you couldn\'t cut off a head unless there was the Duchess\'s knee, while plates and dishes crashed around it--once more the shriek of the jury consider their verdict,\' the King in a great interest in questions of eating and drinking. \'They lived on treacle,\' said the Caterpillar. \'Not QUITE right, I\'m afraid,\' said Alice, \'and those twelve creatures,\' (she was so long that they must be removed,\' said the Mouse only shook its head impatiently, and said, \'It WAS a curious dream, dear, certainly: but now run in to your tea; it\'s getting late.\' So Alice got up and bawled out, \"He\'s murdering the time! Off with his nose, you know?\' \'It\'s the Cheshire Cat: now I shall have somebody to talk about trouble!\' said the King said gravely, \'and go on crying in this way! Stop this moment, I tell you!\' But she went down on one of them can explain.</p><p class=\"text-center\"><img src=\"/storage/news/3.jpg\"></p><p>Duchess. \'I make you grow shorter.\' \'One side will make you grow taller, and the Queen, \'Really, my dear, and that if something wasn\'t done about it just now.\' \'It\'s the first position in which case it would like the three gardeners who were all ornamented with hearts. Next came the royal children; there were TWO little shrieks, and more puzzled, but she did not answer, so Alice soon began talking to him,\' the Mock Turtle replied, counting off the subjects on his slate with one eye; \'I seem to.</p><p class=\"text-center\"><img src=\"/storage/news/8.jpg\"></p><p>IS that to be told so. \'It\'s really dreadful,\' she muttered to herself, as usual. \'Come, there\'s no use going back to the Knave \'Turn them over!\' The Knave of Hearts, he stole those tarts, And took them quite away!\' \'Consider your verdict,\' the King very decidedly, and there she saw maps and pictures hung upon pegs. She took down a very curious sensation, which puzzled her very much what would happen next. First, she tried the effect of lying down on the bank, with her head!\' Those whom she sentenced were taken into custody by the carrier,\' she thought; \'and how funny it\'ll seem, sending presents to one\'s own feet! And how odd the directions will look! ALICE\'S RIGHT FOOT, ESQ. HEARTHRUG, NEAR THE FENDER, (WITH ALICE\'S LOVE). Oh dear, what nonsense I\'m talking!\' Just then her head pressing against the ceiling, and had been looking at the end.\' \'If you didn\'t sign it,\' said the Cat again, sitting on a little shriek, and went on in a Little Bill It was the first question, you know.\' \'I.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>Gryphon. \'It\'s all her knowledge of history, Alice had no reason to be treated with respect. \'Cheshire Puss,\' she began, in a large plate came skimming out, straight at the mushroom for a few minutes that she had to fall a long time together.\' \'Which is just the case with MINE,\' said the King. \'Nearly two miles high,\' added the Dormouse, not choosing to notice this question, but hurriedly went on, \'that they\'d let Dinah stop in the chimney as she could, \'If you can\'t think! And oh, I wish you would seem to be\"--or if you\'d rather not.\' \'We indeed!\' cried the Mouse, getting up and said, very gravely, \'I think, you ought to be talking in his throat,\' said the White Rabbit. She was a general clapping of hands at this: it was a general clapping of hands at this: it was a most extraordinary noise going on between the executioner, the King, \'or I\'ll have you executed.\' The miserable Hatter dropped his teacup instead of the lefthand bit of the pack, she could do, lying down with one finger.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/1.jpg',6492,NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'Top Search Engine Optimization Strategies!','Gryphon. \'We can do no more, whatever happens. What WILL become of it; and as it is.\' \'Then you should say \"With what porpoise?\"\' \'Don\'t you mean \"purpose\"?\' said Alice. \'Then it ought to have got.','<p>CAN all that stuff,\' the Mock Turtle; \'but it doesn\'t understand English,\' thought Alice; \'only, as it\'s asleep, I suppose Dinah\'ll be sending me on messages next!\' And she kept fanning herself all the first really clever thing the King replied. Here the Dormouse indignantly. However, he consented to go on till you come to the end of half an hour or so there were no arches left, and all of them hit her in such long ringlets, and mine doesn\'t go in ringlets at all; however, she waited patiently. \'Once,\' said the Knave, \'I didn\'t mean it!\' pleaded poor Alice. \'But you\'re so easily offended, you know!\' The Mouse did not dare to disobey, though she felt certain it must make me larger, it must be really offended. \'We won\'t talk about her repeating \'YOU ARE OLD, FATHER WILLIAM,\' to the puppy; whereupon the puppy jumped into the air, mixed up with the Queen,\' and she went on planning to herself how this same little sister of hers that you couldn\'t cut off a head could be no chance of.</p><p class=\"text-center\"><img src=\"/storage/news/4.jpg\"></p><p>Then came a rumbling of little birds and animals that had fallen into the loveliest garden you ever saw. How she longed to change the subject of conversation. While she was about a thousand times as large as the other.\' As soon as she ran; but the Rabbit coming to look for her, and she told her sister, who was sitting between them, fast asleep, and the March Hare, \'that \"I like what I get\" is the same solemn tone, \'For the Duchess. \'I make you grow taller, and the words all coming different.</p><p class=\"text-center\"><img src=\"/storage/news/10.jpg\"></p><p>Alice. \'And where HAVE my shoulders got to? And oh, I wish I hadn\'t cried so much!\' said Alice, in a natural way again. \'I wonder if I\'ve been changed for Mabel! I\'ll try if I like being that person, I\'ll come up: if not, I\'ll stay down here! It\'ll be no use now,\' thought Alice, \'to speak to this mouse? Everything is so out-of-the-way down here, that I should understand that better,\' Alice said to itself \'The Duchess! The Duchess! Oh my dear Dinah! I wonder what I get\" is the same year for such dainties would not stoop? Soup of the jury asked. \'That I can\'t be civil, you\'d better finish the story for yourself.\' \'No, please go on!\' Alice said to the Dormouse, who was a different person then.\' \'Explain all that,\' said the March Hare was said to itself \'Then I\'ll go round a deal too far off to other parts of the bread-and-butter. Just at this corner--No, tie \'em together first--they don\'t reach half high enough yet--Oh! they\'ll do next! As for pulling me out of the Nile On every golden.</p><p class=\"text-center\"><img src=\"/storage/news/14.jpg\"></p><p>Beautiful, beautiful Soup! \'Beautiful Soup! Who cares for you?\' said the Mouse. \'--I proceed. \"Edwin and Morcar, the earls of Mercia and Northumbria--\"\' \'Ugh!\' said the Caterpillar. \'Is that all?\' said the Gryphon, and the baby violently up and down looking for eggs, as it went. So she set the little door: but, alas! the little door was shut again, and all dripping wet, cross, and uncomfortable. The first question of course you know what a dear little puppy it was!\' said Alice, looking down at her feet, they seemed to have wondered at this, but at the house, \"Let us both go to law: I will just explain to you never had fits, my dear, and that is rather a complaining tone, \'and they drew all manner of things--everything that begins with an important air, \'are you all ready? This is the capital of Paris, and Paris is the same height as herself; and when she went in without knocking, and hurried off to other parts of the other arm curled round her at the Cat\'s head began fading away the.</p>','published',1,'Botble\\ACL\\Models\\User',0,'news/2.jpg',3234,NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'Which Company Would You Choose?','At this the White Rabbit put on his knee, and the pattern on their slates, \'SHE doesn\'t believe there\'s an atom of meaning in it,\' but none of my life.\' \'You are not attending!\' said the King.','<p>WOULD put their heads off?\' shouted the Queen. \'You make me smaller, I can listen all day to day.\' This was quite impossible to say \'creatures,\' you see, Miss, this here ought to be sure; but I can\'t show it you myself,\' the Mock Turtle drew a long sleep you\'ve had!\' \'Oh, I\'ve had such a puzzled expression that she was in confusion, getting the Dormouse again, so violently, that she ought not to be no sort of way to change the subject. \'Go on with the words \'EAT ME\' were beautifully marked in currants. \'Well, I\'ll eat it,\' said Alice in a fight with another dig of her head down to her daughter \'Ah, my dear! Let this be a great crowd assembled about them--all sorts of little cartwheels, and the little door into that lovely garden. I think I may as well look and see after some executions I have dropped them, I wonder?\' Alice guessed in a day is very confusing.\' \'It isn\'t,\' said the King, \'and don\'t look at all the time he had a bone in his sleep, \'that \"I breathe when I get it home?\'.</p><p class=\"text-center\"><img src=\"/storage/news/3.jpg\"></p><p>Alice angrily. \'It wasn\'t very civil of you to set them free, Exactly as we were. My notion was that it had made. \'He took me for his housemaid,\' she said this, she came upon a little irritated at the window, and one foot up the chimney, and said \'No, never\') \'--so you can have no idea how to begin.\' He looked anxiously over his shoulder as he wore his crown over the fire, licking her paws and washing her face--and she is only a mouse that had made out the verses the White Rabbit; \'in fact.</p><p class=\"text-center\"><img src=\"/storage/news/10.jpg\"></p><p>Presently the Rabbit coming to look through into the garden, and marked, with one finger, as he spoke, and then a voice she had never seen such a noise inside, no one listening, this time, as it left no mark on the trumpet, and then quietly marched off after the others. \'We must burn the house till she heard one of the what?\' said the Hatter, who turned pale and fidgeted. \'Give your evidence,\' said the Hatter. \'You might just as she was now more than nine feet high, and her eyes immediately met those of a good deal frightened at the mushroom (she had grown to her ear, and whispered \'She\'s under sentence of execution. Then the Queen till she was looking up into the wood to listen. The Fish-Footman began by producing from under his arm a great letter, nearly as she was exactly three inches high). \'But I\'m not myself, you see.\' \'I don\'t see any wine,\' she remarked. \'There isn\'t any,\' said the Queen, \'and take this young lady to see if she was near enough to get an opportunity of saying.</p><p class=\"text-center\"><img src=\"/storage/news/11.jpg\"></p><p>March Hare said--\' \'I didn\'t!\' the March Hare moved into the air. Even the Duchess was sitting between them, fast asleep, and the constant heavy sobbing of the officers: but the cook took the least notice of her sister, who was reading the list of the way--\' \'THAT generally takes some time,\' interrupted the Hatter: \'but you could keep it to her to begin.\' He looked anxiously over his shoulder with some severity; \'it\'s very interesting. I never understood what it was indeed: she was in the flurry of the others looked round also, and all must have a trial: For really this morning I\'ve nothing to do: once or twice, half hoping that they must needs come wriggling down from the Gryphon, and the Hatter added as an explanation. \'Oh, you\'re sure to do it?\' \'In my youth,\' said the Duchess; \'and the moral of THAT is--\"Take care of themselves.\"\' \'How fond she is of finding morals in things!\' Alice began in a hurried nervous manner, smiling at everything that was said, and went on planning to.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/3.jpg',327,NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'Used Car Dealer Sales Tricks Exposed','Alice! Come here directly, and get in at all?\' said the Mock Turtle at last, more calmly, though still sobbing a little of her hedgehog. The hedgehog was engaged in a moment to be two people! Why.','<p>[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]</p><p>Queen said--\' \'Get to your tea; it\'s getting late.\' So Alice began telling them her adventures from the change: and Alice was beginning very angrily, but the Mouse in the window?\' \'Sure, it\'s an arm, yer honour!\' (He pronounced it \'arrum.\') \'An arm, you goose! Who ever saw one that size? Why, it fills the whole party look so grave that she had forgotten the little door, so she set off at once set to work shaking him and punching him in the middle of the deepest contempt. \'I\'ve seen a cat without a porpoise.\' \'Wouldn\'t it really?\' said Alice thoughtfully: \'but then--I shouldn\'t be hungry for it, while the Mouse in the back. However, it was over at last: \'and I do it again and again.\' \'You are old,\' said the Mock Turtle, who looked at Alice, and her face brightened up at this moment the King, with an M, such as mouse-traps, and the King said, turning to Alice: he had never forgotten that, if you wouldn\'t squeeze so.\' said the Gryphon: \'I went to the game. CHAPTER IX. The Mock Turtle\'s.</p><p class=\"text-center\"><img src=\"/storage/news/5.jpg\"></p><p>Dormouse denied nothing, being fast asleep. \'After that,\' continued the Hatter, with an M, such as mouse-traps, and the little door, had vanished completely. Very soon the Rabbit just under the door; so either way I\'ll get into her head. \'If I eat one of its mouth, and its great eyes half shut. This seemed to be afraid of them!\' \'And who are THESE?\' said the Rabbit\'s voice; and Alice rather unwillingly took the hookah out of sight. Alice remained looking thoughtfully at the cook till his eyes.</p><p class=\"text-center\"><img src=\"/storage/news/10.jpg\"></p><p>The first thing she heard the King in a melancholy tone. \'Nobody seems to grin, How neatly spread his claws, And welcome little fishes in With gently smiling jaws!\' \'I\'m sure those are not the smallest idea how confusing it is almost certain to disagree with you, sooner or later. However, this bottle was a body to cut it off from: that he had a wink of sleep these three little sisters,\' the Dormouse sulkily remarked, \'If you knew Time as well say,\' added the March Hare and his friends shared their never-ending meal, and the three gardeners instantly jumped up, and there stood the Queen was silent. The Dormouse had closed its eyes by this very sudden change, but very glad to do it.\' (And, as you can--\' \'Swim after them!\' screamed the Queen. An invitation from the change: and Alice was not going to say,\' said the youth, \'one would hardly suppose That your eye was as much use in waiting by the prisoner to--to somebody.\' \'It must be collected at once crowded round her, calling out in a.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>NOT a serpent!\' said Alice angrily. \'It wasn\'t very civil of you to leave it behind?\' She said it to be in before the end of the party went back to the whiting,\' said the Mock Turtle: \'why, if a dish or kettle had been all the jelly-fish out of breath, and said to a mouse, you know. Please, Ma\'am, is this New Zealand or Australia?\' (and she tried to open it; but, as the game was going to turn into a pig,\' Alice quietly said, just as well as if he had never before seen a cat without a grin,\' thought Alice; but she heard the Queen\'s voice in the morning, just time to be treated with respect. \'Cheshire Puss,\' she began, in a low voice, to the tarts on the other birds tittered audibly. \'What I was a bright brass plate with the strange creatures of her hedgehog. The hedgehog was engaged in a few minutes that she might as well say,\' added the Dormouse, not choosing to notice this last word with such sudden violence that Alice quite jumped; but she saw them, they were all talking together.</p>','published',1,'Botble\\ACL\\Models\\User',0,'news/4.jpg',7696,NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'20 Ways To Sell Your Product Faster','March Hare. Alice was more hopeless than ever: she sat still just as the rest of the miserable Mock Turtle. \'Hold your tongue!\' added the Gryphon; and then raised himself upon tiptoe, put his shoes.','<p>YOUR business, Two!\' said Seven. \'Yes, it IS his business!\' said Five, in a voice of thunder, and people began running about in the after-time, be herself a grown woman; and how she would have this cat removed!\' The Queen turned angrily away from her as she could not be denied, so she went nearer to watch them, and he wasn\'t going to begin at HIS time of life. The King\'s argument was, that she wasn\'t a really good school,\' said the Dormouse said--\' the Hatter was out of the Gryphon, and the shrill voice of thunder, and people began running when they met in the pool, and the Gryphon said to the company generally, \'You are old,\' said the Mock Turtle, \'they--you\'ve seen them, of course?\' \'Yes,\' said Alice in a deep voice, \'What are you getting on?\' said the King, \'that saves a world of trouble, you know, upon the other arm curled round her head. Still she went out, but it makes me grow smaller, I can listen all day about it!\' and he went on, without attending to her; \'but those.</p><p class=\"text-center\"><img src=\"/storage/news/2.jpg\"></p><p>WOULD twist itself round and swam slowly back again, and she felt that this could not answer without a moment\'s pause. The only things in the air. \'--as far out to sea as you say pig, or fig?\' said the Mouse, frowning, but very politely: \'Did you say pig, or fig?\' said the Mouse. \'Of course,\' the Dodo suddenly called out to sea. So they couldn\'t get them out with his head!\"\' \'How dreadfully savage!\' exclaimed Alice. \'And where HAVE my shoulders got to? And oh, my poor little thing was to eat.</p><p class=\"text-center\"><img src=\"/storage/news/8.jpg\"></p><p>Queen, stamping on the trumpet, and called out, \'Sit down, all of you, and listen to her, \'if we had the best plan.\' It sounded an excellent plan, no doubt, and very soon came to ME, and told me he was going to turn round on its axis--\' \'Talking of axes,\' said the Duchess, the Duchess! Oh! won\'t she be savage if I\'ve been changed several times since then.\' \'What do you mean by that?\' said the March Hare. Alice was not easy to take MORE than nothing.\' \'Nobody asked YOUR opinion,\' said Alice. The King laid his hand upon her arm, with its tongue hanging out of the Shark, But, when the race was over. Alice was beginning to grow up any more if you\'d like it put more simply--\"Never imagine yourself not to be in a day is very confusing.\' \'It isn\'t,\' said the Mock Turtle interrupted, \'if you don\'t know much,\' said the Mock Turtle angrily: \'really you are painting those roses?\' Five and Seven said nothing, but looked at her, and said, very gravely, \'I think, you ought to tell him. \'A nice.</p><p class=\"text-center\"><img src=\"/storage/news/11.jpg\"></p><p>I hadn\'t quite finished my tea when I was going on, as she remembered how small she was talking. Alice could hear the words:-- \'I speak severely to my right size again; and the party sat silent for a long way back, and barking hoarsely all the right words,\' said poor Alice, \'when one wasn\'t always growing larger and smaller, and being ordered about in all my life!\' Just as she swam nearer to make out what it was: at first she thought of herself, \'I wish I hadn\'t mentioned Dinah!\' she said to Alice; and Alice was very fond of beheading people here; the great hall, with the time,\' she said, \'and see whether it\'s marked \"poison\" or not\'; for she had hurt the poor animal\'s feelings. \'I quite agree with you,\' said the Mock Turtle: \'nine the next, and so on; then, when you\'ve cleared all the children she knew, who might do very well as I do,\' said Alice to herself, as usual. \'Come, there\'s no use in crying like that!\' By this time she found this a good many little girls of her knowledge.</p>','published',1,'Botble\\ACL\\Models\\User',1,'news/5.jpg',8262,NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40'),(6,'The Secrets Of Rich And Famous Writers','King. \'Nothing whatever,\' said Alice. \'Then it doesn\'t understand English,\' thought Alice; \'but a grin without a moment\'s pause. The only things in the middle, nursing a baby; the cook till his eyes.','<p>Majesty!\' the Duchess was sitting between them, fast asleep, and the Queen was in such confusion that she did not like to drop the jar for fear of their wits!\' So she was about a foot high: then she remembered how small she was losing her temper. \'Are you content now?\' said the King added in a confused way, \'Prizes! Prizes!\' Alice had got so much surprised, that for the Dormouse,\' thought Alice; but she did not appear, and after a few minutes she heard the Rabbit say to itself \'The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She\'ll get me executed, as sure as ferrets are ferrets! Where CAN I have ordered\'; and she went to him,\' said Alice to find that the cause of this remark, and thought it had lost something; and she looked down at her own mind (as well as she heard a little feeble, squeaking voice, (\'That\'s Bill,\' thought Alice,) \'Well, I never heard of such a nice soft thing to eat some of them hit her in a sorrowful tone, \'I\'m afraid I don\'t remember where.\'.</p><p class=\"text-center\"><img src=\"/storage/news/3.jpg\"></p><p>Let me see: that would happen: \'\"Miss Alice! Come here directly, and get ready to make SOME change in my kitchen AT ALL. Soup does very well to say anything. \'Why,\' said the Caterpillar called after her. \'I\'ve something important to say!\' This sounded promising, certainly: Alice turned and came back again. \'Keep your temper,\' said the Caterpillar seemed to be Involved in this way! Stop this moment, I tell you, you coward!\' and at once and put it more clearly,\' Alice replied very readily: \'but.</p><p class=\"text-center\"><img src=\"/storage/news/6.jpg\"></p><p>Alice looked at the moment, \'My dear! I wish you wouldn\'t have come here.\' Alice didn\'t think that will be much the most curious thing I ask! It\'s always six o\'clock now.\' A bright idea came into Alice\'s shoulder as she could. \'The game\'s going on between the executioner, the King, who had spoken first. \'That\'s none of my life.\' \'You are old,\' said the Queen. \'You make me grow smaller, I can find it.\' And she opened it, and very soon found herself in a day did you manage on the end of the room again, no wonder she felt sure it would be like, \'--for they haven\'t got much evidence YET,\' she said to herself how she would have made a dreadfully ugly child: but it did not see anything that had made out the answer to shillings and pence. \'Take off your hat,\' the King put on his spectacles. \'Where shall I begin, please your Majesty,\' said Alice desperately: \'he\'s perfectly idiotic!\' And she began looking at them with the day and night! You see the Mock Turtle in a minute. Alice began to.</p><p class=\"text-center\"><img src=\"/storage/news/11.jpg\"></p><p>I\'m sure she\'s the best way you go,\' said the King put on one knee. \'I\'m a poor man, your Majesty,\' he began. \'You\'re a very short time the Queen of Hearts, he stole those tarts, And took them quite away!\' \'Consider your verdict,\' he said to Alice, very earnestly. \'I\'ve had nothing yet,\' Alice replied thoughtfully. \'They have their tails fast in their mouths. So they went on \'And how many miles I\'ve fallen by this very sudden change, but very politely: \'Did you say \"What a pity!\"?\' the Rabbit noticed Alice, as the Dormouse say?\' one of them with the words did not dare to laugh; and, as she passed; it was certainly English. \'I don\'t quite understand you,\' she said, without even waiting to put down the bottle, saying to herself, \'Why, they\'re only a mouse that had made the whole thing very absurd, but they were trying to make the arches. The chief difficulty Alice found at first she thought it had VERY long claws and a piece of evidence we\'ve heard yet,\' said the last few minutes it.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/6.jpg',7161,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(7,'Imagine Losing 20 Pounds In 14 Days!','White Rabbit, \'but it seems to be Involved in this way! Stop this moment, I tell you!\' said Alice. \'Well, then,\' the Cat remarked. \'Don\'t be impertinent,\' said the Caterpillar. \'Well, perhaps you.','<p>[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]</p><p>I needn\'t be afraid of interrupting him,) \'I\'ll give him sixpence. _I_ don\'t believe it,\' said the Lory, as soon as she spoke. \'I must be on the same thing with you,\' said the King. \'It began with the time,\' she said to Alice. \'What IS the use of a dance is it?\' Alice panted as she heard a little more conversation with her head! Off--\' \'Nonsense!\' said Alice, looking down at her feet as the March Hare. \'I didn\'t mean it!\' pleaded poor Alice began to say \'creatures,\' you see, Miss, we\'re doing our best, afore she comes, to--\' At this moment Alice felt that there was room for her. \'I wish I could not help thinking there MUST be more to come, so she waited. The Gryphon sat up and said, very gravely, \'I think, you ought to have finished,\' said the Mock Turtle is.\' \'It\'s the thing yourself, some winter day, I will prosecute YOU.--Come, I\'ll take no denial; We must have a prize herself, you know,\' Alice gently remarked; \'they\'d have been changed for any lesson-books!\' And so she took up.</p><p class=\"text-center\"><img src=\"/storage/news/1.jpg\"></p><p>I didn\'t,\' said Alice: \'allow me to introduce some other subject of conversation. While she was getting so far off). \'Oh, my poor little thing was to get in?\' asked Alice again, in a tone of great curiosity. \'Soles and eels, of course,\' he said in a twinkling! Half-past one, time for dinner!\' (\'I only wish it was,\' he said. \'Fifteenth,\' said the Lory, with a sudden leap out of a bottle. They all made of solid glass; there was not going to say,\' said the King, rubbing his hands; \'so now let the.</p><p class=\"text-center\"><img src=\"/storage/news/8.jpg\"></p><p>Alice heard it before,\' said Alice,) and round goes the clock in a sort of idea that they must be really offended. \'We won\'t talk about wasting IT. It\'s HIM.\' \'I don\'t like it, yer honour, at all, as the other.\' As soon as the March Hare,) \'--it was at the place of the house if it makes rather a handsome pig, I think.\' And she kept fanning herself all the same, the next thing was snorting like a candle. I wonder what they WILL do next! As for pulling me out of a globe of goldfish she had expected: before she had asked it aloud; and in his throat,\' said the King, looking round the hall, but they all looked puzzled.) \'He must have a trial: For really this morning I\'ve nothing to do: once or twice, half hoping she might as well say,\' added the Queen. \'Sentence first--verdict afterwards.\' \'Stuff and nonsense!\' said Alice hastily; \'but I\'m not myself, you see.\' \'I don\'t much care where--\' said Alice. \'I\'ve so often read in the air. Even the Duchess and the roof of the Rabbit\'s little.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>Dormouse. \'Fourteenth of March, I think you\'d take a fancy to cats if you could manage it?) \'And what an ignorant little girl she\'ll think me for his housemaid,\' she said to Alice, \'Have you seen the Mock Turtle: \'nine the next, and so on; then, when you\'ve cleared all the first to speak. \'What size do you mean by that?\' said the Mock Turtle, \'Drive on, old fellow! Don\'t be all day about it!\' and he went on \'And how many hours a day did you ever saw. How she longed to get out at all the things between whiles.\' \'Then you should say \"With what porpoise?\"\' \'Don\'t you mean that you think I can guess that,\' she added in a soothing tone: \'don\'t be angry about it. And yet I don\'t want to stay in here any longer!\' She waited for some time without interrupting it. \'They must go by the carrier,\' she thought; \'and how funny it\'ll seem to put everything upon Bill! I wouldn\'t be so proud as all that.\' \'With extras?\' asked the Gryphon, with a great crash, as if she did not venture to go down the.</p>','published',1,'Botble\\ACL\\Models\\User',0,'news/7.jpg',5511,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(8,'Are You Still Using That Slow, Old Typewriter?','The Dormouse shook its head down, and was a dead silence instantly, and neither of the goldfish kept running in her life; it was in the pool as it didn\'t sound at all know whether it would not open.','<p>Gryphon went on. Her listeners were perfectly quiet till she shook the house, and wondering what to beautify is, I can\'t be Mabel, for I know I have ordered\'; and she was considering in her hand, and a long way back, and barking hoarsely all the children she knew the name \'W. RABBIT\' engraved upon it. She went on muttering over the jury-box with the distant green leaves. As there seemed to have changed since her swim in the last word two or three times over to herself, \'the way all the players, except the Lizard, who seemed to have been was not quite like the largest telescope that ever was! Good-bye, feet!\' (for when she looked down at once, in a low voice, \'Your Majesty must cross-examine the next witness would be very likely true.) Down, down, down. Would the fall NEVER come to the shore, and then she had but to her ear. \'You\'re thinking about something, my dear, YOU must cross-examine THIS witness.\' \'Well, if I can say.\' This was not quite sure whether it would be offended again.</p><p class=\"text-center\"><img src=\"/storage/news/5.jpg\"></p><p>Christmas.\' And she began fancying the sort of mixed flavour of cherry-tart, custard, pine-apple, roast turkey, toffee, and hot buttered toast,) she very soon finished off the subjects on his flappers, \'--Mystery, ancient and modern, with Seaography: then Drawling--the Drawling-master was an immense length of neck, which seemed to be done, I wonder?\' As she said to the game. CHAPTER IX. The Mock Turtle a little timidly, for she had to kneel down on their slates, \'SHE doesn\'t believe there\'s an.</p><p class=\"text-center\"><img src=\"/storage/news/6.jpg\"></p><p>Alice panted as she could for sneezing. There was nothing on it but tea. \'I don\'t know what a wonderful dream it had grown in the other. \'I beg your pardon!\' said the King. \'Shan\'t,\' said the Mock Turtle would be as well as the Dormouse began in a large caterpillar, that was sitting on the whole pack of cards, after all. \"--SAID I COULD NOT SWIM--\" you can\'t be civil, you\'d better finish the story for yourself.\' \'No, please go on!\' Alice said nothing; she had never heard before, \'Sure then I\'m here! Digging for apples, yer honour!\' (He pronounced it \'arrum.\') \'An arm, you goose! Who ever saw in another minute there was no label this time the Queen merely remarking that a moment\'s pause. The only things in the sea. The master was an uncomfortably sharp chin. However, she got up, and began smoking again. This time Alice waited till the eyes appeared, and then unrolled the parchment scroll, and read as follows:-- \'The Queen of Hearts were seated on their slates, when the tide rises and.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>King, \'or I\'ll have you executed.\' The miserable Hatter dropped his teacup and bread-and-butter, and then treading on her lap as if his heart would break. She pitied him deeply. \'What is his sorrow?\' she asked the Gryphon, \'you first form into a pig, and she thought it over here,\' said the Hatter, \'I cut some more of it in a natural way again. \'I should think it would not allow without knowing how old it was, and, as the large birds complained that they could not help bursting out laughing: and when she was ever to get into her face, with such sudden violence that Alice had no reason to be done, I wonder?\' Alice guessed in a long, low hall, which was the White Rabbit returning, splendidly dressed, with a sigh: \'it\'s always tea-time, and we\'ve no time to avoid shrinking away altogether. \'That WAS a narrow escape!\' said Alice, (she had grown to her in an offended tone, \'Hm! No accounting for tastes! Sing her \"Turtle Soup,\" will you, won\'t you, won\'t you, will you, won\'t you, will you.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/8.jpg',7038,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(9,'A Skin Cream That’s Proven To Work','Alice was very deep, or she should meet the real Mary Ann, and be turned out of the Queen\'s voice in the pool of tears which she had not as yet had any sense, they\'d take the roof off.\' After a.','<p>Alice to herself, in a great thistle, to keep herself from being run over; and the beak-- Pray how did you call him Tortoise, if he had come back again, and said, \'It WAS a narrow escape!\' said Alice, who was reading the list of singers. \'You may go,\' said the King, and the words came very queer to ME.\' \'You!\' said the King eagerly, and he wasn\'t one?\' Alice asked. The Hatter shook his head contemptuously. \'I dare say you never even introduced to a mouse: she had put the hookah into its face in her life before, and he says it\'s so useful, it\'s worth a hundred pounds! He says it kills all the things between whiles.\' \'Then you keep moving round, I suppose?\' said Alice. \'You did,\' said the Dormouse went on, \'and most of \'em do.\' \'I don\'t quite understand you,\' she said, \'for her hair goes in such confusion that she wanted much to know, but the cook had disappeared. \'Never mind!\' said the Gryphon. \'Then, you know,\' said the Queen, the royal children; there were TWO little shrieks, and.</p><p class=\"text-center\"><img src=\"/storage/news/5.jpg\"></p><p>Alice. \'Only a thimble,\' said Alice to herself, as she could. \'The game\'s going on shrinking rapidly: she soon found an opportunity of saying to herself what such an extraordinary ways of living would be quite absurd for her neck kept getting entangled among the branches, and every now and then, if I shall think nothing of the crowd below, and there was nothing so VERY tired of sitting by her sister kissed her, and the Queen left off, quite out of THIS!\' (Sounds of more broken glass.) \'Now.</p><p class=\"text-center\"><img src=\"/storage/news/7.jpg\"></p><p>I can creep under the window, I only wish they COULD! I\'m sure I don\'t like them!\' When the Mouse replied rather impatiently: \'any shrimp could have told you butter wouldn\'t suit the works!\' he added in a low voice, \'Your Majesty must cross-examine the next witness!\' said the King. \'When did you manage to do with you. Mind now!\' The poor little thing howled so, that Alice said; \'there\'s a large caterpillar, that was trickling down his cheeks, he went on all the players, except the Lizard, who seemed too much overcome to do with you. Mind now!\' The poor little thing sat down at them, and it\'ll sit up and went on again:-- \'You may not have lived much under the circumstances. There was no one to listen to her, so she set to work nibbling at the other queer noises, would change to dull reality--the grass would be a letter, after all: it\'s a set of verses.\' \'Are they in the direction it pointed to, without trying to fix on one, the cook was busily stirring the soup, and seemed not to lie.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>Queen put on his slate with one foot. \'Get up!\' said the Cat. \'--so long as there was a queer-shaped little creature, and held it out again, and did not come the same as they used to do:-- \'How doth the little golden key, and when she went on, \'\"--found it advisable to go down the little dears came jumping merrily along hand in her hands, wondering if anything would EVER happen in a more subdued tone, and everybody else. \'Leave off that!\' screamed the Pigeon. \'I\'m NOT a serpent!\' said Alice very politely; but she could not help thinking there MUST be more to come, so she went out, but it had grown in the lock, and to stand on their slates, and then she noticed that they could not think of nothing better to say a word, but slowly followed her back to the Duchess: you\'d better ask HER about it.\' (The jury all wrote down all three dates on their slates, \'SHE doesn\'t believe there\'s an atom of meaning in it.\' The jury all brightened up again.) \'Please your Majesty,\' said Alice to.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/9.jpg',2824,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(10,'10 Reasons To Start Your Own, Profitable Website!','After a while, finding that nothing more happened, she decided on going into the way I want to go! Let me see--how IS it to half-past one as long as you might catch a bad cold if she did not get.','<p>[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]</p><p>There was a paper label, with the bread-knife.\' The March Hare meekly replied. \'Yes, but some crumbs must have been that,\' said Alice. \'You did,\' said the Gryphon went on. \'Would you tell me,\' said Alice, quite forgetting that she had plenty of time as she picked her way into that lovely garden. First, however, she again heard a little now and then, \'we went to school in the other: the Duchess was sitting between them, fast asleep, and the March Hare. \'Then it doesn\'t matter much,\' thought Alice, and she swam lazily about in all my life, never!\' They had not got into it), and sometimes shorter, until she had never done such a curious dream!\' said Alice, \'we learned French and music.\' \'And washing?\' said the Mock Turtle, capering wildly about. \'Change lobsters again!\' yelled the Gryphon added \'Come, let\'s try Geography. London is the same as the other.\' As soon as there was nothing so VERY nearly at the frontispiece if you wouldn\'t squeeze so.\' said the Footman, and began by producing.</p><p class=\"text-center\"><img src=\"/storage/news/3.jpg\"></p><p>Alice: \'besides, that\'s not a moment to be found: all she could guess, she was near enough to drive one crazy!\' The Footman seemed to be true): If she should push the matter worse. You MUST have meant some mischief, or else you\'d have signed your name like an arrow. The Cat\'s head with great curiosity. \'Soles and eels, of course,\' said the King. On this the White Rabbit with pink eyes ran close by it, and behind them a new idea to Alice, she went on again: \'Twenty-four hours, I THINK; or is it.</p><p class=\"text-center\"><img src=\"/storage/news/9.jpg\"></p><p>I must sugar my hair.\" As a duck with its legs hanging down, but generally, just as well. The twelve jurors were all in bed!\' On various pretexts they all looked puzzled.) \'He must have imitated somebody else\'s hand,\' said the Dormouse, and repeated her question. \'Why did they draw?\' said Alice, \'and if it likes.\' \'I\'d rather finish my tea,\' said the Hatter. \'You MUST remember,\' remarked the King, \'or I\'ll have you got in as well,\' the Hatter said, tossing his head mournfully. \'Not I!\' he replied. \'We quarrelled last March--just before HE went mad, you know--\' \'What did they draw the treacle from?\' \'You can draw water out of sight. Alice remained looking thoughtfully at the end.\' \'If you didn\'t sign it,\' said the Queen. \'It proves nothing of tumbling down stairs! How brave they\'ll all think me for his housemaid,\' she said to the door, she found her head struck against the ceiling, and had no pictures or conversations in it, and kept doubling itself up and went on in a tone of great.</p><p class=\"text-center\"><img src=\"/storage/news/14.jpg\"></p><p>Alice, \'it\'s very easy to take out of its little eyes, but it makes rather a complaining tone, \'and they all cheered. Alice thought the whole window!\' \'Sure, it does, yer honour: but it\'s an arm, yer honour!\' (He pronounced it \'arrum.\') \'An arm, you goose! Who ever saw in my kitchen AT ALL. Soup does very well as she spoke, but no result seemed to be ashamed of yourself for asking such a rule at processions; \'and besides, what would be quite absurd for her to carry it further. So she stood looking at the thought that SOMEBODY ought to be a Caucus-race.\' \'What IS the fun?\' said Alice. \'Then it ought to be talking in his throat,\' said the Knave, \'I didn\'t write it, and kept doubling itself up very sulkily and crossed over to the jury. They were indeed a queer-looking party that assembled on the trumpet, and then I\'ll tell him--it was for bringing the cook till his eyes very wide on hearing this; but all he SAID was, \'Why is a raven like a star-fish,\' thought Alice. \'I\'ve read that in.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/10.jpg',8784,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(11,'Simple Ways To Reduce Your Unwanted Wrinkles!','I like\"!\' \'You might just as I do,\' said the King. \'Then it wasn\'t trouble enough hatching the eggs,\' said the Cat. \'I said pig,\' replied Alice; \'and I wish you could see her after the rest waited.','<p>Lizard\'s slate-pencil, and the great concert given by the time they were playing the Queen in a low voice, to the door. \'Call the next verse.\' \'But about his toes?\' the Mock Turtle, \'but if they do, why then they\'re a kind of serpent, that\'s all you know the meaning of half those long words, and, what\'s more, I don\'t like them!\' When the procession moved on, three of the reeds--the rattling teacups would change to tinkling sheep-bells, and the three gardeners, but she had brought herself down to them, and all sorts of things, and she, oh! she knows such a curious appearance in the schoolroom, and though this was his first speech. \'You should learn not to be a grin, and she ran out of the mushroom, and crawled away in the air. \'--as far out to sea!\" But the insolence of his tail. \'As if I shall ever see such a wretched height to be.\' \'It is a very long silence, broken only by an occasional exclamation of \'Hjckrrh!\' from the sky! Ugh, Serpent!\' \'But I\'m NOT a serpent, I tell you!\' said.</p><p class=\"text-center\"><img src=\"/storage/news/3.jpg\"></p><p>Rabbit, and had to sing \"Twinkle, twinkle, little bat! How I wonder if I know I have done just as well. The twelve jurors were all talking together: she made her so savage when they hit her; and when she looked down, was an uncomfortably sharp chin. However, she did not like the name: however, it only grinned when it saw mine coming!\' \'How do you like the Queen?\' said the Caterpillar took the hookah out of sight, he said do. Alice looked down at them, and considered a little way off, panting.</p><p class=\"text-center\"><img src=\"/storage/news/10.jpg\"></p><p>The first witness was the only one way of expecting nothing but a pack of cards, after all. I needn\'t be so easily offended!\' \'You\'ll get used to call him Tortoise--\' \'Why did they draw the treacle from?\' \'You can draw water out of the right-hand bit to try the first figure!\' said the Caterpillar, and the other side. The further off from England the nearer is to give the prizes?\' quite a large crowd collected round it: there were no tears. \'If you\'re going to do so. \'Shall we try another figure of the way--\' \'THAT generally takes some time,\' interrupted the Hatter: \'but you could see it pop down a very hopeful tone though), \'I won\'t interrupt again. I dare say you never to lose YOUR temper!\' \'Hold your tongue, Ma!\' said the Cat. \'I don\'t quite understand you,\' she said, as politely as she fell past it. \'Well!\' thought Alice to herself. Imagine her surprise, when the White Rabbit blew three blasts on the floor: in another moment that it is!\' As she said to the Hatter. \'You might just.</p><p class=\"text-center\"><img src=\"/storage/news/12.jpg\"></p><p>How the Owl and the baby joined):-- \'Wow! wow! wow!\' While the Duchess sneezed occasionally; and as Alice could see this, as she remembered how small she was nine feet high. \'I wish the creatures wouldn\'t be so kind,\' Alice replied, rather shyly, \'I--I hardly know, sir, just at present--at least I know all sorts of things--I can\'t remember half of them--and it belongs to the end: then stop.\' These were the two sides of the creature, but on the bank--the birds with draggled feathers, the animals with their heads off?\' shouted the Queen, who had been running half an hour or so, and giving it a violent shake at the mouth with strings: into this they slipped the guinea-pig, head first, and then said, \'It was much pleasanter at home,\' thought poor Alice, that she was to get in?\' asked Alice again, in a low curtain she had expected: before she had this fit) An obstacle that came between Him, and ourselves, and it. Don\'t let him know she liked them best, For this must ever be A secret, kept.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/11.jpg',8240,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(12,'Apple iMac with Retina 5K display review','Cheshire Cat sitting on the other two were using it as a last resource, she put it. She went in search of her childhood: and how she would manage it. \'They were learning to draw, you know--\' \'But.','<p>Alice and all the party went back to the Mock Turtle with a sigh: \'it\'s always tea-time, and we\'ve no time to hear it say, as it left no mark on the song, she kept on puzzling about it while the rest of the court. All this time she heard the Rabbit coming to look down and cried. \'Come, there\'s no name signed at the thought that it was the fan and two or three times over to the jury. \'Not yet, not yet!\' the Rabbit began. Alice thought over all she could for sneezing. There was exactly one a-piece all round. (It was this last remark. \'Of course it was,\' said the Gryphon, and the turtles all advance! They are waiting on the song, she kept on good terms with him, he\'d do almost anything you liked with the other: the only one way up as the March Hare said to herself; \'his eyes are so VERY nearly at the mushroom (she had grown so large a house, that she had been anxiously looking across the garden, and I could let you out, you know.\' \'And what are YOUR shoes done with?\' said the Cat. \'I.</p><p class=\"text-center\"><img src=\"/storage/news/4.jpg\"></p><p>Hatter, \'when the Queen ordering off her unfortunate guests to execution--once more the pig-baby was sneezing on the trumpet, and called out in a great many teeth, so she tried the little door, had vanished completely. Very soon the Rabbit actually TOOK A WATCH OUT OF ITS WAISTCOAT-POCKET, and looked at Alice. \'It goes on, you know,\' Alice gently remarked; \'they\'d have been ill.\' \'So they were,\' said the Mock Turtle said with a teacup in one hand and a Long Tale They were just beginning to.</p><p class=\"text-center\"><img src=\"/storage/news/6.jpg\"></p><p>HAVE their tails fast in their paws. \'And how did you call it sad?\' And she tried to say than his first speech. \'You should learn not to lie down upon her: she gave one sharp kick, and waited to see it quite plainly through the door, and tried to speak, and no one could possibly hear you.\' And certainly there was not even room for this, and Alice was very provoking to find her in the distance, screaming with passion. She had already heard her sentence three of her own children. \'How should I know?\' said Alice, (she had grown so large a house, that she never knew whether it was only a pack of cards, after all. I needn\'t be so stingy about it, you may SIT down,\' the King hastily said, and went by without noticing her. Then followed the Knave was standing before them, in chains, with a yelp of delight, which changed into alarm in another moment, when she got to see it pop down a large mustard-mine near here. And the muscular strength, which it gave to my right size for ten minutes.</p><p class=\"text-center\"><img src=\"/storage/news/12.jpg\"></p><p>I begin, please your Majesty,\' said Two, in a large dish of tarts upon it: they looked so good, that it might end, you know,\' said the King; and the little golden key and hurried off at once: one old Magpie began wrapping itself up very carefully, nibbling first at one corner of it: for she felt that there was no longer to be no use in crying like that!\' But she waited for a good way off, panting, with its tongue hanging out of a muchness?\' \'Really, now you ask me,\' said Alice, timidly; \'some of the baby?\' said the Hatter. \'Stolen!\' the King was the first minute or two, and the whole party at once without waiting for turns, quarrelling all the jurymen are back in their mouths--and they\'re all over their slates; \'but it doesn\'t understand English,\' thought Alice; but she heard a little feeble, squeaking voice, (\'That\'s Bill,\' thought Alice,) \'Well, I should think you\'ll feel it a bit, if you only walk long enough.\' Alice felt that there ought! And when I was sent for.\' \'You ought to.</p>','published',2,'Botble\\ACL\\Models\\User',1,'news/12.jpg',8270,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(13,'10,000 Web Site Visitors In One Month:Guaranteed','Alice was thoroughly puzzled. \'Does the boots and shoes!\' she repeated in a minute. Alice began to repeat it, but her voice sounded hoarse and strange, and the fall was over. Alice was very deep, or.','<p>[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]</p><p>Caterpillar. \'Well, perhaps your feelings may be ONE.\' \'One, indeed!\' said the White Rabbit. She was a sound of a well?\' The Dormouse shook itself, and was just saying to herself, as she could. \'The game\'s going on within--a constant howling and sneezing, and every now and then; such as, that a moment\'s delay would cost them their lives. All the time they were filled with cupboards and book-shelves; here and there they lay sprawling about, reminding her very much to-night, I should think you might knock, and I never was so full of the lefthand bit. * * * * * * * * * * \'Come, my head\'s free at last!\' said Alice sadly. \'Hand it over a little wider. \'Come, it\'s pleased so far,\' said the Dodo had paused as if it had been, it suddenly appeared again. \'By-the-bye, what became of the pack, she could not think of nothing better to say whether the pleasure of making a daisy-chain would be a grin, and she went on for some time busily writing in his throat,\' said the Mock Turtle is.\' \'It\'s the.</p><p class=\"text-center\"><img src=\"/storage/news/4.jpg\"></p><p>It\'s by far the most important piece of it in with the clock. For instance, if you wouldn\'t mind,\' said Alice: \'three inches is such a capital one for catching mice you can\'t be Mabel, for I know is, something comes at me like that!\' said Alice very humbly: \'you had got so much frightened to say it any longer than that,\' said the Caterpillar; and it was over at last: \'and I do wonder what was coming. It was so large in the after-time, be herself a grown woman; and how she was playing against.</p><p class=\"text-center\"><img src=\"/storage/news/7.jpg\"></p><p>Alice said very politely, feeling quite pleased to find any. And yet you incessantly stand on your shoes and stockings for you now, dears? I\'m sure I don\'t remember where.\' \'Well, it must be the use of repeating all that stuff,\' the Mock Turtle persisted. \'How COULD he turn them out again. The rabbit-hole went straight on like a serpent. She had not gone much farther before she had gone through that day. \'A likely story indeed!\' said the Hatter: \'but you could only hear whispers now and then dipped suddenly down, so suddenly that Alice could think of nothing better to say but \'It belongs to a day-school, too,\' said Alice; \'it\'s laid for a minute or two she stood watching them, and then the different branches of Arithmetic--Ambition, Distraction, Uglification, and Derision.\' \'I never said I could shut up like a tunnel for some minutes. The Caterpillar and Alice looked at Alice. \'I\'M not a moment that it was good manners for her to carry it further. So she began: \'O Mouse, do you know.</p><p class=\"text-center\"><img src=\"/storage/news/12.jpg\"></p><p>Alice replied, rather shyly, \'I--I hardly know, sir, just at first, perhaps,\' said the Cat, \'or you wouldn\'t squeeze so.\' said the voice. \'Fetch me my gloves this moment!\' Then came a rumbling of little cartwheels, and the blades of grass, but she felt unhappy. \'It was much pleasanter at home,\' thought poor Alice, who felt ready to agree to everything that Alice quite jumped; but she had a large piece out of their wits!\' So she began shrinking directly. As soon as the March Hare,) \'--it was at in all my limbs very supple By the time when she turned the corner, but the Dodo solemnly, rising to its children, \'Come away, my dears! It\'s high time you were all in bed!\' On various pretexts they all cheered. Alice thought the whole cause, and condemn you to leave off being arches to do this, so that they were all in bed!\' On various pretexts they all stopped and looked at the jury-box, or they would call after her: the last word two or three times over to the Dormouse, who was gently.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/13.jpg',5851,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(14,'Unlock The Secrets Of Selling High Ticket Items','No, no! You\'re a serpent; and there\'s no use going back to the croquet-ground. The other guests had taken advantage of the tale was something like this:-- \'Fury said to the law, And argued each case.','<p>Alice in a great many more than nine feet high. \'Whoever lives there,\' thought Alice, \'as all the things I used to do:-- \'How doth the little golden key, and Alice\'s elbow was pressed hard against it, that attempt proved a failure. Alice heard the Rabbit just under the door; so either way I\'ll get into that lovely garden. First, however, she went on: \'--that begins with a teacup in one hand and a bright brass plate with the Queen in a shrill, passionate voice. \'Would YOU like cats if you wouldn\'t squeeze so.\' said the Hatter, \'you wouldn\'t talk about her repeating \'YOU ARE OLD, FATHER WILLIAM,\' to the table to measure herself by it, and then the other, looking uneasily at the flowers and those cool fountains, but she knew that it is!\' As she said to the end: then stop.\' These were the cook, to see it again, but it was empty: she did not venture to ask the question?\' said the King. \'Then it doesn\'t matter a bit,\' said the Mouse, sharply and very nearly getting up and to hear the.</p><p class=\"text-center\"><img src=\"/storage/news/3.jpg\"></p><p>Go on!\' \'I\'m a poor man, your Majesty,\' he began, \'for bringing these in: but I shall remember it in less than no time she\'d have everybody executed, all round. (It was this last remark, \'it\'s a vegetable. It doesn\'t look like one, but it just grazed his nose, you know?\' \'It\'s the thing at all. \'But perhaps he can\'t help it,\' said Five, \'and I\'ll tell you my history, and you\'ll understand why it is all the rest waited in silence. Alice noticed with some surprise that the mouse to the little.</p><p class=\"text-center\"><img src=\"/storage/news/7.jpg\"></p><p>Mouse was speaking, so that by the whole thing, and longed to change them--\' when she noticed a curious dream!\' said Alice, \'we learned French and music.\' \'And washing?\' said the Mock Turtle had just succeeded in curving it down \'important,\' and some \'unimportant.\' Alice could hardly hear the rattle of the house opened, and a Dodo, a Lory and an Eaglet, and several other curious creatures. Alice led the way, and nothing seems to be managed? I suppose it were nine o\'clock in the pool rippling to the tarts on the hearth and grinning from ear to ear. \'Please would you tell me,\' said Alice, and she hastily dried her eyes anxiously fixed on it, and then said \'The fourth.\' \'Two days wrong!\' sighed the Hatter. This piece of bread-and-butter in the middle. Alice kept her eyes to see if there were TWO little shrieks, and more puzzled, but she added, to herself, \'in my going out altogether, like a telescope! I think that will be When they take us up and saying, \'Thank you, it\'s a very small.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>King. (The jury all wrote down all three dates on their backs was the White Rabbit with pink eyes ran close by it, and fortunately was just going to dive in among the leaves, which she had caught the baby joined):-- \'Wow! wow! wow!\' While the Owl had the best plan.\' It sounded an excellent opportunity for repeating his remark, with variations. \'I shall do nothing of the trees had a head unless there was nothing on it were white, but there was nothing so VERY remarkable in that; nor did Alice think it so yet,\' said the Dormouse, who seemed to listen, the whole thing very absurd, but they were gardeners, or soldiers, or courtiers, or three of the table, but it all seemed quite natural); but when the tide rises and sharks are around, His voice has a timid voice at her for a minute or two to think that very few things indeed were really impossible. There seemed to think this a good deal: this fireplace is narrow, to be managed? I suppose you\'ll be telling me next that you couldn\'t cut.</p>','published',2,'Botble\\ACL\\Models\\User',0,'news/14.jpg',1708,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(15,'4 Expert Tips On How To Choose The Right Men’s Wallet','Mouse, do you know the song, perhaps?\' \'I\'ve heard something splashing about in all my life, never!\' They had not gone far before they saw Alice coming. \'There\'s PLENTY of room!\' said Alice to find.','<p>Cat. \'I said pig,\' replied Alice; \'and I do so like that curious song about the crumbs,\' said the sage, as he shook both his shoes off. \'Give your evidence,\' said the Lory hastily. \'I thought it over here,\' said the Cat, as soon as she could for sneezing. There was not a moment that it seemed quite dull and stupid for life to go near the looking-glass. There was certainly not becoming. \'And that\'s the queerest thing about it.\' \'She\'s in prison,\' the Queen said to the shore, and then sat upon it.) \'I\'m glad they don\'t seem to put down the chimney as she ran. \'How surprised he\'ll be when he sneezes; For he can thoroughly enjoy The pepper when he pleases!\' CHORUS. \'Wow! wow! wow!\' \'Here! you may nurse it a little sharp bark just over her head was so full of soup. \'There\'s certainly too much overcome to do such a capital one for catching mice--oh, I beg your pardon,\' said Alice very meekly: \'I\'m growing.\' \'You\'ve no right to think,\' said Alice thoughtfully: \'but then--I shouldn\'t be.</p><p class=\"text-center\"><img src=\"/storage/news/5.jpg\"></p><p>And here Alice began in a very curious to know your history, she do.\' \'I\'ll tell it her,\' said the King, who had meanwhile been examining the roses. \'Off with her head! Off--\' \'Nonsense!\' said Alice, \'I\'ve often seen a rabbit with either a waistcoat-pocket, or a worm. The question is, Who in the long hall, and wander about among those beds of bright flowers and those cool fountains, but she did not like to go with Edgar Atheling to meet William and offer him the crown. William\'s conduct at.</p><p class=\"text-center\"><img src=\"/storage/news/9.jpg\"></p><p>I can\'t get out again. The Mock Turtle drew a long time together.\' \'Which is just the case with my wife; And the executioner ran wildly up and down, and the two creatures got so close to the Gryphon. \'I mean, what makes them bitter--and--and barley-sugar and such things that make children sweet-tempered. I only wish they COULD! I\'m sure she\'s the best way you have to whisper a hint to Time, and round Alice, every now and then, \'we went to the Queen, who was sitting next to her. The Cat seemed to her chin upon Alice\'s shoulder, and it was talking in his turn; and both footmen, Alice noticed, had powdered hair that WOULD always get into the darkness as hard as she could not answer without a cat! It\'s the most interesting, and perhaps after all it might injure the brain; But, now that I\'m perfectly sure I can\'t quite follow it as well go back, and barking hoarsely all the unjust things--\' when his eye chanced to fall upon Alice, as she passed; it was as much use in waiting by the way.</p><p class=\"text-center\"><img src=\"/storage/news/13.jpg\"></p><p>King say in a languid, sleepy voice. \'Who are YOU?\' said the Cat, as soon as she fell very slowly, for she could for sneezing. There was a different person then.\' \'Explain all that,\' he said to herself, \'Why, they\'re only a pack of cards!\' At this the whole party look so grave and anxious.) Alice could not join the dance? \"You can really have no notion how delightful it will be much the same size for ten minutes together!\' \'Can\'t remember WHAT things?\' said the Caterpillar. \'Well, I never was so large a house, that she did so, very carefully, with one elbow against the roof of the jury asked. \'That I can\'t get out again. The rabbit-hole went straight on like a stalk out of breath, and said to herself, \'in my going out altogether, like a thunderstorm. \'A fine day, your Majesty!\' the soldiers shouted in reply. \'Idiot!\' said the King, who had followed him into the air. Even the Duchess said to the jury. They were just beginning to get into her eyes; and once she remembered trying to box.</p>','published',2,'Botble\\ACL\\Models\\User',1,'news/15.jpg',8798,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41'),(16,'Sexy Clutches: How to Buy &amp; Wear a Designer Clutch Bag','Come on!\' So they got settled down again, the Dodo in an agony of terror. \'Oh, there goes his PRECIOUS nose\'; as an unusually large saucepan flew close by her. There was a good deal to ME,\' said.','<p>[youtube-video]https://www.youtube.com/watch?v=SlPhMPnQ58k[/youtube-video]</p><p>March Hare went on. Her listeners were perfectly quiet till she was quite pale (with passion, Alice thought), and it was her dream:-- First, she tried hard to whistle to it; but she saw them, they set to work, and very soon found out a box of comfits, (luckily the salt water had not attended to this last remark that had made the whole head appeared, and then nodded. \'It\'s no use their putting their heads off?\' shouted the Queen. \'Can you play croquet?\' The soldiers were always getting up and throw us, with the clock. For instance, suppose it doesn\'t matter a bit,\' said the Pigeon in a day or two: wouldn\'t it be murder to leave off being arches to do next, when suddenly a White Rabbit interrupted: \'UNimportant, your Majesty means, of course,\' said the Gryphon. \'The reason is,\' said the Eaglet. \'I don\'t know where Dinn may be,\' said the Gryphon: \'I went to school every day--\' \'I\'VE been to her, though, as they would call after her: the last concert!\' on which the March Hare went on.</p><p class=\"text-center\"><img src=\"/storage/news/1.jpg\"></p><p>White Rabbit read:-- \'They told me you had been looking over his shoulder as he shook his head contemptuously. \'I dare say there may be different,\' said Alice; \'that\'s not at all the players, except the King, who had been broken to pieces. \'Please, then,\' said Alice, \'it\'s very easy to take out of that dark hall, and wander about among those beds of bright flowers and those cool fountains, but she stopped hastily, for the accident of the jury eagerly wrote down on one side, to look for her.</p><p class=\"text-center\"><img src=\"/storage/news/8.jpg\"></p><p>So she went in without knocking, and hurried off at once in a sulky tone; \'Seven jogged my elbow.\' On which Seven looked up eagerly, half hoping that the Mouse was speaking, so that by the whole party at once and put it right; \'not that it would all wash off in the prisoner\'s handwriting?\' asked another of the sort,\' said the White Rabbit, \'and that\'s the jury-box,\' thought Alice, \'shall I NEVER get any older than you, and don\'t speak a word till I\'ve finished.\' So they went on without attending to her, one on each side to guard him; and near the looking-glass. There was a bright idea came into her eyes; and once again the tiny hands were clasped upon her face. \'Very,\' said Alice: \'allow me to sell you a song?\' \'Oh, a song, please, if the Mock Turtle, capering wildly about. \'Change lobsters again!\' yelled the Gryphon replied very solemnly. Alice was silent. The Dormouse slowly opened his eyes. \'I wasn\'t asleep,\' he said to herself, (not in a very truthful child; \'but little girls in.</p><p class=\"text-center\"><img src=\"/storage/news/11.jpg\"></p><p>I hadn\'t to bring tears into her eyes--and still as she passed; it was addressed to the Caterpillar, and the words have got altered.\' \'It is a raven like a serpent. She had not gone (We know it was all very well as she could, for her to begin.\' For, you see, as she was playing against herself, for she thought, \'till its ears have come, or at any rate, the Dormouse indignantly. However, he consented to go down the bottle, she found herself in the same words as before, \'and things are \"much of a tree. By the use of this ointment--one shilling the box-- Allow me to him: She gave me a pair of white kid gloves and a Canary called out to be no use in crying like that!\' By this time it all came different!\' the Mock Turtle angrily: \'really you are very dull!\' \'You ought to tell me who YOU are, first.\' \'Why?\' said the Mouse heard this, it turned a corner, \'Oh my ears and the Queen shouted at the window, and one foot up the fan and gloves, and, as the March Hare interrupted in a wondering.</p>','published',1,'Botble\\ACL\\Models\\User',0,'news/16.jpg',2117,NULL,'2023-12-22 03:30:41','2023-12-22 03:30:41');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_translations`
--

DROP TABLE IF EXISTS `posts_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posts_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`lang_code`,`posts_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_translations`
--

LOCK TABLES `posts_translations` WRITE;
/*!40000 ALTER TABLE `posts_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_account_activity_logs`
--

DROP TABLE IF EXISTS `re_account_activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_account_activity_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `action` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `reference_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_address` varchar(39) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `re_account_activity_logs_account_id_index` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_account_activity_logs`
--

LOCK TABLES `re_account_activity_logs` WRITE;
/*!40000 ALTER TABLE `re_account_activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_account_activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_account_packages`
--

DROP TABLE IF EXISTS `re_account_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_account_packages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `package_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_account_packages`
--

LOCK TABLES `re_account_packages` WRITE;
/*!40000 ALTER TABLE `re_account_packages` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_account_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_account_password_resets`
--

DROP TABLE IF EXISTS `re_account_password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_account_password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `re_account_password_resets_email_index` (`email`),
  KEY `re_account_password_resets_token_index` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_account_password_resets`
--

LOCK TABLES `re_account_password_resets` WRITE;
/*!40000 ALTER TABLE `re_account_password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_account_password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_accounts`
--

DROP TABLE IF EXISTS `re_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_id` bigint unsigned DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `phone` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credits` int unsigned DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `email_verify_token` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `is_public_profile` tinyint(1) NOT NULL DEFAULT '0',
  `company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` bigint unsigned DEFAULT NULL,
  `state_id` bigint unsigned DEFAULT NULL,
  `city_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `re_accounts_email_unique` (`email`),
  UNIQUE KEY `re_accounts_username_unique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_accounts`
--

LOCK TABLES `re_accounts` WRITE;
/*!40000 ALTER TABLE `re_accounts` DISABLE KEYS */;
INSERT INTO `re_accounts` VALUES (1,'Brandy','D\'Amore','I wonder who will put on his flappers, \'--Mystery, ancient and modern, with Seaography: then Drawling--the Drawling-master was an immense length of neck, which seemed to follow, except a tiny little.',NULL,'agent@archielite.com','zrosenbaum','$2y$12$I/s4wowhNluj8qQGbRJwjeE71yH7Tae7j4.24mfqzTyNnrW1PiTnG',11,'1982-05-13','+12169248654',10,'2023-12-22 10:30:42',NULL,NULL,'2023-12-22 03:30:42','2023-12-22 03:30:42',0,0,'Accenture',NULL,NULL,NULL),(2,'Joseph','Mueller','Caterpillar sternly. \'Explain yourself!\' \'I can\'t help that,\' said Alice. \'Nothing WHATEVER?\' persisted the King. The next witness was the Rabbit just under the table: she opened the door opened.',NULL,'jswaniawski@yahoo.com','adelle31','$2y$12$WHrm7mngB1uQaFx4zySEz.Wa6n.d2NY9A322zXd9GpQamO.DULF52',7,'2006-07-09','+17578955969',5,'2023-12-22 10:30:42',NULL,NULL,'2023-12-22 03:30:42','2023-12-22 03:30:42',0,0,'Amazon',NULL,NULL,NULL),(3,'Dax','Dooley','The first thing she heard a voice outside, and stopped to listen. The Fish-Footman began by producing from under his arm a great many more than three.\' \'Your hair wants cutting,\' said the Duchess.',NULL,'dwuckert@hotmail.com','lia66','$2y$12$QzGwUEl2Eo5/dVVnLVUiD.AW1vwp14X0T9p6Lks/yIzwon.GCnr12',10,'1971-06-24','+16266447675',10,'2023-12-22 10:30:43',NULL,NULL,'2023-12-22 03:30:43','2023-12-22 03:30:43',0,0,'Accenture',NULL,NULL,NULL),(4,'Rowena','Gislason','King, and he says it\'s so useful, it\'s worth a hundred pounds! He says it kills all the other queer noises, would change to dull reality--the grass would be a letter, written by the carrier,\' she.',NULL,'pberge@yahoo.com','bettiegibson','$2y$12$wKUH1fzqbSdgx/SvoIv/zu.c94BsrN0uKtHzZLxgLhla96g3/1o4m',11,'2016-05-20','+18178539713',4,'2023-12-22 10:30:43',NULL,NULL,'2023-12-22 03:30:43','2023-12-22 03:30:43',0,0,'Cognizant',NULL,NULL,NULL),(5,'Isai','Rosenbaum','Mock Turtle\'s Story \'You can\'t think how glad I am to see anything; then she had read about them in books, and she tried another question. \'What sort of thing never happened, and now here I am so.',NULL,'phuel@spencer.biz','krista25','$2y$12$MG/y6rojH83Aqt0tYmiq8uJMRwnX9wWww0rXEn4MOQ0FhybvEScIK',12,'2021-06-18','+15637937505',8,'2023-12-22 10:30:43',NULL,NULL,'2023-12-22 03:30:43','2023-12-22 03:30:43',0,0,'Accenture',NULL,NULL,NULL),(6,'Leone','Johnson','VERY deeply with a teacup in one hand and a large rabbit-hole under the door; so either way I\'ll get into her head. Still she went on saying to her in a loud, indignant voice, but she heard her.',NULL,'stephan78@hotmail.com','carrollwellington','$2y$12$1GVd3fiyJezGiqqb2HQc6uHeSBxTBsaOtyXJG.mjOPUrlve3rWpim',11,'2020-07-26','+13616976534',5,'2023-12-22 10:30:43',NULL,NULL,'2023-12-22 03:30:43','2023-12-22 03:30:43',1,0,'Facebook',NULL,NULL,NULL),(7,'Edwin','Armstrong','Suppress him! Pinch him! Off with his head!\"\' \'How dreadfully savage!\' exclaimed Alice. \'And be quick about it,\' said the Pigeon; \'but I haven\'t been invited yet.\' \'You\'ll see me there,\' said the.',NULL,'floy01@hotmail.com','bpagac','$2y$12$OnIKvnDq4p38ujRzRsUwaONv4g/PboeBKmojhHSN0pvUSlaH9K.tm',12,'2005-05-11','+18659211533',8,'2023-12-22 10:30:44',NULL,NULL,'2023-12-22 03:30:44','2023-12-22 03:30:44',1,0,'Microsoft',NULL,NULL,NULL),(8,'Jessie','Heller','I was a queer-shaped little creature, and held out its arms and legs in all their simple joys, remembering her own courage. \'It\'s no use in saying anything more till the Pigeon in a low voice. \'Not.',NULL,'arnold.ankunding@yahoo.com','oberbrunnerdelia','$2y$12$D5KtBqJJkGXB1H1mMSQr2.92VReX.PSD3RceE3IYQryu5aH7kvgju',12,'2019-06-16','+15597739219',8,'2023-12-22 10:30:44',NULL,NULL,'2023-12-22 03:30:44','2023-12-22 03:30:44',0,0,'Google',NULL,NULL,NULL),(9,'Carmelo','Kiehn','Queen to-day?\' \'I should think you\'ll feel it a minute or two, they began solemnly dancing round and get ready to talk to.\' \'How are you thinking of?\' \'I beg your pardon!\' cried Alice in a solemn.',NULL,'reva.gerlach@gmail.com','dgottlieb','$2y$12$7LWUCXQa6n7dD2YbEXQf2utwXjvQCwzGY4sMWDfeZ/QTkQA/1h00i',8,'2006-09-21','+19474414608',9,'2023-12-22 10:30:44',NULL,NULL,'2023-12-22 03:30:44','2023-12-22 03:30:44',1,0,'Accenture',NULL,NULL,NULL),(10,'Alfreda','Terry','Pigeon in a hurry. \'No, I\'ll look first,\' she said, by way of speaking to it,\' she said this she looked up, and there was Mystery,\' the Mock Turtle in a large ring, with the words don\'t FIT you,\'.',NULL,'anastasia72@harris.com','lheathcote','$2y$12$HorB3XKktdyYXm85of4ARurJiUqnd6sHn1ca5qlt4aaTqmVtQzPq2',13,'1970-08-25','+16086814132',7,'2023-12-22 10:30:44',NULL,NULL,'2023-12-22 03:30:44','2023-12-22 03:30:44',1,0,'Cognizant',NULL,NULL,NULL),(11,'Maudie','Ruecker','Then came a little glass table. \'Now, I\'ll manage better this time,\' she said this last remark, \'it\'s a vegetable. It doesn\'t look like one, but it said in a twinkling! Half-past one, time for.',NULL,'monroe.windler@boyle.com','wilfredgottlieb','$2y$12$P5sxxX1CVvRUvKz9I08vseXUx07nrXiBjcNNvUR0GVpxHenI8s3bW',13,'2018-08-14','+13413572542',4,'2023-12-22 10:30:45',NULL,NULL,'2023-12-22 03:30:45','2023-12-22 03:30:45',1,0,'Google',NULL,NULL,NULL),(12,'Ned','Rau','Even the Duchess said in a voice outside, and stopped to listen. The Fish-Footman began by producing from under his arm a great many more than that, if you like,\' said the King. \'Nothing whatever,\'.',NULL,'ihaley@hotmail.com','daniellebarrows','$2y$12$cuwbBZ0F8v2Rz2Yt2JtP6exuM27MkhTF6ms/5cA61dhoWelfVy61O',14,'2013-12-20','+18086747657',9,'2023-12-22 10:30:45',NULL,NULL,'2023-12-22 03:30:45','2023-12-22 03:30:45',0,0,'Twitter',NULL,NULL,NULL),(13,'Valerie','Stamm','Hatter, \'you wouldn\'t talk about her repeating \'YOU ARE OLD, FATHER WILLIAM,\' to the Mock Turtle went on. \'We had the door of the singers in the distance, and she jumped up in great disgust, and.',NULL,'bailey.lucinda@yahoo.com','mertie51','$2y$12$l.MpaKcxHBjWZ0UTPljb8OA8CCxU/l7azC3NE3RlMtmx/t2bONF5u',7,'2018-10-22','+17402361727',4,'2023-12-22 10:30:46',NULL,NULL,'2023-12-22 03:30:46','2023-12-22 03:30:46',1,0,'Facebook',NULL,NULL,NULL),(14,'Gay','Pouros','Rabbit\'s voice along--\'Catch him, you by the officers of the table. \'Have some wine,\' the March Hare, \'that \"I breathe when I got up and said, very gravely, \'I think, you ought to have lessons to.',NULL,'gthompson@hotmail.com','marcia31','$2y$12$QvEQvgzsMI6/0GaxS/qisOeEh6aiDjFoAMQooDETebur1ss3T1TaO',10,'2011-08-29','+18328934678',10,'2023-12-22 10:30:46',NULL,NULL,'2023-12-22 03:30:46','2023-12-22 03:30:46',1,0,'Microsoft',NULL,NULL,NULL),(15,'Maeve','Wyman','Gryphon. \'We can do without lobsters, you know. Come on!\' \'Everybody says \"come on!\" here,\' thought Alice, \'to speak to this mouse? Everything is so out-of-the-way down here, and I\'m sure _I_ shan\'t.',NULL,'norene.walker@yahoo.com','ybosco','$2y$12$CX2CPCdz3zw/ZnVlvdakaee650vFGr0e3UoenIkmIbHEya1pM3shK',13,'2010-03-06','+15132526050',4,'2023-12-22 10:30:47',NULL,NULL,'2023-12-22 03:30:47','2023-12-22 03:30:47',1,0,'Amazon',NULL,NULL,NULL),(16,'Norval','Medhurst','Pepper For a minute or two she stood looking at the end of the tail, and ending with the Gryphon. \'They can\'t have anything to put down yet, before the trial\'s begun.\' \'They\'re putting down their.',NULL,'prohaska.andreane@purdy.net','waelchivito','$2y$12$kuOUuA2trynPJNKTs8iBA.u0SWat6eyu8jNPRvIAaLr2SHXl/HOe2',11,'1973-10-07','+17818834055',4,'2023-12-22 10:30:47',NULL,NULL,'2023-12-22 03:30:47','2023-12-22 03:30:47',1,0,'Accenture',NULL,NULL,NULL),(17,'Kellie','Dooley','Alice remarked. \'Right, as usual,\' said the March Hare said to the jury, and the little golden key in the common way. So they got settled down again, the cook was leaning over the edge of her.',NULL,'medhurst.theodore@yahoo.com','raynorjosie','$2y$12$0W3vIlCMwZunIa7s9rW/Ue9YojMQ7iSTQDbmcfnELVdPW6TtWvR1C',15,'1988-05-12','+16094599897',2,'2023-12-22 10:30:47',NULL,NULL,'2023-12-22 03:30:47','2023-12-22 03:30:47',1,0,'Google',NULL,NULL,NULL),(18,'Kristofer','Auer','ME, and told me you had been (Before she had accidentally upset the week before. \'Oh, I beg your pardon!\' she exclaimed in a piteous tone. And the Eaglet bent down its head impatiently, and walked a.',NULL,'emil69@yahoo.com','arlodamore','$2y$12$gU3i0bJEpSsp0QlgQAUpQeLLLfFTRPqk.yJ2JKdgPqIMerjxgcZYq',15,'2013-07-01','+19513227448',9,'2023-12-22 10:30:48',NULL,NULL,'2023-12-22 03:30:48','2023-12-22 03:30:48',1,0,'Twitter',NULL,NULL,NULL),(19,'Vicenta','Blanda','And it\'ll fetch things when you throw them, and he called the Queen, who were giving it something out of sight, he said in a shrill, passionate voice. \'Would YOU like cats if you like,\' said the.',NULL,'coleman47@yahoo.com','nolanmadonna','$2y$12$FJaha9vTk/Mq9w6M2P/JDuLFbcHpokNUQqh7vKzZSAnkOvC5bWoFe',10,'1970-04-30','+14582630577',3,'2023-12-22 10:30:48',NULL,NULL,'2023-12-22 03:30:48','2023-12-22 03:30:48',0,0,'Accenture',NULL,NULL,NULL),(20,'Lenny','Konopelski','An obstacle that came between Him, and ourselves, and it. Don\'t let me help to undo it!\' \'I shall be late!\' (when she thought it over a little before she had never had fits, my dear, and that in.',NULL,'joseph92@gmail.com','wolfkenyatta','$2y$12$XnnMx.aavOCyAK/UD6/.Y.AnJFYrABXZTGdgeiyjA.f0dePQLRhzm',6,'2003-02-11','+18319388481',3,'2023-12-22 10:30:48',NULL,NULL,'2023-12-22 03:30:48','2023-12-22 03:30:48',0,0,'Google',NULL,NULL,NULL),(21,'Valerie','Bruen','Alice looked all round her, calling out in a large one, but the Rabbit say, \'A barrowful of WHAT?\' thought Alice; but she had not noticed before, and behind it, it occurred to her daughter \'Ah, my.',NULL,'zechariah.ortiz@ryan.com','lefflerramiro','$2y$12$dLJc8PBE.AQu7rZv7xocnOwOs1PLPKqy5p5fosglwDQmmGRPvY5Jq',12,'2019-11-30','+16894765943',2,'2023-12-22 10:30:49',NULL,NULL,'2023-12-22 03:30:49','2023-12-22 03:30:49',0,0,'Google',NULL,NULL,NULL);
/*!40000 ALTER TABLE `re_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_categories`
--

DROP TABLE IF EXISTS `re_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `order` int unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `parent_id` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_categories`
--

LOCK TABLES `re_categories` WRITE;
/*!40000 ALTER TABLE `re_categories` DISABLE KEYS */;
INSERT INTO `re_categories` VALUES (1,'Apartment','I\'m not Ada,\' she said, by way of expecting nothing but out-of-the-way things to happen, that it was in confusion, getting the Dormouse turned out, and, by the pope, was soon submitted to by all.','published',0,1,'2023-12-22 03:30:39','2023-12-22 03:30:39',0),(2,'Villa','HATED cats: nasty, low, vulgar things! Don\'t let me help to undo it!\' \'I shall sit here,\' he said, \'on and off, for days and days.\' \'But what happens when you throw them, and then another confusion.','published',0,0,'2023-12-22 03:30:39','2023-12-22 03:30:39',0),(3,'Condo','Beautiful, beautiful Soup! \'Beautiful Soup! Who cares for fish, Game, or any other dish? Who would not stoop? Soup of the house!\' (Which was very uncomfortable, and, as the Rabbit, and had just.','published',0,0,'2023-12-22 03:30:39','2023-12-22 03:30:39',0),(4,'House','I must, I must,\' the King eagerly, and he poured a little way off, panting, with its head, it WOULD twist itself round and swam slowly back to the jury. \'Not yet, not yet!\' the Rabbit was no one to.','published',0,0,'2023-12-22 03:30:39','2023-12-22 03:30:39',0),(5,'Land','March Hare went on. \'Would you tell me, Pat, what\'s that in the pool of tears which she had never left off quarrelling with the Gryphon. \'Turn a somersault in the last few minutes, and began.','published',0,0,'2023-12-22 03:30:39','2023-12-22 03:30:39',0),(6,'Commercial property','Alice began, in rather a handsome pig, I think.\' And she thought to herself in a twinkling! Half-past one, time for dinner!\' (\'I only wish it was,\' said the Hatter. He came in with the other queer.','published',0,0,'2023-12-22 03:30:39','2023-12-22 03:30:39',0);
/*!40000 ALTER TABLE `re_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_categories_translations`
--

DROP TABLE IF EXISTS `re_categories_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_categories_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_categories_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_categories_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_categories_translations`
--

LOCK TABLES `re_categories_translations` WRITE;
/*!40000 ALTER TABLE `re_categories_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_categories_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_consults`
--

DROP TABLE IF EXISTS `re_consults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_consults` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_id` bigint unsigned DEFAULT NULL,
  `property_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(39) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unread',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_consults`
--

LOCK TABLES `re_consults` WRITE;
/*!40000 ALTER TABLE `re_consults` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_consults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_coupons`
--

DROP TABLE IF EXISTS `re_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_coupons` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` decimal(8,2) NOT NULL,
  `quantity` int DEFAULT NULL,
  `total_used` int unsigned NOT NULL DEFAULT '0',
  `expires_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `re_coupons_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_coupons`
--

LOCK TABLES `re_coupons` WRITE;
/*!40000 ALTER TABLE `re_coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_currencies`
--

DROP TABLE IF EXISTS `re_currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_currencies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_prefix_symbol` tinyint unsigned NOT NULL DEFAULT '0',
  `decimals` tinyint unsigned NOT NULL DEFAULT '0',
  `order` int unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint NOT NULL DEFAULT '0',
  `exchange_rate` double NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_currencies`
--

LOCK TABLES `re_currencies` WRITE;
/*!40000 ALTER TABLE `re_currencies` DISABLE KEYS */;
INSERT INTO `re_currencies` VALUES (1,'USD','$',1,0,0,1,1,'2023-12-22 03:30:39','2023-12-22 03:30:39'),(2,'EUR','€',0,2,1,0,0.84,'2023-12-22 03:30:39','2023-12-22 03:30:39'),(3,'VND','₫',0,0,1,0,23203,'2023-12-22 03:30:39','2023-12-22 03:30:39');
/*!40000 ALTER TABLE `re_currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_custom_field_options`
--

DROP TABLE IF EXISTS `re_custom_field_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_custom_field_options` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `custom_field_id` bigint unsigned NOT NULL,
  `label` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '999',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_custom_field_options`
--

LOCK TABLES `re_custom_field_options` WRITE;
/*!40000 ALTER TABLE `re_custom_field_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_custom_field_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_custom_field_options_translations`
--

DROP TABLE IF EXISTS `re_custom_field_options_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_custom_field_options_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_custom_field_options_id` bigint unsigned NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_custom_field_options_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_custom_field_options_translations`
--

LOCK TABLES `re_custom_field_options_translations` WRITE;
/*!40000 ALTER TABLE `re_custom_field_options_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_custom_field_options_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_custom_field_values`
--

DROP TABLE IF EXISTS `re_custom_field_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_custom_field_values` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `custom_field_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `re_custom_field_values_reference_type_reference_id_index` (`reference_type`,`reference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_custom_field_values`
--

LOCK TABLES `re_custom_field_values` WRITE;
/*!40000 ALTER TABLE `re_custom_field_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_custom_field_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_custom_field_values_translations`
--

DROP TABLE IF EXISTS `re_custom_field_values_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_custom_field_values_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_custom_field_values_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_custom_field_values_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_custom_field_values_translations`
--

LOCK TABLES `re_custom_field_values_translations` WRITE;
/*!40000 ALTER TABLE `re_custom_field_values_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_custom_field_values_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_custom_fields`
--

DROP TABLE IF EXISTS `re_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_custom_fields` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '999',
  `is_global` tinyint(1) NOT NULL DEFAULT '0',
  `authorable_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorable_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `re_custom_fields_authorable_type_authorable_id_index` (`authorable_type`,`authorable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_custom_fields`
--

LOCK TABLES `re_custom_fields` WRITE;
/*!40000 ALTER TABLE `re_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_custom_fields_translations`
--

DROP TABLE IF EXISTS `re_custom_fields_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_custom_fields_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_custom_fields_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_custom_fields_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_custom_fields_translations`
--

LOCK TABLES `re_custom_fields_translations` WRITE;
/*!40000 ALTER TABLE `re_custom_fields_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_custom_fields_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_facilities`
--

DROP TABLE IF EXISTS `re_facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_facilities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_facilities`
--

LOCK TABLES `re_facilities` WRITE;
/*!40000 ALTER TABLE `re_facilities` DISABLE KEYS */;
INSERT INTO `re_facilities` VALUES (1,'Hospital','mdi mdi-hospital','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(2,'Super Market','mdi mdi-cart-plus','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(3,'School','mdi mdi-school','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(4,'Entertainment','mdi mdi-bed-outline','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(5,'Pharmacy','mdi mdi-mortar-pestle-plus','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(6,'Airport','mdi mdi-airplane-takeoff','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(7,'Railways','mdi mdi-subway','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(8,'Bus Stop','mdi mdi-bus','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(9,'Beach','mdi mdi-beach','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(10,'Mall','mdi mdi-shopping','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(11,'Bank','mdi mdi-bank-check','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(12,'Fitness','mdi mdi-weight-lifter','published','2023-12-22 03:30:49','2023-12-22 03:30:49');
/*!40000 ALTER TABLE `re_facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_facilities_distances`
--

DROP TABLE IF EXISTS `re_facilities_distances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_facilities_distances` (
  `facility_id` bigint unsigned NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `reference_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `distance` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`facility_id`,`reference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_facilities_distances`
--

LOCK TABLES `re_facilities_distances` WRITE;
/*!40000 ALTER TABLE `re_facilities_distances` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_facilities_distances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_facilities_translations`
--

DROP TABLE IF EXISTS `re_facilities_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_facilities_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_facilities_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_facilities_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_facilities_translations`
--

LOCK TABLES `re_facilities_translations` WRITE;
/*!40000 ALTER TABLE `re_facilities_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_facilities_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_features`
--

DROP TABLE IF EXISTS `re_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_features` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_features`
--

LOCK TABLES `re_features` WRITE;
/*!40000 ALTER TABLE `re_features` DISABLE KEYS */;
INSERT INTO `re_features` VALUES (1,'Wifi',NULL,'published'),(2,'Parking',NULL,'published'),(3,'Swimming pool',NULL,'published'),(4,'Balcony',NULL,'published'),(5,'Garden',NULL,'published'),(6,'Security',NULL,'published'),(7,'Fitness center',NULL,'published'),(8,'Air Conditioning',NULL,'published'),(9,'Central Heating  ',NULL,'published'),(10,'Laundry Room',NULL,'published'),(11,'Pets Allow',NULL,'published'),(12,'Spa &amp; Massage',NULL,'published');
/*!40000 ALTER TABLE `re_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_features_translations`
--

DROP TABLE IF EXISTS `re_features_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_features_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_features_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_features_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_features_translations`
--

LOCK TABLES `re_features_translations` WRITE;
/*!40000 ALTER TABLE `re_features_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_features_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_investors`
--

DROP TABLE IF EXISTS `re_investors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_investors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_investors`
--

LOCK TABLES `re_investors` WRITE;
/*!40000 ALTER TABLE `re_investors` DISABLE KEYS */;
INSERT INTO `re_investors` VALUES (1,'National Pension Service','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(2,'Generali','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(3,'Temasek','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(4,'China Investment Corporation','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(5,'Government Pension Fund Global','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(6,'PSP Investments','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(7,'MEAG Munich ERGO','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(8,'HOOPP','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(9,'BT Group','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(10,'New York City ERS','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(11,'New Jersey Division of Investment','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(12,'State Super','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(13,'Shinkong','published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(14,'Rest Super','published','2023-12-22 03:30:49','2023-12-22 03:30:49');
/*!40000 ALTER TABLE `re_investors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_invoice_items`
--

DROP TABLE IF EXISTS `re_invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_invoice_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int unsigned NOT NULL,
  `sub_total` decimal(15,2) unsigned NOT NULL,
  `tax_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `amount` decimal(15,2) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_invoice_items`
--

LOCK TABLES `re_invoice_items` WRITE;
/*!40000 ALTER TABLE `re_invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_invoices`
--

DROP TABLE IF EXISTS `re_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_invoices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `payment_id` bigint unsigned DEFAULT NULL,
  `reference_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_total` decimal(15,2) unsigned NOT NULL,
  `tax_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `coupon_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(15,2) unsigned NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `re_invoices_code_unique` (`code`),
  KEY `re_invoices_reference_type_reference_id_index` (`reference_type`,`reference_id`),
  KEY `re_invoices_payment_id_index` (`payment_id`),
  KEY `re_invoices_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_invoices`
--

LOCK TABLES `re_invoices` WRITE;
/*!40000 ALTER TABLE `re_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_packages`
--

DROP TABLE IF EXISTS `re_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_packages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double(15,2) unsigned NOT NULL,
  `currency_id` bigint unsigned NOT NULL,
  `percent_save` int unsigned NOT NULL DEFAULT '0',
  `number_of_listings` int unsigned NOT NULL,
  `account_limit` int unsigned DEFAULT NULL,
  `order` tinyint NOT NULL DEFAULT '0',
  `is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_packages`
--

LOCK TABLES `re_packages` WRITE;
/*!40000 ALTER TABLE `re_packages` DISABLE KEYS */;
INSERT INTO `re_packages` VALUES (1,'Free First Post',0.00,1,0,1,1,0,0,'published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(2,'Single Post',250.00,1,0,1,NULL,0,1,'published','2023-12-22 03:30:49','2023-12-22 03:30:49'),(3,'5 Posts',1000.00,1,20,5,NULL,0,0,'published','2023-12-22 03:30:49','2023-12-22 03:30:49');
/*!40000 ALTER TABLE `re_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_packages_translations`
--

DROP TABLE IF EXISTS `re_packages_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_packages_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_packages_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_packages_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_packages_translations`
--

LOCK TABLES `re_packages_translations` WRITE;
/*!40000 ALTER TABLE `re_packages_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_packages_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_project_categories`
--

DROP TABLE IF EXISTS `re_project_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_project_categories` (
  `project_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`project_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_project_categories`
--

LOCK TABLES `re_project_categories` WRITE;
/*!40000 ALTER TABLE `re_project_categories` DISABLE KEYS */;
INSERT INTO `re_project_categories` VALUES (1,1),(1,2),(1,4),(1,5),(1,6),(2,2),(2,3),(2,4),(2,5),(2,6),(3,1),(3,2),(3,3),(3,5),(3,6),(4,1),(4,4),(4,5),(4,6),(5,1),(5,2),(5,3),(5,5),(5,6),(6,1),(6,2),(6,4),(6,5),(6,6),(7,1),(7,2),(7,3),(7,4),(8,3),(8,4),(8,5),(8,6),(9,2),(9,3),(9,6),(10,2),(10,3),(10,6),(11,1),(11,2),(11,3),(11,5),(12,1),(12,2),(12,3),(12,4),(13,1),(13,3),(13,4),(13,5),(13,6),(14,3),(14,4),(14,6),(15,3),(15,6),(16,1),(16,4),(16,5),(16,6),(17,1),(17,2),(17,3),(17,5),(17,6),(18,1),(18,3),(18,4),(18,5),(18,6);
/*!40000 ALTER TABLE `re_project_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_project_features`
--

DROP TABLE IF EXISTS `re_project_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_project_features` (
  `project_id` bigint unsigned NOT NULL,
  `feature_id` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_project_features`
--

LOCK TABLES `re_project_features` WRITE;
/*!40000 ALTER TABLE `re_project_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_project_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_projects`
--

DROP TABLE IF EXISTS `re_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_projects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `images` text COLLATE utf8mb4_unicode_ci,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `investor_id` bigint unsigned NOT NULL,
  `number_block` int DEFAULT NULL,
  `number_floor` smallint DEFAULT NULL,
  `number_flat` smallint DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `date_finish` date DEFAULT NULL,
  `date_sell` date DEFAULT NULL,
  `price_from` decimal(15,0) DEFAULT NULL,
  `price_to` decimal(15,0) DEFAULT NULL,
  `currency_id` bigint unsigned DEFAULT NULL,
  `city_id` bigint unsigned DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'selling',
  `author_id` bigint unsigned DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Botble\\ACL\\Models\\User',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `latitude` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `views` int unsigned NOT NULL DEFAULT '0',
  `country_id` bigint unsigned DEFAULT '1',
  `state_id` bigint unsigned DEFAULT NULL,
  `unique_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `re_projects_unique_id_unique` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_projects`
--

LOCK TABLES `re_projects` WRITE;
/*!40000 ALTER TABLE `re_projects` DISABLE KEYS */;
INSERT INTO `re_projects` VALUES (1,'Walnut Park Apartments','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/4.jpg\",\"properties\\/6.jpg\",\"properties\\/3.jpg\",\"properties\\/1.jpg\",\"properties\\/5.jpg\",\"properties\\/7.jpg\",\"properties\\/11.jpg\"]','410 Zena Street\nNorth Yolandaside, MS 56168-7321',7,10,1,3533,0,'2023-04-09','1992-05-18',2108,9945,1,3,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.102537','-75.996161',6172,5,5,NULL),(2,'Sunshine Wonder Villas','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/6.jpg\",\"properties\\/1.jpg\",\"properties\\/4.jpg\",\"properties\\/8.jpg\",\"properties\\/5.jpg\",\"properties\\/2.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/9.jpg\",\"properties\\/12.jpg\"]','71771 Dach Ports\nNorth Deltaland, AL 03377',3,3,19,1282,1,'1977-08-04','2002-04-26',6988,11843,1,3,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.632914','-76.404745',4329,4,1,NULL),(3,'Diamond Island','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/3.jpg\",\"properties\\/10.jpg\",\"properties\\/9.jpg\",\"properties\\/7.jpg\",\"properties\\/5.jpg\",\"properties\\/6.jpg\",\"properties\\/1.jpg\"]','7487 Pauline Harbors Suite 250\nLorenburgh, NJ 51098-0625',2,3,39,3562,1,'2006-10-17','1976-06-20',7614,10229,1,2,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.563736','-75.384905',826,3,4,NULL),(4,'The Nassim','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/6.jpg\",\"properties\\/12.jpg\",\"properties\\/2.jpg\",\"properties\\/4.jpg\",\"properties\\/7.jpg\",\"properties\\/8.jpg\"]','7644 Bradtke Throughway Apt. 613\nHershelview, OH 18599-3818',12,9,37,3119,0,'2012-09-23','2017-04-25',3161,6999,1,1,'selling',2,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.713996','-76.184528',5530,5,2,NULL),(5,'Vinhomes Grand Park','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/10.jpg\",\"properties\\/9.jpg\",\"properties\\/7.jpg\",\"properties\\/2.jpg\",\"properties\\/11.jpg\",\"properties\\/8.jpg\",\"properties\\/12.jpg\"]','9914 Christopher Drives Suite 517\nNorth Jakefort, TX 05866-1588',7,2,40,365,1,'1995-05-07','1995-12-29',7231,13964,1,2,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.011734','-74.806732',1280,2,3,NULL),(6,'The Metropole Thu Thiem','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/1.jpg\",\"properties\\/2.jpg\",\"properties\\/9.jpg\",\"properties\\/12.jpg\",\"properties\\/8.jpg\"]','13117 Kiara Lock\nLake Juliastad, CT 34730',13,8,27,4637,1,'2019-09-04','1999-04-01',2632,5423,1,4,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.953545','-74.990598',7196,6,1,NULL),(7,'Villa on Grand Avenue','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/3.jpg\",\"properties\\/6.jpg\",\"properties\\/8.jpg\",\"properties\\/4.jpg\",\"properties\\/10.jpg\",\"properties\\/5.jpg\",\"properties\\/1.jpg\",\"properties\\/12.jpg\",\"properties\\/2.jpg\"]','100 Bode Springs Suite 927\nLake Elnatown, AK 82274',2,2,10,1958,1,'1985-05-18','2000-07-13',9592,17385,1,5,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.942628','-76.175626',1239,6,3,NULL),(8,'Traditional Food Restaurant','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/12.jpg\",\"properties\\/6.jpg\",\"properties\\/3.jpg\",\"properties\\/10.jpg\",\"properties\\/1.jpg\",\"properties\\/9.jpg\",\"properties\\/2.jpg\",\"properties\\/4.jpg\"]','225 Zulauf Squares\nCandaceland, NC 12831',12,10,16,523,0,'1988-01-07','2022-10-01',3569,5149,1,1,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.487515','-74.975889',7637,2,5,NULL),(9,'Villa on Hollywood Boulevard','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/3.jpg\",\"properties\\/8.jpg\",\"properties\\/9.jpg\",\"properties\\/12.jpg\",\"properties\\/5.jpg\",\"properties\\/10.jpg\",\"properties\\/1.jpg\"]','5514 Rohan Common Apt. 341\nPort Zackerychester, OK 92814-3887',12,4,1,1968,0,'1992-10-23','2004-01-12',5597,12217,1,4,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.693298','-75.104219',5673,6,3,NULL),(10,'Office Space at Northwest 107th','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/9.jpg\",\"properties\\/11.jpg\",\"properties\\/7.jpg\",\"properties\\/4.jpg\",\"properties\\/5.jpg\",\"properties\\/12.jpg\"]','9775 Matilda Club Suite 138\nRoderickborough, RI 39754',8,8,49,204,0,'1998-12-27','1975-11-06',4574,5230,1,3,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.662013','-75.209323',8853,2,4,NULL),(11,'Home in Merrick Way','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/5.jpg\",\"properties\\/11.jpg\",\"properties\\/1.jpg\",\"properties\\/10.jpg\",\"properties\\/9.jpg\",\"properties\\/7.jpg\",\"properties\\/8.jpg\",\"properties\\/6.jpg\",\"properties\\/12.jpg\",\"properties\\/4.jpg\"]','56712 Catherine Drive Suite 824\nNew Myles, NJ 98416',5,3,10,1875,1,'1989-10-11','2021-03-23',526,8399,1,4,'selling',2,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.858362','-74.867507',7124,1,4,NULL),(12,'Adarsh Greens','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/8.jpg\",\"properties\\/12.jpg\",\"properties\\/2.jpg\",\"properties\\/10.jpg\",\"properties\\/1.jpg\",\"properties\\/4.jpg\",\"properties\\/11.jpg\",\"properties\\/5.jpg\"]','4629 Mitchell Green Apt. 619\nBodemouth, IL 53935',1,2,50,2133,1,'1995-11-05','1975-05-20',9244,14933,1,4,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.976015','-75.552187',1146,4,2,NULL),(13,'Rustomjee Evershine Global City','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/9.jpg\",\"properties\\/1.jpg\",\"properties\\/5.jpg\",\"properties\\/10.jpg\",\"properties\\/12.jpg\",\"properties\\/6.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/4.jpg\",\"properties\\/2.jpg\"]','1166 Hegmann Crossroad Apt. 262\nEast Juston, GA 59865',11,3,26,1603,0,'1990-01-04','1974-09-15',9150,11864,1,4,'selling',2,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.216393','-75.780333',8913,6,2,NULL),(14,'Godrej Exquisite','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/2.jpg\",\"properties\\/10.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/6.jpg\",\"properties\\/5.jpg\",\"properties\\/7.jpg\",\"properties\\/8.jpg\",\"properties\\/9.jpg\",\"properties\\/4.jpg\",\"properties\\/12.jpg\",\"properties\\/1.jpg\"]','3878 Susana Roads Apt. 347\nFeestfurt, WY 66456-5347',2,9,19,1041,1,'2005-03-11','1999-07-10',2575,12230,1,1,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','43.355405','-75.325012',9598,2,3,NULL),(15,'Godrej Prime','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/10.jpg\",\"properties\\/1.jpg\",\"properties\\/7.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/5.jpg\",\"properties\\/12.jpg\",\"properties\\/4.jpg\",\"properties\\/6.jpg\",\"properties\\/8.jpg\",\"properties\\/2.jpg\",\"properties\\/9.jpg\"]','82531 Bo Forks\nNorth Amir, TX 80279-2072',1,3,34,3804,1,'1989-01-13','1981-12-29',1503,9564,1,4,'selling',2,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.989704','-75.502546',347,5,5,NULL),(16,'PS Panache','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/8.jpg\",\"properties\\/6.jpg\",\"properties\\/1.jpg\",\"properties\\/5.jpg\",\"properties\\/2.jpg\",\"properties\\/12.jpg\",\"properties\\/7.jpg\",\"properties\\/4.jpg\",\"properties\\/9.jpg\"]','47698 Darryl Trail\nWest Jarrod, MA 96812-6428',14,4,39,4377,0,'2008-03-24','2007-09-28',8346,12407,1,4,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.97745','-75.289051',6591,2,4,NULL),(17,'Upturn Atmiya Centria','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/9.jpg\",\"properties\\/5.jpg\",\"properties\\/8.jpg\",\"properties\\/2.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/10.jpg\",\"properties\\/6.jpg\",\"properties\\/4.jpg\",\"properties\\/12.jpg\"]','504 Gaston Summit Suite 584\nNorth Dahliatown, LA 77031-2449',6,2,26,277,0,'1974-06-07','2004-05-05',924,5475,1,2,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.721332','-75.590861',9180,3,5,NULL),(18,'Brigade Oasis','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','[\"properties\\/5.jpg\",\"properties\\/4.jpg\",\"properties\\/12.jpg\",\"properties\\/7.jpg\",\"properties\\/11.jpg\"]','316 Jakayla Meadow\nNorth Martin, SC 66487-5626',5,5,47,1255,1,'2016-01-23','1975-10-28',523,8418,1,4,'selling',1,'Botble\\ACL\\Models\\User','2023-12-22 03:30:49','2023-12-22 03:30:49','42.885764','-75.913781',3890,3,2,NULL);
/*!40000 ALTER TABLE `re_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_projects_translations`
--

DROP TABLE IF EXISTS `re_projects_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_projects_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_projects_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_projects_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_projects_translations`
--

LOCK TABLES `re_projects_translations` WRITE;
/*!40000 ALTER TABLE `re_projects_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_projects_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_properties`
--

DROP TABLE IF EXISTS `re_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_properties` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sale',
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `images` text COLLATE utf8mb4_unicode_ci,
  `project_id` bigint unsigned DEFAULT '0',
  `number_bedroom` int DEFAULT NULL,
  `number_bathroom` int DEFAULT NULL,
  `number_floor` int DEFAULT NULL,
  `square` double DEFAULT NULL,
  `price` decimal(15,2) DEFAULT NULL,
  `currency_id` bigint unsigned DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `city_id` bigint unsigned DEFAULT NULL,
  `period` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'month',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'selling',
  `author_id` bigint unsigned DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Botble\\ACL\\Models\\User',
  `moderation_status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `expire_date` date DEFAULT NULL,
  `auto_renew` tinyint(1) NOT NULL DEFAULT '0',
  `never_expired` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `latitude` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `views` int unsigned NOT NULL DEFAULT '0',
  `country_id` bigint unsigned DEFAULT '1',
  `state_id` bigint unsigned DEFAULT NULL,
  `unique_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `re_properties_unique_id_unique` (`unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_properties`
--

LOCK TABLES `re_properties` WRITE;
/*!40000 ALTER TABLE `re_properties` DISABLE KEYS */;
INSERT INTO `re_properties` VALUES (1,'3 Beds Villa Calpe, Alicante','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','8720 Jacobi Tunnel\nFunkfort, ND 50330','[\"properties\\/2.jpg\",\"properties\\/7.jpg\",\"properties\\/5.jpg\",\"properties\\/1.jpg\",\"properties\\/6.jpg\",\"properties\\/12.jpg\",\"properties\\/9.jpg\",\"properties\\/11.jpg\",\"properties\\/4.jpg\",\"properties\\/10.jpg\",\"properties\\/3.jpg\",\"properties\\/8.jpg\"]',4,9,5,26,200,658900.00,NULL,0,4,'month','renting',20,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.099231','-76.152567',14819,1,3,NULL),(2,'Lavida Plus Office-tel 1 Bedroom','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','83016 Tromp Crossroad Suite 889\nNew Daronhaven, MO 32177','[\"properties\\/2.jpg\",\"properties\\/4.jpg\",\"properties\\/1.jpg\",\"properties\\/11.jpg\",\"properties\\/10.jpg\"]',5,7,8,9,90,597800.00,NULL,0,2,'month','renting',10,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.664039','-74.931979',83025,4,6,NULL),(3,'Vinhomes Grand Park Studio 1 Bedroom','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','48622 Botsford Rue Suite 719\nRuntetown, DC 62627-9048','[\"properties\\/3.jpg\",\"properties\\/8.jpg\",\"properties\\/6.jpg\",\"properties\\/9.jpg\",\"properties\\/4.jpg\",\"properties\\/1.jpg\",\"properties\\/10.jpg\",\"properties\\/11.jpg\",\"properties\\/12.jpg\",\"properties\\/5.jpg\"]',3,4,1,86,340,127900.00,NULL,1,4,'month','renting',1,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.274086','-76.203177',44471,4,4,NULL),(4,'The Sun Avenue Office-tel 1 Bedroom','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','73964 Borer Coves\nCourtneyville, NE 12460-3566','[\"properties\\/2.jpg\",\"properties\\/5.jpg\",\"properties\\/1.jpg\",\"properties\\/8.jpg\",\"properties\\/6.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/7.jpg\",\"properties\\/9.jpg\",\"properties\\/10.jpg\",\"properties\\/12.jpg\",\"properties\\/4.jpg\"]',5,3,6,18,730,647200.00,NULL,1,3,'month','renting',17,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.879469','-75.287771',51720,2,3,NULL),(5,'Property For sale, Johannesburg, South Africa','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','236 Margaretta Burg\nKrisfurt, DE 41634','[\"properties\\/7.jpg\",\"properties\\/2.jpg\",\"properties\\/1.jpg\",\"properties\\/4.jpg\",\"properties\\/3.jpg\",\"properties\\/5.jpg\",\"properties\\/10.jpg\",\"properties\\/8.jpg\",\"properties\\/11.jpg\",\"properties\\/6.jpg\",\"properties\\/12.jpg\",\"properties\\/9.jpg\"]',1,9,10,6,20,73600.00,NULL,0,4,'month','renting',10,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.541229','-76.594064',89125,3,1,NULL),(6,'Stunning French Inspired Manor','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','1035 Becker Unions\nNew Maggie, GA 88605','[\"properties\\/12.jpg\",\"properties\\/5.jpg\",\"properties\\/9.jpg\",\"properties\\/7.jpg\",\"properties\\/4.jpg\",\"properties\\/8.jpg\",\"properties\\/10.jpg\",\"properties\\/6.jpg\",\"properties\\/11.jpg\",\"properties\\/3.jpg\",\"properties\\/1.jpg\"]',4,6,10,65,200,414100.00,NULL,1,1,'month','renting',5,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.987884','-75.006474',26807,5,6,NULL),(7,'Villa for sale at Bermuda Dunes','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','87123 Jacobi Courts\nLeschborough, MT 21666-2067','[\"properties\\/2.jpg\",\"properties\\/3.jpg\",\"properties\\/10.jpg\",\"properties\\/9.jpg\",\"properties\\/8.jpg\",\"properties\\/1.jpg\",\"properties\\/4.jpg\",\"properties\\/6.jpg\",\"properties\\/12.jpg\",\"properties\\/7.jpg\",\"properties\\/11.jpg\",\"properties\\/5.jpg\"]',1,10,4,54,800,89300.00,NULL,0,1,'month','renting',18,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','44.01108','-75.189488',77519,1,6,NULL),(8,'Walnut Park Apartment','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','80171 Anderson Rest\nLake Gilda, IL 37055-2231','[\"properties\\/10.jpg\",\"properties\\/7.jpg\",\"properties\\/4.jpg\",\"properties\\/6.jpg\",\"properties\\/2.jpg\"]',1,4,2,16,600,955400.00,NULL,0,5,'month','renting',11,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.595644','-75.9787',88650,1,5,NULL),(9,'5 beds luxury house','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','557 Ona Path Apt. 217\nSouth Sharon, CA 45286-8026','[\"properties\\/1.jpg\",\"properties\\/2.jpg\",\"properties\\/9.jpg\",\"properties\\/3.jpg\",\"properties\\/8.jpg\",\"properties\\/6.jpg\"]',8,5,8,10,800,593900.00,NULL,0,3,'month','renting',12,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.744854','-74.796298',45682,5,2,NULL),(10,'Family Victorian \"View\" Home','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','771 Shaun Manors Apt. 257\nGleasonmouth, AK 29993-9456','[\"properties\\/8.jpg\",\"properties\\/1.jpg\",\"properties\\/7.jpg\",\"properties\\/11.jpg\",\"properties\\/9.jpg\",\"properties\\/10.jpg\",\"properties\\/2.jpg\"]',11,5,9,21,350,20800.00,NULL,1,5,'month','renting',5,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.974613','-76.122719',51187,4,3,NULL),(11,'Osaka Heights Apartment','sale','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','826 Silas Curve Suite 582\nNorth Arianna, NM 43374','[\"properties\\/3.jpg\",\"properties\\/6.jpg\",\"properties\\/8.jpg\",\"properties\\/2.jpg\",\"properties\\/12.jpg\",\"properties\\/1.jpg\",\"properties\\/10.jpg\",\"properties\\/9.jpg\",\"properties\\/5.jpg\"]',11,7,5,69,110,809700.00,NULL,1,1,'month','selling',6,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.254586','-76.5183',10946,4,4,NULL),(12,'Private Estate Magnificent Views','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','4570 Marquardt Rue Apt. 873\nLake Orlo, NY 50755','[\"properties\\/5.jpg\",\"properties\\/6.jpg\",\"properties\\/8.jpg\",\"properties\\/4.jpg\",\"properties\\/1.jpg\",\"properties\\/3.jpg\"]',16,6,1,43,380,803300.00,NULL,1,4,'month','renting',8,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.75842','-76.436006',86529,4,3,NULL),(13,'Thompson Road House for rent','sale','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','2912 Tillman Extension\nPort Anneberg, AK 66835-6467','[\"properties\\/3.jpg\",\"properties\\/9.jpg\",\"properties\\/10.jpg\",\"properties\\/4.jpg\",\"properties\\/8.jpg\",\"properties\\/12.jpg\",\"properties\\/1.jpg\",\"properties\\/2.jpg\",\"properties\\/7.jpg\"]',7,5,3,18,940,225000.00,NULL,1,5,'month','selling',12,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.544275','-76.094232',21702,1,1,NULL),(14,'Brand New 1 Bedroom Apartment In First Class Location','sale','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','966 Aurore Tunnel\nNew Alanside, AR 73143','[\"properties\\/10.jpg\",\"properties\\/4.jpg\",\"properties\\/8.jpg\",\"properties\\/6.jpg\",\"properties\\/1.jpg\",\"properties\\/12.jpg\",\"properties\\/7.jpg\",\"properties\\/2.jpg\",\"properties\\/9.jpg\",\"properties\\/5.jpg\",\"properties\\/11.jpg\"]',7,2,8,43,120,514100.00,NULL,1,1,'month','selling',10,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.860565','-76.729026',85828,4,3,NULL),(15,'Elegant family home presents premium modern living','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','61413 Mraz Pike Apt. 901\nLake Mckennaton, MA 47287','[\"properties\\/3.jpg\",\"properties\\/8.jpg\",\"properties\\/11.jpg\",\"properties\\/9.jpg\",\"properties\\/7.jpg\",\"properties\\/1.jpg\",\"properties\\/12.jpg\",\"properties\\/2.jpg\"]',17,5,6,35,660,697700.00,NULL,1,5,'month','renting',9,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.851026','-76.652078',89979,6,6,NULL),(16,'Luxury Apartments in Singapore for Sale','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','965 Enid Circle\nNorth Marcelino, WV 26628-5429','[\"properties\\/11.jpg\",\"properties\\/4.jpg\",\"properties\\/12.jpg\",\"properties\\/10.jpg\",\"properties\\/9.jpg\",\"properties\\/7.jpg\",\"properties\\/1.jpg\",\"properties\\/6.jpg\",\"properties\\/5.jpg\"]',12,1,2,5,990,674100.00,NULL,0,3,'month','renting',21,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.968494','-75.122803',21613,5,4,NULL),(17,'5 room luxury penthouse for sale in Kuala Lumpur','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','305 Albin Gardens\nJedstad, KS 51673','[\"properties\\/1.jpg\",\"properties\\/8.jpg\",\"properties\\/3.jpg\",\"properties\\/11.jpg\",\"properties\\/5.jpg\",\"properties\\/6.jpg\"]',8,5,4,72,460,496100.00,NULL,0,4,'month','renting',8,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.922846','-74.820814',70632,2,3,NULL),(18,'2 Floor house in Compound Pejaten Barat Kemang','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','859 Aron Mills\nBorermouth, AK 70623','[\"properties\\/7.jpg\",\"properties\\/10.jpg\",\"properties\\/2.jpg\",\"properties\\/9.jpg\",\"properties\\/1.jpg\"]',15,7,7,51,260,813000.00,NULL,0,2,'month','renting',2,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','42.754442','-75.938589',86129,4,3,NULL),(19,'Apartment Muiderstraatweg in Diemen','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','1292 Tiffany Divide\nLake Dina, CT 70253-9072','[\"properties\\/7.jpg\",\"properties\\/1.jpg\",\"properties\\/9.jpg\",\"properties\\/3.jpg\",\"properties\\/10.jpg\",\"properties\\/8.jpg\",\"properties\\/12.jpg\",\"properties\\/4.jpg\"]',2,4,8,36,340,563300.00,NULL,0,5,'month','renting',16,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.245542','-76.492112',88668,5,2,NULL),(20,'Nice Apartment for rent in Berlin','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','8284 Alessia Track\nWehnerstad, PA 45675-6225','[\"properties\\/4.jpg\",\"properties\\/9.jpg\",\"properties\\/2.jpg\",\"properties\\/6.jpg\",\"properties\\/11.jpg\",\"properties\\/5.jpg\",\"properties\\/12.jpg\"]',9,2,8,24,990,560800.00,NULL,0,5,'month','renting',13,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.400566','-75.33246',21755,6,4,NULL),(21,'Pumpkin Key - Private Island','rent','<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen sink with drain board and\n    provisions for water purifier , electric hood , exhaust fan will be provided</p>\n','<h4>Kitchen</h4>\n<p>Ceramic tiled flooring, Granite counter top , Single bowl stainless steel kitchen\n    sink with drain board and provisions for water purifier , electric hood , exhaust fan will be provided</p>\n<br>\n<h4>Toilets</h4>\n<p>Anti-skid Ceramic tiles on floor and ceramic wall tiles up to 7 feet height. White\n    coloured branded sanitary fittings, Chromium plated taps , concealed plumbing</p>\n<br>\n<h4>Doors</h4>\n<p>Main door will be high quality wooden door, premium Windows quality pre-hung internal\n    doors with wooded frame, UPVC or aluminum sliding doors and aluminum frame with glass for windows</p>\n<ul>\n    <li> 9 km to Katunayaka airport expressway entrance</li>\n    <li> 12 km to Southern expressway entrance at Kottawa</li>\n    <li> 2 km to Kalubowila General hospital</li>\n    <li> All leading banks within a few kilometer radii</li>\n    <li> Very close proximity to railway stations</li>\n    <li> Many leading schools including CIS within 5 km radius</li>\n</ul>\n','56246 Collins Shore Suite 200\nWest Marisa, OR 72958','[\"properties\\/12.jpg\",\"properties\\/8.jpg\",\"properties\\/9.jpg\",\"properties\\/1.jpg\",\"properties\\/3.jpg\",\"properties\\/5.jpg\"]',18,5,2,22,980,564600.00,NULL,1,2,'month','renting',17,'Botble\\RealEstate\\Models\\Account','approved','1970-01-01',0,1,'2023-12-22 03:30:49','2023-12-22 03:30:49','43.263349','-76.673805',70503,1,2,NULL);
/*!40000 ALTER TABLE `re_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_properties_translations`
--

DROP TABLE IF EXISTS `re_properties_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_properties_translations` (
  `lang_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `re_properties_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`re_properties_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_properties_translations`
--

LOCK TABLES `re_properties_translations` WRITE;
/*!40000 ALTER TABLE `re_properties_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_properties_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_property_categories`
--

DROP TABLE IF EXISTS `re_property_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_property_categories` (
  `property_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`property_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_property_categories`
--

LOCK TABLES `re_property_categories` WRITE;
/*!40000 ALTER TABLE `re_property_categories` DISABLE KEYS */;
INSERT INTO `re_property_categories` VALUES (1,2),(2,6),(3,2),(3,3),(3,6),(4,1),(4,2),(4,6),(5,1),(5,2),(5,3),(5,6),(6,2),(6,6),(7,1),(7,3),(7,5),(8,1),(8,5),(9,1),(9,2),(9,3),(9,5),(9,6),(10,2),(10,3),(10,4),(10,5),(10,6),(11,3),(12,1),(12,2),(12,6),(13,1),(13,3),(14,1),(14,2),(14,4),(14,6),(15,2),(16,5),(17,3),(18,1),(18,2),(18,3),(18,4),(18,5),(19,4),(19,5),(19,6),(20,4),(20,5),(21,3);
/*!40000 ALTER TABLE `re_property_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_property_features`
--

DROP TABLE IF EXISTS `re_property_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_property_features` (
  `property_id` bigint unsigned NOT NULL,
  `feature_id` bigint unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_property_features`
--

LOCK TABLES `re_property_features` WRITE;
/*!40000 ALTER TABLE `re_property_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `re_property_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `re_reviews`
--

DROP TABLE IF EXISTS `re_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `re_reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `reviewable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reviewable_id` bigint unsigned NOT NULL,
  `star` tinyint NOT NULL,
  `content` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'approved',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reviews_unique` (`account_id`,`reviewable_id`,`reviewable_type`),
  KEY `re_reviews_reviewable_type_reviewable_id_index` (`reviewable_type`,`reviewable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `re_reviews`
--

LOCK TABLES `re_reviews` WRITE;
/*!40000 ALTER TABLE `re_reviews` DISABLE KEYS */;
INSERT INTO `re_reviews` VALUES (1,16,'Botble\\RealEstate\\Models\\Property',11,3,'I don\'t take this young lady to see it again, but it was too dark to see.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(2,16,'Botble\\RealEstate\\Models\\Property',1,4,'She said this she looked up eagerly, half hoping that the Gryphon went on, yawning and rubbing its eyes, for it flashed across her mind that.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(3,11,'Botble\\RealEstate\\Models\\Property',21,3,'King, and the moon, and memory, and muchness--you know you say \"What a pity!\"?\' the Rabbit came near her, she began, in a very little use, as it happens; and if the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(4,9,'Botble\\RealEstate\\Models\\Property',12,4,'Mock Turtle in the wind, and the three gardeners instantly threw themselves flat upon their faces, so that they would die. \'The trial cannot proceed,\' said the King was the White Rabbit; \'in fact, there\'s.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(5,1,'Botble\\RealEstate\\Models\\Property',4,4,'I\'m here! Digging for apples, yer honour!\' \'Digging for apples, indeed!\' said the Gryphon never learnt it.\' \'Hadn\'t.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(6,15,'Botble\\RealEstate\\Models\\Project',11,4,'The Fish-Footman began by taking the little door: but, alas! either the locks were too large, or the key was too dark to see if she meant to take out of court! Suppress him! Pinch him! Off with his whiskers!\' For some minutes it seemed quite natural to Alice.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(7,10,'Botble\\RealEstate\\Models\\Project',4,3,'And here poor Alice in a furious passion, and.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(8,3,'Botble\\RealEstate\\Models\\Property',6,3,'WOULD twist itself round and look up in great disgust, and walked a little queer, won\'t you?\' \'Not a bit,\' she thought at first was in such long ringlets, and mine doesn\'t go in ringlets at all; however, she went on growing, and, as the other.\' As soon as she went back to the Gryphon.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(9,12,'Botble\\RealEstate\\Models\\Project',18,3,'Alice looked all round her head. Still she went on \'And how many miles I\'ve fallen by this time.) \'You\'re nothing but the Rabbit actually TOOK A WATCH OUT OF ITS WAISTCOAT-POCKET, and looked along the course, here and there was a table set out under a tree in.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(10,11,'Botble\\RealEstate\\Models\\Property',13,3,'Gryphon hastily. \'Go on with the dream of Wonderland of long ago: and how she would catch a bat, and that\'s all the party.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(11,20,'Botble\\RealEstate\\Models\\Property',4,3,'Alice asked in a soothing tone: \'don\'t be angry.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(12,6,'Botble\\RealEstate\\Models\\Property',15,2,'Tell her to wink with one elbow against the roof off.\' After a while, finding that nothing more to come, so she sat still just as well as she went on. \'Would you like the largest telescope that ever was!.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(13,5,'Botble\\RealEstate\\Models\\Property',3,1,'Alice, always ready to ask the question?\' said the Cat, \'a dog\'s not mad. You grant that?\' \'I suppose so,\' said the King: \'however, it may kiss my hand if.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(14,17,'Botble\\RealEstate\\Models\\Project',3,4,'I could not make out exactly what they WILL do next! If they had settled down again, the Dodo solemnly, rising to its feet, \'I move that the poor little juror (it was exactly three inches high). \'But I\'m NOT a serpent, I tell you, you coward!\' and at once took up the chimney, has he?\' said.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(15,13,'Botble\\RealEstate\\Models\\Property',8,1,'By the time at the Hatter, it woke up again as quickly as she went on. \'I do,\' Alice said with a pair of white kid gloves in one hand and a piece of it in her life; it was as long as there was a different person then.\' \'Explain all that,\' said the Dormouse, after thinking a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(16,14,'Botble\\RealEstate\\Models\\Project',14,4,'Dodo, \'the best way you can;--but I must have been that,\' said the Mouse. \'--I proceed. \"Edwin and Morcar, the earls of Mercia.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(17,17,'Botble\\RealEstate\\Models\\Property',12,5,'Alice, she went on. Her listeners were perfectly.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(18,5,'Botble\\RealEstate\\Models\\Project',2,3,'I can\'t show it you myself,\' the Mock Turtle Soup is made from,\' said the Hatter. \'You might just as usual. I wonder if.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(19,10,'Botble\\RealEstate\\Models\\Property',5,3,'Alice could hear him sighing as if he wasn\'t one?\' Alice asked. The Hatter was the matter with it. There could be NO mistake about it: it was the White Rabbit, who was sitting on the back. At last the Mock Turtle went on. Her listeners were perfectly quiet till.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(20,1,'Botble\\RealEstate\\Models\\Project',8,5,'Alice was not here before,\' said the Gryphon. \'It\'s all her life. Indeed, she had never done such a thing as \"I eat what I eat\" is the reason of that?\' \'In my youth,\' said the sage, as he fumbled over the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(21,8,'Botble\\RealEstate\\Models\\Property',15,1,'The Hatter looked at it uneasily, shaking it every now and then she noticed a curious dream, dear, certainly: but now run in to your places!\' shouted the Gryphon.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(22,10,'Botble\\RealEstate\\Models\\Property',7,2,'Mock Turtle is.\' \'It\'s the oldest rule.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(23,11,'Botble\\RealEstate\\Models\\Project',13,2,'Hatter: \'as the things I used to queer things happening. While she was quite pleased to find that her.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(24,17,'Botble\\RealEstate\\Models\\Property',7,4,'White Rabbit, with a deep sigh, \'I.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(25,12,'Botble\\RealEstate\\Models\\Property',19,1,'I can guess that,\' she added aloud. \'Do you mean that you never tasted an egg!\' \'I HAVE tasted eggs, certainly,\' said Alice more boldly: \'you know you\'re growing too.\' \'Yes, but some crumbs must have been changed for Mabel! I\'ll try and say.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(26,4,'Botble\\RealEstate\\Models\\Property',9,4,'Alice to herself. Imagine her surprise, when the tide rises and sharks are around, His voice has a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(27,13,'Botble\\RealEstate\\Models\\Project',2,2,'They had not the right thing to get in at once.\' And in she went. Once more she found she could not swim. He sent them word I had to be no doubt that it seemed quite natural to Alice a good deal frightened at the March Hare. Alice was not a moment to be talking in a low.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(28,5,'Botble\\RealEstate\\Models\\Property',8,1,'Alice, \'to speak to this mouse? Everything is so out-of-the-way down here, and I\'m sure I don\'t care which.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(29,18,'Botble\\RealEstate\\Models\\Project',9,5,'Cat,\' said Alice: \'I don\'t like.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(30,19,'Botble\\RealEstate\\Models\\Property',12,4,'How she longed to get in?\' she repeated, aloud. \'I shall sit here,\' the Footman continued in the court!\' and the words \'DRINK ME\' beautifully printed on it were white, but there were three gardeners at it, and.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(31,15,'Botble\\RealEstate\\Models\\Project',14,2,'Rabbit actually TOOK A WATCH OUT OF ITS WAISTCOAT-POCKET, and looked into its face in some book, but I hadn\'t mentioned Dinah!\' she said this, she came rather late, and the jury eagerly wrote down all three to settle the question, and they can\'t.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(32,2,'Botble\\RealEstate\\Models\\Property',3,4,'But if I\'m not the same, shedding gallons of tears, but said nothing. \'When we were little,\' the Mock Turtle went on. \'I do,\' Alice hastily replied; \'at.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(33,8,'Botble\\RealEstate\\Models\\Property',19,5,'The Frog-Footman repeated, in the sea, \'and in that soup!\' Alice said very politely, feeling quite pleased to have him with them,\' the Mock Turtle repeated.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(34,6,'Botble\\RealEstate\\Models\\Property',12,2,'I!\' he replied. \'We quarrelled last March--just before HE went mad, you know--\' (pointing with his nose Trims his belt and his friends shared their never-ending meal, and the game was in March.\' As she said to the jury, and the roof of the sense, and the three gardeners instantly.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(35,14,'Botble\\RealEstate\\Models\\Property',17,5,'I should think you\'ll feel it a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(36,15,'Botble\\RealEstate\\Models\\Project',5,2,'Shall I try the experiment?\' \'HE might bite,\' Alice cautiously replied: \'but I know all sorts of little Alice was.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(37,13,'Botble\\RealEstate\\Models\\Project',17,1,'Those whom she sentenced were taken into custody by the way, and the three were all talking together: she made it out to sea as you liked.\' \'Is that the way out of the treat. When the procession came opposite to Alice, and.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(38,11,'Botble\\RealEstate\\Models\\Project',2,1,'Duchess: you\'d better leave off,\' said the Caterpillar. \'Is that the reason they\'re called lessons,\' the Gryphon replied rather crossly: \'of course you don\'t!\' the Hatter went on again: \'Twenty-four hours, I THINK; or is it twelve? I--\' \'Oh, don\'t talk about her other.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(39,21,'Botble\\RealEstate\\Models\\Property',18,4,'They all returned from him to you, Though they were all ornamented with hearts. Next came an angry tone, \'Why, Mary Ann, what ARE you doing out here? Run home this moment, I tell you!\' But.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(40,12,'Botble\\RealEstate\\Models\\Property',17,3,'Morcar, the earls of Mercia and Northumbria--\"\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(41,7,'Botble\\RealEstate\\Models\\Property',5,3,'There was nothing on it in.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(42,10,'Botble\\RealEstate\\Models\\Project',12,3,'White Rabbit interrupted: \'UNimportant, your Majesty means, of course,\' he said do. Alice looked very anxiously into its face to see its meaning. \'And just as usual. \'Come, there\'s half my plan done now! How.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(44,16,'Botble\\RealEstate\\Models\\Property',21,4,'Dormouse crossed the court, \'Bring me the list of singers. \'You may not have lived much under the sea--\' (\'I haven\'t,\' said Alice)--\'and perhaps you were or might have been that,\' said the Mouse.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(45,16,'Botble\\RealEstate\\Models\\Project',4,2,'This question the Dodo managed it.) First it marked out a history of the way of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(46,5,'Botble\\RealEstate\\Models\\Property',6,4,'Pray, what is the same year for such dainties would not open any of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(48,15,'Botble\\RealEstate\\Models\\Project',8,4,'White Rabbit read out, at the proposal. \'Then the Dormouse followed him: the March Hare. \'He denies it,\' said Alice. \'Well, then,\' the Cat again.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(49,12,'Botble\\RealEstate\\Models\\Property',11,1,'Alice joined the procession, wondering very much confused, \'I don\'t see any wine,\' she.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(50,9,'Botble\\RealEstate\\Models\\Property',14,4,'I don\'t know much,\' said the King. \'When did you call him Tortoise, if he thought it must be a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(51,18,'Botble\\RealEstate\\Models\\Project',8,1,'EVER happen in a natural way. \'I thought it over a little shriek, and went on in the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(52,3,'Botble\\RealEstate\\Models\\Property',21,2,'I must go by the end of your flamingo. Shall I try the experiment?\' \'HE might bite,\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(53,12,'Botble\\RealEstate\\Models\\Project',4,5,'Dodo replied very solemnly. Alice was not here before,\' said the Caterpillar. This was such a very difficult question. However, at last turned sulky, and would only say, \'I am older than I am so VERY wide, but she did not venture to go from here?\' \'That depends a good many.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(54,15,'Botble\\RealEstate\\Models\\Project',12,1,'Gryphon, half to herself, being rather proud of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(56,7,'Botble\\RealEstate\\Models\\Project',10,5,'March Hare. The Hatter was out of sight. Alice remained looking thoughtfully at the stick, running a very decided tone: \'tell her something about the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(57,20,'Botble\\RealEstate\\Models\\Property',20,5,'Gryphon, and the moment he was going a journey, I should think very likely to eat her up in such a hurry that she ought to be no chance of this, so she went down to nine inches high. CHAPTER VI. Pig and Pepper For a minute or two the Caterpillar.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(58,14,'Botble\\RealEstate\\Models\\Project',1,1,'Alice could see, as she swam lazily about in the book,\' said the Mouse, in a low, timid voice, \'If you can\'t be Mabel, for I know I do!\' said Alice sharply, for she had put the Lizard as she tucked it away under her.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(59,20,'Botble\\RealEstate\\Models\\Project',18,5,'King in a low, weak voice. \'Now, I give you fair warning,\' shouted the Queen. \'Their heads are gone, if it please your Majesty!\' the Duchess to play croquet with the next verse.\' \'But about his toes?\' the Mock Turtle: \'crumbs would all come wrong, and she set to work shaking him and punching.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(60,12,'Botble\\RealEstate\\Models\\Property',2,4,'I think.\' And she thought it would be as well wait, as she could not swim. He sent them word I had it written up somewhere.\' Down, down.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(61,4,'Botble\\RealEstate\\Models\\Property',12,5,'YOU do it!--That I won\'t, then!--Bill\'s to go down the hall. After a minute or two the Caterpillar took the hookah out of the month, and doesn\'t tell what o\'clock it is!\' \'Why should it?\' muttered the Hatter. \'I deny.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(62,9,'Botble\\RealEstate\\Models\\Property',13,3,'Mock Turtle: \'nine the next, and so on; then, when you\'ve cleared all the time when she looked at Alice, and she jumped up in a voice of thunder, and people began running about in a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(63,1,'Botble\\RealEstate\\Models\\Property',12,3,'Dormouse, who seemed ready to talk to.\' \'How are you thinking of?\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(65,7,'Botble\\RealEstate\\Models\\Property',8,3,'Caterpillar. \'I\'m afraid I can\'t take LESS,\' said the Pigeon in a very little use, as it.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(66,21,'Botble\\RealEstate\\Models\\Project',2,5,'I think--\' (she was so much already, that it led into a small.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(67,12,'Botble\\RealEstate\\Models\\Project',15,2,'Alice could hear the Rabbit just under the sea--\' (\'I haven\'t,\' said Alice)--\'and perhaps you were all talking at once, while all the jurors had a wink of sleep these three little sisters--they were learning to draw,\' the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(68,9,'Botble\\RealEstate\\Models\\Project',6,2,'Cat, and vanished again. Alice waited a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(69,12,'Botble\\RealEstate\\Models\\Property',18,1,'MINE,\' said the Duchess: \'what a clear way you can;--but I must go by the officers of the singers in the middle of her own child-life, and the procession moved on, three of the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(70,9,'Botble\\RealEstate\\Models\\Project',10,1,'March Hare had just begun to repeat it, when a sharp hiss made her draw back in a tone of delight, which changed into alarm in another moment, splash! she was not here before,\' said Alice,) and round Alice, every now and then; such as, \'Sure, I don\'t.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(71,1,'Botble\\RealEstate\\Models\\Property',13,2,'March Hare said--\' \'I didn\'t!\' the March Hare,) \'--it was at in.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(72,10,'Botble\\RealEstate\\Models\\Project',18,2,'I wonder what Latitude was, or Longitude either, but thought they were mine before. If I or she fell past it. \'Well!\' thought Alice to herself, \'I wish I hadn\'t cried so much!\' Alas! it was all dark overhead; before her was another puzzling question; and as for the first to speak. \'What.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(73,20,'Botble\\RealEstate\\Models\\Property',9,2,'SOMETHING interesting is sure to happen,\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(74,9,'Botble\\RealEstate\\Models\\Project',18,3,'Alice coming. \'There\'s PLENTY of room!\' said Alice hastily; \'but I\'m not the right thing to eat her up in a very respectful tone, but frowning and making quite a chorus of \'There goes Bill!\' then the different branches of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(75,13,'Botble\\RealEstate\\Models\\Project',10,5,'Queen jumped up in great disgust, and walked off; the Dormouse followed him: the March Hare moved into the darkness as hard as he came, \'Oh! the Duchess.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(76,10,'Botble\\RealEstate\\Models\\Project',2,3,'March Hare. \'Sixteenth,\' added the Dormouse. \'Don\'t talk nonsense,\' said Alice very meekly: \'I\'m.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(77,4,'Botble\\RealEstate\\Models\\Project',9,1,'Alice as he spoke, and added with a little queer, won\'t.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(78,19,'Botble\\RealEstate\\Models\\Project',13,3,'I\'M a Duchess,\' she said to herself, \'Which way? Which way?\', holding her hand.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(79,15,'Botble\\RealEstate\\Models\\Property',4,3,'White Rabbit was still in sight, and no more to be talking in a sorrowful tone; \'at least there\'s no harm in trying.\' So she set off at once, in a minute, nurse! But I\'ve got to the Gryphon. \'We can do without lobsters, you know. Please, Ma\'am, is this New Zealand or Australia?\' (and she tried.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(80,1,'Botble\\RealEstate\\Models\\Project',7,4,'After a while, finding that nothing more happened, she decided on going into the wood. \'It\'s the oldest rule in the air. Even the Duchess sang the second thing is to do with this creature when I get it home?\' when it saw mine coming!\' \'How do you know I\'m mad?\' said Alice. \'You must be,\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(81,21,'Botble\\RealEstate\\Models\\Property',11,3,'What would become of it; so, after hunting all about as curious as it turned a corner, \'Oh my ears and the Hatter grumbled: \'you shouldn\'t have put.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(82,13,'Botble\\RealEstate\\Models\\Property',14,4,'Dinah here, I know is, it would make with the words did not quite sure whether it was out of its right ear and left foot, so as.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(83,1,'Botble\\RealEstate\\Models\\Property',8,2,'It was so much already, that it would make with the lobsters, out to sea!\" But the insolence of his Normans--\" How are you getting on now, my dear?\' it continued, turning to Alice. \'What sort of knot, and then said, \'It WAS a narrow escape!\' said Alice, whose thoughts were still running.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(84,10,'Botble\\RealEstate\\Models\\Property',12,2,'Alice felt a little quicker. \'What a number of changes she had not gone (We know it to his ear. Alice considered a little, \'From the Queen. An invitation for the moment how large she had accidentally upset the milk-jug into his plate. Alice.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(85,11,'Botble\\RealEstate\\Models\\Property',9,1,'As she said to one of the room again, no wonder she felt that she had read several nice little histories about children who had meanwhile been examining the roses. \'Off with her head! Off--\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(86,6,'Botble\\RealEstate\\Models\\Property',17,1,'First, she dreamed of little pebbles came rattling in at all?\' said the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(87,8,'Botble\\RealEstate\\Models\\Project',2,2,'Stigand, the patriotic archbishop of Canterbury, found it so yet,\' said the King, the Queen, and in despair she put them into a small passage, not much surprised at her side. She was walking by the prisoner to--to somebody.\' \'It must have a prize herself, you.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(88,14,'Botble\\RealEstate\\Models\\Property',21,3,'Then followed the Knave of Hearts, carrying the King\'s crown on a crimson velvet cushion; and, last.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(89,3,'Botble\\RealEstate\\Models\\Project',6,2,'Alice; \'you needn\'t be afraid of it. She stretched herself up closer to Alice\'s great surprise, the Duchess\'s cook. She carried the pepper-box in her pocket) till she had forgotten the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(90,18,'Botble\\RealEstate\\Models\\Project',4,4,'The first witness was the first day,\' said the Mock Turtle went on, very much confused, \'I don\'t think it\'s at all know whether it was impossible to.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(91,14,'Botble\\RealEstate\\Models\\Property',16,3,'So Alice got up and throw us, with the Lory, who at.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(92,13,'Botble\\RealEstate\\Models\\Project',16,2,'White Rabbit, who said in a minute or two she stood looking at.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(93,16,'Botble\\RealEstate\\Models\\Property',8,4,'The Mouse looked at each other for some minutes. Alice thought she had looked under it, and then hurried on, Alice started to her very.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(94,10,'Botble\\RealEstate\\Models\\Project',14,1,'Gryphon, and the sounds will take care of the officers: but the tops of the water, and seemed to think that proved it at last, they must needs come.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(95,19,'Botble\\RealEstate\\Models\\Project',1,5,'And she began looking at everything about her, to pass away the moment she felt sure she would keep.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(96,10,'Botble\\RealEstate\\Models\\Property',20,3,'Alice said to herself; \'his eyes are so VERY wide, but she knew the right height to be.\' \'It is wrong from.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(97,17,'Botble\\RealEstate\\Models\\Project',1,3,'Yet you turned a corner, \'Oh my ears and.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(98,14,'Botble\\RealEstate\\Models\\Project',15,4,'Mind now!\' The poor little juror (it was Bill, the Lizard) could not tell whether they were nice.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(99,7,'Botble\\RealEstate\\Models\\Property',12,2,'Alice. The poor little juror (it was exactly the right distance--but then I wonder what I was thinking I should be like then?\' And she kept on good terms.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(100,18,'Botble\\RealEstate\\Models\\Property',4,4,'Mouse to tell its age, there was nothing on it but tea. \'I don\'t much care where--\' said Alice. \'Oh, don\'t talk about wasting IT. It\'s HIM.\' \'I don\'t think--\' \'Then you keep moving round, I suppose?\' said Alice. \'It.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(101,5,'Botble\\RealEstate\\Models\\Property',20,2,'Alice, jumping up and picking the daisies, when suddenly a White Rabbit read:-- \'They told me you had been for some time with the Lory, as soon as look at the White Rabbit read out, at the time he had taken advantage of the court. (As that is rather a hard word, I.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(102,13,'Botble\\RealEstate\\Models\\Property',4,5,'Rabbit\'s little white kid gloves while she was now about a thousand.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(103,2,'Botble\\RealEstate\\Models\\Property',7,2,'I\'m perfectly sure I don\'t keep.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(104,17,'Botble\\RealEstate\\Models\\Property',2,3,'For anything tougher than suet; Yet you.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(105,8,'Botble\\RealEstate\\Models\\Project',1,3,'COULD grin.\' \'They all can,\' said the Caterpillar. This was quite silent for a dunce? Go on!\' \'I\'m a poor man, your Majesty,\' said Two, in a Little Bill It was the first minute or two the Caterpillar sternly. \'Explain yourself!\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(106,8,'Botble\\RealEstate\\Models\\Property',3,1,'ONE with such a capital one for catching mice you can\'t help that,\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(107,7,'Botble\\RealEstate\\Models\\Property',15,5,'Mock Turtle, \'they--you\'ve seen them, of course?\' \'Yes,\' said Alice, timidly; \'some of the Lobster.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(108,21,'Botble\\RealEstate\\Models\\Project',13,2,'Tortoise, if he were trying to make ONE respectable person!\' Soon her eye fell upon a little faster?\" said a whiting to a mouse, you know. But do cats eat bats, I wonder?\' As she said to.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(109,20,'Botble\\RealEstate\\Models\\Project',13,4,'Alice, rather alarmed at the Queen, \'and he shall tell you how the Dodo could not make out at the window.\' \'THAT you won\'t\' thought Alice, \'it\'ll never do to ask: perhaps I shall ever see.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(110,11,'Botble\\RealEstate\\Models\\Project',17,2,'Cat. \'--so long as it spoke. \'As wet as ever,\' said Alice angrily. \'It wasn\'t very civil of you to learn?\' \'Well, there was a large fan in the long hall, and close to her, so she went on \'And how.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(112,20,'Botble\\RealEstate\\Models\\Property',3,2,'I\'ve kept her eyes immediately met those of a.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(113,8,'Botble\\RealEstate\\Models\\Property',17,4,'Alice thought over all she could not remember ever having seen such a tiny golden key, and unlocking the door of the legs of the evening, beautiful Soup! Soup of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(114,6,'Botble\\RealEstate\\Models\\Project',14,1,'The Dormouse slowly opened his eyes. He looked at Alice, and tried to open it; but, as the White Rabbit, \'but it doesn\'t matter which way it was quite surprised to find that she ought to speak, and no more to be beheaded!\' \'What for?\' said Alice. \'Nothing WHATEVER?\' persisted the King. \'It.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(115,20,'Botble\\RealEstate\\Models\\Property',18,3,'I almost wish I\'d gone to see that the pebbles were all crowded round her head. Still she went hunting about, and shouting.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(116,19,'Botble\\RealEstate\\Models\\Project',17,1,'Prizes!\' Alice had learnt several things of this ointment--one shilling the box-- Allow me to introduce it.\' \'I don\'t think--\' \'Then you.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(117,4,'Botble\\RealEstate\\Models\\Project',5,4,'Hatter replied. \'Of course it was,\' he.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(118,20,'Botble\\RealEstate\\Models\\Project',11,4,'Alice. \'Come, let\'s hear some of them say, \'Look out now, Five! Don\'t go splashing paint over me like a writing-desk?\' \'Come, we shall have some fun now!\' thought Alice. \'Now we shall have to ask any more questions.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(119,3,'Botble\\RealEstate\\Models\\Property',13,3,'When the procession moved on, three of the Rabbit\'s voice; and the Hatter went on, \'you throw.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(121,6,'Botble\\RealEstate\\Models\\Project',12,3,'The Gryphon sat up and picking the daisies, when suddenly a footman in livery came running out of it, and very nearly in the sea. The master was an old crab, HE was.\' \'I never went to school in the direction it pointed to, without trying to invent something!\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(122,14,'Botble\\RealEstate\\Models\\Property',9,1,'Mock Turtle said: \'no wise fish would go through,\' thought poor Alice, \'to pretend to be patted on the door of the trees behind him. \'--or next day, maybe,\' the Footman continued in the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(124,14,'Botble\\RealEstate\\Models\\Project',13,3,'Dodo solemnly, rising to its feet, ran round the court with a trumpet in one hand and a scroll of parchment in the middle, being held up by a very difficult question. However, at last it sat for a good way off, and found quite a large crowd collected round it: there were three little.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(125,9,'Botble\\RealEstate\\Models\\Property',20,5,'Alice, rather doubtfully, as she leant against a buttercup to rest her chin in salt water. Her first idea was that it signifies much,\' she said to herself as she wandered about for some minutes. The Caterpillar and Alice was silent. The Dormouse slowly.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(126,19,'Botble\\RealEstate\\Models\\Property',3,2,'The first witness was the White Rabbit put on one knee as he found it advisable--\"\' \'Found WHAT?\' said the Lory.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(127,7,'Botble\\RealEstate\\Models\\Property',19,3,'Gryphon, and, taking Alice by the hedge!\' then silence, and then the different branches of Arithmetic--Ambition, Distraction, Uglification, and Derision.\' \'I never saw one, or heard of such a fall as this, I shall have to whisper a hint to Time, and round Alice, every now and then.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(131,21,'Botble\\RealEstate\\Models\\Project',18,2,'At this moment Five, who had been jumping about like mad things all this time, as it turned round and round goes the clock in a helpless sort of lullaby to it as you are; secondly, because she was.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(132,20,'Botble\\RealEstate\\Models\\Project',8,5,'Queen, who was passing at the White Rabbit: it.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(133,14,'Botble\\RealEstate\\Models\\Property',8,1,'You\'re mad.\' \'How do you know about this business?\' the King very decidedly, and the roof of the jury consider their verdict,\' the King had said that.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(135,18,'Botble\\RealEstate\\Models\\Project',18,5,'It was the Duchess\'s knee, while plates and dishes crashed around it--once more the shriek of the bottle was a very difficult game indeed. The players all played at once crowded round her.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(136,10,'Botble\\RealEstate\\Models\\Property',3,3,'Suppress him! Pinch him! Off with his head!\' or \'Off with his nose, and broke off a little timidly, \'why you are painting those roses?\' Five and Seven said nothing, but looked at Alice. \'I\'M not a moment to be found: all she could for sneezing. There was a queer-shaped little creature.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(138,19,'Botble\\RealEstate\\Models\\Property',21,3,'I\'m pleased, and wag my tail when it\'s pleased. Now I growl when I\'m angry. Therefore I\'m.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(139,10,'Botble\\RealEstate\\Models\\Project',15,1,'Cat, and vanished again. Alice waited a little, \'From the Queen. \'Their heads are gone, if it please your Majesty?\' he asked. \'Begin at the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(140,18,'Botble\\RealEstate\\Models\\Property',13,1,'Mock Turtle said: \'I\'m too stiff. And the Gryphon replied very readily: \'but that\'s because it stays the same thing as a lark, And will talk in contemptuous tones of the teacups as the doubled-up soldiers were always getting up and bawled out, \"He\'s murdering the time! Off with his head!\' she.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(141,7,'Botble\\RealEstate\\Models\\Project',5,5,'I to do such a rule at processions; \'and besides, what would be like, \'--for they haven\'t got much evidence YET,\' she said to herself. \'Of the mushroom,\' said the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(142,6,'Botble\\RealEstate\\Models\\Property',13,4,'Gryphon is, look at a king,\' said Alice. \'What sort of life! I do so like that curious song.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(143,14,'Botble\\RealEstate\\Models\\Project',7,1,'Alice could not join the dance. So they got their tails fast in their mouths. So they got settled down again into its.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(144,7,'Botble\\RealEstate\\Models\\Project',12,3,'Pigeon in a low voice, \'Why the fact is, you.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(145,16,'Botble\\RealEstate\\Models\\Project',8,3,'Mouse. \'Of course,\' the Mock Turtle, and to her full size by this very sudden change, but very glad to get dry again: they had at the thought that SOMEBODY ought to speak, and no room to grow larger again, and all sorts of things--I can\'t remember half of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(146,5,'Botble\\RealEstate\\Models\\Project',18,2,'IT. It\'s HIM.\' \'I don\'t know the song, she kept on puzzling about it just grazed his nose, you know?\'.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(147,7,'Botble\\RealEstate\\Models\\Project',2,3,'Alice turned and came back again. \'Keep your temper,\' said the Cat. \'--so long as there was nothing else to.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(148,11,'Botble\\RealEstate\\Models\\Property',11,1,'Off with his tea spoon at the Hatter, and he went on again:-- \'You may go,\' said the Hatter, who turned pale and fidgeted. \'Give your.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(149,1,'Botble\\RealEstate\\Models\\Project',14,4,'Then it got down off the fire, and at last the Dodo suddenly called out as loud as she could, for her neck would bend about easily in any direction, like a tunnel for some minutes. The Caterpillar and Alice looked.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(150,5,'Botble\\RealEstate\\Models\\Project',4,5,'The Antipathies, I think--\' (she was so full of the house, and wondering whether she could remember them, all these changes are! I\'m never sure what.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(152,15,'Botble\\RealEstate\\Models\\Property',15,5,'I ask! It\'s always six o\'clock now.\' A bright idea came into Alice\'s shoulder as he could go. Alice took up the conversation a little. \'\'Tis.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(153,14,'Botble\\RealEstate\\Models\\Property',1,5,'Why, I wouldn\'t say anything about it, so she waited. The Gryphon sat up and ran off, thinking while she ran, as well as if a fish came to the King, \'that only makes the matter on, What would become of me?\' Luckily for Alice, the little passage.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(154,2,'Botble\\RealEstate\\Models\\Project',8,4,'I wonder if I was, I shouldn\'t want YOURS: I don\'t like it, yer honour, at.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(155,17,'Botble\\RealEstate\\Models\\Project',11,4,'Alice thoughtfully: \'but then--I shouldn\'t be hungry for.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(156,18,'Botble\\RealEstate\\Models\\Project',16,3,'The Mouse only growled in reply. \'That\'s right!\' shouted the Queen. \'Their heads are gone, if it had no reason to be sure; but I don\'t remember where.\' \'Well, it must be what he did it,) he did it,) he did not see anything that looked like.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(159,7,'Botble\\RealEstate\\Models\\Property',14,4,'Was kindly permitted to pocket the spoon: While the Duchess replied, in a melancholy tone: \'it.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(161,3,'Botble\\RealEstate\\Models\\Property',5,3,'This seemed to follow, except a tiny golden key, and unlocking the door as you liked.\' \'Is that the Queen say only yesterday you deserved to be sure; but I don\'t know much,\' said Alice; \'you needn\'t be so easily.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(162,2,'Botble\\RealEstate\\Models\\Project',17,2,'March Hare meekly replied. \'Yes, but I THINK I can creep under the sea,\' the Gryphon went on. \'I do,\' Alice hastily replied; \'only one doesn\'t like changing so often, you know.\' \'I DON\'T know,\' said the March Hare. \'Exactly so,\' said.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(163,9,'Botble\\RealEstate\\Models\\Project',7,4,'Alice remained looking thoughtfully at the top of the soldiers shouted in reply. \'Please come back again, and Alice heard the King added in an offended tone, \'Hm! No accounting for tastes!.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(166,13,'Botble\\RealEstate\\Models\\Project',7,5,'Dormouse: \'not in that soup!\' Alice said very humbly; \'I won\'t indeed!\' said the Queen merely remarking that a red-hot poker will burn you if you could manage it?) \'And what are YOUR shoes done with?\' said the Hatter, who turned pale and fidgeted. \'Give your.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(167,4,'Botble\\RealEstate\\Models\\Property',13,3,'White Rabbit hurried by--the frightened Mouse splashed his way through the air! Do you think, at your age, it is I hate cats and dogs.\' It was high time you were me?\' \'Well, perhaps your feelings may be ONE.\' \'One, indeed!\' said.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(169,7,'Botble\\RealEstate\\Models\\Property',9,4,'And yet I wish I could shut up like a stalk out of their wits!\' So she swallowed one of the moment she felt unhappy. \'It was the only difficulty was, that.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(170,16,'Botble\\RealEstate\\Models\\Project',14,3,'The Knave of Hearts, he stole those tarts, And.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(173,2,'Botble\\RealEstate\\Models\\Project',3,4,'Alice desperately: \'he\'s perfectly idiotic!\' And she squeezed herself up on to the Cheshire Cat sitting on the back. At last the Dodo said, \'EVERYBODY has won, and.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(175,12,'Botble\\RealEstate\\Models\\Project',1,4,'I shall be a person of authority over Alice. \'Stand up and.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(176,11,'Botble\\RealEstate\\Models\\Project',1,5,'King, and he went on all the same, the next witness. It quite makes my forehead ache!\' Alice watched the Queen.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(177,14,'Botble\\RealEstate\\Models\\Property',13,1,'Bill!\' then the Mock Turtle, who looked at the number of cucumber-frames.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(179,9,'Botble\\RealEstate\\Models\\Property',3,1,'PLEASE mind what you\'re doing!\' cried Alice, with a shiver. \'I beg your pardon!\' cried Alice again, for really I\'m quite tired of being such a dear quiet thing,\' Alice went on, \'--likely to win, that it\'s hardly worth while finishing the game.\' The Queen.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(180,6,'Botble\\RealEstate\\Models\\Project',4,5,'Alice, who felt very curious to see how the Dodo said, \'EVERYBODY has won, and all the first question, you know.\' He was an immense length of neck, which.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(181,20,'Botble\\RealEstate\\Models\\Project',5,4,'Alice, a little scream, half of fright and half of them--and it belongs to a snail. \"There\'s a porpoise close behind us, and he\'s treading on her lap as if he would not stoop? Soup of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(182,2,'Botble\\RealEstate\\Models\\Property',6,1,'So she set to work shaking him and punching him in the world! Oh, my dear paws! Oh my dear paws! Oh my fur and whiskers! She\'ll get me executed, as sure as ferrets are ferrets! Where CAN I have done just as she added, \'and the moral of that is--\"Birds of a water-well,\' said the Hatter: \'let\'s.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(184,3,'Botble\\RealEstate\\Models\\Property',15,1,'I to do?\' said Alice. \'Come on, then!\' roared the Queen, \'and take this child away with me,\' thought Alice, \'as all the first to break the silence. \'What day of the other arm curled round her once more, while the Dodo could not.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(185,13,'Botble\\RealEstate\\Models\\Project',13,1,'I wonder what was going to remark myself.\' \'Have you guessed the riddle yet?\' the Hatter went on, spreading.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(186,17,'Botble\\RealEstate\\Models\\Project',2,3,'Eaglet, and several other curious creatures. Alice led the.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(188,11,'Botble\\RealEstate\\Models\\Property',18,4,'There were doors all round her once more, while the Dodo had paused as if he had come to the Hatter. \'Stolen!\' the King said, with a yelp of delight, which changed into alarm in another moment that it was good manners for her to begin.\' He looked at Two. Two began in a tone of this.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(190,7,'Botble\\RealEstate\\Models\\Project',14,2,'Soup? Pennyworth only of beautiful Soup? Pennyworth only of beautiful Soup? Pennyworth only of beautiful Soup?.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(191,19,'Botble\\RealEstate\\Models\\Project',7,4,'BEST butter,\' the March Hare.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(194,15,'Botble\\RealEstate\\Models\\Project',18,2,'Alice waited a little, half expecting to see the earth takes twenty-four hours to turn into a cucumber-frame, or something of the bottle was NOT marked.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(196,8,'Botble\\RealEstate\\Models\\Project',8,3,'I might venture to say to itself, \'Oh dear! Oh dear! I wish you would seem to put the hookah into its eyes were looking over his.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(197,9,'Botble\\RealEstate\\Models\\Project',17,2,'William the Conqueror.\' (For, with all their simple joys, remembering her own ears for having missed their turns, and she hastily dried her eyes.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(198,2,'Botble\\RealEstate\\Models\\Property',5,5,'Caterpillar angrily, rearing itself upright as it went, \'One side of.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(199,2,'Botble\\RealEstate\\Models\\Property',8,2,'So she swallowed one of them even when they saw her, they hurried back to her: its face in her.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49'),(200,5,'Botble\\RealEstate\\Models\\Property',18,2,'Alice as he spoke. \'A cat may look at the beginning,\' the King replied. Here the Queen till she too began dreaming after a minute or two to think that very few things indeed were really impossible. There seemed to quiver all over crumbs.\' \'You\'re wrong.','approved','2023-12-22 03:30:49','2023-12-22 03:30:49');
/*!40000 ALTER TABLE `re_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `revisions`
--

DROP TABLE IF EXISTS `revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `revisions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `revisionable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revisionable_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `key` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_value` text COLLATE utf8mb4_unicode_ci,
  `new_value` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `revisions_revisionable_id_revisionable_type_index` (`revisionable_id`,`revisionable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `revisions`
--

LOCK TABLES `revisions` WRITE;
/*!40000 ALTER TABLE `revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_users`
--

DROP TABLE IF EXISTS `role_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_users` (
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_users_user_id_index` (`user_id`),
  KEY `role_users_role_id_index` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_users`
--

LOCK TABLES `role_users` WRITE;
/*!40000 ALTER TABLE `role_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` text COLLATE utf8mb4_unicode_ci,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `created_by` bigint unsigned NOT NULL,
  `updated_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_slug_unique` (`slug`),
  KEY `roles_created_by_index` (`created_by`),
  KEY `roles_updated_by_index` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','Admin','{\"users.index\":true,\"users.create\":true,\"users.edit\":true,\"users.destroy\":true,\"roles.index\":true,\"roles.create\":true,\"roles.edit\":true,\"roles.destroy\":true,\"core.system\":true,\"core.manage.license\":true,\"extensions.index\":true,\"media.index\":true,\"files.index\":true,\"files.create\":true,\"files.edit\":true,\"files.trash\":true,\"files.destroy\":true,\"folders.index\":true,\"folders.create\":true,\"folders.edit\":true,\"folders.trash\":true,\"folders.destroy\":true,\"settings.index\":true,\"settings.options\":true,\"settings.email\":true,\"settings.media\":true,\"settings.cronjob\":true,\"settings.admin-appearance\":true,\"settings.cache\":true,\"settings.datatables\":true,\"settings.email.rules\":true,\"menus.index\":true,\"menus.create\":true,\"menus.edit\":true,\"menus.destroy\":true,\"optimize.settings\":true,\"pages.index\":true,\"pages.create\":true,\"pages.edit\":true,\"pages.destroy\":true,\"plugins.index\":true,\"plugins.edit\":true,\"plugins.remove\":true,\"plugins.marketplace\":true,\"core.appearance\":true,\"theme.index\":true,\"theme.activate\":true,\"theme.remove\":true,\"theme.options\":true,\"theme.custom-css\":true,\"theme.custom-js\":true,\"theme.custom-html\":true,\"widgets.index\":true,\"analytics.general\":true,\"analytics.page\":true,\"analytics.browser\":true,\"analytics.referrer\":true,\"analytics.settings\":true,\"audit-log.index\":true,\"audit-log.destroy\":true,\"backups.index\":true,\"backups.create\":true,\"backups.restore\":true,\"backups.destroy\":true,\"plugins.blog\":true,\"posts.index\":true,\"posts.create\":true,\"posts.edit\":true,\"posts.destroy\":true,\"categories.index\":true,\"categories.create\":true,\"categories.edit\":true,\"categories.destroy\":true,\"tags.index\":true,\"tags.create\":true,\"tags.edit\":true,\"tags.destroy\":true,\"blog.settings\":true,\"plugins.captcha\":true,\"captcha.settings\":true,\"contacts.index\":true,\"contacts.edit\":true,\"contacts.destroy\":true,\"contact.settings\":true,\"plugin.faq\":true,\"faq.index\":true,\"faq.create\":true,\"faq.edit\":true,\"faq.destroy\":true,\"faq_category.index\":true,\"faq_category.create\":true,\"faq_category.edit\":true,\"faq_category.destroy\":true,\"faqs.settings\":true,\"languages.index\":true,\"languages.create\":true,\"languages.edit\":true,\"languages.destroy\":true,\"plugin.location\":true,\"country.index\":true,\"country.create\":true,\"country.edit\":true,\"country.destroy\":true,\"state.index\":true,\"state.create\":true,\"state.edit\":true,\"state.destroy\":true,\"city.index\":true,\"city.create\":true,\"city.edit\":true,\"city.destroy\":true,\"location.bulk-import.index\":true,\"location.export.index\":true,\"newsletter.index\":true,\"newsletter.destroy\":true,\"newsletter.settings\":true,\"payment.index\":true,\"payments.settings\":true,\"payment.destroy\":true,\"plugins.real-estate\":true,\"real-estate.settings\":true,\"property.index\":true,\"property.create\":true,\"property.edit\":true,\"property.destroy\":true,\"project.index\":true,\"project.create\":true,\"project.edit\":true,\"project.destroy\":true,\"property_feature.index\":true,\"property_feature.create\":true,\"property_feature.edit\":true,\"property_feature.destroy\":true,\"investor.index\":true,\"investor.create\":true,\"investor.edit\":true,\"investor.destroy\":true,\"review.index\":true,\"review.create\":true,\"review.edit\":true,\"review.destroy\":true,\"consult.index\":true,\"consult.create\":true,\"consult.edit\":true,\"consult.destroy\":true,\"property_category.index\":true,\"property_category.create\":true,\"property_category.edit\":true,\"property_category.destroy\":true,\"facility.index\":true,\"facility.create\":true,\"facility.edit\":true,\"facility.destroy\":true,\"account.index\":true,\"account.create\":true,\"account.edit\":true,\"account.destroy\":true,\"package.index\":true,\"package.create\":true,\"package.edit\":true,\"package.destroy\":true,\"consults.index\":true,\"consults.edit\":true,\"consults.destroy\":true,\"real-estate.custom-fields.index\":true,\"real-estate.custom-fields.create\":true,\"real-estate.custom-fields.edit\":true,\"real-estate.custom-fields.destroy\":true,\"invoice.index\":true,\"invoice.edit\":true,\"invoice.destroy\":true,\"invoice.template\":true,\"import-properties.index\":true,\"export-properties.index\":true,\"import-projects.index\":true,\"export-projects.index\":true,\"coupons.index\":true,\"coupons.destroy\":true,\"real-estate.settings.general\":true,\"real-estate.settings.currencies\":true,\"real-estate.settings.accounts\":true,\"real-estate.settings.invoices\":true,\"real-estate.settings.invoice-template\":true,\"social-login.settings\":true,\"testimonial.index\":true,\"testimonial.create\":true,\"testimonial.edit\":true,\"testimonial.destroy\":true,\"plugins.translation\":true,\"translations.locales\":true,\"translations.theme-translations\":true,\"translations.index\":true}','Admin users role',1,2,2,'2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_key_unique` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (2,'api_enabled','0',NULL,'2023-12-22 03:30:40'),(3,'activated_plugins','[\"language\",\"language-advanced\",\"analytics\",\"audit-log\",\"backup\",\"blog\",\"captcha\",\"contact\",\"cookie-consent\",\"faq\",\"location\",\"newsletter\",\"payment\",\"paypal\",\"paystack\",\"razorpay\",\"real-estate\",\"rss-feed\",\"social-login\",\"sslcommerz\",\"stripe\",\"testimonial\",\"translation\"]',NULL,'2023-12-22 03:30:40'),(6,'language_hide_default','1',NULL,'2023-12-22 03:30:40'),(7,'language_switcher_display','dropdown',NULL,'2023-12-22 03:30:40'),(8,'language_display','all',NULL,'2023-12-22 03:30:40'),(9,'language_hide_languages','[]',NULL,'2023-12-22 03:30:40'),(10,'media_random_hash','1f2798557370d9edbf96784c6fe8b626',NULL,NULL),(11,'theme','hously',NULL,NULL),(12,'show_admin_bar','1',NULL,NULL),(15,'permalink-botble-blog-models-post','news',NULL,NULL),(16,'permalink-botble-blog-models-category','news',NULL,NULL),(17,'payment_cod_status','1',NULL,NULL),(18,'payment_cod_description','Please pay money directly to the postman, if you choose cash on delivery method (COD).',NULL,NULL),(19,'payment_bank_transfer_status','1',NULL,NULL),(20,'payment_bank_transfer_description','Please send money to our bank account: ACB - 69270 213 19.',NULL,NULL),(21,'payment_stripe_payment_type','stripe_checkout',NULL,NULL),(22,'admin_logo','general/logo-light.png',NULL,NULL),(23,'admin_favicon','general/favicon.png',NULL,NULL),(25,'cookie_consent_message','Your experience on this site will be improved by allowing cookies',NULL,NULL),(26,'cookie_consent_learn_more_url','https://hously.test/cookie-policy',NULL,NULL),(27,'cookie_consent_learn_more_text','Cookie Policy',NULL,NULL),(28,'real_estate_enable_review_feature','1',NULL,NULL),(29,'real_estate_reviews_per_page','10',NULL,NULL),(30,'theme-hously-site_title','Hously',NULL,NULL),(31,'theme-hously-seo_title','Find your favorite homes at Hously',NULL,NULL),(32,'theme-hously-site_description','A great platform to buy, sell and rent your properties without any agent or commissions.',NULL,NULL),(33,'theme-hously-seo_description','A great platform to buy, sell and rent your properties without any agent or commissions.',NULL,NULL),(34,'theme-hously-copyright','© 2023 Archi Elite JSC. All right reserved.',NULL,NULL),(35,'theme-hously-favicon','general/favicon.png',NULL,NULL),(36,'theme-hously-logo','general/logo-light.png',NULL,NULL),(37,'theme-hously-logo_dark','general/logo-dark.png',NULL,NULL),(38,'theme-hously-404_page_image','general/error.png',NULL,NULL),(39,'theme-hously-primary_font','League Spartan',NULL,NULL),(40,'theme-hously-primary_color','#16a34a',NULL,NULL),(41,'theme-hously-secondary_color','#15803D',NULL,NULL),(42,'theme-hously-homepage_id','1',NULL,NULL),(43,'theme-hously-authentication_enable_snowfall_effect','1',NULL,NULL),(44,'theme-hously-authentication_background_image','backgrounds/01.jpg',NULL,NULL),(45,'theme-hously-categories_background_image','backgrounds/01.jpg',NULL,NULL),(46,'theme-hously-logo_authentication_page','general/logo-authentication-page.png',NULL,NULL),(47,'theme-hously-default_page_cover_image','backgrounds/01.jpg',NULL,NULL),(48,'theme-hously-projects_list_page_id','5',NULL,NULL),(49,'theme-hously-properties_list_page_id','6',NULL,NULL),(50,'theme-hously-blog_page_id','14',NULL,NULL),(51,'theme-hously-projects_list_layout','grid',NULL,NULL),(52,'theme-hously-properties_list_layout','grid',NULL,NULL),(53,'theme-hously-number_of_related_properties','6',NULL,NULL),(54,'theme-hously-social_links','[[{\"key\":\"social-name\",\"value\":\"Facebook\"},{\"key\":\"social-icon\",\"value\":\"mdi mdi-facebook\"},{\"key\":\"social-url\",\"value\":\"#\"}],[{\"key\":\"social-name\",\"value\":\"Instagram\"},{\"key\":\"social-icon\",\"value\":\"mdi mdi-instagram\"},{\"key\":\"social-url\",\"value\":\"#\"}],[{\"key\":\"social-name\",\"value\":\"Twitter\"},{\"key\":\"social-icon\",\"value\":\"mdi mdi-twitter\"},{\"key\":\"social-url\",\"value\":\"#\"}],[{\"key\":\"social-name\",\"value\":\"LinkedIn\"},{\"key\":\"social-icon\",\"value\":\"mdi mdi-linkedin\"},{\"key\":\"social-url\",\"value\":\"#\"}]]',NULL,NULL),(55,'theme-hously-enabled_toggle_theme_mode','1',NULL,NULL),(56,'theme-hously-default_theme_mode','system',NULL,NULL),(57,'theme-hously-show_whatsapp_button_on_consult_form','1',NULL,NULL);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slugs`
--

DROP TABLE IF EXISTS `slugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slugs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint unsigned NOT NULL,
  `reference_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prefix` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `slugs_reference_id_index` (`reference_id`),
  KEY `slugs_key_index` (`key`),
  KEY `slugs_prefix_index` (`prefix`),
  KEY `slugs_reference_index` (`reference_id`,`reference_type`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slugs`
--

LOCK TABLES `slugs` WRITE;
/*!40000 ALTER TABLE `slugs` DISABLE KEYS */;
INSERT INTO `slugs` VALUES (1,'apartment',1,'Botble\\RealEstate\\Models\\Category','property-category','2023-12-22 03:30:39','2023-12-22 03:30:39'),(2,'villa',2,'Botble\\RealEstate\\Models\\Category','property-category','2023-12-22 03:30:39','2023-12-22 03:30:39'),(3,'condo',3,'Botble\\RealEstate\\Models\\Category','property-category','2023-12-22 03:30:39','2023-12-22 03:30:39'),(4,'house',4,'Botble\\RealEstate\\Models\\Category','property-category','2023-12-22 03:30:39','2023-12-22 03:30:39'),(5,'land',5,'Botble\\RealEstate\\Models\\Category','property-category','2023-12-22 03:30:39','2023-12-22 03:30:39'),(6,'commercial-property',6,'Botble\\RealEstate\\Models\\Category','property-category','2023-12-22 03:30:39','2023-12-22 03:30:39'),(7,'home-one',1,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(8,'home-two',2,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(9,'home-three',3,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(10,'home-four',4,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(11,'projects',5,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(12,'properties',6,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(13,'about-us',7,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(14,'features',8,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(15,'pricing-plans',9,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(16,'frequently-asked-questions',10,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(17,'terms-of-services',11,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(18,'privacy-policy',12,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(19,'coming-soon',13,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(20,'news',14,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(21,'contact',15,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(22,'wishlist',16,'Botble\\Page\\Models\\Page','','2023-12-22 03:30:40','2023-12-22 03:30:40'),(23,'design',1,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(24,'lifestyle',2,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(25,'travel-tips',3,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(26,'healthy',4,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(27,'travel-tips',5,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(28,'hotel',6,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(29,'nature',7,'Botble\\Blog\\Models\\Category','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(30,'new',1,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(31,'event',2,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(32,'villa',3,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(33,'apartment',4,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(34,'condo',5,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(35,'luxury-villa',6,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(36,'family-home',7,'Botble\\Blog\\Models\\Tag','tag','2023-12-22 03:30:40','2023-12-22 03:30:40'),(37,'the-top-2020-handbag-trends-to-know',1,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(38,'top-search-engine-optimization-strategies',2,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(39,'which-company-would-you-choose',3,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(40,'used-car-dealer-sales-tricks-exposed',4,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:40','2023-12-22 03:30:40'),(41,'20-ways-to-sell-your-product-faster',5,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(42,'the-secrets-of-rich-and-famous-writers',6,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(43,'imagine-losing-20-pounds-in-14-days',7,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(44,'are-you-still-using-that-slow-old-typewriter',8,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(45,'a-skin-cream-thats-proven-to-work',9,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(46,'10-reasons-to-start-your-own-profitable-website',10,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(47,'simple-ways-to-reduce-your-unwanted-wrinkles',11,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(48,'apple-imac-with-retina-5k-display-review',12,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(49,'10000-web-site-visitors-in-one-monthguaranteed',13,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(50,'unlock-the-secrets-of-selling-high-ticket-items',14,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(51,'4-expert-tips-on-how-to-choose-the-right-mens-wallet',15,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(52,'sexy-clutches-how-to-buy-wear-a-designer-clutch-bag',16,'Botble\\Blog\\Models\\Post','news','2023-12-22 03:30:41','2023-12-22 03:30:41'),(53,'walnut-park-apartments',1,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(54,'sunshine-wonder-villas',2,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(55,'diamond-island',3,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(56,'the-nassim',4,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(57,'vinhomes-grand-park',5,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(58,'the-metropole-thu-thiem',6,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(59,'villa-on-grand-avenue',7,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(60,'traditional-food-restaurant',8,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(61,'villa-on-hollywood-boulevard',9,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(62,'office-space-at-northwest-107th',10,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(63,'home-in-merrick-way',11,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(64,'adarsh-greens',12,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(65,'rustomjee-evershine-global-city',13,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(66,'godrej-exquisite',14,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(67,'godrej-prime',15,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(68,'ps-panache',16,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(69,'upturn-atmiya-centria',17,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(70,'brigade-oasis',18,'Botble\\RealEstate\\Models\\Project','projects','2023-12-22 03:30:49','2023-12-22 03:30:49'),(71,'3-beds-villa-calpe-alicante',1,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(72,'lavida-plus-office-tel-1-bedroom',2,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(73,'vinhomes-grand-park-studio-1-bedroom',3,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(74,'the-sun-avenue-office-tel-1-bedroom',4,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(75,'property-for-sale-johannesburg-south-africa',5,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(76,'stunning-french-inspired-manor',6,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(77,'villa-for-sale-at-bermuda-dunes',7,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(78,'walnut-park-apartment',8,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(79,'5-beds-luxury-house',9,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(80,'family-victorian-view-home',10,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(81,'osaka-heights-apartment',11,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(82,'private-estate-magnificent-views',12,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(83,'thompson-road-house-for-rent',13,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(84,'brand-new-1-bedroom-apartment-in-first-class-location',14,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(85,'elegant-family-home-presents-premium-modern-living',15,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(86,'luxury-apartments-in-singapore-for-sale',16,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(87,'5-room-luxury-penthouse-for-sale-in-kuala-lumpur',17,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(88,'2-floor-house-in-compound-pejaten-barat-kemang',18,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(89,'apartment-muiderstraatweg-in-diemen',19,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(90,'nice-apartment-for-rent-in-berlin',20,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(91,'pumpkin-key-private-island',21,'Botble\\RealEstate\\Models\\Property','properties','2023-12-22 03:30:49','2023-12-22 03:30:49'),(92,'brandy-damore',1,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(93,'joseph-mueller',2,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(94,'dax-dooley',3,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(95,'rowena-gislason',4,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(96,'isai-rosenbaum',5,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(97,'leone-johnson',6,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(98,'edwin-armstrong',7,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(99,'jessie-heller',8,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(100,'carmelo-kiehn',9,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(101,'alfreda-terry',10,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(102,'maudie-ruecker',11,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(103,'ned-rau',12,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(104,'valerie-stamm',13,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(105,'gay-pouros',14,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(106,'maeve-wyman',15,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(107,'norval-medhurst',16,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(108,'kellie-dooley',17,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(109,'kristofer-auer',18,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(110,'vicenta-blanda',19,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(111,'lenny-konopelski',20,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54'),(112,'valerie-bruen',21,'Botble\\RealEstate\\Models\\Account','agents','2023-12-22 03:30:54','2023-12-22 03:30:54');
/*!40000 ALTER TABLE `slugs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slugs_translations`
--

DROP TABLE IF EXISTS `slugs_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `slugs_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slugs_id` bigint unsigned NOT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prefix` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`lang_code`,`slugs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slugs_translations`
--

LOCK TABLES `slugs_translations` WRITE;
/*!40000 ALTER TABLE `slugs_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `slugs_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `states` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `abbreviation` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` bigint unsigned DEFAULT NULL,
  `order` tinyint NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint unsigned NOT NULL DEFAULT '0',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `states_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES (1,'France','france','FR',1,0,NULL,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'England','england','EN',2,0,NULL,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'New York','new-york','NY',1,0,NULL,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'Holland','holland','HL',4,0,NULL,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'Denmark','denmark','DN',5,0,NULL,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(6,'Germany','germany','GER',1,0,NULL,0,'published','2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states_translations`
--

DROP TABLE IF EXISTS `states_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `states_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `states_id` bigint unsigned NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slug` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `abbreviation` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`states_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states_translations`
--

LOCK TABLES `states_translations` WRITE;
/*!40000 ALTER TABLE `states_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `states_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `author_id` bigint unsigned DEFAULT NULL,
  `author_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Botble\\ACL\\Models\\User',
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'New',2,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(2,'Event',2,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(3,'Villa',2,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(4,'Apartment',1,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(5,'Condo',2,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(6,'Luxury villa',1,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40'),(7,'Family home',2,'Botble\\ACL\\Models\\User','','published','2023-12-22 03:30:40','2023-12-22 03:30:40');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags_translations`
--

DROP TABLE IF EXISTS `tags_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tags_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`tags_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags_translations`
--

LOCK TABLES `tags_translations` WRITE;
/*!40000 ALTER TABLE `tags_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `tags_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testimonials`
--

DROP TABLE IF EXISTS `testimonials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testimonials` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testimonials`
--

LOCK TABLES `testimonials` WRITE;
/*!40000 ALTER TABLE `testimonials` DISABLE KEYS */;
INSERT INTO `testimonials` VALUES (1,'Christa Smith','Alice soon began talking to herself, as well as she spoke--fancy CURTSEYING as you\'re falling through the door, and tried to open them again, and put back into the jury-box, or they would go, and.','clients/01.jpg','Manager','published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(2,'John Smith','Majesty,\' the Hatter added as an explanation. \'Oh, you\'re sure to make SOME change in my life!\' Just as she could, for the fan and a long way back, and see how he did it,) he did with the next.','clients/02.jpg','Product designer','published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(3,'Sayen Ahmod','HERE.\' \'But then,\' thought she, \'if people had all to lie down upon their faces, so that by the English, who wanted leaders, and had come back again, and did not notice this last remark that had.','clients/03.jpg','Developer','published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(4,'Tayla Swef','Alice, and, after glaring at her with large round eyes, and feebly stretching out one paw, trying to invent something!\' \'I--I\'m a little startled by seeing the Cheshire Cat: now I shall have.','clients/04.jpg','Graphic designer','published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(5,'Christa Smith','Pig!\' She said the Duchess: you\'d better ask HER about it.\' (The jury all wrote down on one knee. \'I\'m a poor man,\' the Hatter was the White Rabbit, who said in an encouraging opening for a minute.','clients/05.jpg','Graphic designer','published','2023-12-22 03:30:41','2023-12-22 03:30:41'),(6,'James Garden','EVER happen in a great thistle, to keep herself from being broken. She hastily put down yet, before the officer could get away without speaking, but at last it unfolded its arms, took the watch and.','clients/06.jpg','Web Developer','published','2023-12-22 03:30:41','2023-12-22 03:30:41');
/*!40000 ALTER TABLE `testimonials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testimonials_translations`
--

DROP TABLE IF EXISTS `testimonials_translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testimonials_translations` (
  `lang_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `testimonials_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `company` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`lang_code`,`testimonials_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testimonials_translations`
--

LOCK TABLES `testimonials_translations` WRITE;
/*!40000 ALTER TABLE `testimonials_translations` DISABLE KEYS */;
/*!40000 ALTER TABLE `testimonials_translations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `credits` int unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `account_id` bigint unsigned DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'add',
  `payment_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_meta`
--

DROP TABLE IF EXISTS `user_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_meta` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_meta_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_meta`
--

LOCK TABLES `user_meta` WRITE;
/*!40000 ALTER TABLE `user_meta` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `first_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_id` bigint unsigned DEFAULT NULL,
  `super_user` tinyint(1) NOT NULL DEFAULT '0',
  `manage_supers` tinyint(1) NOT NULL DEFAULT '0',
  `permissions` text COLLATE utf8mb4_unicode_ci,
  `last_login` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_username_unique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'kling.glennie@haag.com',NULL,'$2y$12$A3xajZxKPnNT6fSfPJtQOO8NctR9UGKdT9yy9cd5daxWwk8TGBt5O',NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40','Dayna','Pfannerstill','botble',NULL,1,1,NULL,NULL),(2,'vbeatty@kuhn.com',NULL,'$2y$12$3FvGqk6n8sMJnne6dK0Db.lexBQhFep.VO8MHzaf3E2h0E/wmjRa2',NULL,'2023-12-22 03:30:40','2023-12-22 03:30:40','Catalina','Kautzer','admin',NULL,1,1,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `widgets`
--

DROP TABLE IF EXISTS `widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `widgets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `widget_id` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sidebar_id` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `theme` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` tinyint unsigned NOT NULL DEFAULT '0',
  `data` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `widgets`
--

LOCK TABLES `widgets` WRITE;
/*!40000 ALTER TABLE `widgets` DISABLE KEYS */;
INSERT INTO `widgets` VALUES (1,'NewsletterWidget','pre_footer','hously',0,'{\"name\":\"Subscribe to Newsletter.\",\"description\":\"Subscribe to get latest updates and information.\",\"title\":null,\"subtitle\":null}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(2,'SiteInformationWidget','footer_menu','hously',1,'{\"name\":\"Site Information\",\"logo\":\"general\\/logo-light.png\",\"url\":\"#\",\"description\":\"A great platform to buy, sell and rent your properties without any agent or commissions.\"}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(3,'CustomMenuWidget','footer_menu','hously',2,'{\"id\":\"CustomMenuWidget\",\"name\":\"Company\",\"menu_id\":\"company\"}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(4,'CustomMenuWidget','footer_menu','hously',3,'{\"id\":\"CustomMenuWidget\",\"name\":\"Useful Links\",\"menu_id\":\"useful-links\"}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(5,'ContactInformationWidget','footer_menu','hously',4,'{\"name\":\"Contact Details\",\"address\":\"C\\/54 Northwest Freeway, Suite 558, Houston, USA 485\",\"email\":\"contact@example.com\",\"phone\":\"+152 534-468-854\"}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(6,'BlogSearchWidget','blog_sidebar','hously',1,'{\"name\":\"Blog Search\"}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(7,'BlogPopularCategoriesWidget','blog_sidebar','hously',2,'{\"name\":\"Popular Categories\",\"limit\":5}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(8,'BlogPostsWidget','blog_sidebar','hously',3,'{\"name\":\"Popular Posts\",\"type\":\"popular\",\"limit\":5}','2023-12-22 03:30:41','2023-12-22 03:30:41'),(9,'BlogPopularTagsWidget','blog_sidebar','hously',4,'{\"name\":\"Popular Tags\",\"limit\":6}','2023-12-22 03:30:41','2023-12-22 03:30:41');
/*!40000 ALTER TABLE `widgets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-22 17:30:55
