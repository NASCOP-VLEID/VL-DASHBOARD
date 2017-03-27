DROP PROCEDURE IF EXISTS `proc_get_regional_sustxfail_partner`;
DELIMITER //
CREATE PROCEDURE `proc_get_regional_sustxfail_partner`
(IN C_id INT(11), IN filter_year INT(11), IN from_month INT(11), IN to_month INT(11))
BEGIN
  SET @QUERY =    "SELECT 
                      DISTINCT(`p`.`name`) AS `name`,
                      ((SUM(`vps`.`sustxfail`)/SUM(`vps`.`alltests`))*100) AS `percentages`, 
                      SUM(`vps`.`sustxfail`) AS `sustxfail` 
                  FROM `vl_partner_summary` `vps` 
                  JOIN `partners` `p` 
                    ON `vps`.`partner` = `p`.`ID`
                  JOIN `view_facilitys` `vf`
                    ON `p`.`ID` = `vf`.`partner`
                WHERE 1 ";

    IF (from_month != 0 && from_month != '') THEN
      IF (to_month != 0 && to_month != '') THEN
            SET @QUERY = CONCAT(@QUERY, " AND `vps`.`year` = '",filter_year,"' AND `vps`.`month` BETWEEN '",from_month,"' AND '",to_month,"' ");
        ELSE
            SET @QUERY = CONCAT(@QUERY, " AND `vps`.`year` = '",filter_year,"' AND `vps`.`month`='",from_month,"' ");
        END IF;
    ELSE
        SET @QUERY = CONCAT(@QUERY, " AND `vps`.`year` = '",filter_year,"' ");
    END IF;

    SET @QUERY = CONCAT(@QUERY, " AND `vf`.`county` = '",C_id,"' GROUP BY `p`.`name` ORDER BY `percentages` DESC  LIMIT 0, 10 ");

    PREPARE stmt FROM @QUERY;
    EXECUTE stmt;
    
END //
DELIMITER ;
