/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 各种合同Entity
 * @author anthony
 * @version 2016-08-05
 */
public class ContractProduct extends DataEntity<ContractProduct> {
	
	private static final long serialVersionUID = 1L;
	private Contract contract;		// 合同主表 父类
	private String parentId;		// 父级商品
	private String name;		// 名称
	private Double price;		// 价格
	private Integer num;		// 数量
	private String unit;		// 单位
	private Double amount;		// 金额
	private String remark;		// 备注
	private Integer sort;		//排序
	private Integer hasSendNum; //已下单数
	private ProductType productType; //商品类型
	private List<ContractProduct> childs = Lists.newArrayList();		// 子表列表
	private Double cost = 0.00 ;		//成本(从订单产品中获取)
	
	public ContractProduct() {
		super();
	}

	public ContractProduct(String id){
		super(id);
	}

	public ContractProduct(Contract contract){
		this.contract = contract;
	}

	@Length(min=0, max=64, message="合同主表长度必须介于 0 和 64 之间")
	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}
	
	@Length(min=0, max=64, message="父级商品长度必须介于 0 和 64 之间")
	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	
	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}
	
	@Length(min=0, max=10, message="数量长度必须介于 0 和 10 之间")
	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}

	@Length(min=0, max=2, message="单位长度必须介于 0 和 2 之间")
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
	
	@NotNull(message="商品类型不能为空")
	public ProductType getProductType() {
		return productType;
	}

	public void setProductType(ProductType productType) {
		this.productType = productType;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public Integer getHasSendNum() {
		return hasSendNum;
	}

	public void setHasSendNum(Integer hasSendNum) {
		this.hasSendNum = hasSendNum;
	}

	public List<ContractProduct> getChilds() {
		return childs;
	}

	public void setChilds( List<ContractProduct> childs) {
		this.childs = childs;
	}

	public Double getCost(){return cost;}
	public void setCost(Double cost){this.cost = cost;}
}