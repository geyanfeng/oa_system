<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/assets/js/jquery.form.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
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
				var poModalWin =  parent.window.document.getElementById("poFrame").contentWindow;
				if(poModalWin.closeSupplierModal)
					poModalWin.closeSupplierModal(result.data);
			}});
			</c:if>
		});
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="supplier" action="${ctx}/oa/supplier/${not empty fromModal?'ajaxSave':'save'}" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-md-2 control-label">名称：</label>
			<div class="col-md-4">
				<form:input path="name" htmlEscape="false" maxlength="100" class="form-control input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">备注：</label>
			<div class="col-md-4">
				<form:textarea path="remark" htmlEscape="false" rows="4" maxlength="255" class="form-control input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="oa:supplier:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<c:if test="${empty fromModal}">
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</c:if>
		</div>
	</form:form>
</body>
</html>