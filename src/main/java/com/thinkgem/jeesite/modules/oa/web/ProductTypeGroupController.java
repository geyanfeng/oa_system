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
import com.thinkgem.jeesite.modules.oa.entity.ProductTypeGroup;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeGroupService;

/**
 * 商品类型组Controller
 * @author anthony
 * @version 2016-08-01
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/productTypeGroup")
public class ProductTypeGroupController extends BaseController {

	@Autowired
	private ProductTypeGroupService productTypeGroupService;
	
	@ModelAttribute
	public ProductTypeGroup get(@RequestParam(required=false) String id) {
		ProductTypeGroup entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = productTypeGroupService.get(id);
		}
		if (entity == null){
			entity = new ProductTypeGroup();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:productTypeGroup:view")
	@RequestMapping(value = {"list", ""})
	public String list(ProductTypeGroup productTypeGroup, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ProductTypeGroup> page = productTypeGroupService.findPage(new Page<ProductTypeGroup>(request, response), productTypeGroup); 
		model.addAttribute("page", page);
		return "modules/oa/productTypeGroupList";
	}

	@RequiresPermissions("oa:productTypeGroup:view")
	@RequestMapping(value = "form")
	public String form(ProductTypeGroup productTypeGroup, Model model) {
		model.addAttribute("productTypeGroup", productTypeGroup);
		return "modules/oa/productTypeGroupForm";
	}

	@RequiresPermissions("oa:productTypeGroup:edit")
	@RequestMapping(value = "save")
	public String save(ProductTypeGroup productTypeGroup, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, productTypeGroup)){
			return form(productTypeGroup, model);
		}
		productTypeGroupService.save(productTypeGroup);
		addMessage(redirectAttributes, "保存商品类型组成功");
		return "redirect:"+Global.getAdminPath()+"/oa/productTypeGroup/?repage";
	}
	
	@RequiresPermissions("oa:productTypeGroup:edit")
	@RequestMapping(value = "delete")
	public String delete(ProductTypeGroup productTypeGroup, RedirectAttributes redirectAttributes) {
		productTypeGroupService.delete(productTypeGroup);
		addMessage(redirectAttributes, "删除商品类型组成功");
		return "redirect:"+Global.getAdminPath()+"/oa/productTypeGroup/?repage";
	}

}