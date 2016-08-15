/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

/**
 * 各种Entity
 * @author anthony
 * @version 2016-08-03
 */
public class PurchaseOrderAttachment extends DataEntity<PurchaseOrderAttachment> {

	private static final long serialVersionUID = 1L;
	private PurchaseOrder purchaseOrder;		// 订单父类
	private String type;		// 附件类型
	private String files;		// 名称
	private String remark;		// 备注

	public PurchaseOrderAttachment() {
		super();
	}

	public PurchaseOrderAttachment(String id){
		super(id);
	}

	public PurchaseOrderAttachment(PurchaseOrder purchaseOrder){
		this.purchaseOrder = purchaseOrder;
	}

	public PurchaseOrder getPurchaseOrder() {
		return purchaseOrder;
	}

	public void setPurchaseOrder(PurchaseOrder purchaseOrder) {
		this.purchaseOrder = purchaseOrder;
	}
	
	@Length(min=1, max=2, message="附件类型长度必须介于 1 和 2 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	@Length(min=1, max=4000, message="名称长度必须介于 1 和 4000 之间")
	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}