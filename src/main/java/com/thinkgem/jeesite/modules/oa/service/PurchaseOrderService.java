/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.*;
import com.thinkgem.jeesite.modules.oa.entity.*;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.jasig.cas.client.util.CommonUtils.isBlank;

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
	@Autowired
	private ContractDao contractDao;
	@Autowired
	private PurchaseOrderAttachmentDao purchaseOrderAttachmentDao;

	public PurchaseOrder getByProcInsId(String procInsId) {
		return purchaseOrderDao.getByProcInsId(procInsId);
	}
	
	public PurchaseOrder get(String id) {
		PurchaseOrder purchaseOrder = super.get(id);
		purchaseOrder.setPurchaseOrderProductList(purchaseOrderProductDao.findList(new PurchaseOrderProduct(purchaseOrder)));
		purchaseOrder.setPurchaseOrderAttachmentList(purchaseOrderAttachmentDao.findList(new PurchaseOrderAttachment(purchaseOrder)));
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
		if(purchaseOrder.getAmount()==null)
			purchaseOrder.setAmount(0.00);
		if(purchaseOrder.getStatus()==null)
			purchaseOrder.setStatus("40");
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
			if (purchaseOrderProduct.getProductType() == null || StringUtils.isBlank(purchaseOrderProduct.getProductType().getId())) {
				purchaseOrderProduct.setProductType(new ProductType(contractProduct.getProductType().getId()));
			}
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

		//保存附件
		saveAttachments(purchaseOrder);
		//更新订单
		super.save(purchaseOrder);

		//启动流程审核
		purchaseOrder.getAct().setFlag("submit_audit");
		audit(purchaseOrder);
	}

	public void saveAttachments(PurchaseOrder purchaseOrder){
		for (PurchaseOrderAttachment purchaseOrderAttachment : purchaseOrder.getPurchaseOrderAttachmentList()) {
			if (purchaseOrderAttachment.getId() == null) {
				continue;
			}
			if (ContractAttachment.DEL_FLAG_NORMAL.equals(purchaseOrderAttachment.getDelFlag())) {
				if (StringUtils.isBlank(purchaseOrderAttachment.getId())) {
					purchaseOrderAttachment.setPurchaseOrder(purchaseOrder);
					purchaseOrderAttachment.preInsert();
					purchaseOrderAttachmentDao.insert(purchaseOrderAttachment);
				} else {
					purchaseOrderAttachment.preUpdate();
					purchaseOrderAttachmentDao.update(purchaseOrderAttachment);
				}
			} else {
				purchaseOrderAttachmentDao.delete(purchaseOrderAttachment);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(PurchaseOrder purchaseOrder) {
		super.delete(purchaseOrder);
		for(PurchaseOrderProduct purchaseOrderProduct : purchaseOrder.getPurchaseOrderProductList()){
			//得到合同产品
			ContractProduct contractProduct = contractProductDao.get(purchaseOrderProduct.getContractProductId());
			//修改合同产品已发货数
			contractProduct.setHasSendNum(contractProduct.getHasSendNum() - purchaseOrderProduct.getNum());
			contractProduct.preUpdate();
			contractProductDao.update(contractProduct);
		}
		purchaseOrderProductDao.delete(new PurchaseOrderProduct(purchaseOrder));
	}

	public Integer getCountByNoPref(String noPref) {
		return purchaseOrderDao.getCountByNoPref(noPref);
	}

	//设置订单号"订单编号为[合同编号]-PO[两位数编号]"
	public void setNo(PurchaseOrder purchaseOrder){
		if(StringUtils.isBlank(purchaseOrder.getId())) {
			//得到合同编号
			String contractNo = purchaseOrder.getContract().getNo();
			if(isBlank(contractNo)){
				Contract contract = contractDao.get(purchaseOrder.getContract().getId());
				contractNo = contract.getNo();
			}
			String noPref = String.format("%s-PO", contractNo);
			Integer count;
			count = getCountByNoPref(noPref);
			purchaseOrder.setNo(String.format("%s%d",noPref,count+1));
		}
	}

	@Transactional(readOnly = false)
	public void audit(PurchaseOrder purchaseOrder) {
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = purchaseOrder.getAct().getTaskDefKey();
		String flag = purchaseOrder.getAct().getFlag();
		Boolean pass = false;
		Contract contract = contractDao.get(purchaseOrder.getContract().getId());

		if (isBlank(taskDefKey) && "submit_audit".equals(flag)) {
			//更新订单状态
			purchaseOrder.setStatus(DictUtils.getDictValue("已下单","oa_po_status",""));
			purchaseOrder.preUpdate();
			purchaseOrderDao.update(purchaseOrder);
			// 设置流程变量
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("business_person", contract.getBusinessPerson().getName());
			vars.put("artisan", contract.getArtisan().getName());
			purchaseOrder.getAct().setComment("商务下单");
			actTaskService.startProcess(ActUtils.PD_PO_AUDIT[0], ActUtils.PD_PO_AUDIT[1], purchaseOrder.getId(), purchaseOrder.getNo(), vars);
		} else {
			Map<String, Object> vars = Maps.newHashMap();
			String comment = purchaseOrder.getAct().getComment();
			if (StringUtils.isNotBlank(flag) && ("yes".equals(flag) || "no".equals(flag))) {
				pass = "yes".equals(purchaseOrder.getAct().getFlag());
				comment = (pass ? "[同意] " : "[驳回] ") + (StringUtils.isNotBlank(comment) ? comment : "");
				purchaseOrder.getAct().setComment(comment);
				vars.put("pass", pass ? "1" : "0");
			}

			if("verify_ship".equals(taskDefKey)){//确认发货
				purchaseOrder.setStatus(DictUtils.getDictValue("已发货","oa_po_status",""));
			} else if("payment".equals(taskDefKey)){//付款
				purchaseOrder.setStatus(DictUtils.getDictValue("已完成","oa_po_status",""));
			} else {
				if (StringUtils.isNotBlank(flag)) {
					if ("verify_receiving".equals(taskDefKey)) {//收货验收
						if (pass) {
							purchaseOrder.setStatus(DictUtils.getDictValue("已验收", "oa_po_status", ""));
						} else {
							purchaseOrder.setStatus(DictUtils.getDictValue("已发货", "oa_po_status", ""));
						}
					}
				}
			}

			purchaseOrder.preUpdate();
			purchaseOrderDao.update(purchaseOrder);
			actTaskService.complete(purchaseOrder.getAct().getTaskId(), purchaseOrder.getAct().getProcInsId(), purchaseOrder.getAct().getComment(), vars);
		}

	}

	public List<PurchaseOrder> getPoListByContractId(String contractId) {
		return purchaseOrderDao.getPoListByContractId(contractId);
	}
}