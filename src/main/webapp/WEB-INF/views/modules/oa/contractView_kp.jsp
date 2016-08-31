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
                <div class="col-sm-6">
                    发票类型：${fns:getDictLabel(contract.invoiceType, "oa_invoice_type","" )}
                </div>
                <div class="col-sm-6">
                    开票金额：<font style="color: red">${finance.amount}</font>
                </div>

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