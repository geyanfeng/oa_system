package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.act.entity.Act;
import com.thinkgem.jeesite.modules.act.service.ActTaskService;
import com.thinkgem.jeesite.modules.act.utils.ActUtils;
import com.thinkgem.jeesite.modules.oa.dao.ReportDao;
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.PurchaseOrderService;
import com.thinkgem.jeesite.modules.sys.dao.UserDao;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Ge on 2016/8/8.
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/home")
public class HomeController extends BaseController {
	@Autowired
	private ContractService contractService;
	@Autowired
	private PurchaseOrderService purchaseOrderService;
	@Autowired
	private ActTaskService actTaskService;
	@Autowired
	private ReportDao reportDao;
	@Autowired
	private UserDao userDao;

	@RequestMapping(value = { "index", "" })
	public String index(HttpServletRequest request,
			HttpServletResponse response, Model model) {
		// 合同待办
		Act act = new Act();
		act.setProcDefKey("contract_audit");
		List<Act> contract_audit_list = actTaskService.todoList(act);
		model.addAttribute("contract_audit_list", contract_audit_list);

		// 订单待办
		act = new Act();
		act.setProcDefKey("purchaseOrder_audit");
		List<Act> po_audit_list = actTaskService.todoList(act);
		for(Act po_audit : po_audit_list){
			PurchaseOrder po = purchaseOrderService.getByProcInsId(po_audit.getProcInsId());
			if(po!=null)
				po_audit.setTitle(String.format("%s %,.2f", po.getSupplier().getName(), po.getAmount()));
		}
		model.addAttribute("po_audit_list", po_audit_list);
		
		if (UserUtils.IsRoleByRoleEnName("cfo") || UserUtils.IsRoleByRoleEnName("cw")) {
			String roleName = "cw";
			if(UserUtils.IsRoleByRoleEnName("cfo")){
				roleName = "cfo";
			}
			Map queryMap = new LinkedHashMap();
			queryMap.put("roleName", roleName);
			List<Map> financeCalendarList = reportDao.financeCalendar(queryMap);
			
			model.addAttribute("financeCalendarList", financeCalendarList);
		}

		//KAB来单
		if (UserUtils.IsRoleByRoleEnName("cso") || UserUtils.IsRoleByRoleEnName("cto")){
			String sqlCondition = " and saler_id in (";
			Integer index = 0;
			User userFilter = new User();
			userFilter.setOffice(new Office("3"));

			List<User> findUserList = userDao.findList(userFilter);
			for (User user : findUserList){
				sqlCondition +=(index==0?"":",")+ "'"+user.getId()+"'";
				index++;
			}
			sqlCondition +=")";
			Map queryMap = new LinkedHashMap();
			queryMap.put("type", 4);
			queryMap.put("sqlCondition", sqlCondition);
			model.addAttribute("salerHomeList"+4, reportDao.reportSalerHome(queryMap));
		}
		
		if (UserUtils.IsRoleByRoleEnName("cso") || UserUtils.IsRoleByRoleEnName("cto")  || UserUtils.IsRoleByRoleEnName("saler")) {
			String sqlCondition = "";
			if(!UserUtils.IsRoleByRoleEnName("cso") && !UserUtils.IsRoleByRoleEnName("cto")){
				sqlCondition = "and saler_id='" +UserUtils.getUser().getId()+ "'";
			}
			for(int i= 1;i<6;i++){
				if(i==1 || i ==2 || i==5) {
					Map queryMap = new LinkedHashMap();
					queryMap.put("type", i);
					queryMap.put("sqlCondition", sqlCondition);
					model.addAttribute("salerHomeList" + i, reportDao.reportSalerHome(queryMap));
				}
			}

			//首页业绩完成情况
			String saler_ids = "";
			if(!UserUtils.IsRoleByRoleEnName("cso") && !UserUtils.IsRoleByRoleEnName("cto")){
				saler_ids = "'" +UserUtils.getUser().getId()+ "'";
			} else{
				List<User> userList = UserUtils.getUsersByRoleEnName("saler");
				Integer idx = 0;
				for(User user : userList){
					saler_ids += (idx==0? "":"," ) + "'"+ user.getId()+"'";
					idx++;
				}
			}
			Map queryMap = new LinkedHashMap();
			queryMap.put("saler_ids", saler_ids);
			model.addAttribute("home_gauge", reportDao.home_gauge(queryMap));

			//首页销售来单情况
			model.addAttribute("home_ld_group_by_salar", reportDao.home_ld_group_by_salar(queryMap));
			//首页应收和实收情况
			model.addAttribute("home_ys_and_ss", reportDao.home_ys_and_ss(queryMap));
			model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		}
		
		if (UserUtils.IsRoleByRoleEnName("cso") || UserUtils.IsRoleByRoleEnName("cto") || UserUtils.IsRoleByRoleEnName("cfo")) {
			List<Map> financeList = reportDao.reportHomeFinance();
			model.addAttribute("financeList", financeList);
		}

		// 退款待办
		act = new Act();
		act.setProcDefKey(ActUtils.PD_TK_AUDIT[0]);
		List<Act> po_tk_audit_list = actTaskService.todoList(act);
		model.addAttribute("po_tk_audit_list", po_tk_audit_list);

		// 合同退款待办
		act = new Act();
		act.setProcDefKey(ActUtils.PD_CONTRAT_REFUND_AUDIT[0]);
		List<Act> contract_refund_audit_list = actTaskService.todoList(act);
		model.addAttribute("contract_refund_audit_list", contract_refund_audit_list);

		return "modules/oa/home";
	}
}
