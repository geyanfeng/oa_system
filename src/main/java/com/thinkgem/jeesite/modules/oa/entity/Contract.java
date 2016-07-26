/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.modules.sys.entity.User;
import java.util.List;
import com.google.common.collect.Lists;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 各种合同Entity
 * @author anthony
 * @version 2016-07-26
 */
public class Contract extends DataEntity<Contract> {
	
	private static final long serialVersionUID = 1L;
	private String procInsId;		// 流程实例ID
	private Contract parent;		// 父级id
	private String no;		// 合同号
	private String name;		// 合同名称
	private String companyName;		// 公司抬头
	private String contractType;		// 合同类型
	private Customer customer;		// 客户id
	private String status;		// 订单状态
	private String paymentMethod;		// 付款方式
	private String paymentCycle;		// 付款周期类型
	private Date paymentTime;		// 付款时间
	private String paymentAmount;		// 付款金额
	private User business_person;		// 商务人员id
	private User artisan;		// 技术人员id
	private String customerCost;		// 客户费用
	private String isDeduction;		// 是否业绩抵扣
	private String discount;		// 抵扣金额
	private Date expiryDate;		// 有效期
	private String invoiceType;		// 发票类型
	private String invoiceCustomerName;		// 发票客户名称
	private String invoiceNo;		// 发票税务登记号
	private String invoiceBank;		// 开户行
	private String invoiceBankNo;		// 银行帐号
	private String invoiceAddress;		// 地址
	private String invoicePhone;		// 电话
	private String shipAddressType;		// 发货地址类型
	private String shipAddress;		// 发货地址
	private String files;		// 附件
	private String remark;		// 备注
	private List<ContractProduct> contractProductList = Lists.newArrayList();		// 子表列表
	
	public Contract() {
		super();
	}

	public Contract(String id){
		super(id);
	}

	@Length(min=0, max=64, message="流程实例ID长度必须介于 0 和 64 之间")
	public String getProcInsId() {
		return procInsId;
	}

	public void setProcInsId(String procInsId) {
		this.procInsId = procInsId;
	}
	
	@JsonBackReference
	public Contract getParent() {
		return parent;
	}

	public void setParent(Contract parent) {
		this.parent = parent;
	}
	
	@Length(min=1, max=100, message="合同号长度必须介于 1 和 100 之间")
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=1, max=255, message="合同名称长度必须介于 1 和 255 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=255, message="公司抬头长度必须介于 1 和 255 之间")
	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	
	@Length(min=1, max=2, message="合同类型长度必须介于 1 和 2 之间")
	public String getContractType() {
		return contractType;
	}

	public void setContractType(String contractType) {
		this.contractType = contractType;
	}
	
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=2, message="订单状态长度必须介于 0 和 2 之间")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	@Length(min=0, max=2, message="付款方式长度必须介于 0 和 2 之间")
	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}
	
	@Length(min=0, max=2, message="付款周期类型长度必须介于 0 和 2 之间")
	public String getPaymentCycle() {
		return paymentCycle;
	}

	public void setPaymentCycle(String paymentCycle) {
		this.paymentCycle = paymentCycle;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getPaymentTime() {
		return paymentTime;
	}

	public void setPaymentTime(Date paymentTime) {
		this.paymentTime = paymentTime;
	}
	
	public String getPaymentAmount() {
		return paymentAmount;
	}

	public void setPaymentAmount(String paymentAmount) {
		this.paymentAmount = paymentAmount;
	}
	
	public User getBusiness_person() {
		return business_person;
	}

	public void setBusiness_person(User business_person) {
		this.business_person = business_person;
	}
	
	public User getArtisan() {
		return artisan;
	}

	public void setArtisan(User artisan) {
		this.artisan = artisan;
	}
	
	public String getCustomerCost() {
		return customerCost;
	}

	public void setCustomerCost(String customerCost) {
		this.customerCost = customerCost;
	}
	
	@Length(min=1, max=1, message="是否业绩抵扣长度必须介于 1 和 1 之间")
	public String getIsDeduction() {
		return isDeduction;
	}

	public void setIsDeduction(String isDeduction) {
		this.isDeduction = isDeduction;
	}
	
	public String getDiscount() {
		return discount;
	}

	public void setDiscount(String discount) {
		this.discount = discount;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	@Length(min=0, max=2, message="发票类型长度必须介于 0 和 2 之间")
	public String getInvoiceType() {
		return invoiceType;
	}

	public void setInvoiceType(String invoiceType) {
		this.invoiceType = invoiceType;
	}
	
	@Length(min=0, max=255, message="发票客户名称长度必须介于 0 和 255 之间")
	public String getInvoiceCustomerName() {
		return invoiceCustomerName;
	}

	public void setInvoiceCustomerName(String invoiceCustomerName) {
		this.invoiceCustomerName = invoiceCustomerName;
	}
	
	@Length(min=0, max=255, message="发票税务登记号长度必须介于 0 和 255 之间")
	public String getInvoiceNo() {
		return invoiceNo;
	}

	public void setInvoiceNo(String invoiceNo) {
		this.invoiceNo = invoiceNo;
	}
	
	@Length(min=0, max=255, message="开户行长度必须介于 0 和 255 之间")
	public String getInvoiceBank() {
		return invoiceBank;
	}

	public void setInvoiceBank(String invoiceBank) {
		this.invoiceBank = invoiceBank;
	}
	
	@Length(min=0, max=255, message="银行帐号长度必须介于 0 和 255 之间")
	public String getInvoiceBankNo() {
		return invoiceBankNo;
	}

	public void setInvoiceBankNo(String invoiceBankNo) {
		this.invoiceBankNo = invoiceBankNo;
	}
	
	@Length(min=0, max=1000, message="地址长度必须介于 0 和 1000 之间")
	public String getInvoiceAddress() {
		return invoiceAddress;
	}

	public void setInvoiceAddress(String invoiceAddress) {
		this.invoiceAddress = invoiceAddress;
	}
	
	@Length(min=0, max=100, message="电话长度必须介于 0 和 100 之间")
	public String getInvoicePhone() {
		return invoicePhone;
	}

	public void setInvoicePhone(String invoicePhone) {
		this.invoicePhone = invoicePhone;
	}
	
	@Length(min=0, max=2, message="发货地址类型长度必须介于 0 和 2 之间")
	public String getShipAddressType() {
		return shipAddressType;
	}

	public void setShipAddressType(String shipAddressType) {
		this.shipAddressType = shipAddressType;
	}
	
	@Length(min=0, max=255, message="发货地址长度必须介于 0 和 255 之间")
	public String getShipAddress() {
		return shipAddress;
	}

	public void setShipAddress(String shipAddress) {
		this.shipAddress = shipAddress;
	}
	
	@Length(min=0, max=2000, message="附件长度必须介于 0 和 2000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@Length(min=1, max=255, message="备注长度必须介于 1 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public List<ContractProduct> getContractProductList() {
		return contractProductList;
	}

	public void setContractProductList(List<ContractProduct> contractProductList) {
		this.contractProductList = contractProductList;
	}
}