-- 1. Book names and member names for borrowed books
SELECT b.book_name, m.member_name
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id;

-- 2. Book name, member name, and borrow date
SELECT b.book_name, m.member_name, br.borrow_date
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id;

-- 3. Book name, author, member name, and city
SELECT b.book_name, b.author, m.member_name, m.city
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id;

-- 4. Books borrowed by members from Chennai
SELECT b.book_name
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id
WHERE m.city = 'Chennai';

-- 5. Books borrowed by a specific member
SELECT b.book_name
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id
WHERE m.member_id = :member_id;

-- 6. Members who have borrowed Technology books
SELECT DISTINCT m.member_name
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id
WHERE b.category = 'Technology';

-- 7. Book names and their borrowers
SELECT b.book_name, m.member_name AS borrower
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id;

-- 8. Borrow details sorted by borrow date
SELECT br.*, b.book_name, m.member_name
FROM Borrow br
INNER JOIN Books b ON br.book_id = b.book_id
INNER JOIN Members m ON br.member_id = m.member_id
ORDER BY br.borrow_date;
-- 9. All books and the members who borrowed them
SELECT b.book_name, m.member_name
FROM Books b
LEFT JOIN Borrow br ON b.book_id = br.book_id
LEFT JOIN Members m ON br.member_id = m.member_id;

-- 10. All books, including books never borrowed
SELECT b.book_id, b.book_name, br.borrow_id, br.borrow_date
FROM Books b
LEFT JOIN Borrow br ON b.book_id = br.book_id;

-- 11. All members and their borrowed books
SELECT m.member_name, b.book_name
FROM Members m
LEFT JOIN Borrow br ON m.member_id = br.member_id
LEFT JOIN Books b ON br.book_id = b.book_id;

-- 12. All members, including members who never borrowed
SELECT m.member_id, m.member_name, br.borrow_id, br.borrow_date
FROM Members m
LEFT JOIN Borrow br ON m.member_id = br.member_id;

-- 13. Books that have never been borrowed
SELECT b.book_id, b.book_name
FROM Books b
LEFT JOIN Borrow br ON b.book_id = br.book_id
WHERE br.borrow_id IS NULL;

-- 14. Members who have never borrowed a book
SELECT m.member_id, m.member_name
FROM Members m
LEFT JOIN Borrow br ON m.member_id = br.member_id
WHERE br.borrow_id IS NULL;
-- 15. All borrow records and matching book names
SELECT br.*, b.book_name
FROM Books b
RIGHT JOIN Borrow br ON b.book_id = br.book_id;

-- 16. All borrow records with member names
SELECT br.*, m.member_name
FROM Members m
RIGHT JOIN Borrow br ON m.member_id = br.member_id;

-- 17. All members and their borrow information
SELECT m.member_id, m.member_name, br.borrow_id, br.book_id, br.borrow_date
FROM Borrow br
RIGHT JOIN Members m ON br.member_id = m.member_id;
-- 18. Every possible combination of books and members
SELECT b.book_name, m.member_name
FROM Books b
CROSS JOIN Members m;

-- 19. Total number of book-member combinations
SELECT COUNT(*) AS total_combinations
FROM Books b
CROSS JOIN Members m;

-- 20. Member-book combinations for Technology books only
SELECT m.member_name, b.book_name
FROM Members m
CROSS JOIN Books b
WHERE b.category = 'Technology';
-- 21. Number of books each member has borrowed
SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
LEFT JOIN Borrow br ON m.member_id = br.member_id
GROUP BY m.member_id, m.member_name;

-- 22. Number of members who borrowed each book
SELECT b.book_id, b.book_name, COUNT(DISTINCT br.member_id) AS member_count
FROM Books b
LEFT JOIN Borrow br ON b.book_id = br.book_id
GROUP BY b.book_id, b.book_name;

