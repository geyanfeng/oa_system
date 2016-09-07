<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户评价管理</title>
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
	<div class="panel-heading">客户评价列表
		
	</div>
	<div class="panel-body">
	<form:form id="searchForm" modelAttribute="oaCustomerEvaluate" action="${ctx}/oa/oaCustomerEvaluate/" method="post" class="breadcrumb form-search form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		  <div class="form-group">
                <label>客户：</label>
                <form:select path="customer.id"  class="input-small input-sm" id="customer" cssStyle="width: 150px">
                    <form:option value="" label="" />
                    <form:options items="${customerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false" />
                </form:select>
            </div>
		<button id="btnSubmit" class="btn btn-primary input-sm" type="submit" value="查询">
				查询<i class="fa fa-search"></i>
			</button>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>客户 </th>
				<th>客户评价类型</th>
				<th>合同</th>
				<th>应付款时间</th>
				<th>实付款时间</th>
				<th>客户评价</th>				
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="oaCustomerEvaluate">
			<tr>
				 <td>${oaCustomerEvaluate.customer.name}</td>
				 <td>${oaCustomerEvaluate.contract.name}</td>
				 <td>${oaCustomerEvaluate.customerEvalType}</td>
				 <td><fmt:formatDate value="${oaCustomerEvaluate.planPayDate}" pattern="yyyy-MM-dd"/></td>
				 <td><fmt:formatDate value="${oaCustomerEvaluate.payDate}" pattern="yyyy-MM-dd"/></td>
				 <td>${oaCustomerEvaluate.point}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	${page}
	</div>
	</div>
</body>
</html>