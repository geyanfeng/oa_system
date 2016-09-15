<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title></title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/assets/plugins/echarts.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {

	});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
</head>
<body>
	<h2 style="padding-left: 20px; font-weight: normal; font-size: 18px;">${title}</h2>
	<div class="panel panel-default">
		<div class="panel-body">
			<form:form id="searchForm" modelAttribute="searchParams" method="post"
				class="breadcrumb form-search form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
					callback="page();" />
				<c:if test="${reportType eq '1' or reportType eq '2'}">
				<div class="form-group m-r-10">
					<label>日期：</label>
					<div class="input-group">
						<input name="startTime" type="text" readonly="readonly"
							maxlength="20" class="form-control" size="10"
							value="${searchParams.startTime}"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
					</div>
					<div class="input-group">
						<input name="endTime" type="text" readonly="readonly"
							maxlength="20" class="form-control" size="10"
							value="${searchParams.endTime}"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
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
									element="span class='checkbox checkbox-custom checkbox-inline'" />
			    
			    </div>
				<div class="form-group m-r-10">
					<label>时间：</label>
					<div class="input-group">
						<input name="startTime" type="text" readonly="readonly"
							maxlength="20" class="form-control" size="10"
							value="${searchParams.startTime}"
							onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
					</div>
					<div class="input-group">
						<input name="endTime" type="text" readonly="readonly"
							maxlength="20" class="form-control" size="10"
							value="${searchParams.endTime}"
							onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
					</div>
				</div>
				</c:if>
			   <c:choose>
					<c:when test="${reportType eq '1'}">
					<div class="form-group m-r-10">
				<label>供应商：</label>

				<form:select path="supplierId" class="select2-container form-control" id="supplierId" cssStyle="width:200px;">
					<form:option value="" label=""/>
					<form:options items="${supplierList}" itemLabel="name"
								  itemValue="id" htmlEscape="false"/>
				</form:select>
			   </div>
					</c:when>
					<c:when test="${reportType eq '2' or reportType eq '3'}">
					<div class="form-group m-r-10">
				<label>客户：</label>

				<form:select path="customerId" class="select2-container form-control" id="customerId" cssStyle="width:200px;">
					<form:option value="" label=""/>
					<form:options items="${customerList}" itemLabel="name"
								  itemValue="id" htmlEscape="false"/>
				</form:select>
			   </div>
					</c:when>
				</c:choose>
				<div class="form-group m-r-10">
				<button id="btnSubmit" class="btn btn-custom" type="submit"
					value="查询">查&nbsp;&nbsp;询</button>

				</div>
			</form:form>
			<c:if test="${reportType eq '3'}">
			<div class="col-sm-8">
				<div class="card-box">

					<div id="website-stats" style="height: 320px;" class="flot-chart"></div>

				</div>
			</div>
			<script type="text/javascript">
			$(document).ready(function() {
				var chartData = ${fns:toJson(achievementList)};
				var xAxisData = new Array();
				var seriesGpi = new Array();
				var seriesGp = new Array();
				$.each(chartData, function(i, item){      
					xAxisData.push(item.year + "年" + item.quarter + "季度"); 
					seriesGpi.push(item.gpi);
					seriesGp.push(item.gp);
				});   
				var website_stats = echarts.init(document
						.getElementById('website-stats'));
				option = {
					title : {
						text : '业绩统计'
					},
					color : ['#dedede','#57c5a5'],
					tooltip : {
						trigger : 'axis'
					},
					legend : {
						data : [ '毛利指标', '完成毛利' ]
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
						data : xAxisData
					} ],
					yAxis : [ {
						name: '金额',
						type : 'value'
					} ],
					series : [ {
						name : '毛利指标',
						type : 'line',
						stack : '金额',
						areaStyle : {
							normal : {}
						},
						 label: {
				                normal: {
				                    show: true,
				                    position: 'top'
				                }
				            },
						data : seriesGpi
					}, {
						name : '完成毛利',
						type : 'line',
						stack : '金额',
						areaStyle : {
							normal : {}
						},
						   label: {
				                normal: {
				                    show: true,
				                    position: 'top'
				                }
				            },
						data : seriesGp
					} ]
				};
				website_stats.setOption(option);
			});
				
			</script>
			</c:if>
			<sys:message content="${message}" />
			<table id="contentTable" class="table table-striped m-0">
				<thead>
					<tr>
						<c:forEach items="${headers}" var="headers">
						<th>${headers.value}</th>
					   </c:forEach>					
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${page.list}" var="supplier">
						<tr>
							<c:forEach items="${headers}" var="headers">
						     <td>${supplier[headers.key]}</td>
					 	   </c:forEach>		
						</tr>
					</c:forEach>
				</tbody>
			</table>
			${page}
		</div>
	</div>
</body>
</html>