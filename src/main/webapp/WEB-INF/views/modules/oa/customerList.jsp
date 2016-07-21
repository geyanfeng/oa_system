<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
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
		<li class="active"><a href="${ctx}/oa/customer/">客户列表</a></li>
		<shiro:hasPermission name="oa:customer:edit"><li><a href="${ctx}/oa/customer/form">客户添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="customer" action="${ctx}/oa/customer/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
		<ul class="ul-form">
			<li><label>名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium form-control"/>
			</li>
			<li><label>地址：</label>
				<form:input path="address" htmlEscape="false" maxlength="255" class="input-medium form-control"/>
			</li>
			<li><label>联系人：</label>
				<form:input path="contact" htmlEscape="false" maxlength="100" class="input-medium form-control"/>
			</li>
			<li><label>电话：</label>
				<form:input path="phone" htmlEscape="false" maxlength="100" class="input-medium form-control"/>
			</li>
			<li><label>备注：</label>
				<form:input path="remark" htmlEscape="false" maxlength="255" class="input-medium form-control"/>
			</li>
			<li><label>状态：</label>
				<form:radiobuttons path="usedFlag" items="${fns:getDictList('status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
				<th>地址</th>
				<th>联系人</th>
				<th>电话</th>
				<th>备注</th>
				<th class="sort-column usedFlag">状态</th>
				<th>更新时间</th>
				<shiro:hasPermission name="oa:customer:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="customer">
			<tr>
				<td><a href="${ctx}/oa/customer/form?id=${customer.id}">
					${customer.name}
				</a></td>
				<td>
					${customer.address}
				</td>
				<td>
					${customer.contact}
				</td>
				<td>
					${customer.phone}
				</td>
				<td>
					${customer.remark}
				</td>
				<td>
					${fns:getDictLabel(customer.usedFlag, 'status', '')}
				</td>
				<td>
					<fmt:formatDate value="${customer.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="oa:customer:edit"><td>
    				<a href="${ctx}/oa/customer/form?id=${customer.id}">修改</a>
					<%--<a href="${ctx}/oa/customer/delete?id=${customer.id}" onclick="return confirmx('确认要删除该客户吗？', this.href)">删除</a>--%>
					<a href="${ctx}/oa/customer/changeUsedFlag?id=${customer.id}" onclick="return confirmx('确认要修改该客户的状态吗？', this.href)">更改状态</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	${page}
</body>
</html>