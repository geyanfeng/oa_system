/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.ActEntity;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

/**
 * 合同退预付款Entity
 * @author anthony
 * @version 2016-09-27
 */
public class ContractRefund extends ActEntity<ContractRefund> {
	
	private static final long serialVersionUID = 1L;
	private String contractId;		// 合同id
	private String payMethod;		//退款方式
	private Double amount;		// 退款金额
	private String remark;		// 备注
	private Date planTkDate;		// 应退日期
	private Date tkDate;		// 实退日期
	private Integer status = 0;	//状态
	
	public ContractRefund() {
		super();
	}

	public ContractRefund(String id){
		super(id);
	}

	@Length(min=1, max=64, message="合同id长度必须介于 1 和 64 之间")
	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}

	public String getPayMethod(){return payMethod;}
	public void setPayMethod(String payMethod){this.payMethod = payMethod;}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	@JsonFormat(pattern = "yyyy-MM-dd")
	public Date getPlanTkDate() {
		return planTkDate;
	}

	public void setPlanTkDate(Date planTkDate) {
		this.planTkDate = planTkDate;
	}

	@JsonFormat(pattern = "yyyy-MM-dd")
	public Date getTkDate() {
		return tkDate;
	}

	public void setTkDate(Date tkDate) {
		this.tkDate = tkDate;
	}

	public Integer getStatus(){return status;}
	public void setStatus(Integer status){this.status = status;}
}