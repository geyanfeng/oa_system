#计算所有销售的季度佣金
DROP PROCEDURE IF EXISTS calcuate_allsalers_quarter_commission;

create procedure calcuate_allsalers_quarter_commission()
begin
declare salerid varchar(64); 
declare done int;  
declare cur_saler CURSOR for select u.id
	from oa_people_setting p 
	inner join sys_user u on p.saler_id =u.id 
	where u.login_flag=1 and u.del_flag=0;  
declare continue handler FOR SQLSTATE '02000' SET done = 1; 
open cur_saler;  
repeat 
    fetch cur_saler into salerid; 
    #计算当前季度佣金计算  
		set @current_Date = CURRENT_DATE;
		set @year = year(@Current_Date);
		set @quarter = quarter(@Current_Date);
    call calcuate_saler_quarter_commission(salerid,@year,@quarter);
		#计算前一个季度佣金
until done end repeat;  
close cur_saler;  

end