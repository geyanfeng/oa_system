/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.ActEntity;
import org.hibernate.validator.constraints.Length;

import java.util.List;

/**
 * 采购订单Entity
 * @author anthony
 * @version 2016-08-13
 */
public class PurchaseOrder extends ActEntity<PurchaseOrder> {
	
	private static final long serialVersionUID = 1L;
	private String procInsId;		// 流程实例ID
	private String no;		// 订单号
	private Contract contract;		// 合同
	private String companyName;		// 公司抬头
	private Supplier supplier;		// 供应商
	private String paymentDetail;		// 付款信息
	private Integer paymentPointnum;		// 帐期点数
	private Integer shipDate;		// 预计到货时间
	private String remark;		// 备注
	private Double amount;		// 金额
	private List<PurchaseOrderProduct> purchaseOrderProductList = Lists.newArrayList();		// 子表列表
	
	public PurchaseOrder() {
		super();
	}

	public PurchaseOrder(String id){
		super(id);
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	@Length(min=0, max=64, message="流程实例ID长度必须介于 0 和 64 之间")
	public String getProcInsId() {
		return procInsId;
	}

	public void setProcInsId(String procInsId) {
		this.procInsId = procInsId;
	}
	
	@Length(min=0, max=64, message="订单号长度必须介于 0 和 64 之间")
	public String getNo() {
		return no;
	}

	public void setNo(String no) {
		this.no = no;
	}

	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}
	
	@Length(min=1, max=64, message="公司抬头长度必须介于 1 和 64 之间")
	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	
	public Supplier getSupplier() {
		return supplier;
	}

	public void setSupplier(Supplier supplier) {
		this.supplier = supplier;
	}
	
	@Length(min=0, max=4000, message="付款信息长度必须介于 0 和 4000 之间")
	public String getPaymentDetail() {
		return paymentDetail;
	}

	public void setPaymentDetail(String paymentDetail) {
		this.paymentDetail = paymentDetail;
	}
	
	public Integer getPaymentPointnum() {
		return paymentPointnum;
	}

	public void setPaymentPointnum(Integer paymentPointnum) {
		this.paymentPointnum = paymentPointnum;
	}
	
	public Integer getShipDate() {
		return shipDate;
	}

	public void setShipDate(Integer shipDate) {
		this.shipDate = shipDate;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public List<PurchaseOrderProduct> getPurchaseOrderProductList() {
		return purchaseOrderProductList;
	}

	public void setPurchaseOrderProductList(List<PurchaseOrderProduct> purchaseOrderProductList) {
		this.purchaseOrderProductList = purchaseOrderProductList;
	}
}