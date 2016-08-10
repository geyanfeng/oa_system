<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同管理</title>
    <meta name="decorator" content="default"/>
    <style>
        .form-group, label, input[type=text], .col-sm-5 {
            padding: 0px !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnExport").click(function () {
                top.$.jBox.confirm("确认要导出合同列表吗？", "系统提示", function (v, h, f) {
                    if (v == "ok") {
                        $("#searchForm").attr("action", "${ctx}/oa/contract/export");
                        $("#searchForm").submit();
                    }
                }, {buttonsFocus: 1});
                top.$('.jbox-body .jbox-icon').css('top', '55px');
            });
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function selectContract(sender) {
            var self = $(sender);
            var selectedContract = self.closest('tr').data('json');
            if (parent.closeSelectContractModal)
                parent.closeSelectContractModal(selectedContract);
        }
    </script>
</head>
<body>
<%--	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/contract/">合同列表</a></li>
		<shiro:hasPermission name="oa:contract:edit"><li><a href="${ctx}/oa/contract/form">合同添加</a></li></shiro:hasPermission>
	</ul>--%>
<div class="panel panel-default">
    <div class="panel-heading">
        <c:choose>
            <c:when test="${contract.contractType eq '1'}">框架合同</c:when>
            <c:when test="${contract.contractType eq '2'}">客户合同</c:when>
            <c:when test="${contract.contractType eq '3'}">补充合同</c:when>
        </c:choose>
        <div class="pull-right">
            <c:if test="${empty isSelect}">
                <shiro:hasPermission name="oa:contract:edit">
                    <a id="btnExport" class="btn btn-primary waves-effect waves-light input-sm" type="button"
                       title="导出">
                        导出&nbsp;<i
                            class="fa fa-download"></i></a>
                    </a>
                    <a id="btnNew"
                       href="${ctx}/oa/contract/form?contractType=${contract.contractType}"
                       class="btn btn-primary waves-effect waves-light input-sm" title="新增"
                       data-content="新增">新增&nbsp;<i
                            class="fa fa-plus"></i></a>
                </shiro:hasPermission>
            </c:if>

        </div>
    </div>

    <div class="panel-body">
        <form:form id="searchForm" modelAttribute="contract" action="${ctx}/oa/contract/" method="post"
                   class="breadcrumb form-search form-inline">
            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
            <!--过滤条件-->
            <div class="hidden">
                <input name="contractType" value="${contract.contractType}"/>
                <input name="isSelect" value="${isSelect}"/>
            </div>

            <div class="form-group">
                <label>日期：</label>

                <input name="beginCreateDate" type="text" readonly="readonly"
                       maxlength="20"
                       class="form-control Wdate input-sm"
                       value="<fmt:formatDate value="${contract.beginCreateDate}" pattern="yyyy-MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

                -

                <input name="endCreateDate" type="text" readonly="readonly"
                       maxlength="20"
                       class="form-control Wdate input-sm"
                       value="<fmt:formatDate value="${contract.endCreateDate}" pattern="yyyy-MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

            </div>

            <div class="form-group">
                <label>客户：</label>

                <sys:treeselect id="customer" name="customer.id" value="${contract.customer.id}"
                                labelName="customer.name" labelValue="${contract.customer.name}"
                                title="客户" url="/oa/customer/treeData" cssClass="input-small input-sm"
                                allowClear="true" notAllowSelectParent="true" buttonIconCss="input-sm"/>

            </div>

            <div class="form-group">
                <label>销售：</label>

                <sys:treeselect id="createBy" name="createBy.id" value="${contract.createBy.id}"
                                labelName="createBy.name" labelValue="${contract.createBy.name}"
                                title="用户" url="/sys/office/treeData?type=3"
                                cssClass="input-small input-sm"
                                allowClear="true" notAllowSelectParent="true" buttonIconCss="input-sm"/>

            </div>


            <button id="btnSubmit" class="btn btn-primary input-sm" type="submit" value="查询">
                查询<i class="fa fa-search"></i>
            </button>


        </form:form>
        <sys:message content="${message}"/>
        <table id="contentTable" class="table table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th class="sort-column createDate">日期</th>
                <th class="sort-column no">合同号</th>
                <th class="sort-column name">合同名称</th>
                <th class="sort-column companyName">公司抬头</th>
                <th class="sort-column a9.name">客户</th>
                <th class="sort-column u32.name">有效期</th>
                <%-- <th>更新时间</th>--%>
                <shiro:hasPermission name="oa:contract:edit">
                    <th>操作</th>
                </shiro:hasPermission>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="contract">
                <tr data-json='${fns:toJson(contract)}'>
                    <td>
                        <fmt:formatDate value="${contract.createDate}" pattern="yyyy-MM-dd"/>
                    </td>

                    <td><a href="${ctx}/oa/contract/form?id=${contract.id}">
                            ${contract.no}
                    </a></td>
                    <td>
                            ${contract.name}
                    </td>
                    <td>
                            ${fns:getDictLabel(contract.companyName, 'oa_company_name', '')}
                    </td>
                    <td>
                            ${contract.customer.name}
                    </td>

                    <td>
                        <fmt:formatDate value="${contract.expiryDate}" pattern="yyyy-MM-dd"/>
                    </td>
                                         <%--<td>
                            <fmt:formatDate value="${contract.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>--%>
                    <shiro:hasPermission name="oa:contract:edit">
                        <td>
                            <c:if test="${empty isSelect}">
                                <a href="${ctx}/oa/contract/form?id=${contract.id}">修改</a>
                                <a href="${ctx}/oa/contract/delete?id=${contract.id}"
                                   onclick="return confirmx('确认要删除该合同吗？', this.href)">删除</a>
                                <a href="${ctx}/oa/contract/form?originalId=${contract.id}">生成</a>
                            </c:if>
                            <c:if test="${not empty isSelect}">
                                <a href="#" onclick="selectContract(this);">选择</a>
                            </c:if>
                        </td>
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