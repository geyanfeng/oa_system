/**
 *
 */
package com.thinkgem.jeesite.modules.oa.service;

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

import java.text.SimpleDateFormat;
import java.util.*;

import static org.apache.commons.lang3.StringEscapeUtils.unescapeHtml4;
import static org.codehaus.plexus.util.StringUtils.isBlank;
import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * 各种合同Service
 *
 * @author anthony
 * @version 2016-08-03
 */
@Service
@Transactional(readOnly = true)
public class ContractService extends CrudService<ContractDao, Contract> {

    @Autowired
    private ActTaskService actTaskService;
    @Autowired
    private ActProcessService actProcessService;
    @Autowired
    private ContractDao contractDao;
    @Autowired
    private ContractProductDao contractProductDao;
    @Autowired
    private ContractAttachmentDao contractAttachmentDao;
    @Autowired
    private ContractFinanceDao contractFinanceDao;
    @Autowired
    private ContractRecallApproveDao recallApproveDao;
    @Autowired
    private PurchaseOrderService purchaseOrderService;
    @Autowired
    private AlertService alertService;

    public Contract getByProcInsId(String procInsId) {
        return contractDao.getByProcInsId(procInsId);
    }

    public Contract get(String id) {
        Contract contract = super.get(id);
        contract.setContractAttachmentList(contractAttachmentDao.findList(new ContractAttachment(contract)));
        contract.setContractFinanceList(contractFinanceDao.findList(new ContractFinance(contract)));
        contract.setRecallApproveList(recallApproveDao.findList(new ContractRecallApprove(contract)));

        List<ContractProduct> productList = contractProductDao.findList(new ContractProduct(contract));
        List<ContractProduct> parentProductList = new ArrayList<ContractProduct>();
        for (ContractProduct product : productList) {
            if (product.getParentId() == null || product.getParentId() == "") {
                List<ContractProduct> childProductList = new ArrayList<ContractProduct>();
                for (ContractProduct cproduct : productList) {
                    if (cproduct.getParentId() != null && cproduct.getParentId().equals(product.getId()))
                        childProductList.add(cproduct);
                }
                product.setChilds(childProductList);
                parentProductList.add(product);
            }
        }
        contract.setContractProductList(parentProductList);
        //得到成本价
        getCost(contract);
        return contract;
    }

    //得到产品的成本价和合同的成本价
    public void getCost(Contract contract){
        List<PurchaseOrder> poList = purchaseOrderService.getPoListByContractId(contract.getId());
        for (ContractProduct product : contract.getContractProductList()){
            if(product.getChilds().size() > 0){
                Double parentCost = 0.00;
                for (ContractProduct childProduct: product.getChilds()){
                    childProduct.setCost(getPOProductCost(poList, childProduct.getId()));
                    parentCost = parentCost + childProduct.getCost();
                }
                product.setCost(parentCost);
                contract.setCost(contract.getCost() + parentCost);
            } else
            {
                Double productCost = getPOProductCost(poList, product.getId());
                product.setCost(productCost);
                contract.setCost(contract.getCost() + productCost);
            }
        }
    }

    //得到合同产品的成本
    private Double getPOProductCost(List<PurchaseOrder> poList, String contractProductId){
        List<PurchaseOrderProduct> poProducts = getPOProductByContractProductId(poList, contractProductId);
        if(poProducts.size() > 0){
            Double cost = 0.00;
            for (PurchaseOrderProduct poProduct: poProducts){
                cost = cost + poProduct.getAmount();
            }
           return cost;
        }
        return 0.00;
    }

    //根据合同产品id得到订单产品列表
    private List<PurchaseOrderProduct> getPOProductByContractProductId(List<PurchaseOrder> poList, String contractProductId){
        List<PurchaseOrderProduct> poProductList =  new ArrayList<PurchaseOrderProduct>();
        for(PurchaseOrder po : poList){
            for(PurchaseOrderProduct poProduct: po.getPurchaseOrderProductList()){
                if(poProduct.getContractProductId().equals(contractProductId)){
                    poProductList.add(poProduct);
                }
            }
        }
        return poProductList;
    }

    public List<Contract> findList(Contract contract) {
        return super.findList(contract);
    }

