/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import com.thinkgem.jeesite.modules.act.service.ActTaskService;
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
		super.save(purchaseOrder);
		for (PurchaseOrderProduct purchaseOrderProduct : purchaseOrder.getPurchaseOrderProductList()){
			if (purchaseOrderProduct.getId() == null){
				continue;
			}
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
	
}