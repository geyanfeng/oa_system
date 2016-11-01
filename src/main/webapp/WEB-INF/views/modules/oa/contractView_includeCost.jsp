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

.panel-body .row:not(:last-child){
   border-bottom:1px solid #dcdcdc;
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

.form-group {
	margin-right: 15px;
}
</style>
<script>
        $(function(){
            $.validator.addMethod("val-comment", function(value) {
                return !($('#flag').val() === "no" && value==="");
            }, "请输入驳回信息");

            //表单验证
            $("#inputForm").validate({
                rules: {
                    "act.comment":  "val-comment"
                },
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if(element.prop("id")== 'act.comment'){
                        error.appendTo(element.closest(".panel").find(".panel-heading"));
                    }
                    else if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
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
			<div class="panel panel-default m-t-10">
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
						<div class="col-sm-6">客户评分：${contract.customer.evaluate}</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							我司抬头：${fns:getDictLabel(contract.companyName, 'oa_company_name',"")}
						</div>
						<div class="col-sm-3">销售人员：${contract.createBy.name}</div>
						<div class="col-sm-3">
							业绩分成比例：${contract.performancePercentage}%</div>
					</div>
					<div class="row">
						<div class="col-sm-3">合同类别：${fns: getDictLabel(contract.contractType,"oa_contract_type","")}
						</div>
						<div class="col-sm-3">
							合同金额：
							<fmt:formatNumber type="number" value="${contract.amount}"
								maxFractionDigits="2" />
						</div>
						<div class="col-sm-3">
							采购成本：
							<fmt:formatNumber type="number" value="${contract.cost}"
								maxFractionDigits="2" />
						</div>
						<div class="col-sm-3">帐期：</div>
					</div>
					<div class="row">
						<div class="col-sm-3">
							进销差价：<font style="color:red">
							<fmt:formatNumber type="number"
								value="${contract.amount - contract.cost}" maxFractionDigits="2" /></font>
						</div>
						<div class="col-sm-3">
							销售奖金：<font style="color:red">
							<fmt:formatNumber type="number" value="${contract.customerCost}"
								maxFractionDigits="2" /></font>
						</div>
						<div class="col-sm-3">
							毛利：<font style="color:red">
							<fmt:formatNumber type="number"
								value="${contract.amount - contract.cost - contract.customerCost * 1.1}"
								maxFractionDigits="2" /></font>
						</div>
						<div class="col-sm-3">
							毛利率：<font style="color:red">
							<fmt:formatNumber type="number"
								value="${((contract.amount - contract.cost - contract.customerCost * 1.1)/contract.amount)*100}"
								maxFractionDigits="2" />%</font>
						</div>
					</div>
				</div>
			</div>

			<shiro:hasRole name="cso">
				<c:if test="${not empty is_recall && is_recall eq true}">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">原销售清单</h3>
						</div>
						<div class="panel-body">
							<table id="contentTable_old" class="table table-condensed">
								<thead>
									<tr role="row">
										<th class="hidden"></th>
										<th>名称</th>
										<th>数量</th>
										<th>产品类别</th>
										<th>合同售价</th>
									</tr>
								</thead>
								<tbody id="contractProductList_old">
								</tbody>
							</table>
						</div>
					</div>
					<script type="text/template" id="contractProductViewTpl_old">//<!--
							<tr id="contractProductList_old{{idx}}" row="row" data-idx={{idx}} data-id="{{row.id}}">
								<td class="hidden"></td>
								<td>
									<span>{{row.name}}</span>
								</td>
								<td>
									{{row.num}}
								</td>
								<td>
									{{row.productType.name}}
								</td>
								<td>
									{{row.amount}}
								</td>
							</tr>
							//-->
					</script>
					<script>
						var contractProductRowIdx_old = 0, contractProductViewTpl_old = $("#contractProductViewTpl_old").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "")
						 contractProductList_old = ${fns:toJson(old_product_list)};
						$(document).ready(function () {
							loadOldProducts(contractProductList_old);
						});

						function loadOldProducts(data){
							for (var i = 0; i < data.length; i++) {
								data[i].unitName = "";
								for(var j = 0; j<unitList.length; j++){
									if(data[i].unit!= "" && unitList[j].value == data[i].unit)
									{
										data[i].unitName = unitList[j].label;
										break;
									}
								}

								addRow('#contractProductList_old', contractProductRowIdx_old, contractProductViewTpl_old, data[i]);

								contractProductRowIdx_old = contractProductRowIdx_old + 1;
							}
						}
					</script>
				</c:if>
			</shiro:hasRole>

			<!--销售清单-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">
						<shiro:hasRole name="cso">
							<c:if test="${not empty is_recall && is_recall eq true}">新</c:if>
						</shiro:hasRole>
						销售清单
					</h3>
				</div>
				<div class="panel-body">
					<table id="contentTable" class="table table-condensed">
						<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>名称</th>
								<th>数量</th>
								<th>产品类别</th>
								<th>合同售价</th>
								<th>采购成本</th>
								<th>毛利</th>
								<th>毛利率</th>
							</tr>
						</thead>
						<tbody id="contractProductList">
						</tbody>
					</table>
					<script type="text/template" id="contractProductViewTpl">//<!--
						<tr id="contractProductList{{idx}}" row="row" data-idx={{idx}} data-id="{{row.id}}">
							<td class="hidden"></td>
							<td>
								<span>{{row.name}}</span>
							</td>
							<td>
								{{row.num}}
							</td>
							<td>
								{{row.productType.name}}
							</td>
							<td>
							    {{row.amount}}
							</td>
							<td>
								{{row.cost}}
							</td>
							<td>
								{{row.ml}}
							</td>
							<td>
								{{row.mll}}
							</td>
						</tr>
						//-->
            </script>
				</div>
			</div>
			<script type="text/javascript">
				var contractProductRowIdx = 0, contractProductViewTpl = $("#contractProductViewTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "")
				var unitList = ${fns:getDictListJson('oa_unit')};
				var productTypeList = ${fns:toJson(productTypeList)};
				var contractProductList = ${fns:toJson(contract.contractProductList)};

				$(document).ready(function () {
					loadProducts(contractProductList);
				});

				function loadProducts(data){
					for (var i = 0; i < data.length; i++) {
						data[i].unitName = "";
						for(var j = 0; j<unitList.length; j++){
							if(data[i].unit!= "" && unitList[j].value == data[i].unit)
							{
								data[i].unitName = unitList[j].label;
								break;
							}
						}
						data[i].ml = (data[i].amount - data[i].cost).toFixed(2);
						data[i].mll = ((data[i].ml / data[i].amount) *100).toFixed(2);
						addRow('#contractProductList', contractProductRowIdx, contractProductViewTpl, data[i]);
						if(data[i].ml<0){
							$("#contractProductList"+contractProductRowIdx).css("color","red");
						}
						contractProductRowIdx = contractProductRowIdx + 1;
					}
				}

				function addRow(list, idx, tpl, row) {
					$(list).append(Mustache.render(tpl, {
						idx: idx, delBtn: true, row: row, unitList:unitList
					}));
				}

			</script>

			<!--采购订单列表-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">采购订单列表</h3>
				</div>
				<div class="panel-body">
					<table id="poTable"
						class="table table-striped table-condensed table-hover">
						<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>采购订单编号</th>
								<th>状态</th>
								<th>供应商</th>
								<th>金额</th>
								<th>帐期</th>
								<th>帐期点数</th>
								<th>帐期日利率</th>
								<th>退款金额</th>
								<th>滞库金额</th>
							</tr>
						</thead>
						<tbody id="poBody">
						</tbody>
					</table>
					<script type="text/template" id="poViewTpl">//<!--
						<tr role="row" data-id="{{row.id}}">
							<td class="hidden"></td>
							<td>
							   <a href="${ctx}/oa/purchaseOrder/view?id={{row.id}}">{{row.no}}</a>
							</td>
							<td>
							    {{row.statusLabel}}
							</td>
							<td>
								{{row.supplier.name}}
							</td>
							<td>
								{{row.amount}}
							</td>
							<td>
                                {{row.zq}}
							</td>
							<td>
								{{row.paymentPointnum}}
							</td>
							<td>
                                {{row.zqrll}}
							</td>
							<td>
                                {{row.refundMainAmount}}
							</td>
							<td>
                                {{row.stockInAmount}}
							</td>
						</tr>
						//-->
            </script>
					<script>
                var poList = [] ;
				var poStatusList = ${fns:getDictListJson('oa_po_status')};
                $(function(){
                    loadPoList();
                });
                function loadPoList(){
                    $("#poBody").empty();
                    var poViewTpl = $("#poViewTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    $.getJSON("${ctx}/oa/purchaseOrder/poList/contract/${contract.id}",
                            function(data){
                                poList = data;
                                $.each(data, function(idx, po){
                                    calcPoZq(po);
									for(var j = 0; j<poStatusList.length; j++){
										if(po.status!= "" && po.status == poStatusList[j].value)
										{
											po.statusLabel = poStatusList[j].label;
											break;
										}
									}
                                    addRow("#poBody", idx,poViewTpl,po );
                                });

                    });
                }
            </script>
				</div>
			</div>


			<c:if test="${not empty is_recall && is_recall eq true}">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">额外成本</h3>
						</div>
						<div class="panel-body">
							<div class="row form-inline">
								<div class="col-sm-12">
									<div class="form-group">
										<label><font color="red">滞库金额</font>：</label>

										<form:input path="stockInAmount" htmlEscape="false"
											class="form-control required number " style="width:80px;"
											onchange="updateExtraAmount(this);" />
										&nbsp;元

									</div>

									<div class="form-group">
										<label><font color="red">退货成本</font>：</label>

										<form:input path="returningAmount" htmlEscape="false"
											class="form-control required number " value="0" style="width:80px;"
											onchange="updateExtraAmount(this);" />
										&nbsp;元

									</div>

									<div class="form-group">
										<label><font color="red">额外成本总额</font>：</label>

										<form:input path="extraAmount" htmlEscape="false" style="width:80px;"
											class="form-control required number " />
										&nbsp;元

									</div>

									<div class="form-group">
										<div class="checkbox checkbox-custom checkbox-circle">
											<input type="checkbox" value="true" name="stockInIsDeduction"
												id="stockInIsDeduction"> <label
												for="stockInIsDeduction">是否业绩抵扣</label> <input type="hidden"
												value="on" name="_stockInIsDeduction">
										</div>
									</div>

									<div class="form-group" id="stockInDiscount-group"
										>
										<label>抵扣金额：</label>
										<form:input path="stockInDiscount" htmlEscape="false"
											class="form-control  number " style="width:80px;"/>
										&nbsp;元
									</div>
								</div>
							</div>
						</div>
						</div>
						<script>
				    function updateExtraAmount(sender){
				    	var stockInAmount = parseFloat($("#stockInAmount").val());
                    	var returningAmount = parseFloat($("#returningAmount").val());
                    	$("#extraAmount").val(stockInAmount + returningAmount); 
				    }
					$(function(){
						$("#stockInAmount").val(${stockInSumAmount});
						$("#extraAmount").val(${stockInSumAmount});
						
						//更改是否业绩抵扣
						$("#stockInIsDeduction").change(function(){
							if($(this).prop('checked'))
								$("#stockInDiscount-group").show();
							else {
								$("#stockInDiscount").val("");
								$("#stockInDiscount-group").hide();
							}
						});

						$("#stockInIsDeduction").trigger('change');
					});

				</script>
				</c:if>


			<!--退预付款-->
			<c:if test="${not empty is_recall && is_recall eq true}">
					<div class="panel panel-default m-t-10">
						<div class="panel-heading"><h3 class="panel-title">退预付款</h3></div>
						<div class="panel-body">
							<div class="row">
								<div class="col-sm-4">
									退款方式：${fns:getDictLabel(contract.backPayMethod,"oa_payment_method" ,"" )}
								</div>
								<div class="col-sm-4">
									退款金额：
									<fmt:formatNumber type="number" value="${contract.backAmount}"
													  maxFractionDigits="2" />
								</div>
							</div>
						</div>
					</div>
				</c:if>

			<c:if
				test="${not empty contract.id and not empty contract.act.procInsId}">
				<act:histoicFlow procInsId="${contract.act.procInsId}" />
			</c:if>

			<!--您的意见和建议-->
			<c:if
				test="${contract.act.taskDefKey eq 'saler_audit' ||
                    contract.act.taskDefKey eq 'artisan_audit' ||
                    contract.act.taskDefKey eq 'cso_audit' ||
                    contract.act.taskDefKey eq 'verify_receiving'}">
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

			<div class="form-group clearfix hidden">
				<label class="col-sm-3 control-label">合同状态：</label>
				<div class="col-sm-7">
					<form:select path="status" class="form-control col-md-12 input-sm">
						<form:option value="" label="" />
						<form:options items="${fns:getDictList('oa_contract_status')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
				</div>
			</div>

			<div class="form-group">
				<div class="text-center">
					<input id="btnCancel" class="btn btn-inverse" type="button"
						value="返 回" onClick="history.go(-1)" />
					<c:if
						test="${contract.contractType ne '1' and not empty contract.id and not empty contract.act.taskDefKey}">
						<input id="btnSubmit" class="btn btn-info" type="submit"
							value="驳 回" onClick="$('#flag').val('no')" />
						<input id="btnSubmit" class="btn btn-primary" type="submit"
							value="同 意" onClick="$('#flag').val('yes')" />
					</c:if>
				</div>
			</div>
		</div>
	</form:form>
</body>
</html>