<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>选择合同</title>
    <meta name="decorator" content="default" />
    <style>
        .modal.fade.in {
            top: 10%
        }
        .form-inline .form-group {margin-bottom:15px;}
    </style>
    <script type="text/javascript">
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function selectContract(sender) {
            var self = $(sender);
            var selectedContract = self.closest('tr').data('json');
            var frameWin =  top.frames["mainFrame"];
            if (frameWin.closeSelectContractModal)
                frameWin.closeSelectContractModal(selectedContract);
        }

        $(function(){
            $("select").select2({ allowClear: true});
        });
    </script>
</head>
<body>
<div class="panel panel-default">
    <div class="panel-body">
        <form:form id="searchForm" modelAttribute="contract"
                   action="${ctx}/oa/contract/contractSelectList" method="post"
                   class="breadcrumb form-search form-inline">
            <input id="pageNo" name="pageNo" type="hidden"
                   value="${page.pageNo}" />
            <input id="pageSize" name="pageSize" type="hidden"
                   value="${page.pageSize}" />
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
                           callback="page();" />
            <!--过滤条件-->
            <div class="hidden">
                <input name="targetType" value="${targetType}" />
            </div>

            <div class="form-group m-r-10">
                <label>合同名称：</label>
                <form:input path="searchName" class="form-control input-small"></form:input>
            </div>

            <div class="form-group m-r-10">
                <label>客户：</label>
                <form:select path="customer.id" class="input-small form-control" id="customer"
                             cssStyle="width: 150px">
                    <form:option value="" label="" />
                    <form:options items="${customerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false" />
                </form:select>
            </div>

            <div class="form-group m-r-10">
                <label>销售：</label>
                <form:select path="createBy.id" class="input-small form-control" id="createBy"
                             cssStyle="width: 150px">
                    <form:option value="" label="" />
                    <form:options items="${salerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false" />
                </form:select>

            </div>
            <div class="form-group m-r-10">
                <label>我司抬头：</label>
                <form:select path="companyName"
                             class="input-small form-control">
                    <form:option value="" label="" />
                    <form:options items="${fns:getDictList('oa_company_name')}"
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
                <button id="btnSubmit" class="btn btn-custom" type="submit"
                        value="查询">筛&nbsp;&nbsp;选</button>

            </div>


        </form:form>
        <sys:message content="${message}" />
        <table id="contentTable"
               class="table table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th class="sort-column createDate">日期</th>
                <th class="sort-column contractType">类型</th>
                <th class="sort-column no">合同号</th>
                <th class="sort-column a9.name">客户</th>
                <th class="sort-column name">合同名称</th>
                <th class="sort-column amount">合同金额</th>
                <th class="sort-column status">合同状态</th>
                <th class="sort-column u32.name">销售</th>
                <th class="sort-column u15.name">商务人员</th>
                <th class="sort-column u16.name">技术人员</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="contract">
                <tr data-json='${fns:toJson(contract)}'>
                    <td><fmt:formatDate value="${contract.createDate}"
                                        pattern="yyyy-MM-dd" /></td>
                    <td>${fns:getDictLabel(contract.contractType,"oa_contract_type" ,"" )}</td>
                    <td><a href="${ctx}/oa/contract/view?id=${contract.id}">
                            ${contract.no} </a></td>
                    </td>
                    <td>${contract.customer.name}</td>
                    <td>${contract.name}</td>
                    <td><fmt:formatNumber type="number"
                                          value="${contract.amount}" maxFractionDigits="2" /></td>
                    <td><c:if test="${contract.cancelFlag eq 1}"><del class="text-danger"></c:if>${fns:getDictLabel(contract.status, 'oa_contract_status', '')}<c:if test="${contract.cancelFlag eq 1}"></del></c:if>
                    </td>
                    <td>${contract.createBy.name}</td>

                    <td>${contract.businessPerson.name}</td>
                    <td>${contract.artisan.name}</td>
                    <td>
                            <a href="#" onclick="selectContract(this);" title="选择"><i
                                    class="fa fa-check"></i></a>
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