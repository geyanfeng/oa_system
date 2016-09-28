DROP PROCEDURE IF EXISTS financeCalendar;

create procedure financeCalendar(  
IN roleName VARCHAR(100)
)
begin

IF roleName = 'cfo' THEN
 SET @param = "&hiddenButton=1";
 SET @roleName = "'cw','cfo'";
ELSE
 SET @roleName = "'cw'";
 SET @param = "";
END IF;
SET @COUNTSTMT := CONCAT("SELECT  
 CASE 
  WHEN i.GROUP_ID_ = 'cfo' THEN CONCAT('/act/task/form?taskId=',t.ID_,'&taskName=',t.Name_,'&taskDefKey=',t.TASK_DEF_KEY_,'&procInsId=',t.PROC_INST_ID_,'&procDefId=',t.PROC_DEF_ID_,'&status=claim')
  ELSE CONCAT('/act/task/form?taskId=',t.ID_,'&taskName=',t.Name_,'&taskDefKey=',t.TASK_DEF_KEY_,'&procInsId=',t.PROC_INST_ID_,'&procDefId=',t.PROC_DEF_ID_,'&status=claim",@param,"')        
END AS url,
 CASE 
  WHEN i.GROUP_ID_ = 'cfo' THEN '#fbca35'
  ELSE '#e96154'        
END AS color,
CASE 
  WHEN t.TASK_DEF_KEY_ = 'cw_kp' THEN '开票'
  WHEN t.TASK_DEF_KEY_ = 'verify_sk' AND f.amount is not null THEN CONCAT('收',CONVERT(f.amount,char))
  WHEN (t.TASK_DEF_KEY_ = 'payment' or t.TASK_DEF_KEY_ = 'payment_first' or t.TASK_DEF_KEY_ = 'payment_all') AND pf.pay_method = '3' AND pf.amount is not null THEN CONCAT('票付',CONVERT(pf.amount,char))
  WHEN (t.TASK_DEF_KEY_ = 'payment' or t.TASK_DEF_KEY_ = 'payment_first' or t.TASK_DEF_KEY_ = 'payment_all') AND pf.amount is not null THEN CONCAT('付',CONVERT(pf.amount,char))
  ELSE t.NAME_        
END AS title,
CASE 
  WHEN t.TASK_DEF_KEY_ = 'verify_sk' and f.plan_pay_date is not null THEN DATE_FORMAT(f.plan_pay_date,'%Y-%m-%d')
  WHEN (t.TASK_DEF_KEY_ = 'payment' or t.TASK_DEF_KEY_ = 'payment_first' or t.TASK_DEF_KEY_ = 'payment_all') and pf.plan_pay_date is not null THEN DATE_FORMAT(pf.plan_pay_date,'%Y-%m-%d')
  ELSE DATE_FORMAT(t.CREATE_TIME_,'%Y-%m-%d')       
END AS start
FROM ACT_RU_TASK t
inner JOIN ACT_RU_IDENTITYLINK i on t.ID_ = i.TASK_ID_ 
left JOIN oa_contract c
on c.PROC_INS_ID = t.PROC_INST_ID_
left JOIN oa_contract_finance f
on f.contract_id = c.id and f.billing_date is not NULL and f.pay_date is NULL
left join oa_po p 
on p.PROC_INS_ID = t.PROC_INST_ID_
left join (select b.* from (select po_id,pay_method,plan_pay_date,amount from oa_po_finance where pay_date is null order by sort asc) b group by b.po_id) pf
on pf.po_id = p.id
where i.GROUP_ID_ in (",@roleName,")", 
";");
PREPARE STMT FROM @COUNTSTMT; 
EXECUTE STMT;  

end