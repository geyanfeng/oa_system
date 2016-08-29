<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品类型组管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
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
		<li class="active"><a href="${ctx}/oa/productTypeGroup/form?id=${productTypeGroup.id}">商品类型组<shiro:hasPermission name="oa:productTypeGroup:edit">${not empty productTypeGroup.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:productTypeGroup:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="productTypeGroup" action="${ctx}/oa/productTypeGroup/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-md-2 control-label">名称：</label>
			<div class="col-md-4">
				<form:input path="name" htmlEscape="false" maxlength="100" class="form-control required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		
		<div class="form-group">
			<label class="col-md-2 control-label">税收点数TR：</label>
			<div class="col-md-4">
				<form:input path="avalue" htmlEscape="false" class="form-control  number required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">调整系数AC：</label>
			<div class="col-md-4">
				<form:input path="bvalue" htmlEscape="false" class="form-control  number required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">激励系数EC：</label>
			<div class="col-md-4">
				<form:input path="cvalue" htmlEscape="false" class="form-control  number required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">备注：</label>
			<div class="col-md-4">
				<form:input path="remark" htmlEscape="false" maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="oa:productTypeGroup:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>