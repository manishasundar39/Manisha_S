(205, 'Ishaan Roy', 'Kolkata', '9000000005', 'ishaan.roy@example.com'),
(206, 'Sara Khan', 'Hyderabad', '9000000006', 'sara.khan@example.com'),
(207, 'Neel Shah', 'Ahmedabad', '9000000007', 'neel.shah@example.com'),
(208, 'Tara Menon', 'Kochi', '9000000008', 'tara.menon@example.com'),
(209, 'Rohan Das', 'Jaipur', '9000000009', 'rohan.das@example.com');

INSERT INTO Borrow (borrow_id, book_id, member_id, borrow_date, return_date) VALUES
(301, 101, 201, '2026-09-01', '2026-09-15'),
(302, 101, 202, '2026-09-02', '2026-09-16'),
(303, 102, 203, '2026-09-03', '2026-09-17'),
(304, 103, 204, '2026-09-04', '2026-09-18'),
(305, 103, 205, '2026-09-05', '2026-09-19'),
(306, 104, 206, '2026-09-06', '2026-09-20'),
(307, 105, 207, '2026-09-07', '2026-09-21'),
(308, 107, 208, '2026-09-08', '2026-09-22'),
(309, 109, 201, '2026-09-09', '2026-09-23'),
(310, 110, 202, '2026-09-10', '2026-09-24');

INSERT INTO Books (book_id, book_name, author, price, category, stock_quantity)
VALUES (111, 'Sunrise over Jaipur', 'Leena Das', 510.00, 'Fiction', 10);
INSERT INTO Members (member_id, member_name, city, phone, email)
VALUES (210, 'Pia Fernandes', 'Goa', '9000000010', 'pia.fernandes@example.com');
INSERT INTO Borrow (borrow_id, book_id, member_id, borrow_date, return_date)
VALUES (311, 111, 210, '2026-09-11', '2026-09-25');

-- A2 - DML: updates
UPDATE Books SET price = 575.00 WHERE book_id = 103;
UPDATE Books SET price = ROUND(price * 1.10, 2) WHERE category = 'Technology';
UPDATE Books SET stock_quantity = stock_quantity + 5;
UPDATE Members SET city = 'Bengaluru' WHERE member_id = 204;
UPDATE Members SET email = 'mira.joshi.new@example.com' WHERE member_id = 204;
UPDATE Books SET category = 'Technology' WHERE book_id = 110;
UPDATE Borrow SET return_date = '2026-09-30' WHERE borrow_id = 304;

-- A2 - DML: deletes. Cascading foreign keys remove related borrow rows for book 106.
DELETE FROM Books WHERE book_id = 106;
DELETE FROM Members WHERE member_id = 209; -- no borrow records
DELETE FROM Borrow WHERE borrow_id = 310;
DELETE FROM Books WHERE stock_quantity = 0;

-- A3 - DQL
SELECT * FROM Books;
SELECT book_name, author FROM Books;
SELECT book_name, category, price FROM Books;
SELECT * FROM Books WHERE price > 500;
SELECT * FROM Books WHERE price < 500;
SELECT * FROM Books WHERE price BETWEEN 300 AND 800;
SELECT * FROM Books WHERE category = 'Technology';
SELECT * FROM Books WHERE author = 'R. K. Sharma';
SELECT * FROM Books WHERE book_name LIKE 'S%';
SELECT * FROM Books WHERE book_name LIKE '%SQL%';
SELECT * FROM Books WHERE category IN ('Technology', 'Education');
SELECT * FROM Books WHERE price <> 500;
SELECT * FROM Books WHERE stock_quantity > 10;
SELECT * FROM Books WHERE stock_quantity BETWEEN 5 AND 15;

