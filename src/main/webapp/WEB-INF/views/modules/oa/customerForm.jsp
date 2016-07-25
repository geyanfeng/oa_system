<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules: {
					name: {remote: "${ctx}/oa/customer/checkName?oldName=" + encodeURIComponent('${customer.name}')}
				},
				messages: {
					name: {remote: "客户名称已存在"}
				},
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/customer/">客户列表</a></li>
		<li class="active"><a href="${ctx}/oa/customer/form?id=${customer.id}">客户<shiro:hasPermission name="oa:customer:edit">${not empty customer.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:customer:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="customer" action="${ctx}/oa/customer/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-md-2 control-label">名称：</label>
			<div class="col-md-4">
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required form-control" />
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">地址：</label>
			<div class="col-md-4">
				<form:input path="address" htmlEscape="false" maxlength="255" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">联系人：</label>
			<div class="col-md-4">
				<form:input path="contact" htmlEscape="false" maxlength="100" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">电话：</label>
			<div class="col-md-4">
				<form:input path="phone" htmlEscape="false" maxlength="100" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">状态</label>
				<div class="col-md-4">
					<form:radiobuttons path="usedFlag" items="${fns:getDictList('status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
		</div>

		<div class="form-group">
			<label class="col-md-2 control-label">备注：</label>
			<div class="col-md-4">
				<form:textarea path="remark" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge form-control " />
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="oa:customer:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>