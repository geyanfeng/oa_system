<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title></title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {

	});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
	<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">${title}</h2>
	<div class="panel panel-default">
		<div class="panel-body">
			<form:form id="searchForm" modelAttribute="map"
				action="${ctx}/report/" method="post"
				class="breadcrumb form-search form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
					callback="page();" />
				
				
			</form:form>
			<sys:message content="${message}" />
			<table id="contentTable" class="table table-striped m-0">
				<thead>
					<tr>
						<c:forEach items="${headers}" var="headers">
						<th>${headers.value}</th>
					   </c:forEach>					
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${list}" var="supplier">
						<tr>
							<c:forEach items="${headers}" var="headers">
						     <td>${supplier[headers.key]}</td>
					 	   </c:forEach>		
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
		</div>
	</div>
</body>
</html>