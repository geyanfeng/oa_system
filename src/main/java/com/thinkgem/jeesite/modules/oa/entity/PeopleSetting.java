/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.User;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 人员参数设置Entity
 * 
 * @author anthony
 * @version 2016-08-22
 */
public class PeopleSetting extends DataEntity<PeopleSetting> {

	private static final long serialVersionUID = 1L;
	private User saler; // 销售
	private User businessPerson; // 商务
	private User artisan; // 技术
	private Double gpiQ1; // 本Q指标 毛利指标为GPI
	private Double gpiQ2; // 本Q指标 毛利指标为GPI
	private Double gpiQ3; // 本Q指标 毛利指标为GPI
	private Double gpiQ4; // 本Q指标 毛利指标为GPI
	private String remark; // 备注

	public PeopleSetting() {
		super();
	}

	public PeopleSetting(String id) {
		super(id);
	}

	@NotNull(message = "销售不能为空")
	public User getSaler() {
		return saler;
	}

	public void setSaler(User saler) {
		this.saler = saler;
	}

	@NotNull(message = "商务不能为空")
	public User getBusinessPerson() {
		return businessPerson;
	}

	public void setBusinessPerson(User businessPerson) {
		this.businessPerson = businessPerson;
	}

	@NotNull(message = "技术不能为空")
	public User getArtisan() {
		return artisan;
	}

	public void setArtisan(User artisan) {
		this.artisan = artisan;
	}

	@Length(min = 0, max = 255, message = "备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Double getGpiQ1() {
		return gpiQ1;
	}

	public void setGpiQ1(Double gpiQ1) {
		this.gpiQ1 = gpiQ1;
	}

	public Double getGpiQ2() {
		return gpiQ2;
	}

	public void setGpiQ2(Double gpiQ2) {
		this.gpiQ2 = gpiQ2;
	}

	public Double getGpiQ3() {
		return gpiQ3;
	}

	public void setGpiQ3(Double gpiQ3) {
		this.gpiQ3 = gpiQ3;
	}

	public Double getGpiQ4() {
		return gpiQ4;
	}

	public void setGpiQ4(Double gpiQ4) {
		this.gpiQ4 = gpiQ4;
	}

}