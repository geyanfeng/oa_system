package com.thinkgem.jeesite.modules.oa.entity;


public class SearchParams {
	private String supplierId;	
	private String customerId;	
	private String[] salerIds;
	private String productTypeGroup;	
	private String startTime;	
	private String endTime;	
	private String payCondition;
	
	private String overStatus;	
	private String payStatus;	
	private String billingStatus;	
	private String salerId;	
	private String companyId;	
	private String invoiceType;

	public String getSupplierId() {
		return supplierId;
	}

	public void setSupplierId(String supplierId) {
		this.supplierId = supplierId;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String[] getSalerIds() {
		return salerIds;
	}

	public void setSalerIds(String[] salerIds) {
		this.salerIds = salerIds;
	}

	public String getProductTypeGroup() {
		return productTypeGroup;
	}

	public void setProductTypeGroup(String productTypeGroup) {
		this.productTypeGroup = productTypeGroup;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getPayCondition() {
		return payCondition;
	}

	public void setPayCondition(String payCondition) {
		this.payCondition = payCondition;
	}

	public String getOverStatus() {
		return overStatus;
	}

	public void setOverStatus(String overStatus) {
		this.overStatus = overStatus;
	}

	public String getPayStatus() {
		return payStatus;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}

	public String getSalerId() {
		return salerId;
	}

	public void setSalerId(String salerId) {
		this.salerId = salerId;
	}

	public String getBillingStatus() {
		return billingStatus;
	}

	public void setBillingStatus(String billingStatus) {
		this.billingStatus = billingStatus;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getInvoiceType() {
		return invoiceType;
	}

	public void setInvoiceType(String invoiceType) {
		this.invoiceType = invoiceType;
	}
}
