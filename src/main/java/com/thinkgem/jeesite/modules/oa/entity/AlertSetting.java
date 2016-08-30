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
	private Integer issaler;		// 提醒对象:销售
	private Integer isbusinesser;		// 提醒对象:商务
	private Integer istech;		// 提醒对象:技术
	private Integer iscso;		// 提醒对象:销售总监
	private Integer iscw;		// 提醒对象:财务
	private Integer ismsg;		// 提醒方式: 站内通知
	private Integer isemail;		// 提醒方式: 邮件通知
	private Integer iscalendar;		// 提醒方式: 日历提醒
	private Integer duration;		// 持续时间: 0: 提醒一次，1: 直到确认
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
	
	public Integer getIssaler() {
		return issaler;
	}

	public void setIssaler(Integer issaler) {
		this.issaler = issaler;
	}
	
	public Integer getIsbusinesser() {
		return isbusinesser;
	}

	public void setIsbusinesser(Integer isbusinesser) {
		this.isbusinesser = isbusinesser;
	}
	
	public Integer getIstech() {
		return istech;
	}

	public void setIstech(Integer istech) {
		this.istech = istech;
	}
	
	public Integer getIscso() {
		return iscso;
	}

	public void setIscso(Integer iscso) {
		this.iscso = iscso;
	}
	
	public Integer getIscw() {
		return iscw;
	}

	public void setIscw(Integer iscw) {
		this.iscw = iscw;
	}
	
	public Integer getIsmsg() {
		return ismsg;
	}

	public void setIsmsg(Integer ismsg) {
		this.ismsg = ismsg;
	}
	
	public Integer getIsemail() {
		return isemail;
	}

	public void setIsemail(Integer isemail) {
		this.isemail = isemail;
	}
	
	public Integer getIscalendar() {
		return iscalendar;
	}

	public void setIscalendar(Integer iscalendar) {
		this.iscalendar = iscalendar;
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

