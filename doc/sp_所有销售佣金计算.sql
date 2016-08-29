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
call quarter_setting();
open cur_saler;  
repeat 
    fetch cur_saler into salerid; 
    #计算当前季度佣金计算  
		set @current_Date = CURRENT_DATE;
		set @year = year(@Current_Date);
		set @quarter = quarter(@Current_Date);
    set @month = month(@Current_Date);
    set @day = day(@Current_Date);
    call calcuate_saler_quarter_commission(salerid,@year,@quarter);
		#当前季度的第一天计算前一个季度佣金
    IF (@month = 1 OR @month = 4 OR @month = 7 OR @month = 10) AND @day = 1 THEN
        IF @quarter = 1 THEN
           set @previous_year = @year - 1;
					 set @previous_quarter = 4;
	      ELSE
					 set @previous_year = @year;
					 set @previous_quarter = @quarter - 1;
				END IF;
        call calcuate_saler_quarter_commission(salerid,@previous_year,@previous_quarter);
    END IF;
		
until done end repeat;  
close cur_saler;  

end



