/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.ActEntity;
import com.thinkgem.jeesite.common.utils.excel.annotation.ExcelField;
import com.thinkgem.jeesite.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;

import java.util.Date;
import java.util.List;

/**
 * 各种合同Entity
 * @author anthony
 * @version 2016-08-03
 */
public class Contract extends ActEntity<Contract> {
	
	private static final long serialVersionUID = 1L;
	private String parentId;		// 父级id
	private String copyFrom;		//复制的合同id
	private String parentNo;		// 父级no
	private String parentName;		// 父级name
	private String no;		// 合同号
	private String name;		// 合同名称
	private Double amount;		// 合同金额
	private String companyName;		// 公司抬头
	private String contractType;		// 合同类型
	private Customer customer;		// 客户
	private String status;		// 合同状态
	private String paymentCycle;		// 付款周期类型
	private String paymentDetail;		// 付款明细
	private User businessPerson;		// 商务人员
	private User artisan;		// 技术人员
	private Double customerCost;		// 客户费用
	private Boolean isDeduction;		// 是否业绩抵扣
	private Double discount;		// 抵扣金额
	private Double performancePercentage;   //业绩提成比例
	private Date expiryDate;		// 有效期
	private String invoiceType;		// 发票类型
	private String invoiceCustomerName;		// 发票抬头
	private String invoiceNo;		// 发票税务登记号
	private String invoiceBank;		// 开户行
	private String invoiceBankNo;		// 银行帐号
	private String invoiceAddress;		// 地址
	private String invoicePhone;		// 电话
	private String shipMode;			//发货方式
	private String shipAddress;		// 发货地址
	private String shipReceiver;		//收货人
	private String shipPhone;			//联系电话
	private String shipEms;			//快递单号
	private String remark;		// 备注
	private Date beginCreateDate;		// 开始 日期
	private Date endCreateDate;		// 结束 日期
	private List<ContractAttachment> contractAttachmentList = Lists.newArrayList();		// 子表列表
	private List<ContractProduct> contractProductList = Lists.newArrayList();		// 子表列表
	private List<ContractFinance> contractFinanceList = Lists.newArrayList();		// 合同财务相关
	private Double cost = 0.00;		//成本(从订单产品中获取)
	private Date skDate;				//收款日期
	private Integer cancelFlag=0;		//撤销标志: 0为没有撤销, 1为撤销
	private String cancelReason;		//撤销原因
	private Date cancelDate;			//撤销时间
	private String cancelType;			//撤销类型:oa_contract_cancel_type
	
	public Contract() {
		super();
	}

	public Contract(String id){
		super(id);
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	@JsonIgnore
	@ExcelField(title="销售", align=2, sort=80, value="createBy.name")
	public User getCreateBy() {
		return createBy;
	}


	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="日期", align=2, sort=10)
	public Date getCreateDate() {
		return createDate;
	}

	public String getParentNo() {
		return parentNo;
	}

	public void setParentNo(String parentNo) {
		this.parentNo = parentNo;
	}


	public String getParentName() {
		return parentName;
	}

	public void setParentName(String parentName) {
		this.parentName = parentName;
	}
	
