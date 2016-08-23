package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.CustomerEvalSettingDao;
import com.thinkgem.jeesite.modules.oa.entity.CustomerEvalSetting;
import com.thinkgem.jeesite.modules.oa.entity.CustomerEvalSettingColl;
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
@RequestMapping(value = "${adminPath}/oa/customerEvalSetting")
public class CustomerEvalSettingController extends BaseController {
    @Autowired
    private CustomerEvalSettingDao customerEvalSettingDao;

    @RequiresPermissions("oa:customerEvalSetting:view")
    @RequestMapping(value = {"list", ""})
    public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
        List<CustomerEvalSetting> settingList =  customerEvalSettingDao.findAllList(new CustomerEvalSetting());
        model.addAttribute("list", settingList);
        return "modules/oa/customerEvalSettingView";
    }

    @RequiresPermissions("oa:customerEvalSetting:edit")
    @RequestMapping(value = {"edit"})
    public String edit(HttpServletRequest request, HttpServletResponse response, Model model) {
        List<CustomerEvalSetting> settingList =  customerEvalSettingDao.findAllList(new CustomerEvalSetting());
        model.addAttribute("list", settingList);
        return "modules/oa/customerEvalSettingEdit";
    }

    @RequiresPermissions("oa:customerEvalSetting:edit")
    @RequestMapping(value = "save")
    public String save(CustomerEvalSettingColl CustomerEvalSettings, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
       /* for(CustomerEvalSetting CustomerEvalSetting : CustomerEvalSettings.getCustomerEvalSettings()){
            if (!beanValidator(model, CustomerEvalSetting)){
                return edit(request,response, model);
            }
        }*/
        for(CustomerEvalSetting CustomerEvalSetting : CustomerEvalSettings.getCustomerEvalSettings()){
            if(StringUtils.isBlank(CustomerEvalSetting.getId())){
                CustomerEvalSetting.preInsert();
                customerEvalSettingDao.insert(CustomerEvalSetting);
            } else{
                CustomerEvalSetting.preUpdate();
                customerEvalSettingDao.update(CustomerEvalSetting);
            }
        }

        addMessage(redirectAttributes, "保存人员参数成功");
        return "redirect:"+ Global.getAdminPath()+"/oa/customerEvalSetting?repage";
    }
}
