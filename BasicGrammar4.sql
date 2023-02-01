-- 데이터베이스 제거 --
DROP DATABASE IF EXISTS ShopDB;		-- 데이터베이스가 존재한다면! 삭제
DROP DATABASE IF EXISTS ModelDB;
DROP DATABASE IF EXISTS sqlDB;
DROP DATABASE IF EXISTS tableDB;

drop table if exists usertbl;
drop table if exists buytbl;


-- 데이터베이스 생성 --
create database tabledb;

-- (실습 1)
use tabledb;

CREATE TABLE userTbl -- 회원 테이블
( userID  char(8) not null, -- 사용자 아이디
  name    nvarchar(10) not null, -- 이름
  birthYear   int not null,  -- 출생년도
  addr	  nchar(2) not null, -- 지역(경기,서울,경남 등으로 글자만 입력)
  mobile1	char(3), -- 휴대폰의국번(011, 016, 017, 018, 019, 010 등)
  mobile2   char(8), -- 휴대폰의 나머지 전화번호(하이픈 제외)
  height    smallint,  -- 키
  mDate    date,  -- 회원 가입일
  constraint primary key pk_usertbl_userid (userid)
  );
CREATE TABLE buyTbl -- 구매 테이블
(  num int not null primary key auto_increment, -- 순번(PK)
   userid		char(8) not null,-- 아이디(FK)
   prodName		nchar(6) not null, -- 물품명
   groupName	nchar(4) , -- 분류
   price		int not null, -- 단가
   amount		smallint not null, -- 수량
   constraint foreign key(userid) references usertbl(userid)
);

-- 스키마(DB)의 구조 정보 --
SELECT 
    *
FROM
    information_schema.table_constraints		-- 스키마(DB)의 구조 정보.
WHERE
    table_schema = 'tabledb';

-- 데이터 입력 --
INSERT INTO userTbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
insert into usertbl values('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');

INSERT INTO buyTbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buyTbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buyTbl VALUES(NULL, 'JYP', '모니터', '전자', 200, 1);

drop table if exists buytbl; -- 제약조건 생각해서 순서대로 삭제.
drop table if exists usertbl;


-- (실습2) alter를 이용한 테이블 수정
CREATE TABLE userTbl 
( userID  char(8) NOT NULL PRIMARY KEY,  
  name    nvarchar(10) NOT NULL, 
  birthYear   int NOT NULL,  
  addr	  char(2) NOT NULL,
  mobile1	char(3) NULL, 
  mobile2   char(8) NULL, 
  height    smallint NULL, 
  mDate    date NULL
 );
CREATE TABLE buyTbl 
(  num int AUTO_INCREMENT NOT NULL PRIMARY KEY,
   userid  char(8) NOT NULL,
   prodName char(6) NOT NULL,
   groupName char(4) NULL , 
   price     int  NOT NULL,
   amount    smallint  NOT NULL 
);
ALTER TABLE buyTbl
    ADD CONSTRAINT FK_userTbl_buyTbl 
    FOREIGN KEY (userid) 
    REFERENCES userTbl(userID);

ALTER TABLE buyTbl
	DROP FOREIGN KEY FK_userTbl_buyTbl; -- 외래 키 제거
    
ALTER TABLE buyTbl
	ADD CONSTRAINT FK_userTbl_buyTbl
	FOREIGN KEY (userID)
	REFERENCES userTbl (userID)
	ON UPDATE CASCADE;
    
show keys from usertbl;
show keys from buytbl;


DROP TABLE IF EXISTS prodTbl;
CREATE TABLE prodTbl
( prodCode CHAR(3) NOT NULL,
  prodID   CHAR(4)  NOT NULL,
  prodDate DATETIME  NOT NULL,
  prodCur  CHAR(10) NULL
);
ALTER TABLE prodTbl								-- 인덱스로 제약조건을 만들어주는게 검색 효율이 좋다.
	ADD CONSTRAINT PK_prodTbl_proCode_prodID 
	PRIMARY KEY (prodCode, prodID) ;

