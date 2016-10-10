<%@ page import="java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同管理</title>
    <meta name="decorator" content="default"/>
    <style>
	body{padding-top:17px;}
    </style>
    <script src='${ctxStatic}/jquery-plugin/jquery.masonry.js'></script>
    <script src="${ctxStatic}/assets/plugins/echarts.min.js"></script>
    <script>
        $(function () {
            //瀑布流
            $('#masonry').masonry({
                columnWidth: '.item',
                itemSelector: '.item'
            });
        });
    </script>
    <shiro:hasAnyRoles name="cw,cfo">
        <link href='${ctxStatic}/assets/fullcalendar/fullcalendar.css'
              rel='stylesheet'/>
        <link href='${ctxStatic}/assets/fullcalendar/fullcalendar.print.css'
              rel='stylesheet' media='print'/>
        <script src='${ctxStatic}/assets/fullcalendar/moment.min.js'></script>
        <script src='${ctxStatic}/assets/fullcalendar/fullcalendar.min.js'></script>
        <script src='${ctxStatic}/assets/fullcalendar/zh-cn.js'></script>

        <script>

            $(document).ready(function () {
                var rootpath = "${ctx}";
                var financeCalendarList = ${fns:toJson(financeCalendarList)};
                $.each(financeCalendarList, function (i, item) {
                    financeCalendarList[i].url = rootpath + item.url;
                });
                $('#calendar').fullCalendar({
                    header: {
                        left: 'prev,next',
                        center: 'title',
                        //right: 'month,agendaWeek,agendaDay,listWeek'
                        right: ''
                    },
                    locale: 'zh-cn',
                    navLinks: true, // can click day/week names to navigate views
                    editable: true,
                    eventLimit: true, // allow "more" link when too many events
                    events: financeCalendarList,
                    height: $(top.window).height() - 100,
                    fixedWeekCount: false
                });
            });

        </script>
    </shiro:hasAnyRoles>
