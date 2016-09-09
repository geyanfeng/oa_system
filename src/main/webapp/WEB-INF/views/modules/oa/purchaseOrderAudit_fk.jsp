<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>财务总监付款审核</title>
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
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
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


<form:form id="inputForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/audit?sUrl=${sUrl}" method="post" role="form">
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
                    合同编号：<a href="${ctx}/oa/contract/view?id=${purchaseOrder.contract.id}">${purchaseOrder.contract.no}</a>
                </div>
                <div class="col-sm-6">
                    合同名称：${purchaseOrder.contract.name}
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    供应商名称：${purchaseOrder.supplier.name}
                </div>
                <div class="col-sm-6">
                    我司抬头：${fns:getDictLabel(purchaseOrder.contract.companyName, 'oa_company_name',"")}
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    订单编号 ：<a href="${ctx}/oa/purchaseOrder/view?id=${purchaseOrder.id}">${purchaseOrder.no}</a>
                </div>
                <div class="col-sm-6">
                    订单金额 ：<fmt:formatNumber type="number" value="${purchaseOrder.amount}" maxFractionDigits="2"/>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    付款笔数：${fn:length(purchaseOrder.purchaseOrderFinanceList)} 笔
                </div>
            </div>
        </div>
    </div>

    <!--款项信息-->
    <div class="panel panel-default">
        <div class="panel-heading">款项信息</div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    流水号：${purchaseOrder.no}-F${finance.sort}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    帐户名称：${purchaseOrder.supplier.blankAccountName}
                </div>
                <div class="col-sm-3">开户行：${purchaseOrder.supplier.blankName}</div>
                <div class="col-sm-3">帐号：${purchaseOrder.supplier.blankAccountNo}</div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    第${finance.sort}笔：<fmt:formatNumber type="number"
                                                         value="${(finance.amount / purchaseOrder.amount) * 100}"
                                                         maxFractionDigits="2"/>%</td>
                </div>
                <div class="col-sm-3">
                    付款金额：<fmt:formatNumber type="number" value="${finance.amount}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    帐期：<fmt:formatNumber type="number" value="${finance.zq}" maxFractionDigits="0"/>天
                </div>
                <div class="col-sm-3">
                    付款方式：<font
                        <c:if test="${finance.payMethod eq 3}">color="red"</c:if>> ${fns:getDictLabel(finance.payMethod,"oa_payment_method","")}</font>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    应付日期：<fmt:formatDate value="${finance.planPayDate}" pattern="yyyy-MM-dd"/>
                </div>
                <div class="col-sm-6">
                    <%
                        String datetime=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); //获取系统时间
                        request.setAttribute("currentTime",datetime);
                    %>
                    实际付款日期：<input name="fkDate" type="text" readonly="readonly" style="width: 150px;display:inline;"
                                  class="form-control Wdate input-sm required"
                                  value="${currentTime}"
                                  onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty purchaseOrder.id and not empty purchaseOrder.act.procInsId}">
        <act:histoicFlow procInsId="${purchaseOrder.act.procInsId}"/>
    </c:if>

    <div class="form-group">
        <div class="col-sm-offset-4 col-sm-8">
            <c:if test="${not empty purchaseOrder.act.taskDefKey || empty purchaseOrder.act.procInsId}">
                <c:set var="submitText" value="提交审批"/>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'payment_first'}">
                    <c:set var="submitText" value="财务付首款"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'payment_all'}">
                    <c:set var="submitText" value="财务付全款"/>
                </c:if>

                <c:if test="${purchaseOrder.act.taskDefKey eq 'payment'}">
                    <c:set var="submitText" value="确认付款"/>
                </c:if>

                <input id="btnSubmit" class="btn btn-custom" type="submit" value="${submitText}" onclick="$('#flag').val('submit_audit')"/>&nbsp;
            </c:if>

            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </div>

    </form:form>
</body>
</html>