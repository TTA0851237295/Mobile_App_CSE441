-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th12 24, 2025 lúc 03:24 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `tam_an_app`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `entries`
--

CREATE TABLE `entries` (
  `id` varchar(64) NOT NULL,
  `user_id` varchar(64) NOT NULL,
  `timestamp` bigint(20) UNSIGNED NOT NULL,
  `emotion` enum('happy','joyful','neutral','sad','anxious','stressed','angry') NOT NULL,
  `location` enum('work','home','commute','outdoor','other') DEFAULT NULL,
  `activity` enum('meeting','coding','studying','social-media','eating','exercise','relaxing','other') DEFAULT NULL,
  `company` enum('alone','colleagues','boss','family','friends','partner','other') DEFAULT NULL,
  `note` text DEFAULT NULL,
  `custom_tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom_tags`)),
  `health_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`health_data`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `entries`
--

INSERT INTO `entries` (`id`, `user_id`, `timestamp`, `emotion`, `location`, `activity`, `company`, `note`, `custom_tags`, `health_data`) VALUES
('entry-01', 'user-demo', 1766509852000, 'stressed', 'work', 'coding', 'alone', 'Deadline nhiều, hơi áp lực', '[\"deadline\",\"project\"]', '{\"sleepHours\":5,\"steps\":3000,\"exercise\":false,\"water\":4}'),
('entry-02', 'user-demo', 1766509852000, 'happy', 'home', 'relaxing', 'family', 'Ăn tối cùng gia đình rất vui', '[\"family\",\"dinner\"]', '{\"sleepHours\":7,\"steps\":5000,\"exercise\":true,\"water\":6}'),
('entry-03', 'user-01', 1766509852000, 'neutral', '', 'meeting', 'colleagues', 'Họp bình thường, không quá căng', '[\"meeting\"]', '{\"sleepHours\":6,\"steps\":4200,\"exercise\":false,\"water\":5}'),
('entry-04', 'user-02', 1766509852000, 'sad', 'home', 'social-media', 'alone', 'Xem mạng xã hội nhiều nên hơi buồn', '[\"social\"]', '{\"sleepHours\":6,\"steps\":2000,\"exercise\":false,\"water\":3}');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `goals`
--

CREATE TABLE `goals` (
  `id` varchar(64) NOT NULL,
  `user_id` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `target_days` int(11) NOT NULL,
  `created_at` bigint(20) UNSIGNED NOT NULL,
  `completed_at` bigint(20) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `target_metric` enum('reduce_stress','increase_happiness','custom') DEFAULT NULL,
  `auto_tracking` tinyint(1) DEFAULT NULL,
  `target_value` decimal(10,2) DEFAULT NULL,
  `baseline_value` decimal(10,2) DEFAULT NULL,
  `milestones` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`milestones`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `goals`
--

INSERT INTO `goals` (`id`, `user_id`, `title`, `description`, `target_days`, `created_at`, `completed_at`, `is_active`, `target_metric`, `auto_tracking`, `target_value`, `baseline_value`, `milestones`) VALUES
('goal-01', 'user-demo', 'Giảm stress 30 ngày', 'Theo dõi cảm xúc mỗi ngày để giảm stress', 30, 1766509852000, NULL, 1, 'reduce_stress', 1, 30.00, 100.00, NULL),
('goal-02', 'user-01', 'Tăng cảm xúc tích cực', 'Ghi lại khoảnh khắc vui vẻ mỗi ngày', 14, 1766509852000, NULL, 1, 'increase_happiness', 1, 20.00, 50.00, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `milestones`
--

CREATE TABLE `milestones` (
  `id` varchar(64) NOT NULL,
  `goal_id` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `achieved_at` bigint(20) UNSIGNED DEFAULT NULL,
  `percentage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `milestones`
--

INSERT INTO `milestones` (`id`, `goal_id`, `title`, `achieved_at`, `percentage`) VALUES
('ms-01', 'goal-01', 'Hoàn thành 7 ngày đầu', NULL, 25),
('ms-02', 'goal-01', 'Hoàn thành 15 ngày', NULL, 50),
('ms-03', 'goal-02', 'Check-in 7 ngày liên tục', NULL, 50);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `settings`
--

