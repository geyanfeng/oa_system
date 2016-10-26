<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品类型管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("select").select2({ allowClear: true});
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
		<li class="active"><a href="${ctx}/oa/productType/">商品类型列表</a></li>
	</ul>
	<div class="tab-content">
	<form:form id="searchForm" modelAttribute="productType" action="${ctx}/oa/productType/" method="post" class="breadcrumb form-search form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div class="form-group m-r-10">
			<label>商品类型组：</label>
			<form:select path="typeGroup.id" class="input-medium form-control" style="width:100px;">
					<form:option value="" label=""/>
					<form:options items="${productTypeGroup_list}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				</form:select>
		</div>
		<div class="form-group m-r-10">
			<label>名称：</label>
			<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium form-control"/>
		</div>
		<div class="form-group m-r-10">
			<input id="btnSubmit" class="btn btn-custom" type="submit" value="查询"/>
		</div>
		<div class="form-group m-r-10">
			<a id="btnNew" href="${ctx}/oa/productType/form"
					 class="btn btn-custom" title="新增"
					 data-content="新增">新增</a>
		</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped m-0">
		<thead>
			<tr>
				<th>商品类型组</th>
				<th>名称</th>
				<th>备注</th>
				<th>更新时间</th>
				<shiro:hasPermission name="oa:productType:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="productType">
			<tr>
				<td>
					${productType.typeGroup.name}
				</td>
				<td>
					${productType.name}
				</td>
				<td>
					${productType.remark}
				</td>
				<td>
					<fmt:formatDate value="${productType.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="oa:productType:edit"><td>
    				<a href="${ctx}/oa/productType/form?id=${productType.id}" title="修改"><i
								class="fa fa-pencil"></i></a>
					<a href="${ctx}/oa/productType/delete?id=${productType.id}" onclick="return confirmx('确认要删除该商品类型吗？', this.href)" title="删除"><i
								class="fa fa-trash"></i></a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	${page}
	</div>
</body>
</html>