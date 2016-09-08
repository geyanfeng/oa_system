/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import com.thinkgem.jeesite.modules.sys.entity.User;

/**
 * 佣金统计Entity
 * @author frank
 * @version 2016-09-07
 */
public class OaCommission extends DataEntity<OaCommission> {
	
	private static final long serialVersionUID = 1L;
	private Integer year;		// 年
	private Integer quarter;		// 季度
	private String contractId;		// 合同ID
	private String paymentId;		// 支付ID
	private Double sv;		// 合同金额
	private Double cog;		// 合同采购成本
	private Double cc;		// 客户费用
	private Double lc;		// 物流费用
	private Date billingDate;		// 开票日期
	private Date payDate;		// 收款日期
	private Integer pccday;		// 账期天数
	private Double payment;		// 支付金额(所有产品组)
	private Double rate;		// 产品组占比支付百分比
	private String kSalerId;		// 销售人员ID
	private String kId;		// 销售人员ID
	private String kName;		// 产品组名称
	private Double kSv;		// 付款金额
	private Double kCog;		// 采购成本
	private Double kCc;		// 客户费用
	private Double kLc;		// 物流费用
	private Double kGpi;		// 毛利指标为GPI,本Q指标
	private Double kTr;		// 税收点数TR
	private Double kAc;		// AC调整系数AC 如净利（NP)&lt;0，则调整系数 AC=1
	private Double kEc;		// 激励系数EC 如净利（NP)&lt;0，则激励系数 EC=1
	private Double kPcc;		// 账期点数PCC
	private Double kCos;		// 销售费用COS=销售额SV*税收点数TR+采购成本COG*账期点数PCC+物流费用LC
	private Double kScc;		// 提成系数SCC
	private Double gp;		// 实际完成毛利为GP
	private Double kGp;		// 本期毛利
	private Double kNp;		// 本期净利
	private Double kTrV;		// 税收成本
	private Double kPccV;		// 账期成本
	private Double kJzV;		// 净值
	private Double kYjV;		// 业绩提成
	private Double kEwV;		// 额外佣金
	private Double kSc;		// 合计
	private User saler;		// 销售人员
	private Contract contract;		// 合同
	private ContractFinance finance;
	private Integer paymentSchedule;		// 款项进度
	
	public OaCommission() {
		super();
	}

	public OaCommission(String id){
		super(id);
	}

	public Integer getPaymentSchedule() {
		return paymentSchedule;
	}

	public void setPaymentSchedule(Integer paymentSchedule) {
		this.paymentSchedule = paymentSchedule;
	}
	
	public User getSaler() {
		return saler;
	}

	public void setSaler(User saler) {
		this.saler = saler;
	}
	
	public ContractFinance getContractFinance() {
		return finance;
	}

	public void setContractFinance(ContractFinance finance) {
		this.finance = finance;
	}
	
	public Contract getContract() {
		return contract;
	}

	public void setContract(Contract contract) {
		this.contract = contract;
	}
	
