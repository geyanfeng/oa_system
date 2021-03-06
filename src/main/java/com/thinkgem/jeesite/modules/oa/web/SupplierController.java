/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.oa.entity.Supplier;
import com.thinkgem.jeesite.modules.oa.service.SupplierService;

import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * 供应商信息Controller
 * @author anthony
 * @version 2016-07-25
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/supplier")
public class SupplierController extends BaseController {

	@Autowired
	private SupplierService supplierService;
	
	@ModelAttribute
	public Supplier get(@RequestParam(required=false) String id) {
		Supplier entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = supplierService.get(id);
		}
		if (entity == null){
			entity = new Supplier();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:supplier:view")
	@RequestMapping(value = {"list", ""})
	public String list(Supplier supplier, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Supplier> page = supplierService.findPage(new Page<Supplier>(request, response), supplier); 
		model.addAttribute("page", page);
		return "modules/oa/supplierList";
	}

	@RequiresPermissions("oa:supplier:view")
	@RequestMapping(value = "form")
	public String form(Supplier supplier, Model model, @RequestParam(value="fromModal", required=false) String fromModal) {
		model.addAttribute("supplier", supplier);

		if(isNotBlank(fromModal)){
			model.addAttribute("fromModal", fromModal);
		}
		return "modules/oa/supplierForm";
	}

	@RequiresPermissions("oa:supplier:edit")
	@RequestMapping(value = "save")
	public String save(Supplier supplier, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, supplier)){
			return form(supplier, model, null);
		}
		supplierService.save(supplier);
		addMessage(redirectAttributes, "保存供应商成功");
		return "redirect:"+Global.getAdminPath()+"/oa/supplier/?repage";
	}

	@RequiresPermissions("oa:supplier:edit")
	@RequestMapping(value = "ajaxSave")
	@ResponseBody
	public Map<String, Object> ajaxSave(Supplier supplier, Model model, RedirectAttributes redirectAttributes) {
		save(supplier, model, redirectAttributes);
		Map<String, Object> map = Maps.newHashMap();
		map.put("status",1);//1成功,
		map.put("data", supplier);
		return map;
	}
	
	@RequiresPermissions("oa:supplier:edit")
	@RequestMapping(value = "delete")
	public String delete(Supplier supplier, RedirectAttributes redirectAttributes) {
		supplierService.delete(supplier);
		addMessage(redirectAttributes, "删除供应商成功");
		return "redirect:"+Global.getAdminPath()+"/oa/supplier/?repage";
	}

	@RequiresPermissions("oa:supplier:view")
	@ResponseBody
	@RequestMapping(value = "data")
	public List<Map<String, Object>> data( HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Supplier filter = new Supplier();
		filter.setDelFlag("0");
		List<Supplier> list = supplierService.findList(filter);
		for (int i=0; i<list.size(); i++){
			Supplier e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("name", e.getName());
			mapList.add(map);
		}
		return mapList;
	}
}