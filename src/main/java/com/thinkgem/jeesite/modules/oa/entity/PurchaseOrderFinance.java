/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotNull;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 采购订单财务相关Entity
 * @author anthony
 * @version 2016-08-31
 */
public class PurchaseOrderFinance extends DataEntity<PurchaseOrderFinance> {
	
	private static final long serialVersionUID = 1L;
	private PurchaseOrder purchaseOrder;		// 采购订单Id
	private Integer payCondition;		//付款条件,0为预付,1为应付
	private String payMethod;		// 收款方式
	private Integer zq = 0;				//帐期
	private Date planPayDate;		// 预计付款时间
	private Date payDate;		// 付款时间
	private Double amount;		// 开票或收款金额
	private Integer status;		// 状态:1没付款, 2为付款
	private Integer sort;		// 顺序
	private String remark;		// 备注
	private Integer maxStatus;
	private Integer minStatus;
	
	public PurchaseOrderFinance() {
		super();
	}

	public PurchaseOrderFinance(String id){
		super(id);
	}

	public PurchaseOrderFinance(PurchaseOrder purchaseOrder){
		this.purchaseOrder = purchaseOrder;
	}

	public PurchaseOrderFinance(PurchaseOrder purchaseOrder, Integer status){
		this.purchaseOrder = purchaseOrder;
		this.status = status;
	}


	@Length(min=1, max=64, message="采购订单Id长度必须介于 1 和 64 之间")
	public PurchaseOrder getPurchaseOrder() {
		return purchaseOrder;
	}

	public void setPurchaseOrder(PurchaseOrder purchaseOrder) {
		this.purchaseOrder = purchaseOrder;
	}
	
	@Length(min=1, max=64, message="收款方式长度必须介于 1 和 64 之间")
	public String getPayMethod() {
		return payMethod;
	}

	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}

	public Integer getZq() {
		return zq;
	}

	public void setZq(Integer zq) {
		this.zq = zq;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getPlanPayDate() {
		return planPayDate;
	}

	public void setPlanPayDate(Date planPayDate) {
		this.planPayDate = planPayDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	
	@NotNull(message="开票或收款金额不能为空")
	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}
	
	@NotNull(message="状态:1没付款, 2为付款不能为空")
	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getMaxStatus() {
		return maxStatus;
	}

	public void setMaxStatus(Integer maxStatus) {
		this.maxStatus = maxStatus;
	}

	public Integer getMinStatus() {
		return minStatus;
	}

	public void setMinStatus(Integer minStatus) {
		this.minStatus = minStatus;
	}
	
	@NotNull(message="顺序不能为空")
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Integer getPayCondition(){return payCondition;}
	public void setPayCondition(Integer payCondition){this.payCondition = payCondition;}
}