CREATE TEMPORARY TABLE LANGUAGE_HOTFIX (ROW_ID INT, TABLE_NAME TEXT, COLUMN_NAME TEXT);

SET @rownum := 0;

INSERT INTO LANGUAGE_HOTFIX SELECT 
	@rownum := @rownum + 1 AS ROW_ID,
	TABLE_NAME,
	COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
	AND TABLE_NAME LIKE '%_locale'
	AND COLUMN_NAME NOT IN ('ID','entry','locale','Locale','VerifiedBuild');

DELIMITER $$

CREATE PROCEDURE LANGUAGE_HOTFIX_Proc() BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE tname TEXT;
	DECLARE cname TEXT;
	WHILE i <= @rownum DO
			SET tname = (SELECT TABLE_NAME FROM LANGUAGE_HOTFIX WHERE ROW_ID = i);
			SET cname = (SELECT COLUMN_NAME FROM LANGUAGE_HOTFIX WHERE ROW_ID = i);
			SET @searchLanguage = 'deDE';
			
			-- HOTFIX UPDATE STATEMENT FOR GERMAN
			SET @sql_stmt = CONCAT(
				'UPDATE ', tname, ' SET `', cname, '` = ',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(`', cname ,'`,\'Ã¶\', \'ö\'),',
				'\'Ã¤\', \'ä\'),',
				'\'Ã¼\', \'ü\'),',
				'\'ÃŸ\', \'ß\'),',
				'\'Ã–\', \'Ö\'),',
				'\'Ã„\', \'Ä\'),',
			 	'\'Ãœ\', \'Ü\')',
			 	'WHERE locale LIKE \'%', @searchLanguage ,'%\' OR ',
				'Locale LIKE \'%', @searchLanguage ,'%\';'
			);
			
			-- PREPARE HOTFIX UPDATE STATEMENT
			PREPARE stmt FROM @sql_stmt;
			
			-- RUN HOTFIX UPDATE STATEMENT
			EXECUTE stmt;
			
			-- DEPREPARE HOTFIX UPDATE STATEMENT
			DEALLOCATE PREPARE stmt;
			
			SET i = i + 1;
	END WHILE;
END$$

CALL LANGUAGE_HOTFIX_Proc();

DROP PROCEDURE LANGUAGE_HOTFIX_Proc;
DROP TABLE LANGUAGE_HOTFIX;