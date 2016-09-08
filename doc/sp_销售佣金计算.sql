DROP PROCEDURE IF EXISTS calcuate_saler_quarter_commission;

create procedure calcuate_saler_quarter_commission(IN salerid varchar(64),IN currentyear int, In currentquarter int)
begin

declare paymentid varchar(64); 
declare done int;  
declare cur_finance CURSOR for select f.id
	from oa_contract_finance f 
	inner join oa_contract c on f.contract_id=c.id 
	where c.create_by = salerid and year(f.pay_date) = currentyear and quarter(f.pay_date) = currentquarter and f.del_flag=0 and f.status=3 and f.cancel_flag = 0;  
declare continue handler FOR SQLSTATE '02000' SET done = 1; 
open cur_finance;  
repeat 
    fetch cur_finance into paymentid;   
    IF LENGTH(paymentid) >0 THEN
       call calcuate_quarter_commission(paymentid,currentyear,currentquarter);
    END IF;   
until done end repeat;  
close cur_finance;  
select SUM(K_GP) INTO @GP from oa_commission where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

select scc_p1,scc_p2,scc_p3,scc_p4,scc_p5 into @scc_p1,@scc_p2,@scc_p3,@scc_p4,@scc_p5 from oa_quarter_setting where year=@year and quarter = @quarter;

#更新销售费用COS
#K1-K4 销售费用COS=销售额SV*税收点数TR+采购成本COG*账期点数PCC+物流费用LC
#K5 销售费用COS=销售额SV*税收点数TR+销售额SV*账期点数PCC+物流费用LC
set @k5 = 'f91d39a4b25a4b9f8e9f510b35af784e';
UPDATE oa_commission set 
    K_COS =
	  CASE K_ID
        WHEN @k5 THEN (K_SV*K_TR+K_SV*K_PCC+K_LC)
				ELSE (K_SV*K_TR+K_COG*K_PCC+K_LC)
	 	END
where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

#....
UPDATE oa_commission set 
GP = @GP,
K_SCC = CASE
            WHEN @GP <K_GPI*0.7 THEN @scc_p1
            WHEN @GP >=K_GPI*0.7 AND @GP <K_GPI*1.0 THEN @scc_p2
            WHEN @GP >=K_GPI*1.0 AND @GP <K_GPI*1.5 THEN @scc_p3
					  WHEN @GP >=K_GPI*1.5 AND @GP <K_GPI*2.0 THEN @scc_p4
						WHEN @GP >K_GPI*2.0 THEN @scc_p5
END,
K_NP = (K_GP - K_COS), 
K_EC = CASE
    WHEN (K_GP - K_COS) <0 THEN 1
	  ELSE K_EC
END,
K_AC = CASE
    WHEN (K_GP - K_COS) <0 THEN 1
	  ELSE K_AC
END
 where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

/*
业绩提成 = 净利NP*提成系数SCC*调整系数AC
额外佣金 = (销售额SV-客户费用CC*1.1-销售额SV*税收点数TR)*激励系数EC
额外佣金不受其他影响 GP<GPI*.07
*/

update oa_commission 
set K_SC = CASE
            WHEN GP <K_GPI*0.7 THEN K_SCC + (K_SV - K_CC*1.1 - K_SV*K_TR)*K_EC
            ELSE K_NP*K_SCC*K_AC + (K_SV - K_CC*1.1 - K_SV*K_TR)*K_EC
END,
K_TR_V = K_SV * K_TR,
K_PCC_V = K_COG * K_PCC,
K_YJ_V = CASE
            WHEN GP <K_GPI*0.7 THEN K_SCC
            ELSE K_NP*K_SCC*K_AC
END,
K_EW_V = (K_SV - K_CC*1.1 - K_SV*K_TR)*K_EC
where YEAR=currentyear AND `QUARTER` = currentquarter AND K_SALER_ID = salerid;

end