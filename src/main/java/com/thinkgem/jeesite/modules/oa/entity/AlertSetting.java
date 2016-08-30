/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import com.thinkgem.jeesite.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

/**
 * 提醒参数设置Entity
 * @author anthony
 * @version 2016-08-30
 */
public class AlertSetting extends DataEntity<AlertSetting> {
	
	private static final long serialVersionUID = 1L;
	private String node;		// 提醒节点
	private Integer isSaler=0;		// 提醒对象:销售
	private Integer isBusinesser=0;		// 提醒对象:商务
	private Integer isTech=0;		// 提醒对象:技术
	private Integer isCso=0;		// 提醒对象:销售总监
	private Integer isCw=0;		// 提醒对象:财务
	private Integer isMsg=0;		// 提醒方式: 站内通知
	private Integer isEmail=0;		// 提醒方式: 邮件通知
	private Integer isCalendar=0;		// 提醒方式: 日历提醒
	private Integer duration=0;		// 持续时间: 0: 提醒一次，1: 直到确认
	private String title;		// 标题模版
	private String content;		// 内容模版
	private String remark;		// 备注
	
	public AlertSetting() {
		super();
	}

	public AlertSetting(String id){
		super(id);
	}

	@Length(min=1, max=100, message="提醒节点长度必须介于 1 和 100 之间")
	public String getNode() {
		return node;
	}

	public void setNode(String node) {
		this.node = node;
	}
	
	public Integer getIsSaler() {
		return isSaler;
	}

	public void setIsSaler(Integer isSaler) {
		this.isSaler = isSaler;
	}

	public Integer getIsBusinesser() {
		return isBusinesser;
	}

	public void setIsBusinesser(Integer isBusinesser) {
		this.isBusinesser = isBusinesser;
	}
	
	public Integer getIsTech() {
		return isTech;
	}

	public void setIsTech(Integer isTech) {
		this.isTech = isTech;
	}
	
	public Integer getIsCso() {
		return isCso;
	}

	public void setIsCso(Integer isCso) {
		this.isCso = isCso;
	}
	
	public Integer getIsCw() {
		return isCw;
	}

	public void setIsCw(Integer isCw) {
		this.isCw = isCw;
	}
	
	public Integer getIsMsg() {
		return isMsg;
	}

	public void setIsMsg(Integer isMsg) {
		this.isMsg = isMsg;
	}
	
	public Integer getIsEmail() {
		return isEmail;
	}

	public void setIsEmail(Integer isEmail) {
		this.isEmail = isEmail;
	}
	
	public Integer getIsCalendar() {
		return isCalendar;
	}

	public void setIsCalendar(Integer isCalendar) {
		this.isCalendar = isCalendar;
	}
	
	public Integer getDuration() {
		return duration;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}
	
	@Length(min=0, max=200, message="标题模版长度必须介于 0 和 200 之间")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=500, message="内容模版长度必须介于 0 和 500 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@Length(min=0, max=255, message="备注长度必须介于 0 和 255 之间")
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}

