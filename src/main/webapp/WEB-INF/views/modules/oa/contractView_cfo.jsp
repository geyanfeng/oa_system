<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>查看合同</title>
<meta name="decorator" content="default" />
<style>
.panel-body .row {
	padding: 10px;
	margin: 0;
}

.panel-body .row:not (:last-child ){
	border-bottom: 1px solid #dcdcdc;
}

.panel .panel-body {
	padding: 0;
}

.productChildTable>tbody>tr>td {
	border: 1px solid transparent !important;
}

.div_bill {
	position: absolute;
	right: 10px;
	top: 100px;
	z-index: 1040;
}

html, body {
	background: #FFF;
}

a.anchor {
	display: block;
	position: relative;
	top: -150px;
	visibility: hidden;
}

.table tr th:nth-child(2), .table tr td:nth-child(2) {
	padding-left: 20px;
}

.table {
	margin-bottom: 0;
}

th, td {
	text-align: left;
}
</style>
<script>
	$(function() {
		$.validator.addMethod("val-comment", function(value) {
			return !($('#flag').val() === "no" && value === "");
		}, "请输入驳回信息");

		//表单验证
		$("#inputForm").validate(
				{
					rules : {
						"act.comment" : "val-comment"
					},
					submitHandler : function(form) {
						loading('正在提交，请稍等...');
						form.submit();
					},
					errorContainer : "#messageBox",
					errorPlacement : function(error, element) {
						$("#messageBox").text("输入有误，请先更正。");
						if (element.prop("id") == 'act.comment') {
							error.appendTo(element.closest(".panel").find(
									".panel-heading"));
						} else if (element.is(":checkbox")
								|| element.is(":radio")
								|| element.parent().is(".input-append")) {
							error.appendTo(element.parent().parent());
						} else {
							error.insertAfter(element);
						}
					}
				});
	});
</script>
</head>
<body data-spy="scroll" data-target="#navbar">


	<form:form id="inputForm" modelAttribute="contract"
		action="${ctx}/oa/contract/audit?sUrl=${sUrl}" method="post"
		role="form">
		<form:hidden path="id" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}" />

		<div class="col-sm-12">
			<!--合同信息-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">合同信息</h3>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-6">
							合同编号：<a href="${ctx}/oa/contract/view?id=${contract.id}">${contract.no}</a>
						</div>
						<div class="col-sm-6">合同名称：${contract.name}</div>

					</div>
					<div class="row">
						<div class="col-sm-6">客户名称：${contract.customer.name}</div>
						<div class="col-sm-6">
							我司抬头：${fns:getDictLabel(contract.companyName, 'oa_company_name',"")}
						</div>
					</div>

					<div class="row">
						<div class="col-sm-6">
							合同金额：
							<fmt:formatNumber type="number" value="${contract.amount}"
								maxFractionDigits="2" />
						</div>
						<div class="col-sm-6">
							采购成本：<font color="red"><fmt:formatNumber type="number"
									value="${contract.cost}" maxFractionDigits="2" /></font>
						</div>

					</div>
					<div class="row">
					
						<div class="col-sm-6">
							毛利率：
							<font color="red"><fmt:formatNumber type="number" value="${(contract.amount - contract.cost - contract.customerCost * 1.1)/contract.amount}"
								maxFractionDigits="2" /></font>
						</div>
						<div class="col-sm-6">
							销售奖金：<font color="red"><fmt:formatNumber type="number"
									value="${contract.customerCost}" maxFractionDigits="2" /></font>
						</div>

					</div>
				</div>
			</div>

			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">付款信息</h3>
				</div>
				<div class="panel-body">
					<c:forEach items="${purchaseOrderList}" var="po"
						varStatus="aStatus">
						<div class="row">
							<div class="col-sm-3">
								订单号: <a href="${ctx}/oa/purchaseOrder/view?id=${po.id}">${po.no}</a>
							</div>
							<div class="col-sm-4">供应商: ${po.supplier.name}</div>
							<div class="col-sm-3">付款笔数:
								${fn:length(po.purchaseOrderFinanceList)} 笔</div>
						</div>
						<table class="table table-striped table-condensed table-hover">
							<tbody>
								<c:forEach items="${po.purchaseOrderFinanceList}" var="finance"
									varStatus="bStatus">
									<tr>
										<td class="hidden"></td>
										<td>第${bStatus.count}笔: <fmt:formatNumber type="number"
												value="${(finance.amount / po.amount) * 100}"
												maxFractionDigits="2" />%
										</td>
										<td>付款金额: <fmt:formatNumber type="number"
												value="${finance.amount}" maxFractionDigits="2" /></td>
										<td>帐期: <fmt:formatNumber type="number"
												value="${finance.zq}" maxFractionDigits="0" />天
										</td>
										<td>帐期点数: ${po.paymentPointnum}%</td>
										<td>付款条件: <c:if test="${finance.payCondition eq 0}">预付</c:if><c:if test="${finance.payCondition eq 1}">后付</c:if></td>
										<td>付款方式: <font
											<c:if test="${finance.payMethod eq 3}">color="red"</c:if>>
												${fns:getDictLabel(finance.payMethod,"oa_payment_method","")}</font></td>
									</tr>
								</c:forEach>

							</tbody>
						</table>
					</c:forEach>
				</div>
			</div>


			<c:if
				test="${not empty contract.id and not empty contract.act.procInsId}">
				<act:histoicFlow procInsId="${contract.act.procInsId}" />
			</c:if>

			<!--您的意见和建议-->
			<c:if test="${contract.act.taskDefKey eq 'cfo_audit'}">
				<div class="panel panel-default" id="comment_other">
					<div class="panel-heading">
						<h3 class="panel-title">您的意见和建议</h3>
					</div>
					<div class="panel-body">
						<div class="row">
							<div class="col-sm-12">
								<form:textarea path="act.comment" class="form-control" rows="5" />
							</div>
						</div>
					</div>
				</div>
			</c:if>

			<div class="form-group">
				<div class="text-center">
					<input id="btnCancel" class="btn btn-inverse" type="button"
						value="返 回" onclick="history.go(-1)" />
					<c:if
						test="${contract.contractType ne '1' and not empty contract.id and not empty contract.act.taskDefKey}">

						<input id="btnSubmit" class="btn btn-info" type="submit"
							value="驳回" onclick="$('#flag').val('no')" />&nbsp;
            	<input id="btnSubmit" class="btn btn-custom" type="submit"
							value="同 意" onclick="$('#flag').val('yes')" />&nbsp;
            </c:if>


				</div>
			</div>
	</form:form>
</body>
</html>