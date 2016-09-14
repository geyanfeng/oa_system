DROP PROCEDURE IF EXISTS report_contract_statistics;

create procedure report_contract_statistics(
IN pageNo INT, 
IN pageSize INT,   
IN sqlCondition VARCHAR(500),  
IN orderBy VARCHAR(100)
)
begin

SET pageNo = (pageNo-1 ) * pageSize;  

SET @COUNTSTMT := CONCAT("select COUNT(a.contract_id) into @COUNT from (select contract_id from oa_view_achievement where 1=1 ", sqlCondition," GROUP BY contract_id) a");
PREPARE STMT FROM @COUNTSTMT; 
EXECUTE STMT;  

SET @STMT := CONCAT("select @COUNT as recordCount, c.create_date as createDate,c.`no`,c.company_name as companyName,
cus.`name` as CustomerName,c.`name`,
c.amount,
CASE
  WHEN c.`status` = 0 THEN '初始状态'
  WHEN c.`status` = 10 THEN '已签约'
  WHEN c.`status` = 20 THEN '待审批(销售)'
  WHEN c.`status` = 22 THEN '待审批(技术)'
  WHEN c.`status` = 24 THEN '待审批(销售总监)'
  WHEN c.`status` = 26 THEN '待审批(财务总监)'
  WHEN c.`status` = 30 THEN '待签约'
  WHEN c.`status` = 35 THEN '待下单'
  WHEN c.`status` = 40 THEN '已下单'
  WHEN c.`status` = 50 THEN '部分发货'
  WHEN c.`status` = 60 THEN '已发货'
  WHEN c.`status` = 70 THEN '已验收'
  WHEN c.`status` = 75 THEN '确认开票中'
  WHEN c.`status` = 80 THEN '已开票'
  WHEN c.`status` = 90 THEN '已收款'
  WHEN c.`status` = 100 THEN '已完成'
	ELSE '未定义'
END AS status,
u1.`name` as salerName,u2.name as businessName,u3.name artisanName
from 
(select contract_id from oa_view_achievement where 1=1 ", sqlCondition," GROUP BY contract_id) a 
left join oa_contract c on c.id = a.contract_id 
left join sys_user u1 on u1.id = c.create_by
left join sys_user u2 on u2.id = c.business_person_id
left join sys_user u3 on u3.id = c.artisan_id
left join oa_customer cus on cus.id = c.customer_id",
" ", orderBy,
" limit ",pageNo,",",pageSize);
PREPARE STMT FROM @STMT; 
EXECUTE STMT;  
end
