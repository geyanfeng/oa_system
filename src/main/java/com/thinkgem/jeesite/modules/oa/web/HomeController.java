package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.act.entity.Act;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Created by Ge on 2016/8/8.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/home")
public class HomeController  extends BaseController {
    @Autowired
    private ContractService contractService;
    @Autowired
    private ActTaskService actTaskService;

    @RequestMapping(value = {"index", ""})
    public String index(HttpServletRequest request, HttpServletResponse response, Model model) {
        //合同待办
        Act act = new Act();
        act.setProcDefKey("contract_audit");
        List<Act> contract_audit_list = actTaskService.todoList(act);
        model.addAttribute("contract_audit_list", contract_audit_list);

        //订单待办
        act = new Act();
        act.setProcDefKey("purchaseOrder_audit");
        List<Act> po_audit_list = actTaskService.todoList(act);
        model.addAttribute("po_audit_list", po_audit_list);

        return "modules/oa/home";
    }
}
