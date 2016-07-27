<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
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
		<li class="active"><a href="${ctx}/oa/contract/">合同列表</a></li>
		<shiro:hasPermission name="oa:contract:edit"><li><a href="${ctx}/oa/contract/form">合同添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="contract" action="${ctx}/oa/contract/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>客户：</label>
				<sys:treeselect id="customer" name="customer.id" value="${contract.customer.id}" labelName="customer.name" labelValue="${contract.customer.name}"
					title="客户" url="/oa/customer/treeData" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>合同状态：</label>
				<form:select path="status" class="input-medium">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('oa_contract_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>销售：</label>
				<sys:treeselect id="createBy" name="createBy.id" value="${contract.createBy.id}" labelName="createBy.name" labelValue="${contract.createBy.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>日期：</label>
				<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${contract.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
				<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${contract.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>合同号</th>
				<th>合同名称</th>
				<th>合同金额</th>
				<th>公司抬头</th>
				<th>客户</th>
				<th>合同状态</th>
				<th>商务人员</th>
				<th>技术人员</th>
				<th>销售</th>
				<th>日期</th>
				<th>更新时间</th>
				<shiro:hasPermission name="oa:contract:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="contract">
			<tr>
				<td><a href="${ctx}/oa/contract/form?id=${contract.id}">
					${contract.no}
				</a></td>
				<td>
					${contract.name}
				</td>
				<td>
					${contract.amount}
				</td>
				<td>
					${fns:getDictLabel(contract.companyName, 'oa_company_name', '')}
				</td>
				<td>
					${contract.customer.name}
				</td>
				<td>
					${fns:getDictLabel(contract.status, 'oa_contract_status', '')}
				</td>
				<td>
					${contract.business_person.name}
				</td>
				<td>
					${contract.artisan.name}
				</td>
				<td>
					${contract.createBy.name}
				</td>
				<td>
					<fmt:formatDate value="${contract.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<fmt:formatDate value="${contract.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="oa:contract:edit"><td>
    				<a href="${ctx}/oa/contract/form?id=${contract.id}">修改</a>
					<a href="${ctx}/oa/contract/delete?id=${contract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>