	@NotNull(message="年不能为空")
	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}
	
	@NotNull(message="季度不能为空")
	public Integer getQuarter() {
		return quarter;
	}

	public void setQuarter(Integer quarter) {
		this.quarter = quarter;
	}
	
	@Length(min=0, max=64, message="合同ID长度必须介于 0 和 64 之间")
	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	
	@Length(min=1, max=64, message="支付ID长度必须介于 1 和 64 之间")
	public String getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}
	
	public Double getSv() {
		return sv;
	}

	public void setSv(Double sv) {
		this.sv = sv;
	}
	
	public Double getCog() {
		return cog;
	}

	public void setCog(Double cog) {
		this.cog = cog;
	}
	
	public Double getCc() {
		return cc;
	}

	public void setCc(Double cc) {
		this.cc = cc;
	}
	
	public Double getLc() {
		return lc;
	}

	public void setLc(Double lc) {
		this.lc = lc;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getBillingDate() {
		return billingDate;
	}

	public void setBillingDate(Date billingDate) {
		this.billingDate = billingDate;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	
	public Integer getPccday() {
		return pccday;
	}

	public void setPccday(Integer pccday) {
		this.pccday = pccday;
	}
	
	public Double getPayment() {
		return payment;
	}

	public void setPayment(Double payment) {
		this.payment = payment;
	}
	
	public Double getRate() {
		return rate;
	}

	public void setRate(Double rate) {
		this.rate = rate;
	}
	
	@Length(min=0, max=64, message="销售人员ID长度必须介于 0 和 64 之间")
	public String getKSalerId() {
		return kSalerId;
	}

	public void setKSalerId(String kSalerId) {
		this.kSalerId = kSalerId;
	}
	
	@Length(min=0, max=64, message="销售人员ID长度必须介于 0 和 64 之间")
	public String getKId() {
		return kId;
	}

	public void setKId(String kId) {
		this.kId = kId;
	}
	
	@Length(min=0, max=255, message="产品组名称长度必须介于 0 和 255 之间")
	public String getKName() {
		return kName;
	}

	public void setKName(String kName) {
		this.kName = kName;
	}
	
	public Double getKSv() {
		return kSv;
	}

	public void setKSv(Double kSv) {
		this.kSv = kSv;
	}
	
	public Double getKCog() {
		return kCog;
	}

	public void setKCog(Double kCog) {
		this.kCog = kCog;
	}
	
	public Double getKCc() {
		return kCc;
	}

	public void setKCc(Double kCc) {
		this.kCc = kCc;
	}
	
	public Double getKLc() {
		return kLc;
	}

	public void setKLc(Double kLc) {
		this.kLc = kLc;
	}
	
	public Double getKGpi() {
		return kGpi;
	}

	public void setKGpi(Double kGpi) {
		this.kGpi = kGpi;
	}
	
	public Double getKTr() {
		return kTr;
	}

	public void setKTr(Double kTr) {
		this.kTr = kTr;
	}
	
	public Double getKAc() {
		return kAc;
	}

	public void setKAc(Double kAc) {
		this.kAc = kAc;
	}
	
	public Double getKEc() {
		return kEc;
	}

	public void setKEc(Double kEc) {
		this.kEc = kEc;
	}
	
	public Double getKPcc() {
		return kPcc;
	}

	public void setKPcc(Double kPcc) {
		this.kPcc = kPcc;
	}
	
	public Double getKCos() {
		return kCos;
	}

	public void setKCos(Double kCos) {
		this.kCos = kCos;
	}
	
	public Double getKScc() {
		return kScc;
	}

	public void setKScc(Double kScc) {
		this.kScc = kScc;
	}
	
	public Double getGp() {
		return gp;
	}

	public void setGp(Double gp) {
		this.gp = gp;
	}
	
	public Double getKGp() {
		return kGp;
	}

	public void setKGp(Double kGp) {
		this.kGp = kGp;
	}
	
	public Double getKNp() {
		return kNp;
	}

	public void setKNp(Double kNp) {
		this.kNp = kNp;
	}
	
	public Double getKTrV() {
		return kTrV;
	}

	public void setKTrV(Double kTrV) {
		this.kTrV = kTrV;
	}
	
	public Double getKPccV() {
		return kPccV;
	}

	public void setKPccV(Double kPccV) {
		this.kPccV = kPccV;
	}
	
	public Double getKJzV() {
		return kJzV;
	}

	public void setKJzV(Double kJzV) {
		this.kJzV = kJzV;
	}
	
	public Double getKYjV() {
		return kYjV;
	}

	public void setKYjV(Double kYjV) {
		this.kYjV = kYjV;
	}
	
	public Double getKEwV() {
		return kEwV;
	}

	public void setKEwV(Double kEwV) {
		this.kEwV = kEwV;
	}
	
	public Double getKSc() {
		return kSc;
	}

	public void setKSc(Double kSc) {
		this.kSc = kSc;
	}
	
}