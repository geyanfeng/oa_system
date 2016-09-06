/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.Date;

/**
 * 合同财务相关Entity
 * @author anthony
 * @version 2016-08-24
 */
public class ContractFinance extends DataEntity<ContractFinance> {
	
	private static final long serialVersionUID = 1L;
	private Contract contract;		// 合同 父类
	private String paymentCycle;		// 付款周期
	private Date billingDate;		// 开票时间
	private String payMethod;		// 收款方式
	private Date planPayDate;		// 预计付款时间
	private Date payDate;		// 付款时间
	private Double amount;		// 开票或收款金额
	private Integer status;		// 状态:1为没开票,1没付款, 2为开票, 3为付款
	private Integer sort;		// 顺序
	private String remark;		// 备注
	private Integer maxStatus;
	private Integer minStatus;
	private Integer cancelFlag=0;		//撤销标志: 0为没有撤销, 1为撤销
	
	public ContractFinance() {
		super();
	}

	public ContractFinance(String id){
		super(id);
	}

	public ContractFinance(Contract contract){
		this.contract = contract;
	}

	public ContractFinance(Contract contract, Integer status){
		this.contract = contract;
		this.status = status;
	}

	@Length(min=1, max=64, message="合同长度必须介于 1 和 64 之间")
	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	@Length(min=1, max=4, message="付款周期长度必须介于 1 和 4 之间")
	public String getPaymentCycle() {
		return paymentCycle;
	}

	public void setPaymentCycle(String paymentCycle) {
		this.paymentCycle = paymentCycle;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getBillingDate() {
		return billingDate;
	}

	public void setBillingDate(Date billingDate) {
		this.billingDate = billingDate;
	}
	
	@Length(min=1, max=64, message="收款方式长度必须介于 1 和 64 之间")
	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
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
	
	@NotNull(message="开票或收款金额不能为空")
	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}
	
	@NotNull(message="状态:0为没开票,没付款, 1为开票, 2为付款不能为空")
	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getMaxStatus() {
		return maxStatus;
	}

	public void setMaxStatus(Integer maxStatus) {
		this.maxStatus = maxStatus;
	}

	public Integer getMinStatus() {
		return minStatus;
	}

	public void setMinStatus(Integer minStatus) {
		this.minStatus = minStatus;
	}
	
	@NotNull(message="顺序不能为空")
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Integer getCancelFlag(){return cancelFlag;}
	public void setCancelFlag(Integer cancelFlag){this.cancelFlag = cancelFlag;}
}