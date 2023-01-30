-- 변수의 사용.
use sqldb;
set @myvar1 = 5;
set @myvar2 = 3;
set @myvar3 = 4.25;
set @myvar4 = '가수 이름 ==> ';

select @myvar1;
select @myvar2 + @myvar3;

select @myvar4 as '가수', name from usertbl where height > 180;


-- 데이터 형식 변환 함수.
-- cast(expression as 데이터형식 [(길이)])
-- convert(expression, 데이터형식 [(길이)])
use sqldb;
select avg(amount) as '평균 구매 개수' from buytbl;
select cast(avg(amount) as signed integer) as '평균 구매 개수' from buytbl;
select convert(avg(amount), signed integer) as '평균 구매 개수' from buytbl;

SELECT CAST('2020$12$12' AS DATE);
SELECT CAST('2020/12/12' AS DATE);
SELECT CAST('2020%12%12' AS DATE);
SELECT CAST('2020@12@12' AS DATE);

SELECT num, CONCAT(CAST(price AS CHAR(10)), 'X', CAST(amount AS CHAR(4)) ,'=' )  AS '단가X수량',
	price*amount AS '구매액' 
  FROM buyTbl ;

SELECT '100' + '200' ; -- 문자와 문자를 더함 (정수로 변환되서 연산됨)
SELECT CONCAT('100', '200'); -- 문자와 문자를 연결 (문자로 처리)
SELECT CONCAT(100, '200'); -- 정수와 문자를 연결 (정수가 문자로 변환되서 처리)
SELECT 1 > '2mega'; -- 정수인 2로 변환되어서 비교
SELECT 3 > '2MEGA'; -- 정수인 2로 변환되어서 비교
SELECT 0 = 'mega2'; -- 문자는 0으로 변환됨


-- 내장 함수
select if (100>200, '참이다', '거짓이다');		-- if : 수식이 참 또는 거짓인지 결과에 따라서 2중 분기한다.

SELECT IFNULL(NULL, '널이군요'), IFNULL(100, '널이군요');	-- 수식1이 null이 아니면 수식1이 반환되고, 수식1이 null이면 수식2가 반환된다.

SELECT NULLIF(100,100), IFNULL(200,100);	-- 수식1과 수식2가 같으면 null을 반환하고, 다르면 수식1을 반환한다.

SELECT 	CASE 10
		WHEN 1  THEN  '일'
		WHEN 5  THEN  '오'
		WHEN 10 THEN  '십' 
		ELSE '모름'
	END;


-- 문자열 함수
select ascii('a'), convert(char(65) using utf8), char(65);

-- BIT_LENGTH('문자열') : 할당된 bit 크기 또는 문자 크기를 반환한다.
-- CHAR_LENGTH('문자열') : 문자의 개수를 반환한다.
-- LENGTH('문자열') : 할당된 byte 수를 반환한다.
SELECT BIT_LENGTH('abc'),  CHAR_LENGTH('abc'), LENGTH('abc');
SELECT BIT_LENGTH('가나다'),  CHAR_LENGTH('가나다'), LENGTH('가나다');

SELECT CONCAT_WS('/', '2020', '01', '01');		-- 구분자와 함께 문자열을 이어준다.

SELECT 
    ELT(2, '하나', '둘', '셋'),		-- 위치 번째에 해당하는 문자열을 반환.
    FIELD('둘', '하나', '둘', '셋'),	-- 찾을 문자열의 위치를 찾아서 반환, 매치되는 문자열이 없으면 0을 반환한다.
    FIND_IN_SET('둘', '하나,둘,셋'),	-- 찾을 문자열을 문자열 리스트에서 찾아서 위치를 반환.
    INSTR('하나둘셋', '둘'),			-- 기준 문자열에서 부분 문자열을 찾아서 그 시작 위치를 반환.
    LOCATE('둘', '하나둘셋');			-- INSTR()과 동일하지만 파라미터의 순서가 반대.
    
SELECT FORMAT(123456.123456, 4);	-- 숫자를 소수점 아래 자릿수까지 표현.

SELECT BIN(31), HEX(31), OCT(31);	-- 2진수, 16진수, 8진수 값을 반환.

SELECT INSERT('abcdefghi', 3, 4, '@@@@'), INSERT('abcdefghi', 3, 2, '@@@@');	-- 기존 문자열의 위치부터 길이만큼 지우고 삽입할 문자열을 끼워 넣는다.

SELECT LEFT('abcdefghi', 3), RIGHT('abcdefghi', 3);		-- 왼쪽 또는 오른쪽에서 문자열의 길이만큼 반환.

SELECT LOWER('abcdEFGH'), UPPER('abcdEFGH');			-- 소문자를 대문자로, 대문자를 소문자로 변경.

SELECT LPAD('이것이', 5, '##'), RPAD('이것이', 5, '##');	-- 문자열을 길이만큼 늘린 후에 빈 곳을 채울 문자열로 채운다.

