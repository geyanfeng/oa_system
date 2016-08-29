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
import com.thinkgem.jeesite.modules.oa.entity.OaPoEvaluate;
import com.thinkgem.jeesite.modules.oa.service.OaPoEvaluateService;

/**
 * 供应商评价Controller
 * @author frank
 * @version 2016-08-23
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaPoEvaluate")
public class OaPoEvaluateController extends BaseController {

	@Autowired
	private OaPoEvaluateService oaPoEvaluateService;
	
	@ModelAttribute
	public OaPoEvaluate get(@RequestParam(required=false) String id) {
		OaPoEvaluate entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = oaPoEvaluateService.get(id);
		}
		if (entity == null){
			entity = new OaPoEvaluate();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:oaPoEvaluate:view")
	@RequestMapping(value = {"list", ""})
	public String list(OaPoEvaluate oaPoEvaluate, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<OaPoEvaluate> page = oaPoEvaluateService.findPage(new Page<OaPoEvaluate>(request, response), oaPoEvaluate); 
		model.addAttribute("page", page);
		return "modules/oa/oaPoEvaluateList";
	}

	public String form(OaPoEvaluate oaPoEvaluate, Model model) {
		model.addAttribute("oaPoEvaluate", oaPoEvaluate);
		return "modules/oa/oaPoEvaluateForm";
	}

	
	public String save(OaPoEvaluate oaPoEvaluate, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, oaPoEvaluate)){
			return form(oaPoEvaluate, model);
		}
		oaPoEvaluateService.save(oaPoEvaluate);
		addMessage(redirectAttributes, "保存供应商评价成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaPoEvaluate/?repage";
	}
	
	@RequiresPermissions("oa:oaPoEvaluate:edit")
	@RequestMapping(value = "delete")
	public String delete(OaPoEvaluate oaPoEvaluate, RedirectAttributes redirectAttributes) {
		oaPoEvaluateService.delete(oaPoEvaluate);
		addMessage(redirectAttributes, "删除供应商评价成功");
		return "redirect:"+Global.getAdminPath()+"/oa/oaPoEvaluate/?repage";
	}

}