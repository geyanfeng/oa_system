<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>佣金参数 -- 编辑</title>
<meta name="decorator" content="default" />
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
            //loading('正在提交，请稍等...');
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
	<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">佣金参数
		-- 编辑</h2>
	<form:form id="inputForm" modelAttribute="setting"
		action="${ctx}/oa/commissionSetting/save" method="post" role="form">
		<sys:message content="${message}" />
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">提成系数SCC设置</h3>
			</div>
			<div class="panel-body" style="padding: 0;">
				<table class="table table-striped table-condensed">
					<tr>
						<th width="50%">完成毛利GP情况</th>
						<th>参数(SC/SCC)</th>
					</tr>
					<c:forEach items="${list1}" var="setting" varStatus="settingIdx">
						<tr>
							<td><input
								name="CommissionSettings1[${settingIdx.index}].id"
								value="${setting.id}" class="hidden"> <input
								name="CommissionSettings1[${settingIdx.index}].fkey.value"
								value="${setting.fkey.value}" class="hidden">${setting.fkey.label}</td>
							<td><input
								name="CommissionSettings1[${settingIdx.index}].avalue"
								value="${empty setting.avalue? '0':setting.avalue}"
								class="text number required"></td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">账期点数PCC设置</h3>
			</div>
			<div class="panel-body" style="padding: 0;">
				<table class="table table-striped table-condensed">
					<tr>
						<th width="50%">账期PC</th>
						<th>账期点数PCC</th>
					</tr>
					<c:forEach items="${list4}" var="setting" varStatus="settingIdx">
						<tr>
							<td><input
								name="CommissionSettings4[${settingIdx.index}].id"
								value="${setting.id}" class="hidden"> <input
								name="CommissionSettings4[${settingIdx.index}].fkey.value"
								value="${setting.fkey.value}" class="hidden">
								${setting.fkey.label}</td>
							<td><input
								name="CommissionSettings4[${settingIdx.index}].avalue"
								value="${empty setting.avalue? '0':setting.avalue}"
								class="text number required"></td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">资金成本参数</h3>
			</div>
			<div class="panel-body" style="padding: 0;">
				<table class="table table-striped table-condensed">
					
					<c:forEach items="${list2}" var="setting" varStatus="settingIdx">
						<tr>
							<td  width="50%"><input
								name="CommissionSettings2[${settingIdx.index}].id"
								value="${setting.id}" class="hidden"> <input
								name="CommissionSettings2[${settingIdx.index}].fkey.value"
								value="${setting.fkey.value}" class="hidden">
								${setting.fkey.label}</td>
							<td><input
								name="CommissionSettings2[${settingIdx.index}].avalue"
								value="${empty setting.avalue? '0':setting.avalue}"
								class="text number required"></td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<div class="row m-t-20 text-center">

			<button id="btnEdit" type="submit"
				class="btn btn-custom" title="保存"
				data-content="保存">
				保存
			</button>


			<a id="btnReturn" href="#" onclick="history.go(-1)"
				class="btn btn-inverse" title="返回"
				data-content="返回">返回</a>

		</div>
	</form:form>
</body>
</html>