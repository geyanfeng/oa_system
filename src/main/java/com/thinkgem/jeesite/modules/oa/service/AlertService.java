package com.thinkgem.jeesite.modules.oa.service;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.SendMailUtil;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.dao.AlertDao;
import com.thinkgem.jeesite.modules.oa.dao.AlertSettingDao;
import com.thinkgem.jeesite.modules.oa.dao.ContractDao;
import com.thinkgem.jeesite.modules.oa.dao.PurchaseOrderDao;
import com.thinkgem.jeesite.modules.oa.entity.Alert;
import com.thinkgem.jeesite.modules.oa.entity.AlertSetting;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.sys.dao.UserDao;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * Created by Ge on 2016/9/8.
 */
@Service
@Transactional(readOnly = true)
public class AlertService extends CrudService<AlertDao, Alert> {

    @Autowired
    private AlertSettingDao alertSettingDao;
    @Autowired
    private UserDao userDao;
    @Autowired
    private ContractDao contractDao;
    @Autowired
    private PurchaseOrderDao poDao;
    @Autowired
    private ActTaskService actTaskService;

    public AlertSetting getSettingByNode(String node) {
        return alertSettingDao.getByNode(node);
    }

    @Transactional(readOnly = false)
    public void alertContract(String node, Contract contract) {
        if (StringUtils.isBlank(node)) return;
        AlertSetting setting = getSettingByNode(node);
        if (setting == null) return;
        if (StringUtils.isBlank(setting.getContent())) return;
        if (setting.getIsEmail() == 0 && setting.getIsMsg() == 0) return;
        Map<String, String> receiverMap;//合同消息的接收人
        Map<String, Object> data = new HashMap<String, Object>();//模版数据
        String title, content;
        data.put("contract", contract);
        //得到合同消息的接收人
        receiverMap = getContractReceiverMap(setting, contract);
        //得到标题
        if (StringUtils.isBlank(setting.getTitle()))
            title = "系统消息提醒";
        else
            title = SendMailUtil.getText(setting.getTitle(), data);
        //得到内容
        content = SendMailUtil.getText(setting.getContent(), data);

        //是否保存消息数据
        if (setting.getIsMsg() == 1) {
            for (String key : receiverMap.keySet()) {
                Alert alert = new Alert();
                alert.setAlertType("0");
                alert.setTargetId(contract.getId());
                alert.setNode(node);
                alert.setOwnerId(key);
                alert.setTitle(title);
                alert.setContent(content);
                super.save(alert);
            }
        }
        //发送邮件
        if (setting.getIsEmail() == 1) {
            for (String email : receiverMap.values()) {
                if(StringUtils.isNotBlank(email))
                    SendMailUtil.sendCommonMail(email, title, content);
            }
        }
    }

    /**
     * 得到合同消息的接收人
     *
     * @param setting
     * @param contract
     * @return
     */
    private Map<String, String> getContractReceiverMap(AlertSetting setting, Contract contract) {
        Map<String, String> receiverMap = new HashMap<String, String>();
        //是否向销售发送消息
        if (setting.getIsSaler() == 1 && contract.getCreateBy() != null && StringUtils.isNotBlank(contract.getCreateBy().getId())) {
            User user = userDao.get(contract.getCreateBy().getId());
            if (user != null && !receiverMap.containsKey(user.getId())) {
                receiverMap.put(user.getId(), user.getEmail());
            }
        }
        //是否向商务发送消息
        if (setting.getIsBusinesser() == 1 && contract.getBusinessPerson() != null && StringUtils.isNotBlank(contract.getBusinessPerson().getId())) {
            User user = userDao.get(contract.getBusinessPerson().getId());
            if (user != null && !receiverMap.containsKey(user.getId())) {
                receiverMap.put(user.getId(), user.getEmail());
            }
        }

        //是否向技术发送消息
        if (setting.getIsTech() == 1 && contract.getArtisan() != null && StringUtils.isNotBlank(contract.getArtisan().getId())) {
            User user = userDao.get(contract.getArtisan().getId());
            if (user != null && !receiverMap.containsKey(user.getId())) {
                receiverMap.put(user.getId(), user.getEmail());
            }
        }

        //是否向销售总监发送消息
        if (setting.getIsCso() == 1) {
            List<User> userList = userDao.findUserByRoleEnName("cso");
            if (userList != null) {
                for (User user : userList) {
                    if(!receiverMap.containsKey(user.getId()))
                        receiverMap.put(user.getId(), user.getEmail());
                }
            }
        }
        //是否向财务发送消息
        if (setting.getIsCw() == 1) {
            List<User> userList = userDao.findUserByRoleEnName("cw");
            if (userList != null) {
                for (User user : userList) {
                    if(!receiverMap.containsKey(user.getId()))
                        receiverMap.put(user.getId(), user.getEmail());
                }
            }
        }
        return receiverMap;
    }

