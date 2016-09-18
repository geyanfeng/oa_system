/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.common.persistence.ActEntity;
import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 退款主数据Entity
 * @author anthony
 * @version 2016-09-18
 */
public class RefundMain extends ActEntity<RefundMain> {
	
	private static final long serialVersionUID = 1L;
	private String contractId;		// 合同id
	private String poId;		// 订单主表
	private String recallId;		// 撤回id
	private Double amount;		// 金额
	private String remark;		// 备注
	
	public RefundMain() {
		super();
	}

	public RefundMain(String id){
		super(id);
	}

	@Length(min=1, max=64, message="合同id长度必须介于 1 和 64 之间")
	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	
	@Length(min=1, max=64, message="订单主表长度必须介于 1 和 64 之间")
	public String getPoId() {
		return poId;
	}

	public void setPoId(String poId) {
		this.poId = poId;
	}
	
	@Length(min=1, max=64, message="撤回id长度必须介于 1 和 64 之间")
	public String getRecallId() {
		return recallId;
	}

	public void setRecallId(String recallId) {
		this.recallId = recallId;
	}

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
	
}