/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 采购订单Entity
 * @author anthony
 * @version 2016-08-13
 */
public class PurchaseOrderProduct extends DataEntity<PurchaseOrderProduct> {
	
	private static final long serialVersionUID = 1L;
	private PurchaseOrder purchaseOrder;		// 订单主表 父类
	private String contractProductId;		// 合同商品
	private String name;		// 名称
	private String productType;		// 商品类型
	private Boolean price;		// 价格
	private Boolean num;		// 数量
	private String unit;		// 单位
	private Boolean amount;		// 金额
	private String remark;		// 备注
	private Boolean sort;		// 排序
	
	public PurchaseOrderProduct() {
		super();
	}

	public PurchaseOrderProduct(String id){
		super(id);
	}

	public PurchaseOrderProduct(PurchaseOrder purchaseOrder){
		this.purchaseOrder = purchaseOrder;
	}

	@JsonBackReference
	public PurchaseOrder getPurchaseOrder() {
		return purchaseOrder;
	}

	public void setPurchaseOrder(PurchaseOrder parent) {
		this.purchaseOrder = purchaseOrder;
	}
	
	@Length(min=0, max=64, message="合同商品长度必须介于 0 和 64 之间")
	public String getContractProductId() {
		return contractProductId;
	}

	public void setContractProductId(String contractProductId) {
		this.contractProductId = contractProductId;
	}
	
	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=1, max=64, message="商品类型长度必须介于 1 和 64 之间")
	public String getProductType() {
		return productType;
	}

	public void setProductType(String productType) {
		this.productType = productType;
	}
	
	public Boolean getPrice() {
		return price;
	}

	public void setPrice(Boolean price) {
		this.price = price;
	}
	
	public Boolean getNum() {
		return num;
	}

	public void setNum(Boolean num) {
		this.num = num;
	}
	
	@Length(min=0, max=2, message="单位长度必须介于 0 和 2 之间")
	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	public Boolean getAmount() {
		return amount;
	}

	public void setAmount(Boolean amount) {
		this.amount = amount;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	@NotNull(message="排序不能为空")
	public Boolean getSort() {
		return sort;
	}

	public void setSort(Boolean sort) {
		this.sort = sort;
	}
	
}