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
		<div class="row">
			<div class="col-sm-12">
				<div class="card-box">
					<div id="total" style="height: 320px;" class="flot-chart"></div>
				</div>
			</div>
		</div>

		<script type="text/javascript">
			var total = echarts.init(document.getElementById('total'));
			option = {
				tooltip : {
					formatter : "{a} <br/>{c} {b}"
				},
				toolbox : {
					show : true,
					feature : {
						restore : {
							show : true
						},
						saveAsImage : {
							show : true
						}
					}
				},
				series : [ {
					name : '速度',
					type : 'gauge',
					z : 3,
					min : 0,
					max : 220,
					splitNumber : 11,
					radius : '50%',
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
						value : 40,
						name : 'km/h'
					} ]
				}, {
					name : '转速',
					type : 'gauge',
					center : [ '20%', '55%' ], // 默认全局居中
					radius : '35%',
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
						name : 'x1000 r/min'
					} ]
				}, {
					name : '油表',
					type : 'gauge',
					center : [ '77%', '50%' ], // 默认全局居中
					radius : '25%',
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
								return 'E';
							case '1':
								return 'Gas';
							case '2':
								return 'F';
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
					name : '水表',
					type : 'gauge',
					center : [ '77%', '50%' ], // 默认全局居中
					radius : '25%',
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
								return 'H';
							case '1':
								return 'Water';
							case '2':
								return 'C';
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
				} ]
			};
			total.setOption(option);
		</script>
		<div class="row">
			<div class="col-sm-6">
				<div class="card-box">

					<div id="website-stats" style="height: 320px;" class="flot-chart"></div>

				</div>
			</div>
			<script type="text/javascript">
				var website_stats = echarts.init(document
						.getElementById('website-stats'));
				option = {
					title : {
						text : '来单情况'
					},
					tooltip : {
						trigger : 'axis'
					},
					legend : {
						data : [ '邮件营销', '联盟广告', '视频广告' ]
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
						data : [ '周一', '周二', '周三', '周四', '周五', '周六', '周日' ]
					} ],
					yAxis : [ {
						type : 'value'
					} ],
					series : [ {
						name : '邮件营销',
						type : 'line',
						stack : '总量',
						areaStyle : {
							normal : {}
						},
						data : [ 120, 132, 101, 134, 90, 230, 210 ]
					}, {
						name : '联盟广告',
						type : 'line',
						stack : '总量',
						areaStyle : {
							normal : {}
						},
						data : [ 220, 182, 191, 234, 290, 330, 310 ]
					}, {
						name : '视频广告',
						type : 'line',
						stack : '总量',
						areaStyle : {
							normal : {}
						},
						data : [ 150, 232, 201, 154, 190, 330, 410 ]
					} ]
				};
				website_stats.setOption(option);
			</script>

			<div class="col-sm-6">
				<div class="card-box">
					<div id="pie-chart-container" style="height: 320px;"
						class="flot-chart"></div>
				</div>
			</div>
			<!-- end col-->
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
				legend : {
					orient : 'vertical',
					left : 'right',
					data : [ '直接访问', '邮件营销', '联盟广告', '视频广告', '搜索引擎' ]
				},
				series : [ {
					name : '访问来源',
					type : 'pie',
					radius : '55%',
					center : [ '50%', '60%' ],
					data : [ {
						value : 335,
						name : '直接访问'
					}, {
						value : 310,
						name : '邮件营销'
					}, {
						value : 234,
						name : '联盟广告'
					}, {
						value : 135,
						name : '视频广告'
					}, {
						value : 1548,
						name : '搜索引擎'
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

		<div class="row">
			<div class="col-sm-6">
				<div class="card-box">

					<div id="income-stats" style="height: 320px;" class="flot-chart"></div>

				</div>
			</div>
			<script type="text/javascript">
				var income_stats = echarts.init(document
						.getElementById('income-stats'));
				option = {
					title : {
						text : '应收实收情况'
					},
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
						data : [ '巴西', '印尼', '美国', '印度', '中国', '世界人口(万)' ]
					},
					series : [ {
						name : '2011年',
						type : 'bar',
						data : [ 18203, 23489, 29034, 104970, 131744, 630230 ]
					}, {
						name : '2012年',
						type : 'bar',
						data : [ 19325, 23438, 31000, 121594, 134141, 681807 ]
					} ]
				};
				income_stats.setOption(option);
			</script>

			<div class="col-sm-6">
				<div class="card-box">
					<div id="product" style="height: 320px;" class="flot-chart"></div>
				</div>
			</div>
			<!-- end col-->
		</div>
		<script type="text/javascript">
			// 基于准备好的dom，初始化echarts实例
			var product = echarts.init(document.getElementById('product'));

			option = {
				title : {
					text : '当季度合同状态',
					x : 'left'
				},
				tooltip : {
					trigger : 'item',
					formatter : "{a} <br/>{b}: {c} ({d}%)"
				},
				legend : {
					orient : 'vertical',
					x : 'right',
					data : [ '直接访问', '邮件营销', '联盟广告', '视频广告', '搜索引擎' ]
				},
				series : [ {
					name : '访问来源',
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
						name : '直接访问'
					}, {
						value : 310,
						name : '邮件营销'
					}, {
						value : 234,
						name : '联盟广告'
					}, {
						value : 135,
						name : '视频广告'
					}, {
						value : 1548,
						name : '搜索引擎'
					} ]
				} ]
			};

			product.setOption(option);
		</script>

		<div class="row">
			<div class="col-sm-6">
				<div class="card-box" id="card_contract_audit">
					<h4 class="header-title m-t-0 m-b-30">合同订单待办</h4>
					<table class="table m-0">
						<thead>
							<tr>
								<th width="5%">#</th>
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
									<td><a class="btn btn-primary btn-sm" target="_blank"
										href="${ctx}/act/task/trace/photo/${task.processDefinitionId}/${task.executionId}">${task.name}</a>
									</td>
								</tr>
							</c:forEach>

						</tbody>
					</table>
				</div>
			</div>
			<div class="col-sm-6"">
				<div class="card-box id="card_po_audit">
					<h4 class="header-title m-t-0 m-b-30">采购订单待办</h4>
					<table class="table m-0">
						<thead>
							<tr>
								<th width="5%">#</th>
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
									<td><a class="btn btn-primary btn-sm" target="_blank"
										href="${pageContext.request.contextPath}/act/rest/diagram-viewer?processDefinitionId=${task.processDefinitionId}&processInstanceId=${task.processInstanceId}">${task.name}</a>
									</td>
								</tr>
							</c:forEach>

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>



</body>
</html>
