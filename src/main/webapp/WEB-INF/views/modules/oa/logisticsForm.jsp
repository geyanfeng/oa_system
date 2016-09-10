<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>物流管理</title>
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
		<li><a href="${ctx}/oa/logistics/">物流列表</a></li>
		<li class="active"><a href="${ctx}/oa/logistics/form?id=${logistics.id}">物流<shiro:hasPermission name="oa:logistics:edit">${not empty logistics.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:logistics:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<div class="tab-content">
	<form:form id="inputForm" modelAttribute="logistics" action="${ctx}/oa/logistics/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-md-2 control-label">名称 <span class="help-inline"><font color="red">*</font> </span></label>
			<div class="col-md-4">
				<form:select path="name" class="form-control input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('oa_ship_mode')}" itemLabel="label"
								  itemValue="value" htmlEscape="false"/>
				</form:select>
				
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">费用 </label>
			<div class="col-md-4">
				<form:input path="cost" htmlEscape="false" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-actions text-center">
			<shiro:hasPermission name="oa:logistics:edit"><input id="btnSubmit" class="btn btn-custom" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
	</div>
</body>
</html>