/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.thinkgem.jeesite.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.Date;

/**
 * 奖金发放记录Entity
 * @author anthony
 * @version 2016-10-19
 */
public class BonusRecord extends DataEntity<BonusRecord> {
	
	private static final long serialVersionUID = 1L;
	private String contractId;		// 合同id
	private Double bonus;		// 资金金额
	private Date bonusDate;		// 发放日期
	private Integer sort;		// sort
	
	public BonusRecord() {
		super();
	}

	public BonusRecord(String id){
		super(id);
	}

	@Length(min=0, max=64, message="合同id长度必须介于 1 和 64 之间")
	public String getContractId() {
		return contractId;
	}

	public void setContractId(String contractId) {
		this.contractId = contractId;
	}
	
	@NotNull(message="资金金额不能为空")
	public Double getBonus() {
		return bonus;
	}

	public void setBonus(Double bonus) {
		this.bonus = bonus;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd")
	@NotNull(message="发放日期不能为空")
	public Date getBonusDate() {
		return bonusDate;
	}

	public void setBonusDate(Date bonusDate) {
		this.bonusDate = bonusDate;
	}
	
	//@NotNull(message="sort不能为空")
	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}
	
}