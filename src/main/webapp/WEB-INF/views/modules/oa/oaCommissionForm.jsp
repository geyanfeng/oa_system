<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>佣金统计管理</title>
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
		<li><a href="${ctx}/oa/oaCommission/">佣金统计列表</a></li>
		<li class="active"><a href="${ctx}/oa/oaCommission/form?id=${oaCommission.id}">佣金统计<shiro:hasPermission name="oa:oaCommission:edit">${not empty oaCommission.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:oaCommission:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="oaCommission" action="${ctx}/oa/oaCommission/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-md-2 control-label">年：</label>
			<div class="col-md-4">
				<form:input path="year" htmlEscape="false" maxlength="4" class="form-control required digits"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">季度：</label>
			<div class="col-md-4">
				<form:input path="quarter" htmlEscape="false" maxlength="1" class="form-control required digits"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">合同ID：</label>
			<div class="col-md-4">
				<form:input path="contractId" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">支付ID：</label>
			<div class="col-md-4">
				<form:input path="paymentId" htmlEscape="false" maxlength="64" class="form-control required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">合同金额：</label>
			<div class="col-md-4">
				<form:input path="sv" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">合同采购成本：</label>
			<div class="col-md-4">
				<form:input path="cog" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">客户费用：</label>
			<div class="col-md-4">
				<form:input path="cc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">物流费用：</label>
			<div class="col-md-4">
				<form:input path="lc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">开票日期：</label>
			<div class="col-md-4">
				<input name="billingDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate "
					value="<fmt:formatDate value="${oaCommission.billingDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">收款日期：</label>
			<div class="col-md-4">
				<input name="payDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate "
					value="<fmt:formatDate value="${oaCommission.payDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">账期天数：</label>
			<div class="col-md-4">
				<form:input path="pccday" htmlEscape="false" maxlength="5" class="form-control  digits"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">支付金额(所有产品组)：</label>
			<div class="col-md-4">
				<form:input path="payment" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">产品组占比支付百分比：</label>
			<div class="col-md-4">
				<form:input path="rate" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">销售人员ID：</label>
			<div class="col-md-4">
				<form:input path="kSalerId" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">销售人员ID：</label>
			<div class="col-md-4">
				<form:input path="kId" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">产品组名称：</label>
			<div class="col-md-4">
				<form:input path="kName" htmlEscape="false" maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">付款金额：</label>
			<div class="col-md-4">
				<form:input path="kSv" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">采购成本：</label>
			<div class="col-md-4">
				<form:input path="kCog" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">客户费用：</label>
			<div class="col-md-4">
				<form:input path="kCc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">物流费用：</label>
			<div class="col-md-4">
				<form:input path="kLc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">毛利指标为GPI,本Q指标：</label>
			<div class="col-md-4">
				<form:input path="kGpi" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">税收点数TR：</label>
			<div class="col-md-4">
				<form:input path="kTr" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">AC调整系数AC 如净利（NP)&lt;0，则调整系数 AC=1：</label>
			<div class="col-md-4">
				<form:input path="kAc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">激励系数EC 如净利（NP)&lt;0，则激励系数 EC=1：</label>
			<div class="col-md-4">
				<form:input path="kEc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">账期点数PCC：</label>
			<div class="col-md-4">
				<form:input path="kPcc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">销售费用COS=销售额SV*税收点数TR+采购成本COG*账期点数PCC+物流费用LC：</label>
			<div class="col-md-4">
				<form:input path="kCos" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">提成系数SCC：</label>
			<div class="col-md-4">
				<form:input path="kScc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">实际完成毛利为GP：</label>
			<div class="col-md-4">
				<form:input path="gp" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">本期毛利：</label>
			<div class="col-md-4">
				<form:input path="kGp" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">本期净利：</label>
			<div class="col-md-4">
				<form:input path="kNp" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">税收成本：</label>
			<div class="col-md-4">
				<form:input path="kTrV" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">账期成本：</label>
			<div class="col-md-4">
				<form:input path="kPccV" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-md-2 control-label">业绩提成：</label>
			<div class="col-md-4">
				<form:input path="kYjV" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">额外佣金：</label>
			<div class="col-md-4">
				<form:input path="kEwV" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">合计：</label>
			<div class="col-md-4">
				<form:input path="kSc" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="oa:oaCommission:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>