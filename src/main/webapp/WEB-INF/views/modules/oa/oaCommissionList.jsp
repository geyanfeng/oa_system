<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同提成计算</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<div class="panel panel-default">
	<div class="panel-heading">合同提成计算列表
		
	</div>
	<div class="panel-body">
	<form:form id="searchForm" modelAttribute="oaCommission" action="${ctx}/oa/oaCommission/" method="post" class="breadcrumb form-search form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		
			<button id="btnSubmit" class="btn btn-primary input-sm" type="submit" value="查询">
				查询<i class="fa fa-search"></i>
			</button>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-condensed table-hover">
		<thead>
			<tr>
				<th>年</th>
			    <th>季度</th>
			    <th>销售员</th>
				<th>收款流水 </th>
				<th>合同ID</th>
				<th>项目名称</th>
				<th>款项进度</th>
				<th>本期毛利</th>
				<th>本期净利</th>
				<th>税收成本</th>
				<th>账期成本</th>
				<th>净值</th>
				<th>业绩提成</th>
				<th>额外佣金</th>
				<th>合计</th>
				
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="oaCommission">
			<tr>
			    <td>${oaCommission.year}</td>
			    <td>${oaCommission.quarter}</td>
			    <td>${oaCommission.saler.name}</td>
			    <td>${oaCommission.contract.no}-S${oaCommission.contractFinance.sort}</td>
			    <td>${oaCommission.contract.no}</td>
			    <td>${oaCommission.contract.name}</td>
			    <td></td>
			    <td>${oaCommission.KGp}</td>
			    <td>${oaCommission.KNp}</td>
				<td>${oaCommission.KTrV}</td>
				<td>${oaCommission.KPccV}</td>
				<td>${oaCommission.KJzV}</td>
				<td>${oaCommission.KYjV}</td>
				<td>${oaCommission.KEwV}</td>
				<td>${oaCommission.KSc}</td>
				
			</tr>
		</c:forEach>
		</tbody>
	</table>
	${page}
	</div>
	</div>
</body>
</html>