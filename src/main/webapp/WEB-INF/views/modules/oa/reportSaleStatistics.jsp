<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>销售统计报表</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            $("select").select2({allowClear: true});

            //全选
            $("#checkall").click(function(){
                if($(this).is(':checked')){
                    $("input[name='salerIds']").prop("checked","checked");
                } else{
                    $("input[name='salerIds']").prop("checked","");
                }
            });
            $("input[name='salerIds']").click(function(){
                $("#checkall").prop("checked","checked");
                $("input[name='salerIds']").each(function(){
                   if(!$(this).is(':checked')) {
                       $("#checkall").prop("checked","");
                       return;
                   }
                });
            });
            if(${fn:length(salerList)} == ${fn:length(searchParams.salerIds)}){
                $("#checkall").prop("checked","checked");
            } else{
                $("#checkall").prop("checked","");
            }

            <c:if test="${not empty searchParams.customerId}">
                $("#span-cust").html($("#customerId").find("option:selected").text());
            </c:if>
            //毛利率
            <c:if test="${not empty summary.contract_ml && not empty summary.amount}">
                $("#span-ml").html(((${summary.contract_ml}/${summary.amount})*100).toFixed(2) + " %");
            </c:if>
            //其它产品毛利率
            <c:if test="${not empty summary.contract_ml && not empty summary.other_ml}">
                $("#span-otherML").html(((${summary.other_ml}/${summary.amount})*100).toFixed(2) + " %");
            </c:if>

            changeType(${searchParams.reportType});
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function changeType(type){
            switch (type){
                case 3:
                    $("#span-summary-amount").html("合同总金额");
                    $("#contentTable thead tr th:eq(5)").html("合同金额");
                    break;
                case 4:
                    $("#span-summary-amount").html("业绩总金额");
                    $("#contentTable thead tr th:eq(5)").html("业绩金额");
                    break;
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
<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">销售统计报表</h2>
<div class="panel panel-default" style="padding: 0;">
    <div class="panel-body" style="padding: 0 0 0 20px;">
        <form:form id="searchForm" modelAttribute="searchParams"
                   action="${ctx}/report/saleStatistics" method="post"
                   class="breadcrumb form-search form-inline">
            <input id="pageNo" name="pageNo" type="hidden"
                   value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden"
                   value="${page.pageSize}"/>
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
                           callback="page();"/>
            <div class="row m-b-20">
                <form:checkboxes path="salerIds"
                                 items="${salerList}" itemLabel="name"
                                 itemValue="id" htmlEscape="false" class=""
                                 element="span class='checkbox checkbox-custom checkbox-inline'"/>
                <span class="checkbox checkbox-custom checkbox-inline">
                    <input id="checkall" type="checkbox" checked>
                    <label for="checkall">全选</label></span>
            </div>

            <div class="form-group m-r-10">
                <label>时间：</label>
                <div class="input-group">
                    <input name="startTime" type="text" readonly="readonly"
                           maxlength="20" class="form-control" size="10"
                           value="${searchParams.startTime}"
                           onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                </div>
                <div class="input-group">
                    <input name="endTime" type="text" readonly="readonly"
                           maxlength="20" class="form-control" size="10"
                           value="${searchParams.endTime}"
                           onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                </div>
            </div>
            <div class="form-group m-r-10">
                <label>客户：</label>
                <form:select path="customerId" class="select2-container form-control" id="customerId"
                             cssStyle="width:200px;">
                    <form:option value="" label=""/>
                    <form:options items="${customerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false"/>
                </form:select>
            </div>
            <div class="form-group m-r-10">
                <span class="radio radio-custom radio-inline">
                    <input id="reportType3" name="reportType" value="4" type="radio" ${searchParams.reportType eq '4'? 'checked':''} onchange="changeType(4)">
                    <label for="reportType3">业绩</label>
                </span>
                <span class="radio radio-custom radio-inline">
                    <input id="reportType4" name="reportType" value="3" type="radio" ${searchParams.reportType eq '3'? 'checked':''} onchange="changeType(3)">
                    <label for="reportType4">来单</label>
                </span>
            </div>
            <input type="hidden" name="flag" id="flag">
            <div class="form-group m-r-10">
                <button id="btnSubmit" class="btn btn-custom" type="submit" onclick="$('#flag').val('search');"
                        value="查询">查&nbsp;&nbsp;询
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
                            <td>客户：<span id="span-cust">全选</span></td>
                            <td><span id="span-summary-amount">合同总金额</span>：<fmt:formatNumber type="number" value="${summary.amount}" maxFractionDigits="2" /></td>
                            <td>采购总金额：<fmt:formatNumber type="number" value="${summary.po_sum_amount}" maxFractionDigits="2" /></td>
                            <td>进销差价：<fmt:formatNumber type="number" value="${summary.contract_ce}" maxFractionDigits="2" /></td>
                            <td>销售总费用：<fmt:formatNumber type="number" value="${summary.customer_cost}" maxFractionDigits="2" /></td>
                        </tr>
                        <tr>
                            <td>K1总金额：<fmt:formatNumber type="number" value="${summary.k1_amount}" maxFractionDigits="2" /></td>
                            <td>K2总金额：<fmt:formatNumber type="number" value="${summary.k2_amount}" maxFractionDigits="2" /></td>
                            <td>K3总金额：<fmt:formatNumber type="number" value="${summary.k3_amount}" maxFractionDigits="2" /></td>
                            <td>K4总金额：<fmt:formatNumber type="number" value="${summary.k4_amount}" maxFractionDigits="2" /></td>
                            <td>K5总金额：<fmt:formatNumber type="number" value="${summary.k5_amount}" maxFractionDigits="2" /></td>
                        </tr>
                        <tr>
                            <td>K1-K4产品利润：<fmt:formatNumber type="number" value="${summary.other_ml}" maxFractionDigits="2" /></td>
                            <td>K1-K4产品利润率：<span style="color:red;" id="span-otherML">${(summary.contract_ml / summary.amount) * 100} %</span></td>
                            <td>总毛利：<fmt:formatNumber type="number" value="${summary.contract_ml}" maxFractionDigits="2" /></td>
                            <td>总毛利率：<span style="color:red;" id="span-ml">${(summary.contract_ml / summary.amount) * 100} %</span></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <table id="contentTable" class="table table-striped m-0">
            <thead>
            <tr>
                <th>日期</th>
                <th>合同编号</th>
                <th>公司抬头</th>
                <th>客户</th>
                <th>销售</th>
                <th>合同金额</th>
                <th>K1</th>
                <th>K2</th>
                <th>K3</th>
                <th>K4</th>
                <th>K5</th>
                <th>合同状态</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="item">
                <tr>
                    <td>${item.create_date}</td>
                    <td><a href="${ctx}/oa/contract/view?id=${item.id}" target="mainFrame">${item.contract_no}</a></td>
                    <td>${item.company_name}</td>
                    <td>${item.cust_name}</td>
                    <td>${item.saler_name}</td>
                    <td><c:if test="${not empty item.amount && item.amount ne '0E-8'}"><fmt:formatNumber type="number" value="${item.amount}" maxFractionDigits="2" /></c:if></td>
                    <td><c:if test="${not empty item.k1_amount && item.k1_amount ne '0E-8'}"><fmt:formatNumber type="number" value="${item.k1_amount}" maxFractionDigits="2" /></c:if></td>
                    <td><c:if test="${not empty item.k2_amount && item.k2_amount ne '0E-8'}"><fmt:formatNumber type="number" value="${item.k2_amount}" maxFractionDigits="2" /></c:if></td>
                    <td><c:if test="${not empty item.k3_amount && item.k3_amount ne '0E-8'}"><fmt:formatNumber type="number" value="${item.k3_amount}" maxFractionDigits="2" /></c:if></td>
                    <td><c:if test="${not empty item.k4_amount && item.k4_amount ne '0E-8'}"><fmt:formatNumber type="number" value="${item.k4_amount}" maxFractionDigits="2" /></c:if></td>
                    <td><c:if test="${not empty item.k5_amount && item.k5_amount ne '0E-8'}"><fmt:formatNumber type="number" value="${item.k5_amount}" maxFractionDigits="2" /></c:if></td>
                    <td>${item.contract_status}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        ${page}
    </div>
</div>
</body>
</html>