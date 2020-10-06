use KAKAOBANK;

DELIMITER $$

DROP PROCEDURE IF EXISTS loopInsert2$$

CREATE PROCEDURE loopInsert2()

BEGIN

	DECLARE i INT DEFAULT 1;
    DECLARE value1 bigint DEFAULT 1;
    DECLARE value2 bigint DEFAULT 1;


	WHILE i <= 10000000 DO

        set i = i + 1 ;

		SET value1 = 20220324012354 + i;
        set value2 = value1 + i ;

        -- 더미 데이터 insert
        INSERT INTO KAKAOBANK.USR_INFO_CHG_LOG_Q3 (LOG_TKTM, LOG_ID, USR_NO, RSDT_NO , LOC_NM , MCCO_NM)
	    VALUES (convert(value1 , char) , concat('id', convert(value2 , char) ) ,  i , '' , ''   ,'LG') ;

        -- 더미 데이터 insert
        INSERT INTO KAKAOBANK.MENU_LOG_Q2 (LOG_TKTM, LOG_ID, USR_NO, MENU_NM )
        VALUES (convert(value1 , char) , concat('id', convert(value2 , char) ) ,  i , 'logout');

	END WHILE;

END$$

DELIMITER $$

-- select * from KAKAOBANK.MENU_LOG_Q1;

call loopInsert2();






