/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

/**
 * 客户信息Controller
 * @author anthony
 * @version 2016-07-17
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/customer")
public class CustomerController extends BaseController {

	@Autowired
	private CustomerService customerService;
	
	@ModelAttribute
	public Customer get(@RequestParam(required=false) String id) {
		Customer entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = customerService.get(id);
		}
		if (entity == null){
			entity = new Customer();
		}
		return entity;
	}
	
	@RequiresPermissions("oa:customer:view")
	@RequestMapping(value = {"list", ""})
	public String list(Customer customer, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Customer> page = customerService.findPage(new Page<Customer>(request, response), customer); 
		model.addAttribute("page", page);
		return "modules/oa/customerList";
	}

	@RequiresPermissions("oa:customer:view")
	@RequestMapping(value = "form")
	public String form(Customer customer,@RequestParam(value="fromModal", required=false) String fromModal, Model model) {
		model.addAttribute("customer", customer);
		if(isNotBlank(fromModal)){
			model.addAttribute("fromModal", fromModal);
		}
		if(StringUtils.isBlank(customer.getInvoiceType())){
			customer.setInvoiceType("2");
		}
		return "modules/oa/customerForm";
	}



	@RequiresPermissions("oa:customer:edit")
	@RequestMapping(value = "save")
	public String save(Customer customer,Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, customer)){
			return form(customer,null, model);
		}
		customerService.save(customer);
		return "redirect:"+Global.getAdminPath()+"/oa/customer/?repage";
	}

	@SuppressWarnings("Duplicates")
	@RequiresPermissions("oa:customer:edit")
	@RequestMapping(value = "ajaxSave")
	@ResponseBody
	public Map<String, Object> ajaxSave(Customer customer, Model model, RedirectAttributes redirectAttributes) {
		save(customer, model, redirectAttributes);
		Map<String, Object> map = Maps.newHashMap();
		map.put("status",1);//1成功,
		map.put("data", customer);
		return map;
	}
	
	@RequiresPermissions("oa:customer:edit")
	@RequestMapping(value = "delete")
	public String delete(Customer customer, RedirectAttributes redirectAttributes) {
		customerService.delete(customer);
		addMessage(redirectAttributes, "删除客户成功");
		return "redirect:"+Global.getAdminPath()+"/oa/customer/?repage";
	}

	/**
	 * 验证名称是否有效
	 * @param oldName
	 * @param name
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkName(String oldName, String name) {
		if (name !=null && name.equals(oldName)) {
			return "true";
		} else if (name !=null && customerService.getCustomerByName(name) == null) {
			return "true";
		}
		return "false";
	}

	@ResponseBody
	@RequestMapping(value = "checkAddress")
	public String checkAddress(String oldAddress, String address) {
		if (address !=null && address.equals(oldAddress)) {
			return "true";
		} else if (oldAddress !=null && customerService.getCustomerByAddress(address) == null) {
			return "true";
		}
		return "false";
	}

	@ResponseBody
	@RequestMapping(value = "checkPhone")
	public String checkPhone(String oldPhone, String phone) {
		if (phone !=null && phone.equals(oldPhone)) {
			return "true";
		} else if (phone !=null && customerService.getCustomerByPhone(phone) == null) {
			return "true";
		}
		return "false";
	}

	@RequiresPermissions("oa:customer:edit")
	@RequestMapping(value = "changeUsedFlag")
	public String changeUsedFlag(Customer customer, RedirectAttributes redirectAttributes) {
		customerService.changeUsedFlag(customer);
		addMessage(redirectAttributes, "修改客户状态成功");
		return "redirect:"+Global.getAdminPath()+"/oa/customer/?repage";
	}

	@RequiresPermissions("oa:customer:view")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Customer filter = new Customer();
		filter.setDelFlag("0");
		List<Customer> list = customerService.findList(filter);
		for (int i=0; i<list.size(); i++){
			Customer e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", "");
			map.put("name", e.getName());
			map.put("invoiceType", e.getInvoiceType());
			map.put("invoiceCustomerName", e.getInvoiceCustomerName());
			map.put("invoiceNo", e.getInvoiceNo());
			map.put("invoiceBank", e.getInvoiceBank());
			map.put("invoiceBankNo", e.getInvoiceBankNo());
			map.put("invoiceAddress", e.getInvoicePhone());
			map.put("invoicePhone", e.getInvoicePhone());

			mapList.add(map);
		}
		return mapList;
	}
}