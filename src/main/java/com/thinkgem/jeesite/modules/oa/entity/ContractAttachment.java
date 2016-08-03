/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 各种合同Entity
 * @author anthony
 * @version 2016-08-03
 */
public class ContractAttachment extends DataEntity<ContractAttachment> {
	
	private static final long serialVersionUID = 1L;
	private Contract oa_contract;		// 合同 父类
	private String type;		// 附件类型
	private String files;		// 名称
	private String remark;		// 备注
	
	public ContractAttachment() {
		super();
	}

	public ContractAttachment(String id){
		super(id);
	}

	public ContractAttachment(Contract oa_contract){
		this.oa_contract = oa_contract;
	}

	@Length(min=1, max=64, message="合同长度必须介于 1 和 64 之间")
	public Contract getContract() {
		return oa_contract;
	}

	public void setContract(Contract contractId) {
		this.oa_contract = contractId;
	}
	
	@Length(min=1, max=2, message="附件类型长度必须介于 1 和 2 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=1, max=4000, message="名称长度必须介于 1 和 4000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}