CREATE TABLE `settings` (
  `user_id` varchar(64) NOT NULL,
  `notifications_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `notification_frequency` int(11) NOT NULL DEFAULT 3,
  `notification_times` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`notification_times`)),
  `custom_location_tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '[]' CHECK (json_valid(`custom_location_tags`)),
  `custom_activity_tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '[]' CHECK (json_valid(`custom_activity_tags`)),
  `custom_company_tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '[]' CHECK (json_valid(`custom_company_tags`)),
  `user_name` varchar(255) DEFAULT NULL,
  `dark_mode` tinyint(1) NOT NULL DEFAULT 0,
  `data_export_format` enum('json','csv') NOT NULL DEFAULT 'json',
  `reminder_sound` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `settings`
--

INSERT INTO `settings` (`user_id`, `notifications_enabled`, `notification_frequency`, `notification_times`, `custom_location_tags`, `custom_activity_tags`, `custom_company_tags`, `user_name`, `dark_mode`, `data_export_format`, `reminder_sound`) VALUES
('user-01', 1, 2, '[\"08:00\",\"20:00\"]', '[\"office\",\"home\"]', '[\"meeting\",\"coding\"]', '[\"colleagues\"]', 'Tuấn Anh', 1, 'csv', 1),
('user-02', 0, 1, NULL, '[]', '[]', '[]', 'Linh', 0, 'json', 0),
('user-demo', 1, 3, '[\"09:00\",\"14:00\",\"21:00\"]', '[\"library\",\"cafe\"]', '[\"coding\",\"studying\"]', '[\"friends\",\"family\"]', 'Demo User', 0, 'json', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `system_stats`
--

CREATE TABLE `system_stats` (
  `timestamp` bigint(20) UNSIGNED NOT NULL,
  `total_users` int(11) NOT NULL,
  `active_users` int(11) NOT NULL,
  `total_check_ins` int(11) NOT NULL,
  `average_check_ins_per_user` decimal(10,2) NOT NULL,
  `most_common_emotion` enum('happy','joyful','neutral','sad','anxious','stressed','angry') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `system_stats`
--

INSERT INTO `system_stats` (`timestamp`, `total_users`, `active_users`, `total_check_ins`, `average_check_ins_per_user`, `most_common_emotion`) VALUES
(1766509852000, 4, 3, 12, 3.00, 'happy');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tips`
--

CREATE TABLE `tips` (
  `id` varchar(64) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `category` enum('stress','anxiety','happiness','general') NOT NULL,
  `created_by` varchar(64) NOT NULL,
  `created_at` bigint(20) UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tips`
--

INSERT INTO `tips` (`id`, `title`, `content`, `category`, `created_by`, `created_at`, `is_active`) VALUES
('tip-01', 'Hít thở sâu 4-7-8', 'Hít vào 4s, giữ 7s, thở ra 8s để giảm căng thẳng.', 'stress', 'admin-default', 1766509852000, 1),
('tip-02', 'Viết 3 điều biết ơn', 'Mỗi ngày viết ra 3 điều khiến bạn cảm thấy biết ơn.', 'happiness', 'admin-default', 1766509852000, 1),
('tip-03', 'Giảm thời gian mạng xã hội', 'Giới hạn mạng xã hội giúp giảm lo âu.', 'general', 'admin-default', 1766509852000, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` varchar(64) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL,
  `created_at` bigint(20) UNSIGNED NOT NULL,
  `last_login` bigint(20) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `created_at`, `last_login`, `is_active`) VALUES
('admin-default', 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'admin', 1766509833000, NULL, 1),
('user-01', 'tuananh', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'user', 1766509852000, NULL, 1),
('user-02', 'linh', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'user', 1766509852000, NULL, 1),
('user-demo', 'demo', 'd3ad9315b7be5dd53b31a273b3b3aba5defe700808305aa16a3062b76658a791', 'user', 1766509833000, NULL, 1);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `entries`
--
ALTER TABLE `entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_timestamp` (`timestamp`),
  ADD KEY `idx_emotion` (`emotion`),
  ADD KEY `idx_location` (`location`),
  ADD KEY `idx_activity` (`activity`),
  ADD KEY `idx_company` (`company`),
  ADD KEY `idx_user_timestamp` (`user_id`,`timestamp`);

--
-- Chỉ mục cho bảng `goals`
--
ALTER TABLE `goals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Chỉ mục cho bảng `milestones`
--
ALTER TABLE `milestones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_goal_id` (`goal_id`),
  ADD KEY `idx_achieved` (`achieved_at`);

--
-- Chỉ mục cho bảng `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`user_id`);

--
-- Chỉ mục cho bảng `system_stats`
--
ALTER TABLE `system_stats`
  ADD PRIMARY KEY (`timestamp`);

--
-- Chỉ mục cho bảng `tips`
--
ALTER TABLE `tips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_username` (`username`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `entries`
--
ALTER TABLE `entries`
  ADD CONSTRAINT `fk_entries_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `goals`
--
ALTER TABLE `goals`
  ADD CONSTRAINT `fk_goals_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `milestones`
--
ALTER TABLE `milestones`
  ADD CONSTRAINT `fk_milestones_goal` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `settings`
--
ALTER TABLE `settings`
  ADD CONSTRAINT `fk_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `tips`
--
ALTER TABLE `tips`
  ADD CONSTRAINT `fk_tips_admin` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
