package com.thinkgem.jeesite.modules.oa.service;

import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderDao;
import com.thinkgem.jeesite.modules.oa.dao.StockInDao;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.entity.StockIn;
import org.activiti.engine.TaskService;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * Created by Administrator on 2016/9/18.
 */
@Service
@Transactional(readOnly = true)
public class StockInService  extends CrudService<StockInDao, StockIn> {
    @Autowired
    private PurchaseOrderDao purchaseOrderDao;
    @Autowired
    private ContractDao contractDao;
    @Autowired
    private TaskService taskService;
    @Autowired
    private ActTaskService actTaskService;


    @Transactional(readOnly = false)
    public void saveList(String poId, List<StockIn> stockInList) throws Exception {
        if(stockInList==null || stockInList.size() == 0) throw new Exception("出错: 没有提交数据!");

        PurchaseOrder po = purchaseOrderDao.get(new PurchaseOrder(poId));
        String contractId = po.getContract().getId();
        Contract contract = contractDao.get(contractId);
        String recall_id="";

        //得到撤回id
        if(isNotBlank(contract.getProcInsId())) {
            Object recall_id_obj = actTaskService.getVarValue(contract.getProcInsId(),"recall_id");
            if(recall_id_obj!=null)
                recall_id = recall_id_obj.toString();
        }

        //找到已经存在的数据并删除
        StockIn filter = new StockIn();
        filter.setPoId(poId);
        List<StockIn> existingList = dao.findList(filter);
        for(StockIn in : existingList){
            dao.delete(in);
        }
        Integer sort = 1;
        //增加新增数据
        for(StockIn in : stockInList){
            in.setPoId(poId);
            in.setContractId(contractId);
            in.setRecallId(recall_id);
            in.setSort(sort);
            in.preInsert();
            dao.insert(in);
            sort++;
        }
    }
}
