<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>合同管理</title>
<meta name="decorator" content="default" />
<style>
#payment-collapse .row .form-group {
	margin-left: 20px;
}

.row.form-inline {
	margin-bottom: 10px;
}

.row.form-inline .form-group {
	margin-left: 20px;
}
th,td{text-align:left;}
.table{margin-bottom:0px;}
.table tr th:nth-child(2),.table tr td:nth-child(2){
        	padding-left:20px;
        }
</style>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						//$("#name").focus();
						$("#inputForm")
								.validate(
										{
											rules : {
												name : {
													remote : "${ctx}/oa/contract/checkName?oldName="
															+ encodeURIComponent('${contract.name}')
												}
											},
											messages : {
												name : {
													remote : "合同名称已存在"
												}
											},
											submitHandler : function(form) {
												loading('正在提交，请稍等...');
												form.submit();
											},
											errorContainer : "#messageBox",
											errorPlacement : function(error,
													element) {
												$("#messageBox").text(
														"输入有误，请先更正。");
												if (element.is(":checkbox")
														|| element.is(":radio")
														|| element
																.parent()
																.is(
																		".input-append")) {
													error.appendTo(element
															.parent().parent());
												} else {
													error.insertAfter(element);
												}
											}
										});
						//changeContractType();//如果从合同列表中新合同时, 初始化时加载合同类型

						//更改发票类型时,显示或隐藏列
						//更改发票类型时,显示或隐藏列
						$('input[name=invoiceType]').change(function () {
							var sVal = $('input[name=invoiceType]:checked ').val();
							switch (sVal) {
								case "2":
									$("div[id^=field-invoice]").show();
									break;
								default:
									$("div[id^=field-invoice]").hide();
									break;
							}
						});
						$('input[name=invoiceType]').trigger('change');

						setCommonHideHandler();
					});

	function changeContractType() {
		var contractType_value = $('#contractType').val();
		/*  switch (contractType_value) {
		      case "1":
		          $('#card_other').hide();
		          $('#card_products').hide();
		          break;
		      default:
		          $('#card_other').show();
		          $('#card_products').show();
		          break;
		  }*/
		window.location.replace("${ctx}/oa/contract/form?contractType="
				+ contractType_value);
	}

	//更改客户
	function changeCustomer(sender) {
		var self = $(sender);
		$('#invoiceCustomerName').val(self.select2('data').text);
	}

	//增加客户
	function addCustomer(sender) {
		openModalFromUrl("新增客户", "${ctx}/oa/customer/form?fromModal=1", false);
	}

	//关闭增加
	function closeCustomerModal(customer){
		getCommonModal().modal('hide');
		$.get('${ctx}/oa/customer/treeData',function(data){
			$('#customer').children().remove();
			$("#customer").append("<option value='' selected='selected'></option>");
			$.each(data,function(idx, item){
				$("#customer").append("<option value='"+item.id+"'>"+item.name+"</option>");
			});
			if(customer && customer.id)
				$('#customer').val(customer.id).trigger("change");
		});
	}