    public Page<Contract> findPage(Page<Contract> page, Contract contract) {
        return super.findPage(page, contract);
    }

    @Transactional(readOnly = false)
    public void save(Contract contract) {
        if(contract.getStatus()==null)
            contract.setStatus("0");
        super.save(contract);

        saveProducts(contract);
        saveAttachments(contract);
        saveFinance(contract);
    }

    @Transactional(readOnly = false)
    public void saveProducts(Contract contract){
        Integer sort = 1;
        for (ContractProduct contractProduct : contract.getContractProductList()) {
            contractProduct.setSort(sort);
            sort++;
            if (contractProduct.getId() == null) {
                continue;
            }
            //删除子商品
            Integer childSort = 1;
            for (ContractProduct childProduct : contractProduct.getChilds()) {
                childProduct.setSort(childSort);
                childSort++;
                if (childProduct.getId() == null) {
                    continue;
                }

                if (!childProduct.DEL_FLAG_NORMAL.equals(childProduct.getDelFlag())) {
                    contractProductDao.delete(childProduct);
                }
            }

            if (ContractProduct.DEL_FLAG_NORMAL.equals(contractProduct.getDelFlag())) {
                if (StringUtils.isBlank(contractProduct.getId())) {
                    contractProduct.setContract(contract);
                    contractProduct.preInsert();
                    contractProductDao.insert(contractProduct);
                } else {
                    contractProduct.setContract(contract);
                    contractProduct.preUpdate();
                    contractProductDao.update(contractProduct);
                }
            } else {
                //删除下面所有的子商品
                for (ContractProduct childProduct : contractProduct.getChilds()) {
                    contractProductDao.delete(childProduct);
                }
                contractProductDao.delete(contractProduct);
            }
            //增加或修改子商品
            for (ContractProduct childProduct : contractProduct.getChilds()) {
                if (childProduct.getId() == null) {
                    continue;
                }

                if (childProduct.DEL_FLAG_NORMAL.equals(childProduct.getDelFlag())) {
                    if (StringUtils.isBlank(childProduct.getId())) {
                        childProduct.setContract(contract);
                        childProduct.setParentId(contractProduct.getId());
                        childProduct.setParentId(contractProduct.getId());
                        childProduct.preInsert();
                        contractProductDao.insert(childProduct);
                    } else {
                    /*	childProduct.setContract(contract);
						childProduct.setParentId(contractProduct.getId());*/
                        childProduct.setParentId(contractProduct.getId());
                        childProduct.setContract(contract);
                        childProduct.preUpdate();
                        contractProductDao.update(childProduct);
                    }
                }
            }
        }
    }

    @Transactional(readOnly = false)
    public void saveAttachments(Contract contract){
        for (ContractAttachment contractAttachment : contract.getContractAttachmentList()) {
            if (contractAttachment.getId() == null) {
                continue;
            }
            if (ContractAttachment.DEL_FLAG_NORMAL.equals(contractAttachment.getDelFlag())) {
                if (StringUtils.isBlank(contractAttachment.getId())) {
                    contractAttachment.setContract(contract);
                    contractAttachment.preInsert();
                    contractAttachmentDao.insert(contractAttachment);
                } else {
                    contractAttachment.preUpdate();
                    contractAttachmentDao.update(contractAttachment);
                }
            } else {
                contractAttachmentDao.delete(contractAttachment);
            }
        }
    }

