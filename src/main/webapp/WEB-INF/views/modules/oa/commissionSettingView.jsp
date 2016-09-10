<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>佣金参数 -- 查看</title>
<meta name="decorator" content="default" />
<style>
.row {
	margin-top: 10px;
	text-align: center;
}
</style>
</head>
<body>
	<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">佣金参数
		-- 查看</h2>
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
				<c:forEach items="${list1}" var="setting">
					<tr>
						<td>${setting.fkey.label}</td>
						<td>${empty setting.avalue? '0':setting.avalue}</td>
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
				<c:forEach items="${list4}" var="setting">
					<tr>
						<td>${setting.fkey.label}</td>
						<td>${empty setting.avalue? '0':setting.avalue}</td>
					</tr>
				</c:forEach>
				<tr>
					<td>账期PC > 90</td>
					<td>12+3*int[(PC-90)/15]</td>
				</tr>
			</table>
		</div>
	</div>


	<div class="row m-t-20 center">
		<a id="btnEdit" href="${ctx}/oa/commissionSetting/edit"
			class="btn btn-custom" title="编辑" data-content="新增">编辑</a>
	</div>
</body>
</html>
