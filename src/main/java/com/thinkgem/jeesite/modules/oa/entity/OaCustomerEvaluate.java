/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.modules.oa.entity.Customer;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 客户评价Entity
 * @author frank
 * @version 2016-09-05
 */
public class OaCustomerEvaluate extends DataEntity<OaCustomerEvaluate> {
	
	private static final long serialVersionUID = 1L;
	private Customer customer;		// 客户ID
	private String customerEvalType;		// 客户评价参数类型
	private String contractId;		// 合同ID
	private String paymentId;		// 支付ID
	private Date planPayDate;		// 应付款时间
	private Date payDate;		// 实际付款时间
	private Double point;		// 点数
	private Contract contract;		// 合同
	
	public OaCustomerEvaluate() {
		super();
	}

	public OaCustomerEvaluate(String id){
		super(id);
	}

	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}
	
	@NotNull(message="客户ID不能为空")
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	
	@Length(min=1, max=100, message="客户评价参数类型长度必须介于 1 和 100 之间")
	public String getCustomerEvalType() {
		return customerEvalType;
	}

	public void setCustomerEvalType(String customerEvalType) {
		this.customerEvalType = customerEvalType;
	}
	
	@Length(min=0, max=64, message="合同ID长度必须介于 0 和 64 之间")
	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	
	@Length(min=0, max=64, message="支付ID长度必须介于 0 和 64 之间")
	public String getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getPlanPayDate() {
		return planPayDate;
	}

	public void setPlanPayDate(Date planPayDate) {
		this.planPayDate = planPayDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	
	@NotNull(message="点数不能为空")
	public Double getPoint() {
		return point;
	}

	public void setPoint(Double point) {
		this.point = point;
	}
	
}