    /*
    保存财务相关的数据
     */
    @Transactional(readOnly = false)
    public void saveFinance(Contract contract){
        //删除数据
        contractFinanceDao.delete(new ContractFinance(contract));
        //如果收款数据为空, 不增加新的付款数据
        if(isBlank(contract.getPaymentDetail())){
            return;
        }
        //解码
        String paymentDetail = Encodes.unescapeHtml(contract.getPaymentDetail());
        if(paymentDetail.contains("&quot;"))
            paymentDetail = Encodes.unescapeHtml(paymentDetail);

/*
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root; = mapper.readTree(paymentDetail);
        }
        catch (IOException e) {
            logger.warn("parse json string error:" + paymentDetail, e);
        }*/

        Object payment = JsonMapper.getInstance().fromJson(paymentDetail, Object.class);
        if(contract.getPaymentCycle().equals("1")){//一次性付款
            Map<String, Object> paymentObj=(Map<String, Object>)payment;
            ContractFinance contractFinance = new ContractFinance(contract);
            contractFinance.setPaymentCycle(contract.getPaymentCycle());
            contractFinance.setPayMethod(paymentObj.get("payment_onetime_paymentMethod").toString());
            contractFinance.setAmount(Double.parseDouble(paymentObj.get("payment_onetime_amount").toString()));
            contractFinance.setSort(1);
            contractFinance.setStatus(1);
            contractFinance.preInsert();
            contractFinanceDao.insert(contractFinance);
        } else if(contract.getPaymentCycle().equals("2")){//分期付款
            List<Map<String, Object>> paymentList=(List<Map<String, Object>>)payment;
            int sort = 1;
            for (Map<String, Object> paymentObj: paymentList){
                ContractFinance contractFinance = new ContractFinance(contract);
                contractFinance.setPaymentCycle(contract.getPaymentCycle());
                contractFinance.setPayMethod(paymentObj.get("payment_installment_paymentMethod").toString());
                contractFinance.setAmount(Double.parseDouble(paymentObj.get("payment_installment_amount").toString()));
                contractFinance.setSort(sort);
                contractFinance.setStatus(1);
                contractFinance.preInsert();
                contractFinanceDao.insert(contractFinance);
                sort++;
            }
        }  else if(contract.getPaymentCycle().equals("3") || contract.getPaymentCycle().equals("4")){//月付或季付
            Map<String, Object> paymentObj=(Map<String, Object>)payment;
            Integer num = Integer.parseInt(paymentObj.get("payment_month_num").toString());

            Integer payment_month_day = Integer.parseInt(paymentObj.get("payment_month_day").toString());//付款日
            Integer payment_month_start = Integer.parseInt(paymentObj.get("payment_month_start").toString());//付款月

            for (int idx=1;idx<=num;idx++){
                ContractFinance contractFinance = new ContractFinance(contract);
                contractFinance.setPaymentCycle(contract.getPaymentCycle());
                contractFinance.setPayMethod(paymentObj.get("payment_month_paymentMethod").toString());
                contractFinance.setAmount(Double.parseDouble(paymentObj.get("payment_month_amount").toString()));
                contractFinance.setSort(idx);

                //设置预付款时间
                Calendar cc = Calendar.getInstance();
                int month = cc.get(Calendar.MONTH) + 1;
                int sx = contract.getPaymentCycle().equals("3")? 1: 3;//增加月数的系数
                int playMonth = payment_month_start + sx * (idx-1);
                if(playMonth< month)
                {
                    cc.add(Calendar.YEAR,1);
                }
                cc.set(Calendar.MONTH, playMonth - 1);//
                cc.set(Calendar.DAY_OF_MONTH, payment_month_day);
                contractFinance.setPlanPayDate(cc.getTime());

                contractFinance.setStatus(1);
                contractFinance.preInsert();
                contractFinanceDao.insert(contractFinance);
            }
        }
    }

    /*
    开票时更新财务数据
     */
    public void updateFinanceKP(Contract contract){
        //如果收款数据为空, 不增加新的付款数据
        if(isBlank(contract.getPaymentDetail())){
            return;
        }
        String paymentDetail = unescapeHtml4(contract.getPaymentDetail());
        Object payment = JsonMapper.getInstance().fromJson(paymentDetail, Object.class);

        ContractFinance filter = new ContractFinance(contract,1);
        List<ContractFinance> finances = contractFinanceDao.findList(filter);

        if(finances.size()==0)
            return;

        Calendar cc = Calendar.getInstance();

        ContractFinance contractFinance = finances.get(0);

        if(contract.getPaymentCycle().equals("1")) {//一次性付款
            Map<String, Object> paymentObj=(Map<String, Object>)payment;
            Integer payment_onetime_time  =Integer.parseInt(paymentObj.get("payment_onetime_time").toString());
            contractFinance.setBillingDate(cc.getTime());//设置开票日期
            cc.add(Calendar.DATE, payment_onetime_time);//设置预付款时间
            contractFinance.setPlanPayDate(cc.getTime());
        } else if(contract.getPaymentCycle().equals("2")) {//分期付款
            List<Map<String, Object>> paymentList=(List<Map<String, Object>>)payment;
            Integer sort = contractFinance.getSort();
            if(sort-1<0) return;
            Map<String, Object> paymentObj=paymentList.get(sort-1);
            Integer payment_installment_time  =Integer.parseInt(paymentObj.get("payment_installment_time").toString());
            contractFinance.setBillingDate(cc.getTime());//设置开票日期
            cc.add(Calendar.DATE, payment_installment_time);//设置预付款时间
            contractFinance.setPlanPayDate(cc.getTime());
        } else  if(contract.getPaymentCycle().equals("3") || contract.getPaymentCycle().equals("4")){//月付或季付
            contractFinance.setBillingDate(cc.getTime());//设置开票日期
        }
        //更新状态为已开票
        contractFinance.setStatus(2);
        contractFinance.preUpdate();
        contractFinanceDao.update(contractFinance);
    }

