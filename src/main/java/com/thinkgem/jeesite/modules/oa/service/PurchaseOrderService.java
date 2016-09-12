/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.Encodes;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActProcessService;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.*;
import com.thinkgem.jeesite.modules.oa.entity.*;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;
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
	private ActProcessService actProcessService;
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
	@Autowired
	private PurchaseOrderFinanceDao purchaseOrderFinanceDao;

	public PurchaseOrder getByProcInsId(String procInsId) {
		return purchaseOrderDao.getByProcInsId(procInsId);
	}
	
	public PurchaseOrder get(String id) {
		PurchaseOrder purchaseOrder = super.get(id);
		purchaseOrder.setPurchaseOrderProductList(purchaseOrderProductDao.findList(new PurchaseOrderProduct(purchaseOrder)));
		purchaseOrder.setPurchaseOrderAttachmentList(purchaseOrderAttachmentDao.findList(new PurchaseOrderAttachment(purchaseOrder)));
		purchaseOrder.setPurchaseOrderFinanceList(purchaseOrderFinanceDao.findList(new PurchaseOrderFinance(purchaseOrder)));
		return purchaseOrder;
	}
	
	public List<PurchaseOrder> findList(PurchaseOrder purchaseOrder) {
		return super.findList(purchaseOrder);
	}
	
	public Page<PurchaseOrder> findPage(Page<PurchaseOrder> page, PurchaseOrder purchaseOrder) {
		return super.findPage(page, purchaseOrder);
	}
	
	@Transactional(readOnly = false)
	public void common_save(PurchaseOrder purchaseOrder) {
		super.save(purchaseOrder);
	}
	
	@Transactional(readOnly = false)
	public void save(PurchaseOrder purchaseOrder) {
		Integer sort = 1;
		Double amount = 0.00;

		boolean isNew = purchaseOrder.getIsNewRecord();

		//设置订单号
		setNo(purchaseOrder);
		if(purchaseOrder.getAmount()==null)
			purchaseOrder.setAmount(0.00);
		if(purchaseOrder.getStatus()==null)
			purchaseOrder.setStatus("0");
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
		//保存财务数据
		saveFinance(purchaseOrder);
		//更新订单
		super.save(purchaseOrder);

	/*	//启动流程审核
		if(isNew) {
			purchaseOrder.getAct().setFlag("submit_audit");
			audit(purchaseOrder);
		}*/
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

	/*
保存财务相关的数据
 */
	@Transactional(readOnly = false)
	public void saveFinance(PurchaseOrder purchaseOrder) {
		//删除数据
		purchaseOrderFinanceDao.delete(new PurchaseOrderFinance(purchaseOrder));
		//如果收款数据为空, 不增加新的付款数据
		if (isBlank(purchaseOrder.getPaymentDetail())) {
			return;
		}
		//解码
		String paymentDetail = Encodes.unescapeHtml(purchaseOrder.getPaymentDetail());
		if (paymentDetail.contains("&quot;"))
			paymentDetail = Encodes.unescapeHtml(paymentDetail);

		Object payment = JsonMapper.getInstance().fromJson(paymentDetail, Object.class);

		List<Map<String, Object>> paymentList = (List<Map<String, Object>>) payment;
		int sort = 1;
		List<PurchaseOrderFinance> financeList = Lists.newArrayList();
		for (Map<String, Object> paymentObj : paymentList) {
			PurchaseOrderFinance purchaseOrderFinance = new PurchaseOrderFinance(purchaseOrder);
			purchaseOrderFinance.setPayMethod(paymentObj.get("payment_installment_paymentMethod").toString());
			purchaseOrderFinance.setZq(Integer.parseInt(paymentObj.get("payment_installment_time").toString()));
			purchaseOrderFinance.setAmount(Double.parseDouble(paymentObj.get("payment_installment_amount").toString()));
			purchaseOrderFinance.setPayCondition(Integer.parseInt(paymentObj.get("payment_installment_condition").toString()));
			purchaseOrderFinance.setSort(sort);
			purchaseOrderFinance.setStatus(1);
			purchaseOrderFinance.preInsert();
			purchaseOrderFinanceDao.insert(purchaseOrderFinance);
			financeList.add(purchaseOrderFinance);
			sort++;
		}
		purchaseOrder.setPurchaseOrderFinanceList(financeList);
	}
	
	@Transactional(readOnly = false)
	public void delete(PurchaseOrder purchaseOrder) {
		if(isNotBlank(purchaseOrder.getProcInsId())){
			actProcessService.deleteProcIns(purchaseOrder.getProcInsId(),"删除");
		}
		for(PurchaseOrderProduct purchaseOrderProduct : purchaseOrder.getPurchaseOrderProductList()){
			//得到合同产品
			ContractProduct contractProduct = contractProductDao.get(purchaseOrderProduct.getContractProductId());
			//修改合同产品已发货数
			contractProduct.setHasSendNum(contractProduct.getHasSendNum() - purchaseOrderProduct.getNum());
			contractProduct.preUpdate();
			contractProductDao.update(contractProduct);
		}
		purchaseOrderProductDao.delete(new PurchaseOrderProduct(purchaseOrder));
		super.delete(purchaseOrder);
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

	/*
	技术验收后更新预付款日期
	 */
	private void updatePlanPayDate(PurchaseOrder purchaseOrder) {
		PurchaseOrderFinance filter = new PurchaseOrderFinance(purchaseOrder,1);//过滤还没有付款的数据
		List<PurchaseOrderFinance> finances = purchaseOrderFinanceDao.findList(filter);

		if(finances.size()==0)
			return;
		PurchaseOrderFinance poFinance = finances.get(0);
		Calendar cc = Calendar.getInstance();
		cc.add(Calendar.DATE, poFinance.getZq());
		poFinance.setPlanPayDate(cc.getTime());
		poFinance.preUpdate();
		purchaseOrderFinanceDao.update(poFinance);
	}

	/*
	财务付款确认后更新财务付款数据
	 */
	private void updateFinancePayment(PurchaseOrder purchaseOrder){
		PurchaseOrderFinance filter = new PurchaseOrderFinance(purchaseOrder,1);//过滤还没有付款的数据
		List<PurchaseOrderFinance> finances = purchaseOrderFinanceDao.findList(filter);

		if(finances.size()==0)
			return;
		PurchaseOrderFinance poFinance = finances.get(0);

		poFinance.setPayDate(purchaseOrder.getFkDate());
		poFinance.setStatus(2);//更新状态为已付款

		poFinance.preUpdate();
		purchaseOrderFinanceDao.update(poFinance);
	}

	/*
    检查是否都付款
     */
	private boolean checkSK(PurchaseOrder purchaseOrder){
		PurchaseOrderFinance filter = new PurchaseOrderFinance(purchaseOrder, 1);
		List<PurchaseOrderFinance> finances = purchaseOrderFinanceDao.findList(filter);
		if(finances.size()>0)
			return false;
		else
			return true;
	}

	@Transactional(readOnly = false)
	public void audit(PurchaseOrder purchaseOrder) {
		// 对不同环节的业务逻辑进行操作
		String taskDefKey = purchaseOrder.getAct().getTaskDefKey();
		String flag = purchaseOrder.getAct().getFlag();
		Boolean pass = false;
		Contract contract = contractDao.get(purchaseOrder.getContract().getId());

		if (isBlank(taskDefKey) && "submit_audit".equals(flag)) {
			// 设置流程变量
			Map<String, Object> vars = Maps.newHashMap();
			vars.put("business_person", contract.getBusinessPerson().getName());//商务人员
			vars.put("artisan", contract.getArtisan().getName());//技术人员
			vars.put("payment_num", purchaseOrder.getPurchaseOrderFinanceList().size());//支付次数
			vars.put("contract_no", contract.getNo());
			vars.put("contract_name", contract.getName());
			vars.put("po_no", purchaseOrder.getNo());
			if(purchaseOrder.getPurchaseOrderFinanceList().size() == 1){
				vars.put("zq", purchaseOrder.getPurchaseOrderFinanceList().get(0).getZq());//如果为一次付款,写入帐期数
			}
			//purchaseOrder.getAct().setComment("商务下单");
			actTaskService.startProcess(ActUtils.PD_PO_AUDIT[0], ActUtils.PD_PO_AUDIT[1], purchaseOrder.getId(), purchaseOrder.getNo(), vars);
			purchaseOrder.setStatus(DictUtils.getDictValue("待下单", "oa_po_status", ""));
		} else {
			Map<String, Object> vars = Maps.newHashMap();
			String comment = purchaseOrder.getAct().getComment();
			if (StringUtils.isNotBlank(flag) && ("yes".equals(flag) || "no".equals(flag))) {
				pass = "yes".equals(purchaseOrder.getAct().getFlag());
				comment = (pass ? "[同意] " : "[驳回] ") + (StringUtils.isNotBlank(comment) ? comment : "");
				purchaseOrder.getAct().setComment(comment);
				vars.put("pass", pass ? "1" : "0");
			}

			//自动执行签收
			String[] autoQSTask = {"cfo_confirm_payment_1","cfo_confirm_payment_2", "cfo_confirm_payment_3", "payment_first", "payment_all", "payment"};
			if( Arrays.asList(autoQSTask).contains(taskDefKey)){
				actTaskService.claim(purchaseOrder.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
			}

			if("payment_first".equals(taskDefKey) || "payment_all".equals(taskDefKey) || "payment".equals(taskDefKey)){//付款
				updateFinancePayment(purchaseOrder);//更新财务付款数据
				if("payment".equals(taskDefKey)){
					vars.put("finishPayment",checkSK(purchaseOrder)? 1:0 );//检查是否已经全部付款并将变量写入到流程中
				}

			} else if("verify_ship_1".equals(taskDefKey) || "verify_ship_2".equals(taskDefKey)){//确认发货
				if("verify_ship_1".equals(taskDefKey))
					updatePlanPayDate(purchaseOrder);//更新预付款时间
			}

			updatePoStatus(purchaseOrder, taskDefKey, pass);//更新订单状态

			purchaseOrder.preUpdate();
			purchaseOrderDao.update(purchaseOrder);
			actTaskService.complete(purchaseOrder.getAct().getTaskId(), purchaseOrder.getAct().getProcInsId(), purchaseOrder.getAct().getComment(), vars);

			//自动合同的审核
			if("business_person_createbill".equals(taskDefKey)) {//商务下单
				autoFinishContractTask(20, contract, "business_person_createbill");
			}
		}
	}

	/*
	修改订单状态
	 */
	private void updatePoStatus(PurchaseOrder purchaseOrder, String taskDefKey, boolean pass){
		if("business_person_createbill".equals(taskDefKey)) {//商务下单
			if(purchaseOrder.getPurchaseOrderFinanceList().size() == 1){//一次付款
				if(purchaseOrder.getPurchaseOrderFinanceList().get(0).getZq()<=0)//0帐期
					purchaseOrder.setStatus(DictUtils.getDictValue("已下单待审核", "oa_po_status", ""));
				else
					purchaseOrder.setStatus(DictUtils.getDictValue("已下单待发货", "oa_po_status", ""));
			}
			else//多次付款
				purchaseOrder.setStatus(DictUtils.getDictValue("已下单待审核", "oa_po_status", ""));
		}
		else if("cfo_confirm_payment_1".equals(taskDefKey) || "cfo_confirm_payment_2".equals(taskDefKey) || "cfo_confirm_payment_2".equals(taskDefKey)){//财务总监确认可付款
			purchaseOrder.setStatus(DictUtils.getDictValue("已审核待付款","oa_po_status",""));
		}
		else if("payment_first".equals(taskDefKey) || "payment_all".equals(taskDefKey) || "payment".equals(taskDefKey)){//付款
			if("payment_first".equals(taskDefKey) || "payment_all".equals(taskDefKey)){
				purchaseOrder.setStatus(DictUtils.getDictValue("已付款待发货","oa_po_status",""));
			} else{//payment
				if(checkSK(purchaseOrder)){
					purchaseOrder.setStatus(DictUtils.getDictValue("已付款已完成","oa_po_status",""));
				} else{
					purchaseOrder.setStatus(DictUtils.getDictValue("已付款待审核","oa_po_status",""));
				}
			}
		} else if("verify_ship_1".equals(taskDefKey) || "verify_ship_2".equals(taskDefKey)){//商务确认发货
			purchaseOrder.setStatus(DictUtils.getDictValue("已发货待验收","oa_po_status",""));
		}
		else if("verify_ship_1".equals(taskDefKey) || "verify_ship_2".equals(taskDefKey)){//技术确认验收
			if(!pass){
				purchaseOrder.setStatus(DictUtils.getDictValue("已付款待发货","oa_po_status",""));
			} else{
				if("verify_ship_1".equals(taskDefKey)){
					purchaseOrder.setStatus(DictUtils.getDictValue("已验收待审核","oa_po_status",""));
				} else{
					purchaseOrder.setStatus(DictUtils.getDictValue("已验收已完成","oa_po_status",""));
				}
			}
		}
	}

	public List<PurchaseOrder> getPoListByContractId(String contractId) {
		List<PurchaseOrder> purchaseOrderList = purchaseOrderDao.getPoListByContractId(contractId);
		for (PurchaseOrder purchaseOrder: purchaseOrderList){
			purchaseOrder.setPurchaseOrderProductList(purchaseOrderProductDao.findList(new PurchaseOrderProduct(purchaseOrder)));
			purchaseOrder.setPurchaseOrderAttachmentList(purchaseOrderAttachmentDao.findList(new PurchaseOrderAttachment(purchaseOrder)));
			purchaseOrder.setPurchaseOrderFinanceList(purchaseOrderFinanceDao.findList(new PurchaseOrderFinance(purchaseOrder)));
		}
		return purchaseOrderList;
	}

	//自动完成合同的状态
	private void autoFinishContractTask(Integer poStatus, Contract contract, String taskDefKey){
		List<PurchaseOrder> poList = getPoListByContractId(contract.getId());
		for(PurchaseOrder po: poList){
			if(isBlank(po.getStatus()) || new Integer(po.getStatus())< poStatus)
				return;
		}
		ProcessInstance processInstance = actTaskService.getProcIns(contract.getProcInsId());
		if(processInstance==null)return;
		Task contractTask =actTaskService.getCurrentTaskInfo(processInstance);
		if(contractTask == null) return ;
		/*Task contractTask = contract.getAct().getTask();*/
		if(isNotBlank(contractTask.getTaskDefinitionKey()) && taskDefKey.equals(contractTask.getTaskDefinitionKey())){
			contract.setStatus(DictUtils.getDictValue("已下单","oa_contract_status",""));
			contract.preUpdate();
			contractDao.update(contract);
			actTaskService.complete(contractTask.getId(), contract.getAct().getProcInsId(),"", (Map<String, Object>)contract.getAct().getVars());
		}
	}
}