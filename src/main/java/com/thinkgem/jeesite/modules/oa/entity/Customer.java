/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 客户信息Entity
 * @author anthony
 * @version 2016-07-17
 */
public class Customer extends DataEntity<Customer> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String address;		// 地址
	private String contact;		// 联系人
	private String phone;		// 电话
	private String remark;		// 备注
	private float evaluate;		// 客户评价分数
	private String usedFlag = "1";		// 状态
	private String invoiceType;		// 发票类型
	private String invoiceCustomerName;		// 发票抬头
	private String invoiceNo;		// 发票税务登记号
	private String invoiceBank;		// 开户行
	private String invoiceBankNo;		// 银行帐号
	private String invoiceAddress;		// 地址
	private String invoicePhone;		// 电话
	
	public Customer() {
		super();
	}

	public Customer(String id){
		super(id);
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=255, message="地址长度必须介于 0 和 255 之间")
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	@Length(min=0, max=100, message="联系人长度必须介于 0 和 100 之间")
	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}
	
	@Length(min=0, max=100, message="电话长度必须介于 0 和 100 之间")
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	@Length(min=1, max=1, message="状态长度必须介于 1 和 1 之间")
	public String getUsedFlag() {
		return usedFlag;
	}

	public void setUsedFlag(String usedFlag) {
		this.usedFlag = usedFlag;
	}
	
	public float getEvaluate() {
		return evaluate;
	}

	public void setEvaluate(float evaluate) {
		this.evaluate = evaluate;
	}

	@Override
	public String toString() {
		return name;
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
}