-- 23. Most borrowed book (includes ties)
SELECT b.book_id, b.book_name, COUNT(br.borrow_id) AS borrow_count
FROM Books b
JOIN Borrow br ON b.book_id = br.book_id
GROUP BY b.book_id, b.book_name
HAVING COUNT(br.borrow_id) = (
    SELECT MAX(borrow_count)
    FROM (
        SELECT COUNT(*) AS borrow_count
        FROM Borrow
        GROUP BY book_id
    ) counts
);

-- 24. Members who have borrowed more than 2 books
SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
JOIN Borrow br ON m.member_id = br.member_id
GROUP BY m.member_id, m.member_name
HAVING COUNT(br.borrow_id) > 2;

-- 25. Categories and number of borrow records for books in each category
SELECT b.category, COUNT(br.borrow_id) AS borrow_count
FROM Books b
LEFT JOIN Borrow br ON b.book_id = br.book_id
GROUP BY b.category;

-- 26. Total borrowed-book records for each category
SELECT b.category, COUNT(br.borrow_id) AS total_borrowed
FROM Books b
JOIN Borrow br ON b.book_id = br.book_id
GROUP BY b.category;
-- C1.1 Books priced above the average price
SELECT *
FROM Books
WHERE price > (SELECT AVG(price) FROM Books);

-- C1.2 Books priced below the average price
SELECT *
FROM Books
WHERE price < (SELECT AVG(price) FROM Books);

-- C1.3 Most expensive book (includes ties)
SELECT *
FROM Books
WHERE price = (SELECT MAX(price) FROM Books);

-- C1.4 Cheapest book (includes ties)
SELECT *
FROM Books
WHERE price = (SELECT MIN(price) FROM Books);

-- C1.5 Books with the same price as book_id 2
SELECT *
FROM Books
WHERE price = (SELECT price FROM Books WHERE book_id = 2);

-- C1.6 Books with stock above the average stock quantity
SELECT *
FROM Books
WHERE stock_quantity > (SELECT AVG(stock_quantity) FROM Books);
-- 7. Books in categories containing more than one book
SELECT *
FROM Books
WHERE category IN (
    SELECT category
    FROM Books
    GROUP BY category
    HAVING COUNT(*) > 1
);

-- 8. Books by authors who have written more than one book
SELECT *
FROM Books
WHERE author IN (
    SELECT author
    FROM Books
    GROUP BY author
    HAVING COUNT(*) > 1
);

-- 9. Books in categories whose average price is greater than ₹500
SELECT *
FROM Books
WHERE category IN (
    SELECT category
    FROM Books
    GROUP BY category
    HAVING AVG(price) > 500
);

-- 10. Members who have borrowed Technology books
SELECT *
FROM Members
WHERE member_id IN (
    SELECT br.member_id
    FROM Borrow br
    WHERE br.book_id IN (
        SELECT book_id
        FROM Books
        WHERE category = 'Technology'
    )
);
-- 11. Books that have never been borrowed
SELECT *
FROM Books
WHERE book_id NOT IN (
    SELECT book_id
    FROM Borrow
    WHERE book_id IS NOT NULL
);

-- 12. Members who have never borrowed a book
SELECT *
FROM Members
WHERE member_id NOT IN (
    SELECT member_id
    FROM Borrow
    WHERE member_id IS NOT NULL
);

-- 13. Authors whose books have never been borrowed
SELECT DISTINCT author
FROM Books
WHERE author NOT IN (
    SELECT b.author
    FROM Books b
    JOIN Borrow br ON br.book_id = b.book_id
    WHERE b.author IS NOT NULL
);
-- 17. Books with at least one borrow record
SELECT b.*
FROM Books b
WHERE EXISTS (
    SELECT 1
    FROM Borrow br
    WHERE br.book_id = b.book_id
);

-- 18. Members with at least one borrow record
SELECT m.*
FROM Members m
WHERE EXISTS (
    SELECT 1
    FROM Borrow br
    WHERE br.member_id = m.member_id
);

