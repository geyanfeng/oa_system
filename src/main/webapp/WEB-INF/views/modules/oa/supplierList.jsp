<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>供应商管理</title>
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
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/supplier/">供应商列表</a></li>
		<shiro:hasPermission name="oa:supplier:edit">
			<li><a href="${ctx}/oa/supplier/form">供应商添加</a></li>
		</shiro:hasPermission>
	</ul>
	<div class="tab-content">
		<div class="tab-pane fade in active">
			<form:form id="searchForm" modelAttribute="supplier"
				action="${ctx}/oa/supplier/" method="post"
				class="breadcrumb form-search form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<div class="form-group m-r-10">
					<label>名称：</label> <form:input path="name"
							htmlEscape="false" maxlength="100" class="input-medium form-control" /></div>
				<div class="form-group m-r-10">
					<label>备注：</label> <form:input path="remark"
							htmlEscape="false" maxlength="255" class="input-medium form-control" /></div>
				<div class="form-group m-r-10">
					<input id="btnSubmit" class="btn btn-custom"
						type="submit" value="查询" /></div>

			</form:form>
			<sys:message content="${message}" />
			<table id="contentTable"
				class="table table-striped m-0">
				<thead>
					<tr>
						<th>名称</th>
						<th>联系人</th>
						<th>联系电话</th>
						<th>发货速度</th>
						<th>沟通效率</th>
						<th>产品质量</th>
						<th>服务态度</th>
						<th>备注</th>
						<th>更新时间</th>
						<shiro:hasPermission name="oa:supplier:edit">
							<th>操作</th>
						</shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${page.list}" var="supplier">
						<tr>
							<td><a href="${ctx}/oa/supplier/form?id=${supplier.id}">
									${supplier.name} </a></td>
							<td>${supplier.contact}</td>
							<td>${supplier.phone}</td>
							<td><c:choose>
									<c:when test="${supplier.shippingSpeed eq 0}">
				     未评价
				  </c:when>
									<c:otherwise>
				   ${supplier.shippingSpeed}
                  </c:otherwise>
								</c:choose></td>
							<td><c:choose>
									<c:when test="${supplier.communicationEfficiency eq 0}">
				     未评价
				  </c:when>
									<c:otherwise>
				   ${supplier.communicationEfficiency}
                  </c:otherwise>
								</c:choose></td>
							<td><c:choose>
									<c:when test="${supplier.productQuality eq 0}">
				     未评价
				  </c:when>
									<c:otherwise>
				   ${supplier.productQuality}
                  </c:otherwise>
								</c:choose></td>
							<td><c:choose>
									<c:when test="${supplier.serviceAttitude eq 0}">
				     未评价
				  </c:when>
									<c:otherwise>
				   ${supplier.serviceAttitude}
                  </c:otherwise>
								</c:choose></td>
							<td>${supplier.remark}</td>
							<td><fmt:formatDate value="${supplier.updateDate}"
									pattern="yyyy-MM-dd HH:mm:ss" /></td>
							<shiro:hasPermission name="oa:supplier:edit">
								<td><a href="${ctx}/oa/supplier/form?id=${supplier.id}" class="m-r-5" title="修改"><i
											class="fa fa-pencil"></i></a>
									<a href="${ctx}/oa/supplier/delete?id=${supplier.id}"
									onclick="return confirmx('确认要删除该供应商吗？', this.href)"title="删除"><i
											class="fa fa-trash"></i></a></td>
							</shiro:hasPermission>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			${page}
		</div>
	</div>
</body>
</html>