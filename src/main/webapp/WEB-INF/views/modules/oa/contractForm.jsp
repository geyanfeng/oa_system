<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
	<meta name="decorator" content="default"/>

	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules: {
					name: {remote: "${ctx}/oa/contract/checkName?oldName=" + encodeURIComponent('${contract.name}')}
				},
				messages: {
					name: {remote: "合同名称已存在"}
				},
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			changeContractType();//如果从合同列表中新合同时, 初始化时加载合同类型

			$("#btnTest").click(function(){
				var frameSrc = "${ctx}/oa/contract/list?contractType=1&isSelect=true";
				$("#iframe-contract-list").attr("src", frameSrc);
				$('#modal-contract-list').modal({ show: true, backdrop: 'static' });
			});

			//更改发票类型时,显示或隐藏列
			$('input[name=invoiceType]').change(function(){
				var sVal = $('input[name=invoiceType]:checked ').val();
				switch (sVal){
					case "1":
						$("div[id^=field-invoice]").hide();
						break;
					default:
						$("div[id^=field-invoice]").show();
						break;
				}
			});
			$('input[name=invoiceType]').trigger('change');
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}

		function changeContractType(){
			var contractType_value = $('#contractType').val();
			switch (contractType_value){
				case "1":
						$('#card_other').hide();
						$('#card_products').hide();
					break;
				default:
					$('#card_other').show();
					$('#card_products').show();
					break;
			}
		}

		//更新表格中的金额, 同时更新合同总金额
		function updatePriceAmount(sender) {
			var row = $(sender).closest('tr');
			//var price = $("#contentTable input[id$=row + '_price']").val();
			var price = row.find("input[id$='_price']").val();
			var num = row.find("input[id$='_num']").val();
			if (price && num) {
				row.find("input[id$='_amount']").val(price * num);
			}

			//更新合同总金额
			updateAmount();
		}

		//更新合同总金额
		function updateAmount(){
			var amount = 0;
			var rowCount = $("#contentTable tbody tr").length;
			if(rowCount>0){
				var priceFields = $("#contentTable tbody tr input[id$='_price");
				var numFields = $("#contentTable tbody tr input[id$='_num");
				for(var i=0;i<rowCount;i++){
					amount += ($(priceFields[i]).val() * $(numFields[i]).val())
				}
				$("#amount").val(amount);
			}
		}

		//关闭框架合同选择框,并设置相关的值
		function closeSelectContractModal(selectedContract){
			$('#modal-contract-list').modal('hide');
			setSelectedContract(selectedContract);
		}

		//选中框架合同后,设置相关值
		function setSelectedContract(contract){
			$('#customer').val(contract.customer.id).trigger("change");
			$("input[name=invoiceType][value="+ contract.invoiceType +"]").attr("checked",true);
			$("#invoiceCustomerName").val(contract.invoiceCustomerName);
			$("#invoiceNo").val(contract.invoiceNo);
			$("#invoiceBank").val(contract.invoiceBank);
			$("#invoiceBankNo").val(contract.invoiceBankNo);
			$("#invoiceAddress").val(contract.invoiceAddress);
			$("#invoicePhone").val(contract.invoicePhone);
			$('#companyName').val(contract.companyName).trigger("change");

			$("input[name=paymentMethod][value="+ contract.paymentMethod +"]").attr("checked",true);
			$('#paymentCycle').val(contract.paymentCycle).trigger("change");
			$('input[name=paymentTime]').val(contract.paymentTime);
			$("#paymentAmount").val(contract.paymentAmount);
		}

		//更改客户
		function changeCustomer(sender){
			var self = $(sender);
			$('#invoiceCustomerName').val(self.select2('data').text);
		}
	</script>
