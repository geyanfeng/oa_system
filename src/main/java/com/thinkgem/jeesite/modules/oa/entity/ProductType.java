/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.modules.oa.entity.ProductTypeGroup;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 商品类型Entity
 * @author anthony
 * @version 2016-08-01
 */
public class ProductType extends DataEntity<ProductType> {
	
	private static final long serialVersionUID = 1L;
	private ProductTypeGroup typeGroup;		// 商品类型组
	private String name;		// 名称
	private String remark;		// 备注
	
	public ProductType() {
		super();
	}

	public ProductType(String id){
		super(id);
	}

	@NotNull(message="商品类型组不能为空")
	public ProductTypeGroup getTypeGroup() {
		return typeGroup;
	}

	public void setTypeGroup(ProductTypeGroup typeGroup) {
		this.typeGroup = typeGroup;
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