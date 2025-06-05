-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Waktu pembuatan: 05 Jun 2025 pada 11.31
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pitjarus`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_product_area_percentage` (IN `from_date` DATE, IN `to_date` DATE, IN `filter_area` VARCHAR(100))   BEGIN
  DECLARE sql_text TEXT;
  DECLARE area_condition TEXT DEFAULT '';
  DECLARE where_condition TEXT;

  -- Bangun kondisi tambahan untuk area (sebagai bagian dari WHERE)
  IF filter_area IS NOT NULL AND filter_area != '' THEN
        -- Buat bagian kolom pivot
  SELECT GROUP_CONCAT(
    DISTINCT
    CONCAT(
      'ROUND(100 * SUM(CASE WHEN sar.area_name = ''',
      area_name,
      ''' THEN sa.compliance ELSE 0 END) / SUM(sa.compliance), 2) AS `',
      area_name, '`'
    )
  ) INTO sql_text
  FROM store_area WHERE area_id=filter_area;
  ELSE
    -- Buat bagian kolom pivot
  SELECT GROUP_CONCAT(
    DISTINCT
    CONCAT(
      'ROUND(100 * SUM(CASE WHEN sar.area_name = ''',
      area_name,
      ''' THEN sa.compliance ELSE 0 END) / SUM(sa.compliance), 2) AS `',
      area_name, '`'
    )
  ) INTO sql_text
  FROM store_area;
  END IF;



  -- Gabungkan semua query
  SET @final_sql = CONCAT(
    'SELECT p.product_name AS product_name, ',
    sql_text,
    ' FROM report sa
      JOIN store s ON s.store_id = sa.store_id
      JOIN store_area sar ON s.area_id = sar.area_id
      JOIN product p ON p.product_id = sa.product_id
      WHERE sa.tanggal BETWEEN "', from_date, '" AND "', to_date, '"',
    area_condition,
    ' GROUP BY p.product_id, p.product_name
      ORDER BY p.product_name'
  );

  -- Eksekusi query dinamis
  PREPARE stmt FROM @final_sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `brand`
--

CREATE TABLE `brand` (
  `brand_id` bigint(20) NOT NULL,
  `brand_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `brand`
--

INSERT INTO `brand` (`brand_id`, `brand_name`) VALUES
(1, 'Indofood'),
(2, 'Bread Co');

-- --------------------------------------------------------

--
-- Struktur dari tabel `product`
--

CREATE TABLE `product` (
  `product_id` bigint(20) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `brand_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `brand_id`) VALUES
(1, 'SUSU KALENG', 1),
(2, 'ROTI TAWAR', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `report`
--

CREATE TABLE `report` (
  `report_id` bigint(20) NOT NULL,
  `store_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `compliance` int(11) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `report`
--

INSERT INTO `report` (`report_id`, `store_id`, `product_id`, `compliance`, `tanggal`) VALUES
(1, 1, 1, 2000, '2025-06-10'),
(2, 1, 1, 2000, '2025-05-10'),
(3, 2, 1, 4000, '2025-06-10'),
(4, 3, 1, 1000, '2025-06-10'),
(5, 4, 1, 500, '2025-06-10'),
(6, 5, 1, 400, '2025-06-10'),
(7, 6, 1, 1500, '2025-06-10'),
(8, 7, 1, 1250, '2025-06-10'),
(9, 7, 1, 500, '2025-05-10'),
(10, 1, 2, 2000, '2025-05-10'),
(11, 2, 2, 4000, '2025-06-10'),
(12, 3, 2, 1000, '2025-06-10'),
(13, 4, 2, 500, '2025-06-10'),
(14, 5, 2, 400, '2025-06-10'),
(15, 6, 2, 1500, '2025-06-10'),
(16, 7, 2, 1250, '2025-06-10'),
(17, 7, 2, 500, '2025-05-10');

-- --------------------------------------------------------

--
-- Struktur dari tabel `store`
--

CREATE TABLE `store` (
  `store_id` bigint(20) NOT NULL,
  `store_name` varchar(255) NOT NULL,
  `account_id` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `is_active` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `store`
--

INSERT INTO `store` (`store_id`, `store_name`, `account_id`, `area_id`, `is_active`) VALUES
(1, 'Setiabudhi', 1, 1, 1),
(2, 'Gatot Subroto', 1, 1, 1),
(3, 'Dago', 1, 2, 1),
(4, 'Cikutra', 1, 2, 1),
(5, 'IKN', 1, 3, 1),
(6, 'Semarang', 1, 4, 1),
(7, 'Denpasar', 1, 5, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `store_area`
--

CREATE TABLE `store_area` (
  `area_id` bigint(20) NOT NULL,
  `area_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `store_area`
--

INSERT INTO `store_area` (`area_id`, `area_name`) VALUES
(1, 'DKI Jakarta'),
(2, 'Jawa Barat'),
(3, 'Kalimantan'),
(4, 'Jawa Tengah'),
(5, 'Bali');

-- --------------------------------------------------------

--
-- Struktur dari tabel `strore_account`
--

CREATE TABLE `strore_account` (
  `account_id` bigint(20) NOT NULL,
  `account_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `strore_account`
--

INSERT INTO `strore_account` (`account_id`, `account_name`) VALUES
(1, 'Store Ledger');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`brand_id`);

--
-- Indeks untuk tabel `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indeks untuk tabel `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`report_id`);

--
-- Indeks untuk tabel `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`store_id`);

--
-- Indeks untuk tabel `store_area`
--
ALTER TABLE `store_area`
  ADD PRIMARY KEY (`area_id`),
  ADD UNIQUE KEY `area_id` (`area_id`),
  ADD UNIQUE KEY `area_id_2` (`area_id`),
  ADD UNIQUE KEY `area_id_4` (`area_id`),
  ADD KEY `area_id_3` (`area_id`);

--
-- Indeks untuk tabel `strore_account`
--
ALTER TABLE `strore_account`
  ADD PRIMARY KEY (`account_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `brand`
--
ALTER TABLE `brand`
  MODIFY `brand_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `product`
--
ALTER TABLE `product`
  MODIFY `product_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `report`
--
ALTER TABLE `report`
  MODIFY `report_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `store`
--
ALTER TABLE `store`
  MODIFY `store_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `store_area`
--
ALTER TABLE `store_area`
  MODIFY `area_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `strore_account`
--
ALTER TABLE `strore_account`
  MODIFY `account_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
