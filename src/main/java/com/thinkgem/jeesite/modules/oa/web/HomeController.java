package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.act.entity.Act;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
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

        //角色类型
        int roleType = 0;
        if (UserUtils.getUser().isAdmin()) {
			//管理员
			roleType = 1;
		}
        else if (UserUtils.IsRoleByRoleEnName("cfo")) {
			//财务总监
			roleType = 2;
		}
        else if (UserUtils.IsRoleByRoleEnName("cso")) {
			//销售总兼
			roleType = 3;
		}
		
		else if (UserUtils.IsRoleByRoleEnName("saler")) {
			//销售
			roleType = 4;
		}
		model.addAttribute("roleType", roleType);

		//退款待办
		act = new Act();
        act.setProcDefKey(ActUtils.PD_TK_AUDIT[0]);
        List<Act> po_tk_audit_list = actTaskService.todoList(act);
        model.addAttribute("po_tk_audit_list", po_tk_audit_list);

        return "modules/oa/home";
    }
}