    @Transactional(readOnly = false)
    public void scheduleAlert(){
        List<AlertSetting> alertSettings = alertSettingDao.findList(new AlertSetting());
        AlertType alertType = AlertType.Contract;
        for (AlertSetting alertSetting : alertSettings){
            //如果没有设置邮件标题或内容,直接跳过
            if(StringUtils.isBlank(alertSetting.getTitle()) || StringUtils.isBlank(alertSetting.getContent())) break;
            String node = alertSetting.getNode().toLowerCase();
            String[] splitNodeArray =  node.split("_");
            if(splitNodeArray.length<2) break;
            if(splitNodeArray[0].equals("c"))
                alertType = AlertType.Contract;
            else
                alertType= AlertType.PO;

            String status = splitNodeArray[1];

            switch (alertType){
                case Contract:
                    alertContract(status, alertSetting);
                    break;
                case PO:
                    alertPO(status,alertSetting);
                    break;
            }
        }
    }

    /**
     * 提醒合同
     * @param status
     * @param alertSetting
     */
    private void alertContract(String status, AlertSetting alertSetting){
        String alertType = "0";
        Contract filter = new Contract();
        filter.setStatus(status);
        List<Contract> contractList = contractDao.findList(filter);
        for (Contract contract: contractList){
            Map<String, String> receiverMap = getContractReceiverMap(alertSetting, contract);
            for (String userId : receiverMap.keySet()){
                List<Alert> existingAlertList = getExistsAlert(userId, alertType, contract.getId(), alertSetting);
                //如果没有数据保存
                if(existingAlertList.size() == 0){
                    Map<String, Object> data = new HashMap<String, Object>();//模版数据
                    data.put("contract", contract);
                    String title, content, emailTitle, emailContent;
                    title = contract.getNo();
                    content = String.format("%s -> %s", contract.getName(), DictUtils.getDictLabel(status, "oa_contract_status",""));
                    //得到标题
                    if (StringUtils.isBlank(alertSetting.getTitle()))
                        emailTitle = "系统消息提醒";
                    else
                        emailTitle = SendMailUtil.getText(alertSetting.getTitle(), data);
                    //得到内容
                    emailContent = SendMailUtil.getText(alertSetting.getContent(), data);

                    //emailContent = addTaskLink(contract.getProcInsId(), emailContent);//增加任务链接

                    saveAndSendEmail(alertSetting, alertType, contract.getId(),userId, receiverMap.get(userId), title, content,emailTitle,emailContent);
                }
            }
        }
    }