-- 19. Books borrowed at least twice
SELECT b.*
FROM Books b
WHERE EXISTS (
    SELECT 1
    FROM Borrow br
    WHERE br.book_id = b.book_id
    GROUP BY br.book_id
    HAVING COUNT(*) >= 2
);
-- 1. Books priced above the overall average
WITH AveragePrice AS (
    SELECT AVG(price) AS avg_price
    FROM Books
)
SELECT b.*
FROM Books b
CROSS JOIN AveragePrice ap
WHERE b.price > ap.avg_price;

-- 2. Average price for each category
WITH CategoryAverage AS (
    SELECT category, AVG(price) AS avg_price
    FROM Books
    GROUP BY category
)
SELECT *
FROM CategoryAverage;

-- 3. Books priced above their category's average
WITH CategoryAverage AS (
    SELECT category, AVG(price) AS avg_price
    FROM Books
    GROUP BY category
)
SELECT b.*
FROM Books b
JOIN CategoryAverage ca ON ca.category = b.category
WHERE b.price > ca.avg_price;

-- 4. Total stock quantity for each category
WITH CategoryStock AS (
    SELECT category, SUM(stock_quantity) AS total_stock
    FROM Books
    GROUP BY category
)
SELECT *
FROM CategoryStock;

-- 5. Categories with total stock greater than 20
WITH CategoryStock AS (
    SELECT category, SUM(stock_quantity) AS total_stock
    FROM Books
    GROUP BY category
)
SELECT category, total_stock
FROM CategoryStock
WHERE total_stock > 20;

-- 6. Most expensive book in each category (includes ties)
WITH CategoryMaximum AS (
    SELECT category, MAX(price) AS max_price
    FROM Books
    GROUP BY category
)
SELECT b.*
FROM Books b
JOIN CategoryMaximum cm
  ON cm.category = b.category
 AND cm.max_price = b.price;

-- 7. Number of books written by each author
WITH AuthorBookCount AS (
    SELECT author, COUNT(*) AS book_count
    FROM Books
    GROUP BY author
)
SELECT *
FROM AuthorBookCount;

-- 8. Authors who have written more than one book
WITH AuthorBookCount AS (
    SELECT author, COUNT(*) AS book_count
    FROM Books
    GROUP BY author
)
SELECT author, book_count
FROM AuthorBookCount
WHERE book_count > 1;
-- 9. Rank all books by price, highest first
SELECT book_id, book_name, price,
       RANK() OVER (ORDER BY price DESC) AS price_rank
FROM Books;

-- 10. Rank all books by price, lowest first
SELECT book_id, book_name, price,
       RANK() OVER (ORDER BY price ASC) AS price_rank
FROM Books;

-- 11. Unique row number by price
SELECT book_id, book_name, price,
       ROW_NUMBER() OVER (ORDER BY price DESC, book_id) AS row_num
FROM Books;

-- 12. Rank books within each category (ties leave gaps)
SELECT book_id, book_name, category, price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) AS category_rank
FROM Books;

-- 13. Dense rank books within each category (no gaps after ties)
SELECT book_id, book_name, category, price,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS category_rank
FROM Books;

-- 14. Each book with its category's average price
SELECT book_id, book_name, category, price,
       AVG(price) OVER (PARTITION BY category) AS category_avg_price
FROM Books;

-- 15. Each book with the highest price in its category
SELECT book_id, book_name, category, price,
       MAX(price) OVER (PARTITION BY category) AS category_max_price
FROM Books;

-- 16. Each book with the lowest price in its category
SELECT book_id, book_name, category, price,
       MIN(price) OVER (PARTITION BY category) AS category_min_price
FROM Books;

-- 17. Difference between book price and category average
SELECT book_id, book_name, category, price,
       price - AVG(price) OVER (PARTITION BY category) AS difference_from_category_avg
FROM Books;

