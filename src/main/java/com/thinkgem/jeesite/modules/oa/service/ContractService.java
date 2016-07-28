/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractProduct;
import com.thinkgem.jeesite.modules.oa.dao.ContractProductDao;

/**
 * 各种合同Service
 * @author anthony
 * @version 2016-07-28
 */
@Service
@Transactional(readOnly = true)
public class ContractService extends CrudService<ContractDao, Contract> {

	@Autowired
	private ContractProductDao contractProductDao;
	
	public Contract get(String id) {
		Contract contract = super.get(id);
		contract.setContractProductList(contractProductDao.findList(new ContractProduct(contract)));
		return contract;
	}
	
	public List<Contract> findList(Contract contract) {
		return super.findList(contract);
	}
	
	public Page<Contract> findPage(Page<Contract> page, Contract contract) {
		return super.findPage(page, contract);
	}
	
	@Transactional(readOnly = false)
	public void save(Contract contract) {
		super.save(contract);
		for (ContractProduct contractProduct : contract.getContractProductList()){
			if (contractProduct.getId() == null){
				continue;
			}
			if (ContractProduct.DEL_FLAG_NORMAL.equals(contractProduct.getDelFlag())){
				if (StringUtils.isBlank(contractProduct.getId())){
					contractProduct.setContractId(contract);
					contractProduct.preInsert();
					contractProductDao.insert(contractProduct);
				}else{
					contractProduct.preUpdate();
					contractProductDao.update(contractProduct);
				}
			}else{
				contractProductDao.delete(contractProduct);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(Contract contract) {
		super.delete(contract);
		contractProductDao.delete(new ContractProduct(contract));
	}
	
}