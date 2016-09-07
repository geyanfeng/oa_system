<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>确认开票</title>
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
            var amount = ${contract.amount};
            var currentAmount = ${finance.amount};
            var percentage = (currentAmount/amount).toFixed(4) * 100;
            $("#percentage").html(percentage+"%");

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


<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/audit?sUrl=${sUrl}" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>

<%
    String datetime=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); //获取系统时间
    request.setAttribute("currentTime",datetime);
%>
<div class="col-sm-12">
    <!--合同头-->
    <div class="row m-b-20" style="margin-top: 80px !important;">
        <div class="col-sm-3">
            合同编号：<a href="${ctx}/oa/contract/view?id=${contract.id}">${contract.no}</a>
        </div>
        <div class="col-sm-3">
            合同名称：${contract.name}
        </div>
        <div class="pull-right">
            我司抬头: <span class="btn-warning waves-effect waves-light btn-sm">${fns:getDictLabel(contract.companyName, "oa_company_name","" )}</span>
        </div>
    </div>
    <!--合同信息-->
    <div class="panel panel-default">
        <div class="panel-heading">合同信息
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-12">
                    客户名称：${contract.invoiceCustomerName}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    收款金额：${finance.amount}
                </div>
                <div class="col-sm-6">
                    款项进程：${jc}&nbsp;&nbsp;&nbsp;<span id="percentage"></span>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    收款方式：${fns:getDictLabel(finance.payMethod, "oa_payment_method","" )}
                </div>
                <div class="col-sm-6">
                    实际收款日期：<input name="skDate" type="text" readonly="readonly" style="width: 150px;display:inline;"
                                  class="form-control Wdate input-sm required"
                                  value="${currentTime}"
                                  onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                </div>
            </div>
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

    <div class="form-group">
        <div class="col-sm-offset-4 col-sm-8">
            <input id="btnSubmit" class="btn btn-custom" type="submit" value="确认开票"/>&nbsp;

            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </div>
    </form:form>
</body>
</html>