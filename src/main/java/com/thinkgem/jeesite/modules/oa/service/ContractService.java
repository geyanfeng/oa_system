/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.ContractAttachmentDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractProductDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.ContractAttachment;
import com.thinkgem.jeesite.modules.oa.entity.ContractProduct;
import com.thinkgem.jeesite.modules.oa.entity.TestAudit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * 各种合同Service
 * @author anthony
 * @version 2016-08-03
 */
@Service
@Transactional(readOnly = true)
public class ContractService extends CrudService<ContractDao, Contract> {

	@Autowired
	private ActTaskService actTaskService;
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private ContractProductDao contractProductDao;
	@Autowired
	private ContractAttachmentDao contractAttachmentDao;

	public TestAudit getByProcInsId(String procInsId) {
		return contractDao.getByProcInsId(procInsId);
	}
	
	public Contract get(String id) {
		Contract contract = super.get(id);
		contract.setContractAttachmentList(contractAttachmentDao.findList(new ContractAttachment(contract)));
		List<ContractProduct> productList = contractProductDao.findList(new ContractProduct(contract));
		List<ContractProduct> parentProductList = new ArrayList<ContractProduct>();
		for (ContractProduct product: productList) {
			if(product.getParentId() == null || product.getParentId()==""){
				List<ContractProduct> childProductList = new ArrayList<ContractProduct>();
				for (ContractProduct cproduct: productList) {
					if(cproduct.getParentId() !=null && cproduct.getParentId().equals(product.getId()))
						childProductList.add(cproduct);
				}
				product.setChilds(childProductList);
				parentProductList.add(product);
			}
		}
		contract.setContractProductList(parentProductList);
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

		Integer sort=1;
		for (ContractProduct contractProduct : contract.getContractProductList()){
			contractProduct.setSort(sort);
			sort++;
			if (contractProduct.getId() == null){
				continue;
			}
			//删除子商品
			Integer childSort = 1;
			for (ContractProduct childProduct: contractProduct.getChilds()){
				childProduct.setSort(childSort);
				childSort++;
				if (childProduct.getId() == null){
					continue;
				}

				if (!childProduct.DEL_FLAG_NORMAL.equals(childProduct.getDelFlag())){
					contractProductDao.delete(childProduct);
				}
			}

			if (ContractProduct.DEL_FLAG_NORMAL.equals(contractProduct.getDelFlag())){
				if (StringUtils.isBlank(contractProduct.getId())){
					contractProduct.setContract(contract);
					contractProduct.preInsert();
					contractProductDao.insert(contractProduct);
				}else{
					contractProduct.preUpdate();
					contractProductDao.update(contractProduct);
				}
			}else{
				//删除下面所有的子商品
				for (ContractProduct childProduct: contractProduct.getChilds()){
						contractProductDao.delete(childProduct);
				}
				contractProductDao.delete(contractProduct);
			}
			//增加或修改子商品
			for (ContractProduct childProduct: contractProduct.getChilds()){
				if (childProduct.getId() == null){
					continue;
				}

				if (childProduct.DEL_FLAG_NORMAL.equals(childProduct.getDelFlag())){
					if (StringUtils.isBlank(childProduct.getId())){
						childProduct.setContract(contract);
						childProduct.setParentId(contractProduct.getId());
						childProduct.preInsert();
						contractProductDao.insert(childProduct);
					}else{
					/*	childProduct.setContract(contract);
						childProduct.setParentId(contractProduct.getId());*/
						childProduct.preUpdate();
						contractProductDao.update(childProduct);
					}
				}
			}
		}

		for (ContractAttachment contractAttachment : contract.getContractAttachmentList()){
			if (contractAttachment.getId() == null){
				continue;
			}
			if (ContractAttachment.DEL_FLAG_NORMAL.equals(contractAttachment.getDelFlag())){
				if (StringUtils.isBlank(contractAttachment.getId())){
					contractAttachment.setContract(contract);
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

	@Transactional(readOnly = false)
	public void audit(Contract contract) {
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = contract.getAct().getTaskDefKey();
		String flag= contract.getAct().getFlag();

		if("submit_audit".equals(taskDefKey)){
			contract.getAct().setComment("提交审批");
			actTaskService.startProcess(ActUtils.PD_CONTRAT_AUDIT[0], ActUtils.PD_CONTRAT_AUDIT[1], contract.getId(), contract.getName());
		}
	}
}