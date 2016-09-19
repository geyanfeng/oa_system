<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>合同管理</title>
<meta name="decorator" content="default" />
<style>
</style>
<script src="${ctxStatic}/assets/plugins/echarts.min.js"></script>
</head>
<body>
	<div class="container">
		<c:if test="${roleType eq '1' or roleType eq '2' or roleType eq '3' or roleType eq '4'}">
			<div class="row">
				<div class="col-sm-12">
					<div class="card-box">
						<div id="total" style="height: 460px;" class="flot-chart"></div>
					</div>
				</div>
			</div>

			<script type="text/javascript">
				var total = echarts.init(document.getElementById('total'));
				option = {
					title : {
						text : '业绩完成情况'
					},
					tooltip : {
						formatter : "{a} <br/>{c}"
					},
					series : [ {
						name : '本季度',
						type : 'gauge',
						z : 3,
						min : 0,
						max : 220,
						splitNumber : 11,
						radius : '85%',
						axisLine : { // 坐标轴线
							lineStyle : { // 属性lineStyle控制线条样式
								width : 10
							}
						},
						axisTick : { // 坐标轴小标记
							length : 15, // 属性length控制线长
							lineStyle : { // 属性lineStyle控制线条样式
								color : 'auto'
							}
						},
						splitLine : { // 分隔线
							length : 20, // 属性length控制线长
							lineStyle : { // 属性lineStyle（详见lineStyle）控制线条样式
								color : 'auto'
							}
						},
						title : {
							textStyle : { // 其余属性默认使用全局文本样式，详见TEXTSTYLE
								fontWeight : 'bolder',
								fontSize : 20,
								fontStyle : 'italic'
							}
						},
						detail : {
							textStyle : { // 其余属性默认使用全局文本样式，详见TEXTSTYLE
								fontWeight : 'bolder'
							}
						},
						data : [ {
							value : 4000,
							name : '本季度'
						} ]
					}, {
						name : '本季度预测',
						type : 'gauge',
						center : [ '20%', '55%' ], // 默认全局居中
						radius : '55%',
						min : 0,
						max : 7,
						endAngle : 45,
						splitNumber : 7,
						axisLine : { // 坐标轴线
							lineStyle : { // 属性lineStyle控制线条样式
								width : 8
							}
						},
						axisTick : { // 坐标轴小标记
							length : 12, // 属性length控制线长
							lineStyle : { // 属性lineStyle控制线条样式
								color : 'auto'
							}
						},
						splitLine : { // 分隔线
							length : 20, // 属性length控制线长
							lineStyle : { // 属性lineStyle（详见lineStyle）控制线条样式
								color : 'auto'
							}
						},
						pointer : {
							width : 5
						},
						title : {
							offsetCenter : [ 0, '-30%' ], // x, y，单位px
						},
						detail : {
							textStyle : { // 其余属性默认使用全局文本样式，详见TEXTSTYLE
								fontWeight : 'bolder'
							}
						},
						data : [ {
							value : 1.5,
							name : '本季度预测'
						} ]
					}, {
						name : '年度完成度',
						type : 'gauge',
						center : [ '79%', '50%' ], // 默认全局居中
						radius : '55%',
						min : 0,
						max : 2,
						startAngle : 135,
						endAngle : 45,
						splitNumber : 2,
						axisLine : { // 坐标轴线
							lineStyle : { // 属性lineStyle控制线条样式
								width : 8
							}
						},
						axisTick : { // 坐标轴小标记
							splitNumber : 5,
							length : 10, // 属性length控制线长
							lineStyle : { // 属性lineStyle控制线条样式
								color : 'auto'
							}
						},
						axisLabel : {
							formatter : function(v) {
								switch (v + '') {
								case '0':
									return '0';
								case '1':
									return '年度完成30%';
								case '2':
									return '100%';
								}
							}
						},
						splitLine : { // 分隔线
							length : 15, // 属性length控制线长
							lineStyle : { // 属性lineStyle（详见lineStyle）控制线条样式
								color : 'auto'
							}
						},
						pointer : {
							width : 2
						},
						title : {
							show : false
						},
						detail : {
							show : false
						},
						data : [ {
							value : 0.5,
							name : 'gas'
						} ]
					}, {
						name : '年度预测',
						type : 'gauge',
						center : [ '79%', '50%' ], // 默认全局居中
						radius : '55%',
						min : 0,
						max : 2,
						startAngle : 315,
						endAngle : 225,
						splitNumber : 2,
						axisLine : { // 坐标轴线
							lineStyle : { // 属性lineStyle控制线条样式
								width : 8
							}
						},
						axisTick : { // 坐标轴小标记
							show : false
						},
						axisLabel : {
							formatter : function(v) {
								switch (v + '') {
								case '0':
									return '0';
								case '1':
									return '年度预测50%';
								case '2':
									return '100%';
								}
							}
						},
						splitLine : { // 分隔线
							length : 15, // 属性length控制线长
							lineStyle : { // 属性lineStyle（详见lineStyle）控制线条样式
								color : 'auto'
							}
						},
						pointer : {
							width : 2
						},
						title : {
							show : false
						},
						detail : {
							show : false
						},
						data : [ {
							value : 0.8,
							name : '年度预测'
						} ]
					} ]
				};
				total.setOption(option);
			</script>
		</c:if>
		<c:if test="${roleType eq '1' or roleType eq '2' or roleType eq '3'}">
			<div class="row">
				<div class="col-sm-4">
					<div class="card-box" style="height: 200px;">
						<div class="m-t-0">收款情况</div>
						<div class="text-center m-t-30">
							<h2 class="text-custom">应收1000,000</h2>
							<ul class="list-unstyled">
								<li>已收：10000</li>
								<li>未收：100</li>
								<li>逾期：<span class="text-danger">100</span></li>
							</ul>
						</div>
					</div>
				</div>
				<!-- end col -->

				<div class="col-sm-4">
					<div class="card-box" style="height: 200px;">
						<div class="m-t-0">付款情况</div>
						<div class="text-center m-t-30">
							<h2 class="text-custom">应付1000,000</h2>
							<ul class="list-unstyled">
								<li>已付：10000</li>
								<li>未付：100</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- end col -->

				<div class="col-sm-4">
					<div class="card-box" style="height: 200px;">
						<div class="m-t-0">待开发票金额</div>
						<div class="text-center m-t-30">
							<h2 class="text-custom">待开票1000,000</h2>
						</div>
					</div>
				</div>
				<!-- end col -->
			</div>
		</c:if>

		<c:if test="${roleType eq '1' or roleType eq '2' or roleType eq '3' or roleType eq '4'}">
		<div class="row">
			<div class="col-sm-6">
				<div class="card-box">

					<div id="website-stats" style="height: 320px;" class="flot-chart"></div>

				</div>
				<script type="text/javascript">
					var website_stats = echarts.init(document
							.getElementById('website-stats'));
					option = {
						title : {
							text : '来单情况'
						},
						color : [ '#57c5a5', '#dedede' ],
						tooltip : {
							trigger : 'axis'
						},
						legend : {
							data : [ '实际', '预测' ]
						},
						grid : {
							left : '3%',
							right : '4%',
							bottom : '3%',
							containLabel : true
						},
						xAxis : [ {
							type : 'category',
							boundaryGap : false,
							data : [ '0', '1', '2', '3', '4', '5', '6' ]
						} ],
						yAxis : [ {
							type : 'value'
						} ],
						series : [ {
							name : '实际',
							type : 'line',
							stack : '总量',
							areaStyle : {
								normal : {}
							},
							data : [ 120, 132, 101, 134, 90, 230, 210 ]
						}, {
							name : '预测',
							type : 'line',
							stack : '总量',
							areaStyle : {
								normal : {}
							},
							data : [ 220, 182, 191, 234, 290, 330, 310 ]
						} ]
					};
					website_stats.setOption(option);
				</script>
			</div>

			<div class="col-sm-6">
				<div class="card-box">
					<div id="product" style="height: 320px;" class="flot-chart"></div>
				</div>
				<script type="text/javascript">
					// 基于准备好的dom，初始化echarts实例
					var product = echarts.init(document
							.getElementById('product'));

					option = {
						title : {
							text : '产品组来单情况',
							x : 'left'
						},
						tooltip : {
							trigger : 'item',
							formatter : "{a} <br/>{b}: {c} ({d}%)"
						},
						legend : {
							orient : 'vertical',
							x : 'right',
							data : [ 'K1', 'K2', 'K3', 'K4', 'K5' ]
						},
						color : [ '#4eb194', '#57c5a5', '#79d1b7', '#9adcc9',
								'#caede3' ],
						series : [ {
							name : '当季度合同状态',
							type : 'pie',
							radius : [ '50%', '70%' ],
							avoidLabelOverlap : false,
							label : {
								normal : {
									show : false,
									position : 'center'
								},
								emphasis : {
									show : true,
									textStyle : {
										fontSize : '30',
										fontWeight : 'bold'
									}
								}
							},
							labelLine : {
								normal : {
									show : false
								}
							},
							data : [ {
								value : 335,
								name : 'K1'
							}, {
								value : 310,
								name : 'K2'
							}, {
								value : 234,
								name : 'K3'
							}, {
								value : 135,
								name : 'K4'
							}, {
								value : 1548,
								name : 'K5'
							} ]
						} ]
					};

					product.setOption(option);
				</script>

			</div>

			<!-- end col-->
		</div>
		</c:if>
        <c:if test="${roleType eq '4'}">
		<div class="row">
			<div class="col-sm-6">
				<div class="card-box">

					<div id="income-stats" style="height: 320px;" class="flot-chart"></div>

				</div>
				<script type="text/javascript">
					var income_stats = echarts.init(document
							.getElementById('income-stats'));
					option = {
						title : {
							text : '应收实收情况'
						},
						color : [ '#45b0e2', '#57c5a5' ],
						tooltip : {
							trigger : 'axis',
							axisPointer : {
								type : 'shadow'
							}
						},
						legend : {
							data : [ '应收', '实收' ]
						},
						grid : {
							left : '3%',
							right : '4%',
							bottom : '3%',
							containLabel : true
						},
						xAxis : {
							type : 'value',
							boundaryGap : [ 0, 0.01 ]
						},
						yAxis : {
							type : 'category',
							data : [ '上期', '本期', ]
						},
						series : [ {
							name : '应收',
							type : 'bar',
							data : [ 18203, 23489 ]
						}, {
							name : '实收',
							type : 'bar',
							data : [ 19325, 23438 ]
						} ]
					};
					income_stats.setOption(option);
				</script>
			</div>
			<div class="col-sm-6">
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
						title : {
							text : '当季度合同状态',
							x : 'left'
						},
						tooltip : {
							trigger : 'item',
							formatter : "{a} <br/>{b} : {c} ({d}%)"
						},
						color : [ '#57c5a5', '#79d1b7', '#9adcc9' ],
						legend : {
							orient : 'vertical',
							left : 'right',
							data : [ '已签约', '已验收', '已完成' ]
						},
						series : [ {
							name : '当季度合同状态',
							type : 'pie',
							radius : '55%',
							center : [ '50%', '60%' ],
							data : [ {
								value : 335,
								name : '已签约'
							}, {
								value : 310,
								name : '已验收'
							}, {
								value : 234,
								name : '已完成'
							} ],
							itemStyle : {
								emphasis : {
									shadowBlur : 10,
									shadowOffsetX : 0,
									shadowColor : 'rgba(0, 0, 0, 0.5)'
								}
							}
						} ]
					};

					// 使用刚指定的配置项和数据显示图表。
					pie.setOption(option);
				</script>
			</div>



			<!-- end col-->
		</div>
		</c:if>

		<div class="row">
			<div class="col-sm-6">
				<div class="card-box" id="card_contract_audit">
					<h4 class="header-title m-t-0 m-b-30">合同订单待办</h4>
					<table class="table m-0">
						<thead>
							<tr>
								<th width="20%">合同ID</th>
								<th>项目名称</th>
								<th width="15%">类别</th>

							</tr>
						</thead>
						<tbody>
							<c:forEach items="${contract_audit_list}" var="contract_audit"
								varStatus="p">
								<c:set var="task" value="${contract_audit.task}" />
								<c:set var="vars" value="${contract_audit.vars}" />
								<c:set var="procDef" value="${contract_audit.procDef}" />
								<c:set var="status" value="${contract_audit.status}" />
								<tr>
									<th scope="row">${p.index + 1}</th>
									<td><a
										href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 60)}</a>
									</td>
									<td><span class="label label-danger">${task.name}</span></td>
								</tr>
							</c:forEach>

						</tbody>
					</table>
				</div>
			</div>
			<c:if test="${roleType ne '3' and roleType ne '4'}">
			<div class="col-sm-6"">
				<div class="card-box id="card_po_audit">
					<h4 class="header-title m-t-0 m-b-30">采购订单待办</h4>
					<table class="table m-0">
						<thead>
							<tr>
								<th width="20%">合同ID</th>
								<th>项目名称</th>
								<th width="15%">类别</th>

							</tr>
						</thead>
						<tbody>
							<c:forEach items="${po_audit_list}" var="po_audit" varStatus="p">
								<c:set var="task" value="${po_audit.task}" />
								<c:set var="vars" value="${po_audit.vars}" />
								<c:set var="procDef" value="${po_audit.procDef}" />
								<c:set var="status" value="${po_audit.status}" />
								<tr>
									<th scope="row">${p.index + 1}</th>
									<td><a
										href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 60)}</a>
									</td>
									<td><span class="label label-danger">${task.name}</span></td>
								</tr>
							</c:forEach>

						</tbody>
					</table>
				</div>
			</div>
			</c:if>
		</div>
	</div>



</body>
</html>