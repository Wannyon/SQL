CREATE TABLE Book (
  bookid      INTEGER PRIMARY KEY,
  bookname    VARCHAR(40),
  publisher   VARCHAR(40),
  price       INTEGER 
);

CREATE TABLE  Customer (
  custid      INTEGER PRIMARY KEY,  
  name        VARCHAR(40),
  address     VARCHAR(50),
  phone       VARCHAR(20)
);

CREATE TABLE Orders (
  orderid INTEGER PRIMARY KEY,
  custid  INTEGER ,
  bookid  INTEGER ,
  saleprice INTEGER ,
  orderdate DATE,
  FOREIGN KEY (custid) REFERENCES Customer(custid),
  FOREIGN KEY (bookid) REFERENCES Book(bookid)
);

CREATE TABLE Imported_Book (
  bookid      INTEGER,
  bookname    VARCHAR(40),
  publisher   VARCHAR(40),
  price       INTEGER 
);


INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');  
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, STR_TO_DATE('2014-07-01','%Y-%m-%d')); 
INSERT INTO Orders VALUES (2, 1, 3, 21000, STR_TO_DATE('2014-07-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, STR_TO_DATE('2014-07-03','%Y-%m-%d')); 
INSERT INTO Orders VALUES (4, 3, 6, 6000, STR_TO_DATE('2014-07-04','%Y-%m-%d')); 
INSERT INTO Orders VALUES (5, 4, 7, 20000, STR_TO_DATE('2014-07-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, STR_TO_DATE('2014-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, STR_TO_DATE( '2014-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, STR_TO_DATE('2014-07-08','%Y-%m-%d')); 
INSERT INTO Orders VALUES (9, 2, 10, 7000, STR_TO_DATE('2014-07-09','%Y-%m-%d')); 
INSERT INTO Orders VALUES (10, 3, 8, 13000, STR_TO_DATE('2014-07-10','%Y-%m-%d'));

INSERT INTO Imported_Book VALUES(21, 'Zen Golf', 'Pearson', 12000);
INSERT INTO Imported_Book VALUES(22, 'Soccer Skills', 'Human Kinetics', 15000);


select * from book;
select * from orders;
select * from customer;
select * from Imported_Book;

commit;

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- 1. 모든 도서의 이름과 가격을 검색하시오.
select bookname as '도서 이름', price as '가격' from book;

-- 2. 모든 도서의 도서번호,  도서이름, 출판사, 가격을 검색하시오.
select * from book;

-- 3. 도서 테이블에 있는 모든 출판사를 검색하시오.(중복을 제거)
select distinct publisher from book;

-- 4. 가격이 20,000원 미만인 도서를 검색하시오.
select bookname, price from book where price < 20000 order by price;

-- 5. 가격이 10,000원 이상 20,000 이하인 도서를 검색하시오. *
select bookname, price from book where price between 10000 and 20000 order by price;
select bookname, price from book where price >= any (select price from book where price <= 20000);	-- 서브쿼리로 해보기

-- 6. 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’인 도서를 검색하시오. (in 연산자 사용)
select bookname, publisher from book where publisher in ('굿스포츠', '대한미디어') order by publisher;

-- 7. 도서이름에 ‘축구’가 포함된 출판사를 검색하시오.
select bookname, publisher from book where bookname like '축구%';

-- 8. 도서이름의 왼쪽 두 번째 위치에 ‘구’라는 문자열을 갖는 도서를 검색하시오.
select bookid, bookname from book where bookname like '%구%%';

-- 9. 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하시오. *
select * from book where price >= 20000 and bookname like '%축구%';

-- 10. 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’인 도서를 검색하시오. *
select bookid, bookname, publisher from book where publisher like '굿스포츠' or publisher like '대한미디어' order by publisher;
select bookid, bookname from book where publisher = all (select publisher from book where publisher = '굿스포츠','대한미디어');

-- 11. 도서를 이름순으로 검색하시오.
select * from book order by bookname asc;

-- 12. 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 검색하시오.
select * from book order by price asc, bookname asc;

-- 13. 도서를 가격의 내림차순으로 검색하시오. 만약 가격이 같다면 출판사의 오름차순으로 검색한다.
select * from book order by price desc, publisher asc;

-- 14. 고객이 주문한 도서의 총 판매액을 구하시오.
select custid, sum(saleprice) from orders group by custid;

-- 15. 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오.
select custid, sum(saleprice) from orders where custid = 2 group by custid ;

-- 16. 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하시오.	*
select sum(saleprice), avg(saleprice), min(saleprice), max(saleprice) from orders;

-- 17. 서점의 도서 판매 건수를 구하시오.
select count(orderid) from orders;

-- 18. 고객별로 주문한 도서의 총 수량과 총 판매액을 구하시오.
select custid, count(*), sum(saleprice) from orders group by custid;

SELECT C.name '이름', COUNT(O.orderid) '도서의 총 수량', SUM(O.saleprice) '총 판매액'
FROM Customer C
JOIN Orders O
ON C.custid = O.custid
GROUP BY C.name;

-- 19. 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. (단, 두 권 이상 구매한 고객만 구한다.)
select custid, count(*) from orders where saleprice >= 8000 group by custid having count(*) >= 2;

SELECT C.name '이름', COUNT(O.orderid) '도서의 총 수량', SUM(O.saleprice) '총 판매액'
FROM Customer C
JOIN Orders O
ON C.custid = O.custid
WHERE O.saleprice >= 8000
GROUP BY C.name
HAVING COUNT(O.custid) >= 2;


