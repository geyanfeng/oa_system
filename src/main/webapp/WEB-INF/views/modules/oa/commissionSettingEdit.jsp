<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>佣金参数 -- 编辑</title>
    <meta name="decorator" content="default"/>
    <style>
        .row {
            margin-top: 10px;
            text-align: center;
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
<body>
<form:form id="inputForm" modelAttribute="setting" action="${ctx}/oa/commissionSetting/save" method="post" role="form">
    <sys:message content="${message}"/>
<div class="panel panel-default">
    <div class="panel-heading">佣金参数 -- 编辑</div>
    <div class="panel-body">
        <div class="col-sm-6">
            <!--提成系数SCC设置-->
            <h4 class="text-custom">提成系数SCC设置</h4>
            <div class="row">
                <div class="col-sm-10">
                    完成毛利GP情况
                </div>
                <div class="col-sm-2">
                    参数
                </div>
            </div>
            <c:forEach items="${list1}" var="setting" varStatus="settingIdx">
                <div class="row">
                    <input name="CommissionSettings1[${settingIdx.index}].id" value="${setting.id}"
                           class="hidden">
                    <input name="CommissionSettings1[${settingIdx.index}].fkey.value" value="${setting.fkey.value}"
                           class="hidden">
                    <div class="col-sm-10">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                            <input name="CommissionSettings1[${settingIdx.index}].avalue" value="${empty setting.avalue? '0':setting.avalue}"  class="text number required">
                    </div>
                </div>
            </c:forEach>

            <!--税收点数TR与调整系数AC设置-->
           <%-- <h4 class="text-custom">税收点数TR与调整系数AC设置</h4>
            <div class="row">
                <div class="col-sm-8">
                    产品组
                </div>
                <div class="col-sm-2">
                    税收点数TR
                </div>
            </div>
            <c:forEach items="${list2}" var="setting" varStatus="settingIdx">
                <div class="row">
                    <input name="CommissionSettings2[${settingIdx.index}].id" value="${setting.id}"
                           class="hidden">
                    <input name="CommissionSettings2[${settingIdx.index}].fkey.value" value="${setting.fkey.value}"
                           class="hidden">
                    <div class="col-sm-8">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                        <input name="CommissionSettings2[${settingIdx.index}].avalue" value="${empty setting.avalue? '0':setting.avalue}"  class="text number required">
                    </div>
                </div>
            </c:forEach>


            <!--调整系数AC与激励系数EC设置-->
            <h4 class="text-custom">调整系数AC与激励系数EC设置</h4>
            <div class="row">
                <div class="col-sm-8">
                    产品组
                </div>
                <div class="col-sm-2">
                    调整系数AC
                </div>
                <div class="col-sm-2">
                    激励系数EC
                </div>
            </div>
            <c:forEach items="${list3}" var="setting" varStatus="settingIdx">
                <div class="row">
                    <input name="CommissionSettings3[${settingIdx.index}].id" value="${setting.id}"
                           class="hidden">
                    <input name="CommissionSettings3[${settingIdx.index}].fkey.value" value="${setting.fkey.value}"
                           class="hidden">
                    <div class="col-sm-8">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                        <input name="CommissionSettings3[${settingIdx.index}].avalue" value="${empty setting.avalue? '0':setting.avalue}"  class="text number required">
                    </div>
                    <div class="col-sm-2">
                        <input name="CommissionSettings3[${settingIdx.index}].bvalue" value="${empty setting.bvalue? '0':setting.bvalue}"  class="text number required">
                    </div>
                </div>
            </c:forEach>--%>


            <!--账期点数PCC设置-->
            <h4 class="text-custom">账期点数PCC设置</h4>
            <div class="row">
                <div class="col-sm-8">
                    账期PC
                </div>
                <div class="col-sm-2">
                    账期点数PCC
                </div>
            </div>
            <c:forEach items="${list4}" var="setting" varStatus="settingIdx">
                <div class="row">
                    <input name="CommissionSettings4[${settingIdx.index}].id" value="${setting.id}"
                           class="hidden">
                    <input name="CommissionSettings4[${settingIdx.index}].fkey.value" value="${setting.fkey.value}"
                           class="hidden">
                    <div class="col-sm-8">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                        <input name="CommissionSettings4[${settingIdx.index}].avalue" value="${empty setting.avalue? '0':setting.avalue}"  class="text number required">
                    </div>
                </div>
            </c:forEach>



            <div class="row m-t-20">
                <div class="col-sm-2 col-sm-offset-7">
                    <button id="btnEdit" type="submit" class="btn btn-primary waves-effect waves-light input-sm"
                            title="保存" data-content="保存">保存&nbsp;<i class="fa fa-save"></i></button>
                </div>
                <div class="col-sm-1">
                    <a id="btnReturn"
                       href="#" onclick="history.go(-1)"
                       class="btn btn-primary waves-effect waves-light input-sm" title="返回"
                       data-content="返回">返回&nbsp;<i
                            class="ti-back-left"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
</form:form>
</body>
</html>
