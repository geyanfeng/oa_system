<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>客户评价参数 -- 编辑</title>
    <meta name="decorator" content="default"/>
    <style>
        .table th, .table td {
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
<form:form id="inputForm" modelAttribute="setting" action="${ctx}/oa/customerEvalSetting/save" method="post" role="form">
    <div class="panel panel-default">
        <div class="panel-heading">客户评价参数 -- 编辑</div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-4 col-sm-offset-2">
                    <c:forEach items="${list}" var="setting" varStatus="settingIdx">
                        <input name="CustomerEvalSettings[${settingIdx.index}].id" value="${setting.id}"
                               class="hidden">
                        <input name="CustomerEvalSettings[${settingIdx.index}].evalType.value" value="${setting.evalType.value}"
                               class="hidden">
                        <div class="row m-t-10">
                            <div class="col-sm-10">
                                    ${setting.evalType.label}
                            </div>
                            <div class="col-sm-2">
                                <input name="CustomerEvalSettings[${settingIdx.index}].value" value="${empty setting.value? '0':setting.value}"
                                       class="text number required">
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="row m-t-20">
                <div class="col-sm-1 col-sm-offset-5">
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
</form:form>
</body>
</html>
