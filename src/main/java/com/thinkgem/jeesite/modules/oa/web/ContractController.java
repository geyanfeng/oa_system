/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.web;

import com.google.common.collect.Maps;
import com.thinkgem.jeesite.common.config.Global;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.utils.DateUtils;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.common.utils.excel.ExportExcel;
import com.thinkgem.jeesite.common.web.BaseController;
import com.thinkgem.jeesite.modules.oa.entity.*;
import com.thinkgem.jeesite.modules.oa.service.ContractService;
import com.thinkgem.jeesite.modules.oa.service.CustomerService;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeGroupService;
import com.thinkgem.jeesite.modules.oa.service.ProductTypeService;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.codehaus.plexus.util.StringUtils.isNotBlank;

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
	@Autowired
	private CustomerService customerService;
	@Autowired
	private ProductTypeService productTypeService;
	@Autowired
	private ProductTypeGroupService productTypeGroupService;
	
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

	@RequestMapping(value = {"get"})
	@ResponseBody
	public Map<String, Object> getData(@RequestParam(required=false) String id) {
		Contract entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = contractService.get(id);
		}
		if (entity == null){
			entity = new Contract();
		}
		Map<String, Object> map = Maps.newHashMap();
		map.put("data",entity);
		return map;
	}
	
	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = {"list", ""})
	public String list(Contract contract, @RequestParam(value="isSelect", required=false) Boolean isSelect, HttpServletRequest request, HttpServletResponse response, Model model) {
		String view="contractList";
		Page<Contract> page = contractService.findPage(new Page<Contract>(request, response), contract); 
		model.addAttribute("page", page);
		model.addAttribute("isSelect", isSelect);//是否为框架合同选择列表
		if(contract.getContractType().equals("1"))
			view = "contractList_kj";
		return "modules/oa/"+view;
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "form")
	public String form(Contract contract, @RequestParam(value="originalId", required=false) String originalId, Model model) {
		String view = "contractForm";
		//如果是来自父级,复制部分数据
		if(originalId !=null){
			Contract originalContract = contractService.get(originalId);
			contract.setParentId(originalContract.getId());
			contract.setParentName(originalContract.getName());
			contract.setParentNo(originalContract.getName());
			contract.setCustomer(originalContract.getCustomer());
			contract.setInvoiceType(originalContract.getInvoiceType());
			contract.setInvoiceCustomerName(originalContract.getInvoiceCustomerName());
			contract.setInvoiceNo(originalContract.getInvoiceNo());
			contract.setInvoiceBank(originalContract.getInvoiceBank());
			contract.setInvoiceBankNo(originalContract.getInvoiceBankNo());
			contract.setInvoiceAddress(originalContract.getInvoiceAddress());
			contract.setInvoicePhone(originalContract.getInvoicePhone());
			contract.setCompanyName(originalContract.getCompanyName());
			contract.setPaymentCycle(originalContract.getPaymentCycle());
			contract.setPaymentDetail(originalContract.getPaymentDetail());
		}
		if (contract.getContractType() == null)
			contract.setContractType("2"); //设置默认合同类型为客户合同
		if (contract.getCompanyName() == null)
			contract.setCompanyName("1"); //设置默认我司抬头为上海精鲲
		if (contract.getInvoiceType() == null)
			contract.setInvoiceType("1"); //设置默认发票类型为增值税普票
		if (contract.getPaymentCycle() == null)
			contract.setPaymentCycle("2");//设置默认付款周期为分期付款
		if (contract.getShipMode() == null)
			contract.setShipMode("3");//设置默认发货方式为同城第三方物流

		//获取所有客户
		List<Customer> customerList = customerService.findList(new Customer());
		model.addAttribute("customerList", customerList);
		//获取附件
		setContractAttachment(contract);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));

		//设置合同号
		contractService.setContractNo(contract);

		model.addAttribute("contract", contract);

		//如果是框架性合同显示不同的界面
		if(contract.getContractType().equals("1"))
			view ="contractForm_kj";

		return "modules/oa/" + view;
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "view")
	public String view(Contract contract, HttpServletRequest request, HttpServletResponse response, Model model) {
		model.addAttribute("contract", contract);
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));
		//获取附件
		setContractAttachment(contract);
		// 查看审批申请单
		if (isNotBlank(contract.getId())) {//.getAct().getProcInsId())){
			// 环节编号
			String taskDefKey = contract.getAct().getTaskDefKey();

			/*// 查看工单
			if(contract.getAct().isFinishTask()){
				view = "testAuditView";
			}
			// 修改环节
			else if ("modify".equals(taskDefKey)){
				view = "testAuditForm";
			}*/
			model.addAttribute("taskDefKey",taskDefKey);
		}
		//商品类型
		model.addAttribute("productTypeList", productTypeService.findList(new ProductType()));

		return "modules/oa/contractView";
	}

	private void setContractAttachment(Contract contract){
		//获取附件
		if(contract.getContractAttachmentList()==null || contract.getContractAttachmentList().size()==0){
			ArrayList<ContractAttachment> attachmentList = new ArrayList<ContractAttachment>();
			List<Dict> attachmentTypes =  DictUtils.getDictList("oa_contract_attachment_type");
			for (Dict attachType : attachmentTypes){
				ContractAttachment attachment = new ContractAttachment();
				attachment.setType(attachType.getValue());
				attachmentList.add(attachment);
			}
			contract.setContractAttachmentList(attachmentList);
		}
	}

	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "save")
	public String save(Contract contract, Model model, RedirectAttributes redirectAttributes) {

		if (!beanValidator(model, contract)){
			return form(contract, null, model);
		}
		//设置合同号
		contractService.setContractNo(contract);

		contractService.save(contract);
		addMessage(redirectAttributes, "保存合同成功");
		return "redirect:"+Global.getAdminPath()+"/oa/contract/?contractType="+contract.getContractType()+"&repage";
	}

	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "audit")
	public String audit(Contract contract, Model model, RedirectAttributes redirectAttributes) {
		if(!contract.getContractType().equals("1") && isNotBlank(contract.getAct().getFlag()) || isNotBlank(contract.getAct().getTaskDefKey()))
		{
			try {
				contractService.audit(contract);
				addMessage(redirectAttributes, "成功提交审批");
			}
			catch(Exception e){
				addMessage(redirectAttributes, e.getMessage());
			}
			return "redirect:" + adminPath + "/act/task/todo/";
		}
		return "redirect:"+Global.getAdminPath()+"/oa/contract/?contractType="+contract.getContractType()+"&repage";
	}
	
	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "delete")
	public String delete(Contract contract, RedirectAttributes redirectAttributes) {
		contractService.delete(contract);
		addMessage(redirectAttributes, "删除合同成功");
		return "redirect:"+Global.getAdminPath()+"/oa/contract?contractType="+ contract.getContractType() +"&repage";
	}

	/**
	 * 验证名称是否有效
	 * @param oldName
	 * @param name
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "checkName")
	public String checkName(String oldName, String name) {
		if (name !=null && name.equals(oldName)) {
			return "true";
		} else if (name !=null && contractService.getByName(name) == null) {
			return "true";
		}
		return "false";
	}

	@RequiresPermissions("oa:contract:view")
	@RequestMapping(value = "export", method=RequestMethod.POST)
	public String exportFile(Contract contract, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String contractType = isNotBlank(contract.getContractType())? DictUtils.getDictLabel(contract.getContractType(),"oa_contract_type","合同列表"):"合同列表";
			String fileName = contractType+ DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
			Page<Contract> page = contractService.findPage(new Page<Contract>(request, response,-1), contract);
			new ExportExcel(contractType, Contract.class).setDataList(page.getList()).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出合同列表！失败信息："+e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()+"/oa/contract?contractType="+ contract.getContractType() +"&repage";
	}

	@RequiresPermissions("oa:contract:edit")
	@RequestMapping(value = "{contractId}/saveProduct")
	@ResponseBody
	public void saveProduct(@PathVariable String contractId,@RequestBody List<ContractProduct> contractProductList) throws Exception {
		Contract contract = get(contractId);
		for (ContractProduct contractProduct : contract.getContractProductList()){
			if(contractProduct.getHasSendNum()>0){
				throw new Exception("已经下单不能修改");
			}
			for(ContractProduct childProduct : contractProduct.getChilds()){
				if(childProduct.getHasSendNum()>0){
					throw new Exception("已经下单不能修改");
				}
			}
		}
		contract.setContractProductList(contractProductList);
		contractService.saveProducts(contract);
	}
}