/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.Contract;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 各种合同Controller
 * @author anthony
 * @version 2016-07-28
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/contract")
public class ContractController extends BaseController {

	@Autowired
	private ContractService contractService;
	
	@ModelAttribute
	public Contract get(@RequestParam(required=false) String id) {
		Contract entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = contractService.get(id);
		}
		if (entity == null){
			entity = new Contract();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = {"list", ""})
	public String list(Contract contract, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Contract> page = contractService.findPage(new Page<Contract>(request, response), contract); 
		model.addAttribute("page", page);
		return "modules/oa/contractList";
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "form")
	public String form(Contract contract, Model model) {
		contract.setContractType("2"); //设置默认合同类型为客户合同
		contract.setCompanyName("1"); //设置默认我司抬头为上海精鲲
		contract.setInvoiceType("1"); //设置默认发票类型为增值税普票
		contract.setPaymentMethod("2");//设置默认付款方式为银行转账
		contract.setPaymentCycle("2");//设置默认付款周期为分期付款
		contract.setShipAddressType("1");//设置默认发货地址类型为客户名称
		model.addAttribute("contract", contract);
		return "modules/oa/contractForm";
	}

	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "save")
	public String save(Contract contract, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, contract)){
			return form(contract, model);
		}
		contractService.save(contract);
		addMessage(redirectAttributes, "保存合同成功");
		return "redirect:"+Global.getAdminPath()+"/oa/contract/?repage";
	}
	
	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "delete")
	public String delete(Contract contract, RedirectAttributes redirectAttributes) {
		contractService.delete(contract);
		addMessage(redirectAttributes, "删除合同成功");
		return "redirect:"+Global.getAdminPath()+"/oa/contract/?repage";
	}

}