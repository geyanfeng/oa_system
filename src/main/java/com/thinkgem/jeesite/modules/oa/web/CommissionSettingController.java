package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.CommissionSettingDao;
import com.thinkgem.jeesite.modules.oa.entity.CommissionSetting;
import com.thinkgem.jeesite.modules.oa.entity.CommissionSettingColl;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Created by Anthony on 2016/8/23.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/commissionSetting")
public class CommissionSettingController extends BaseController {
    @Autowired
    private CommissionSettingDao commissionSettingDao;

    @RequiresPermissions("oa:commissionSetting:view")
    @RequestMapping(value = {"list", ""})
    public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
        setModel(model);
        return "modules/oa/commissionSettingView";
    }

    @RequiresPermissions("oa:commissionSetting:edit")
    @RequestMapping(value = {"edit"})
    public String edit(HttpServletRequest request, HttpServletResponse response, Model model) {
        setModel(model);
        return "modules/oa/commissionSettingEdit";
    }

    private void setModel(Model model){
        CommissionSetting filter1 = new CommissionSetting();
        filter1.setBeginKey(10);
        filter1.setEndKey(99);
        model.addAttribute("list1", commissionSettingDao.findAllList(filter1));
       //CommissionSetting filter2 = new CommissionSetting();
      /*  filter2.setBeginKey(100);
        filter2.setEndKey(199);
        model.addAttribute("list2", commissionSettingDao.findAllList(filter2));
        CommissionSetting filter3 = new CommissionSetting();
        filter3.setBeginKey(200);
        filter3.setEndKey(299);
        model.addAttribute("list3", commissionSettingDao.findAllList(filter3));*/
        CommissionSetting filter4 = new CommissionSetting();
        filter4.setBeginKey(300);
        filter4.setEndKey(349);
        model.addAttribute("list4", commissionSettingDao.findAllList(filter4));
        
        CommissionSetting filter2 = new CommissionSetting();
        filter2.setBeginKey(350);
        filter2.setEndKey(359);
        List<CommissionSetting> a = commissionSettingDao.findAllList(filter2);
        model.addAttribute("list2", a);
    }

    @RequiresPermissions("oa:commissionSetting:edit")
    @RequestMapping(value = "save")
    public String save(CommissionSettingColl commissionSettings, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
        saveCommissionSetting(commissionSettings.getCommissionSettings1());
        saveCommissionSetting(commissionSettings.getCommissionSettings2());
        //saveCommissionSetting(commissionSettings.getCommissionSettings3());
        saveCommissionSetting(commissionSettings.getCommissionSettings4());

        addMessage(redirectAttributes, "保存佣金参数成功");
        return "redirect:" + Global.getAdminPath() + "/oa/commissionSetting?repage";
    }

    private void saveCommissionSetting(List<CommissionSetting> commissionSettings){
        for (CommissionSetting CommissionSetting : commissionSettings) {
            if (StringUtils.isBlank(CommissionSetting.getId())) {
                CommissionSetting.preInsert();
                commissionSettingDao.insert(CommissionSetting);
            } else {
                CommissionSetting.preUpdate();
                commissionSettingDao.update(CommissionSetting);
            }
        }
    }
}