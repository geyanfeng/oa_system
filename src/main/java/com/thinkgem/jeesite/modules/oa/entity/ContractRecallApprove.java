/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.common.persistence.ActEntity;
import org.hibernate.validator.constraints.Length;

/**
 * 合同撤回申请Entity
 * @author anthony
 * @version 2016-09-14
 */
public class ContractRecallApprove extends ActEntity<ContractRecallApprove> {
	
	private static final long serialVersionUID = 1L;
	private Contract contract;		// 合同id
	private Integer type = 1;		// 撤回类型: 1为合同撤销， 2为合同修改
	private String remark;		// 备注
	
	public ContractRecallApprove() {
		super();
	}

	public ContractRecallApprove(String id){
		super(id);
	}

	public ContractRecallApprove(Contract contract){
		this.contract = contract;
	}

	@Length(min=1, max=64, message="合同id长度必须介于 1 和 64 之间")
	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}