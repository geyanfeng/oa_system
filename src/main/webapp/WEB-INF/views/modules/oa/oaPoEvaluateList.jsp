<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商评价管理</title>
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
		<li class="active"><a href="${ctx}/oa/oaPoEvaluate/">供应商评价列表</a></li>
		
	</ul>
	<form:form id="searchForm" modelAttribute="oaPoEvaluate" action="${ctx}/oa/oaPoEvaluate/" method="post" class="breadcrumb form-search form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div class="form-group">
				<label>供应商：</label>

				<form:select path="supplier.id" class="select2-container form-control input-sm" id="supplier" cssStyle="width:200px;">
					<form:option value="" label=""/>
					<form:options items="${supplierList}" itemLabel="name"
								  itemValue="id" htmlEscape="false"/>
				</form:select>

			</div>
			<button id="btnSubmit" class="btn btn-primary input-sm" type="submit" value="查询">
				查询<i class="fa fa-search"></i>
			</button>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-condensed table-hover">
		<thead>
			<tr>
				<th>订单号 </th>
				<th>供应商</th>
				<th>发货速度</th>
				<th>沟通效率</th>
				<th>产品质量</th>
				<th>服务态度</th>
				<th>备注</th>
				<th>评价人</th>
				<th>评价时间</th>
				
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="oaPoEvaluate">
			<tr>
			    <td>${oaPoEvaluate.purchaseOrder.no}</td>
			    <td>${oaPoEvaluate.supplier.name}</td>
			    <td>${oaPoEvaluate.shippingSpeed}</td>
			    <td>${oaPoEvaluate.communicationEfficiency}</td>
			    <td>${oaPoEvaluate.productQuality}</td>
			    <td>${oaPoEvaluate.serviceAttitude}</td>
			    <td>${oaPoEvaluate.remark}</td>
			    <td>${oaPoEvaluate.updateBy.name}</td>
				<td><fmt:formatDate value="${oaPoEvaluate.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				
			</tr>
		</c:forEach>
		</tbody>
	</table>
	${page}
</body>
</html>