    /*
    收款时更新财务数据
     */
    public void updateFinanceSK(Contract contract){
        //如果收款数据为空, 不增加新的付款数据
        if(isBlank(contract.getPaymentDetail())){
            return;
        }
        //String paymentDetail = StringEscapeUtils.unescapeHtml4(contract.getPaymentDetail());

        ContractFinance filter = new ContractFinance(contract,2);//过滤已经开票数据
        List<ContractFinance> finances = contractFinanceDao.findList(filter);

        if(finances.size()==0)
            return;
        ContractFinance contractFinance = finances.get(0);
        Calendar cc = Calendar.getInstance();
        cc.setTime(contract.getSkDate());
        contractFinance.setPayDate(contract.getSkDate());
        contractFinance.setStatus(3);//更新状态为已付款

        contractFinance.preUpdate();
        contractFinanceDao.update(contractFinance);
    }

    /*
    检查是否都付款
     */
    public boolean checkSK(Contract contract){
        ContractFinance filter = new ContractFinance(contract);
        filter.setMaxStatus(2);//小于等于2没付款
        List<ContractFinance> finances = contractFinanceDao.findList(filter);
        if(finances.size()>0)
            return false;
        else
            return true;
    }

    @Transactional(readOnly = false)
    public void delete(Contract contract) {
        if (isNotBlank(contract.getProcInsId()))
            actProcessService.deleteProcIns(contract.getProcInsId(), "删除合同");

        contractAttachmentDao.delete(new ContractAttachment(contract));
        contractProductDao.delete(new ContractProduct(contract));
        super.delete(contract);
    }

    public Contract getByName(String name) {
        return contractDao.getByName(name);
    }

