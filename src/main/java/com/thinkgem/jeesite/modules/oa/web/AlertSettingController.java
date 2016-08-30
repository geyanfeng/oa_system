package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.AlertSettingDao;
import com.thinkgem.jeesite.modules.oa.entity.AlertSetting;
import com.thinkgem.jeesite.modules.oa.entity.AlertSettingColl;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by Anthony on 2016/8/30.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/settingIdx")
public class AlertSettingController extends BaseController {
    @Autowired
    private AlertSettingDao alertSettingDao;

    @RequiresPermissions("oa:alertSetting:edit")
    @RequestMapping(value = {"edit"})
    public String edit(HttpServletRequest request, HttpServletResponse response, Model model) {
        model.addAttribute("list", alertSettingDao.findAllList(new AlertSetting()));
        return "modules/oa/alertSettingEdit";
    }

    @RequiresPermissions("oa:alertSetting:edit")
    @RequestMapping(value = "save")
    public String save(AlertSettingColl alertSettingColl, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
        for (AlertSetting alertSetting : alertSettingColl.getAlertSettingList()) {
            if (StringUtils.isBlank(alertSetting.getId())) {
                alertSetting.preInsert();
                alertSettingDao.insert(alertSetting);
            } else {
                alertSetting.preUpdate();
                alertSettingDao.update(alertSetting);
            }
        }
        addMessage(redirectAttributes, "保存提醒参数成功");
        return "redirect:" + Global.getAdminPath() + "/oa/alertSetting/edit?repage";
    }
}
