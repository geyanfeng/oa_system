<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>合同撤回申请审核</title>
<meta name="decorator" content="default" />
<style>
.panel-body .row {
	padding: 10px;
	margin: 0;
}

.panel-body
 
.row
:not
 
(
:last-child
 
){
border-bottom
:
 
1
px
 
solid
 
#dcdcdc
;

        
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
	<div class="navbar navbar-default navbar-fixed-top  navbar-static"
		role="navigation" id="navbar">
		<div class="collapse navbar-collapse bs-js-navbar-scrollspy">
			<ul class="nav navbar-nav">
				<li><a href="#panel-1">合同信息</a></li>
				<li><a href="#panel-2">开票信息</a></li>
				<li><a href="#panel-3">采购列表</a></li>
				<li><a href="#panel-9">订单列表</a></li>
				<li><a href="#panel-4">付款信息</a></li>
				<li><a href="#panel-5">收货信息</a></li>
				<li id="li-other"><a href="#panel-6">其它信息</a></li>
				<li><a href="#panel-7">附件</a></li>
				<li><a href="#panel-8">操作信息</a></li>
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
					<div class="col-sm-3"><h3>合同撤回申请审核</h3></div>
				</div>
			</div>
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
							进销差价：
							<fmt:formatNumber type="number"
								value="${contract.amount - contract.cost}" maxFractionDigits="2" />
						</div>
						<div class="col-sm-3">
							销售奖金：
							<fmt:formatNumber type="number" value="${contract.customerCost}"
								maxFractionDigits="2" />
						</div>
						<div class="col-sm-3">
							毛利：
							<fmt:formatNumber type="number"
								value="${contract.amount - contract.cost - contract.customerCost * 1.1}"
								maxFractionDigits="2" />
						</div>
						<div class="col-sm-3">
							毛利率：
							<fmt:formatNumber type="number"
								value="${((contract.amount - contract.cost - contract.customerCost * 1.1)/contract.amount) *100}"
								maxFractionDigits="2" />%
						</div>
					</div>
				</div>
			</div>

			<!--采购列表-->
			<div class="panel panel-default" id="card_products">
				<div class="panel-heading">
					<h3 class="panel-title">采购列表</h3>
				</div>
				<div class="panel-body" id="products-collapse">
					<table id="contentTable" class="table table-condensed">
						<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>采购条目</th>
								<th>采购数量</th>
								<th>产品组</th>
								<th>合同价</th>
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
								{{row.mll}}%
							</td>
						</tr>
						//-->
                </script>
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
                            data[i].ml = data[i].amount - data[i].cost - (${contract.customerCost} * (data[i].amount / ${contract.cost}) * 1.1);
                            data[i].mll = ((data[i].ml / data[i].amount)*100).toFixed(2);
                            addRow('#contractProductList', contractProductRowIdx, contractProductViewTpl, data[i]);

                            contractProductRowIdx = contractProductRowIdx + 1;
                        }
                    }

                    function addRow(list, idx, tpl, row) {
                        $(list).append(Mustache.render(tpl, {
                            idx: idx, delBtn: true, row: row, unitList:unitList
                        }));
                    }

                </script>
				</div>
			</div>

			<!--订单列表-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">订单列表</h3>
				</div>
				<div class="panel-body">
					<table id="poTable"
						class="table table-striped table-condensed table-hover">
						<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>订单编号</th>
								<th>供应商</th>
								<th>金额</th>
								<th>帐期</th>
								<th>帐期点数</th>
								<th>帐期日利率</th>
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
						</tr>
						//-->
                </script>
					<script>
                    var poList = [] ;
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
                                        addRow("#poBody", idx,poViewTpl,po );
                                    });

                                });
                    }
                </script>
				</div>
			</div>

			<!--撤回原因-->
			<div class="panel panel-default m-t-10">
				<div class="panel-heading">
					<h3 class="panel-title">撤回原因</h3>
				</div>
				<div class="panel-body">
					<div class="row">
						<div class="col-sm-6 text-danger">
							<c:if test="${recall_type eq 1}">合同撤销</c:if>
							<c:if test="${recall_type eq 2}">合同修改</c:if>
						</div>

					</div>
					<div class="row">
						<div class="col-sm-12  text-danger">备注：${recall_remark}</div>

					</div>
				</div>
			</div>

			<c:if
				test="${not empty contract.id and not empty contract.act.procInsId}">
				<act:histoicFlow procInsId="${contract.act.procInsId}" />
			</c:if>

			<!--您的意见和建议-->

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


			<div class="form-group">
				<div class="text-center">
					<input id="btnCancel" class="btn btn-inverse" type="button"
						value="返 回" onclick="history.go(-1)" />
					<c:if
						test="${contract.contractType ne '1' and not empty contract.id and not empty contract.act.taskDefKey}">
						
                    <input id="btnSubmit" class="btn btn-primary"
							type="submit" value="同 意" onclick="$('#flag').val('yes')" />
							<input id="btnCancel" class="btn btn-info" type="submit"
							value="驳 回" onclick="$('#flag').val('no')" />
                </c:if>
				</div>
			</div>
		</div>
	</form:form>
</body>
</html>