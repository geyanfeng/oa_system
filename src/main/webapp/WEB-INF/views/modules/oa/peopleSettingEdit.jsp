<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>人员参数 -- 编辑</title>
<meta name="decorator" content="default" />
<style>
.table th, .table td {
	text-align: center;
}
</style>
</head>
<body>
	<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">人员参数 -- 编辑</h2>
	<form:form id="inputForm" modelAttribute="setting"
		action="${ctx}/oa/peoplesetting/save" method="post" role="form">
		<div class="panel panel-default">
			<div class="panel-body">
				<div class="row">

					<table id="contentTable" class="table table-striped m-0">
						<thead>
							<tr>
								<th class="hidden"></th>
								<th>销售</th>
								<th>商务</th>
								<th>技术</th>
								 <th>Q1指标</th>
                        <th>Q2指标</th>
                        <th>Q3指标</th>
                        <th>Q4指标</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${list}" var="peopleSetting"
								varStatus="settingIdx">
								<tr>
									<td class="hidden"><input
										name="peopleSettingCollocations[${settingIdx.index}].id"
										value="${peopleSetting.id}" class="hidden"></td>
									<td><input
										name="peopleSettingCollocations[${settingIdx.index}].saler"
										value="${peopleSetting.saler.id}" class="hidden">
										${peopleSetting.saler.name}</td>
									<td><select
										name="peopleSettingCollocations[${settingIdx.index}].businessPerson"
										data-value="${peopleSetting.businessPerson}"
										class="form-control input-block required input-sm"
										style="width: 150px;">
											<c:forEach items="${businessPeopleList}" var="dict">
												<option value="${dict.id}">${dict.name}</option>
											</c:forEach>
									</select></td>
									<td><select
										name="peopleSettingCollocations[${settingIdx.index}].artisan"
										data-value="${peopleSetting.artisan}"
										class="form-control input-block required input-sm"
										style="width: 150px;">
											<c:forEach items="${artisanList}" var="dict">
												<option value="${dict.id}">${dict.name}</option>
											</c:forEach>
									</select></td>
									<td><input
										name="peopleSettingCollocations[${settingIdx.index}].gpiQ1"
										value="${peopleSetting.gpiQ1}" class="text number required">
									</td>
									<td><input
										name="peopleSettingCollocations[${settingIdx.index}].gpiQ2"
										value="${peopleSetting.gpiQ2}" class="text number required">
									</td>
									<td><input
										name="peopleSettingCollocations[${settingIdx.index}].gpiQ3"
										value="${peopleSetting.gpiQ3}" class="text number required">
									</td>
									<td><input
										name="peopleSettingCollocations[${settingIdx.index}].gpiQ4"
										value="${peopleSetting.gpiQ4}" class="text number required">
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<br/>
				<div class="row text-center">

					<button id="btnEdit" type="submit"
						class="btn btn-custom"
						title="保存" data-content="保存">
						保存
					</button>

					<a id="btnReturn" href="#" onclick="history.go(-1)"
						class="btn btn-inverse"
						title="返回" data-content="返回">返回</a>
				</div>
			</div>
		</div>
	</form:form>
	<script>
		$(function() {
			$("select").each(function(){
				var self = $(this);
				if(!self.val() || self.val().length==0){
					self.find("option").first().prop("selected",true);
					self.trigger("change");
				}
			});
			/*$("select").each(function() {
				$(this).val($(this).attr("data-value")).trigger("change");
			});*/
		});
	</script>
</body>
</html>