</script>
</head>
<body>
	<%--<ul class="nav nav-tabs">
    <li><a href="${ctx}/oa/contract/">合同列表</a></li>
    <li class="active"><a href="${ctx}/oa/contract/form?id=${contract.id}">合同<shiro:hasPermission name="oa:contract:edit">${not empty contract.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:contract:edit">查看</shiro:lacksPermission></a></li>
</ul><br/>--%>

	<form:form id="inputForm" modelAttribute="contract"
		action="${ctx}/oa/contract/save" method="post" role="form"
		class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<sys:message content="${message}" />
		<div class="col-sm-12">
			<!--合同信息-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">
						合同信息
						<div class="pull-right">
							<a data-toggle="collapse" href="#card-collapse" class=""
								aria-expanded="true"><i class="zmdi zmdi-minus"></i></a>
						</div>
					</h3>
				</div>
				<div class="panel-body panel-collapse collapse in"
					id="card-collapse">
					<div class="row">
						<div class="col-sm-6">
							<div class="form-group">
								<label class="col-sm-3 control-label">合同类型 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<c:if test="${empty param.contractType}">
										<form:select path="contractType" class="form-control required"
											onchange="changeContractType()">
											<form:option value="" label="" />
											<form:options items="${fns:getDictList('oa_contract_type')}"
												itemLabel="label" itemValue="value" htmlEscape="false" />
										</form:select>
									</c:if>
									<c:if test="${not empty param.contractType}">
										<form:hidden path="contractType"></form:hidden>
										<span>${fns:getDictLabel(contract.contractType,"oa_contract_type" ,"" )}</span>
									</c:if>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group ">
								<label class="col-sm-3 control-label">客&nbsp;&nbsp;户 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<div class="input-group bootstrap-touchspin">
										<form:select path="customer.id"
											class="form-control required col-sm-9" id="customer"
											onchange="changeCustomer(this)">
											<form:option value="" label="" />
											<form:options items="${customerList}" itemLabel="name"
												itemValue="id" htmlEscape="false" />
										</form:select>
										<span class="input-group-btn"> <a href="javascript:void(0);"
											onclick="addCustomer(this)" title="新增客户"
											class="btn btn-custom">+</a></span>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="form-group ">
								<label class="col-sm-3 control-label">我司抬头 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<form:select path="companyName" class="form-control required">
										<form:option value="" label="" />
										<form:options items="${fns:getDictList('oa_company_name')}"
											itemLabel="label" itemValue="value" htmlEscape="false" />
									</form:select>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group ">
								<label class="col-sm-3 control-label">有效期  <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<div class="input-group bootstrap-touchspin">
										<input name="expiryDate" type="text" readonly="readonly"
											maxlength="20" class="form-control required"
											value="<fmt:formatDate value="${contract.expiryDate}" pattern="yyyy-MM-dd"/>"
											onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
										<span class="input-group-addon bg-custom b-0 text-white"><i
											class="ti-calendar"></i></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>


			<!--开票信息-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">开票信息
					<div class="pull-right">
						<a data-toggle="collapse" href="#invoice-collapse" class=""
							aria-expanded="true"><i class="zmdi zmdi-minus"></i></a>
					</div>
					</h3>
				</div>
				<div class="panel-body form-horizontal" id="invoice-collapse">
					<div class="col-sm-9">
						<div class="form-group clearfix">
							<label class="col-sm-3 control-label">发票类型 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-9">
								<form:radiobuttons path="invoiceType"
									items="${fns:getDictList('oa_invoice_type')}" itemLabel="label"
									itemValue="value" htmlEscape="false" class=""
									element="span class='radio radio-custom radio-inline'" />
							</div>
						</div>
						<div class="form-group clearfix">
							<label class="col-sm-3 control-label">发票抬头<span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceCustomerName" htmlEscape="false"
									maxlength="255" class="form-control required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceNo">
							<label class="col-sm-3 control-label">发票税务登记号 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceNo" htmlEscape="false" maxlength="255"
									class="form-control required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceBank">
							<label class="col-sm-3 control-label">开户行 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceBank" htmlEscape="false"
									maxlength="255" class="form-control required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceBankNo">
							<label class="col-sm-3 control-label">银行帐号 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceBankNo" htmlEscape="false"
									maxlength="255" class="form-control required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceAddress">
							<label class="col-sm-3 control-label">地址 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceAddress" htmlEscape="false"
									maxlength="1000" class="form-control required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoicePhone">
							<label class="col-sm-3 control-label">电话 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoicePhone" htmlEscape="false"
									maxlength="100" class="form-control required" />
							</div>
						</div>

					</div>
				</div>
			</div>

			<!--附件-->
			<div class="panel panel-default" id="card_attachemnts">
				<div class="panel-heading"><h3 class="panel-title">附件</h3></div>
				<div class="panel-body" style="padding:20px 0 0;">
					<table id="attchmentTable"
						class="table table-striped table-condensed">
						<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th style="padding-left:20px;">附件类型</th>
								<th style="padding-left:30px;">文件名</th>
								<th style="text-align:center;">创建时间</th>
							</tr>
						</thead>
						<tbody id="attchmentList">
							<c:forEach items="${contract.contractAttachmentList}"
								var="attachment" varStatus="status">
								<tr row="row">
									<td class="hidden"><input
										id="contractAttachmentList${status.index}_id"
										name="contractAttachmentList[${status.index}].id"
										type="hidden" value="${attachment.id}" /></td>
									<td>${fns:getDictLabel(attachment.type, 'oa_contract_attachment_type', '')}
										<a href="javascript:void(0);" title="上传文档" class="fa fa-cloud-upload text-custom" style="margin-left:10px;font-size:18px;"
										onclick="files${status.index}FinderOpen();"></a> <input
										id="contractAttachmentList${status.index}_type"
										name="contractAttachmentList[${status.index}].type"
										type="hidden" value="${attachment.type}" />
									</td>
									<td><form:hidden id="files${status.index}"
											path="contractAttachmentList[${status.index}].files"
											htmlEscape="false" maxlength="2000" class="form-control" />
										<sys:myckfinder input="files${status.index}" type="files"
											uploadPath="/oa/contract" selectMultiple="true" /></td>
									<td><fmt:formatDate value="${attachment.updateDate}"
											pattern="yyyy-MM-dd" /></td>
								</tr>

							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>

			<!--备注-->
			<div class="panel panel-default" id="card_other">
				<div class="panel-heading"><h3 class="panel-title">备注</h3></div>
				<div class="panel-body">
					<div class="form-group clearfix">
						<div class="col-sm-12">
							<form:textarea path="remark" htmlEscape="false" maxlength="255"
								class="form-control" />
						</div>
					</div>
				</div>
			</div>

			<div class="form-group">
				<div class="text-center">
<input id="btnCancel" class="btn btn-inverse" type="button" value="返 回"
						onclick="history.go(-1)" />&nbsp;
					<shiro:hasPermission name="oa:contract:edit">
						<input id="btnSubmit"
							class="btn btn-info" type="submit"
							value="保 存" />&nbsp;
            </shiro:hasPermission>

					
				</div>
			</div>
		</div>
	</form:form>
</body>
</html>