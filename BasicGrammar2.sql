-- distinct
use sqldb;
select addr from usertbl order by addr;
select distinct addr from usertbl order by addr;	-- 중복된 것만 남기는 distinct
select name, distinct addr from usertbl order by addr;	-- 이름의 출력값은 중복되는게 없어 생략이 없는데 주소는 생략되어 오류 발생.


-- limit
use employees;
SELECT 
    emp_no, hire_date
FROM
    employees
ORDER BY hire_date ASC
LIMIT 5;					-- limit : 상위 n개의 데이터를 조회.	/	limit 10, 5; : 10번째 위치부터 5개의 데이터 조회. = limit 5 offset 10;


-- create table
use sqldb;
create table buytbl2 (select * from buytbl);	-- 형식 : create table 새로운테이블 ( select 복사할열 from 복사할테이블)
select * from buytbl2;

desc buytbl;
desc buytbl2;									-- 데이터는 복사가 되나 기본키, 외래키와 같은 제약조건은 복사가 되지 않는다.


-- group by
select *from buytbl order by userid;
select userid as '사용자 아이디', sum(amount) as '총구매개수' from buytbl group by userid;	-- group by : 그룹으로 묶어주는 역할.
select userid, sum(price*amount) from buytbl group by userid;							-- 집계 함수 sum()
select userid, avg(amount) from buytbl group by userid;


-- 집계 함수
select avg(amount) from buytbl;							-- 컬럼 지정이 없을때는 테이블 전체로 본다.
select count(name) as '등록된 고객' from usertbl;
select name, max(height), min(height) from usertbl;		-- 오류!! name의 행의 개수는 10, max,min은 1개씩이어서 오류 발생. group by로 해결 가능


-- having 절
-- where 절과 비슷한 개념으로 조건제한에 쓰이는 구문이지만 꼭 group by절 다음에 사용되어야한다.
select userid as '사용자', sum(amount*price) as '총구매액' from buytbl group by userid;
select userid as '사용자', sum(amount*price) as '총구매액' from buytbl where sum(amount*price) > 1000 group by userid;	-- 오류!! 집계함수는 where절로 나타낼 수 없다.

SELECT 
    userid AS '사용자', SUM(amount * price) AS '총구매액'
FROM
    buytbl
GROUP BY userid
HAVING SUM(amount * price) > 1000	-- having 절로 해결 가능. having절의 위치는 반드시 group by 뒤에 위치.
order by SUM(amount * price) asc;


-- rollup
SELECT 
    num, groupName, SUM(amount * price) AS '비용'
FROM
    buytbl
GROUP BY groupName , num WITH ROLLUP;				-- with rollup : 분류별로 함계 및 그 총합을 구할 때 사용.


-- -----------------------------------------------------------------------------------------------------------------------------------
-- insert into
CREATE TABLE testtbl1 (
    id INT,
    userName CHAR(3),
    age INT
);

select * from testtbl1;
insert into testtbl1 values ( 1, '홍길동', 25);
insert into testtbl1(id, username, age) values (2, '이순신', 35);
insert into testtbl1(id, username) values (3, '김유신');
insert into testtbl1(username, age, id) values ('하니', 26, 4);

CREATE TABLE testtbl2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userName CHAR(3),
    age INT
);
desc testtbl2;

insert into testtbl2 values (null, '지민', 25);
insert into testtbl2(username, age) values ('유진', 25);
select * from testtbl2;


-- alter table
alter table testtbl2 auto_increment = 100;			-- alter : 바꾸다, auto_increment = 100 : 100부터 시작.
insert into testtbl2 values (null, '찬미', 23);
insert into testtbl2 values (null, '쿠라', 21);

CREATE TABLE testtbl3 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userName CHAR(3),
    age INT
);
alter table testtbl3 auto_increment = 1000;		-- 1000부터 시작
set @@auto_increment_increment = 3;				-- 3씩 증가, 주의) auto_increment를 사용하는 모든 테이블에 적용된다.

insert into testtbl3 values (null, '나연', 20);
insert into testtbl3 values (null, '정연', 25);
insert into testtbl3 values (null, '모모', 22);
-- insert into testtbl3 values (null, '나연', 20, (null, '정연', 25), (null, '모모', 22); 	한문장으로 위의 3문장을 표현 가능하다.
select * from testtbl3;

insert into testtbl2 values (null, '모모', 22);
insert into testtbl2 values (null, '모모', 26);
select * from testtbl2;								-- @@auto_increment_increment = 3이 testtbl2에도 적용됨을 확인.

CREATE TABLE testtbl4 (
    id INT,
    Fname VARCHAR(50),
    Lname VARCHAR(50)
);
insert into testtbl4 select emp_no, first_name, last_name from employees.employees;
select* from testtbl4;


-- update, delete
update testtbl4 set lname = '없음' where fname = 'kyoichi';		-- update 테이블이름 set 열 = 값1, 열 = 값2 where 조건;
select * from testtbl4 where fname = 'kyoichi';

select @@autocommit;		-- 값이 1이면 true, 0이면 false / true일때 자동으로 커밋.
set autocommit = false;

select * from buytbl;
update buytbl set price = price*1.5;
update buytbl set amount = 100 where num = 2;
delete from buytbl where num = 2;				-- delete from 테이블이름 where 조건;
rollback;
commit;

select * from buytbl order by userid;
delete from buytbl where userid = 'bbk' limit 3;	-- 이런 형식으로도 사용가능

delete from bigtbl1;	-- DML 명령문 ROLLBACK 가능.
truncate table bigtbl1;	-- DDL 명령문 롤백 불가능 그러나 빠르다.
drop table bigtbl1;		-- DDL 명령문


-- with as --
select userid as '사용자', sum(price*amount) as '총구매액' from buytbl group by userid order by sum(price*amount) desc;

with abc(userid, total) 
	as (select userid, sum(price*amount) from buytbl group by userid) 
    select * from abc order by total desc;
