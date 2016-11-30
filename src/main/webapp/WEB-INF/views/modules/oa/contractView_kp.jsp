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
            padding: 10px;
            margin:0;
        }
        .panel-body .row:not(:last-child){
            border-bottom: 1px solid #dcdcdc;
        }
        .panel .panel-body {
        	padding:0;
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


<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/audit?sUrl=${sUrl}" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>

<div class="col-sm-12">
    <!--合同头-->
    <div class="container">
    <div class="row m-b-20" style="margin-top: 80px !important;">
        <div class="col-sm-3">
            合同编号：<a href="${ctx}/oa/contract/view?id=${contract.id}">${contract.no}</a>
        </div>
        <div class="col-sm-3">
            合同名称：${contract.name}
        </div>
        <div class="pull-right">
            我司抬头: <span class="label label-warning" style="font-size:16px;color:#000;">${fns:getDictLabel(contract.companyName, "oa_company_name","" )}</span>
        </div>
    </div>
	</div>
    <!--合同信息-->
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">开票信息</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <c:choose>
                <c:when test="${contract.act.taskDefKey eq 'cw_kp' || contract.act.taskDefKey eq 'cw_kp2'}">
                <div class="col-sm-3">
                    </c:when>
                    <c:otherwise>
                    <div class="col-sm-6">
                        </c:otherwise>
                        </c:choose>
                    发票类型：${fns:getDictLabel(contract.invoiceType, "oa_invoice_type","" )}
                </div>
                        <c:choose>
                        <c:when test="${contract.act.taskDefKey eq 'cw_kp' || contract.act.taskDefKey eq 'cw_kp2'}">
                        <div class="col-sm-3">
                            </c:when>
                            <c:otherwise>
                            <div class="col-sm-6">
                                </c:otherwise>
                                </c:choose>
                    开票金额：<font style="color: red"><fmt:formatNumber type="number" value="${finance.amount}" maxFractionDigits="2" /></font>
                </div>
                <c:if test="${contract.act.taskDefKey eq 'cw_kp' || contract.act.taskDefKey eq 'cw_kp2'}">
                    <div class="col-sm-3 form-inline">
                        <%
                            String datetime=new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime()); //获取系统时间
                            request.setAttribute("currentTime",datetime);
                        %>
                        <font style="color:red">实际开票日期：</font><div class="input-group">
                        <input name="kpDate" type="text" readonly
                                      class="form-control input-sm required"
                                      value="${currentTime}"
                                      onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                         <span class="input-group-addon bg-custom b-0 text-white"><i
                                        class="ti-calendar"></i></span>
                                </div>
                    </div>
                </c:if>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    客户名称：${contract.invoiceCustomerName}
                </div>
                <div class="col-sm-6">
                    纳税人识别码：${contract.invoiceNo}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    开户行：${contract.invoiceBank}
                </div>
                <div class="col-sm-6">
                    银行帐号：${contract.invoiceBankNo}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    地址：${contract.invoiceAddress}
                </div>
                <div class="col-sm-6">
                    电话：${contract.invoicePhone}
                </div>
            </div>
        </div>
    </div>

    <!--备注-->
    <div class="panel panel-default" id="card_other">
        <div class="panel-heading"><h3 class="panel-title">备注</h3></div>
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
        <div class="text-center">
        <c:if test="${contract.act.hiddenButton ne '1'}">
            <c:set var="submitText" value="确认开票"/>
            <c:if test="${contract.act.taskDefKey eq 'can_invoice' || contract.act.taskDefKey eq 'can_invoice2'}">
                <c:set var="submitText" value="确认可以开票"/>
            </c:if>
            <input id="btnSubmit" class="btn btn-custom" type="submit" value="${submitText}"/>&nbsp;
		</c:if>
            <input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onClick="history.go(-1)"/>
        </div>
    </div>
    </form:form>
</body>
</html>