/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.google.common.collect.Lists;
import com.thinkgem.jeesite.common.persistence.ActEntity;
import com.thinkgem.jeesite.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;

import java.util.Date;
import java.util.List;

/**
 * 采购订单Entity
 * @author anthony
 * @version 2016-08-13
 */
public class PurchaseOrder extends ActEntity<PurchaseOrder> {
	
	private static final long serialVersionUID = 1L;
	private String no;		// 订单号
	private Contract contract;		// 合同
	private String addressType;		// 地址类型
	private String address;		// 地址
	private Supplier supplier;		// 供应商
	private Double paymentPointnum;		// 帐期点数
	private Integer shipDate;		// 预计到货时间
	private String remark;		// 备注
	private Double amount;		// 金额
	private String status;		// 订单状态
	private Date beginCreateDate;		// 开始 日期
	private Date endCreateDate;		// 结束 日期
	protected String evaluateFlag = "0"; 	// 评价标记（0：未评价；1：已评价）
	private List<PurchaseOrderProduct> purchaseOrderProductList = Lists.newArrayList();		// 子表列表
	private List<PurchaseOrderAttachment> purchaseOrderAttachmentList = Lists.newArrayList();		// 子表列表
	private List<PurchaseOrderFinance> purchaseOrderFinanceList = Lists.newArrayList();
	private Date fkDate;				//付款日期
	private Integer cancelFlag=0;		//撤销标志: 0为没有撤销, 1为撤销
	private String cancelReason;		//撤销原因
	private Date cancelDate;			//撤销时间
	private Double refundMainAmount;	//退款金额
	private Double stockInAmount;		//转库存金额
	private User businessPerson;		// 商务人员
	private User artisan;		// 技术人员
	
	public PurchaseOrder() {
		super();
	}

	public PurchaseOrder(String id){
		super(id);
	}

	@Length(min=1, max=1)
	public String getEvaluateFlag() {
		return evaluateFlag;
	}

	public void setEvaluateFlag(String evaluateFlag) {
		this.evaluateFlag = evaluateFlag;
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Double getAmount() {
		return amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
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

	public String getAddressType() {
		return addressType;
	}

	public void setAddressType(String addressType) {
		this.addressType = addressType;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	
	public Supplier getSupplier() {
		return supplier;
	}

	public void setSupplier(Supplier supplier) {
		this.supplier = supplier;
	}

	public Double getPaymentPointnum() {
		return paymentPointnum;
	}

	public void setPaymentPointnum(Double paymentPointnum) {
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

	public Date getBeginCreateDate() {
		return beginCreateDate;
	}

	public void setBeginCreateDate(Date beginCreateDate) {
		this.beginCreateDate = beginCreateDate;
	}

	public Date getEndCreateDate() {
		return endCreateDate;
	}

	public void setEndCreateDate(Date endCreateDate) {
		this.endCreateDate = endCreateDate;
	}
	
	public List<PurchaseOrderProduct> getPurchaseOrderProductList() {
		return purchaseOrderProductList;
	}

	public void setPurchaseOrderProductList(List<PurchaseOrderProduct> purchaseOrderProductList) {
		this.purchaseOrderProductList = purchaseOrderProductList;
	}

	public List<PurchaseOrderAttachment> getPurchaseOrderAttachmentList() {
		return purchaseOrderAttachmentList;
	}

	public void setPurchaseOrderAttachmentList(List<PurchaseOrderAttachment> purchaseOrderAttachmentList) {
		this.purchaseOrderAttachmentList = purchaseOrderAttachmentList;
	}

	public List<PurchaseOrderFinance> getPurchaseOrderFinanceList(){return purchaseOrderFinanceList;}
	public void setPurchaseOrderFinanceList(List<PurchaseOrderFinance> purchaseOrderFinanceList){
		this.purchaseOrderFinanceList = purchaseOrderFinanceList;
	}

	public Date getFkDate(){return fkDate;}
	public void setFkDate(Date fkDate){this.fkDate = fkDate;}

	public Integer getCancelFlag(){return cancelFlag;}
	public void setCancelFlag(Integer cancelFlag){this.cancelFlag = cancelFlag;}

	public String getCancelReason(){return cancelReason;}
	public void setCancelReason(String cancelReason){this.cancelReason = cancelReason;}

	public Date getCancelDate(){return cancelDate;}
	public void setCancelDate(Date cancelDate){this.cancelDate = cancelDate;}

	public Double getRefundMainAmount(){return refundMainAmount;}
	public void setRefundMainAmount(Double refundMainAmount){this.refundMainAmount = refundMainAmount;}

	public Double getStockInAmount(){return stockInAmount;}
	public void setStockInAmount(Double stockInAmount){this.stockInAmount = stockInAmount;}

	public User getBusinessPerson() {
		return businessPerson;
	}
	public void setBusinessPerson(User businessPerson) {
		this.businessPerson = businessPerson;
	}

	public User getArtisan() {
		return artisan;
	}
	public void setArtisan(User artisan) {
		this.artisan = artisan;
	}
}