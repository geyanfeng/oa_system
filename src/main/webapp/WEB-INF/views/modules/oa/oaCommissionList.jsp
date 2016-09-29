<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同提成计算</title>
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
<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">合同提成计算列表</h2>
	<div class="panel panel-default">
	<div class="panel-body">
	<form:form id="searchForm" modelAttribute="oaCommission" action="${ctx}/oa/oaCommission/" method="post" class="breadcrumb form-search form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<div class="form-group m-r-10">
					<label>销售：</label>
					<form:select path="saler.id" class="input-small form-control" id="saler"
								 cssStyle="width: 150px">
						<form:option value="" label="" />
						<form:options items="${salerList}" itemLabel="name"
									  itemValue="id" htmlEscape="false" />
					</form:select>

				</div>
		
            <div class="form-group">
			<button id="btnSubmit" class="btn btn-custom" type="submit" value="查询">
				查&nbsp;&nbsp;询
			</button>
			</div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-condensed table-hover">
		<thead>
			<tr>
				<th>年</th>
			    <th>季度</th>
			    <th>销售</th>
				<th>合同编号</th>
				<th align="center">项目名称</th>
				<th>款项</th>
				<th>本期毛利</th>
				<th>税收成本</th>
				<th>物流费用</th>
				<th>账期成本</th>
				<th>本期净利</th>
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
			    <td><a href="${ctx}/oa/contract/view?id=${oaCommission.contract.id}">${oaCommission.contract.no}</a></td>
			    <td align="center"><a href="${ctx}/oa/contract/view?id=${oaCommission.contract.id}">${oaCommission.contract.name}</a></td>
			    <td>
			     <c:choose>
                  <c:when test="${oaCommission.paymentSchedule eq '0'}">全款</c:when>
                  <c:when test="${oaCommission.paymentSchedule eq '-1'}">尾款</c:when>
                  <c:when test="${oaCommission.paymentSchedule eq '1'}">首款</c:when>
                  <c:otherwise>第${oaCommission.paymentSchedule}笔款</c:otherwise>
                 </c:choose>
			    </td>
			    <td>${oaCommission.KGp}</td>			  
				<td>${oaCommission.KTrV}</td>
				<td>${oaCommission.KLc}</td>
				<td>${oaCommission.KPccV}</td>
				<td>${oaCommission.KNp}</td>
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