DROP TABLE IF EXISTS prodTbl;
CREATE TABLE prodTbl
( prodCode CHAR(3) NOT NULL,
  prodID   CHAR(4)  NOT NULL,
  prodDate DATETIME  NOT NULL,
  prodCur  CHAR(10) NULL,
  CONSTRAINT PK_prodTbl_proCode_prodID 
	PRIMARY KEY (prodCode, prodID) 
);

-- (실습3) on <delete or update> cascade
DROP TABLE IF EXISTS buyTbl, userTbl ;
CREATE TABLE userTbl 
( userID  char(8) NOT NULL PRIMARY KEY,  
  name    nvarchar(10) NOT NULL, 
  birthYear   int NOT NULL,  
  addr	  char(2) NOT NULL,
  mobile1	char(3) NULL, 
  mobile2   char(8) NULL, 
  height    smallint NULL, 
  mDate    date NULL
 );
CREATE TABLE buyTbl 
(  num int AUTO_INCREMENT NOT NULL PRIMARY KEY,
   userid  char(8) NOT NULL,
   prodName char(6) NOT NULL,
   groupName char(4) NULL , 
   price     int  NOT NULL,
   amount    smallint  NOT NULL 
);
ALTER TABLE buyTbl
    ADD CONSTRAINT FK_userTbl_buyTbl 
    FOREIGN KEY (userid) 
    REFERENCES userTbl(userID);

ALTER TABLE buyTbl
	DROP FOREIGN KEY FK_userTbl_buyTbl; -- 외래 키 제거
    
ALTER TABLE buyTbl
	ADD CONSTRAINT FK_userTbl_buyTbl
	FOREIGN KEY (userID)
	REFERENCES userTbl (userID)
	ON delete CASCADE;					-- 제약관계로 연결된 테이블 연동해서 데이터 수정 delete, update
    
INSERT INTO userTbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
insert into usertbl values('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');

INSERT INTO buyTbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buyTbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buyTbl VALUES(NULL, 'JYP', '모니터', '전자', 200, 1);

select * from usertbl, buytbl;

delete from usertbl where userid = 'JYP';

SELECT * 
FROM information_schema.table_constraints		-- 스키마(DB)의 구조 정보.
WHERE table_schema = 'tabledb';


-- (실습4) unique : '중복되지 않는 유일한 값'
drop table if exists buytbl, prodtbl, usertbl;
CREATE TABLE userTbl 
( userID  char(8) NOT NULL PRIMARY KEY,
  name    nvarchar(10) NOT NULL, 
  birthYear   int NOT NULL,  
  addr	  char(2) NOT NULL,
  mobile1	char(3) NULL, 
  mobile2   char(8) NULL, 
  height    smallint NULL, 
  mDate    date NULL,
  email   char(30) NULL  UNIQUE
);

CREATE TABLE userTbl 
( userID  char(8) NOT NULL PRIMARY KEY,
  name    nvarchar(10) NOT NULL, 
  birthYear   int NOT NULL,  
  addr	  char(2) NOT NULL,
  mobile1	char(3) NULL, 
  mobile2   char(8) NULL, 
  height    smallint NULL, 
  mDate    date NULL,
  email   char(30) NULL ,  
  CONSTRAINT AK_email  UNIQUE (email)	-- UK_email
);

show keys from usertbl;


-- check 제약조건 : 입력되는 데이터를 점검하는 기능 --
ALTER TABLE userTbl
	ADD CONSTRAINT CK_birthYear
	CHECK  (birthYear >= 1900 AND birthYear <= YEAR(CURDATE())) ;


-- default : 값을 입력하지 않았을 때, 자동으로 입력되는 기본 값. --
CREATE DATABASE IF NOT EXISTS testDB;
use testDB;
DROP TABLE IF EXISTS userTbl;
CREATE TABLE userTbl 
( userID  	char(8) NOT NULL PRIMARY KEY,  
  name    	varchar(10) NOT NULL, 
  birthYear	int NOT NULL DEFAULT -1,
  addr	  	char(2) NOT NULL DEFAULT '서울',
  mobile1	char(3) NULL, 
  mobile2	char(8) NULL, 
  height	smallint NULL DEFAULT 170, 
  mDate    	date NULL
);

