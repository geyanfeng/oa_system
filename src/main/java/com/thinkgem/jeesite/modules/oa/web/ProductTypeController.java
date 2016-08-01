/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.thinkgem.jeesite.modules.oa.entity.ProductTypeGroup;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeGroupService;
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
import com.thinkgem.jeesite.modules.oa.entity.ProductType;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeService;

/**
 * 商品类型Controller
 * @author anthony
 * @version 2016-08-01
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/productType")
public class ProductTypeController extends BaseController {

	@Autowired
	private ProductTypeService productTypeService;

	@Autowired
	private ProductTypeGroupService productTypeGroupService;
	
	@ModelAttribute
	public ProductType get(@RequestParam(required=false) String id) {
		ProductType entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = productTypeService.get(id);
		}
		if (entity == null){
			entity = new ProductType();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:productType:view")
	@RequestMapping(value = {"list", ""})
	public String list(ProductType productType, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ProductType> page = productTypeService.findPage(new Page<ProductType>(request, response), productType); 
		model.addAttribute("page", page);
		model.addAttribute("productTypeGroup_list", productTypeGroupService.findList(new ProductTypeGroup()));
		return "modules/oa/productTypeList";
	}

	@RequiresPermissions("oa:productType:view")
	@RequestMapping(value = "form")
	public String form(ProductType productType, Model model) {
		model.addAttribute("productTypeGroup_list", productTypeGroupService.findList(new ProductTypeGroup()));
		model.addAttribute("productType", productType);
		return "modules/oa/productTypeForm";
	}

	@RequiresPermissions("oa:productType:edit")
	@RequestMapping(value = "save")
	public String save(ProductType productType, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, productType)){
			return form(productType, model);
		}
		productTypeService.save(productType);
		addMessage(redirectAttributes, "保存商品类型成功");
		return "redirect:"+Global.getAdminPath()+"/oa/productType/?repage";
	}
	
	@RequiresPermissions("oa:productType:edit")
	@RequestMapping(value = "delete")
	public String delete(ProductType productType, RedirectAttributes redirectAttributes) {
		productTypeService.delete(productType);
		addMessage(redirectAttributes, "删除商品类型成功");
		return "redirect:"+Global.getAdminPath()+"/oa/productType/?repage";
	}

}