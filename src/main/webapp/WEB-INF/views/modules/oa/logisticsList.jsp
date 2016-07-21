<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>物流管理</title>
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
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/logistics/">物流列表</a></li>
		<shiro:hasPermission name="oa:logistics:edit"><li><a href="${ctx}/oa/logistics/form">物流添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="logistics" action="${ctx}/oa/logistics/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
		<ul class="ul-form">
			<li><label>名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>费用：</label>
				<form:input path="cost" htmlEscape="false" class="input-medium"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped m-0">
		<thead>
			<tr>
				<th class="sort-column name">名称</th>
				<th class="sort-column cost">费用</th>
				<th>更新时间</th>
				<shiro:hasPermission name="oa:logistics:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="logistics">
			<tr>
				<td><a href="${ctx}/oa/logistics/form?id=${logistics.id}">
					${logistics.name}
				</a></td>
				<td>
					${logistics.cost}
				</td>
				<td>
					<fmt:formatDate value="${logistics.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="oa:logistics:edit"><td>
    				<a href="${ctx}/oa/logistics/form?id=${logistics.id}">修改</a>
					<a href="${ctx}/oa/logistics/delete?id=${logistics.id}" onclick="return confirmx('确认要删除该物流吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>