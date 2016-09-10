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
<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">客户评价参数 -- 编辑</h2>
<form:form id="inputForm" modelAttribute="setting" action="${ctx}/oa/customerEvalSetting/save" method="post" role="form">
  
    <div class="panel panel-default">
        <div class="panel-body" style="padding:0;">
        <table class="table table-striped table-condensed m-b-0">
					<c:forEach items="${list}" var="setting" varStatus="settingIdx">
						<tr>
							<td><input name="CustomerEvalSettings[${settingIdx.index}].id" value="${setting.id}"
                               class="hidden">
                        <input name="CustomerEvalSettings[${settingIdx.index}].evalType.value" value="${setting.evalType.value}"
                               class="hidden">
                                    ${setting.evalType.label}</td>
							<td><input name="CustomerEvalSettings[${settingIdx.index}].value" value="${empty setting.value? '0':setting.value}"
                                       class="text number required"></td>
						</tr>
					</c:forEach>
				</table>      
        </div>
    </div>
    <div class="row m-t-20 text-center">
                    <button id="btnEdit" type="submit" class="btn btn-custom"
                            title="保存" data-content="保存">保存</button>
                    <a id="btnReturn"
                       href="#" onclick="history.go(-1)"
                       class="btn btn-inverse" title="返回"
                       data-content="返回">返回</a>

            </div>
</form:form>
</body>
</html>
