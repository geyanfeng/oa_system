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
    </style>
</head>
<body>
<%--<ul class="nav nav-tabs">
    <li><a href="${ctx}/oa/contract/">合同列表</a></li>
    <li class="active"><a href="${ctx}/oa/contract/form?id=${contract.id}">合同<shiro:hasPermission name="oa:contract:edit">${not empty contract.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:contract:edit">查看</shiro:lacksPermission></a></li>
</ul><br/>--%>

<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/save" method="post" role="form">
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
            <div class="pull-right">
                <a data-toggle="collapse" href="#card-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div>
        </div>
        <div class="panel-body panel-collapse collapse in" id="card-collapse">
            <div class="row">
                <div class="col-sm-3">
                    合同编号：${contract.no}
                </div>
                <div class="col-sm-3">
                    合同名称：${contract.name}
                </div>
                <div class="col-sm-3">
                    合同类别：${fns: getDictLabel(contract.contractType,"oa_contract_type","")}
                </div>
                <div class="col-sm-3">
                    父级合同：${contract.parentName}${not empty contract.parentNo? "(":""}${contract.parentNo}${not empty contract.parentNo? ")":""}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    客户名称：${contract.customer.name}
                </div>
                <div class="col-sm-6">
                    客户评分：
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    创建人：${contract.createBy.name}
                </div>
                <div class="col-sm-3">
                    创建时间：<fmt:formatDate value="${contract.createDate}" pattern="yyyy-MM-dd"/>
                </div>
                <div class="col-sm-3">
                    商务协同：${contract.businessPerson.name}
                </div>
                <div class="col-sm-3">
                    技术协同：${contract.artisan.name}
                </div>
            </div>
        </div>
    </div>

    <!--开票信息-->
    <div class="panel panel-default">
        <div class="panel-heading">开票信息
            <div class="pull-right">
                <a data-toggle="collapse" href="#invoice-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div>
        </div>
        <div class="panel-body" id="invoice-collapse">
            <div class="row">
                <div class="col-sm-12">
                    发票类型：${fns:getDictLabel(contract.invoiceType,"oa_invoice_type" ,"" )}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    客户名称：${contract.invoiceCustomerName}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    纳税人识别码：${contract.invoiceNo}
                </div>
                <div class="col-sm-4">
                    开户行：${contract.invoiceBank}
                </div>
                <div class="col-sm-4">
                    银行帐号：${contract.invoiceBankNo}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    我司抬头：${contract.companyName}
                </div>
                <div class="col-sm-4">
                    地址：${contract.invoiceAddress}
                </div>
                <div class="col-sm-4">
                    电话：${contract.invoicePhone}
                </div>
            </div>
        </div>
    </div>

    <!--采购列表-->
    <div class="panel panel-default" id="card_products">
        <div class="panel-heading">采购列表</div>
        <div class="panel-body panel-collapse collapse in" id="products-collapse">
            <table id="contentTable" class="table table-striped table-condensed">
                <thead>
                <tr role="row">
                    <th class="hidden"></th>
                    <th>采购条目</th>
                    <th>采购价格</th>
                    <th>采购数量</th>
                    <th>单位</th>
                    <th>金额</th>
                    <th>备注</th>
                </tr>
                </thead>
                <tbody id="contractProductList">
                </tbody>
            </table>
            <script type="text/template" id="contractProductTpl">//<!--
						<tr id="contractProductList{{idx}}" row="row" data-idx={{idx}}>
							<td class="hidden">
								<input id="contractProductList{{idx}}_id" name="contractProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="contractProductList{{idx}}_sort" name="contractProductList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="contractProductList{{idx}}_delFlag" name="contractProductList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								{{row.name}}
								<select id="contractProductList{{idx}}_productType" name="contractProductList[{{idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required input-sm" style="width: 40%;display: inline-block;">
									<c:forEach items="${productTypeList}" var="dict">
										<option value="${dict.id}">${dict.name}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								{{row.price}}
							</td>
							<td>
								{{row.num}}
							</td>
							<td>
							    {{row.unitName}}
							</td>
							<td>
								{{row.amount}}
							</td>
							<td>
								{{row.remark}}
							</td>
						</tr>
						//-->
            </script>
            <script type="text/javascript">
                var contractProductRowIdx = 0, contractProductTpl = $("#contractProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                //var childRowIdx = 0, contractProductChildTpl = $("#contractProductChildTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                var unitList = ${fns:getDictListJson('oa_unit')};
                $(document).ready(function () {
                    var data = ${fns:toJson(contract.contractProductList)};
                    for (var i = 0; i < data.length; i++) {
                        data[i].unitName = "";
                        for(var j = 0; j<unitList.length; j++){
                            if(data[i].unit!= "" && unitList[j].value == data[i].unit)
                            {
                                data[i].unitName = unitList[j].label;
                                break;
                            }
                        }
                        addRow('#contractProductList', contractProductRowIdx, contractProductTpl, data[i]);

/*
                        if (data[i].childs) {
                            for (var j = 0; j < data[i].childs.length; j++) {
                                addChildRow('#childProductList' + contractProductRowIdx, contractProductRowIdx, j, contractProductChildTpl, data[i].childs[j]);
                            }
                        }
*/

                        contractProductRowIdx = contractProductRowIdx + 1;
                    }
                });
                function addRow(list, idx, tpl, row) {
                    $(list).append(Mustache.render(tpl, {
                        idx: idx, delBtn: true, row: row, unitList:unitList
                    }));
                    $(list + idx).find("select").each(function () {
                        $(this).val($(this).attr("data-value"));
                    });
                    $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                        var ss = $(this).attr("data-value").split(',');
                        for (var i = 0; i < ss.length; i++) {
                            if ($(this).val() == ss[i]) {
                                $(this).attr("checked", "checked");
                            }
                        }
                    });
                }
            </script>
        </div>
    </div>

    <!--付款信息-->
    <div class="panel panel-default">
        <div class="panel-heading">付款信息</div>
        <div class="panel-body panel-collapse collapse in" id="payment-collapse">
            <form:hidden path="paymentDetail"></form:hidden>
            <div class="row">
                <div class="col-sm-12">
                    付款周期：${fns:getDictLabel(contract.paymentCycle,"oa_payment_cycle" ,"" )}
                </div>
            </div>
            <script type="text/template" id="payment-onetime-tpl">//<!--
                <div class="row" id="payment-onetime">
                    <div class="col-sm-3">付款金额：{{row.payment_onetime_amount}}</div>
                    <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                    <div class="col-sm-3">账期：{{row.payment_onetime_time}}</div>
                    <div class="col-sm-3">账期点数：{{row.payment_onetime_pointnum}}</div>
                </div>
                    //-->
            </script>
            <script type="text/template" id="payment-installment-tpl">//<!--
                <div class="row" id="payment-installment_{{idx}}">
                    <div class="col-sm-4">付款金额：{{row.payment_installment_amount}}</div>
                    <div class="col-sm-4">账期：{{row.payment_installment_time}}</div>
                    <div class="col-sm-4">付款方式：{{row.paymentMethod}}</div>
                </div>
                //-->
            </script>
            <script type="text/template" id="payment-month-tpl">//<!--
                <div class="row" id="payment-month">
                    <div class="col-sm-3">付款金额：{{row.payment_month_amount}}</div>
                    <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                    <div class="col-sm-3">{{type}}数：{{row.payment_month_num}} 个{{type}}</div>
                    <div class="col-sm-3">付款日：{{row.payment_month_day}}</div>
                    <div class="col-sm-3">起始月：{{row.payment_month_start}}</div>
                </div>
                 //-->
            </script>
            <div id="payment-body" data-idx="1">

            </div>
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
            </script>
        </div>
    </div>


    <!--其它-->
    <div class="panel panel-default" id="card_other">
        <div class="panel-heading">其它</div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-3">
                    销售奖金：${contract.customerCost}
                </div>
                <div class="col-sm-3">
                    是否抵扣：${contract.isDeduction? "是":"否"}
                </div>
                <div class="col-sm-3">
                    抵扣金额：${contract.discount}
                </div>
                <div class="col-sm-3">
                    业绩分成比例：${contract.performancePercentage}%
                </div>
            </div>
        </div>
    </div>

    <!--附件-->
    <div class="panel panel-default" id="card_attachemnts">
        <div class="panel-heading">附件</div>
        <div class="panel-body">
            <table id="attchmentTable" class="table table-striped table-condensed">
                <thead>
                <tr role="row">
                    <th class="hidden"></th>
                    <th>附件类型</th>
                    <th>文件名</th>
                    <th>创建时间</th>
                </tr>
                </thead>
                <tbody id="attchmentList">
                <c:forEach items="${contract.contractAttachmentList}" var="attachment" varStatus="status">
                    <tr row="row">
                        <td class="hidden">
                            <input id="contractAttachmentList${status.index}_id"
                                   name="contractAttachmentList[${status.index}].id" type="hidden"
                                   value="${attachment.id}"/>
                        </td>
                        <td>
                                ${fns:getDictLabel(attachment.type, 'oa_contract_attachment_type', '')}
                            <a href="#" title="上传文档" class="zmdi zmdi-upload pull-right"
                               onclick="files${status.index}FinderOpen();"></a>
                            <input id="contractAttachmentList${status.index}_type"
                                   name="contractAttachmentList[${status.index}].type" type="hidden"
                                   value="${attachment.type}"/>
                        </td>
                        <td>
                            <form:hidden id="files${status.index}"
                                         path="contractAttachmentList[${status.index}].files" htmlEscape="false"
                                         maxlength="2000" class="form-control"/>
                            <sys:myckfinder input="files${status.index}" type="files" uploadPath="/oa/contract"
                                            selectMultiple="true"/>
                        </td>
                        <td>
                            <fmt:formatDate value="${attachment.updateDate}" pattern="yyyy-MM-dd"/>
                        </td>
                    </tr>

                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!--备注-->
    <div class="panel panel-default" id="card_other">
        <div class="panel-heading">备注</div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-12">
                    ${contract.remark}
                </div>
            </div>
        </div>
    </div>

    <div class="form-group clearfix hidden">
        <label class="col-sm-3 control-label">合同金额：</label>
        <div class="col-sm-7">
            <form:input path="amount" htmlEscape="false" class="form-control  number input-sm"/>
        </div>
    </div>

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
    <c:if test="${not empty contract.id and not empty contract.act.procInsId}">
        <act:histoicFlow procInsId="${contract.act.procInsId}"/>
    </c:if>
    <div class="form-group">
        <div class="col-sm-offset-4 col-sm-8">

            <shiro:hasPermission name="oa:contract:edit"><input id="btnSubmit"
                                                                class="btn btn-primary waves-effect waves-light"
                                                                type="submit"
                                                                value="保 存"/>&nbsp;
                <c:if test="${contract.contractType ne '1' and not empty contract.id}">
                    <c:if test="${empty contract.act.procInsId}">
                        <input id="btnCancel" class="btn btn-custom" type="submit" value="提交"
                               onclick="$('#flag').val('submit_audit')"/>&nbsp;
                    </c:if>
                    <c:if test="${not empty contract.act.taskId and contract.act.taskDefKey ne 'end' and contract.act.taskDefKey ne 'submit_audit'}">
                        <input id="btnSubmit" class="btn btn-primary" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
                        <input id="btnSubmit" class="btn btn-inverse" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
                    </c:if>
                </c:if>
            </shiro:hasPermission>

            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </div>
    </form:form>

    <%--选择框架合同的modal--%>
    <div id="modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <iframe width="100%" height="500" frameborder="0"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>