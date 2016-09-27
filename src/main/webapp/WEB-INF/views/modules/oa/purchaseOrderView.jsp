<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>查看订单</title>
    <meta name="decorator" content="default"/>
    <style>
        .panel-body .row{
            padding: 10px;
            margin:0;
        }
        .panel-body .row:not(:last-child){
            border-bottom: 1px solid #dcdcdc;
        }
        .panel .panel-body {
        	padding:0;
        }
        table[id^='childProductList']>tbody>tr>td{
            border: 1px solid transparent !important;
        }
        .div_bill {position: absolute; right: 10px;top: 100px;z-index:1040;}
        html,body{
            background: #FFF;
        }
        .table tr th:nth-child(2),.table tr td:nth-child(2){
        	padding-left:20px;
        }
        .table{
        	margin-bottom:0;
        }
        th,td{text-align:left;}
    </style>
    <script>
        function getModal(){
            return $('#modal');
        }

        $(function(){
            if(parent.mainFrame){
                if(parent.window)
                    $(parent.window).scroll( function(){
                        if(parent.window)
                            $('.navbar').css('top', parent.window.document.body.scrollTop)
                    });
            }
        });
    </script>
</head>
<body data-spy="scroll" data-target="#navbar">

<form:form id="inputForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/audit?sUrl=${sUrl}" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>
<div role="navigation" id="navbar">
    <div class="collapse navbar-collapse bs-js-navbar-scrollspy">
        <ul class="nav navbar-nav">
            <li><a href="#panel-1" class="on">合同信息</a></li>
            <li><a href="#panel-2">供应商信息</a></li>
            <li><a href="#panel-3">采购清单</a></li>
            <li><a href="#panel-4">付款信息</a></li>
            <li><a href="#panel-5">发货信息</a></li>
            <li><a href="#panel-6">附件</a></li>
            <li><a href="#panel-7">操作日志</a></li>
        </ul>
    </div>
</div>

