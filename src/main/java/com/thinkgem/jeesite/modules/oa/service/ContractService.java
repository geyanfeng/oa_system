/**
 *
 */
package com.thinkgem.jeesite.modules.oa.service;

import com.google.common.collect.Maps;
import com.sun.mail.iap.BadCommandException;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.ContractAttachmentDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractProductDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderDao;
import com.thinkgem.jeesite.modules.oa.entity.*;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

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
    private RuntimeService runtimeService;
    @Autowired
    private ContractDao contractDao;
    @Autowired
    private ContractProductDao contractProductDao;
    @Autowired
    private ContractAttachmentDao contractAttachmentDao;
    @Autowired
    private PurchaseOrderService purchaseOrderService;

    public Contract getByProcInsId(String procInsId) {
        return contractDao.getByProcInsId(procInsId);
    }

    public Contract get(String id) {
        Contract contract = super.get(id);
        contract.setContractAttachmentList(contractAttachmentDao.findList(new ContractAttachment(contract)));
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

    @Transactional(readOnly = false)
    public void delete(Contract contract) {
        super.delete(contract);
        contractAttachmentDao.delete(new ContractAttachment(contract));
        contractProductDao.delete(new ContractProduct(contract));
        runtimeService.suspendProcessInstanceById(contract.getProcInsId());
    }

    public Contract getByName(String name) {
        return contractDao.getByName(name);
    }

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
                vars.put("pass", pass ? "1" : "0");
            }

            //拆分po
            if("split_po".equals(taskDefKey)){
                if(!isFinishSplitPO(contract))
                    throw new Exception("提交失败: 还没有完成拆分po, 不能提交!");
                contract.setStatus(DictUtils.getDictValue("待审批","oa_contract_status",""));
                saveProducts(contract);
            } else if("business_person_createbill".equals(taskDefKey)){//商务下单
                if(!isFinishCreateBill(contract))
                    throw new Exception("提交失败: 还有订单没有完成商务下单, 不能提交!");
                contract.setStatus(DictUtils.getDictValue("已下单","oa_contract_status",""));
            } else if("verify_ship".equals(taskDefKey)){//确认发货
                contract.setStatus(DictUtils.getDictValue("已发货","oa_contract_status",""));
            } else if("cw_kp".equals(taskDefKey)){//财务开票
                contract.setStatus(DictUtils.getDictValue("已开票","oa_contract_status",""));
            } else if("verify_sk".equals(taskDefKey)){//确认收款
                contract.setStatus(DictUtils.getDictValue("已收款","oa_contract_status",""));
            } else if("finish".equals(taskDefKey)){//商务确认合同完成
                contract.setStatus(DictUtils.getDictValue("已完成","oa_contract_status",""));
            } else {
                if (isNotBlank(flag)) {
                    //销售审核和技术审核
                    if ("saler_audit".equals(taskDefKey) || "artisan_audit".equals(taskDefKey)) {
                        if (pass) {
                            contract.setStatus(DictUtils.getDictValue("待审批", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("已签约", "oa_contract_status", ""));
                        }

                    } else if ("cso_audit".equals(taskDefKey)) {//总监审核
                        if (pass) {
                            actTaskService.claim(contract.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
                            contract.setStatus(DictUtils.getDictValue("待下单", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("待签约", "oa_contract_status", ""));
                        }
                    } else if ("verify_receiving".equals(taskDefKey)) {//收货验收
                        if (pass) {
                            contract.setStatus(DictUtils.getDictValue("已验收", "oa_contract_status", ""));
                        } else {
                            contract.setStatus(DictUtils.getDictValue("已发货", "oa_contract_status", ""));
                        }
                    }
                }
            }

            contract.preUpdate();
            contractDao.update(contract);
            actTaskService.complete(contract.getAct().getTaskId(), contract.getAct().getProcInsId(), contract.getAct().getComment(), vars);
        }
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

    //判断订单是否已经商务下单
    private Boolean isFinishCreateBill(Contract contract){
       List<PurchaseOrder> poList = purchaseOrderService.getPoListByContractId(contract.getId());
        for(PurchaseOrder purchaseOrder:poList){
            if(isBlank(purchaseOrder.getStatus()) || new Integer(purchaseOrder.getStatus())<40)
                return false;
        }
        return true;
    }
}