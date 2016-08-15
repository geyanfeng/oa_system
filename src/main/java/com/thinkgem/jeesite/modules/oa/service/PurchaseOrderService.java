/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.dao.ContractProductDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderProductDao;
import com.thinkgem.jeesite.modules.oa.entity.ContractProduct;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrderProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
	private ContractProductDao contractProductDao;

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
		Double amount = 0.00;

		//设置订单号
		setNo(purchaseOrder);
		super.save(purchaseOrder);

		for (PurchaseOrderProduct purchaseOrderProduct : purchaseOrder.getPurchaseOrderProductList()) {
			purchaseOrderProduct.setSort(sort);
			sort++;

			if (purchaseOrderProduct.getId() == null) {
				continue;
			}

			//得到合同产品
			ContractProduct contractProduct = contractProductDao.get(purchaseOrderProduct.getContractProductId());
			if (contractProduct == null) continue;
			//设置产品类型
			if (StringUtils.isBlank(purchaseOrderProduct.getProductType()))
				purchaseOrderProduct.setProductType(contractProduct.getProductType().getId());
			//设置产品单位
			if (StringUtils.isBlank(purchaseOrderProduct.getUnit()))
				purchaseOrderProduct.setUnit(contractProduct.getUnit());

			//计算金额
			purchaseOrderProduct.setAmount(purchaseOrderProduct.getNum() * purchaseOrderProduct.getPrice());

			if (PurchaseOrderProduct.DEL_FLAG_NORMAL.equals(purchaseOrderProduct.getDelFlag())) {
				if (StringUtils.isBlank(purchaseOrderProduct.getId())) {
					//修改合同产品已发货数
					contractProduct.setHasSendNum(contractProduct.getHasSendNum()+ purchaseOrderProduct.getNum());
					//更新金额
					purchaseOrder.setAmount(purchaseOrder.getAmount()+ purchaseOrderProduct.getAmount());
					purchaseOrderProduct.setPurchaseOrder(purchaseOrder);
					purchaseOrderProduct.preInsert();
					purchaseOrderProductDao.insert(purchaseOrderProduct);
				} else {
					//修改合同产品已发货数
					PurchaseOrderProduct oldPoProduct = purchaseOrderProductDao.get(purchaseOrderProduct.getId());
					contractProduct.setHasSendNum(contractProduct.getHasSendNum() + (purchaseOrderProduct.getNum() - oldPoProduct.getNum()));
					//更新金额
					purchaseOrder.setAmount(purchaseOrder.getAmount()+ (purchaseOrderProduct.getAmount() - oldPoProduct.getAmount()));
					purchaseOrderProduct.preUpdate();
					purchaseOrderProductDao.update(purchaseOrderProduct);
				}
			} else {
				//修改合同产品已发货数
				contractProduct.setHasSendNum(contractProduct.getHasSendNum() - purchaseOrderProduct.getNum());
				//更新金额
				purchaseOrder.setAmount(purchaseOrder.getAmount() - purchaseOrderProduct.getAmount());
				purchaseOrderProductDao.delete(purchaseOrderProduct);
			}
			//更新合同产品
			contractProduct.preUpdate();
			contractProductDao.update(contractProduct);
		}
		//更新订单
		super.save(purchaseOrder);
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
}