SELECT LTRIM('   이것이'), RTRIM('이것이   ');				-- 문자열의 왼/오 공백을 제거한다. 중간의 공백은 제거되지 않는다.

SELECT 
	TRIM('   이것이   '), 						-- 문자열의 앞뒤 공백을 모두 없앤다.
	TRIM(BOTH 'ㅋ' FROM 'ㅋㅋㅋ재밌어요.ㅋㅋㅋ');		-- TRIM(방향_자를 문자열, from 문자열), 방향은 leading(앞), both(양쪽), trailing(뒤)

SELECT REPEAT('이것이', 3);	-- 문자열을 횟수만큼 반복한다.

SELECT REPLACE ('이것이 MySQL이다', '이것이' , 'This is');	-- 문자열에서 원래 문자열을 찾아서 바꿀 문자열로 바꿔준다.

SELECT REVERSE ('MySQL');		-- 문자열의 순서를 거꾸로 만든다.


-- 날짜 및 시간 함수
SELECT ADDDATE('2020-01-01', INTERVAL 31 DAY), ADDDATE('2020-01-01', INTERVAL 1 MONTH);
SELECT SUBDATE('2020-01-01', INTERVAL 31 DAY), SUBDATE('2020-01-01', INTERVAL 1 MONTH);

SELECT ADDTIME('2020-01-01 23:59:59', '1:1:1'), ADDTIME('15:00:00', '2:10:10');
SELECT SUBTIME('2020-01-01 23:59:59', '1:1:1'), SUBTIME('15:00:00', '2:10:10');

SELECT YEAR(CURDATE()), MONTH(CURDATE()), DAYOFMONTH(CURDATE);
SELECT HOUR(CURTIME()), MINUTE(CURRENT_TIME()), SECOND(CURRENT_TIME), MICROSECOND(CURRENT_TIME);

SELECT DATE(NOW()), TIME(NOW());

SELECT DATEDIFF('2020-01-01', NOW()), TIMEDIFF('23:23:59', '12:11:10');

SELECT DAYOFWEEK(CURDATE()), MONTHNAME(CURDATE()), DAYOFYEAR(CURDATE());

SELECT LAST_DAY('2020-02-01');

SELECT MAKEDATE(2020, 32);

SELECT MAKETIME(12, 11, 10);

SELECT PERIOD_ADD(202001, 11), PERIOD_DIFF(202001, 201812);

SELECT QUARTER('2020-07-07');

SELECT TIME_TO_SEC('12:11:10');



-- JSON --
USE sqlDB;
SELECT JSON_OBJECT('name', name, 'height', height) AS 'JSON 값'
	FROM userTBL 
    WHERE height >= 180;

SET @json='{ "userTBL" :
  [
	{"name":"임재범","height":182},
	{"name":"이승기","height":182},
	{"name":"성시경","height":186}
  ]
}' ;	-- 배열 형태
SELECT JSON_VALID(@json);
SELECT JSON_SEARCH(@json, 'one', '성시경');
SELECT JSON_EXTRACT(@json, '$.userTBL[2].name');
SELECT JSON_INSERT(@json, '$.userTBL[0].mDate', '2009-09-09');
SELECT JSON_REPLACE(@json, '$.userTBL[0].name', '홍길동');
SELECT JSON_REMOVE(@json, '$.userTBL[0]');



-- JOIN --
USE sqldb;

select * from usertbl;
select * from buytbl;

SELECT 
    *
FROM
    buytbl
        INNER JOIN
    usertbl ON buytbl.userid = usertbl.userid;

SELECT 
    *
FROM
    buyTbl
        INNER JOIN
    userTbl ON buyTbl.userID = userTbl.userID
WHERE
    buyTbl.userID = 'JYP';		-- 한정자, 규정자
    
SELECT 					-- 테이블 별칭 사용
    B.userID,
    U.name,
    B.prodName,
    U.addr,
    U.mobile1 + U.mobile2 AS '연락처'
FROM
    buyTbl B
        INNER JOIN
    userTbl U ON B.userID = U.userID;
    
    -- JOIN 실습 --
USE sqlDB;
CREATE TABLE stdTbl (
    stdName VARCHAR(10) NOT NULL PRIMARY KEY,
    addr CHAR(4) NOT NULL
);
CREATE TABLE clubTbl (
    clubName VARCHAR(10) NOT NULL PRIMARY KEY,
    roomNo CHAR(4) NOT NULL
);
CREATE TABLE stdclubTbl (
    num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    stdName VARCHAR(10) NOT NULL,
    clubName VARCHAR(10) NOT NULL,
    FOREIGN KEY (stdName)
        REFERENCES stdTbl (stdName),
    FOREIGN KEY (clubName)
        REFERENCES clubTbl (clubName)
);
INSERT INTO stdTbl VALUES ('김범수','경남'), ('성시경','서울'), ('조용필','경기'), ('은지원','경북'),('바비킴','서울');
INSERT INTO clubTbl VALUES ('수영','101호'), ('바둑','102호'), ('축구','103호'), ('봉사','104호');
INSERT INTO stdclubTbl VALUES (NULL, '김범수','바둑'), (NULL,'김범수','축구'), (NULL,'조용필','축구'), (NULL,'은지원','축구'), (NULL,'은지원','봉사'), (NULL,'바비킴','봉사');

