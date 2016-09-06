#call calcuate_allsalers_quarter_commission();


	 #call calcuate_saler_quarter_commission('16',2016,3);
/*
select u.id
	from oa_people_setting p 
	inner join sys_user u on p.saler_id =u.id 
	where u.login_flag=1 and u.del_flag=0; 
select *
	from oa_contract_finance f 
	inner join oa_contract c on f.contract_id=c.id 
	where c.create_by = '620212e9ac71484db06978bf3e5f90f6' and year(f.pay_date) = 2016 and quarter(f.pay_date) = 3 and f.del_flag=0 and f.status=3; 
SHOW VARIABLES LIKE 'event_scheduler';
set global event_scheduler =1; 

set global event_scheduler=1;
Create event myevent on schedule
every 1 day starts '2010-12-18 01:00:00'
DO
DROP EVENT IF EXISTS e_calcuate_quarter_commission;

*/


create event if not exists e_calcuate_customer_evaluate
on schedule EVERY 1 DAY STARTS date_add(date(curdate()),interval 22 hour)
ON COMPLETION PRESERVE
ENABLE
DO
call calcuate_customer_evaluate();

create event if not exists e_quarter_setting
on schedule EVERY 1 DAY STARTS date_add(date(curdate()),interval 23 hour) 
ON COMPLETION PRESERVE
ENABLE
DO
call quarter_setting();

create event if not exists e_calcuate_allsalers_quarter_commission
on schedule EVERY 1 DAY STARTS date_add(date(curdate() + 1),interval 1 hour) 
ON COMPLETION PRESERVE
ENABLE
DO
call calcuate_allsalers_quarter_commission();



 

