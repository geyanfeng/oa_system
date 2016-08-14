/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.modules.oa.entity.ProductType;
import com.thinkgem.jeesite.modules.oa.entity.Supplier;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeGroupService;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeService;
import com.thinkgem.jeesite.modules.oa.service.SupplierService;
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
import com.thinkgem.jeesite.modules.oa.entity.PurchaseOrder;
import com.thinkgem.jeesite.modules.oa.service.PurchaseOrderService;

import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * 采购订单Controller
 * @author anthony
 * @version 2016-08-13
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/purchaseOrder")
public class PurchaseOrderController extends BaseController {

	@Autowired
	private PurchaseOrderService purchaseOrderService;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private ProductTypeService productTypeService;
	@Autowired
	private ProductTypeGroupService productTypeGroupService;
	
	@ModelAttribute
	public PurchaseOrder get(@RequestParam(required=false) String id) {
		PurchaseOrder entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = purchaseOrderService.get(id);
		}
		if (entity == null){
			entity = new PurchaseOrder();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:purchaseOrder:view")
	@RequestMapping(value = {"list", ""})
	public String list(PurchaseOrder purchaseOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<PurchaseOrder> page = purchaseOrderService.findPage(new Page<PurchaseOrder>(request, response), purchaseOrder); 
		model.addAttribute("page", page);
		return "modules/oa/purchaseOrderList";
	}

	@RequiresPermissions("oa:purchaseOrder:view")
	@RequestMapping(value = "form")
	public String form(PurchaseOrder purchaseOrder, Model model, @RequestParam(value="fromModal", required=false) String fromModal) {
		String view = "purchaseOrderForm";
		//获取所有供应商
		List<Supplier> supplierList = supplierService.findList(new Supplier());
		model.addAttribute("supplierList", supplierList);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));

		model.addAttribute("purchaseOrder", purchaseOrder);
		//判断是否使用不同的视图
		if(isNotBlank(fromModal)){
			view = "purchaseOrderForm_ajax";
		}
		return "modules/oa/" + view;
	}

	@RequiresPermissions("oa:purchaseOrder:edit")
	@RequestMapping(value = "save")
	public String save(PurchaseOrder purchaseOrder, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, purchaseOrder)){
			return form(purchaseOrder, model, null);
		}
		purchaseOrderService.save(purchaseOrder);
		addMessage(redirectAttributes, "保存采购订单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/purchaseOrder/?repage";
	}

	@SuppressWarnings("Duplicates")
	@RequiresPermissions("oa:purchaseOrder:edit")
	@RequestMapping(value = "ajaxSave")
	@ResponseBody
	public Map<String, Object> ajaxSave(PurchaseOrder purchaseOrder, Model model, RedirectAttributes redirectAttributes) {
		save(purchaseOrder, model, redirectAttributes);
		Map<String, Object> map = Maps.newHashMap();
		map.put("status",1);//1成功,
		map.put("data", purchaseOrder);
		return map;
	}
	
	@RequiresPermissions("oa:purchaseOrder:edit")
	@RequestMapping(value = "delete")
	public String delete(PurchaseOrder purchaseOrder, RedirectAttributes redirectAttributes) {
		purchaseOrderService.delete(purchaseOrder);
		addMessage(redirectAttributes, "删除采购订单成功");
		return "redirect:"+Global.getAdminPath()+"/oa/purchaseOrder/?repage";
	}

}