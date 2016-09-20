package com.thinkgem.jeesite.modules.oa.service;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.act.service.ActProcessService;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderDao;
import com.thinkgem.jeesite.modules.oa.dao.RefundDetailDao;
import com.thinkgem.jeesite.modules.oa.dao.RefundMainDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.entity.RefundDetail;
import com.thinkgem.jeesite.modules.oa.entity.RefundMain;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.activiti.engine.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * Created by Ge on 2016/9/18.
 */
@Service
@Transactional(readOnly = true)
public class RefundService  extends CrudService<RefundMainDao, RefundMain> {
    @Autowired
    private PurchaseOrderDao purchaseOrderDao;
    @Autowired
    private ContractDao contractDao;
    @Autowired
    private TaskService taskService;
    @Autowired
    private ActTaskService actTaskService;
    @Autowired
    private RefundDetailDao refundDetailDao;
    @Autowired
    private ActProcessService actProcessService;

    @Transactional(readOnly = false)
    public void saveList(String poId, List<RefundDetail> refundDetailList) throws Exception {
        if (refundDetailList == null || refundDetailList.size() == 0) throw new Exception("出错: 没有提交数据!");

        PurchaseOrder po = purchaseOrderDao.get(new PurchaseOrder(poId));
        String contractId = po.getContract().getId();
        Contract contract = contractDao.get(contractId);
        String recall_id = "";

        //得到撤回id
        if (isNotBlank(contract.getProcInsId())) {
            Object recall_id_obj = actTaskService.getVarValue(contract.getProcInsId(), "recall_id");
            if (recall_id_obj != null)
                recall_id = recall_id_obj.toString();
        }

        //找到已经存在的数据并删除
        RefundMain filter = new RefundMain();
        filter.setPoId(poId);
        List<RefundMain> existingMainList = dao.findList(filter);
        for (RefundMain main : existingMainList) {
            //删除没有完成的退款流程
            if (isNotBlank(main.getProcInsId()))
                actProcessService.deleteProcIns(main.getProcInsId(), "删除退款流程");
            //删除数据
            dao.delete(main);
        }
        RefundDetail filterDetail = new RefundDetail();
        filterDetail.setPoId(poId);
        List<RefundDetail> existingDetailList = refundDetailDao.findList(filterDetail);
        for (RefundDetail detail : existingDetailList) {
            refundDetailDao.delete(detail);
        }

        Integer sort = 1;
        Double amount = 0.00;
        for (RefundDetail detail : refundDetailList) {
            amount += detail.getAmount();
        }

        RefundMain main = new RefundMain();
        main.setAmount(amount);
        main.setPoId(poId);
        main.setContractId(contractId);
        main.setRecallId(recall_id);
        main.preInsert();
        dao.insert(main);

        //增加新增数据
        for (RefundDetail detail : refundDetailList) {
            detail.setPoId(poId);
            detail.setContractId(contractId);
            detail.setRecallId(recall_id);
            detail.setMainId(main.getId());
            detail.setSort(sort);
            detail.preInsert();
            refundDetailDao.insert(detail);
            sort++;
            amount += detail.getAmount();
        }

        //开始退款流程
        Map<String, Object> vars = Maps.newHashMap();
        vars.put("contract_no", contract.getNo());
        vars.put("contract_name", contract.getName());
        vars.put("po_no", po.getNo());
        vars.put("recall_id", recall_id);
        actTaskService.startProcess(ActUtils.PD_TK_AUDIT[0], ActUtils.PD_TK_AUDIT[1], main.getId(), po.getNo(),vars);
    }

    @Transactional(readOnly = false)
    public void audit(RefundMain refundMain) {
        actTaskService.claim(refundMain.getAct().getTaskId(),  UserUtils.getUser().getLoginName());
        actTaskService.complete(refundMain.getAct().getTaskId(), refundMain.getAct().getProcInsId(), refundMain.getAct().getComment(),null);

        refundMain.preUpdate();
        dao.update(refundMain);
    }
}
