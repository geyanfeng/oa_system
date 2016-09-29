package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.Alert;
import com.thinkgem.jeesite.modules.oa.service.AlertService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Created by Ge on 2016/9/11.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/alert")
public class AlertController extends BaseController {
    @Autowired
    private AlertService alertService;


    @ResponseBody
    @RequestMapping(value =  {"list", ""})
    public List<Alert> list() {
        //List<Map<String, Object>> mapList = Lists.newArrayList();
        Alert filter = new Alert();
        filter.setOwnerId(UserUtils.getUser().getId());
        filter.setDelFlag("0");
        return alertService.findList(filter);
    }

    @RequestMapping(value =  "delete")
    public void delete(@RequestParam(value="id", required=false) String id,HttpServletResponse response){
        if(StringUtils.isBlank(id))
        {
            Alert filter = new Alert();
            filter.setOwnerId(UserUtils.getUser().getId());
            alertService.delete(filter);
        }else{
            alertService.delete(new Alert(id));
        }

        renderString(response,"OK");
    }
}