-- A4 - DCL (execute as a MySQL administrator)
CREATE USER IF NOT EXISTS 'library_user'@'localhost' IDENTIFIED BY 'LibraryUser_ChangeMe_2026!';
GRANT SELECT ON LibraryDB.Books TO 'library_user'@'localhost';
GRANT INSERT ON LibraryDB.Books TO 'library_user'@'localhost';
GRANT UPDATE ON LibraryDB.Books TO 'library_user'@'localhost';
SHOW GRANTS FOR 'library_user'@'localhost';
REVOKE INSERT ON LibraryDB.Books FROM 'library_user'@'localhost';
REVOKE UPDATE ON LibraryDB.Books FROM 'library_user'@'localhost';
GRANT SELECT ON LibraryDB.* TO 'library_user'@'localhost';
REVOKE SELECT ON LibraryDB.Books FROM 'library_user'@'localhost';
SHOW GRANTS FOR 'library_user'@'localhost';

-- A5 - Sorting and LIMIT
SELECT * FROM Books ORDER BY price ASC;
SELECT * FROM Books ORDER BY price DESC;
SELECT * FROM Books ORDER BY book_name ASC;
SELECT * FROM Books ORDER BY category ASC, price ASC;
SELECT * FROM Books ORDER BY price DESC LIMIT 3;
SELECT * FROM Books ORDER BY price ASC LIMIT 3;
SELECT * FROM Books ORDER BY stock_quantity DESC LIMIT 5;
SELECT * FROM Members ORDER BY member_name ASC LIMIT 5;
SELECT * FROM Borrow ORDER BY borrow_date DESC, borrow_id DESC LIMIT 5;

-- A6 - Aggregate functions
SELECT COUNT(*) AS total_books FROM Books;
SELECT COUNT(*) AS total_members FROM Members;
SELECT COUNT(*) AS total_borrow_records FROM Borrow;
SELECT SUM(stock_quantity) AS total_stock_quantity FROM Books;
SELECT SUM(price) AS total_book_price FROM Books;
SELECT AVG(price) AS average_book_price FROM Books;
SELECT MAX(price) AS highest_book_price FROM Books;
SELECT MIN(price) AS lowest_book_price FROM Books;
SELECT MAX(price) - MIN(price) AS price_difference FROM Books;
SELECT AVG(stock_quantity) AS average_stock_quantity FROM Books;

-- A7 - GROUP BY
SELECT category, COUNT(*) AS book_count FROM Books GROUP BY category;
SELECT category, AVG(price) AS average_price FROM Books GROUP BY category;
SELECT category, MAX(price) AS highest_price FROM Books GROUP BY category;
SELECT category, MIN(price) AS lowest_price FROM Books GROUP BY category;
SELECT category, SUM(stock_quantity) AS total_stock FROM Books GROUP BY category;
SELECT category, SUM(price * stock_quantity) AS total_inventory_value FROM Books GROUP BY category;
SELECT category, COUNT(*) AS book_count FROM Books GROUP BY category HAVING COUNT(*) > 2;
SELECT category, AVG(price) AS average_price FROM Books GROUP BY category HAVING AVG(price) > 500;
SELECT author, COUNT(*) AS book_count FROM Books GROUP BY author;
SELECT author, AVG(price) AS average_price FROM Books GROUP BY author;

-- A8 - HAVING (the pasted assignment truncates during question 79)
SELECT category, COUNT(*) AS book_count FROM Books GROUP BY category HAVING COUNT(*) > 2;
SELECT category, AVG(price) AS average_price FROM Books GROUP BY category HAVING AVG(price) > 500;
SELECT author, COUNT(*) AS book_count FROM Books GROUP BY author HAVING COUNT(*) > 1;
SELECT category, SUM(stock_quantity) AS total_stock FROM Books GROUP BY category HAVING SUM(stock_quantity) > 20;
-- Visible fragment of question 79: "Display authors whose average b..."
-- Assumption: the intended condition is average book price greater than ₹500.
SELECT author, AVG(price) AS average_price FROM Books GROUP BY author HAVING AVG(price) > 500;
