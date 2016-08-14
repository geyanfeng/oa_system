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
        table[id^='childProductList']>tbody>tr>td{
            border: 1px solid transparent !important;
        }
        .div_bill {position: absolute; right: 10px;top: 100px;z-index:1040;}
    </style>
    <script>
        function getModal(){
            return $('#modal');
        }
    </script>
</head>
<body data-spy="scroll" data-target="#navbar">

<c:if test="${contract.act.taskDefKey eq 'business_person_createbill'}">
    <script src="${ctxStatic}/assets/plugins/jquery-ui/jquery-ui.min.js"></script>
    <div class="col-sm-5 div_bill"id="draggable">
        <div class="panel panel-default">
            <div class="panel-heading" style="text-align: center;">采购下单
                <div class="pull-right">
                    <a href="#"><i class="glyphicon glyphicon-remove"></i></a>
                </div>
            </div>
            <div class="panel-body" style="padding:0;">
                <iframe id="poFrame" name="poFrame" scrolling="auto" frameborder="no" src="${ctx}/oa/purchaseOrder/form?contract.id=${contract.id}&fromModal=1" width="100%" height="600px"></iframe>
            </div>
        </div>
    </div>
    <script>
        $( function() {
            $( "#draggable" ).draggable();

            if(parent.mainFrame){
                parent.window.onscroll = function(){
                    var winHeight = $(parent.window).height(), winWidth = $(parent.window).width(), divHeight =  $("#draggable").height(), divWidth = $("#draggable").width();
                    $("#draggable").css('top',parent.window.document.body.scrollTop + (winHeight - divHeight - 100)); //控制上下位置
                    $("#draggable").css('left',(winWidth - divWidth -300 - 20)); //控制横向位置
                };
            } else{
                window.onscroll = function(){
                    var winHeight = $(window).height(), winWidth = $(window).width(), divHeight =  $("#draggable").height(), divWidth = $("#draggable").width();
                    $("#draggable").css('top',document.body.scrollTop + (winHeight - divHeight - 100)); //控制上下位置
                    $("#draggable").css('left',document.body.scrollLeft + (winWidth - divWidth - 20)); //控制横向位置
                };
            }
            if(parent.mainFrame) {
                parent.window.onscroll();
            } else{
                $(window).trigger('scroll');
            }

        });
    </script>
</c:if>

<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/audit" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>
<div class="navbar navbar-default navbar-fixed-top  navbar-static" role="navigation" id="navbar">
    <div class="collapse navbar-collapse bs-js-navbar-scrollspy">
        <ul class="nav navbar-nav">
            <li><a href="#panel-baseInfo">合同信息</a></li>
            <li><a href="#panel-invoice">开票信息</a></li>
            <li><a href="#card_products">采购列表</a></li>
            <li><a href="#panel-payment">付款信息</a></li>
            <li><a href="#card_other">其它信息</a></li>
            <li><a href="#card_attachemnts">附件</a></li>
            <li><a href="#panel-audit">操作信息</a></li>
        </ul>
    </div>
</div>



