/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.modules.sys.entity.Dict;
import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 佣金参数设置Entity
 * @author anthony
 * @version 2016-08-23
 */
public class CommissionSetting extends DataEntity<CommissionSetting> {
	
	private static final long serialVersionUID = 1L;
	private Dict key;		// 名称
	private float avalue;		// 第一个值
	private float bvalue;		// 第二个值
	private Integer beginKey;
	private Integer endKey;
	
	public CommissionSetting() {
		super();
	}

	public CommissionSetting(String id){
		super(id);
	}

	@Length(min=1, max=4, message="名称长度必须介于 1 和 4 之间")
	public Dict getKey() {
		return key;
	}

	public void setKey(Dict key) {
		this.key = key;
	}
	
	public float getAvalue() {
		return avalue;
	}

	public void setAvalue(float avalue) {
		this.avalue = avalue;
	}
	
	public float getBvalue() {
		return bvalue;
	}

	public void setBvalue(float bvalue) {
		this.bvalue = bvalue;
	}

	public Integer getBeginKey() {
		return beginKey;
	}

	public void setBeginKey(Integer beginKey) {
		this.beginKey = beginKey;
	}

	public Integer getEndKey() {
		return endKey;
	}

	public void setEndKey(Integer endKey) {
		this.endKey = endKey;
	}
}