</head>
<body>
	<%--<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/contract/">合同列表</a></li>
		<li class="active"><a href="${ctx}/oa/contract/form?id=${contract.id}">合同<shiro:hasPermission name="oa:contract:edit">${not empty contract.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:contract:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>--%>

	<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="col-sm-12">
			<div class="card-box" name="card_info">
				<h4 class="header-title m-t-0 m-b-30">合同信息
					<a class="btn btn-custom waves-effect waves-light" data-toggle="modal" data-target="#con-close-modal" id="btnTest">选择框架合同</a>
				</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">合同号：</label>
							<div class="col-sm-7">
								<form:input path="no" htmlEscape="false" maxlength="100" class="form-control required"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">合同类型：</label>
							<div class="col-sm-7">
								<form:select path="contractType" class="form-control col-md-12 required" onchange="changeContractType()">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_contract_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">商务人员：</label>
							<div class="col-sm-7">
								<sys:treeselect id="business_person" name="business_person.id"
												value="${contract.business_person.id}" labelName="business_person.name"
												labelValue="${contract.business_person.name}"
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control "
												allowClear="true" notAllowSelectParent="true"/>
							</div>
						</div>

					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">合同名称：</label>
							<div class="col-sm-7">
								<form:input path="name" htmlEscape="false" maxlength="255"
											class="form-control required"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">客户：</label>
							<div class="col-sm-7">
								<form:select path="customer.id" class="form-control col-md-12 required" id="customer" onchange="changeCustomer(this)">
									<form:option value="" label=""/>
									<form:options items="${customerList}" itemLabel="name"
												  itemValue="id" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">技术人员：</label>
							<div class="col-sm-7">
								<sys:treeselect id="artisan" name="artisan.id" value="${contract.artisan.id}"
												labelName="artisan.name" labelValue="${contract.artisan.name}"
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control "
												allowClear="true" notAllowSelectParent="true"/>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="card-box">
				<h4 class="header-title m-t-0 m-b-30">开票信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">发票类型：</label>
							<div class="col-sm-7">
								<form:radiobuttons path="invoiceType" items="${fns:getDictList('oa_invoice_type')}"
												   itemLabel="label" itemValue="value" htmlEscape="false" class=""
												   element="span class='radio radio-success col-sm-4'"/>
							</div>
						</div>
						<div class="form-group" id="field-invoiceCustomerName">
							<label class="col-sm-3 control-label">发票客户名称：</label>
							<div class="col-sm-7">
								<form:input path="invoiceCustomerName" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group" id="field-invoiceNo">
							<label class="col-sm-3 control-label">发票税务登记号：</label>
							<div class="col-sm-7">
								<form:input path="invoiceNo" htmlEscape="false" maxlength="255" class="form-control "/>
							</div>
						</div>
						<div class="form-group" id="field-invoiceBank">
							<label class="col-sm-3 control-label">开户行：</label>
							<div class="col-sm-7">
								<form:input path="invoiceBank" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group" id="field-invoiceBankNo">
							<label class="col-sm-3 control-label">银行帐号：</label>
							<div class="col-sm-7">
								<form:input path="invoiceBankNo" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group" id="field-invoiceAddress">
							<label class="col-sm-3 control-label">地址：</label>
							<div class="col-sm-7">
								<form:input path="invoiceAddress" htmlEscape="false" maxlength="1000"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group" id="filed-invoicePhone">
							<label class="col-sm-3 control-label">电话：</label>
							<div class="col-sm-7">
								<form:input path="invoicePhone" htmlEscape="false" maxlength="100"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">公司抬头：</label>
							<div class="col-sm-7">
								<form:select path="companyName" class="form-control col-md-12 required">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_company_name')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="card-box">
				<h4 class="header-title m-t-0 m-b-30">付款信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">付款方式：</label>
							<div class="col-sm-7">
								<form:radiobuttons path="paymentMethod" items="${fns:getDictList('oa_payment_method')}"
												   itemLabel="label" itemValue="value" htmlEscape="false" class=""
												   element="span class='radio radio-success col-sm-4'"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">付款周期类型：</label>
							<div class="col-sm-7">
								<form:select path="paymentCycle" class="form-control col-md-12 ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_payment_cycle')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">付款时间：</label>
							<div class="col-sm-7">
								<input name="paymentTime" type="text" readonly="readonly" maxlength="20"
									   class="form-control Wdate "
									   value="<fmt:formatDate value="${contract.paymentTime}" pattern="yyyy-MM-dd"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">付款金额：</label>
							<div class="col-sm-7">
								<form:input path="paymentAmount" htmlEscape="false" class="form-control  number"/>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="card-box" id="card_other" name="card_other">
				<h4 class="header-title m-t-0 m-b-30">其它</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">客户费用：</label>
							<div class="col-sm-7">
								<form:input path="customerCost" htmlEscape="false" class="form-control  number"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label"></label>
							<div class="col-md-4">
								<form:checkbox path="isDeduction" label="是否业绩抵扣"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">抵扣金额：</label>
							<div class="col-sm-7">
								<form:input path="discount" htmlEscape="false" class="form-control  number"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">有效期：</label>
							<div class="col-sm-7">
								<input name="expiryDate" type="text" readonly="readonly" maxlength="20"
									   class="form-control Wdate "
									   value="<fmt:formatDate value="${contract.expiryDate}" pattern="yyyy-MM-dd"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-3 control-label">发货地址类型：</label>
							<div class="col-sm-7">
								<form:select path="shipAddressType" class="form-control col-md-12 ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_ship_address_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">发货地址：</label>
							<div class="col-sm-7">
								<form:input path="shipAddress" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">备注：</label>
							<div class="col-sm-7">
								<form:textarea path="remark" htmlEscape="false" maxlength="255"
											class="form-control"/>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--合同产品明细表-->
			<div class="card-box" id="card_products">
				<h4 class="header-title m-t-0 m-b-30">合同产品明细表</h4>
				<shiro:hasPermission name="oa:contract:edit">
					<div class="pull-right">
						<a href="javascript:"
						   onclick="addRow('#contractProductList', contractProductRowIdx, contractProductTpl);contractProductRowIdx = contractProductRowIdx + 1;"
						   class="btn btn-primary waves-effect waves-light m-b-5">新增<i class="fa fa-plus"></i></a>
					</div>
				</shiro:hasPermission>
				<div class="row">
					<div class="col-sm-12">
						<table id="contentTable" class="table table-striped table-bordered table-condensed">
							<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>名称</th>
								<th>价格</th>
								<th>数量</th>
								<th>单位</th>
								<th>金额</th>
								<th>备注</th>
								<shiro:hasPermission name="oa:contract:edit">
									<th width="10">&nbsp;</th>
								</shiro:hasPermission>
							</tr>
							</thead>
							<tbody id="contractProductList">
							</tbody>

						</table>
						<script type="text/template" id="contractProductTpl">//<!--
						<tr id="contractProductList{{idx}}" row="row">
							<td class="hidden">
								<input id="contractProductList{{idx}}_id" name="contractProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="contractProductList{{idx}}_delFlag" name="contractProductList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_name" name="contractProductList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="form-control input-block required"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_price" name="contractProductList[{{idx}}].price" type="text" value="{{row.price}}" class="form-control input-block" onchange="updatePriceAmount(this);"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_num" name="contractProductList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control input-block" onchange="updatePriceAmount(this);"//>
							</td>
							<td>
								<select id="contractProductList{{idx}}_unit" name="contractProductList[{{idx}}].unit" data-value="{{row.unit}}" class="form-control input-block">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('oa_unit')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="contractProductList{{idx}}_amount" name="contractProductList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-block"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_remark" name="contractProductList[{{idx}}].remark" type="text" value="{{row.remark}}" maxlength="255" class="form-control input-block"/>
							</td>
							<shiro:hasPermission name="oa:contract:edit"><td class="text-center" width="10">
								{{#delBtn}}<a href="#" class="on-default remove-row" onclick="delRow(this, '#contractProductList{{idx}}')"  title="删除"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
						</script>
						<script type="text/javascript">
							var contractProductRowIdx = 0, contractProductTpl = $("#contractProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
							$(document).ready(function () {
								var data = ${fns:toJson(contract.contractProductList)};
								for (var i = 0; i < data.length; i++) {
									addRow('#contractProductList', contractProductRowIdx, contractProductTpl, data[i]);
									contractProductRowIdx = contractProductRowIdx + 1;
								}
							});
						</script>
					</div>
				</div>
			</div>

			<!--附件-->
			<div class="card-box" id="card_attachemnts">
				<h4 class="header-title m-t-0 m-b-30">附件</h4>
				<div class="row">
					<div class="col-sm-12">
						<table id="attchmentTable" class="table table-striped table-bordered table-condensed">
							<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>附件类型</th>
								<th>文件名</th>
								<th>创建时间</th>
							</tr>
							</thead>
							<tbody id="attchmentList">
								<c:forEach items="${contract.contractAttachmentList}" var="attachment" varStatus="status">
									<tr row="row">
										<td class="hidden">
											<input id="contractAttachmentList${status.index}_id" name="contractAttachmentList[${status.index}].id" type="hidden" value="${attachment.id}"/>
										</td>
										<td>
											${fns:getDictLabel(attachment.type, 'oa_contract_attachment_type', '')}
											<a href="#" class="zmdi zmdi-upload" onclick="files${status.index}FinderOpen();"></a>
											<input id="contractAttachmentList${status.index}_type" name="contractAttachmentList[${status.index}].type" type="hidden" value="${attachment.type}"/>
										</td>
										<td>
											<form:hidden id="files${status.index}" path="contractAttachmentList[${status.index}].files" htmlEscape="false" maxlength="2000" class="form-control"/>
											<sys:myckfinder input="files${status.index}" type="files" uploadPath="/oa/contract" selectMultiple="true"/>
										</td>
										<td>
											<fmt:formatDate value="${attachment.updateDate}" pattern="yyyy-MM-dd"/>
										</td>
									</tr>

								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="form-group">
			<label class="col-sm-3 control-label">合同金额：</label>
			<div class="col-sm-7">
				<form:input path="amount" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>

		<div class="form-group hidden">
			<label class="col-sm-3 control-label">合同状态：</label>
			<div class="col-sm-7">
				<form:select path="status" class="form-control col-md-12 ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('oa_contract_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>

		<div class="form-actions">
			<shiro:hasPermission name="oa:contract:edit"><input id="btnSubmit" class="btn btn-custom" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

	<%--选择框架合同的modal--%>
	<div id="modal-contract-list" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
		<div class="modal-dialog modal-full">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">选择框架合同</h4>
				</div>
				<div class="modal-body">
					<div class="row">
							<iframe id="iframe-contract-list" width="100%" height="500" frameborder="0"></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>