<div class="col-sm-12">

    <div class="row m-b-20" style="margin-top: 60px !important;">
        <div class="col-sm-3">
            合同编号：${contract.no}
        </div>
        <div class="col-sm-3">
            合同名称：${contract.name}
        </div>
        <div class="pull-right">
            合同状态: <span class="btn-warning waves-effect waves-light btn-sm">${fns:getDictLabel(contract.status, "oa_contract_status","" )}</span>
        </div>
    </div>

    <!--合同信息-->
    <div class="panel panel-default" id="panel-baseInfo">
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
    <div class="panel panel-default" id="panel-invoice">
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
            <table id="contentTable" class="table table-condensed">
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
						<tr id="contractProductList{{idx}}" row="row" data-idx={{idx}} data-id="{{row.id}}">
							<td class="hidden">
								<input id="contractProductList{{idx}}_id" name="contractProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="contractProductList{{idx}}_sort" name="contractProductList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="contractProductList{{idx}}_delFlag" name="contractProductList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="contractProductList{{idx}}_productTypeGroup" name="contractProductList[{{idx}}].productType" type="hidden" value="{{row.productType.id}}"/>

								<input id="contractProductList{{idx}}_name" name="contractProductList[{{idx}}].name" type="hidden" value="{{row.name}}"/>
								<c:if test="${contract.act.taskDefKey ne 'split_po'}">
								    <input id="contractProductList{{idx}}_productType" name="contractProductList[{{idx}}].productType" type="hidden" value="{{row.productType.id}}"/>
								</c:if>
								<input id="contractProductList{{idx}}_price" name="contractProductList[{{idx}}].price" type="hidden" value="{{row.price}}"/>
								<input id="contractProductList{{idx}}_num" name="contractProductList[{{idx}}].num" type="hidden" value="{{row.num}}"/>
								<input id="contractProductList{{idx}}_unit" name="contractProductList[{{idx}}].unit" type="hidden" value="{{row.unit}}"/>
								<input id="contractProductList{{idx}}_amount" name="contractProductList[{{idx}}].amount" type="hidden" value="{{row.amount}}"/>
								<input id="contractProductList{{idx}}_remark" name="contractProductList[{{idx}}].remark" type="hidden" value="{{row.remark}}"/>
								<input id="contractProductList{{idx}}_hasSendNum" name="contractProductList[{{idx}}].hasSendNum" type="hidden" value="{{row.hasSendNum}}"/>
							</td>
							<td>
							    <c:if test="${contract.act.taskDefKey eq 'business_person_createbill'}">
							        <input type="checkbox" onchange="selectProduct(this, '{{row.json}}')">
                                </c:if>
								<span>{{row.name}}</span>
								 <span style="margin-left:50px;">{{row.productTypeGroupName}}</span>
								<c:if test="${contract.act.taskDefKey eq 'split_po'}">
                                    <select id="contractProductList{{idx}}_productType" name="contractProductList[{{idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required input-sm" style="width: 40%;display: inline-block;">
                                        <c:forEach items="${productTypeList}" var="dict">
                                            <option value="${dict.id}">${dict.name}</option>
                                        </c:forEach>
                                    </select>
							        <a href="javascript:" class="fa fa-plus" onclick="addNewChildRow(this)"></a>
                                </c:if>
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
						<tr>
							<td colspan=6 style="padding-left: 40px;">
							 <table class="table table-condensed" id="childProductList{{idx}}_table" style="width: 600px;">
								<tbody id="childProductList{{idx}}">
								  </tbody>
								</table>
							</td>
						<tr>
						//-->
            </script>
            <script type="text/template" id="contractProductChildTpl">//<!--
						<tr id="childProductList{{idx}}_{{child_idx}}" row="row" data-id="{{row.id}}" data-parentid = "{{row.parentId}}">
							<td class="hidden">
								<input id="childProductList{{idx}}_{{child_idx}}_id" name="contractProductList[{{idx}}].childs[{{child_idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_sort" name="contractProductList[{{idx}}].childs[{{child_idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_delFlag" name="contractProductList[{{idx}}].childs[{{child_idx}}].delFlag" type="hidden" value="0"/>
								<input id="childProductList{{idx}}_{{child_idx}}_hasSendNum" name="contractProductList[{{idx}}].childs[{{child_idx}}].hasSendNum" type="hidden" value="{{row.hasSendNum}}"/>
							</td>
							<td>
								<input id="childProductList{{idx}}_{{child_idx}}_name" name="contractProductList[{{idx}}].childs[{{child_idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="form-control required input-sm"  style="width: 50%;display: inline-block;"/>
								<select id="childProductList{{idx}}_{{child_idx}}_productType" name="contractProductList[{{idx}}].childs[{{child_idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required input-sm"  style="width: 40%;display: inline-block;">
									<c:forEach items="${productTypeList}" var="dict">
										<option value="${dict.id}">${dict.name}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="cchildProductList{{idx}}_{{child_idx}}_num" name="contractProductList[{{idx}}].childs[{{child_idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control number input-block required input-sm" onchange="updatePriceAmount(this);"/>
							</td>
							<td>
								<select id="childProductList{{idx}}_{{child_idx}}_unit" name="contractProductList[{{idx}}].childs[{{child_idx}}].unit" data-value="{{row.unit}}" class="form-control input-block required input-sm">
									<c:forEach items="${fns:getDictList('oa_unit')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<shiro:hasPermission name="oa:contract:edit"><td class="text-center" width="10">
								{{#delBtn}}<a href="#" class="on-default remove-row" onclick="delRow(this, '#childProductList{{idx}}_{{child_idx}}')"  title="删除"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>
						//-->
            </script>
            <script type="text/template" id="contractProductChildViewTpl">//<!--
						<tr id="childProductList{{idx}}_{{child_idx}}" row="row" data-id="{{row.id}}" data-parentid = "{{row.parentId}}">
							<td class="hidden">
								<input id="childProductList{{idx}}_{{child_idx}}_id" name="contractProductList[{{idx}}].childs[{{child_idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_sort" name="contractProductList[{{idx}}].childs[{{child_idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_delFlag" name="contractProductList[{{idx}}].childs[{{child_idx}}].delFlag" type="hidden" value="0"/>
								<input id="childProductList{{idx}}_{{child_idx}}_hasSendNum" name="contractProductList[{{idx}}].childs[{{child_idx}}].hasSendNum" type="hidden" value="{{row.hasSendNum}}"/>
							</td>
							<td>
							     <c:if test="${contract.act.taskDefKey eq 'business_person_createbill'}">
							        <input type="checkbox" onchange="selectProduct(this, '{{row.json}}')">
                                </c:if>
								<span style="display:inline-block;width:100px;">{{row.name}}</span>
								<span style="margin-left:50px">{{row.productType.name}}</span>
							</td>
							<td>
								{{row.num}}
							</td>
							<td>
								{{row.unitName}}
							</td>
						</tr>
						//-->
            </script>
            <script type="text/javascript">
                var contractProductRowIdx = 0, contractProductTpl = $("#contractProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                var childRowIdx = 0, contractProductChildTpl = $("#contractProductChildTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),
                        contractProductChildViewTpl = $("#contractProductChildViewTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                var unitList = ${fns:getDictListJson('oa_unit')};
                var productTypeList = ${fns:toJson(productTypeList)};

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
                        data[i].productTypeGroupName = data[i].productType.name;

                        addRow('#contractProductList', contractProductRowIdx, contractProductTpl, data[i]);

                        if (data[i].childs) {
                            for (var j = 0; j < data[i].childs.length; j++) {
                                data[i].childs[j].unitName = "";
                                for(var m = 0; m<unitList.length; m++){
                                    if(data[i].childs[j].unit!= "" && unitList[m].value == data[i].childs[j].unit)
                                    {
                                        data[i].childs[j].unitName = unitList[m].label;
                                        break;
                                    }
                                }
                                addChildRow('#childProductList' + contractProductRowIdx, contractProductRowIdx, j, ${contract.act.taskDefKey eq "split_po"? "contractProductChildTpl": "contractProductChildViewTpl"}, data[i].childs[j]);
                            }
                        }

                        contractProductRowIdx = contractProductRowIdx + 1;
                    }
                });

                function addRow(list, idx, tpl, row) {
                    <c:if test="${contract.act.taskDefKey eq 'business_person_createbill'}">
                        row.json = JSON.stringify(row);
                    </c:if>
                    $(list).append(Mustache.render(tpl, {
                        idx: idx, delBtn: true, row: row, unitList:unitList
                    }));
                    $(list + idx).find("select").each(function () {
                        $(this).val($(this).attr("data-value"));
                    });
                    $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                        var dataValue = $(this).attr("data-value")
                        if(dataValue) {
                            var ss = dataValue.split(',');
                            for (var i = 0; i < ss.length; i++) {
                                if ($(this).val() == ss[i]) {
                                    $(this).attr("checked", "checked");
                                }
                            }
                        }
                    });
                }

                function addChildRow(list, idx, child_idx, tpl, row) {
                    <c:if test="${contract.act.taskDefKey eq 'business_person_createbill'}">
                        row.json = JSON.stringify(row);
                    </c:if>
                    $(list).append(Mustache.render(tpl, {
                        idx: idx, child_idx: child_idx, delBtn: true, row: row
                    }));
                    $(list + "_" + child_idx).find("select").each(function () {
                        $(this).val($(this).attr("data-value"));
                    });
                    $(list + "_" + child_idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                        var dataValue = $(this).attr("data-value")
                        if(dataValue) {
                            var ss = dataValue.split(',');
                            for (var i = 0; i < ss.length; i++) {
                                if ($(this).val() == ss[i]) {
                                    $(this).attr("checked", "checked");
                                }
                            }
                        }
                    });
                }

                function addNewChildRow(sender) {
                    var parentRow = $(sender).closest('tr');
                    var parentIdx = parentRow.data('idx');
                    var childTable = $('#childProductList' + parentIdx + '_table');
                    var childIdx = childTable.find('tr').length;

                    var productTypeGroup = parentRow.find("input[id$='productTypeGroup']").val();

                    addChildRow('#childProductList' + parentIdx, parentIdx, childIdx, contractProductChildTpl);
                }

                function delRow(obj, prefix) {
                    var id = $(prefix + "_id");
                    var delFlag = $(prefix + "_delFlag");
                    if (id.val() == "") {
                        $(obj).parent().parent().remove();
                    } else if (delFlag.val() == "0") {
                        delFlag.val("1");
                        $(obj).html("&divide;").attr("title", "撤销删除");
                        $(obj).parent().parent().addClass("error");
                    } else if (delFlag.val() == "1") {
                        delFlag.val("0");
                        $(obj).html("&times;").attr("title", "删除");
                        $(obj).parent().parent().removeClass("error");
                    }
                }

                function selectProduct(sender, dataString){
                    var self = $(sender);
                    var checked = self.is(':checked');
                    var poFrameWin = document.getElementById("poFrame").contentWindow;
                    var data = JSON.parse(dataString);
                    if(checked){
                        if(data.childs){
                            if(poFrameWin.addProduct){
                                $.each(data.childs, function(idx, item){
                                    $("#card_products tr[data-id='"+ item.id +"'] input:checkbox").prop("checked","checked");
                                    $("#card_products tr[data-id='"+ item.id +"'] input:checkbox").trigger('change');
                                    //poFrameWin.addProduct(item);
                                });
                            }
                        } else {
                            if(poFrameWin.addProduct) {
                                poFrameWin.addProduct(data);
                            } else
                                self.prop("checked","");
                        }
                    } else{
                        if(data.childs) {
                            $.each(data.childs, function(idx, item){
                                if(poFrameWin.removeProduct){
                                    $("#card_products tr[data-id='"+ item.id +"'] input:checkbox").prop("checked","");
                                    poFrameWin.removeProduct(item.id);
                                }
                            });
                        } else{
                            if(poFrameWin.removeProduct){
                                poFrameWin.removeProduct(data.id);
                            } else
                                self.prop("checked","checked");
                        }
                    }
                }

                function unSelectProduct(id){
                    $("#card_products tr[data-id='"+ id +"'] input:checkbox").prop("checked","");
                    var parentId = $("#card_products tr[data-id='"+ id +"']").data("parentid");
                    if(parentId)
                        $("#card_products tr[data-id='"+ parentId +"'] input:checkbox").prop("checked","");
                }
            </script>
        </div>
    </div>

    <!--付款信息-->
    <div class="panel panel-default" id="panel-payment">
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

    <!--物流信息-->
    <div class="panel panel-default">
        <div class="panel-heading">物流信息</div>
        <div class="panel-body panel-collapse collapse in" id="ship-collapse">
            <c:choose>
                <c:when test="${contract.act.taskDefKey eq 'verify_ship'}">
                    <div class="row">
                        <div class="form-group">
                            <label class="control-label">发货方式：</label>
                            <form:radiobuttons path="shipMode" items="${fns:getDictList('oa_ship_mode')}"
                                               itemLabel="label" itemValue="value" htmlEscape="false" class=""
                                               element="span class='radio radio-success radio-inline'"/>

                        </div>
                    </div>
                    <div class="row form-inline">
                        <div class="form-group">
                            <label class="control-label">收货地址：</label>
                            <form:input path="shipAddress" htmlEscape="false" class="form-control  input-sm" size="60"/>
                        </div>
                        <div class="form-group">
                            <label class="control-label">收货人：</label>
                            <form:input path="shipReceiver" htmlEscape="false" class="form-control  input-sm"/>
                        </div>
                        <div class="form-group">
                            <label class="control-label">联系电话：</label>
                            <form:input path="shipPhone" htmlEscape="false" class="form-control  input-sm phone"/>
                        </div>

                    </div>
                    <div class="row form-inline" style="margin-top:10px;">
                        <div class="form-group">
                            <label class="control-label">快递单号：</label>
                            <form:input path="shipEms" htmlEscape="false" class="form-control  input-sm" size="60"/>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <div class="col-sm-6">
                            发货方式：${fns:getDictLabel(contract.shipMode, "oa_ship_mode","" )}
                        </div>
                    </div>
                    <div class="row ">
                        <div class="col-sm-4">
                            收货地址：${contract.shipAddress}
                        </div>
                        <div class="col-sm-4">
                            收货人：${contract.shipReceiver}
                        </div>
                        <div class="col-sm-4">
                           联系电话：${contract.shipPhone}
                        </div>

                    </div>
                    <div class="row" style="margin-top:10px;">
                        <div class="col-sm-6">
                            快递单号：${contract.shipEms}
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
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
                        <form:textarea path="act.comment" class="required form-control" rows="5"/>
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
                <c:if test="${contract.contractType ne '1' and not empty contract.id}">
                    <c:choose>
                        <c:when test="${empty contract.act.procInsId ||
                                            contract.act.taskDefKey eq 'split_po' ||
                                            contract.act.taskDefKey eq 'contract_edit' ||
                                            contract.act.taskDefKey eq 'business_person_createbill' ||
                                            contract.act.taskDefKey eq 'verify_ship' ||
                                            contract.act.taskDefKey eq 'cw_kp' ||
                                            contract.act.taskDefKey eq 'verify_sk' ||
                                            contract.act.taskDefKey eq 'finish'}">
                            <input id="btnCancel" class="btn btn-custom" type="submit" value="提交" onclick="$('#flag').val('submit_audit')"/>&nbsp;
                        </c:when>

                        <c:otherwise>
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
                            <input id="btnSubmit" class="btn btn-inverse" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
                        </c:otherwise>
                    </c:choose>


                    <%--<c:if test="${empty contract.act.procInsId}">
                        <input id="btnCancel" class="btn btn-custom" type="submit" value="提交"
                               onclick="$('#flag').val('submit_audit')"/>&nbsp;
                    </c:if>
                    <c:if test="${not empty contract.act.taskId and contract.act.taskDefKey ne 'end' and contract.act.taskDefKey ne 'submit_audit'}">
                        <input id="btnSubmit" class="btn btn-primary" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
                        <input id="btnSubmit" class="btn btn-inverse" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
                    </c:if>--%>
                </c:if>

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