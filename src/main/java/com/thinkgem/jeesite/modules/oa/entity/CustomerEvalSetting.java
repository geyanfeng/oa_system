/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import org.apache.fop.fo.flow.Float;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 客户评价参数设置Entity
 * @author anthony
 * @version 2016-08-22
 */
public class CustomerEvalSetting extends DataEntity<CustomerEvalSetting> {
	
	private static final long serialVersionUID = 1L;
	private Dict evalType;		// 客户评价参数类型
	private Float value;		// 数值
	private String remark;		// 备注
	
	public CustomerEvalSetting() {
		super();
	}

	public CustomerEvalSetting(String id){
		super(id);
	}

	@Length(min=1, max=4, message="客户评价参数类型长度必须介于 1 和 4 之间")
	public Dict getEvalType() {
		return evalType;
	}

	public void setEvalType(Dict evalType) {
		this.evalType = evalType;
	}
	
	@NotNull(message="数值不能为空")
	public Float getValue() {
		return value;
	}

	public void setValue(Float value) {
		this.value = value;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}