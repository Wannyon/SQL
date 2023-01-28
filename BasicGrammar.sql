USE employees;	-- 사용할 데이터베이스 지정

select * from employees;	-- 데이터 조회 (*은 모든 것)
select emp_no as 직원번호, birth_date as "생년월일", first_name as '이 름', last_name as "성" from employees;
-- as : 별칭, 별칭 사용시에는 ""를 사용하는 것을 권장, 별칭에 띄어쓰기가 있을 경우 필수로 ""사용해야함.

desc employees;	 -- describe : desc 데이터 구조 출력

show databases;	-- 현재 사용자가 접근 가능한 데이터베이스 조회
use mysql;
show tables;	-- 선택된 테이블 목록 조회
show table status;	-- 테이블 목록과 상태 조회
select * from user;	-- 사용자 권한 조회
select * from db;	-- 관리자 권한 조회

drop database if exists dqldb;	-- 데이터베이스 삭제
create database sqldb;	-- 데이터베이스 생성

use sqldb;
create table usertbl (	-- 회원 테이블
	userID		char(8) not null primary key,	-- 사용자 아이디(PK)
    name		varchar(10) not null,			-- 이름
    birthYear 	int not null,					-- 출생년도
    addr		char(2) not null,				-- 지역(서울, 경남 등등 2글자로 제한)
    mobile1		char(3),						-- 휴대번호의 국번(010)
    mobile2		char(8),						-- 휴대번호의 나머지 번호(하이폰 제외)
    height		smallint,						-- 키
    mDate		date							-- 회원 가입일
);
describe usertbl;

create table buytbl (	-- 회원 구매 테이블
	num			int not null auto_increment  primary key,	-- 순번(PK), AUTO_INCREMENT(AI)
    userID 		char(8) not null,							-- 아이디(FK)
    prodName	char(6) not null,							-- 물품명
    groupName	char(4),									-- 분류
    price		int not null,								-- 단가
    amount		smallint not null,							-- 수량
    foreign key (userID) references usertbl(userID)
);
desc buytbl;

insert into usertbl(userID, name, birthYear, addr, mobile1, mobile2, height, mDate)			-- 원래 형식
values('LSG', '이승기', 1987, '서울', '011', '111111', 182, '2008-8-8');
insert into usertbl values('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');	-- 초기치와 똑같은 형식으로 작성시에는 필드를 생략 가능하다.
insert into usertbl values('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
insert into usertbl values('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
insert into usertbl values('SSK', '성시경', 1979, '서울', NULL, NULL, 186, '2013-12-12');
insert into usertbl values('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
insert into usertbl values('YJS', '윤종신', 1969, '경남', NULL, NULL, 170, '2005-5-5');
insert into usertbl values('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
insert into usertbl values('JKW', '조관우', 1965, '경기', '018', '9999999', 176, '2013-5-5');
insert into usertbl values('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
insert into buytbl values(NULL, 'KBS', '운동화', NULL, 30, 2);		-- buytbl의 num 열은 자동으로 증가하기 때문에 null 입력
insert into buytbl values(NULL, 'KBS', '노트북', '전자', 1000, 1);
insert into buytbl values(NULL, 'JYP', '모니터', '전자', 200, 1);
insert into buytbl values(NULL, 'BBK', '모니터', '전자', 200, 5);
insert into buytbl values(NULL, 'KBS', '청바지', '의류', 50, 3);
insert into buytbl values(NULL, 'BBK', '메모리', '전자', 80, 10);
insert into buytbl values(NULL, 'SSK', '책', '서적', 15, 5);
insert into buytbl values(NULL, 'EJW', '책', '서적', 15, 2);
insert into buytbl values(NULL, 'EJW', '청바지', '의류', 50, 1);
insert into buytbl values(NULL, 'BBK', '운동화', NULL, 30, 2);
insert into buytbl values(NULL, 'EJW', '책', '서적', 15, 1);
insert into buytbl values(NULL, 'BBK', '운동화', NULL, 30, 2);

select * from usertbl;
select * from buytbl;

select * from usertbl where name != '김경호';		-- select 필드 form 테이블명 where 필드명 = 데이터
select userID, Name from usertbl where birthYear >= 1970 and height >= 182;
select userID, Name from usertbl where birthYear >= 1970 or height >= 182;

select name, height from usertbl where height >= 180 and height <= 183;
select name, height from usertbl where height between 180 and 183;		-- 연속적인 값일 때 범위를 between으로 표현.

select name, addr from usertbl where addr='경남' or addr='전남' or addr='경북';
select name, addr from usertbl where addr in ('경남', '경북', '전남');		-- 이산적인 값 조회를 위해 in() 사용.

select name, height from usertbl where name like '김%';		-- like : 문자열의 내용을 검색
select name, height from usertbl where name like '_종신';	-- _ : 임의의 한문자,  % : 0개 이상의 문자를 의미
select name, height from usertbl where name like '%기%';
select name, height from usertbl where name like '김%' escape '%';	-- escape 뒤에 있는 문자는 like 뒤에 쓰인 문자를 문자열로 본다. 또는 '김\%'

select name, height from usertbl 
where height > (select height from usertbl where Name = '김경호');

select name, height from usertbl where addr = '경남';
select name, height from usertbl 
	where height >= (select height from usertbl where addr = '경남');		-- 서브쿼리의 결과가 둘 이상이라 에러가 발생한다.
select name, height, addr from usertbl 
	where height >= any (select height from usertbl where addr = '경남');	-- any는 서브쿼리의 여러 개의 결과 중 한 가지만 만족해도 된다. (170~173, 170 이상) = some
select name, height, addr from usertbl 
	where height >= (select min(height) from usertbl where addr = '경남');	-- (부등호 주의) any 대신 min으로 대체가능 
    
select name, height, addr from usertbl 
	where height <= any (select height from usertbl where addr = '경남');
select name, height, addr from usertbl 
	where height <= (select max(height) from usertbl where addr = '경남');	-- (부등호 주의) any 대신 max으로 대체가능
 
 select name, height, addr from usertbl 
	where height = any (select height from usertbl where addr = '경남');
select name, height, addr from usertbl 
	where height in (select height from usertbl where addr = '경남');		-- =any는 in으로 바꿀 수 있다.

select name, height, addr from usertbl 
	where height >= all (select height from usertbl where addr = '경남');	-- all은 서브쿼리의 여러 개의 결과를 모두 만족시켜야 한다. (170~173, 173 이상)
select name, height, addr from usertbl 
	where height >= (select max(height) from usertbl where addr = '경남');
    
select name, height from usertbl order by height desc, name asc;	-- asc는 디폴트값 생략가능.
select name, mdate from usertbl order by mdate desc, name asc;		-- mdate를 내림차순으로 정렬 후 같은 날짜가 있을 때 같은 데이터에서 name을 오름차순으로 정렬;
select name, mdate from usertbl order by mdate asc, name asc;

