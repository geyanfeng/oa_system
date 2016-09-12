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
			<form:form id="searchForm" modelAttribute="searchParams"
				action="${ctx}/report/" method="post"
				class="breadcrumb form-search form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
					callback="page();" />
				
				<div class="form-group m-r-10">
					<label>日期：</label>
					<div class="input-group">
						<input name="startTime" type="text" readonly="readonly"
							maxlength="20" class="form-control" size="10"
							value="<fmt:formatDate value="${searchParams.startTime}" pattern="yyyy-MM-dd"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
					</div>
					<div class="input-group">
						<input name="endTime" type="text" readonly="readonly"
							maxlength="20" class="form-control" size="10"
							value="<fmt:formatDate value="${searchParams.endTime}" pattern="yyyy-MM-dd"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
					</div>
				</div>
				<div class="form-group m-r-10">
				<label>供应商：</label>

				<form:select path="supplierId" class="select2-container form-control" id="supplierId" cssStyle="width:200px;">
					<form:option value="" label=""/>
					<form:options items="${supplierList}" itemLabel="name"
								  itemValue="id" htmlEscape="false"/>
				</form:select>

			</div>
				<div class="form-group m-r-10">
				<button id="btnSubmit" class="btn btn-custom" type="submit"
					value="查询">查&nbsp;&nbsp;询</button>

				</div>
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
					<c:forEach items="${page.list}" var="supplier">
						<tr>
							<c:forEach items="${headers}" var="headers">
						     <td>${supplier[headers.key]}</td>
					 	   </c:forEach>		
						</tr>
					</c:forEach>
				</tbody>
			</table>
			${page}
		</div>
	</div>
</body>
</html>