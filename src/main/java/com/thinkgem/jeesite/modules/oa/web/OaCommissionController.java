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
import com.thinkgem.jeesite.modules.oa.entity.OaCommission;
import com.thinkgem.jeesite.modules.oa.service.OaCommissionService;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 佣金统计Controller
 * @author frank
 * @version 2016-09-07
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/oaCommission")
public class OaCommissionController extends BaseController {

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