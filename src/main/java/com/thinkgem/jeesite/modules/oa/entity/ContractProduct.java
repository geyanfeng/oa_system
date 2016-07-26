/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 各种合同Entity
 * @author anthony
 * @version 2016-07-26
 */
public class ContractProduct extends DataEntity<ContractProduct> {
	
	private static final long serialVersionUID = 1L;
	private Contract contractId;		// 合同主表id 父类
	private String name;		// 名称
	private String price;		// 价格
	private String num;		// 数量
	private String unit;		// 单位
	private String amount;		// 金额
	private String remark;		// 备注
	
	public ContractProduct() {
		super();
	}

	public ContractProduct(String id){
		super(id);
	}

	public ContractProduct(Contract contractId){
		this.contractId = contractId;
	}

	@Length(min=0, max=64, message="合同主表id长度必须介于 0 和 64 之间")
	public Contract getContractId() {
		return contractId;
	}

	public void setContractId(Contract contractId) {
		this.contractId = contractId;
	}
	
	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}
	
	@Length(min=0, max=10, message="数量长度必须介于 0 和 10 之间")
	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}
	
	@Length(min=0, max=2, message="单位长度必须介于 0 和 2 之间")
	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
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