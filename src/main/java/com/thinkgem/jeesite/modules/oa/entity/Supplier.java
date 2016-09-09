/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 供应商信息Entity
 * @author anthony
 * @version 2016-09-03
 */
public class Supplier extends DataEntity<Supplier> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String remark;		// 备注
	private Double shippingSpeed = Double.valueOf("0.0");		// shipping_speed
	private Double communicationEfficiency = Double.valueOf("0.0");		// communication_efficiency
	private Double productQuality= Double.valueOf("0.0");		// product_quality
	private Double serviceAttitude= Double.valueOf("0.0");		// service_attitude
	
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
	
	@NotNull(message="shipping_speed不能为空")
	public Double getShippingSpeed() {
		return shippingSpeed;
	}

	public void setShippingSpeed(Double shippingSpeed) {
		this.shippingSpeed = shippingSpeed;
	}
	
	@NotNull(message="communication_efficiency不能为空")
	public Double getCommunicationEfficiency() {
		return communicationEfficiency;
	}

	public void setCommunicationEfficiency(Double communicationEfficiency) {
		this.communicationEfficiency = communicationEfficiency;
	}
	
	@NotNull(message="product_quality不能为空")
	public Double getProductQuality() {
		return productQuality;
	}

	public void setProductQuality(Double productQuality) {
		this.productQuality = productQuality;
	}
	
	@NotNull(message="service_attitude不能为空")
	public Double getServiceAttitude() {
		return serviceAttitude;
	}

	public void setServiceAttitude(Double serviceAttitude) {
		this.serviceAttitude = serviceAttitude;
	}
	
}