	@Length(min=1, max=100, message="合同号长度必须介于 1 和 100 之间")
	@ExcelField(title="合同号", align=2, sort=20)
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}
	
	@Length(min=0, max=255, message="合同名称长度必须介于 1 和 255 之间")
	@ExcelField(title="合同名称", align=2, sort=50)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@ExcelField(title="合同金额", align=2, sort=60)
	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}
	
	@Length(min=1, max=255, message="公司抬头长度必须介于 1 和 255 之间")
	@ExcelField(title="公司抬头", align=2, sort=30,dictType = "oa_company_name")
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

	@ExcelField(title="客户", align=2, sort=40, value = "customer.name")
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	
	@Length(min=0, max=4, message="合同状态长度必须介于 0 和 2 之间")
	@ExcelField(title="合同状态", align=2, sort=70, dictType = "oa_contract_status")
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	
	@Length(min=0, max=4, message="付款周期类型长度必须介于 0 和 2 之间")
	public String getPaymentCycle() {
		return paymentCycle;
	}

	public void setPaymentCycle(String paymentCycle) {
		this.paymentCycle = paymentCycle;
	}

	@JsonFormat
	public String getPaymentDetail() {
		return paymentDetail;
	}

	public void setPaymentDetail(String paymentDetail) {
		this.paymentDetail = paymentDetail;
	}


	@ExcelField(title="商务人员", align=2, sort=90, value="businessPerson.name")
	public User getBusinessPerson() {
		return businessPerson;
	}

	public void setBusinessPerson(User businessPerson) {
		this.businessPerson = businessPerson;
	}

	@ExcelField(title="技术人员", align=2, sort=100, value="artisan.name")
	public User getArtisan() {
		return artisan;
	}

	public void setArtisan(User artisan) {
		this.artisan = artisan;
	}
	
	public Double getCustomerCost() {
		return customerCost;
	}

	public void setCustomerCost(Double customerCost) {
		this.customerCost = customerCost;
	}

	public Boolean getIsDeduction() {
		return isDeduction;
	}

	public void setIsDeduction(Boolean isDeduction) {
		this.isDeduction = isDeduction;
	}
	
	public Double getDiscount() {
		return discount;
	}

	public void setDiscount(Double discount) {
		this.discount = discount;
	}

	public Double getPerformancePercentage() {
		return performancePercentage;
	}

	public void setPerformancePercentage(Double performancePercentage) {
		this.performancePercentage = performancePercentage;
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
	
	@Length(min=0, max=255, message="发票抬头长度必须介于 0 和 255 之间")
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
	
	@Length(min=0, max=4, message="发货方式长度必须介于 0 和 2 之间")
	public String getShipMode() {
		return shipMode;
	}

	public void setShipMode(String shipMode) {
		this.shipMode = shipMode;
	}
	

	public String getShipAddress() {
		return shipAddress;
	}

	public void setShipAddress(String shipAddress) {
		this.shipAddress = shipAddress;
	}


	public String getShipReceiver() {
		return shipReceiver;
	}

	public void setShipReceiver(String shipReceiver) {
		this.shipReceiver = shipReceiver;
	}


	public String getShipPhone() {
		return shipPhone;
	}

	public void setShipPhone(String shipPhone) {
		this.shipPhone = shipPhone;
	}


	public String getShipEms() {
		return shipEms;
	}

	public void setShipEms(String shipEms) {
		this.shipEms = shipEms;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}

	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}
		
	public List<ContractAttachment> getContractAttachmentList() {
		return contractAttachmentList;
	}

	public void setContractAttachmentList(List<ContractAttachment> contractAttachmentList) {
		this.contractAttachmentList = contractAttachmentList;
	}
	public List<ContractProduct> getContractProductList() {
		return contractProductList;
	}

	public void setContractProductList(List<ContractProduct> contractProductList) {
		this.contractProductList = contractProductList;
	}

	public List<ContractFinance> getContractFinanceList() {
		return contractFinanceList;
	}

	public void setContractFinanceList(List<ContractFinance> contractFinanceList) {
		this.contractFinanceList = contractFinanceList;
	}

	//成本
	public Double getCost(){return cost;}
	public void setCost(Double cost){this.cost = cost;}

	public Date getSkDate(){return skDate;}
	public void setSkDate(Date skDate){this.skDate = skDate;}

	public Integer getCancelFlag(){return cancelFlag;}
	public void setCancelFlag(Integer cancelFlag){this.cancelFlag = cancelFlag;}

	public String getCancelReason(){return cancelReason;}
	public void setCancelReason(String cancelReason){this.cancelReason = cancelReason;}

	public Date getCancelDate(){return cancelDate;}
	public void setCancelDate(Date cancelDate){this.cancelDate = cancelDate;}

	public String getCopyFrom(){return copyFrom;}
	public void setCopyFrom(String copyFrom){this.copyFrom = copyFrom;}

	public String getCancelType(){return cancelType;}
	public void setCancelType(String cancelType){this.cancelType = cancelType;}
}