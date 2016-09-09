/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.entity;

import org.hibernate.validator.constraints.Length;
import javax.validation.constraints.NotNull;

import com.thinkgem.jeesite.common.persistence.DataEntity;

/**
 * 消息提醒Entity
 * @author anthony
 * @version 2016-09-08
 */
public class Alert extends DataEntity<Alert> {
	
	private static final long serialVersionUID = 1L;
	private String node;			//节点
	private String ownerId;		// 接收人_id
	private String title;		// 标题
	private String content;		// 内容
	private Integer isRead = 0;		// 是否看过
	
	public Alert() {
		super();
	}

	public Alert(String id){
		super(id);
	}

	@Length(min=1, max=64, message="接收人_id长度必须介于 1 和 64 之间")
	public String getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}

	public String getNode(){return node;}
	public void setNode(String node){this.node= node;}
	
	@Length(min=0, max=255, message="标题长度必须介于 0 和 255 之间")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	@Length(min=0, max=500, message="内容长度必须介于 0 和 500 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	@NotNull(message="是否看过不能为空")
	public Integer getIsRead() {
		return isRead;
	}

	public void setIsRead(Integer isRead) {
		this.isRead = isRead;
	}
	
}