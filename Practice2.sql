-- table : Book/ Customer/ Orders/ Imported_Book
select * from book;
select * from customer;
select * from orders;
select * from imported_book;

-- 20. 고객과 고객의 주문에 관한 데이터를 모두 보이시오.
SELECT 
    *
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid;

-- 21. 고객과 고객의 주문에 관한 데이터를 고객번호 순으로 정렬하여 보이시오.
SELECT 
    *
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid
ORDER BY c.custid;

-- 22. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오. book.bookid, orders.bookid / orders.custid, customer.custid
SELECT 
    c.name, b.bookname, b.price
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid
        INNER JOIN
    book b ON b.bookid = o.bookid;

-- 23. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오. orders, book/ order by 사용/ group by 사용 총판매액 / custid, total_price/ orders.bookid, book.bookid/ orders.custid, customer.custid
SELECT 
    c.custid, c.name, SUM(b.price)
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid
        INNER JOIN
    book b ON o.bookid = b.bookid
GROUP BY c.custid
ORDER BY c.custid;
-- ---------------------------------------
SELECT 
    c.custid, c.name, SUM(b.price)
FROM
    customer c,
    orders o,
    book b
WHERE
    c.custid = o.custid
GROUP BY c.custid
ORDER BY c.custid;

-- 24. 고객의 이름과 고객이 주문한 도서의 이름을 구하시오. customer.name, book.bookname/ orders.custid, customer.custid / book.bookid, orders.bookid
SELECT 
    c.name, b.bookname
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid
        INNER JOIN
    book b ON b.bookid = o.bookid
ORDER BY c.name;
-- ----------------------------------------------
SELECT 
    c.name, b.bookname
FROM
    customer c,
    orders o,
    book b
WHERE
    c.custid = o.custid
        AND o.bookid = b.bookid
ORDER BY c.name;

-- 25. 가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오. customer.name, book.bookname/ orders.custid, customer.custid / book.bookid, orders.bookid/ where 사용.
SELECT 
    c.name, b.bookname
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid
        INNER JOIN
    book b ON b.bookid = o.bookid
WHERE
    b.price = 20000;

-- 26. 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하시오. customer.name, book.bookname, book.price/
SELECT 
    c.name, b.bookname, b.price
FROM
    customer c
        LEFT OUTER JOIN
    orders o ON c.custid = o.custid
        LEFT OUTER JOIN
    book b ON o.bookid = b.bookid;

-- 27. 가장 비싼 도서의 이름을 보이시오. limit
SELECT 
    b.bookname, b.price
FROM
    book b
ORDER BY price DESC
LIMIT 1;

-- 28. 도서를 구매한 적이 있는 고객의 이름을 검색하시오. orders에 custid가 있는 사람. 중복제외 distinct
SELECT DISTINCT
    c.name
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid;

-- 29. 대한미디어에서 출판한 도서를 구매한 고객의 이름을 보이시오.
SELECT DISTINCT
    c.name
FROM
    customer c
        JOIN
    Orders o ON c.custid = o.custid
        JOIN
    book b ON b.bookid = o.bookid
WHERE
    b.publisher LIKE '대한미디어';
    
    -- ----------------------------
SELECT  C.name
FROM Customer C
JOIN
(
	SELECT  O.custid
	FROM Book B
	JOIN
	(
		SELECT  DISTINCT custid
		       ,bookid
		FROM Orders
	) O
	ON B.bookid = O.bookid
	WHERE B.publisher = '대한미디어' 
) O
ON C.custid = O.custid;



-- 30. 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오.
SELECT  B.publisher	'출판사'
       ,R.avg_price	'출판사 도서별 평균 가격'
       ,B.bookname	'출판사 도서별 평균 가격보다 비싼 도서'
       ,B.price	'도서의 가격'
FROM Book B
JOIN (
	SELECT  publisher
	       ,ROUND(AVG(price))'avg_price'
	FROM Book
	GROUP BY  publisher
) R
ON B.publisher = R.publisher
WHERE B.price > R.avg_price;
-- ---------------------------------------------------------------
WITH avgprice(publisher, avg)
	AS (
		SELECT publisher, ROUND(AVG(price)) FROM book GROUP BY publisher
    )
    SELECT B.bookname FROM book B
		INNER JOIN avgprice AP ON B.publisher = AP.publisher
    WHERE B.price > AP.avg;

-- 31. 주문이 있는 고객의 이름과 주소를 보이시오. c.name, c.address / customer, orders
SELECT DISTINCT
    c.name, c.address
FROM
    customer c
        INNER JOIN
    orders o ON c.custid = o.custid;
    
    -- ---------------------------
SELECT  name
       ,address
FROM Customer
WHERE custid IN ( SELECT DISTINCT custid FROM Orders );