select * from stdtbl;
select * from clubtbl;
select * from stdclubtbl;

SELECT 
    s.stdname as '이름', s.addr as '지역', c.clubname as '동아리', c.roomno as '동아리방'
FROM
    stdtbl s
        INNER JOIN
    stdclubtbl sc ON s.stdname = sc.stdname
        INNER JOIN
    clubtbl c ON sc.clubname = c.clubname
order by
	s.stdname;
    
-- OUTER JOIN --
-- 조인의 조건에 만족되지 않는 행까지도 포함시키는 것.
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
   FROM userTbl U
      JOIN buyTbl B
         ON U.userID = B.userID 
   ORDER BY U.userID;
   
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
   FROM userTbl U
      LEFT OUTER JOIN buyTbl B
         ON U.userID = B.userID 
   ORDER BY U.userID;
   
   SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2)  AS '연락처'
   FROM userTbl U
      LEFT OUTER JOIN buyTbl B
         ON U.userID = B.userID 
   WHERE B.prodName IS NULL			-- null을 비교연산을 할때는 등호를 쓰지 않고 is null로 표현한다.
   ORDER BY U.userID;
   
   SELECT S.stdName, S.addr, C.clubName, C.roomNo
   FROM stdTbl S 
      LEFT OUTER JOIN stdclubTbl SC
          ON S.stdName = SC.stdName
      LEFT OUTER JOIN clubTbl C
          ON SC.clubName = C.clubName
   ORDER BY S.stdName;
   
   SELECT C.clubName, C.roomNo, S.stdName, S.addr
   FROM  stdTbl S
      LEFT OUTER JOIN stdclubTbl SC
          ON SC.stdName = S.stdName
      RIGHT OUTER JOIN clubTbl C
          ON SC.clubName = C.clubName
   ORDER BY C.clubName ;

SELECT S.stdName, S.addr, C.clubName, C.roomNo		-- union : 두 join문을 합쳐서 출력
   FROM stdTbl S 
      LEFT OUTER JOIN stdclubTbl SC
          ON S.stdName = SC.stdName
      LEFT OUTER JOIN clubTbl C
          ON SC.clubName = C.clubName
UNION 
SELECT S.stdName, S.addr, C.clubName, C.roomNo
   FROM  stdTbl S
      LEFT OUTER JOIN stdclubTbl SC
          ON SC.stdName = S.stdName
      RIGHT OUTER JOIN clubTbl C
          ON SC.clubName = C.clubName;
          
SELECT 			-- cross join
    *
FROM
    buyTbl
        CROSS JOIN
    userTbl;

SELECT * 
   FROM buyTbl , userTbl ;
   
   
-- 셀프 조인------------------------------------------------------------------
CREATE TABLE empTbl (
    emp CHAR(3),
    manager CHAR(3),
    empTel VARCHAR(8)
);

INSERT INTO empTbl VALUES('나사장',NULL,'0000');
INSERT INTO empTbl VALUES('김재무','나사장','2222');
INSERT INTO empTbl VALUES('김부장','김재무','2222-1');
INSERT INTO empTbl VALUES('이부장','김재무','2222-2');
INSERT INTO empTbl VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTbl VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTbl VALUES('이영업','나사장','1111');
INSERT INTO empTbl VALUES('한과장','이영업','1111-1');
INSERT INTO empTbl VALUES('최정보','나사장','3333');
INSERT INTO empTbl VALUES('윤차장','최정보','3333-1');
INSERT INTO empTbl VALUES('이주임','윤차장','3333-1-1');

select * from emptbl;

SELECT A.emp AS '부하직원' , B.emp AS '직속상관', B.empTel AS '직속상관연락처'
   FROM empTbl A
      INNER JOIN empTbl B
         ON A.manager = B.emp		-- 순서 주의.
   WHERE A.emp = '우대리';			-- 테이블 주의.
   
   
   -- union, union all, not in, in --
SELECT stdName, addr FROM stdTbl
   UNION ALL							-- union : 중복된 열 제외하고 합쳐서 조회 / union all : 중복된 열까지 모두 조회.
SELECT clubName, roomNo FROM clubTbl;

SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM userTbl
   WHERE name NOT IN ( SELECT name FROM userTbl WHERE mobile1 IS NULL) ;		-- 서브쿼리에 해당하는 내용을 제외하고 조회.

SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM userTbl
   WHERE name IN ( SELECT name FROM userTbl WHERE mobile1 IS NULL) ;			-- 서브쿼리에 해당하는 내용만 조회.