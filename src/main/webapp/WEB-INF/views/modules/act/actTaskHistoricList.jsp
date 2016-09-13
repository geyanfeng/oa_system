<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>已办任务</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {

	});
	function page(n, s) {
		location = '${ctx}/act/task/historic/?pageNo=' + n + '&pageSize=' + s;
	}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/act/task/todo/">待办任务</a></li>
		<li class="active"><a href="${ctx}/act/task/historic/">已办任务</a></li>
		<li><a href="${ctx}/act/task/process/">新建任务</a></li>
	</ul>
	<div class="tab-content">
		<div class="tab-pane fade in active">
			<form:form id="searchForm" modelAttribute="act"
				action="${ctx}/act/task/historic/" method="get"
				class="breadcrumb form-search form-inline">
				<div>
					<div class="form-group m-r-10">
						<label>流程类型：&nbsp;</label>
						<form:select path="procDefKey" class="input-medium form-control">
							<form:option value="" label="全部流程" />
							<form:options items="${fns:getDictList('act_type')}"
								itemLabel="label" itemValue="value" htmlEscape="false" />
						</form:select>
					</div>
					<div class="form-group m-r-10">
						<label>日期：</label>
						<div class="input-group">
							<input name="beginCreateDate" type="text" readonly="readonly"
								maxlength="20" class="form-control" size="10"
								value="<fmt:formatDate value="${contract.beginCreateDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
							<span class="input-group-addon bg-custom b-0 text-white"><i
								class="ti-calendar"></i></span>
						</div>
						<div class="input-group">
							<input name="endCreateDate" type="text" readonly="readonly"
								maxlength="20" class="form-control" size="10"
								value="<fmt:formatDate value="${contract.endCreateDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
							<span class="input-group-addon bg-custom b-0 text-white"><i
								class="ti-calendar"></i></span>
						</div>
					</div>
					<div class="form-group m-r-10">
						<input id="btnSubmit" class="btn btn-custom" type="submit"
							value="查询" />
					</div>
				</div>

			</form:form>
			<sys:message content="${message}" />
			<table id="contentTable" class="table table-striped m-0">
				<thead>
					<tr>
						<th>标题</th>
						<th>当前环节</th>
						<%--
				<th>任务内容</th> --%>
						<th>流程名称</th>
						<th>流程版本</th>
						<th>完成时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${page.list}" var="act">
						<c:set var="task" value="${act.histTask}" />
						<c:set var="vars" value="${act.vars}" />
						<c:set var="procDef" value="${act.procDef}" />
						<%--
				<c:set var="procExecUrl" value="${act.procExecUrl}" /> --%>
						<c:set var="status" value="${act.status}" />
						<tr>
							<td><a
								href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 60)}</a>
							</td>
							<td><a target="_blank"
								href="${pageContext.request.contextPath}/act/rest/diagram-viewer?processDefinitionId=${task.processDefinitionId}&processInstanceId=${task.processInstanceId}">${task.name}</a>
								<%--
						<a target="_blank" href="${ctx}/act/task/trace/photo/${task.processDefinitionId}/${task.executionId}">${task.name}</a>
						<a target="_blank" href="${ctx}/act/task/trace/info/${task.processInstanceId}">${task.name}</a> --%>
							</td>
							<%--
					<td>${task.description}</td> --%>
							<td>${procDef.name}</td>
							<td><b title='流程版本号'>V: ${procDef.version}</b></td>
							<td><fmt:formatDate value="${task.endTime}" type="both" /></td>
							<td><a
								href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">详情</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			${page}
		</div>
	</div>
</body>
</html>
