package com.thinkgem.jeesite.modules.oa.service;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.act.service.ActProcessService;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.ContractRefundDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.ContractRefund;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * Created by Administrator on 2016/9/27.
 */
@Service
@Transactional(readOnly = true)
public class ContractRefundService extends CrudService<ContractRefundDao, ContractRefund> {
    @Autowired
    private ActTaskService actTaskService;
    @Autowired
    private ActProcessService actProcessService;

    public void saveRefund(Contract contract,String recall_id){
        //找到已经存在的数据并删除
        ContractRefund filter = new ContractRefund();
        filter.setContractId(contract.getId());
        List<ContractRefund> existsRefundList = dao.findList(filter);
        if(existsRefundList!=null){
            for(ContractRefund contractRefund : existsRefundList){
                //删除没有完成的退款流程
                if (isNotBlank(contractRefund.getProcInsId()))
                    actProcessService.deleteProcIns(contractRefund.getProcInsId(), "删除预付退款流程");
                //删除数据
                dao.delete(contractRefund);
            }
        }

        if(contract.getBackAmount()!=null && contract.getBackAmount()>0){
            ContractRefund refund = new ContractRefund();
            refund.setContractId(contract.getId());
            refund.setPayMethod(contract.getBackPayMethod());
            refund.setAmount(contract.getBackAmount());
            refund.preInsert();
            dao.insert(refund);

            //开始预付退款流程
            Map<String, Object> vars = Maps.newHashMap();
            vars.put("contract_no", contract.getNo());
            vars.put("contract_name", contract.getName());
            vars.put("recall_id", recall_id);
            actTaskService.startProcess(ActUtils.PD_CONTRAT_REFUND_AUDIT[0], ActUtils.PD_CONTRAT_REFUND_AUDIT[1], refund.getId(), contract.getNo(),vars);
        }
    }


    @Transactional(readOnly = false)
    public void audit(ContractRefund contractRefund) {
        String taskDefKey = contractRefund.getAct().getTaskDefKey();

        actTaskService.claim(contractRefund.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
        actTaskService.complete(contractRefund.getAct().getTaskId(), contractRefund.getAct().getProcInsId(), contractRefund.getAct().getComment(),null);

        if(taskDefKey.equals("cw_audit")){
            contractRefund.setStatus(1);
        }

        contractRefund.preUpdate();
        dao.update(contractRefund);
    }
}
