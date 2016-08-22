package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.dao.PeopleSettingDao;
import com.thinkgem.jeesite.modules.oa.entity.PeopleSetting;
import com.thinkgem.jeesite.modules.oa.entity.PeopleSettingCollocation;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

import static org.apache.commons.lang3.StringUtils.isBlank;

/**
 * Created by Administrator on 2016/8/22.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/peoplesetting")
public class PeopleSettingController extends BaseController {
    @Autowired
    private PeopleSettingDao peopleSettingDao;

    @RequiresPermissions("oa:peoplesetting:view")
    @RequestMapping(value = {"list", ""})
    public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
        List<PeopleSetting> settingList =  peopleSettingDao.findAllList(new PeopleSetting());
        model.addAttribute("list", settingList);
        return "modules/oa/peopleSettingView";
    }

    @RequiresPermissions("oa:peoplesetting:edit")
    @RequestMapping(value = {"edit"})
    public String edit(HttpServletRequest request, HttpServletResponse response, Model model) {
        List<PeopleSetting> settingList =  peopleSettingDao.findAllList(new PeopleSetting());
        model.addAttribute("list", settingList);
        model.addAttribute("businessPeopleList", UserUtils.getUsersByRoleEnName("businesser"));
        model.addAttribute("artisanList", UserUtils.getUsersByRoleEnName("tech"));
        return "modules/oa/peopleSettingEdit";
    }

    @RequiresPermissions("oa:peoplesetting:edit")
    @RequestMapping(value = "save")
    public String save(PeopleSettingCollocation peopleSettings, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
        for(PeopleSetting peopleSetting : peopleSettings.getPeopleSettingCollocations()){
            if (!beanValidator(model, peopleSetting)){
                return edit(request,response, model);
            }
        }
        for(PeopleSetting peopleSetting : peopleSettings.getPeopleSettingCollocations()){
            if(isBlank(peopleSetting.getId())){
                peopleSetting.preInsert();
                peopleSettingDao.insert(peopleSetting);
            } else{
                peopleSetting.preUpdate();
                peopleSettingDao.update(peopleSetting);
            }
        }

        addMessage(redirectAttributes, "保存人员参数成功");
        return "redirect:"+ Global.getAdminPath()+"/oa/peoplesetting?repage";
    }
}
