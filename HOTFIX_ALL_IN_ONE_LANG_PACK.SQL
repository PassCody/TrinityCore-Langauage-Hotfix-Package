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
			SET @searchLanguage_de = 'deDE';
			SET @searchLanguage_es = 'esES';
			SET @searchLanguage_mx = 'esMX';
			SET @searchLanguage_fr = 'frFR';
			
			-- HOTFIX UPDATE STATEMENT FOR GERMAN
			SET @hotfixGermanLanguage = CONCAT(
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
			 	'WHERE locale LIKE \'%', @searchLanguage_de ,'%\' OR ',
				'Locale LIKE \'%', @searchLanguage_de ,'%\';'
			);
			
			-- HOTFIX UPDATE STATEMENT FOR ESPANIOL
			SET @hotfixEspaniolLanguage = CONCAT(
				'UPDATE ', tname, ' SET `', cname, '` = ',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(`', cname ,'`,\'Ã¡\', \'á\'),',
				'\'Ã©\', \'é\'),',
				'\'Ã\', \'í\'),',
				'\'Ã³\', \'ó\'),',
				'\'Ãº\', \'ú\'),',
				'\'Ã±\', \'ñ\'),',
				'\'Â¡\', \'¡\'),',
			 	'\'Â¿\', \'¿\')',
			 	'WHERE locale LIKE \'%', @searchLanguage_es ,'%\' OR ',
				'Locale LIKE \'%', @searchLanguage_es ,'%\' OR ',
				'locale LIKE \'%', @searchLanguage_mx ,'%\' OR ',
				'Locale LIKE \'%', @searchLanguage_mx ,'%\';'
			);
			
			-- HOTFIX UPDATE STATEMENT FOR FRANCH
			SET @hotfixFranchLanguage = CONCAT(
				'UPDATE ', tname, ' SET `', cname, '` = ',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(',
				'REPLACE(`', cname ,'`,\'Ã\', \'à\'),',
				'\'Ã¢\', \'â\'),',
				'\'Ã§\', \'ç\'),',
				'\'Ã©\', \'é\'),',
				'\'Ã¨\', \'è\'),',
				'\'Ãª\', \'ê\'),',
				'\'Ã«\', \'ë\'),',
				'\'Ã®\', \'î\'),',
				'\'Ã¯\', \'ï\'),',
				'\'Ã´\', \'ô\'),',
				'\'Ã¹\', \'ù\'),',
				'\'Ã»\', \'û\'),',
				'\'Ã¼\', \'ü\'),',
				'\'Å“\', \'œ\'),',
				'\'Æ\', \'æ\')',
			 	'WHERE locale LIKE \'%', @searchLanguage_fr ,'%\' OR ',
				'Locale LIKE \'%', @searchLanguage_fr ,'%\';'
			);
			
			-- PREPARE HOTFIX UPDATE STATEMENT
			PREPARE stmtHotfixGerman FROM @hotfixGermanLanguage;
			PREPARE stmtHotfixEspaniol FROM @hotfixEspaniolLanguage;
			PREPARE stmtHotfixFranch FROM @hotfixFranchLanguage;
			
			-- RUN HOTFIX UPDATE STATEMENT
			EXECUTE stmtHotfixGerman;
			EXECUTE stmtHotfixEspaniol;
			EXECUTE stmtHotfixFranch;
			
			-- DEPREPARE HOTFIX UPDATE STATEMENT
			DEALLOCATE PREPARE stmtHotfixGerman;
			DEALLOCATE PREPARE stmtHotfixEspaniol;
			DEALLOCATE PREPARE stmtHotfixFranch;
			
			SET i = i + 1;
	END WHILE;
END$$

CALL LANGUAGE_HOTFIX_Proc();

DROP PROCEDURE LANGUAGE_HOTFIX_Proc;
DROP TABLE LANGUAGE_HOTFIX;