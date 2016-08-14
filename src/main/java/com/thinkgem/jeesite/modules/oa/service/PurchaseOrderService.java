/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.ContractProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderDao;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrderProduct;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderProductDao;

/**
 * 采购订单Service
 * @author anthony
 * @version 2016-08-13
 */
@Service
@Transactional(readOnly = true)
public class PurchaseOrderService extends CrudService<PurchaseOrderDao, PurchaseOrder> {

	@Autowired
	private ActTaskService actTaskService;
	@Autowired
	private PurchaseOrderProductDao purchaseOrderProductDao;
	@Autowired
	private PurchaseOrderDao purchaseOrderDao;
	@Autowired
	private ContractService contractService;
	public PurchaseOrder getByProcInsId(String procInsId) {
		return purchaseOrderDao.getByProcInsId(procInsId);
	}
	
	public PurchaseOrder get(String id) {
		PurchaseOrder purchaseOrder = super.get(id);
		purchaseOrder.setPurchaseOrderProductList(purchaseOrderProductDao.findList(new PurchaseOrderProduct(purchaseOrder)));
		return purchaseOrder;
	}
	
	public List<PurchaseOrder> findList(PurchaseOrder purchaseOrder) {
		return super.findList(purchaseOrder);
	}
	
	public Page<PurchaseOrder> findPage(Page<PurchaseOrder> page, PurchaseOrder purchaseOrder) {
		return super.findPage(page, purchaseOrder);
	}
	
	@Transactional(readOnly = false)
	public void save(PurchaseOrder purchaseOrder) {
		Integer sort = 1;

		Contract contract = getContract(purchaseOrder.getContract().getId());
		//设置订单号
		setNo(purchaseOrder);
		super.save(purchaseOrder);
		for (PurchaseOrderProduct purchaseOrderProduct : purchaseOrder.getPurchaseOrderProductList()){
			purchaseOrderProduct.setSort(sort);
			sort++;

			if (purchaseOrderProduct.getId() == null){
				continue;
			}
			if(StringUtils.isBlank(purchaseOrderProduct.getProductType())|| StringUtils.isBlank(purchaseOrderProduct.getUnit())) {
				//得到合同产品
				ContractProduct contractProduct = getContractProduct(contract, purchaseOrderProduct.getContractProductId());
				if (contractProduct == null) continue;
				//设置产品类型
				purchaseOrderProduct.setProductType(contractProduct.getProductType().getId());
				//设置产品单位
				purchaseOrderProduct.setUnit(contractProduct.getUnit());
			}
			//计算金额
			purchaseOrderProduct.setAmount(purchaseOrderProduct.getNum() * purchaseOrderProduct.getPrice());

			if (PurchaseOrderProduct.DEL_FLAG_NORMAL.equals(purchaseOrderProduct.getDelFlag())){
				if (StringUtils.isBlank(purchaseOrderProduct.getId())){
					purchaseOrderProduct.setPurchaseOrder(purchaseOrder);
					purchaseOrderProduct.preInsert();
					purchaseOrderProductDao.insert(purchaseOrderProduct);
				}else{
					purchaseOrderProduct.preUpdate();
					purchaseOrderProductDao.update(purchaseOrderProduct);
				}
			}else{
				purchaseOrderProductDao.delete(purchaseOrderProduct);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(PurchaseOrder purchaseOrder) {
		super.delete(purchaseOrder);
		purchaseOrderProductDao.delete(new PurchaseOrderProduct(purchaseOrder));
	}

	public Integer getCountByNoPref(String noPref) {
		return purchaseOrderDao.getCountByNoPref(noPref);
	}

	//设置订单号
	public void setNo(PurchaseOrder purchaseOrder){
		if(StringUtils.isBlank(purchaseOrder.getId())) {
			SimpleDateFormat dateFormater = new SimpleDateFormat("yyyyMMdd");
			String noPref = String.format("%s", dateFormater.format(new Date()));
			Integer count;
			count = getCountByNoPref(noPref);
			purchaseOrder.setNo(String.format("%s%d",noPref,count+1));
		}
	}

	private Contract getContract(String contractId){
		return contractService.get(contractId);
	}

	private ContractProduct getContractProduct(Contract contract, String contractProductId){
		for (ContractProduct contractProduct: contract.getContractProductList()){
			if(contractProduct.getChilds().size() == 0 && contractProduct.getId().equals(contractProductId))
				return contractProduct;
			else{
				for (ContractProduct contractChildProduct : contractProduct.getChilds()){
					if(contractChildProduct.getId().equals(contractProductId))
						return contractChildProduct;
				}
			}
		}
		return null;
	}
}