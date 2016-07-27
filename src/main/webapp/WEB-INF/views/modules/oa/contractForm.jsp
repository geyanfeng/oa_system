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
			<div class="card-box">
				<h4 class="header-title m-t-0 m-b-30">合同信息</h4>
				<div class="row">
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">合同号：</label>
							<div class="col-md-4">
								<form:input path="no" htmlEscape="false" maxlength="100" class="form-control required"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">合同类型：</label>
							<div class="col-md-4">
								<form:select path="contractType" class="form-control col-md-12 required">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_contract_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">商务人员：</label>
							<div class="col-md-4">
								<sys:treeselect id="business_person" name="business_person.id"
												value="${contract.business_person.id}" labelName="business_person.name"
												labelValue="${contract.business_person.name}"
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control "
												allowClear="true" notAllowSelectParent="true"/>
							</div>
						</div>

					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">合同名称：</label>
							<div class="col-md-4">
								<form:input path="name" htmlEscape="false" maxlength="255"
											class="form-control required"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">客户：</label>
							<div class="col-md-4">
								<sys:treeselect id="customer" name="customer.id" value="${contract.customer.id}"
												labelName="customer.name" labelValue="${contract.customer.name}"
												title="客户" url="/oa/customer/treeData" cssClass="" allowClear="true"
												notAllowSelectParent="true"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">技术人员：</label>
							<div class="col-md-4">
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
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">发票类型：</label>
							<div class="col-md-4">
								<form:radiobuttons path="invoiceType" items="${fns:getDictList('oa_invoice_type')}"
												   itemLabel="label" itemValue="value" htmlEscape="false" class=""
												   element="span class='radio radio-success col-sm-4'"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">发票客户名称：</label>
							<div class="col-md-4">
								<form:input path="invoiceCustomerName" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">发票税务登记号：</label>
							<div class="col-md-4">
								<form:input path="invoiceNo" htmlEscape="false" maxlength="255" class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">开户行：</label>
							<div class="col-md-4">
								<form:input path="invoiceBank" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">银行帐号：</label>
							<div class="col-md-4">
								<form:input path="invoiceBankNo" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">地址：</label>
							<div class="col-md-4">
								<form:input path="invoiceAddress" htmlEscape="false" maxlength="1000"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">电话：</label>
							<div class="col-md-4">
								<form:input path="invoicePhone" htmlEscape="false" maxlength="100"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">公司抬头：</label>
							<div class="col-md-4">
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
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">付款方式：</label>
							<div class="col-md-4">
								<form:radiobuttons path="paymentMethod" items="${fns:getDictList('oa_payment_method')}"
												   itemLabel="label" itemValue="value" htmlEscape="false" class=""
												   element="span class='radio radio-success col-sm-4'"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">付款周期类型：</label>
							<div class="col-md-4">
								<form:select path="paymentCycle" class="form-control col-md-12 ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_payment_cycle')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">付款时间：</label>
							<div class="col-md-4">
								<input name="paymentTime" type="text" readonly="readonly" maxlength="20"
									   class="form-control Wdate "
									   value="<fmt:formatDate value="${contract.paymentTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">付款金额：</label>
							<div class="col-md-4">
								<form:input path="paymentAmount" htmlEscape="false" class="form-control  number"/>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="card-box">
				<h4 class="header-title m-t-0 m-b-30">其它</h4>
				<div class="row">
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">客户费用：</label>
							<div class="col-md-4">
								<form:input path="customerCost" htmlEscape="false" class="form-control  number"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">是否业绩抵扣：</label>
							<div class="col-md-4">
								<form:checkboxes path="isDeduction" items="${fns:getDictList('')}" itemLabel="label"
												 itemValue="value" htmlEscape="false" class="form-control required"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">抵扣金额：</label>
							<div class="col-md-4">
								<form:input path="discount" htmlEscape="false" class="form-control  number"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">有效期：</label>
							<div class="col-md-4">
								<input name="expiryDate" type="text" readonly="readonly" maxlength="20"
									   class="form-control Wdate "
									   value="<fmt:formatDate value="${contract.expiryDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
						</div>
					</div>
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">发货地址类型：</label>
							<div class="col-md-4">
								<form:select path="shipAddressType" class="form-control col-md-12 ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('oa_ship_address_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">发货地址：</label>
							<div class="col-md-4">
								<form:input path="shipAddress" htmlEscape="false" maxlength="255"
											class="form-control "/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">备注：</label>
							<div class="col-md-4">
								<form:input path="remark" htmlEscape="false" maxlength="255"
											class="form-control required"/>
								<span class="help-inline"><font color="red">*</font> </span>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-6">
						<div class="form-group">
							<label class="col-md-2 control-label">附件：</label>
							<div class="col-md-4">
								<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class="form-control"/>
								<sys:ckfinder input="files" type="files" uploadPath="/oa/contract" selectMultiple="true"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>



		<div class="form-group hidden">
			<label class="col-md-2 control-label">合同金额：</label>
			<div class="col-md-4">
				<form:input path="amount" htmlEscape="false" class="form-control  number"/>
			</div>
		</div>



		<div class="form-group hidden">
			<label class="col-md-2 control-label">合同状态：</label>
			<div class="col-md-4">
				<form:select path="status" class="form-control col-md-12 ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('oa_contract_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>


		<div class="card-box">
			<h4 class="header-title m-t-0 m-b-30">合同产品明细表</h4>
			<shiro:hasPermission name="oa:contract:edit">
				<div class="pull-right">
					<a href="javascript:"
					   onclick="addRow('#contractProductList', contractProductRowIdx, contractProductTpl);contractProductRowIdx = contractProductRowIdx + 1;"
					   class="btn btn-info waves-effect w-md waves-light m-b-5 ti-plus">新增</a>
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
								<input id="contractProductList{{idx}}_price" name="contractProductList[{{idx}}].price" type="text" value="{{row.price}}" class="form-control input-block"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_num" name="contractProductList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control input-block"/>
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
								{{#delBtn}}<span class="close" onclick="delRow(this, '#contractProductList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
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
		<div class="form-actions">
			<shiro:hasPermission name="oa:contract:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>