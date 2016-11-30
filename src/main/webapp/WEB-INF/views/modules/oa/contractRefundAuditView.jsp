<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同退预付款确认</title>
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
        $(function(){
            function disableButtons(){
                $("#btnSubmit").attr("disabled","disabled");
                //$("#btnUnAudit").attr("disabled","disabled");
            }

            function enableButtons(){
                $("#btnSubmit").removeAttr("disabled");
                //$("#btnUnAudit").removeAttr("disabled");
            }

            $("#inputForm").submit(function(){
                disableButtons();
            });

            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                invalidHandler: function(){
                    enableButtons();
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

<form:form id="inputForm" modelAttribute="contractRefund" action="${ctx}/oa/contractrefund/audit?sUrl=${sUrl}" method="post" role="form">
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
                <c:choose>
                    <c:when test="${contractRefund.act.taskDefKey eq 'cfo_audit'}">
                        <h4>财务总监确认预付款退款</h4>
                    </c:when>
                    <c:otherwise>
                        <h4>财务确认预付款退款</h4>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>
    <!--合同信息-->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">合同信息</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    合同编号：${contract.no}
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
                    我司抬头：${fns:getDictLabel(contract.companyName,"oa_company_name","")}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    合同金额：<fmt:formatNumber type="number" value="${contract.amount}" maxFractionDigits="2" />
                </div>
                <div class="col-sm-6">
                    收款笔数 ：${skCount}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    已收金额：<font color="red"> <fmt:formatNumber type="number" value="${sumFAmount}" maxFractionDigits="2"/></font>
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
                <div class="col-sm-3">
                    退款金额：<fmt:formatNumber type="number" value="${contractRefund.amount}" maxFractionDigits="2"/>
                </div>
                <div class="col-sm-3">
                    退款方式：${fns:getDictLabel(contractRefund.payMethod,"oa_payment_method" , "现金")}
                </div>
                <div class="col-sm-3">
                    <%
                        String datetime=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); //获取系统时间
                        request.setAttribute("currentTime",datetime);
                    %>
                    <c:choose>
                        <c:when test="${contractRefund.act.taskDefKey eq 'cfo_audit'}">
                            应退日期：<input name="planTkDate" type="text" readonly="readonly" style="width: 150px;display:inline;"
                            class="form-control Wdate input-sm required"
                            value="${currentTime}"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                        </c:when>
                        <c:otherwise>
                            实退日期：<input name="tkDate" type="text" readonly="readonly" style="width: 150px;display:inline;"
                            class="form-control Wdate input-sm required"
                            value="${currentTime}"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="text-center">
            <input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onclick="history.go(-1)"/>&nbsp;
            <input id="btnSubmit" class="btn btn-custom" type="submit" value="确认退款"/>
        </div>
    </div>
    </form:form>
</body>
</html>