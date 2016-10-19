/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.BonusRecord;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.entity.OaCommission;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import com.thinkgem.jeesite.modules.oa.service.OaCommissionService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 佣金统计Controller
 * @author frank
 * @version 2016-09-07
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommission")
public class OaCommissionController extends BaseController {
	@Autowired
	private ContractService contractService;
	@Autowired
	private CustomerService customerService;
	@Autowired
	private OaCommissionService oaCommissionService;
	
	@ModelAttribute
	public OaCommission get(@RequestParam(required=false) String id) {
		OaCommission entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCommissionService.get(id);
		}
		if (entity == null){
			entity = new OaCommission();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:oaCommission:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaCommission oaCommission, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCommission> page = oaCommissionService.findPage(new Page<OaCommission>(request, response), oaCommission); 
		model.addAttribute("page", page);
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		return "modules/oa/oaCommissionList";
	}

	@RequiresPermissions("oa:oaCommission:editList")
	@RequestMapping(value = {"editList"})
	public String editList(Contract contract, HttpServletRequest request, HttpServletResponse response, Model model) {
		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取销售人员
		model.addAttribute("salerList", UserUtils.getUsersByRoleEnName("saler"));
		//排除框架合同
		contract.setSearchTypeArray(new String[]{"2","3"});
		Page<Contract> page = contractService.findPage(new Page<Contract>(request, response), contract);
		model.addAttribute("page", page);
		return "modules/oa/oaCommissionEditList";
	}

	@RequestMapping(value = "contract/{contractId}")
	@RequiresPermissions("oa:oaCommission:edit")
	public String edit(@PathVariable String contractId, @RequestBody Map<String, Object> map,HttpServletResponse response){
		try{
			oaCommissionService.saveBonusRecord(contractId, map);
			return renderString(response, "成功调整!");
		}catch(Exception e){
			return renderString(response, "调整失败!");
		}
	}

	@RequestMapping(value = "contract/{contractId}/bonusRecord")
	@ResponseBody
	public List<BonusRecord> getBonusRecords(@PathVariable String contractId){
		return oaCommissionService.getBonusRecords(contractId);
	}

	@RequiresPermissions("oa:oaCommission:view")
	@RequestMapping(value = "form")
	public String form(OaCommission oaCommission, Model model) {
		model.addAttribute("oaCommission", oaCommission);
		return "modules/oa/oaCommissionForm";
	}

	@RequiresPermissions("oa:oaCommission:edit")
	@RequestMapping(value = "save")
	public String save(OaCommission oaCommission, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaCommission)){
			return form(oaCommission, model);
		}
		oaCommissionService.save(oaCommission);
		addMessage(redirectAttributes, "保存佣金统计成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommission/?repage";
	}
	
	@RequiresPermissions("oa:oaCommission:edit")
	@RequestMapping(value = "delete")
	public String delete(OaCommission oaCommission, RedirectAttributes redirectAttributes) {
		oaCommissionService.delete(oaCommission);
		addMessage(redirectAttributes, "删除佣金统计成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCommission/?repage";
	}

}