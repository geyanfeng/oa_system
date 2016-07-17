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
import com.thinkgem.jeesite.modules.oa.entity.Logistics;
import com.thinkgem.jeesite.modules.oa.service.LogisticsService;

/**
 * 物流信息Controller
 * @author anthony
 * @version 2016-07-17
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/logistics")
public class LogisticsController extends BaseController {

	@Autowired
	private LogisticsService logisticsService;
	
	@ModelAttribute
	public Logistics get(@RequestParam(required=false) String id) {
		Logistics entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = logisticsService.get(id);
		}
		if (entity == null){
			entity = new Logistics();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:logistics:view")
	@RequestMapping(value = {"list", ""})
	public String list(Logistics logistics, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Logistics> page = logisticsService.findPage(new Page<Logistics>(request, response), logistics); 
		model.addAttribute("page", page);
		return "modules/oa/logisticsList";
	}

	@RequiresPermissions("oa:logistics:view")
	@RequestMapping(value = "form")
	public String form(Logistics logistics, Model model) {
		model.addAttribute("logistics", logistics);
		return "modules/oa/logisticsForm";
	}

	@RequiresPermissions("oa:logistics:edit")
	@RequestMapping(value = "save")
	public String save(Logistics logistics, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, logistics)){
			return form(logistics, model);
		}
		logisticsService.save(logistics);
		addMessage(redirectAttributes, "保存物流成功");
		return "redirect:"+Global.getAdminPath()+"/oa/logistics/?repage";
	}
	
	@RequiresPermissions("oa:logistics:edit")
	@RequestMapping(value = "delete")
	public String delete(Logistics logistics, RedirectAttributes redirectAttributes) {
		logisticsService.delete(logistics);
		addMessage(redirectAttributes, "删除物流成功");
		return "redirect:"+Global.getAdminPath()+"/oa/logistics/?repage";
	}

}