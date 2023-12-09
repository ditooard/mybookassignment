-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 09 Des 2023 pada 17.46
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `book_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_books`
--

CREATE TABLE `tbl_books` (
  `book_id` int(11) NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `book_isbn` varchar(17) NOT NULL,
  `book_title` varchar(200) NOT NULL,
  `book_desc` varchar(2000) NOT NULL,
  `book_author` varchar(100) NOT NULL,
  `book_price` decimal(6,2) NOT NULL,
  `book_qty` int(11) NOT NULL,
  `book_status` varchar(10) NOT NULL,
  `book_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_books`
--

INSERT INTO `tbl_books` (`book_id`, `user_id`, `book_isbn`, `book_title`, `book_desc`, `book_author`, `book_price`, `book_qty`, `book_status`, `book_date`) VALUES
(1, '1', '978-0-7475-3269-9', 'Bumi', 'This novel tells the story of the adventures of three 15-year-old teenagers named Raib, Ali, and Seli. However, they are not ordinary teenagers; instead, they are teenagers with special abilities. Raib has the power to disappear, Seli can summon lightning, and Ali is a highly intelligent student.', 'Tere Liye', '260.00', 2, 'Used', '2023-12-09 23:35:45.013883');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_password`, `user_datereg`) VALUES
(1, 'fariz@gmail.com', 'Muhammad Fadhilah Alfarizi', '4afefe748e9659cbd3d21955f5db1ef91615aee3', '2023-12-09 22:23:10.350807');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `tbl_books`
--
ALTER TABLE `tbl_books`
  ADD PRIMARY KEY (`book_id`),
  ADD UNIQUE KEY `book_isbn` (`book_isbn`);

--
-- Indeks untuk tabel `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `tbl_books`
--
ALTER TABLE `tbl_books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
