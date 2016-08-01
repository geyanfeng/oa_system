/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 商品类型组Entity
 * @author anthony
 * @version 2016-08-01
 */
public class ProductTypeGroup extends DataEntity<ProductTypeGroup> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private Double royaltyRate;		// 提成
	private String remark;		// 备注
	private Double beginRoyaltyRate;		// 开始 提成
	private Double endRoyaltyRate;		// 结束 提成
	
	public ProductTypeGroup() {
		super();
	}

	public ProductTypeGroup(String id){
		super(id);
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public Double getRoyaltyRate() {
		return royaltyRate;
	}

	public void setRoyaltyRate(Double royaltyRate) {
		this.royaltyRate = royaltyRate;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public Double getBeginRoyaltyRate() {
		return beginRoyaltyRate;
	}

	public void setBeginRoyaltyRate(Double beginRoyaltyRate) {
		this.beginRoyaltyRate = beginRoyaltyRate;
	}
	
	public Double getEndRoyaltyRate() {
		return endRoyaltyRate;
	}

	public void setEndRoyaltyRate(Double endRoyaltyRate) {
		this.endRoyaltyRate = endRoyaltyRate;
	}
		
}