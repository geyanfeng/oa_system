<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/assets/js/jquery.form.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules: {
					name: {remote: "${ctx}/oa/customer/checkName?oldName=" + encodeURIComponent('${customer.name}')},
					address: {remote: "${ctx}/oa/customer/checkAddress?oldAddress=" + encodeURIComponent('${customer.address}')},
					phone: {remote: "${ctx}/oa/customer/checkPhone?oldPhone=" + encodeURIComponent('${customer.phone}')}
				},
				messages: {
					name: {remote: "客户名称已存在"},
					address: {remote: "客户地址已存在"},
					phone: {remote: "客户联系方式已存在"}
				},
				<c:if test="${empty fromModal}">
					submitHandler: function(form){
						loading('正在提交，请稍等...');
						form.submit();
					},
				</c:if>
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

			<c:if test="${not empty fromModal}">
				$("#inputForm").ajaxForm({success:function(result){
					var status= result.status;
					if(status!="1") return;
					var frameWin =  top.document.getElementById("mainFrame").contentWindow;
					if(frameWin.closeCustomerModal)
						frameWin.closeCustomerModal(result.data);
				}});
			</c:if>
		});
	</script>
	<style>
		body{padding:0;}
	</style>
</head>
<body>
<c:if test="${empty fromModal}"><h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">客户管理--编辑</h2></c:if>
<div class="panel panel-default" style="margin:0;<c:if test="${not empty fromModal}">border:none;</c:if>">
		<div class="panel-body">
	<form:form id="inputForm" modelAttribute="customer" action="${ctx}/oa/customer/${not empty fromModal?'ajaxSave':'save'}" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-sm-2 control-label">名称 <span class="help-inline"><font color="red">*</font> </span></label>
			<div class="col-sm-4">
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required form-control" />
				
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">地址 </label>
			<div class="col-sm-4">
				<form:input path="address" htmlEscape="false" maxlength="255" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">联系人 </label>
			<div class="col-sm-4">
				<form:input path="contact" htmlEscape="false" maxlength="100" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">电话 </label>
			<div class="col-sm-4">
				<form:input path="phone" htmlEscape="false" maxlength="100" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-actions text-center">
			<shiro:hasPermission name="oa:customer:edit"><input id="btnSubmit" class="btn btn-custom" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<c:if test="${empty fromModal}">
			<input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onclick="history.go(-1)"/>
			</c:if>
		</div>
	</form:form>
	</div>
	</div>
</body>
</html>