    /*
    审批合同
     */
    @Transactional(readOnly = false)
    public void audit(Contract contract) throws Exception {
        // 对不同环节的业务逻辑进行操作
        String taskDefKey = contract.getAct().getTaskDefKey();
        String flag = contract.getAct().getFlag();
        Boolean pass = false;

        if (isBlank(taskDefKey) && "submit_audit".equals(flag)) {
            //更新合同状态
            contract.setStatus(DictUtils.getDictValue("已签约","oa_contract_status",""));
            contract.preUpdate();
            contractDao.update(contract);
            // 设置流程变量
            Map<String, Object> vars = Maps.newHashMap();
            vars.put("business_person", contract.getBusinessPerson().getName());
            vars.put("artisan", contract.getArtisan().getName());
            vars.put("contract_no", contract.getNo());
            vars.put("contract_name", contract.getName());
            //dao.insert(contract);
            contract.getAct().setComment("提交审批");
            actTaskService.startProcess(ActUtils.PD_CONTRAT_AUDIT[0], ActUtils.PD_CONTRAT_AUDIT[1], contract.getId(), contract.getName(), vars);
        } else {
            Map<String, Object> vars = Maps.newHashMap();
            String comment = contract.getAct().getComment();
            if (isNotBlank(flag) && ("yes".equals(flag) || "no".equals(flag))) {
                pass = "yes".equals(contract.getAct().getFlag());
                comment = (pass ? "[同意] " : "[驳回] ") + (isNotBlank(comment) ? comment : "");
                contract.getAct().setComment(comment);
                vars.put("pass", pass ? 1: 0);
            }

            //拆分po
            if("split_po".equals(taskDefKey)){
                if(!isFinishSplitPO(contract))
                    throw new Exception("提交失败: 还没有完成拆分po, 不能提交!");
                contract.setStatus(DictUtils.getDictValue("待审批(销售)","oa_contract_status",""));
                saveProducts(contract);
            } else if("business_person_createbill".equals(taskDefKey)){//商务下单
                if(!isFinishCreateBill(contract))
                    throw new Exception("提交失败: 还有订单没有完成商务下单, 不能提交!");
                contract.setStatus(DictUtils.getDictValue("已下单","oa_contract_status",""));
            } else if("verify_ship".equals(taskDefKey)){//确认发货
                contract.setStatus(DictUtils.getDictValue("已发货","oa_contract_status",""));
            } if("can_invoice".equals(taskDefKey)){//商务确认开票
                contract.setStatus(DictUtils.getDictValue("确认开票中","oa_contract_status",""));
            } else if("cw_kp".equals(taskDefKey)){//财务开票
                actTaskService.claim(contract.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
                updateFinanceKP(contract);
                contract.setStatus(DictUtils.getDictValue("已开票","oa_contract_status",""));
            } else if("verify_sk".equals(taskDefKey)){//确认收款
                actTaskService.claim(contract.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
                updateFinanceSK(contract);
                //检查是否已经全部收款
                vars.put("pass",checkSK(contract)?1:0);

                contract.setStatus(DictUtils.getDictValue("已收款","oa_contract_status",""));
            } else if("finish".equals(taskDefKey)){//商务确认合同完成
                contract.setStatus(DictUtils.getDictValue("已完成","oa_contract_status",""));
            } else {
                if (isNotBlank(flag)) {
                    //销售审核
                    if ("saler_audit".equals(taskDefKey)) {
                        if (pass) {
                            contract.setStatus(DictUtils.getDictValue("待审批(技术)", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("已签约", "oa_contract_status", ""));
                        }

                    }
                    else if("artisan_audit".equals(taskDefKey)){//技术审核
                        if (pass) {
                            contract.setStatus(DictUtils.getDictValue("待审批(销售总监)", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("已签约", "oa_contract_status", ""));
                        }
                    }
                     else if ("cso_audit".equals(taskDefKey)) {//销售总监审核
                        if (pass) {
                            actTaskService.claim(contract.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
                            contract.setStatus(DictUtils.getDictValue("待审批(财务总监)", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("待签约", "oa_contract_status", ""));
                        }
                    }
                    else if ("cfo_audit".equals(taskDefKey)) {//财务总监审核
                        if (pass) {
                            actTaskService.claim(contract.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
                            contract.setStatus(DictUtils.getDictValue("待下单", "oa_contract_status", ""));
                            autoStartPOFlow(contract);//自动启动合同相关的所有订单流程
                        } else {
                            contract.setStatus(DictUtils.getDictValue("待签约", "oa_contract_status", ""));
                        }
                    }
                    else if ("verify_receiving".equals(taskDefKey)) {//收货验收
                        if (pass) {
                            contract.setStatus(DictUtils.getDictValue("已验收", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("已发货", "oa_contract_status", ""));
                        }
                    }
                }
            }

            saveAttachments(contract);//保存附件

            contract.preUpdate();
            contractDao.update(contract);
            actTaskService.complete(contract.getAct().getTaskId(), contract.getAct().getProcInsId(), contract.getAct().getComment(), vars);
        }
        //消息处理
        String node = taskDefKey;
        if(StringUtils.isBlank(node) && "submit_audit".equals(flag))
            node = "submit_audit";
        alertService.alertContract(node, contract);
    }

    public Integer getCountByNoPref(String noPref) {
        return contractDao.getCountByNoPref(noPref);
    }

    //设置合同号
    public void setContractNo(Contract contract){
        if(isBlank(contract.getId())) {
            SimpleDateFormat dateFormater = new SimpleDateFormat("yyyyMMdd");
            String noPref = String.format("%s%s%s", contract.getCompanyName(), contract.getContractType(), dateFormater.format(new Date()));
            Integer count;
            count = getCountByNoPref(noPref);
            contract.setNo(String.format("%s%d",noPref,count+1));
        }
    }

    //更新已下单数
    public void updateHasSendProduct(ContractProduct contractProduct){
        contractProductDao.updateHasSendNum(contractProduct);
    }

    //判断是否完成拆分po
    private Boolean isFinishSplitPO(Contract contract){
        for (ContractProduct product : contract.getContractProductList()) {
            if(product.getChilds().size() == 0 ){
                if(!product.getNum().equals(product.getHasSendNum()))
                    return false;
            } else{
                for (ContractProduct childProduct : product.getChilds()) {
                    if(!childProduct.getNum().equals(childProduct.getHasSendNum()))
                        return false;
                }
            }
        }
        return true;
    }

    /**
     * 自动启动合同相关的所有订单流程
     * @param contract
     */
    private void autoStartPOFlow(Contract contract){
        List<PurchaseOrder> poList = purchaseOrderService.getPoListByContractId(contract.getId());
        for(PurchaseOrder purchaseOrder:poList){
            purchaseOrder.getAct().setFlag("submit_audit");
            purchaseOrderService.audit(purchaseOrder);
        }
    }

    //判断订单是否已经商务下单
    private Boolean isFinishCreateBill(Contract contract){
       List<PurchaseOrder> poList = purchaseOrderService.getPoListByContractId(contract.getId());
        for(PurchaseOrder purchaseOrder:poList){
            if(isBlank(purchaseOrder.getStatus()) || new Integer(purchaseOrder.getStatus())<20)
                return false;
        }
        return true;
    }

    @Transactional(readOnly = false)
    public void jump(String contractId){
        Contract contract = get(contractId);
        ProcessInstance processInstance = actTaskService.getProcIns(contract.getProcInsId());
        Task task = actTaskService.getCurrentTaskInfo(processInstance);
        String actId = "cfo_recall_audit";
        actTaskService.Jump(task.getExecutionId(), actId);
    }

    /*
    撤销合同
     */
    @Transactional(readOnly = false)
    public void cancelContract(String contractId, Map<String, Object> content) {
        Contract contract = get(contractId);
        List<PurchaseOrder> poList = purchaseOrderService.getPoListByContractId(contractId);
        String cancelReason = "";
        Boolean isCopy = false;
        String cancelType = "10";

        if(content.get("cancelReason")!=null)
            cancelReason = content.get("cancelReason").toString();

        if(content.get("isCopy")!=null)
            isCopy =content.get("isCopy").toString().equalsIgnoreCase("true")?true:false;

        if(content.get("cancelType")!=null)
            cancelType =content.get("cancelType").toString();

        try {
            if (isNotBlank(contract.getProcInsId()))
                actProcessService.deleteProcIns(contract.getProcInsId(), "撤销合同, 类型:" + DictUtils.getDictLabel(cancelType, "oa_contract_cancel_type", "") + " 原因:" + cancelReason);

            for (PurchaseOrder po : poList) {
                if (isNotBlank(po.getProcInsId()))
                    actProcessService.deleteProcIns(po.getProcInsId(), "撤销合同, 类型:" + DictUtils.getDictLabel(cancelType, "oa_contract_cancel_type", "") + "原因:" + cancelReason);
            }
        }
        catch (Exception e) {
            System.out.println(e);
        }

        //deep clone
        if(isCopy) {
            try {
                Contract copiedContract = (Contract) contract.deepCopy();
                copiedContract.setId("");
                copiedContract.setIsNewRecord(false);
                copiedContract.setCopyFrom(contractId);
                copiedContract.setStatus("0");
                setContractNo(copiedContract);
                for (ContractProduct product : copiedContract.getContractProductList()){
                    product.setId("");
                    product.setIsNewRecord(false);
                }
                for (ContractAttachment attachment: copiedContract.getContractAttachmentList()){
                    attachment.setId("");
                    attachment.setIsNewRecord(false);
                }
                save(copiedContract);
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        Contract cancelContract = new Contract();
        cancelContract.setId(contractId);
        cancelContract.setCancelType(cancelType);
        cancelContract.setCancelReason(cancelReason);
        cancelContract.setCancelDate(new Date());
        contractDao.cancelContract(cancelContract);
    }

    /**
     * 撤回合同
     * @param contractId
     * @param recallApprove
     */
    public void recallApprove(String contractId, ContractRecallApprove recallApprove) {

    }
}