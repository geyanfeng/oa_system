DROP PROCEDURE IF EXISTS calcuate_saler_quarter_commission;

create procedure calcuate_saler_quarter_commission(IN salerid varchar(64),IN currentyear int, In currentquarter int)
begin

declare paymentid varchar(64); 
declare done int;  
declare cur_finance CURSOR for select f.id
	from oa_contract_finance f 
	inner join oa_contract c on f.contract_id=c.id 
	where c.create_by = salerid and year(f.pay_date) = currentyear and quarter(f.pay_date) = currentquarter and f.del_flag=0 and f.status=3;  
declare continue handler FOR SQLSTATE '02000' SET done = 1; 
open cur_finance;  
repeat 
    fetch cur_finance into paymentid;   
    call calcuate_quarter_commission(paymentid,currentyear,currentquarter);
until done end repeat;  
close cur_finance;  
select SUM(K_GP) INTO @GP from oa_commission where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

select scc_p1,scc_p2,scc_p3,scc_p4,scc_p5 into @scc_p1,@scc_p2,@scc_p3,@scc_p4,@scc_p5 from oa_quarter_setting where year=@year and quarter = @quarter;

UPDATE oa_commission set 
GP = @GP,
K_SCC = CASE
            WHEN @GP <K_GPI*0.7 THEN @scc_p1
            WHEN @GP >=K_GPI*0.7 AND @GP <K_GPI*1.0 THEN @scc_p2
            WHEN @GP >=K_GPI*1.0 AND @GP <K_GPI*1.5 THEN @scc_p3
					  WHEN @GP >=K_GPI*1.5 AND @GP <K_GPI*2.0 THEN @scc_p4
						WHEN @GP >K_GPI*2.0 THEN @scc_p5
END,
K_COS = (K_SV*K_TR+K_COG*K_PCC+K_LC),
K_NP = (K_GP - (K_SV*K_TR+K_COG*K_PCC+K_LC)), 
K_EC = CASE
    WHEN (K_GP - (K_SV*K_TR+K_COG*K_PCC+K_LC)) <0 THEN 1
	  ELSE K_EC
END,
K_AC = CASE
    WHEN (K_GP - (K_SV*K_TR+K_COG*K_PCC+K_LC)) <0 THEN 1
	  ELSE K_AC
END
 where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

update oa_commission 
set K_SC = CASE
            WHEN GP <K_GPI*0.7 THEN K_SCC
            ELSE (K_SV-K_COG-K_CC-K_SV*K_TR+K_COG*K_PCC-K_LC)*K_SCC*K_EC
END 
where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

end