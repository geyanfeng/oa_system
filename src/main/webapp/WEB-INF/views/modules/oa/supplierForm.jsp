<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>供应商管理</title>
<meta name="decorator" content="default" />
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
				//var poModalWin =  parent.window.document.getElementById("poFrame").contentWindow;
				var poModalWin = top.document.getElementById("mainFrame").contentWindow.frames["poFrame"];
				if(poModalWin && poModalWin.closeSupplierModal)
					poModalWin.closeSupplierModal(result.data);
			}});
			</c:if>
		});
	</script>
</head>
<body>
	<div class="panel panel-default" style="margin: 0;">
		<div class="panel-body">
			<form:form id="inputForm" modelAttribute="supplier"
				action="${ctx}/oa/supplier/${not empty fromModal?'ajaxSave':'save'}"
				method="post" class="form-horizontal">
				<form:hidden path="id" />
				<sys:message content="${message}" />
				<div class="form-group">
					<label class="col-sm-2 control-label">名称<span class="help-inline"><font color="red">*</font> </span></label>
					<div class="col-sm-4">
						<form:input path="name" htmlEscape="false" maxlength="100"
							class="form-control input-xlarge required" />
						
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">地址</label>
					<div class="col-sm-4">
						<form:input path="address" htmlEscape="false" maxlength="255"
							class="input-xlarge form-control " />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">联系人<font color="red">*</font></label>
					<div class="col-sm-4">
						<form:input path="contact" htmlEscape="false" maxlength="100"
							class="input-xlarge form-control required" />
						
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">联系电话<font color="red">*</font></label>
					<div class="col-sm-4">
						<form:input path="phone" htmlEscape="false" maxlength="100"
							class="input-xlarge form-control required" />
						
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">QQ/微信：</label>
					<div class="col-sm-4">
						<form:input path="qqWebChat" htmlEscape="false" maxlength="100"
							class="input-xlarge form-control " />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">邮箱：</label>
					<div class="col-sm-4">
						<form:input path="email" htmlEscape="false" maxlength="100"
							class="input-xlarge form-control " />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">帐户名称：</label>
					<div class="col-sm-4">
						<form:input path="blankAccountName" htmlEscape="false"
							maxlength="100" class="input-xlarge form-control " />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">开户行：</label>
					<div class="col-sm-4">
						<form:input path="blankName" htmlEscape="false" maxlength="100"
							class="input-xlarge form-control " />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">帐号：</label>
					<div class="col-sm-4">
						<form:input path="blankAccountNo" htmlEscape="false"
							maxlength="100" class="input-xlarge form-control " />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">备注：</label>
					<div class="col-sm-4">
						<form:textarea path="remark" htmlEscape="false" rows="4"
							maxlength="255" class="form-control input-xxlarge " />
					</div>
				</div>
				<div class="form-actions text-center">
					<shiro:hasPermission name="oa:supplier:edit">
						<input id="btnSubmit" class="btn btn-custom" type="submit"
							value="保 存" />&nbsp;</shiro:hasPermission>
					<c:if test="${empty fromModal}">
						<input id="btnCancel" class="btn btn-inverse" type="button" value="返 回"
							onclick="history.go(-1)" />
					</c:if>
				</div>
			</form:form>
		</div>
	</div>
</body>
</html>