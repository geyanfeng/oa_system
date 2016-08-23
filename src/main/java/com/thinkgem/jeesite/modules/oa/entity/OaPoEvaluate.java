/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 供应商评价Entity
 * @author frank
 * @version 2016-08-23
 */
public class OaPoEvaluate extends DataEntity<OaPoEvaluate> {
	
	private static final long serialVersionUID = 1L;
	private String poId;		// 订单ID
	private Double shippingSpeed;		// 发货速度
	private Double communicationEfficiency;		// 沟通效率
	private Double productQuality;		// 产品质量
	private Double serviceAttitude;		// 服务态度
	private String remark;		// 备注
	
	public OaPoEvaluate() {
		super();
	}

	public OaPoEvaluate(String id){
		super(id);
	}

	@Length(min=1, max=64, message="订单ID长度必须介于 1 和 64 之间")
	public String getPoId() {
		return poId;
	}

	public void setPoId(String poId) {
		this.poId = poId;
	}
	
	@NotNull(message="发货速度不能为空")
	public Double getShippingSpeed() {
		return shippingSpeed;
	}

	public void setShippingSpeed(Double shippingSpeed) {
		this.shippingSpeed = shippingSpeed;
	}
	
	@NotNull(message="沟通效率不能为空")
	public Double getCommunicationEfficiency() {
		return communicationEfficiency;
	}

	public void setCommunicationEfficiency(Double communicationEfficiency) {
		this.communicationEfficiency = communicationEfficiency;
	}
	
	@NotNull(message="产品质量不能为空")
	public Double getProductQuality() {
		return productQuality;
	}

	public void setProductQuality(Double productQuality) {
		this.productQuality = productQuality;
	}
	
	@NotNull(message="服务态度不能为空")
	public Double getServiceAttitude() {
		return serviceAttitude;
	}

	public void setServiceAttitude(Double serviceAttitude) {
		this.serviceAttitude = serviceAttitude;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}