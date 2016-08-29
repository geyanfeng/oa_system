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
	private Double gpi; // 本Q指标 毛利指标为GPI
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

	// 本Q指标
	public Double getGpi() {
		return gpi;
	}

	public void setGpi(Double gpi) {
		this.gpi = gpi;
	}

}