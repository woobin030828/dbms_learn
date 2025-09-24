-- *13) 유저 중 이태희를 태희로 이름 변경
UPDATE TBL_BUYER
SET BUYER_NAME = '태희', BUYER_ADDRESS = '서울시 스카일캐슬'
WHERE BUYER_NAME = '이태희';
SELECT * FROM TBL_BUYER;

-- 14) 신상품 '나이키', '에어맥스 95', 가격 179000원, 재고 200개를 TBL_PRODUCT 테이블에 추가
-- 15) BUYER_NAME이 '철수'인 사람의 핸드폰 번호를 '010-0000-0000'으로 변경
-- *16) PRODUCT_NAME이 '후드티'인 상품의 가격을 310000으로 인상
UPDATE TBL_PRODUCT 
SET PRODUCT_PRICE = 310000
WHERE PRODUCT_NAME = '후드티';

SELECT * FROM TBL_PRODUCT;

-- 19) '짱구'가 주문한 상품의 이름과 가격을 조회
-- 20) 각 구매자별로 주문한 상품의 총 개수를 조회 (구매자 이름, 주문 건수)
-- 21) 가장 많이 주문된 상품 3개의 이름과 주문 횟수를 내림차순으로 조회
-- *22) 여성 구매자들이 주문한 상품 평균 가격을 조회
SELECT FLOOR(AVG(PRODUCT_PRICE)) 
FROM (
	SELECT *
	FROM TBL_ORDER
	WHERE BUYER_ID IN (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_GENDER = '여'
	)
) TBO
JOIN TBL_PRODUCT TBP
ON TBO.PRODUCT_ID = TBP.ID;

-- 23) 나이가 30세 이상인 남성 구매자들의 이름과 주소를 조회
-- 24) 재고가 100개 이하인 상품 목록을 브랜드명과 함께 조회
-- 25) '서울시 강북구'에 사는 구매자들의 이름과 핸드폰 번호를 조회
-- 26) 주문 상태가 '배송중'인 주문 내역과 해당 주문자의 이름, 상품명을 조회
-- 27) '훈이' 구매자가 주문한 상품들의 총 가격 합계 조회
-- *28) 상품별 기대 매출 조회
SELECT PRODUCT_NAME, PRODUCT_PRICE * PRODUCT_STOCK
FROM TBL_PRODUCT;

-- *29) '유리' 구매자의 주문 내역 중 가장 최근 주문한 상품의 이름과 주문일자를 조회
SELECT TBP.PRODUCT_NAME, TBO.ORDER_START_DATE
FROM TBL_PRODUCT TBP
JOIN (
	SELECT *
	FROM TBL_ORDER TBO
	JOIN (
		SELECT ID
		FROM TBL_BUYER
		WHERE BUYER_NAME = '유리'
	) TBU
	ON TBO.BUYER_ID = TBU.ID
	ORDER BY ORDER_START_DATE DESC
	FETCH FIRST 2 ROWS ONLY
) TBO
ON TBP.ID = TBO.PRODUCT_ID;

-- *30) 구매자별로 주문 완료 일자가 가장 빠른 주문 내역을 조회
SELECT *
FROM TBL_BUYER TBU
JOIN (
	SELECT BUYER_ID, MAX(ORDER_START_DATE)
	FROM TBL_ORDER
	GROUP BY BUYER_ID
) TBO
ON TBU.ID = TBO.BUYER_ID;

-- 31) '스웨이드' 브랜드의 모든 상품 주문 건수를 조회
-- 32) '봉미선' 구매자가 주문한 상품들 중 가격이 5만원 이상인 상품의 이름과 가격을 조회
-- 33) '수지' 구매자의 주소를 '서울시 송파구'로 수정
-- 34) 주문 상태가 '배송중'인 주문을 '배송완료'로 변경
-- 35) 25세 이하인 구매자의 이름, 나이, 구매한 상품명 조회
-- 36) 특정 상품(예: '볼캡')의 재고 수량을 0으로 변경
-- 37) '아이더' 브랜드 상품을 주문한 구매자들의 이름과 연락처를 조회
-- 38) '맹구' 구매자가 주문한 상품들의 가격 총합을 계산
-- 39) 상품 할인 중 모든 30% 할인가격 조회
-- 40) 구매자별로 주문한 상품 개수를 조회
-- 41) '짱구' 구매자가 주문한 상품 중 가격이 가장 비싼 상품을 조회
-- 42) '철수'와 '훈이'가 주문한 상품들을 조회하되 중복 없이 출력
-- 43) '강북구'에 사는 여성 구매자들의 주문 내역을 조회
-- 44) 구매자 이름과 그가 주문한 상품 이름, 주문 상태를 함께 출력
-- 45) 모든 상품의 평균 가격을 구하고, 평균 이상 가격인 상품들을 조회
-- 46) '스파오' 브랜드 상품의 재고를 50개 이하인 경우 재고를 100개로 수정


-- 보류
-- 17) BUYER_NAME이 '맹구'인 구매자의 정보를 TBL_BUYER에서 삭제 (단, 주문 이력이 있을 경우 삭제되지 않음)
-- 18) PRODUCT_NAME이 '텀블러'인 상품을 TBL_PRODUCT 테이블에서 삭제

-- 막조인
SELECT *
FROM TBL_PRODUCT, TBL_ORDER;


CREATE TABLE TBL_EMPLOYEE(
	ID NUMBER CONSTRAINT PK_EMPLOYEE PRIMARY KEY,
	EMPLOYEE_NAME VARCHAR2(255)
);

CREATE TABLE TBL_INCOME(
	ID NUMBER CONSTRAINT PK_INCOME PRIMARY KEY,
	INCOME NUMBER,
	INCOME_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	EMPLOYEE_ID NUMBER,
	CONSTRAINT FK_INCOME_EMPLOYEE FOREIGN KEY(EMPLOYEE_ID)
	REFERENCES TBL_EMPLOYEE(ID)
);

INSERT INTO TBL_EMPLOYEE
VALUES(1, '홍길동');
INSERT INTO TBL_EMPLOYEE
VALUES(2, '장보고');
INSERT INTO TBL_EMPLOYEE
VALUES(3, '이순신');

INSERT INTO TBL_INCOME(ID, INCOME, EMPLOYEE_ID)
VALUES(1, 100000, 1);
INSERT INTO TBL_INCOME(ID, INCOME, EMPLOYEE_ID)
VALUES(2, 150000, 1);

SELECT EMPLOYEE_NAME, NVL(SUM(INCOME), 0)
FROM TBL_INCOME TI
RIGHT JOIN TBL_EMPLOYEE TE
ON TI.EMPLOYEE_ID = TE.ID
GROUP BY EMPLOYEE_NAME;









