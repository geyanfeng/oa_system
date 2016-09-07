DROP PROCEDURE IF EXISTS sp_cancel_contract;
create procedure sp_cancel_contract(
	IN id varchar(64),
	IN cancelReason VARCHAR(1000),
	IN cancelDate VARCHAR(100),
	IN cancelType char(4))
begin		
		UPDATE oa_contract SET
		cancel_flag = 1, cancel_reason = cancelReason, cancel_date=cancelDate, cancel_type = cancelType, PROC_INS_ID = NULL
		WHERE oa_contract.id = id;

		UPDATE oa_contract_product SET
		cancel_flag = 1
		WHERE oa_contract_product.contract_id = id;

		UPDATE oa_contract_finance SET
		cancel_flag = 1
		WHERE oa_contract_finance.contract_id = id;

		UPDATE oa_po SET
		cancel_flag = 1, cancel_reason = cancelReason, cancel_date=cancelDate, PROC_INS_ID = NULL
		WHERE oa_po.contract_id = id;

		UPDATE oa_po_product SET
		cancel_flag = 1
		WHERE oa_po_product.po_id in (select a.id from oa_po a, oa_contract b where b.id = a.contract_id and b.id =id );

		UPDATE oa_po_finance SET
		cancel_flag = 1
		WHERE oa_po_finance.po_id in (select a.id from oa_po a, oa_contract b where b.id = a.contract_id and b.id =id );
End