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

			//更改发票类型时,显示或隐藏列
			$('input[name=invoiceType]').change(function () {
				var sVal = $('input[name=invoiceType]:checked ').val();
				switch (sVal) {
					case "2":
						$("div[id^=field-invoice]").show();
						break;
					default:
						$("div[id^=field-invoice]").hide();
						break;
				}
			});
			$('input[name=invoiceType]').trigger('change');

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
			<div class="col-sm-6">
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required form-control" />

			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">地址 </label>
			<div class="col-sm-6">
				<form:input path="address" htmlEscape="false" maxlength="255" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">联系人 </label>
			<div class="col-sm-6">
				<form:input path="contact" htmlEscape="false" maxlength="100" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">电话 </label>
			<div class="col-sm-6">
				<form:input path="phone" htmlEscape="false" maxlength="100" class="input-xlarge form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">发票类型</label>
			<div class="col-sm-10" style="padding-top:6px;">
				<form:radiobuttons path="invoiceType"
								   items="${fns:getDictList('oa_invoice_type')}" itemLabel="label"
								   itemValue="value" htmlEscape="false" class=""
								   element="span class='radio radio-custom radio-inline'" />
			</div>
		</div>
		<div class="form-group clearfix">
			<label class="col-sm-2 control-label">发票抬头</label>
			<div class="col-sm-6">
				<form:input path="invoiceCustomerName" htmlEscape="false"
							maxlength="255" class="form-control" />
			</div>
		</div>

		<div class="form-group" id="field-invoiceNo">
			<label class="col-sm-2 control-label">纳税人识别码</label>
			<div class="col-sm-6">
				<form:input path="invoiceNo" htmlEscape="false" maxlength="255"
							class="form-control" />
			</div>
		</div>
		<div class="form-group" id="field-invoiceBank">
			<label class="col-sm-2 control-label">开户行</label>
			<div class="col-sm-6">
				<form:input path="invoiceBank" htmlEscape="false"
							maxlength="255" class="form-control" />
			</div>
		</div>
		<div class="form-group" id="field-invoiceBankNo">
			<label class="col-sm-2 control-label">银行帐号</label>
			<div class="col-sm-6">
				<form:input path="invoiceBankNo" htmlEscape="false"
							maxlength="255" class="form-control" />
			</div>
		</div>
		<div class="form-group" id="field-invoiceAddress">
			<label class="col-sm-2 control-label">地址 </label>
			<div class="col-sm-6">
				<form:input path="invoiceAddress" htmlEscape="false"
							maxlength="1000" class="form-control" />
			</div>
		</div>
		<div class="form-group" id="field-invoicePhone">
			<label class="col-sm-2 control-label">电话 </label>
			<div class="col-sm-6">
				<form:input path="invoicePhone" htmlEscape="false"
							maxlength="100" class="form-control" />
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