</head>
<body>
<div class="container">
    <shiro:hasAnyRoles name="cw,cfo">
    <div class="row" id="calendar" style="padding:10px;background:#fff;margin-bottom:20px;"></div>
    </shiro:hasAnyRoles>
    <shiro:hasAnyRoles name="cso,saler">
    <div class="row">
        <div class="col-sm-12">
            <div class="card-box">
                <div id="total" style="height: 460px;" class="flot-chart"></div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var total = echarts.init(document.getElementById('total'));
        var home_gauge = ${fns:toJson(home_gauge)};
        var avg_quarter_gpi = home_gauge[0].avg_quarter_gpi,
                avg_year_gpi = home_gauge[0].avg_year_gpi,
                sum_quarter_gpi = home_gauge[0].sum_quarter_gpi,
                sum_year_gpi = home_gauge[0].sum_year_gpi,
                quarter_ld_amount = home_gauge[0].quarter_ld_amount,
                year_ld_amount = home_gauge[0].year_ld_amount,
                quarter_yj_amount = home_gauge[0].quarter_yj_amount,
                year_yj_amount = home_gauge[0].year_yj_amount;
        option = {
            title: {
                text: '业绩完成情况'
            },
            tooltip: {
                formatter: "{a} <br/>{c}"
            },
            series: [{
                name: '本季度业绩',
                type: 'gauge',
                z: 3,
                min: 0,
                max: avg_quarter_gpi,
                splitNumber: 10,
                radius: '85%',
                axisLine: { // 坐标轴线
                    lineStyle: { // 属性lineStyle控制线条样式
                        width: 10
                    }
                },
                axisLabel: {
                    formatter: function (v) {
                        return v.toFixed(0);
                    }
                },
                axisTick: { // 坐标轴小标记
                    length: 15, // 属性length控制线长
                    lineStyle: { // 属性lineStyle控制线条样式
                        color: 'auto'
                    }
                },
                splitLine: { // 分隔线
                    length: 20, // 属性length控制线长
                    lineStyle: { // 属性lineStyle（详见lineStyle）控制线条样式
                        color: 'auto'
                    }
                },
                title: {
                    textStyle: { // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                        fontWeight: 'bolder',
                        fontSize: 20,
                        fontStyle: 'italic'
                    }
                },
                detail: {
                    textStyle: { // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                        fontWeight: 'bolder'
                    }
                },
                data: [{
                    value: quarter_yj_amount,
                    name: '本季度业绩'
                }]
            }, {
                name: '本季度来单',
                type: 'gauge',
                center: ['20%', '55%'], // 默认全局居中
                radius: '55%',
                min: 0,
                max: avg_quarter_gpi,
                endAngle: 45,
                splitNumber: 7,
                axisLine: { // 坐标轴线
                    lineStyle: { // 属性lineStyle控制线条样式
                        width: 8
                    }
                },
                axisLabel: {
                    formatter: function (v) {
                        return v.toFixed(0);
                    }
                },
                axisTick: { // 坐标轴小标记
                    length: 12, // 属性length控制线长
                    lineStyle: { // 属性lineStyle控制线条样式
                        color: 'auto'
                    }
                },
                splitLine: { // 分隔线
                    length: 20, // 属性length控制线长
                    lineStyle: { // 属性lineStyle（详见lineStyle）控制线条样式
                        color: 'auto'
                    }
                },
                pointer: {
                    width: 5
                },
                title: {
                    offsetCenter: [0, '-30%'], // x, y，单位px
                },
                detail: {
                    textStyle: { // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                        fontWeight: 'bolder'
                    }
                },
                data: [{
                    value: quarter_ld_amount,
                    name: '本季度来单'
                }]
            }, {
                name: '年度完成度',
                type: 'gauge',
                center: ['79%', '50%'], // 默认全局居中
                radius: '55%',
                min: 0,
                max: 100,
                startAngle: 135,
                endAngle: 45,
                splitNumber: 2,
                axisLine: { // 坐标轴线
                    lineStyle: { // 属性lineStyle控制线条样式
                        width: 8
                    }
                },
                axisTick: { // 坐标轴小标记
                    splitNumber: 5,
                    length: 10, // 属性length控制线长
                    lineStyle: { // 属性lineStyle控制线条样式
                        color: 'auto'
                    }
                },
                axisLabel: {
                    formatter: function (v) {
                        switch (v + '') {
                            case '0':
                                return '0';
                            case '50':
                                return '年度完成50%';
                            case '100':
                                return '100%';
                        }
                    }
                },
                splitLine: { // 分隔线
                    length: 15, // 属性length控制线长
                    lineStyle: { // 属性lineStyle（详见lineStyle）控制线条样式
                        color: 'auto'
                    }
                },
                pointer: {
                    width: 2
                },
                title: {
                    show: false
                },
                detail: {
                    show: false
                },
                data: [{
                    value: ((year_yj_amount / sum_year_gpi) * 100).toFixed(2),
                    name: 'gas'
                }]
            }, {
                name: '年度来单',
                type: 'gauge',
                center: ['79%', '50%'], // 默认全局居中
                radius: '55%',
                min: 0,
                max: 100,
                startAngle: 315,
                endAngle: 225,
                splitNumber: 2,
                axisLine: { // 坐标轴线
                    lineStyle: { // 属性lineStyle控制线条样式
                        width: 8
                    }
                },
                axisTick: { // 坐标轴小标记
                    show: false
                },
                axisLabel: {
                    formatter: function (v) {
                        switch (v + '') {
                            case '0':
                                return '0';
                            case '50':
                                return '年度来单50%';
                            case '100':
                                return '100%';
                        }
                    }
                },
                splitLine: { // 分隔线
                    length: 15, // 属性length控制线长
                    lineStyle: { // 属性lineStyle（详见lineStyle）控制线条样式
                        color: 'auto'
                    }
                },
                pointer: {
                    width: 2
                },
                title: {
                    show: false
                },
                detail: {
                    show: false
                },
                data: [{
                    value: ((year_ld_amount / sum_year_gpi) * 100).toFixed(2),
                    name: '年度来单'
                }]
            }]
        };
        total.setOption(option);
    </script>
    </shiro:hasAnyRoles>
    <shiro:hasAnyRoles name="cso,cfo">
    <div class="row">
        <div class="col-sm-4">
            <div class="card-box" style="height: 200px;">
                <h4 class="header-title m-t-0">收款情况</h4>
                <div class="text-center m-t-30">
                    <h2 class="text-custom">应收${financeList[0]['allAmount']}</h2>
                    <ul class="list-unstyled">
                        <c:choose>
                            <c:when test="${fn:length(financeList) eq 0}">
                                <li>已收：0</li>
                                <li>未收：0</li>
                                <li>逾期：<span class="text-danger">0</span></li>
                            </c:when>
                            <c:otherwise>
                                <li>已收：${not empty financeList[0]['payAmount'] ? financeList[0]['payAmount'] : 0}</li>
                                <li>
                                    未收：${not empty financeList[0]['noPayAmount'] ? financeList[0]['noPayAmount'] : 0}</li>
                                <li>逾期：<span
                                        class="text-danger">${not empty financeList[0]['overdueAmount']? financeList[0]['overdueAmount']:0}</span>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>
        <!-- end col -->

        <div class="col-sm-4">
            <div class="card-box" style="height: 200px;">
                <h4 class="header-title m-t-0">付款情况</h4>
                <div class="text-center m-t-30">

                    <c:choose>
                        <c:when test="${fn:length(financeList) eq 0}">
                            <h2 class="text-custom">应付0</h2>
                            <ul class="list-unstyled">
                                <li>已付：0</li>
                                <li>未付：0</li>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <h2 class="text-custom">
                                应付${not empty financeList[0]['toAllAmount'] ? financeList[0]['toAllAmount'] : 0}</h2>
                            <ul class="list-unstyled">
                                <li>
                                    已付：${not empty financeList[0]['toPayAmount'] ? financeList[0]['toPayAmount'] : 0}</li>
                                <li>
                                    未付：${not empty financeList[0]['toNoPayAmount'] ? financeList[0]['toNoPayAmount'] : 0}</li>
                            </ul>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
        <!-- end col -->

        <div class="col-sm-4">
            <div class="card-box" style="height: 200px;">
                <h4 class="header-title m-t-0">待开发票金额</h4>
                <div class="text-center m-t-30">
                    <c:choose>
                        <c:when test="${fn:length(financeList) eq 0}">
                            <h2 class="text-custom">待开票 0</h2>
                        </c:when>
                        <c:otherwise>
                            <h2 class="text-custom">
                                待开票${not empty financeList[0]['noBillAmount'] ? financeList[0]['noBillAmount'] : 0}</h2>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <!-- end col -->
    </div>
    </shiro:hasAnyRoles>

    <div class="row masonry-container" id="masonry">
        <shiro:hasAnyRoles name="cso">

            <div class="col-sm-6 item">
                <div class="card-box">
                    <h4 class="header-title m-t-0">销售来单情况</h4>
                    <div id="total_1" style="height: 293px;" class="flot-chart"></div>
                </div>
            </div>
            <script type="text/javascript">
                var total_1 = echarts.init(document.getElementById('total_1'));
                var salerList = ${fns:toJson(salerList)};
                var home_ld_group_by_salar = ${fns:toJson(home_ld_group_by_salar)};
                var home_ld_series = [];
                var saler_List = [];
                $.each(salerList, function (idx, saler) {
                    saler_List.push(saler.name);
                    var item = {
                        name: saler.name,
                        type: 'bar',
                        stack: '总量',
                        label: {
                            normal: {
                                show: true,
                                position: 'insideRight'
                            }
                        },
                        data: [0, 0, 0, 0]
                    };
                    $.each(home_ld_group_by_salar, function (idx, data) {
                        if (saler.id == data.saler_id) {
                            if (data.total_amount) {
                                switch (data.quarter) {
                                    case 1:
                                        item.data[3] = parseFloat(data.total_amount).toFixed(2);
                                        break;
                                    case 2:
                                        item.data[2] = parseFloat(data.total_amount).toFixed(2);
                                        break;
                                    case 3:
                                        item.data[1] = parseFloat(data.total_amount).toFixed(2);
                                        break;
                                    case 4:
                                        item.data[0] = parseFloat(data.total_amount).toFixed(2);
                                        break;
                                }
                            }

                            return;
                        }
                    });
                    home_ld_series.push(item);
                });
                option = {
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                            type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        }
                    },
                    legend: {
                        data: saler_List
                    },
                    color: ['#4568cc', '#3fc847', '#46b0e4', '#fcca35', '#e96153', '#57c4a4', '#c23531', '#2f4554', '#61a0a8', '#d48265', '#91c7ae', '#749f83', '#ca8622', '#bda29a', '#6e7074', '#546570', '#c4ccd3'],
                    grid: {
                        left: '0%',
                        right: '4%',
                        bottom: '3%',
                        containLabel: true
                    },
                    xAxis: {
                        type: 'value'
                    },
                    yAxis: {
                        type: 'category',
                        data: ['Q4', 'Q3', 'Q2', 'Q1']
                    },
                    series: home_ld_series
                };
                total_1.setOption(option);
            </script>
            <!-- end col-->
        </shiro:hasAnyRoles>

        <shiro:hasAnyRoles name="cso,saler">
            <!--来单情况-->
            <div class="col-sm-6 item">
                <div class="card-box">

                    <div id="website-stats" style="height: 320px;" class="flot-chart"></div>

                </div>
                <script type="text/javascript">
                    var website_stats = echarts.init(document
                            .getElementById('website-stats'));
                    <%
						Calendar cc = Calendar.getInstance();
						request.setAttribute("year", cc.get(Calendar.YEAR));
						request.setAttribute("month", cc.get(Calendar.MONTH) + 1);
					%>
                    var ldqk_data = ${fns:toJson(salerHomeList5)};
                    var sj_data=[0, 0, 0, 0, 0, 0];//实际数据
                    var fyear = ${year};
                    var fmonth = ${month};
                    for(var i=5;i>=0;i--){
                        $.each(ldqk_data, function(idx, data){
                            if(fyear == data.year && fmonth == data.month && data.value){
                                sj_data[i] = data.value;
                                return;
                            }
                        });
                        fmonth--;
                        if(fmonth==0){
                            fyear--;
                            fmonth=12;
                        }
                        i--;
                    }

                    option = {
                        title: {
                            text: '来单情况'
                        },
                        color: ['#57c5a5', '#dedede'],
                        tooltip: {
                            trigger: 'axis'
                        },
                        legend: {
                            data: ['实际', '预测']
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
                            data: ['1', '2', '3', '4', '5', '6']
                        }],
                        yAxis: [{
                            type: 'value'
                        }],
                        series: [{
                            name: '实际',
                            type: 'line',
                            stack: '总量',
                            areaStyle: {
                                normal: {}
                            },
                            data: sj_data
                        }, {
                            name: '预测',
                            type: 'line',
                            stack: '总量',
                            areaStyle: {
                                normal: {}
                            },
                            data: [182, 191, 234, 290, 330, 310]
                        }]
                    };
                    website_stats.setOption(option);
                </script>
            </div>
            <!--产品组来单情况-->
            <div class="col-sm-6 item">
                <div class="card-box">
                    <div id="product" style="height: 320px;" class="flot-chart"></div>
                </div>
                <script type="text/javascript">
                    // 基于准备好的dom，初始化echarts实例
                    var product = echarts.init(document
                            .getElementById('product'));

                    option = {
                        title: {
                            text: '产品组来单情况',
                            x: 'left'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b}: {c} ({d}%)"
                        },
                        legend: {
                            orient: 'vertical',
                            x: 'right',
                            data: ['K1', 'K2', 'K3', 'K4', 'K5']
                        },
                        color: ['#4eb194', '#57c5a5', '#79d1b7', '#9adcc9',
                            '#caede3'],
                        series: [{
                            name: '当季度合同状态',
                            type: 'pie',
                            radius: ['50%', '70%'],
                            avoidLabelOverlap: false,
                            label: {
                                normal: {
                                    show: false,
                                    position: 'center'
                                },
                                emphasis: {
                                    show: true,
                                    textStyle: {
                                        fontSize: '30',
                                        fontWeight: 'bold'
                                    }
                                }
                            },
                            labelLine: {
                                normal: {
                                    show: false
                                }
                            },
                            data: ${fns:toJson(salerHomeList1)}
                        }]
                    };

                    product.setOption(option);
                </script>

            </div>
        </shiro:hasAnyRoles>
        <shiro:hasAnyRoles name="cso">
            <!--KAB产品组来单情况-->
            <div class="col-sm-6 item">
                <div class="card-box">
                    <div id="kabProduct" style="height: 320px;" class="flot-chart"></div>
                </div>
                <script type="text/javascript">
                    // 基于准备好的dom，初始化echarts实例
                    var kabProduct = echarts.init(document
                            .getElementById('kabProduct'));

                    option = {
                        title: {
                            text: 'KAB产品组来单情况',
                            x: 'left'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b}: {c} ({d}%)"
                        },
                        legend: {
                            orient: 'vertical',
                            x: 'right',
                            data: ['K1', 'K2', 'K3', 'K4', 'K5']
                        },
                        color: ['#4eb194', '#57c5a5', '#79d1b7', '#9adcc9',
                            '#caede3'],
                        series: [{
                            name: '当季度合同状态',
                            type: 'pie',
                            radius: ['50%', '70%'],
                            avoidLabelOverlap: false,
                            label: {
                                normal: {
                                    show: false,
                                    position: 'center'
                                },
                                emphasis: {
                                    show: true,
                                    textStyle: {
                                        fontSize: '30',
                                        fontWeight: 'bold'
                                    }
                                }
                            },
                            labelLine: {
                                normal: {
                                    show: false
                                }
                            },
                            data: ${fns:toJson(salerHomeList4)}
                        }]
                    };

                    kabProduct.setOption(option);
                </script>

            </div>
            <!--应收实收情况-->
            <div class="col-sm-6 item">
                <div class="card-box">

                    <div id="income-stats" style="height: 320px;" class="flot-chart"></div>

                </div>
                <script type="text/javascript">
                    var income_stats = echarts.init(document
                            .getElementById('income-stats'));
                    option = {
                        title: {
                            text: '应收实收情况'
                        },
                        color: ['#45b0e2', '#57c5a5'],
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'shadow'
                            }
                        },
                        legend: {
                            data: ['应收', '实收']
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '3%',
                            containLabel: true
                        },
                        xAxis: {
                            type: 'value',
                            boundaryGap: [0, 0.01]
                        },
                        yAxis: {
                            type: 'category',
                            data: ['上期', '本期',]
                        },
                        series: [{
                            name: '应收',
                            type: 'bar',
                            data: [18203, 23489]
                        }, {
                            name: '实收',
                            type: 'bar',
                            data: [19325, 23438]
                        }]
                    };
                    income_stats.setOption(option);
                </script>
            </div>
            <!--当季度合同状态-->
            <div class="col-sm-6 item">
                <div class="card-box">
                    <div id="pie-chart-container" style="height: 320px;"
                         class="flot-chart"></div>
                </div>
                <script type="text/javascript">
                    // 基于准备好的dom，初始化echarts实例
                    var pie = echarts.init(document
                            .getElementById('pie-chart-container'));

                    // 指定图表的配置项和数据
                    option = {
                        title: {
                            text: '当季度合同状态',
                            x: 'left'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c} ({d}%)"
                        },
                        color: ['#57c5a5', '#79d1b7', '#9adcc9'],
                        legend: {
                            orient: 'vertical',
                            left: 'right',
                            data: ['已签约', '已验收', '已完成']
                        },
                        series: [{
                            name: '当季度合同状态',
                            type: 'pie',
                            radius: '55%',
                            center: ['50%', '60%'],
                            data: ${fns:toJson(salerHomeList2)},
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }]
                    };

                    // 使用刚指定的配置项和数据显示图表。
                    pie.setOption(option);
                </script>
            </div>
        </shiro:hasAnyRoles>
        <!-- end col-->

        <div class="col-sm-6 item">
            <div class="card-box" id="card_contract_audit">
                <h4 class="header-title m-t-0 m-b-30">合同订单待办</h4>
                <c:choose>
                    <c:when test="${empty contract_audit_list}">
                        当前无待办事项
                    </c:when>
                    <c:otherwise>
                        <table class="table m-0">
                            <thead>
                            <tr>
                                <th width="20%">合同号</th>
                                <th>合同名称</th>
                                <th width="15%">流程节点</th>

                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${contract_audit_list}" var="contract_audit"
                                       varStatus="p">
                                <c:set var="task" value="${contract_audit.task}"/>
                                <c:set var="vars" value="${contract_audit.vars}"/>
                                <c:set var="procDef" value="${contract_audit.procDef}"/>
                                <c:set var="status" value="${contract_audit.status}"/>
                                <tr>
                                    <td scope="row">${not empty vars.map.contract_no ? vars.map.contract_no: p.index + 1}</td>
                                    <td><a
                                            href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">
                                            ${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 30)}</a>
                                    </td>
                                    <td><span
                                            class="label label-<c:if test="${not empty vars.map.status}">${fns:getDictRemark(vars.map.status,"oa_contract_status" ,"danguer" )}</c:if>
													<c:if test="${empty vars.map.status}">danger</c:if>">${task.name}</span>
                                    </td>
                                </tr>
                            </c:forEach>

                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="col-sm-6 item">
            <shiro:hasAnyRoles name="cw,cfo">
                <div class="card-box">
                    <h4 class="header-title m-t-0 m-b-30">合同退款待办</h4>
                    <c:choose>
                        <c:when test="${empty contract_refund_audit_list}">
                            当前无待办事项
                        </c:when>
                        <c:otherwise>
                            <table class="table m-0">
                                <thead>
                                <tr>
                                    <th width="35%">合同号</th>
                                    <th>合同名称</th>
                                    <th width="15%">流程节点</th>

                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${contract_refund_audit_list}"
                                           var="contract_refund_audit" varStatus="p">
                                    <c:set var="task" value="${contract_refund_audit.task}"/>
                                    <c:set var="vars" value="${contract_refund_audit.vars}"/>
                                    <c:set var="procDef" value="${contract_refund_audit.procDef}"/>
                                    <c:set var="status" value="${contract_refund_audit.status}"/>
                                    <tr>
                                        <td scope="row">${not empty vars.map.contract_no ? vars.map.contract_no: p.index + 1}</td>
                                        <td><a
                                                href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">
                                                ${fns:abbr(not empty vars.map.contract_name ? vars.map.contract_name : task.id, 30)}
                                        </a></td>
                                        <td><span class="label label-danger">${task.name}</span></td>
                                    </tr>
                                </c:forEach>

                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </shiro:hasAnyRoles>
        </div>
        <div class="col-sm-6 item">
            <shiro:hasAnyRoles name="cw,tech,businesser,cfo,dept">
                <div class="card-box" id="card_po_audit">
                    <h4 class="header-title m-t-0 m-b-30">采购订单待办</h4>
                    <c:choose>
                        <c:when test="${empty po_audit_list}">
                            当前无待办事项
                        </c:when>
                        <c:otherwise>
                            <table class="table m-0">
                                <thead>
                                <tr>
                                    <th width="35%">订单号</th>
                                    <th>合同名称</th>
                                    <th width="15%">流程节点</th>

                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${po_audit_list}" var="po_audit"
                                           varStatus="p">
                                    <c:set var="task" value="${po_audit.task}"/>
                                    <c:set var="vars" value="${po_audit.vars}"/>
                                    <c:set var="procDef" value="${po_audit.procDef}"/>
                                    <c:set var="status" value="${po_audit.status}"/>
                                    <tr>
                                        <td scope="row">${not empty vars.map.title ? vars.map.title: p.index + 1}</td>
                                        <td><a
                                                href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">
                                                ${fns:abbr(not empty vars.map.contract_name ? vars.map.contract_name : task.id, 30)}
                                        </a></td>
                                        <td><span
                                                class="label label-<c:if test="${not empty vars.map.status}">${fns:getDictRemark(vars.map.status,"oa_po_status" ,"danguer" )}</c:if>
														<c:if test="${empty vars.map.status}">danger</c:if>">${task.name}</span>
                                        </td>
                                    </tr>
                                </c:forEach>

                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>

                </div>
            </shiro:hasAnyRoles>
        </div>
        <div class="col-sm-6 item">
            <shiro:hasRole name="cw">
                <div class="card-box">
                    <h4 class="header-title m-t-0 m-b-30">采购订单退款待办</h4>
                    <c:choose>
                        <c:when test="${empty po_tk_audit_list}">
                            当前无待办事项
                        </c:when>
                        <c:otherwise>
                            <table class="table m-0">
                                <thead>
                                <tr>
                                    <th width="35%">订单号</th>
                                    <th>合同名称</th>
                                    <th width="15%">流程节点</th>

                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${po_tk_audit_list}" var="po_tk_audit"
                                           varStatus="p">
                                    <c:set var="task" value="${po_tk_audit.task}"/>
                                    <c:set var="vars" value="${po_tk_audit.vars}"/>
                                    <c:set var="procDef" value="${po_tk_audit.procDef}"/>
                                    <c:set var="status" value="${po_tk_audit.status}"/>
                                    <tr>
                                        <td scope="row">${not empty vars.map.po_no ? vars.map.po_no: p.index + 1}</td>
                                        <td><a
                                                href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">
                                                ${fns:abbr(not empty vars.map.contract_name ? vars.map.contract_name : task.id, 30)}
                                        </a></td>
                                        <td><span class="label label-danger">${task.name}</span></td>
                                    </tr>
                                </c:forEach>

                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </shiro:hasRole>
        </div>
    </div>
</body>
</html>