<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {

        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function selectContract(sender){
            var self = $(sender);
            var selectedContract = self.closest('tr').data('json');
            if(parent.closeSelectContractModal)
                parent.closeSelectContractModal(selectedContract);
        }
    </script>
</head>
<body>
<%--	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/contract/">合同列表</a></li>
		<shiro:hasPermission name="oa:contract:edit"><li><a href="${ctx}/oa/contract/form">合同添加</a></li></shiro:hasPermission>
	</ul>--%>
<div class="contrainer">
<form:form id="searchForm" modelAttribute="contract" action="${ctx}/oa/contract/" method="post"
           class="breadcrumb form-search">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <!--过滤条件-->
    <div class="hidden">
        <input name="contractType" value="${contract.contractType}"/>
        <input name="isSelect" value="${isSelect}"/>
    </div>


    <div class="col-sm-12">
        <div class="card-box">
            <div class="row">
                <div class="col-sm-5">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">日期：</label>
                        <div class="col-sm-7">
                            <div class="row">
                                <div class="col-sm-5">
                                    <input name="beginCreateDate" type="text" readonly="readonly" maxlength="20"
                                           class="form-control Wdate "
                                           value="<fmt:formatDate value="${contract.beginCreateDate}" pattern="yyyy-MM-dd"/>"
                                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                                </div>
                                <div class="col-sm-1">-</div>
                                <div class="col-sm-5">
                                    <input name="endCreateDate" type="text" readonly="readonly" maxlength="20"
                                           class="form-control Wdate "
                                           value="<fmt:formatDate value="${contract.endCreateDate}" pattern="yyyy-MM-dd"/>"
                                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-3 control-label">客户：</label>
                        <div class="col-sm-7">
                            <sys:treeselect id="customer" name="customer.id" value="${contract.customer.id}"
                                            labelName="customer.name" labelValue="${contract.customer.name}"
                                            title="客户" url="/oa/customer/treeData" cssClass="input-small"
                                            allowClear="true" notAllowSelectParent="true"/>
                        </div>
                    </div>

                </div>
                <div class="col-sm-5">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">合同状态：</label>
                        <div class="col-sm-7">
                            <form:select path="status" class="select2-container form-control col-md-12">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('oa_contract_status')}" itemLabel="label"
                                              itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                    </div>

                    <div class="form-group ">
                        <label class="col-sm-3 control-label">销售：</label>
                        <div class="col-sm-7">
                            <sys:treeselect id="createBy" name="createBy.id" value="${contract.createBy.id}"
                                            labelName="createBy.name" labelValue="${contract.createBy.name}"
                                            title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                            allowClear="true" notAllowSelectParent="true"/>
                        </div>
                    </div>

                </div>
                <div class="col-sm-2">
                    <div class="row">
                        <div class="col-sm-10">
                            <button id="btnSubmit" class="btn btn-primary" type="submit" value="查询">
                                查询<i class="fa fa-search"></i>
                            </button>
                        </div>
                    </div>

                    <c:if test="${empty isSelect}">
                        <shiro:hasPermission name="oa:contract:edit">
                            <div class="row m-t-10">
                                <div class="col-sm-10">
                                    <a id="btnNew" href="${ctx}/oa/contract/form?contractType=${contract.contractType}"
                                       class="btn btn-primary waves-effect waves-light" title="新增"
                                       data-content="新增">新增<i
                                            class="fa fa-plus"></i></a>
                                </div>
                            </div>
                        </shiro:hasPermission>
                    </c:if>
                </div>
            </div>
        </div>

    </div>

</form:form>
<sys:message content="${message}"/>
<table id="contentTable" class="table table-striped">
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
        <shiro:hasPermission name="oa:contract:edit">
            <th>操作</th>
        </shiro:hasPermission>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.list}" var="contract">
        <tr data-json='${fns:toJson(contract)}'>
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
                    ${contract.businessPerson.name}
            </td>
            <td>
                    ${contract.artisan.name}
            </td>
            <td>
                    ${contract.createBy.name}
            </td>
            <td>
                <fmt:formatDate value="${contract.createDate}" pattern="yyyy-MM-dd"/>
            </td>
            <td>
                <fmt:formatDate value="${contract.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </td>
            <shiro:hasPermission name="oa:contract:edit">
                <td>
                    <c:if test="${empty isSelect}">
                        <a href="${ctx}/oa/contract/form?id=${contract.id}">修改</a>
                        <a href="${ctx}/oa/contract/delete?id=${contract.id}"
                           onclick="return confirmx('确认要删除该合同吗？', this.href)">删除</a>
                    </c:if>
                    <c:if test="${not empty isSelect}">
                        <a href="#" onclick="selectContract(this);">选择</a>
                    </c:if>
                    <c:if test="${contract.contractType eq '1'}">
                        <a href="${ctx}/oa/contract/form?originalId=${contract.id}">生成</a>
                    </c:if>
                </td>
            </shiro:hasPermission>
        </tr>
    </c:forEach>
    </tbody>
</table>
${page}
</div>
</body>
</html>