-- 18. Cumulative stock quantity across all books
SELECT book_id, book_name, stock_quantity,
       SUM(stock_quantity) OVER (
           ORDER BY book_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_stock
FROM Books;

-- 19. Cumulative stock quantity within each category
SELECT book_id, book_name, category, stock_quantity,
       SUM(stock_quantity) OVER (
           PARTITION BY category
           ORDER BY book_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS category_cumulative_stock
FROM Books;

-- 20. Previous book's price, ordered by price
SELECT book_id, book_name, price,
       LAG(price) OVER (ORDER BY price, book_id) AS previous_book_price
FROM Books;

-- 21. Next book's price, ordered by price
SELECT book_id, book_name, price,
       LEAD(price) OVER (ORDER BY price, book_id) AS next_book_price
FROM Books;

-- 22. Difference between current and previous book price
SELECT book_id, book_name, price,
       price - LAG(price) OVER (ORDER BY price, book_id) AS difference_from_previous_price
FROM Books;
-- 23. Expensive or affordable
SELECT book_name, price,
       CASE
           WHEN price > 600 THEN 'Expensive'
           ELSE 'Affordable'
       END AS price_class
FROM Books;

-- 24. Low, medium, or high price
SELECT book_name, price,
       CASE
           WHEN price < 400 THEN 'Low'
           WHEN price <= 700 THEN 'Medium'
           ELSE 'High'
       END AS price_class
FROM Books;

-- 25. Stock status
SELECT book_name, stock_quantity,
       CASE
           WHEN stock_quantity = 0 THEN 'Out of Stock'
           WHEN stock_quantity BETWEEN 1 AND 5 THEN 'Low Stock'
           ELSE 'Available'
       END AS stock_status
FROM Books;

-- 26. Book name, price, and price category
SELECT book_name, price,
       CASE
           WHEN price < 400 THEN 'Low'
           WHEN price <= 700 THEN 'Medium'
           ELSE 'High'
       END AS price_category
FROM Books;

-- 27. Book name, stock quantity, and stock status
SELECT book_name, stock_quantity,
       CASE
           WHEN stock_quantity = 0 THEN 'Out of Stock'
           WHEN stock_quantity BETWEEN 1 AND 5 THEN 'Low Stock'
           ELSE 'Available'
       END AS stock_status
FROM Books;

-- 28. Count books in each price category
SELECT
    CASE
        WHEN price < 400 THEN 'Low'
        WHEN price <= 700 THEN 'Medium'
        ELSE 'High'
    END AS price_category,
    COUNT(*) AS book_count
FROM Books
GROUP BY
    CASE
        WHEN price < 400 THEN 'Low'
        WHEN price <= 700 THEN 'Medium'
        ELSE 'High'
    END;

-- 29. Apply a ₹100 discount to books priced above ₹700
SELECT book_name, price,
       CASE
           WHEN price > 700 THEN price - 100
           ELSE price
       END AS discounted_price
FROM Books;
-- 30. Create a view of Technology books
CREATE VIEW Technology_Books AS
SELECT *
FROM Books
WHERE category = 'Technology';

-- 31. Display the view
SELECT *
FROM Technology_Books;

-- 32. Create a view of books priced above ₹600
CREATE VIEW Expensive_Books AS
SELECT *
FROM Books
WHERE price > 600;

-- 33. Create a view of books with available stock
CREATE VIEW Available_Books AS
SELECT *
FROM Books
WHERE stock_quantity > 0;
-- 34. Create a view combining book and borrower details
CREATE VIEW Library_Borrow_Details AS
SELECT b.book_name, b.author, m.member_name, m.city, br.borrow_date
FROM Borrow br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id;

-- 35. Display the view data
SELECT *
FROM Library_Borrow_Details;

-- 36. View of each category's average book price
CREATE VIEW Category_Average_Price AS
SELECT category, AVG(price) AS average_price
FROM Books
GROUP BY category;

-- 37. View of members who have borrowed books
CREATE VIEW Members_Who_Borrowed AS
SELECT DISTINCT m.member_id, m.member_name, m.city
FROM Members m
JOIN Borrow br ON br.member_id = m.member_id;

-- 38. Display a view's structure
-- MySQL
DESCRIBE Library_Borrow_Details;

-- 39. Recreate the details view with the book category added
CREATE OR REPLACE VIEW Library_Borrow_Details AS
SELECT b.book_name, b.author, b.category,
       m.member_name, m.city, br.borrow_date
FROM Borrow br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id;

-- 40. Drop a view
DROP VIEW Category_Average_Price;
-- 41. Procedure to display all books
DELIMITER //
CREATE PROCEDURE GetAllBooks()
BEGIN
    SELECT * FROM Books;
END //
DELIMITER ;

-- 42. Execute GetAllBooks
CALL GetAllBooks();

-- 43. Procedure to display all members
DELIMITER //
CREATE PROCEDURE GetAllMembers()
BEGIN
    SELECT * FROM Members;
END //
DELIMITER ;

-- 44. Execute GetAllMembers
CALL GetAllMembers();

-- 45. Procedure to find books by category
DELIMITER //
CREATE PROCEDURE GetBooksByCategory(IN p_category VARCHAR(100))
BEGIN
    SELECT *
    FROM Books
    WHERE category = p_category;
END //
DELIMITER ;

-- 46. Execute for the Technology category
CALL GetBooksByCategory('Technology');

-- 47. Procedure to find books by author
DELIMITER //
CREATE PROCEDURE GetBooksByAuthor(IN p_author VARCHAR(255))
BEGIN
    SELECT *
    FROM Books
    WHERE author = p_author;
END //
DELIMITER ;

-- Example:
CALL GetBooksByAuthor('Author Name');

-- 48. Procedure to find books priced above a given amount
DELIMITER //
CREATE PROCEDURE GetBooksAbovePrice(IN p_price DECIMAL(10,2))
BEGIN
    SELECT *
    FROM Books
    WHERE price > p_price;
END //
DELIMITER ;

-- Example:
CALL GetBooksAbovePrice(500);

-- 49. Procedure to display borrow details for a member
DELIMITER //
CREATE PROCEDURE GetMemberBorrowDetails(IN p_member_id INT)
BEGIN
    SELECT b.book_name, b.author, br.borrow_date
    FROM Borrow br
    JOIN Books b ON br.book_id = b.book_id
    WHERE br.member_id = p_member_id;
END //
DELIMITER ;

-- Example:
CALL GetMemberBorrowDetails(1);

-- 50. Procedure to find books in a category below a price limit
DELIMITER //
CREATE PROCEDURE GetCategoryBooks(
    IN p_category VARCHAR(100),
    IN p_price_limit DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM Books
    WHERE category = p_category
      AND price < p_price_limit;
END //
DELIMITER ;

-- Example:
CALL GetCategoryBooks('Technology', 700);
-- 1. Members who borrowed books priced above the overall average
SELECT DISTINCT m.member_name
FROM Members m
JOIN Borrow br ON br.member_id = m.member_id
JOIN Books b ON b.book_id = br.book_id
WHERE b.price > (SELECT AVG(price) FROM Books);

-- 2. Most expensive book in each category, including ties
SELECT b.category, b.book_name, b.author, b.price
FROM Books b
JOIN (
    SELECT category, MAX(price) AS max_price
    FROM Books
    GROUP BY category
) x ON x.category = b.category AND x.max_price = b.price;

-- 3. Categories whose average price is above the overall average
SELECT category, AVG(price) AS category_average
FROM Books
GROUP BY category
HAVING AVG(price) > (SELECT AVG(price) FROM Books);

-- 4. Members who have borrowed more than one book
SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
JOIN Borrow br ON br.member_id = m.member_id
GROUP BY m.member_id, m.member_name
HAVING COUNT(br.borrow_id) > 1;

-- 5. Never-borrowed books priced above ₹500
SELECT b.*
FROM Books b
WHERE b.price > 500
  AND NOT EXISTS (
      SELECT 1
      FROM Borrow br
      WHERE br.book_id = b.book_id
  );

-- 6. Three most expensive books
SELECT book_id, book_name, category, price
FROM (
    SELECT b.*,
           ROW_NUMBER() OVER (ORDER BY price DESC, book_id) AS rn
    FROM Books b
) ranked
WHERE rn <= 3;

-- 7. Book count, average price, and total stock by category
SELECT category,
       COUNT(*) AS total_books,
       AVG(price) AS average_price,
       SUM(stock_quantity) AS total_stock
FROM Books
GROUP BY category;

-- 8. Each book with its category average and difference
SELECT book_name, category, price,
       AVG(price) OVER (PARTITION BY category) AS category_average,
       price - AVG(price) OVER (PARTITION BY category) AS difference_from_average
FROM Books;

-- 9. Each member and their borrowed-book count, including zero
SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
LEFT JOIN Borrow br ON br.member_id = m.member_id
GROUP BY m.member_id, m.member_name;

-- 10. Members with more borrow records than the average per member
WITH MemberCounts AS (
    SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
    FROM Members m
    LEFT JOIN Borrow br ON br.member_id = m.member_id
    GROUP BY m.member_id, m.member_name
)
SELECT member_id, member_name, books_borrowed
FROM MemberCounts
WHERE books_borrowed > (SELECT AVG(books_borrowed) FROM MemberCounts);

-- 11. Highest-priced borrowed book for each member, including ties
WITH MemberBookPrices AS (
    SELECT m.member_id, m.member_name, b.book_name, b.price,
           RANK() OVER (
               PARTITION BY m.member_id
               ORDER BY b.price DESC
           ) AS price_rank
    FROM Members m
    JOIN Borrow br ON br.member_id = m.member_id
    JOIN Books b ON b.book_id = br.book_id
)
SELECT member_id, member_name, book_name, price
FROM MemberBookPrices
WHERE price_rank = 1;

-- 12. Categories with at least 2 books and average price above ₹500
SELECT category, COUNT(*) AS total_books, AVG(price) AS average_price
FROM Books
GROUP BY category
HAVING COUNT(*) >= 2 AND AVG(price) > 500;

-- 13. Two most expensive books per category, including ties
WITH RankedBooks AS (
    SELECT b.*,
           DENSE_RANK() OVER (
               PARTITION BY category
               ORDER BY price DESC
           ) AS price_rank
    FROM Books b
)
SELECT book_id, book_name, category, price
FROM RankedBooks
WHERE price_rank <= 2;

-- 14. Books above their category average with stock greater than 5
SELECT book_id, book_name, category, price, stock_quantity
FROM (
    SELECT b.*,
           AVG(price) OVER (PARTITION BY category) AS category_average
    FROM Books b
) x
WHERE price > category_average
  AND stock_quantity > 5;

-- 15. View with each book's borrow-record count
CREATE VIEW Book_Borrow_Counts AS
SELECT b.book_id, b.book_name, b.category, b.price, b.stock_quantity,
       COUNT(br.borrow_id) AS borrow_count
FROM Books b
LEFT JOIN Borrow br ON br.book_id = b.book_id
GROUP BY b.book_id, b.book_name, b.category, b.price, b.stock_quantity;

-- To display the view:
SELECT book_name, category, price, stock_quantity, borrow_count
FROM Book_Borrow_Counts;

-- 16. Procedure: books in a category, highest price first
DELIMITER //
CREATE PROCEDURE GetCategoryBooksByPrice(IN p_category VARCHAR(100))
BEGIN
    SELECT *
    FROM Books
    WHERE category = p_category
    ORDER BY price DESC;
END //
DELIMITER ;

-- Example:
CALL GetCategoryBooksByPrice('Technology');

-- 17. Procedure: books within a price range, inclusive
DELIMITER //
CREATE PROCEDURE GetBooksByPriceRange(
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM Books
    WHERE price BETWEEN p_min_price AND p_max_price
    ORDER BY price;
END //
DELIMITER ;

-- Example:
CALL GetBooksByPriceRange(300, 800);

-- 18. Categories with more than 2 borrowed-book records
WITH CategoryBorrowCounts AS (
    SELECT b.category, COUNT(br.borrow_id) AS borrowed_count
    FROM Books b
    JOIN Borrow br ON br.book_id = b.book_id
    GROUP BY b.category
)
SELECT category, borrowed_count
FROM CategoryBorrowCounts
WHERE borrowed_count > 2;

-- 19. Count books by price band
SELECT
    CASE
        WHEN price < 400 THEN 'Low'
        WHEN price <= 700 THEN 'Medium'
        ELSE 'High'
    END AS price_range,
    COUNT(*) AS book_count
FROM Books
GROUP BY
    CASE
        WHEN price < 400 THEN 'Low'
        WHEN price <= 700 THEN 'Medium'
        ELSE 'High'
    END;

-- 20. Top-ranked book(s) in each category; ties are included
WITH RankedBooks AS (
    SELECT b.*,
           RANK() OVER (
               PARTITION BY category
               ORDER BY price DESC
           ) AS price_rank
    FROM Books b
)
SELECT book_id, book_name, category, price
FROM RankedBooks
WHERE price_rank = 1;
-- 1. Members who borrowed books priced above the overall average
SELECT DISTINCT m.member_name
FROM Members m
JOIN Borrow br ON br.member_id = m.member_id
JOIN Books b ON b.book_id = br.book_id
WHERE b.price > (SELECT AVG(price) FROM Books);

-- 2. Most expensive book in each category, including ties
SELECT b.category, b.book_name, b.author, b.price
FROM Books b
JOIN (
    SELECT category, MAX(price) AS max_price
    FROM Books
    GROUP BY category
) x ON x.category = b.category AND x.max_price = b.price;

-- 3. Categories whose average price is above the overall average
SELECT category, AVG(price) AS category_average
FROM Books
GROUP BY category
HAVING AVG(price) > (SELECT AVG(price) FROM Books);

-- 4. Members who have borrowed more than one book
SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
JOIN Borrow br ON br.member_id = m.member_id
GROUP BY m.member_id, m.member_name
HAVING COUNT(br.borrow_id) > 1;

-- 5. Never-borrowed books priced above ₹500
SELECT b.*
FROM Books b
WHERE b.price > 500
  AND NOT EXISTS (
      SELECT 1
      FROM Borrow br
      WHERE br.book_id = b.book_id
  );

-- 6. Three most expensive books
SELECT book_id, book_name, category, price
FROM (
    SELECT b.*,
           ROW_NUMBER() OVER (ORDER BY price DESC, book_id) AS rn
    FROM Books b
) ranked
WHERE rn <= 3;

-- 7. Book count, average price, and total stock by category
SELECT category,
       COUNT(*) AS total_books,
       AVG(price) AS average_price,
       SUM(stock_quantity) AS total_stock
FROM Books
GROUP BY category;

-- 8. Each book with its category average and difference
SELECT book_name, category, price,
       AVG(price) OVER (PARTITION BY category) AS category_average,
       price - AVG(price) OVER (PARTITION BY category) AS difference_from_average
FROM Books;

-- 9. Each member and their borrowed-book count, including zero
SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
FROM Members m
LEFT JOIN Borrow br ON br.member_id = m.member_id
GROUP BY m.member_id, m.member_name;

-- 10. Members with more borrow records than the average per member
WITH MemberCounts AS (
    SELECT m.member_id, m.member_name, COUNT(br.borrow_id) AS books_borrowed
    FROM Members m
    LEFT JOIN Borrow br ON br.member_id = m.member_id
    GROUP BY m.member_id, m.member_name
)
SELECT member_id, member_name, books_borrowed
FROM MemberCounts
WHERE books_borrowed > (SELECT AVG(books_borrowed) FROM MemberCounts);

-- 11. Highest-priced borrowed book for each member, including ties
WITH MemberBookPrices AS (
    SELECT m.member_id, m.member_name, b.book_name, b.price,
           RANK() OVER (
               PARTITION BY m.member_id
               ORDER BY b.price DESC
           ) AS price_rank
    FROM Members m
    JOIN Borrow br ON br.member_id = m.member_id
    JOIN Books b ON b.book_id = br.book_id
)
SELECT member_id, member_name, book_name, price
FROM MemberBookPrices
WHERE price_rank = 1;

-- 12. Categories with at least 2 books and average price above ₹500
SELECT category, COUNT(*) AS total_books, AVG(price) AS average_price
FROM Books
GROUP BY category
HAVING COUNT(*) >= 2 AND AVG(price) > 500;

-- 13. Two most expensive books per category, including ties
WITH RankedBooks AS (
    SELECT b.*,
           DENSE_RANK() OVER (
               PARTITION BY category
               ORDER BY price DESC
           ) AS price_rank
    FROM Books b
)
SELECT book_id, book_name, category, price
FROM RankedBooks
WHERE price_rank <= 2;

-- 14. Books above their category average with stock greater than 5
SELECT book_id, book_name, category, price, stock_quantity
FROM (
    SELECT b.*,
           AVG(price) OVER (PARTITION BY category) AS category_average
    FROM Books b
) x
WHERE price > category_average
  AND stock_quantity > 5;

-- 15. View with each book's borrow-record count
CREATE VIEW Book_Borrow_Counts AS
SELECT b.book_id, b.book_name, b.category, b.price, b.stock_quantity,
       COUNT(br.borrow_id) AS borrow_count
FROM Books b
LEFT JOIN Borrow br ON br.book_id = b.book_id
GROUP BY b.book_id, b.book_name, b.category, b.price, b.stock_quantity;

-- To display the view:
SELECT book_name, category, price, stock_quantity, borrow_count
FROM Book_Borrow_Counts;

-- 16. Procedure: books in a category, highest price first
DELIMITER //
CREATE PROCEDURE GetCategoryBooksByPrice(IN p_category VARCHAR(100))
BEGIN
    SELECT *
    FROM Books
    WHERE category = p_category
    ORDER BY price DESC;
END //
DELIMITER ;

-- Example:
CALL GetCategoryBooksByPrice('Technology');

-- 17. Procedure: books within a price range, inclusive
DELIMITER //
CREATE PROCEDURE GetBooksByPriceRange(
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2)
)
BEGIN
    SELECT *
    FROM Books
    WHERE price BETWEEN p_min_price AND p_max_price
    ORDER BY price;
END //
DELIMITER ;

-- Example:
CALL GetBooksByPriceRange(300, 800);

-- 18. Categories with more than 2 borrowed-book records
WITH CategoryBorrowCounts AS (
    SELECT b.category, COUNT(br.borrow_id) AS borrowed_count
    FROM Books b
    JOIN Borrow br ON br.book_id = b.book_id
    GROUP BY b.category
)
SELECT category, borrowed_count
FROM CategoryBorrowCounts
WHERE borrowed_count > 2;

-- 19. Count books by price band
SELECT
    CASE
        WHEN price < 400 THEN 'Low'
        WHEN price <= 700 THEN 'Medium'
        ELSE 'High'
    END AS price_range,
    COUNT(*) AS book_count
FROM Books
GROUP BY
    CASE
        WHEN price < 400 THEN 'Low'
        WHEN price <= 700 THEN 'Medium'
        ELSE 'High'
    END;

-- 20. Top-ranked book(s) in each category; ties are included
WITH RankedBooks AS (
    SELECT b.*,
           RANK() OVER (
               PARTITION BY category
               ORDER BY price DESC
           ) AS price_rank
    FROM Books b
)
SELECT book_id, book_name, category, price
FROM RankedBooks
WHERE price_rank = 1;