    private void alertPO(String status, AlertSetting alertSetting){
        String alertType = "1";
        PurchaseOrder filter = new PurchaseOrder();
        filter.setStatus(status);
        List<PurchaseOrder> poList = poDao.findList(filter);
        for (PurchaseOrder po: poList){
            Contract contract = contractDao.get(po.getContract().getId());
            Map<String, String> receiverMap = getContractReceiverMap(alertSetting, contract);
            for (String userId : receiverMap.keySet()){
                List<Alert> existingAlertList = getExistsAlert(userId, alertType, po.getId(), alertSetting);
                //如果没有数据保存
                if(existingAlertList.size() == 0){
                    Map<String, Object> data = new HashMap<String, Object>();//模版数据
                    data.put("contract", contract);
                    data.put("po", po);
                    String title, content, emailTitle, emailContent;
                    title = po.getNo();
                    content = String.format("%s -> %s", contract.getName(), DictUtils.getDictLabel(status, "oa_po_status",""));
                    //得到标题
                    if (StringUtils.isBlank(alertSetting.getTitle()))
                        emailTitle = "系统消息提醒";
                    else
                        emailTitle = SendMailUtil.getText(alertSetting.getTitle(), data);
                    //得到内容
                    emailContent = SendMailUtil.getText(alertSetting.getContent(), data);

                    //emailContent = addTaskLink(po.getProcInsId(), emailContent);//增加任务链接

                    saveAndSendEmail(alertSetting, alertType, po.getId(),userId, receiverMap.get(userId), title, content,emailTitle,emailContent);
                }
            }
        }
    }

    /**
     * 增加任务链接
     * @param procInsId
     * @param content
     */
    private String addTaskLink(String procInsId, String content){
        Task task = actTaskService.getCurrentTaskInfo(procInsId);
        if(task!=null) {
            String url = Global.getConfig("site.domain")+ Global.getAdminPath()+ "/act/task/form?taskId="+task.getId()+"&taskName="+task.getName()+"&taskDefKey="+task.getTaskDefinitionKey()+"&procInsId="+task.getProcessInstanceId()+"&procDefId="+task.getProcessDefinitionId()+"&status=todo";
            content=content+"<br/>"+"<a href='" +url+"'>"+url+"</a>";
        }
        return content;
    }

    /**
     * 得到存在的提醒数据
     * @param ownerId
     * @param targetId
     * @param alertSetting
     * @return
     */
    private  List<Alert> getExistsAlert(String ownerId, String alertType,String targetId, AlertSetting alertSetting){
        Alert alertFiler = new Alert();
        alertFiler.setOwnerId(ownerId);
        alertFiler.setAlertType(alertType);
        alertFiler.setTargetId(targetId);
        alertFiler.setNode(alertSetting.getNode());
        alertFiler.setDelFlag(null);
        if(alertSetting.getDuration() == 1){
            Calendar cc = Calendar.getInstance();
            //获得当天0点时间
            cc.set(Calendar.HOUR_OF_DAY, 0);
            cc.set(Calendar.SECOND, 0);
            cc.set(Calendar.MINUTE, 0);
            cc.set(Calendar.MILLISECOND, 0);
            alertFiler.setBeginCreateDate(cc.getTime());
            //获得当天24点时间
            cc.setTime(new Date());
            cc.set(Calendar.HOUR_OF_DAY, 24);
            cc.set(Calendar.SECOND, 0);
            cc.set(Calendar.MINUTE, 0);
            cc.set(Calendar.MILLISECOND, 0);
            alertFiler.setEndCreateDate(cc.getTime());
        }
        return dao.findList(alertFiler);
    }

    /**
     * 保存并发送邮件
     * @param alertSetting
     * @param alertType
     * @param targetId
     * @param ownerId
     * @param email
     * @param title
     * @param content
     * @param emailTitle
     * @param emailContent
     */
    private void saveAndSendEmail(AlertSetting alertSetting, String alertType,String targetId, String ownerId,String email, String title, String content, String emailTitle, String emailContent){
        Alert alert = new Alert();
        alert.setAlertType(alertType);
        alert.setTargetId(targetId);
        alert.setNode(alertSetting.getNode());
        alert.setOwnerId(ownerId);
        alert.setTitle(title);
        alert.setContent(content);
        alert.setEmailTitle(emailTitle);
        alert.setEmailContent(emailContent);
        alert.setInSys("0");
        //是否保存消息数据
        if (alertSetting.getIsMsg() == 1) {
            alert.setInSys("1");
        }
        super.save(alert);
        //发送邮件
        if (alertSetting.getIsEmail() == 1) {
            if(StringUtils.isNotBlank(email))
                SendMailUtil.sendCommonMail(email, emailTitle, emailContent);
        }
    }



    public enum AlertType{
        Contract,
        PO
    }
}
