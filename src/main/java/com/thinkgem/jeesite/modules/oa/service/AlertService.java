package com.thinkgem.jeesite.modules.oa.service;

import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.SendMailUtil;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.oa.dao.AlertDao;
import com.thinkgem.jeesite.modules.oa.dao.AlertSettingDao;
import com.thinkgem.jeesite.modules.oa.entity.Alert;
import com.thinkgem.jeesite.modules.oa.entity.AlertSetting;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.sys.dao.UserDao;
import com.thinkgem.jeesite.modules.sys.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
}
