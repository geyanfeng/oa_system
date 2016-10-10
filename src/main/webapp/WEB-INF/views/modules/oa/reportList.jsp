<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title></title>
    <meta name="decorator" content="default"/>
    <script src="${ctxStatic}/assets/plugins/echarts.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("select").select2({allowClear: true});
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
    </script>
    <style type="text/css">
        .form-group {
            margin-top: 10px;
        }
    </style>
</head>
<body>
<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">${title}</h2>
<div class="panel panel-default">
    <div class="panel-body">
        <form:form id="searchForm" modelAttribute="searchParams" method="post"
                   class="breadcrumb form-search form-inline">
            <input id="pageNo" name="pageNo" type="hidden"
                   value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden"
                   value="${page.pageSize}"/>
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
                           callback="page();"/>
            <c:if test="${reportType eq '1' or reportType eq '2' or reportType eq '7'}">
                <div class="form-group m-r-10">
                    <label>日期：</label>
                    <div class="input-group">
                        <input name="startTime" type="text" readonly="readonly"
                               maxlength="20" class="form-control" size="10"
                               value="${searchParams.startTime}"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                    </div>
                    <div class="input-group">
                        <input name="endTime" type="text" readonly="readonly"
                               maxlength="20" class="form-control" size="10"
                               value="${searchParams.endTime}"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                    </div>
                </div>
            </c:if>
            <c:if test="${reportType eq '3'}">
                <div class="row" style="margin-bottom:20px;">
                    <form:checkboxes path="salerIds"
                                     items="${salerList}" itemLabel="name"
                                     itemValue="id" htmlEscape="false" class=""
                                     element="span class='checkbox checkbox-custom checkbox-inline'"/>

                </div>
                <div class="form-group m-r-10">
                    <label>时间：</label>
                    <div class="input-group">
                        <input name="startTime" type="text" readonly="readonly"
                               maxlength="20" class="form-control" size="10"
                               value="${searchParams.startTime}"
                               onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                    </div>
                    <div class="input-group">
                        <input name="endTime" type="text" readonly="readonly"
                               maxlength="20" class="form-control" size="10"
                               value="${searchParams.endTime}"
                               onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                    </div>
                </div>
            </c:if>

            <c:if test="${reportType eq '4'}">
                <div class="row" style="margin-bottom:20px;">
                    <form:checkboxes path="salerIds"
                                     items="${salerList}" itemLabel="name"
                                     itemValue="id" htmlEscape="false" class=""
                                     element="span class='checkbox checkbox-custom checkbox-inline'"/>

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
            </c:if>
            <c:if test="${reportType eq '7'}">
                <div class="form-group m-r-10">
                    <label>发票类型：</label>

                    <form:select cssStyle="width:200px;" path="invoiceType"
                                 class="select2-container form-control">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('oa_invoice_type')}"
                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
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
            </c:if>
            <c:if test="${reportType eq '5'}">
                <div class="form-group m-r-10">
                    <label>我方抬头：</label>

                    <form:select cssStyle="width:200px;" path="companyId"
                                 class="select2-container form-control">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('oa_company_name')}"
                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
                <div class="form-group m-r-10">
                    <label>销售：</label>

                    <form:select path="salerId" class="select2-container form-control" id="salerId"
                                 cssStyle="width:200px;">
                        <form:option value="" label=""/>
                        <form:options items="${salerList}" itemLabel="name"
                                      itemValue="id" htmlEscape="false"/>
                    </form:select>
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
                    <label>开票状态：</label>

                    <form:select path="billingStatus"
                                 class="form-control" cssStyle="width:100px;">
                        <form:option value="" label="全部"/>
                        <form:option value="1" label="未开票"/>
                        <form:option value="2" label="已开票"/>
                    </form:select>
                </div>
                <div class="form-group m-r-10">
                    <label>收款状态：</label>

                    <form:select path="payStatus"
                                 class="form-control" cssStyle="width:100px;">
                        <form:option value="" label="全部"/>
                        <form:option value="1" label="未付款"/>
                        <form:option value="2" label="已付款"/>
                    </form:select>
                </div>
                <div class="form-group m-r-10">
                    <label>是否逾期：</label>

                    <form:select path="overStatus"
                                 class="form-control" cssStyle="width:100px;">
                        <form:option value="" label="全部"/>
                        <form:option value="1" label="未逾期"/>
                        <form:option value="2" label="已逾期"/>
                    </form:select>
                </div>
            </c:if>
            <c:if test="${reportType eq '6'}">
                <div class="form-group m-r-10">
                    <label>收款方：</label>

                    <form:select path="supplierId" class="select2-container form-control" id="supplierId"
                                 cssStyle="width:200px;">
                        <form:option value="" label=""/>
                        <form:options items="${supplierList}" itemLabel="name"
                                      itemValue="id" htmlEscape="false"/>
                    </form:select>
                </div>
                <div class="form-group m-r-10">
                    <label>付款条件：</label>

                    <form:select path="payCondition"
                                 class="form-control">
                        <form:option value="" label="全部"/>
                        <form:option value="0" label="预付"/>
                        <form:option value="1" label="后付"/>
                    </form:select>
                </div>
            </c:if>
            <c:choose>
                <c:when test="${reportType eq '1'}">
                    <div class="form-group m-r-10">
                        <label>供应商：</label>

                        <form:select path="supplierId" class="select2-container form-control" id="supplierId"
                                     cssStyle="width:200px;">
                            <form:option value="" label=""/>
                            <form:options items="${supplierList}" itemLabel="name"
                                          itemValue="id" htmlEscape="false"/>
                        </form:select>
                    </div>
                </c:when>
                <c:when test="${reportType eq '2' or reportType eq '3'}">
                    <div class="form-group m-r-10">
                        <label>客户：</label>

                        <form:select path="customerId" class="select2-container form-control" id="customerId"
                                     cssStyle="width:200px;">
                            <form:option value="" label=""/>
                            <form:options items="${customerList}" itemLabel="name"
                                          itemValue="id" htmlEscape="false"/>
                        </form:select>
                    </div>
                </c:when>
                <c:when test="${reportType eq '4'}">
                    <div class="form-group m-r-10">
                        <label>产品类型：</label>
                        <form:select path="productTypeGroup" class="input-medium form-control" style="width:200px;">
                            <form:option value="" label=""/>
                            <form:options items="${productTypeGroup_list}" itemLabel="name" itemValue="id"
                                          htmlEscape="false"/>
                        </form:select>
                    </div>


                </c:when>
            </c:choose>
            <div class="form-group m-r-10">
                <button id="btnSubmit" class="btn btn-custom" type="submit"
                        value="查询">查&nbsp;&nbsp;询
                </button>

            </div>
        </form:form>
        <c:if test="${reportType eq '3'}">
            <div class="col-sm-8">
                <div class="card-box">

                    <div id="website-stats" style="height: 320px;" class="flot-chart"></div>

                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function () {
                    var chartData = ${fns:toJson(achievementList)};
                    var xAxisData = new Array();
                    var seriesGpi = new Array();
                    var seriesGp = new Array();
                    $.each(chartData, function (i, item) {
                        xAxisData.push(item.year + "年" + item.quarter + "季度");
                        seriesGpi.push(item.gpi);
                        seriesGp.push(item.gp);
                    });
                    var website_stats = echarts.init(document
                            .getElementById('website-stats'));
                    option = {
                        title: {
                            text: '业绩统计'
                        },
                        color: ['#dedede', '#57c5a5'],
                        tooltip: {
                            trigger: 'axis'
                        },
                        legend: {
                            data: ['毛利指标', '完成毛利']
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '3%',
                            containLabel: true
                        },
                        xAxis: [{
                            type: 'category',
                            boundaryGap: false,
                            data: xAxisData
                        }],
                        yAxis: [{
                            name: '金额',
                            type: 'value'
                        }],
                        series: [{
                            name: '毛利指标',
                            type: 'line',
                            stack: '金额',
                            areaStyle: {
                                normal: {}
                            },
                            label: {
                                normal: {
                                    show: true,
                                    position: 'top'
                                }
                            },
                            data: seriesGpi
                        }, {
                            name: '完成毛利',
                            type: 'line',
                            stack: '金额',
                            areaStyle: {
                                normal: {}
                            },
                            label: {
                                normal: {
                                    show: true,
                                    position: 'top'
                                }
                            },
                            data: seriesGp
                        }]
                    };
                    website_stats.setOption(option);
                });

            </script>
        </c:if>
        <c:if test="${reportType eq '4'}">
            <div class="col-sm-8">
                <div class="card-box">

                    <div id="website-stats" style="height: 320px;" class="flot-chart"></div>

                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function () {
                    var chartData = ${fns:toJson(forecastList)};
                    var xAxisData = new Array();
                    var seriesGpi = new Array();
                    var seriesGp = new Array();
                    $.each(chartData, function (i, item) {
                        xAxisData.push(item.year + "年" + item.month + "月");
                        seriesGpi.push(item.gp);
                        seriesGp.push(item.gp);
                    });
                    var website_stats = echarts.init(document
                            .getElementById('website-stats'));
                    option = {
                        title: {
                            text: '来单预测'
                        },
                        color: ['#dedede', '#57c5a5'],
                        tooltip: {
                            trigger: 'axis'
                        },
                        legend: {
                            data: ['预测毛利', '完成毛利']
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '3%',
                            containLabel: true
                        },
                        xAxis: [{
                            type: 'category',
                            boundaryGap: false,
                            data: xAxisData
                        }],
                        yAxis: [{
                            name: '金额',
                            type: 'value'
                        }],
                        series: [{
                            name: '预测毛利',
                            type: 'line',
                            stack: '金额',
                            areaStyle: {
                                normal: {}
                            },
                            label: {
                                normal: {
                                    show: true,
                                    position: 'top'
                                }
                            },
                            data: seriesGpi
                        }, {
                            name: '完成毛利',
                            type: 'line',
                            stack: '金额',
                            areaStyle: {
                                normal: {}
                            },
                            label: {
                                normal: {
                                    show: true,
                                    position: 'top'
                                }
                            },
                            data: seriesGp
                        }]
                    };
                    website_stats.setOption(option);
                });

            </script>
        </c:if>
        <c:if test="${reportType ne '4'}">
            <sys:message content="${message}"/>
            <table id="contentTable" class="table table-striped m-0">
                <thead>
                <tr>
                    <c:forEach items="${headers}" var="headers">
                        <th class="sort-column ${headers.key}">${headers.value}</th>
                    </c:forEach>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="supplier">
                    <tr>
                        <c:forEach items="${headers}" var="headers">
                            <c:choose>
                                <c:when test="${reportType eq '5' and headers.key eq 'contract_name'}"><td><a href="${ctx}/oa/contract/view?id=${supplier['contract_id']}">${supplier[headers.key]}</a></td></c:when>
                                <c:when test="${reportType eq '6' and headers.key eq 'finance_no'}"><td><a href="${ctx}/oa/purchaseOrder/view?id=${supplier['po_id']}">${supplier[headers.key]}</a></td></c:when>
                                <c:otherwise><td>${supplier[headers.key]}</td></c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            ${page}
        </c:if>
    </div>
</div>
</body>
</html>