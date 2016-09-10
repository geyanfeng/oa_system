<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>客户评价参数 -- 查看</title>
<meta name="decorator" content="default" />
<style>
.table th, .table td {
	text-align: center;
}
</style>
</head>
<body>
	<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">客户评价参数
		-- 查看</h2>
	<div class="panel panel-default">
		<div class="panel-body" style="padding: 0;">
			<table class="table table-striped table-condensed m-b-0">
				<c:forEach items="${list}" var="setting">
					<tr>
						<td width="50%">${setting.evalType.label}</td>
						<td>${empty setting.value? '0':setting.value}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	<div class="row m-t-20 text-center">
		<a id="btnEdit" href="${ctx}/oa/customerEvalSetting/edit"
			class="btn btn-custom" title="编辑" data-content="新增">编辑</a>
	</div>

</body>
</html>
