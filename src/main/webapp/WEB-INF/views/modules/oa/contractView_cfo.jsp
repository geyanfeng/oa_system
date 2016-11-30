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

		function disableButtons(){
			$("#btnSubmit").attr("disabled","disabled");
			$("#btnUnAudit").attr("disabled","disabled");
		}

		function enableButtons(){
			$("#btnSubmit").removeAttr("disabled");
			$("#btnUnAudit").removeAttr("disabled");
		}

		$("#inputForm").submit(function(){
			disableButtons();
		});

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
					invalidHandler: function(){
						enableButtons();
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
<div id="navbar">
    <div class="collapse navbar-collapse bs-js-navbar-scrollspy">
        <ul class="nav navbar-nav">
            <li><a href="#panel-1" class="on">合同信息</a></li>
			<li><a href="#panel-3">收款信息</a></li>
            <li><a href="#panel-4">付款信息</a></li>
            <li><a href="#panel-8">操作信息</a></li>
            <li id="li-other"><a href="#panel-6">其它信息</a></li>
        </ul>
    </div>
</div>

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
			<div class="container">
				<div class="row m-b-20" style="margin-top: 80px !important;">
					<div class="col-sm-3">财务总监审核</div>
				</div>
			</div>
			<!--合同信息-->
			<a class="anchor" name="panel-1"></a>
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
							<font color="red"><fmt:formatNumber type="number" value="${((contract.amount - contract.cost - contract.customerCost * 1.1)/contract.amount)*100}"
								maxFractionDigits="2" />%</font>
						</div>
						<div class="col-sm-6">
							销售奖金：<font color="red"><fmt:formatNumber type="number"
									value="${contract.customerCost}" maxFractionDigits="2" /></font>
						</div>

					</div>
				</div>
			</div>

			<!--收款信息-->
			<a class="anchor" name="panel-3"></a>
			<div class="panel panel-default">
				<div class="panel-heading"><h3 class="panel-title">收款信息</h3></div>
				<div class="panel-body panel-collapse collapse in" id="payment-collapse">
					<div class="row">
						<div class="col-sm-12">
							收款周期：${fns:getDictLabel(contract.paymentCycle,"oa_payment_cycle" ,"" )}
						</div>
					</div>

					<div id="payment-body" data-idx="1">
						<table class="table table-striped table-condensed">
							<thead>
							<tr row="row">
                            	<th class="hidden"></th>
								<th>收款次数</th>
								<th>收款金额</th>
								<th>收款方式</th>
								<th>收款条件</th>
								<th>状态</th>
								<th>开票时间</th>
								<th>预计收款时间</th>
								<th>实际收款时间</th>
							</tr>
							</thead>
							<tbody >
							<c:forEach items="${contract.contractFinanceList}" var="finance" varStatus="status">
								<tr row="row">
                                	<td class="hidden"></td>
									<td>${status.count}</td>
									<td><fmt:formatNumber type="number" value="${finance.amount}" maxFractionDigits="2" /></td>
									<td>${fns:getDictLabel(finance.payMethod, "oa_payment_method" ,"银行转帐" )}</td>
									<td>${finance.payCondition eq 0 ? '预付':'后付'}</td>
									<td>${finance.status eq 1 ? '未开票': finance.status eq 2 ? '已开票':'已收款'}</td>
									<td><fmt:formatDate value="${finance.billingDate}" pattern="yyyy-MM-dd" /></td>
									<td><fmt:formatDate value="${finance.planPayDate}" pattern="yyyy-MM-dd" /></td>
									<td><fmt:formatDate value="${finance.payDate}" pattern="yyyy-MM-dd" /></td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
						<%--   <script type="text/template" id="payment-onetime-tpl">//<!--
                               <div class="row" id="payment-onetime">
                                   <div class="col-sm-3">付款金额：{{row.payment_onetime_amount}}</div>
                                   <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                                   <div class="col-sm-3">账期：{{row.payment_onetime_time}}</div>
                                   <div class="col-sm-3">付款条件：{{row.payCondition}}</div>
                               </div>
                                   //-->
                           </script>
                           <script type="text/template" id="payment-installment-tpl">//<!--
                               <div class="row" id="payment-installment_{{idx}}">
                                   <div class="col-sm-3">付款金额：{{row.payment_installment_amount}}</div>
                                   <div class="col-sm-3">账期：{{row.payment_installment_time}}</div>
                                   <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                                   <div class="col-sm-3">付款条件：{{row.payCondition}}</div>
                               </div>
                               //-->
                           </script>
                           <script type="text/template" id="payment-month-tpl">//<!--
                               <div class="row" id="payment-month">
                                   <div class="col-sm-3">付款金额：{{row.payment_month_amount}}</div>
                                   <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                                   <div class="col-sm-2">{{type}}数：{{row.payment_month_num}} 个{{type}}</div>
                                   <div class="col-sm-2">付款日：{{row.payment_month_day}}</div>
                                   <div class="col-sm-2">起始月：{{row.payment_month_start}}</div>
                               </div>
                                //-->
                           </script>
                           <script type="text/javascript">
                               $(document).ready(function () {
                                   if ($('#id').val()!="") {
                                       //load payment detail from saved data
                                       var paymentDetail = JSON.parse(${fns:toJson(contract.paymentDetail)});
                                       var paymentCycle = ${contract.paymentCycle};
                                       var paymentMethod = ${fns:getDictListJson("oa_payment_method")};
                                       switch (paymentCycle) {
                                           case 1:
                                                for(i=0;i<paymentMethod.length;i++){
                                                    if(paymentMethod[i].value == paymentDetail.payment_onetime_paymentMethod)
                                                    {
                                                        paymentDetail.paymentMethod= paymentMethod[i].label;
                                                        break;
                                                    }
                                                }
                                                if(paymentDetail.payment_onetime_payCondition == 1){
                                                    paymentDetail.payCondition = "后付";
                                                } else{
                                                    paymentDetail.payCondition = "预付";
                                                }
                                               addPaymentRow(paymentCycle, paymentDetail);
                                               break;
                                           case 2:
                                               $.each(paymentDetail, function (idx, item) {
                                                   for(i=0;i<paymentMethod.length;i++){
                                                       if(paymentMethod[i].value == item.payment_installment_paymentMethod)
                                                       {
                                                           item.paymentMethod= paymentMethod[i].label;
                                                           break;
                                                       }
                                                   }
                                                   if(item.payment_installment_payCondition == 1){
                                                       item.payCondition = "后付";
                                                   } else{
                                                       item.payCondition = "预付";
                                                   }
                                                   addPaymentRow(paymentCycle, item, idx + 1);
                                               });
                                               break;
                                           case 3:
                                           case 4:
                                               for(i=0;i<paymentMethod.length;i++){
                                                   if(paymentMethod[i].value == paymentDetail.payment_month_paymentMethod)
                                                   {
                                                       paymentDetail.paymentMethod= paymentMethod[i].label;
                                                       break;
                                                   }
                                               }
                                               addPaymentRow(paymentCycle, paymentDetail);
                                               break;
                                       }
                                   }
                               });

                               function addPaymentRow(paymentCycle,row,idx){
                                   switch(paymentCycle) {
                                       case 1:
                                           $("#payment-body").append(Mustache.render($("#payment-onetime-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {row: row}));
                                           break;
                                       case 2:
                                           if (!idx)
                                               idx = 1;
                                           $("#payment-body").append(Mustache.render($("#payment-installment-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                                               idx: idx,
                                               row: row
                                           }));
                                           idx = idx + 1;
                                           $("#payment-body").data("idx", idx);
                                           break;
                                       case 3:
                                           $("#payment-body").append(Mustache.render($("#payment-month-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                                               type: "月",
                                               row: row
                                           }));
                                           break;
                                       case 4:
                                           $("#payment-body").append(Mustache.render($("#payment-month-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                                               type: "季",
                                               row: row
                                           }));
                                           break;
                                   }
                               }
                           </script>--%>
				</div>
			</div>

			<a class="anchor" name="panel-4"></a>
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">付款信息</h3>
				</div>
				<div class="panel-body">
					<c:forEach items="${purchaseOrderList}" var="po"
						varStatus="aStatus">
						<div class="row" style="border-top: 1px solid #e0e0e0;">
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
										<td class="hidden" style="border:none;"></td>
										<td style="border:none;">第${bStatus.count}笔: <fmt:formatNumber type="number"
												value="${po.amount eq 0 ? 0:((finance.amount / po.amount) * 100)}"
												maxFractionDigits="2" />%
										</td>
										<td style="border:none;">付款金额: <fmt:formatNumber type="number"
												value="${finance.amount}" maxFractionDigits="2" /></td>
										<td style="border:none;">帐期: <fmt:formatNumber type="number"
												value="${finance.zq}" maxFractionDigits="0" />天
										</td>
										<td style="border:none;">帐期点数: ${po.paymentPointnum}%</td>
										<td style="border:none;">付款条件: <c:if test="${finance.payCondition eq 0}">预付</c:if><c:if test="${finance.payCondition eq 1}">后付</c:if></td>
										<td style="border:none;">付款方式: <font
											<c:if test="${finance.payMethod eq 3}">color="red"</c:if>>
												${fns:getDictLabel(finance.payMethod,"oa_payment_method","")}</font></td>
									</tr>
								</c:forEach>

							</tbody>
						</table>
					</c:forEach>
				</div>
			</div>

			<a class="anchor" name="panel-8"></a>
			<c:if
				test="${not empty contract.id and not empty contract.act.procInsId}">
				<act:histoicFlow procInsId="${contract.act.procInsId}" />
			</c:if>

			<a class="anchor" name="panel-6"></a>
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
						value="返 回" onClick="history.go(-1)" />
					<c:if
						test="${contract.contractType ne '1' and not empty contract.id and not empty contract.act.taskDefKey}">

						<input id="btnUnAudit" class="btn btn-info" type="submit"
							value="驳回" onClick="$('#flag').val('no')" />
            	<input id="btnSubmit" class="btn btn-primary" type="submit"
							value="同 意" onClick="$('#flag').val('yes')" />
            </c:if>


				</div>
			</div>
	</form:form>
	<script>
		$(function(){
			$('#mainFrame',top.document).parent().parent().css({paddingTop:'3px'});
			$(top.document).scroll(function(){
				var _height = $(this).scrollTop();
				$('#navbar').css({position:'absolute',top:_height + 'px'});
			});
		});
	</script>
</body>
</html>