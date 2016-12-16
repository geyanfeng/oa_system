<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同提成计算</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            $("select").select2({allowClear: true});
            changeSaler();
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function changeSaler(){
           var saler = $("#saler").find("option:selected").text();
            if(saler === ""){
                $("#span-saler").html("不限");
            } else{
                $("#span-saler").html(saler);
            }
        }
    </script>
    <style type="text/css">
        .form-group {
            margin-top: 10px;
        }
        #zy-table td{
            text-align: left;
        }
    </style>
</head>
<body>
<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">合同提成计算列表</h2>
<div class="panel panel-default">
    <div class="panel-body">
        <form:form id="searchForm" modelAttribute="oaCommission" action="${ctx}/oa/oaCommission/" method="post"
                   class="breadcrumb form-search form-inline">
            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
                           callback="page();" />
            <input id="flag" name="flag" type="hidden"/>
            <div class="form-group m-r-10">
                <label>销售：</label>
                <form:select path="saler.id" class="input-small form-control" id="saler"
                             cssStyle="width: 150px" onchange="changeSaler();">
                    <form:option value="" label=""/>
                    <form:options items="${salerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false"/>
                </form:select>
            </div>

            <div class="form-group m-r-10">
                <label>季度：</label>
                <form:select path="yearQuarter" class="input-small form-control" id="yearQuarter">
                    <c:forEach items="${yearQuarters}" var="item">
                        <option value="${item}" <c:if test="${item eq oaCommission.yearQuarter}">selected</c:if>>${item}</option>
                    </c:forEach>
                </form:select>
            </div>

            <div class="form-group m-r-10">
                <label>状态：</label>
                <form:select path="status" class="input-small form-control" id="status">
                    <option value="0" <c:if test="${oaCommission.status eq 0}">selected</c:if>>未确认</option>
                    <option value="1" <c:if test="${oaCommission.status eq 1}">selected</c:if>>确认</option>
                </form:select>
            </div>

            <div class="form-group">
                <button id="btnSubmit" class="btn btn-custom" type="submit" value="查询">
                    查&nbsp;&nbsp;询
                </button>
                <button id="btnReCalc" class="btn btn-custom" type="submit" value="重新计算" onclick="$('#flag').val('reCalc');">
                    重新计算
                </button>
                <button id="btnConfirm" class="btn btn-custom" type="submit" value="确认" onclick="$('#flag').val('confirm');">
                    确&nbsp;&nbsp;认
                </button>
            </div>
        </form:form>
        <sys:message content="${message}"/>
        <div class="panel panel-default m-r-15">
            <div class="panel-heading" style="padding-left: 5px;">摘要信息
            </div>
            <div class="panel-body" style="padding: 0;">
                <table id="zy-table" class="table table-condensed m-0">
                    <tbody>
                    <tr>
                        <td>销售：<span id="span-saler">不限</span></td>
                        <td>本季度指标：<fmt:formatNumber type="number" value="${summary.sum_gpi}" maxFractionDigits="2" /></td>
                        <td>已完成业绩：<fmt:formatNumber type="number" value="${summary.sum_k_sv}" maxFractionDigits="2" /></td>
                        <td>完成率：
                            <c:if test="${summary.sum_gpi ne '0.00' && summary.sum_k_sv ne '0.00'}">
                                <span style="color:red;" id="span-otherML"><fmt:formatNumber type="number" value="${(summary.sum_k_sv / summary.sum_gpi) * 100}" maxFractionDigits="2" /> %</span>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td>提成系数：<fmt:formatNumber type="number" value="${summary.avg_k_scc}" maxFractionDigits="2" /></td>
                        <td>提成总金额：<fmt:formatNumber type="number" value="${summary.sum_k_yjv}" maxFractionDigits="2" /></td>
                        <td></td>
                        <td></td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>
        <table id="contentTable" class="table table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th class="sort-column a4.name ">销售</th>
                <th class="sort-column a2.no">合同编号</th>
               <%-- <th class="sort-column K_SV">合同金额</th>
                <th class="sort-column K_COG">采购成本</th>--%>
                <th class="sort-column K_SV-K_COg">进销差价</th>
                <th class="sort-column a.stock_in_amount+a.discount">额外总成本</th>
                <th class="sort-column customerCost">销售奖金</th>
                <th class="sort-column stockInAmount+extraAmount+customerCost">抵扣</th>
                <th class="sort-column a.K_SV/a.sv">收款占比</th>

                <%--<th>本期毛利</th>--%>
                <th class="sort-column k_tr_v">税收成本</th>
                <th>物流费用</th>
                <th class="sort-column k_pcc_v">账期成本</th>
                <th class="sort-column a.k_np">本期净利</th>
                <th class="sort-column k_yj_v">业绩提成</th>
                <th class="sort-column k_ew_v">额外佣金</th>
                <th class="sort-column k_sc">合计</th>
                <th class="sort-column a.status">状态</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="oaCommission">
                <tr>

                    <td>${oaCommission.saler.name}</td>
                    <td><a href="${ctx}/oa/contract/view?id=${oaCommission.contract.id}"><c:if test="${oaCommission.cancelFlag eq 1}"><del class="text-danger"></c:if>${oaCommission.contract.no}<c:if test="${oaCommission.cancelFlag eq 1}"></del></c:if></a>
                    </td>
                   <%-- <td><fmt:formatNumber type="number" value="${oaCommission.KSv}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${oaCommission.KCog}" maxFractionDigits="2" /></td>--%>
                    <td><fmt:formatNumber type="number" value="${oaCommission.KSv - oaCommission.KCog}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${oaCommission.stockInAmount + oaCommission.extraAmount}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${oaCommission.customerCost * 1.1}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${oaCommission.stockInAmount + oaCommission.extraAmount + oaCommission.customerCost * 1.1}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${oaCommission.sv==0?'':((oaCommission.KSv / oaCommission.sv) *100)}" maxFractionDigits="2" /></td>

                   <%-- <td>${oaCommission.KGp}</td>--%>
                    <td>${oaCommission.KTrV}</td>
                    <td>${oaCommission.KLc}</td>
                    <td>${oaCommission.KPccV}</td>
                    <td>${oaCommission.KNp}</td>
                    <td>${oaCommission.KYjV}</td>
                    <td>${oaCommission.KEwV}</td>
                    <td>${oaCommission.KSc}</td>
                    <td>${oaCommission.status eq 0?'未确认':'确认'}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        ${page}
    </div>
</div>
</body>
</html>