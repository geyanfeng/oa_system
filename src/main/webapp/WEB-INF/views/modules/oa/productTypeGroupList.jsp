<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品类型组管理</title>
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
		<li class="active"><a href="${ctx}/oa/productTypeGroup/">商品类型组列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="productTypeGroup" action="${ctx}/oa/productTypeGroup/" method="post" class="breadcrumb form-search form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>提成：</label>
				<form:input path="royaltyRate" htmlEscape="false" class="input-medium"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li>  <a id="btnNew" href="${ctx}/oa/productTypeGroup/form"
					 class="btn btn-primary waves-effect waves-light" title="新增"
					 data-content="新增">新增<i
					class="fa fa-plus"></i></a></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>名称</th>
				<th>提成</th>
				<th>备注</th>
				<th>更新时间</th>
				<shiro:hasPermission name="oa:productTypeGroup:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="productTypeGroup">
			<tr>
				<td><a href="${ctx}/oa/productTypeGroup/form?id=${productTypeGroup.id}">
					${productTypeGroup.name}
				</a></td>
				<td>
					${productTypeGroup.royaltyRate}
				</td>
				<td>
					${productTypeGroup.remark}
				</td>
				<td>
					<fmt:formatDate value="${productTypeGroup.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="oa:productTypeGroup:edit"><td>
    				<a href="${ctx}/oa/productTypeGroup/form?id=${productTypeGroup.id}">修改</a>
					<a href="${ctx}/oa/productTypeGroup/delete?id=${productTypeGroup.id}" onclick="return confirmx('确认要删除该商品类型组吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>