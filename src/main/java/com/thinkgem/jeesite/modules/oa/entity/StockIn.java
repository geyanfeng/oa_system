/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 转入库存Entity
 * @author anthony
 * @version 2016-09-18
 */
public class StockIn extends DataEntity<StockIn> {
	
	private static final long serialVersionUID = 1L;
	private String poId;		// 订单主表
	private String contractId;		// 合同id
	private String recallId;		// 撤回id
	private String name;		// 名称
	private String productType;		// 商品类型
	private Double price;		// 价格
	private Integer num;		// 数量
	private String unit;		// 单位
	private Double amount;		// 金额
	private String remark;		// 备注
	private Integer sort;		// 排序
	
	public StockIn() {
		super();
	}

	public StockIn(String id){
		super(id);
	}

	@Length(min=0, max=64, message="订单主表长度必须介于 0 和 64 之间")
	public String getPoId() {
		return poId;
	}

	public void setPoId(String poId) {
		this.poId = poId;
	}
	
	@Length(min=0, max=64, message="合同id长度必须介于 0 和 64 之间")
	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	
	@Length(min=0, max=64, message="撤回id长度必须介于 0 和 64 之间")
	public String getRecallId() {
		return recallId;
	}

	public void setRecallId(String recallId) {
		this.recallId = recallId;
	}
	
	@Length(min=0, max=100, message="名称长度必须介于 0 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=64, message="商品类型长度必须介于 0 和 64 之间")
	public String getProductType() {
		return productType;
	}

	public void setProductType(String productType) {
		this.productType = productType;
	}
	
	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}
	
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}
	
	@Length(min=0, max=6, message="单位长度必须介于 0 和 6 之间")
	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
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
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
}