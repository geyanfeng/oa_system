<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>合同管理</title>
<meta name="decorator" content="default" />
<style>
.modal.fade.in {
	top: 10%
}
.form-inline .form-group {margin-bottom:15px;}
</style>
<script type="text/javascript">
	$(document).ready(
			function () {
				$("select").select2({ allowClear: true});

				$("#btnExport").click(
						function () {
							top.$.jBox.confirm("确认要导出合同列表吗？", "系统提示", function (v, h, f) {
								if (v == "ok") {
									$("#searchForm").attr("action",
											"${ctx}/oa/contract/export");
									$("#searchForm").submit();
								}
							}, {
								buttonsFocus: 1
							});
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
	
	//撤销合同
	function cancelContract(contractId) {
		var modal = $('#modal-cancelContract');
		modal.modal({
			show : true,
			backdrop : 'static'
		});
		modal.find("#btnSubmitCancel").data("contractId", contractId);
	}

	//撤回合同
	function recallContract(contractId) {
		var modal = $('#modal-recall');
		modal.modal({
			show : true,
			backdrop : 'static'
		});
		modal.find("#btnSubmitRecall").data("contractId", contractId);
	}

	function submitCancelContract(sender) {
		var contractId = $(sender).data("contractId"), isCopy = $("#copyFrom")
				.is(':checked') ? "true" : "false", cancelType = $(
				"#cancelType").val(), cancelReason = $("#cancelReason").val();
		var postData = {
			isCopy : isCopy,
			cancelType : cancelType,
			cancelReason : cancelReason
		};
		$.ajax({
			type : 'POST',
			url : "${ctx}/oa/contract/" + contractId + "/cancel",
			contentType : "application/json;",
			data : JSON.stringify(postData),
			success : function(msg) {
				var type = msg.indexOf("失败") > -1 ? "error" : "info";
				showTipMsg(msg, type);
				location.reload();
			},
			error : function(a) {
				showTipMsg("撤销合同失败", "error");
			}
		});

	}

	function submitRecall(sender) {
		var contractId = $(sender).data("contractId");
		var postData = {
			type : $("input[name='recall_type']:checked").val(),
			remark: $("#recall_remark").val()
		};
		$("#btnSubmitRecall").attr('disabled',"true");
		$.ajax({
			type : 'POST',
			url : "${ctx}/oa/contract/" + contractId + "/recallApprove",
			contentType : "application/json;",
			data : JSON.stringify(postData),
			success : function(msg) {
				var type = msg.indexOf("失败") > -1 ? "error" : "info";
				showTipMsg(msg, type);
				location.reload();
			},
			error : function(a) {
				showTipMsg("撤回合同失败", "error");
				$("#btnSubmitRecall").removeAttr("disabled");
			}
		});

	}
</script>
</head>
<body>
	<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">
		<c:choose>
			<c:when test="${contract.contractType eq '1'}">框架合同</c:when>
			<c:when test="${contract.contractType eq '2'}">客户合同</c:when>
			<c:when test="${contract.contractType eq '3'}">补充合同</c:when>
		</c:choose>
		<div class="pull-right">
			<c:if test="${empty isSelect}">
				<shiro:hasPermission name="oa:contract:edit">
					<a id="btnExport" class="btn btn-custom" type="button" title="导出">
						导出&nbsp;<i class="fa fa-download"></i>
					</a>
					</a>
					<a id="btnNew"
						href="${ctx}/oa/contract/form?contractType=${contract.contractType}"
						class="btn btn-primary" title="增加合同" data-content="新增"><i
						class="fa fa-plus"></i>&nbsp;增加合同</a>
				</shiro:hasPermission>
			</c:if>

		</div>
	</h2>
	<div class="panel panel-default">
		<div class="panel-body">
			<form:form id="searchForm" modelAttribute="contract"
				action="${ctx}/oa/contract/" method="post"
				class="breadcrumb form-search form-inline">
				<input id="pageNo" name="pageNo" type="hidden"
					value="${page.pageNo}" />
				<input id="pageSize" name="pageSize" type="hidden"
					value="${page.pageSize}" />
				<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
					callback="page();" />
				<!--过滤条件-->
				<div class="hidden">
					<input name="contractType" value="${contract.contractType}" /> <input
						name="isSelect" value="${isSelect}" />
				</div>


				<div class="form-group m-r-10">
					<label>客户：</label>

					<%-- <sys:treeselect id="customer" name="customer.id" value="${contract.customer.id}"
                                labelName="customer.name" labelValue="${contract.customer.name}"
                                title="客户" url="/oa/customer/treeData" cssClass="input-small input-sm"
                                allowClear="true" notAllowSelectParent="true" buttonIconCss="input-sm"/>
--%>
					<form:select path="customer.id" class="input-small" id="customer"
						cssStyle="width: 150px">
						<form:option value="" label="" />
						<form:options items="${customerList}" itemLabel="name"
							itemValue="id" htmlEscape="false" />
					</form:select>
				</div>

				<div class="form-group m-r-10">
					<label>销售：</label>
					<form:select path="createBy.id" class="input-small" id="createBy"
								 cssStyle="width: 150px">
						<form:option value="" label="" />
						<form:options items="${salerList}" itemLabel="name"
									  itemValue="id" htmlEscape="false" />
					</form:select>

				</div>

				<div class="form-group m-r-10" id="div-status">
					<label>合同状态：</label>
					<form:select path="status" class="select2-container form-control"
						cssStyle="width:150px;">
						<form:option value="" label="" />
						<form:options items="${fns:getDictList('oa_contract_status')}"
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
						<th class="sort-column no">合同号</th>
						<th class="sort-column a9.name">客户</th>
						<th class="sort-column name">合同名称</th>
						<th class="sort-column amount">合同金额</th>
						<th class="sort-column status">合同状态</th>
						<th class="sort-column u32.name">销售</th>
						<th class="sort-column u15.name">商务人员</th>
						<th class="sort-column u16.name">技术人员</th>
						<%-- <th>更新时间</th>--%>
						<shiro:hasPermission name="oa:contract:edit">
							<th>操作</th>
						</shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${page.list}" var="contract">
						<tr data-json='${fns:toJson(contract)}'>
							<td><fmt:formatDate value="${contract.createDate}"
									pattern="yyyy-MM-dd" /></td>

							<td>
								<c:choose><c:when test="${empty isSelect}">
									<a href="${ctx}/oa/contract/view?id=${contract.id}" target="mainFrame">${contract.no} </a>
								</c:when><c:otherwise>
									<a href="${ctx}/oa/contract/view?id=${contract.id}" target="blank">${contract.no} </a>
						  	    </c:otherwise></c:choose>
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


							<%--<td>
                            <fmt:formatDate value="${contract.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>--%>

							<td><shiro:hasPermission name="oa:contract:edit">
									<c:if test="${empty isSelect and contract.cancelFlag eq 0 and contract.status eq '0'}">
										<a href="${ctx}/oa/contract/form?id=${contract.id}" title="修改"><i
											class="fa fa-pencil"></i></a>
										<a href="${ctx}/oa/contract/delete?id=${contract.id}"
											onclick="return confirmx('确认要删除该合同吗？', this.href)" title="删除"><i
											class="fa fa-trash"></i></a>
									</c:if>
								</shiro:hasPermission>
								<c:if test="${contract.cancelFlag eq 0 and contract.status ne '0' and contract.status ne '100'}">
								<%--	<shiro:hasPermission name="oa:contract:cancel">
										<a href="#" onclick="cancelContract('${contract.id}');"
											title="撤销"><i class="fa fa-reply"></i></a>
									</shiro:hasPermission>--%>
								</c:if>
								<shiro:hasPermission name="oa:contract:view">
									<c:if test="${not empty isSelect}">
										<a href="#" onclick="selectContract(this);" title="选择"><i
											class="fa fa-check"></i></a>
									</c:if>
								</shiro:hasPermission>
								<c:if test="${contract.status ne '0' and contract.status ne '100' and contract.status ne '200'}">
									<shiro:hasPermission name="oa:contract:recall">
										<a href="#" onclick="recallContract('${contract.id}');"
										   title="撤回"><i class="fa fa-reply"></i></a>
									</shiro:hasPermission>
								</c:if>
							</td>

						</tr>
					</c:forEach>
				</tbody>
			</table>
			${page}
		</div>
	</div>

	<div id="modal-cancelContract" class="modal fade" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
		style="display: none;">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title">撤销合同</h4>
				</div>
				<div class="modal-body">
					<div class="form-horizontal">
						<div class="row">
							<div class="col-md-8 col-md-offset-4">
								<div class="form-group">
									<div class="checkbox checkbox-custom">
										<input id="copyFrom" type="checkbox" class="form-control">
										<label for="copyFrom">是否复制本合同 </label>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="col-md-3 control-label">撤销类型</label>
									<div class="col-md-8">
										<select class="form-control" id="cancelType">
											<c:forEach
												items="${fns:getDictList('oa_contract_cancel_type')}"
												var="cancelType">
												<option value="${cancelType.value}">${cancelType.label}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="col-md-3 control-label">撤销原因</label>
									<div class="col-md-8">
										<textarea id="cancelReason" class="form-control" rows="5"></textarea>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info waves-effect waves-light"
						id="btnSubmitCancel" onclick="submitCancelContract(this);">确定撤销</button>
					<button type="button" class="btn" data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
	</div>

	<div id="modal-recall" class="modal fade" tabindex="-1"
		 role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
		 style="display: none;">
		<div class="modal-dialog" style="width:400px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
					<h4 class="modal-title">撤回申请</h4>
				</div>
				<div class="modal-body">
						<div class="row">
							<div class="col-md-12 form-group">
								<span class="radio radio-custom radio-inline">
									<input id="recallType1" name="recall_type" type="radio"
											   value="1" checked>
										<label for="recallType1">合同撤销</label>
								</span>
								<span class="radio radio-custom radio-inline">
									<input id="recallType2" name="recall_type" type="radio"
											   value="2" checked>
										<label for="recallType1">合同修改</label>
								</span>
								</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="form-group">
									<label class="control-label">备注:</label>
									<textarea id="recall_remark" class="form-control" rows="5"></textarea>
								</div>
							</div>
						</div>
				</div>
				<div class="text-center">
					<button type="button" class="btn btn-inverse" data-dismiss="modal">返回</button>
					<button type="button" class="btn btn-custom"
							id="btnSubmitRecall" onclick="submitRecall(this);">提交</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>