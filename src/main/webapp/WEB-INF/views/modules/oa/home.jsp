<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同管理</title>
    <meta name="decorator" content="default"/>
</head>
<body>
<div class="card-box col-sm-6" id="card_other">
    <h4 class="header-title m-t-0 m-b-30">合同待办</h4>
    <table class="table m-0">
        <thead>
        <tr>
            <th width="5%">#</th>
            <th>项目名称</th>
            <th width="15%">类别</th>

        </tr>
        </thead>
        <tbody>
        <c:forEach items="${contract_audit_list}" var="contract_audit" varStatus="p">
            <c:set var="task" value="${contract_audit.task}"/>
            <c:set var="vars" value="${contract_audit.vars}"/>
            <c:set var="procDef" value="${contract_audit.procDef}"/>
            <c:set var="status" value="${contract_audit.status}"/>
            <tr>
                <th scope="row">${p.index + 1}</th>
                <td>
                    <c:if test="${empty task.assignee}">
                        <a href="javascript:claim('${task.id}');"
                           title="签收任务">${fns:abbr(not empty contract_audit.vars.map.title ? contract_audit.vars.map.title : task.id, 60)}</a>
                    </c:if>
                    <c:if test="${not empty task.assignee}">
                        <a href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 60)}</a>
                    </c:if>
                </td>
                <td><a class="btn btn-primary btn-sm" target="_blank"
                       href="${pageContext.request.contextPath}/act/rest/diagram-viewer?processDefinitionId=${task.processDefinitionId}&processInstanceId=${task.processInstanceId}">${task.name}</a>
                </td>
            </tr>
        </c:forEach>

        </tbody>
    </table>
</div>
</body>
</html>