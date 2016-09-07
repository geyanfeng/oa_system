<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>查看合同</title>
    <meta name="decorator" content="default"/>
    <style>
        .panel-body .row{
            padding-top: 10px;
        }
        .panel-body .row:not(:last-child){
            border-bottom: 1px solid;
            padding-bottom: 10px;
        }
        .productChildTable>tbody>tr>td{
            border: 1px solid transparent !important;
        }
        .div_bill {position: absolute; right: 10px;top: 100px;z-index:1040;}
        html,body{
            background: #FFF;
        }
        a.anchor {
            display: block;
            position: relative;
            top: -150px;
            visibility: hidden;
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


<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/audit" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>

<div class="col-sm-12">
    <!--合同信息-->
    <div class="panel panel-default">
        <div class="panel-heading">合同信息
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    合同编号：<a href="${ctx}/oa/contract/view?id=${contract.id}">${contract.no}</a>
                </div>
                <div class="col-sm-6">
                    合同名称：${contract.name}
                </div>

            </div>
            <div class="row">
                <div class="col-sm-6">
                    客户名称：${contract.customer.name}
                </div>
                <div class="col-sm-6">
                    客户评分：${contract.customer.evaluate}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    我司抬头：${fns:getDictLabel(contract.companyName, 'oa_company_name',"")}
                </div>
                <div class="col-sm-3">
                    销售人员：${contract.createBy.name}
                </div>
                <div class="col-sm-3">
                    业绩分成比例：${contract.performancePercentage}%
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    合同类别：${fns: getDictLabel(contract.contractType,"oa_contract_type","")}
                </div>
                <div class="col-sm-3">
                    合同金额：<fmt:formatNumber type="number" value="${contract.amount}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    采购成本：<fmt:formatNumber type="number" value="${contract.cost}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    帐期：
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    进销差价：<fmt:formatNumber type="number" value="${contract.amount - contract.cost}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    销售奖金：<fmt:formatNumber type="number" value="${contract.customerCost}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    毛利：<fmt:formatNumber type="number" value="${contract.amount - contract.cost - contract.customerCost * 1.1}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    毛利率：<fmt:formatNumber type="number" value="${(contract.amount - contract.cost - contract.customerCost * 1.1)/contract.amount}" maxFractionDigits="2"/>
                </div>
            </div>
        </div>
    </div>

    <!--采购列表-->
    <div class="panel panel-default" id="card_products">
        <div class="panel-heading">采购列表 </div>
        <div class="panel-body" id="products-collapse">
            <table id="contentTable" class="table table-condensed">
                <thead>
                <tr role="row">
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
                        data[i].mll = data[i].ml / data[i].amount;
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
        <div class="panel-heading">订单列表</div>
        <div class="panel-body">
            <table id="poTable" class="table table-striped table-condensed table-hover">
                <thead>
                <tr role="row">
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

    <c:if test="${not empty contract.id and not empty contract.act.procInsId}">
        <act:histoicFlow procInsId="${contract.act.procInsId}"/>
    </c:if>

    <!--您的意见和建议-->
    <c:if test="${contract.act.taskDefKey eq 'saler_audit' ||
                    contract.act.taskDefKey eq 'artisan_audit' ||
                    contract.act.taskDefKey eq 'cso_audit' ||
                    contract.act.taskDefKey eq 'verify_receiving'}">
        <div class="panel panel-default" id="comment_other">
            <div class="panel-heading">您的意见和建议</div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-sm-12">
                        <form:textarea path="act.comment" class="form-control" rows="5"/>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <div class="form-group clearfix hidden">
        <label class="col-sm-3 control-label">合同状态：</label>
        <div class="col-sm-7">
            <form:select path="status" class="form-control col-md-12 input-sm">
                <form:option value="" label=""/>
                <form:options items="${fns:getDictList('oa_contract_status')}" itemLabel="label" itemValue="value"
                              htmlEscape="false"/>
            </form:select>
        </div>
    </div>

    <div class="form-group">
        <div class="col-sm-offset-4 col-sm-8">
                <c:if test="${contract.contractType ne '1' and not empty contract.id and not empty contract.act.taskDefKey}">
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
                            <input id="btnSubmit" class="btn btn-inverse" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
                </c:if>

            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </div>
    </form:form>
</body>
</html>