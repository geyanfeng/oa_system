package com.thinkgem.jeesite.modules.oa.entity;

import java.util.Date;

public class SearchParams {
	private String supplierId;	
	private String customerId;	
	private String salerIds;
	private String productTypeGroup;	
	private Date startTime;	
	private Date endTime;	

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

	public String getSalerIds() {
		return salerIds;
	}

	public void setSalerIds(String salerIds) {
		this.salerIds = salerIds;
	}

	public String getProductTypeGroup() {
		return productTypeGroup;
	}

	public void setProductTypeGroup(String productTypeGroup) {
		this.productTypeGroup = productTypeGroup;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
}
