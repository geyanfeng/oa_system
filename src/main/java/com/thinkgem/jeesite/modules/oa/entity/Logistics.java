/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 物流信息Entity
 * @author anthony
 * @version 2016-07-17
 */
public class Logistics extends DataEntity<Logistics> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String cost;		// 费用
	private String beginCost;		// 开始 费用
	private String endCost;		// 结束 费用
	
	public Logistics() {
		super();
	}

	public Logistics(String id){
		super(id);
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getCost() {
		return cost;
	}

	public void setCost(String cost) {
		this.cost = cost;
	}
	
	public String getBeginCost() {
		return beginCost;
	}

	public void setBeginCost(String beginCost) {
		this.beginCost = beginCost;
	}
	
	public String getEndCost() {
		return endCost;
	}

	public void setEndCost(String endCost) {
		this.endCost = endCost;
	}
		
}