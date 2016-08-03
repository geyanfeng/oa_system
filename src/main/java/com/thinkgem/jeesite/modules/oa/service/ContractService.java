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
import com.thinkgem.jeesite.modules.oa.entity.ContractAttachment;
import com.thinkgem.jeesite.modules.oa.dao.ContractAttachmentDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractProduct;
import com.thinkgem.jeesite.modules.oa.dao.ContractProductDao;

/**
 * 各种合同Service
 * @author anthony
 * @version 2016-08-03
 */
@Service
@Transactional(readOnly = true)
public class ContractService extends CrudService<ContractDao, Contract> {

	@Autowired
	private ContractDao contractDao;
	@Autowired
	private ContractProductDao contractProductDao;
	@Autowired
	private ContractAttachmentDao contractAttachmentDao;
	
	public Contract get(String id) {
		Contract contract = super.get(id);
		contract.setContractAttachmentList(contractAttachmentDao.findList(new ContractAttachment(contract)));
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
		for (ContractAttachment contractAttachment : contract.getContractAttachmentList()){
			if (contractAttachment.getId() == null){
				continue;
			}
			if (ContractAttachment.DEL_FLAG_NORMAL.equals(contractAttachment.getDelFlag())){
				if (StringUtils.isBlank(contractAttachment.getId())){
					contractAttachment.setContractId(contract);
					contractAttachment.preInsert();
					contractAttachmentDao.insert(contractAttachment);
				}else{
					contractAttachment.preUpdate();
					contractAttachmentDao.update(contractAttachment);
				}
			}else{
				contractAttachmentDao.delete(contractAttachment);
			}
		}
		for (ContractProduct contractProduct : contract.getContractProductList()){
			if (contractProduct.getId() == null){
				continue;
			}
			if (ContractProduct.DEL_FLAG_NORMAL.equals(contractProduct.getDelFlag())){
				if (StringUtils.isBlank(contractProduct.getId())){
					contractProduct.setOa_contract(contract);
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
		contractAttachmentDao.delete(new ContractAttachment(contract));
		contractProductDao.delete(new ContractProduct(contract));
	}

	public Contract getByName(String name) {
		return contractDao.getByName(name);
	}
}