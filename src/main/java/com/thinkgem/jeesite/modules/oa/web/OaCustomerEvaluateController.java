/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.oa.entity.OaCustomerEvaluate;
import com.thinkgem.jeesite.modules.oa.service.OaCustomerEvaluateService;

/**
 * 客户评价Controller
 * @author frank
 * @version 2016-09-05
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCustomerEvaluate")
public class OaCustomerEvaluateController extends BaseController {

	@Autowired
	private OaCustomerEvaluateService oaCustomerEvaluateService;
	
	@ModelAttribute
	public OaCustomerEvaluate get(@RequestParam(required=false) String id) {
		OaCustomerEvaluate entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaCustomerEvaluateService.get(id);
		}
		if (entity == null){
			entity = new OaCustomerEvaluate();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:oaCustomerEvaluate:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaCustomerEvaluate oaCustomerEvaluate, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaCustomerEvaluate> page = oaCustomerEvaluateService.findPage(new Page<OaCustomerEvaluate>(request, response), oaCustomerEvaluate); 
		model.addAttribute("page", page);
		return "modules/oa/oaCustomerEvaluateList";
	}

	@RequiresPermissions("oa:oaCustomerEvaluate:view")
	@RequestMapping(value = "form")
	public String form(OaCustomerEvaluate oaCustomerEvaluate, Model model) {
		model.addAttribute("oaCustomerEvaluate", oaCustomerEvaluate);
		return "modules/oa/oaCustomerEvaluateForm";
	}

	@RequiresPermissions("oa:oaCustomerEvaluate:edit")
	@RequestMapping(value = "save")
	public String save(OaCustomerEvaluate oaCustomerEvaluate, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaCustomerEvaluate)){
			return form(oaCustomerEvaluate, model);
		}
		oaCustomerEvaluateService.save(oaCustomerEvaluate);
		addMessage(redirectAttributes, "保存客户评价成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCustomerEvaluate/?repage";
	}
	
	@RequiresPermissions("oa:oaCustomerEvaluate:edit")
	@RequestMapping(value = "delete")
	public String delete(OaCustomerEvaluate oaCustomerEvaluate, RedirectAttributes redirectAttributes) {
		oaCustomerEvaluateService.delete(oaCustomerEvaluate);
		addMessage(redirectAttributes, "删除客户评价成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaCustomerEvaluate/?repage";
	}

}