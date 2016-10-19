/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.dao.BonusRecordDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.dao.OaCommissionDao;
import com.thinkgem.jeesite.modules.oa.entity.BonusRecord;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.OaCommission;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

/**
 * 佣金统计Service
 * @author frank
 * @version 2016-09-07
 */
@Service
@Transactional(readOnly = true)
public class OaCommissionService extends CrudService<OaCommissionDao, OaCommission> {
	@Autowired
    private ContractDao contractDao;

	@Autowired
	private BonusRecordDao bonusRecordDao;

	public OaCommission get(String id) {
		return super.get(id);
	}
	
	public List<OaCommission> findList(OaCommission oaCommission) {
		return super.findList(oaCommission);
	}
	
	public Page<OaCommission> findPage(Page<OaCommission> page, OaCommission oaCommission) {
		return super.findPage(page, oaCommission);
	}
	
	@Transactional(readOnly = false)
	public void save(OaCommission oaCommission) {
		super.save(oaCommission);
	}
	
	@Transactional(readOnly = false)
	public void delete(OaCommission oaCommission) {
		super.delete(oaCommission);
	}


	@Transactional(readOnly = false)
	public void saveBonusRecord(String contractId, Map<String, Object> map) throws ParseException {
		Contract contract = contractDao.get(contractId);

		if(map.get("customerCost")!=null)
			contract.setCustomerCost(Double.parseDouble(map.get("customerCost").toString()));

		if(map.get("stockInAmount")!=null)
			contract.setStockInAmount(Double.parseDouble(map.get("stockInAmount").toString()));

		if(map.get("returningAmount")!=null)
			contract.setReturningAmount(Double.parseDouble(map.get("returningAmount").toString()));

		if(map.get("discount")!=null)
			contract.setDiscount(Double.parseDouble(map.get("discount").toString()));

		if(map.get("performancePercentage")!=null)
			contract.setPerformancePercentage(Double.parseDouble(map.get("performancePercentage").toString()));

		//更新合同
		contract.preUpdate();
		contractDao.update(contract);

		List<Map<String, Object>> bonusRecords = Lists.newArrayList();
		if(map.get("bonusRecords")!=null)
		{
			bonusRecords = (List<Map<String, Object>>)map.get("bonusRecords");
		}

		//删除存在的数据
		BonusRecord filter = new BonusRecord();
		filter.setContractId(contractId);
		List<BonusRecord> existRecords = bonusRecordDao.findList(filter);
		for(BonusRecord record : existRecords){
			bonusRecordDao.delete(record);
		}

		//增加新数据
		SimpleDateFormat sdf =   new SimpleDateFormat( "yyyy-MM-dd" );
		Integer sort = 1;
		for(Map<String, Object> record: bonusRecords){
			BonusRecord newRecord = new BonusRecord();
			newRecord.setBonus(Double.parseDouble(record.get("bonus").toString()));
			newRecord.setBonusDate(sdf.parse(record.get("bonusDate").toString()));
			newRecord.setSort(sort);
			newRecord.setContractId(contractId);
			sort++;
			newRecord.preInsert();
			bonusRecordDao.insert(newRecord);
		}
	}

	public List<BonusRecord> getBonusRecords(String contractId) {
		BonusRecord filter = new BonusRecord();
		filter.setContractId(contractId);
		return bonusRecordDao.findList(filter);
	}
}