use testDB;
DROP TABLE IF EXISTS userTbl;
CREATE TABLE userTbl 
( userID	char(8) NOT NULL PRIMARY KEY,  
  name		varchar(10) NOT NULL, 
  birthYear	int NOT NULL ,
  addr		char(2) NOT NULL,
  mobile1	char(3) NULL, 
  mobile2	char(8) NULL, 
  height	smallint NULL, 
  mDate	date NULL 
);
ALTER TABLE userTbl
	ALTER COLUMN birthYear SET DEFAULT -1;
ALTER TABLE userTbl
	ALTER COLUMN addr SET DEFAULT '서울';
ALTER TABLE userTbl
	ALTER COLUMN height SET DEFAULT 170;

-- default 문은 DEFAULT로 설정된 값을 자동 입력한다.
INSERT INTO userTbl VALUES ('LHL', '이혜리', default, default, '011', '1234567', default, '2019.12.12');
-- 열이름이 명시되지 않으면 DEFAULT로 설정된 값을 자동 입력한다
INSERT INTO userTbl(userID, name) VALUES('KAY', '김아영');
-- 값이 직접 명기되면 DEFAULT로 설정된 값은 무시된다.
INSERT INTO userTbl VALUES ('WB', '원빈', 1982, '대전', '019', '9876543', 176, '2017.5.5');
SELECT * FROM userTbl;



-- 실습5 view --
USE tableDB;
CREATE VIEW v_userTbl
AS
	SELECT userid, name, addr FROM userTbl;

SELECT * FROM v_userTbl;  -- 뷰를 테이블이라고 생각해도 무방

SELECT U.userid, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
FROM userTbl U
  INNER JOIN buyTbl B
     ON U.userid = B.userid ;

CREATE VIEW v_userbuyTbl
AS
SELECT U.userid, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
FROM userTbl U
	INNER JOIN buyTbl B
	 ON U.userid = B.userid ;

SELECT * FROM v_userbuyTbl WHERE name = '김범수';


-- 실습6 --
use tabledb;

CREATE TABLE userTbl -- 회원 테이블
( userID  char(8) not null, -- 사용자 아이디
  name    nvarchar(10) not null, -- 이름
  birthYear   int not null,  -- 출생년도
  addr	  nchar(2) not null, -- 지역(경기,서울,경남 등으로 글자만 입력)
  mobile1	char(3), -- 휴대폰의국번(011, 016, 017, 018, 019, 010 등)
  mobile2   char(8), -- 휴대폰의 나머지 전화번호(하이픈 제외)
  height    smallint,  -- 키
  mDate    date,  -- 회원 가입일
  constraint primary key pk_usertbl_userid (userid)
  );
CREATE TABLE buyTbl -- 구매 테이블
(  num int not null primary key auto_increment, -- 순번(PK)
   userid		char(8) not null,-- 아이디(FK)
   prodName		nchar(6) not null, -- 물품명
   groupName	nchar(4) , -- 분류
   price		int not null, -- 단가
   amount		smallint not null, -- 수량
   constraint foreign key(userid) references usertbl(userid)
);

-- 데이터 입력 --
INSERT INTO userTbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
insert into usertbl values('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');

INSERT INTO buyTbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buyTbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buyTbl VALUES(NULL, 'JYP', '모니터', '전자', 200, 1);

CREATE VIEW v_userbuyTbl
AS
   SELECT U.userid AS 'USER ID', U.name AS 'USER NAME', B.prodName AS 'PRODUCT NAME', 
		U.addr, CONCAT(U.mobile1, U.mobile2) AS 'MOBILE PHONE'
      FROM userTbl U
	INNER JOIN buyTbl B
	 ON U.userid = B.userid;
     
show create view v_userbuytbl;
select * from v_userbuytbl;
select * from v_usertbl;

UPDATE v_userTbl SET addr = '부산' WHERE userid='JKW' ;

INSERT INTO v_userTbl VALUES('KBM','김병만','충북', '011', '4444444', 166, '2009-4-4') ;