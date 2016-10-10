<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>财务应收退款确认</title>
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
        a.anchor {
            display: block;
            position: relative;
            top: -150px;
            visibility: hidden;
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

<form:form id="inputForm" modelAttribute="refundMain" action="${ctx}/oa/refund/audit?sUrl=${sUrl}" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>

<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>

<div class="col-sm-12">
    <div class="container">
        <div class="row m-b-20">
            <div class="col-sm-3">
                <h4>财务应收退款确认</h4>
            </div>
        </div>
    </div>
    <!--合同信息-->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">订单信息</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    合同编号：${purchaseOrder.contract.no}
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
                    我司抬头：${fns:getDictLabel(contract.companyName,"oa_company_name","")}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    采购订单编号 ：${purchaseOrder.no}
                </div>
                <div class="col-sm-6">
                    订单金额 ：<fmt:formatNumber type="number" value="${purchaseOrder.amount}" maxFractionDigits="2"/>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    付款笔数：${fn:length(purchaseOrder.purchaseOrderFinanceList)} 笔
                </div>
                <div class="col-sm-6">
                    已付金额：<fmt:formatNumber type="number" value="${sumFAmount}" maxFractionDigits="2"/>
                </div>
            </div>
        </div>
    </div>

    <!--款项信息-->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">款项信息</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    退款金额：<fmt:formatNumber type="number" value="${refundMain.amount}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-6">
                    <%
                        String datetime=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); //获取系统时间
                        request.setAttribute("currentTime",datetime);
                    %>
                    实际退款日期：<input name="tkDate" type="text" readonly="readonly" style="width: 150px;display:inline;"
                                  class="form-control Wdate input-sm required"
                                  value="${currentTime}"
                                  onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                </div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="text-center">
            <input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onclick="history.go(-1)"/>&nbsp;
            <c:if test="${refundMain.act.hiddenButton ne '1'}">
            <input id="btnSubmit" class="btn btn-custom" type="button" value="确认收款" onclick="return confirmx('请确认已收到这笔款项？', function(){document.forms[0].submit();})"/>
            </c:if>
        </div>
    </div>
    </form:form>
</body>
</html>