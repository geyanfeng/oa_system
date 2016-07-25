/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 供应商信息Entity
 * @author anthony
 * @version 2016-07-25
 */
public class Supplier extends DataEntity<Supplier> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String remark;		// 备注
	
	public Supplier() {
		super();
	}

	public Supplier(String id){
		super(id);
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}