<div class="col-sm-12">
	<div class="container">
    <div class="row m-b-20" style="margin-top: 80px !important;">
        <div class="col-sm-3">
            采购订单编号 ：${purchaseOrder.no}
        </div>
        <div class="pull-right">
            订单状态: <span class="label label-${fns:getDictRemark(contract.status,"oa_po_status","warning")}" style="font-size:16px;color:#000;">${fns:getDictLabel(purchaseOrder.status, "oa_po_status","" )}</span>
        </div>
    </div>
	</div>
    <!--合同信息-->
    <a class="anchor" name="panel-1"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">合同信息
            <div class="pull-right">
                <a data-toggle="collapse" href="#card-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div>
            </h3>
        </div>
        <div class="panel-body panel-collapse collapse in" id="card-collapse">
            <div class="row">
                <div class="col-sm-3">
                    合同编号：${purchaseOrder.contract.no}
                </div>
                <div class="col-sm-3">
                    合同名称：${purchaseOrder.contract.name}
                </div>
                <div class="col-sm-3">
                    合同类别：${fns: getDictLabel(purchaseOrder.contract.contractType,"oa_purchaseOrder_type","")}
                </div>
                <div class="col-sm-3">
                    父级合同：${purchaseOrder.contract.parentName}${not empty purchaseOrder.contract.parentNo? "(":""}${purchaseOrder.contract.parentNo}${not empty purchaseOrder.contract.parentNo? ")":""}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    客户名称：${purchaseOrder.contract.customer.name}
                </div>
                <div class="col-sm-6">
                    合同状态：${fns:getDictLabel(purchaseOrder.contract.status, "oa_contract_status","" )}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    创建人：${purchaseOrder.contract.createBy.name}
                </div>
                <div class="col-sm-3">
                    创建时间：<fmt:formatDate value="${purchaseOrder.contract.createDate}" pattern="yyyy-MM-dd"/>
                </div>
                <div class="col-sm-3">
                    商务协同：${purchaseOrder.contract.businessPerson.name}
                </div>
                <div class="col-sm-3">
                    技术协同：${purchaseOrder.contract.artisan.name}
                </div>
            </div>
        </div>
    </div>

    <!--供应商信息-->
    <%--todo:供应商信息不完善 --%>
    <a class="anchor" name="panel-2"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">供应商信息 </h3></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    供应商名称：${purchaseOrder.supplier.name}
                </div>
                <div class="col-sm-6">
                    联系地址：${purchaseOrder.supplier.name}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    联系人：
                </div>
                <div class="col-sm-3">
                    联系电话：
                </div>
                <div class="col-sm-3">
                    QQ/微信：
                </div>
                <div class="col-sm-3">
                    Email：
                </div>
            </div>

        </div>
     </div>

    <!--采购列表-->
    <a class="anchor" name="panel-3"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">采购列表</h3></div>
        <div class="panel-body">
            <table id="contentTable" class="table table-condensed">
                <thead>
                <tr role="row">
                	<th class="hidden"></th>
                    <th>名称</th>
                    <th>产品类别</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>单位</th>
                    <th>金额</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${purchaseOrder.purchaseOrderProductList}" var="product" varStatus="status">
                <tr>
                	<td class="hidden"></td>
                    <td>${product.name}</td>
                    <td>${product.productType.name}</td>
                    <td>${product.price}</td>
                    <td>${product.num}</td>
                    <td>${fns:getDictLabel(product.unit,"oa_unit" ,"" )}</td>
                    <td>${product.amount}</td>
                </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!--付款信息-->
    <%--todo: 付款期限--%>
    <a class="anchor" name="panel-4"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">付款信息</h3></div>
        <div class="panel-body">
            <script type="text/template" id="payment-installment-tpl">//<!--
                <div class="row" id="payment-installment_{{idx}}">
                    <div class="col-sm-3">付款金额：{{row.amount}}</div>
                    <div class="col-sm-3">账期：{{row.zq}}</div>
                    <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                    <div class="col-sm-3">付款期限：{{row.activeDate}}</div>
                </div>
                //-->
            </script>
            <div id="payment-body" data-idx="1">
            </div>
            <script type="text/javascript">
                $(document).ready(function () {
                    if ($('#id').val()!="") {
                        //load payment detail from saved data
                        var paymentDetail = ${fns:toJson(purchaseOrder.purchaseOrderFinanceList)};
                        var paymentMethod = ${fns:getDictListJson("oa_payment_method")};
                        $.each(paymentDetail, function (idx, item) {
                            for(i=0;i<paymentMethod.length;i++){
                                if(paymentMethod[i].value == item.payMethod)
                                {
                                    item.paymentMethod= paymentMethod[i].label;
                                    break;
                                }
                            }
                            addPaymentRow(item, idx + 1);
                        });


                    }
                });

                function addPaymentRow(row,idx){
                    if (!idx)
                        idx = 1;
                    $("#payment-body").append(Mustache.render($("#payment-installment-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                        idx: idx,
                        row: row
                    }));
                    idx = idx + 1;
                    $("#payment-body").data("idx", idx);
                }
            </script>

            <div class="row">
                <div class="col-sm-3">账期点数：${purchaseOrder.paymentPointnum}</div>
                <div class="col-sm-3">日利率：</div>
            </div>
        </div>
    </div>

    <!--发货信息-->
    <a class="anchor" name="panel-5"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">发货信息</h3></div>
        <div class="panel-body">
            <div class="row"><%--todo: 发货信息--%>
                <div class="col-sm-6">发货地址：
                  <c:choose>
   			<c:when test="${purchaseOrder.addressType eq '1'}">
   				杨浦区国伟路135号13号楼401
   			</c:when>
   			<c:otherwise>
   			 ${purchaseOrder.address}
   			</c:otherwise>
   		  </c:choose>
               
                </div>
                <div class="col-sm-3">发货周期：${purchaseOrder.shipDate}</div>
                <div class="col-sm-3">发货方式：到${fns:getDictLabel(purchaseOrder.addressType,"oa_po_address_type" ,"" )}</div>
            </div>
        </div>
    </div>

    <!--附件-->
    <a class="anchor" name="panel-6"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">附件</h3></div>
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
                <c:forEach items="${purchaseOrder.purchaseOrderAttachmentList}" var="attachment" varStatus="status">
                    <tr row="row">
                        <td class="hidden">
                            <input id="purchaseOrderAttachmentList${status.index}_id"
                                   name="purchaseOrderAttachmentList[${status.index}].id" type="hidden"
                                   value="${attachment.id}"/>
                        </td>
                        <td>
                                ${fns:getDictLabel(attachment.type, 'oa_po_attachment_type', '')}
                            <a href="#" title="上传文档" class="zmdi zmdi-upload pull-right"
                               onclick="files${status.index}FinderOpen();"></a>
                            <input id="purchaseOrderAttachmentList${status.index}_type"
                                   name="purchaseOrderAttachmentList[${status.index}].type" type="hidden"
                                   value="${attachment.type}"/>
                        </td>
                        <td>
                            <form:hidden id="files${status.index}"
                                         path="purchaseOrderAttachmentList[${status.index}].files" htmlEscape="false"
                                         maxlength="2000" class="form-control"/>
                            <sys:myckfinder input="files${status.index}" type="files" uploadPath="/oa/purchaseOrder"
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
        <div class="panel-heading"><h3 class="panel-title">备注</h3></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-12">
                        ${purchaseOrder.remark}
                </div>
            </div>
        </div>
    </div>

    <a class="anchor" name="panel-7"></a>
    <c:if test="${not empty purchaseOrder.id and not empty purchaseOrder.act.procInsId}">
        <act:histoicFlow procInsId="${purchaseOrder.act.procInsId}"/>
    </c:if>

    <c:if test="${purchaseOrder.act.taskDefKey eq 'verify_receiving'}">
    <!--您的意见和建议-->
    <div class="panel panel-default" id="comment_other">
        <div class="panel-heading"><h3 class="panel-title">您的意见和建议</h3></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-12">
                    <form:textarea path="act.comment" class="required form-control" rows="5"/>
                </div>
            </div>
        </div>
    </div>
    </c:if>


    <div class="form-group">
        <div class="text-center">
            <c:if test="${not empty purchaseOrder.act.taskDefKey || empty purchaseOrder.act.procInsId}">
                <c:set var="submitText" value="提交审批"/>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'business_person_createbill'}">
                    <c:set var="submitText" value="确认下单"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'cfo_confirm_payment_1' || purchaseOrder.act.taskDefKey eq 'cfo_confirm_payment_2' || purchaseOrder.act.taskDefKey eq 'cfo_confirm_payment_3'}">
                    <c:set var="submitText" value="批准付款"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'payment_first'}">
                    <c:set var="submitText" value="财务付首款"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'payment_all'}">
                    <c:set var="submitText" value="财务付全款"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'payment'}">
                    <c:set var="submitText" value="确认付款"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'verify_ship_1' || purchaseOrder.act.taskDefKey eq 'verify_ship_2'}">
                    <c:set var="submitText" value="商务确认发货"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'verify_receiving_1' || purchaseOrder.act.taskDefKey eq 'verify_receiving_2'}">
                    <c:set var="submitText" value="技术确认验收"/>
                </c:if>

                <c:choose>
                    <c:when test="${purchaseOrder.act.taskDefKey eq 'verify_receiving_1' || purchaseOrder.act.taskDefKey eq 'verify_receiving_2'}">
                        <input id="btnSubmit" class="btn btn-custom" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
                        <input id="btnSubmit" class="btn btn-info" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
                    </c:when>
                    <c:otherwise>
                        <input id="btnSubmit" class="btn btn-custom" type="submit" value="${submitText}" onclick="$('#flag').val('submit_audit')"/>&nbsp;
                    </c:otherwise>
                </c:choose>
            </c:if>

            <input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </div>
    </form:form>
    <script>
    $(function(){
    	$('#mainFrame',window.parent.document).parent().parent().css({paddingTop:'3px'});
    	$(window.parent.document).scroll(function(){
        	var _height = $(window.parent.document).scrollTop();
       		$('#navbar').css({position:'absolute',top:_height + 'px'});
        });
    });  
    </script>
</body>
</html>