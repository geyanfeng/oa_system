/*
alter view oa_view_receivable_amount as
select  
CONCAT(c.`no`,"-S",CONVERT(f.sort,char)) as finance_no,
d.value as company_id, d.label as company_name,
u.id as saler_id, u.`name` as saler_name,
ct.id as customer_id, ct.`name` as customer_name,
c.id,c.`name` as contract_name,c.`no` as contract_no,
c.amount as contract_amount,
c.`status` as contract_stauts,
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
  WHEN c.`status` = 200 THEN '撤回中'
	ELSE '未定义'
END as contract_stauts_name,
f.amount as receivable_amount,
f.billing_date,
DATEDIFF(f.plan_pay_date,f.billing_date) as payment_days,
f.plan_pay_date,
f.`status` as finance_stauts,
CASE
  WHEN f.`status` = 1 THEN '没付款'
  WHEN f.`status` = 2 THEN '已开票'
  WHEN f.`status` = 3 THEN '已付款'
END as finance_stauts_name,
CASE
  WHEN f.`status` = 3 THEN f.amount
END as finance_amount,
f.pay_date,
DATEDIFF(f.pay_date,f.plan_pay_date) as over_days
from oa_contract_finance f 
inner join oa_contract c on f.contract_id = c.id
inner join oa_customer ct on ct.id = c.customer_id
inner join sys_user u on u.id = c.create_by
inner join sys_dict d on d.`value` = c.company_name 
where d.type='oa_company_name' and f.del_flag=0 and f.cancel_flag=0 and c.`status`> 26 and c.`status` not in(30,200);
*/
DROP PROCEDURE IF EXISTS report_receivable_amount;

create procedure report_receivable_amount(
IN pageNo INT, 
IN pageSize INT,  
IN sqlCondition VARCHAR(500),  
IN orderBy VARCHAR(100)
)
begin

SET pageNo = (pageNo-1 ) * pageSize;  
SET @COUNTSTMT := CONCAT("select COUNT(*) into @COUNT from oa_view_receivable_amount where 1=1 ", sqlCondition,";");
PREPARE STMT FROM @COUNTSTMT; 
EXECUTE STMT;  

SET @STMT := CONCAT("select @COUNT as recordCount,finance_no,company_name,saler_name,customer_name,contract_name,contract_stauts_name,
receivable_amount,billing_date,payment_days,plan_pay_date,finance_stauts_name,finance_amount,pay_date,over_days from oa_view_receivable_amount where 1=1 ", sqlCondition,
" ", orderBy);
PREPARE STMT FROM @STMT; 
EXECUTE STMT;  
end

