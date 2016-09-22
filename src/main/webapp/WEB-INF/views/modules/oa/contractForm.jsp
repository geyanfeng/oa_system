<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>合同管理</title>
	<meta name="decorator" content="default" />
	<script src="${ctxStatic}/assets/js/jquery.form.js"></script>
<style>
#payment-collapse .row .form-group {
	margin-left: 20px;
}

.row.form-inline .form-group {
	margin-left: 20px;
	margin-bottom:5px;
}

th,td{text-align:left;}
.table{margin-bottom:0px;}
.table tr th:nth-child(2),.table tr td:nth-child(2){
        	padding-left:20px;
        }
.table > tbody > tr > td{vertical-align:middle;}
.form-horizontal .radio label,.form-inline .radio label{
    line-height: 16px;
}
.form-horizontal .radio{
    padding-top:1px;
}
</style>
<script type="text/javascript">
        $(document).ready(function () {
            //增加定义付款金额验证规则
            $.validator.addMethod("validationPaymentAmount", function(value) {
                return validationPaymentAmount();
            }, "付款金额应该大于等于采购总金额:"+ $("#amount").val());

            $("#inputForm").validate({
                rules: {
                    name: {remote: "${ctx}/oa/contract/checkName?oldName=" + encodeURIComponent('${contract.name}')},
                    paymentCycle:  "validationPaymentAmount"
                },
                messages: {
                    name: {remote: "合同名称已存在"}
                },
                submitHandler: function (form) {
                	if($("#contractType").val() == "3" && $("#parentId").val() == ""){
                		showTipMsg("补充合同,父级合同不能为空","error");
                		return;
                	}
                    if(!validationPaymentAmount())
                            return;
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                },
				onfocusout: function(element){ $(element).valid(); }
            });
            //changeContractType();//如果从合同列表中新合同时, 初始化时加载合同类型

            $("#btnSelectParentContract").click(function () {
                var frameSrc = "${ctx}/oa/contract/contractSelectList?targetType=2";
				if($("#contractType").val() == "3")
					frameSrc = "${ctx}/oa/contract/contractSelectList?targetType=3";
				openModalFromUrl($("#contractType").val() == "3"?"选择框架合同和客户合同":"选择框架合同",frameSrc , true );
            });

            //更改是否业绩抵扣
            $("#isDeduction").change(function(){
                if($(this).prop('checked'))
                    $("#discount-group").show();
                else {
                    $("#discount").val("");
                    $("#discount-group").hide();
                }
            });
            $("#isDeduction").trigger('change');

			setCommonHideHandler();
        });

        function changeContractType() {
            var contractType_value = $('#contractType').val();
            /*switch (contractType_value) {
                case "1":
                    $('#card_other').hide();
                    $('#card_products').hide();
                    break;
                default:
                    $('#card_other').show();
                    $('#card_products').show();
                    break;
            }*/
            window.location.replace("${ctx}/oa/contract/form?contractType="+contractType_value);
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
        function updateAmount() {
            var amount = 0;
            var rowCount = $("#contentTable>tbody>tr[id^=contractProductList]").length;
            if (rowCount > 0) {
                var priceFields = $("#contentTable tbody tr input[id$='_price");
                var numFields = $("#contentTable tbody tr input[id$='_num");
                for (var i = 0; i < rowCount; i++) {
                    amount += ($(priceFields[i]).val() * $(numFields[i]).val())
                }
                $("#amount").val(amount);
				$("#span-display-amount").html("采购总金额: " + amount);
            }
        }

        //关闭框架合同选择框,并设置相关的值
        function closeSelectContractModal(selectedContract) {
			getCommonModal().modal('hide');
            setSelectedContract(selectedContract);
        }

        //选中框架合同后,设置相关值
        function setSelectedContract(contract) {
            $("#parentId").val(contract.id);
			if(contract.name)
            	$("#parentNo").val(contract.name + "(" + contract.no + ")");
			else
				$("#parentNo").val(contract.no);
            $('#customer').val(contract.customer.id).trigger("change");
            $("input[name=invoiceType][value=" + contract.invoiceType + "]").attr("checked", true);
            $("#invoiceCustomerName").val(contract.invoiceCustomerName);
            $("#invoiceNo").val(contract.invoiceNo);
            $("#invoiceBank").val(contract.invoiceBank);
            $("#invoiceBankNo").val(contract.invoiceBankNo);
            $("#invoiceAddress").val(contract.invoiceAddress);
            $("#invoicePhone").val(contract.invoicePhone);
            $('#companyName').val(contract.companyName).trigger("change");

            $("input[name=paymentMethod][value=" + contract.paymentMethod + "]").attr("checked", true);
            $('#paymentCycle').val(contract.paymentCycle).trigger("change");
            $('input[name=paymentTime]').val(contract.paymentTime);
            $("#paymentAmount").val(contract.paymentAmount);
        }

        //更改客户
        function changeCustomer(sender) {
            var self = $(sender);
            $('#invoiceCustomerName').val(self.select2('data').text);
        }

        //增加客户
        function addCustomer(sender){
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
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/oa/contract/importProduct" method="post" enctype="multipart/form-data">
			<input id="uploadFile" name="file" type="file" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"/><br/><br/>　　
		</form>
	</div>

	<form:form id="inputForm" modelAttribute="contract"
		action="${ctx}/oa/contract/save" method="post" role="form" class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="act.taskId" />
		<form:hidden path="act.taskName" />
		<form:hidden path="act.taskDefKey" />
		<form:hidden path="act.procInsId" />
		<form:hidden path="act.procDefId" />
		<form:hidden id="flag" path="act.flag" />
		<%--<input name="status" value="${empty contract.status?10:contract.status}" type="hidden"/>--%>
		<sys:message content="${message}" />

		<div class="col-sm-12">
			<!-- Page-Title -->
			<div class="navbar navbar-default navbar-fixed-top  navbar-static"
				role="navigation" id="navbar">
				<div class="collapse navbar-collapse bs-js-navbar-scrollspy">
					<ul class="nav navbar-nav">
						<li><a href="#panel-1">合同信息</a></li>
						<li><a href="#panel-2">开票信息</a></li>
						<li><a href="#panel-3">采购列表</a></li>
						<li><a href="#panel-9">订单列表</a></li>
						<li><a href="#panel-4">付款信息</a></li>
						<li><a href="#panel-5">物流信息</a></li>
						<li><a href="#panel-6">其它信息</a></li>
						<li><a href="#panel-7">附件</a></li>
						<li><a href="#panel-8">操作信息</a></li>
					</ul>
				</div>
			</div>

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
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">合同类型 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<c:if test="${empty param.contractType}">
										<form:select path="contractType"
											class="form-control col-md-12 required"
											onchange="changeContractType()">
											<form:option value="" label="" />
											<form:options items="${fns:getDictList('oa_contract_type')}"
												itemLabel="label" itemValue="value" htmlEscape="false" />
										</form:select>
									</c:if>
									<c:if test="${not empty param.contractType}">
										<form:hidden path="contractType"></form:hidden>
										<span style="line-height:32px;">${fns:getDictLabel(contract.contractType,"oa_contract_type" ,"" )}</span>
									</c:if>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">客户名称 <span
								class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<div class="input-group bootstrap-touchspin">
										<form:select path="customer.id"
											class="form-control col-md-12 required"
											id="customer" onchange="changeCustomer(this)">
											<form:option value="" label="" />
											<form:options items="${customerList}" itemLabel="name"
												itemValue="id" htmlEscape="false" />
										</form:select>

										<span class="input-group-btn"><a
											href="javascript:void(0);" onclick="addCustomer(this)" title="新增客户"
											class="btn btn-custom">+</a></span>
									</div>

								</div>

							</div>
						</div>

					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">我司抬头 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<form:select path="companyName"
										class="form-control col-md-12 required">
										<form:options items="${fns:getDictList('oa_company_name')}"
											itemLabel="label" itemValue="value" htmlEscape="false" />
									</form:select>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">合同名称 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<form:input path="name" htmlEscape="false" maxlength="255"
										class="form-control required" />
								</div>
							</div>
						</div>

					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">父级合同</label>
								<div class="col-sm-9">
									<div class="input-group">
										<input type="text" htmlEscape="false" maxlength="255"
											class="form-control required" id="parentNo" disabled
											value='${contract.parentName}${not empty contract.parentNo? "(":""}${contract.parentNo}${not empty contract.parentNo? ")":""}' />
										<input type="hidden" name="parentId" id="parentId"
											value="${contract.parentId}" class="hidden" /> <span
											class="input-group-btn"> <a
											id="btnSelectParentContract" href="javascript:" class="btn btn-custom"
											style=""> <i class="fa fa-search"></i>
													
										</a>
										</span>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">商务人员 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<%--<sys:treeselect id="business_person" name="businessPerson.id"
										value="${contract.businessPerson.id}"
										labelName="businessPerson.name"
										labelValue="${contract.businessPerson.name}" title="用户"
										url="/sys/office/treeData?type=3"
										cssClass="form-control required"
										buttonIconCss="" allowClear="true"
										notAllowSelectParent="true" />--%>
										<form:select path="businessPerson.id" id="business_person"
													 class="form-control col-md-12 required">
											<form:option value="" label="" />
											<form:options items="${businessPeopleList}"
														  itemLabel="name" itemValue="id" htmlEscape="false" />
										</form:select>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label">技术人员 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<%--<sys:treeselect id="artisan" name="artisan.id"
										value="${contract.artisan.id}" labelName="artisan.name"
										labelValue="${contract.artisan.name}" title="用户"
										url="/sys/office/treeData?type=3"
										cssClass="form-control required"
										buttonIconCss="" allowClear="true"
										notAllowSelectParent="true" />--%>
										<form:select path="artisan.id" id="artisan"
													 class="form-control col-md-12 required">
											<form:option value="" label="" />
											<form:options items="${artisanList}"
														  itemLabel="name" itemValue="id" htmlEscape="false" />
										</form:select>
								</div>
							</div>
						</div>

						<div class="col-sm-6">
							<div class="form-group clearfix">
								<label class="col-sm-3 control-label" for="no">合同号 <span
									class="help-inline"><font color="red">*</font> </span></label>
								<div class="col-sm-9">
									<input id="no" name="no" value="${contract.no}"
										htmlEscape="false" maxlength="100"
										class="form-control required" disabled />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!--开票信息-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">
						开票信息
						<div class="pull-right">
							<a data-toggle="collapse" href="#invoice-collapse" class=""
								aria-expanded="true"><i class="zmdi zmdi-minus"></i></a>
						</div>
					</h3>
				</div>
				<div class="panel-body collapse in" id="invoice-collapse">
					<div class="col-sm-9">
						<div class="form-group">
							<label class="col-sm-3 control-label">发票类型 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-9" style="padding-top:6px;">
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
									maxlength="255" class="form-control  required" />
							</div>
						</div>

						<div class="form-group clearfix" id="field-invoiceNo">
							<label class="col-sm-3 control-label">纳税人识别码 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceNo" htmlEscape="false" maxlength="255"
									class="form-control  required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceBank">
							<label class="col-sm-3 control-label">开户行 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceBank" htmlEscape="false"
									maxlength="255" class="form-control  required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceBankNo">
							<label class="col-sm-3 control-label">银行帐号 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceBankNo" htmlEscape="false"
									maxlength="255" class="form-control  required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoiceAddress">
							<label class="col-sm-3 control-label">地址 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoiceAddress" htmlEscape="false"
									maxlength="1000" class="form-control  required" />
							</div>
						</div>
						<div class="form-group clearfix" id="field-invoicePhone">
							<label class="col-sm-3 control-label">电话 <span
								class="help-inline"><font color="red">*</font> </span></label>
							<div class="col-sm-6">
								<form:input path="invoicePhone" htmlEscape="false"
									maxlength="100" class="form-control  required" />
							</div>
						</div>
					</div>
				</div>
			</div>
			<script>
        $(function(){
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
        });
    </script>

			<!--采购列表-->
			<div class="panel panel-default" id="card_products">
				<div class="panel-heading">
					<h3 class="panel-title">
						采购列表
						<shiro:hasPermission name="oa:contract:edit">
							<div class="pull-right">
								<a href="javascript:void(0);" class="btn btn-danger"
									onclick="addRow('#contractProductList', contractProductRowIdx, contractProductTpl);contractProductRowIdx = contractProductRowIdx + 1;">
									<i class="fa fa-plus"></i> 新增
								</a>
								<a class="btn btn-info" onclick="importProducts();">
									<i class="fa fa-upload"></i> 导入采购列表
								</a>
								<a class="btn btn-primary" href="${ctx}/oa/contract/import/productTemplate">
									<i class="fa fa-download"></i> 下载导入模版
								</a>
							</div>
						</shiro:hasPermission>
					</h3>
				</div>
				<div class="panel-body panel-collapse collapse in"
					id="products-collapse" style="padding:20px 0;">
					<div class="">
						<table id="contentTable"
							class="table table-striped table-condensed">
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
										<th width="15">&nbsp;</th>
									</shiro:hasPermission>
								</tr>
							</thead>
							<tbody id="contractProductList">
							</tbody>

						</table>
						<script type="text/template" id="contractProductTpl">//<!--
						<tr id="contractProductList{{idx}}" row="row" data-idx={{idx}}>
							<td class="hidden">
								<input id="contractProductList{{idx}}_id" name="contractProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="contractProductList{{idx}}_sort" name="contractProductList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="contractProductList{{idx}}_delFlag" name="contractProductList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_name" name="contractProductList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="form-control required "  style="display: inline-block;"/>
								<c:if test="${contract.act.taskDefKey eq 'split_po'}">
                                    <select id="contractProductList{{idx}}_productType" name="contractProductList[{{idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required " style="width: 40%;display: inline-block;">
                                        <c:forEach items="${productTypeList}" var="dict">
                                            <option value="${dict.id}">${dict.name}</option>
                                        </c:forEach>
                                    </select>
							        <a href="javascript:" class="fa fa-plus" onclick="addNewChildRow(this)"></a>
                                </c:if>
							</td>
							<td>
								<input id="contractProductList{{idx}}_price" name="contractProductList[{{idx}}].price" type="text" value="{{row.price}}" class="form-control number input-block required " onchange="updatePriceAmount(this);"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_num" name="contractProductList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control number input-block required " onchange="updatePriceAmount(this);" size="10"/>
							</td>
							<td>
								<select id="contractProductList{{idx}}_unit" name="contractProductList[{{idx}}].unit" data-value="{{row.unit}}" class="form-control input-block required ">
									<c:forEach items="${fns:getDictList('oa_unit')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="contractProductList{{idx}}_amount" name="contractProductList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-block " readonly style="background-color: #e8e8e8 !important;" size="10"/>
							</td>
							<td>
								<input id="contractProductList{{idx}}_remark" name="contractProductList[{{idx}}].remark" type="text" value="{{row.remark}}" maxlength="255" class="form-control input-block "/>
							</td>
							<shiro:hasPermission name="oa:contract:edit"><td class="text-center">
								{{#delBtn}}<a href="javascript:void(0);" class="on-default remove-row" onclick="delRow(this, '#contractProductList{{idx}}')"  title="删除" style="font-size:18px;"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>
						<tr>
							<td colspan=6 style="padding-left: 40px;">
							 <table class="table table-condensed" id="childProductList{{idx}}_table" style="width: 60%;">
								<tbody id="childProductList{{idx}}">
								  </tbody>
								</table>
							</td>
						<tr>
						//-->
                </script>
						<script type="text/template" id="contractProductChildTpl">//<!--
						<tr id="childProductList{{idx}}_{{child_idx}}" row="row">
							<td class="hidden">
								<input id="childProductList{{idx}}_{{child_idx}}_id" name="contractProductList[{{idx}}].childs[{{child_idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_sort" name="contractProductList[{{idx}}].childs[{{child_idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_delFlag" name="contractProductList[{{idx}}].childs[{{child_idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="childProductList{{idx}}_{{child_idx}}_name" name="contractProductList[{{idx}}].childs[{{child_idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="form-control required "  style="width: 50%;display: inline-block;"/>
								<select id="childProductList{{idx}}_{{child_idx}}_productType" name="contractProductList[{{idx}}].childs[{{child_idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required "  style="width: 40%;display: inline-block;">
										<c:forEach items="${productTypeList}" var="dict">
										<option value="${dict.id}">${dict.name}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="cchildProductList{{idx}}_{{child_idx}}_num" name="contractProductList[{{idx}}].childs[{{child_idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control number input-block required " onchange="updatePriceAmount(this);" size="10"/>
							</td>
							<td>
								<select id="childProductList{{idx}}_{{child_idx}}_unit" name="contractProductList[{{idx}}].childs[{{child_idx}}].unit" data-value="{{row.unit}}" class="form-control input-block required ">
									<c:forEach items="${fns:getDictList('oa_unit')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<shiro:hasPermission name="oa:contract:edit"><td class="text-center">
								{{#delBtn}}<a href="javascript:void(0);" class="on-default remove-row" onclick="delRow(this, '#childProductList{{idx}}_{{child_idx}}')"  title="删除"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>
						//-->
                </script>
						<script type="text/javascript">
                    var contractProductRowIdx = 0, contractProductTpl = $("#contractProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    var childRowIdx = 0, contractProductChildTpl = $("#contractProductChildTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");

                    $(document).ready(function () {
                        var data = ${fns:toJson(contract.contractProductList)};
                        for (var i = 0; i < data.length; i++) {
                            addRow('#contractProductList', contractProductRowIdx, contractProductTpl, data[i]);

                            if (data[i].childs) {
                                for (var j = 0; j < data[i].childs.length; j++) {
                                    addChildRow('#childProductList' + contractProductRowIdx, contractProductRowIdx, j, contractProductChildTpl, data[i].childs[j]);
                                }
                            }

                            contractProductRowIdx = contractProductRowIdx + 1;
                        }
                    });

                    function addRow(list, idx, tpl, row) {
                        $(list).append(Mustache.render(tpl, {
                            idx: idx, delBtn: true, row: row
                        }));
                        $(list + idx).find("select").each(function () {
                            $(this).val($(this).attr("data-value"));
                        });
                        $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                            var ss = $(this).attr("data-value").split(',');
                            for (var i = 0; i < ss.length; i++) {
                                if ($(this).val() == ss[i]) {
                                    $(this).attr("checked", "checked");
                                }
                            }
                        });
                    }

                    function addChildRow(list, idx, child_idx, tpl, row) {
                        $(list).append(Mustache.render(tpl, {
                            idx: idx, child_idx: child_idx, delBtn: true, row: row
                        }));
                        $(list + "_" + child_idx).find("select").each(function () {
                            $(this).val($(this).attr("data-value"));
                        });
                        $(list + "_" + child_idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                            var ss = $(this).attr("data-value").split(',');
                            for (var i = 0; i < ss.length; i++) {
                                if ($(this).val() == ss[i]) {
                                    $(this).attr("checked", "checked");
                                }
                            }
                        });
                    }

                    function addNewChildRow(sender) {
                        var parentRow = $(sender).closest('tr');
                        var parentIdx = parentRow.data('idx');
                        var childTable = $('#childProductList' + parentIdx + '_table');
                        var childIdx = childTable.find('tr').length;
                        var productTypeGroup = parentRow.find('select').val();
                        addChildRow('#childProductList' + parentIdx, parentIdx, childIdx, contractProductChildTpl);
                    }

                    function delRow(obj, prefix) {
                        var id = $(prefix + "_id");
                        var delFlag = $(prefix + "_delFlag");
                        if (id.val() == "") {
                            $(obj).parent().parent().remove();
                        } else if (delFlag.val() == "0") {
                            delFlag.val("1");
                            $(obj).html("&divide;").attr("title", "撤销删除");
                            $(obj).parent().parent().addClass("error");
                        } else if (delFlag.val() == "1") {
                            delFlag.val("0");
                            $(obj).html("&times;").attr("title", "删除");
                            $(obj).parent().parent().removeClass("error");
                        }
                    }

					//导入excel
					function importProducts(){
						$("#uploadFile").trigger("click");
					}
					$(document).ready(function(){
						$("#uploadFile").change(function(){
							$('#importForm').trigger("submit");
						});
						$("#importForm").ajaxForm({success:completeLoadProducts, dataType:'json'});
						function completeLoadProducts(result){
							for (var i = 0; i < result.length; i++) {
								addRow('#contractProductList', contractProductRowIdx, contractProductTpl, result[i]);
							}
							$("#uploadFile").val("");
						}
					});

                </script>
					</div>
				</div>
				<div class="panel-footer text-right" style="background:#fff;">
					<strong id="span-display-amount">采购总金额:
						${contract.amount}</strong>
				</div>
			</div>

			<!--付款信息-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">付款信息</h3>
				</div>
				<div class="panel-body form-horizontal" id="payment-collapse">
					<div class="row clearfix">
						<div class="form-group">
							<label class="control-label">付款周期：</label>
								<form:radiobuttons path="paymentCycle"
									items="${fns:getDictList('oa_payment_cycle')}"
									itemLabel="label" itemValue="value" htmlEscape="false" class=""
									element="span class='radio radio-custom radio-inline'" />
								<form:hidden path="paymentDetail"></form:hidden>

						</div>
						<span id="paymentMsg" style="display: none"
							class="label label-danger pull-right"></span>
					</div>
					<script type="text/template" id="payment-onetime-tpl">//<!--
                <div class="row form-inline" id="payment-onetime">      
 					<div class="form-group">
							<label>比例：</label>
							<div class="input-group">
							<input type="text" value="" class="form-control  number payPercentage" onchange="updatePayment(this);" style="width:60px;">
							<span class="input-group-addon bootstrap-touchspin-postfix">%</span></div>
					</div>
					<div class="form-group">
                        <label>付款金额：</label>
                        <input type="text" class="form-control number required payment_amount" id="payment_onetime_amount" value="{{row.payment_onetime_amount}}"/>
                    </div>
                    <div class="form-group">
                        <label>付款方式：</label>
                        <c:forEach items="${fns:getDictList('oa_payment_method')}" var="dict" varStatus="s">
                            <span class="radio radio-custom radio-inline" style="padding-left:2px">
                                <input id="payment_onetime_paymentMethod${s.index+1}" name="payment_onetime_paymentMethod" type="radio"
                                       value="${dict.value}" data-value="{{row.payment_onetime_paymentMethod}}"  checked>
                                <label for="payment_onetime_paymentMethod${s.index+1}">${dict.label}</label>
                            </span>
                        </c:forEach>
                    </div>
                    <div class="form-group">
                        <label>账期：</label>
                        <input id="payment_onetime_time" type="text" class="form-control number required" value="{{row.payment_onetime_time}}"/>
                    </div>
                   
                </div>
                    //-->
            </script>
					<script type="text/template" id="payment-installment-tpl">//<!--
                <div class="row form-inline" id="payment-installment_{{idx}}" style="margin-bottom:10px;">
					<div class="form-group">
							<label>比例：</label>
							<div class="input-group">
							<input type="text" value="" class="form-control  number payPercentage" onchange="updatePayment(this);" style="width:60px;">
							<span class="input-group-addon bootstrap-touchspin-postfix">%</span></div>
					</div>
					<div class="form-group">
                        <label>付款金额：</label>
                        <input type="text" class="form-control required number payment_amount" id="payment_installment_amount_{{idx}}"
                        value="{{row.payment_installment_amount}}"/>
                    </div>
                    <div class="form-group">
                        <label>账期：</label>
                        <input id="payment_installment_time_{{idx}}" type="text" class="form-control number  required"
                        value="{{row.payment_installment_time}}"/>
                    </div>
                    <div class="form-group">
                        <label>付款方式：</label>
                        <c:forEach items="${fns:getDictList('oa_payment_method')}" var="dict" varStatus="s">
                            <span class="radio radio-custom radio-inline" style="padding-left:2px;">
                                <input id="payment_installment_paymentMethod_{{idx}}_${s.index+1}" name="payment_installment_paymentMethod_{{idx}}" type="radio"
                                       value="${dict.value}" data-value="{{row.payment_installment_paymentMethod}}" checked>
                                <label for="payment_installment_paymentMethod_{{idx}}_${s.index+1}">${dict.label}</label>
                            </span>
                        </c:forEach>
					</div>
					<div class="form-group">
                        <span  style="margin-left:20px;">
  				   		<a href="javascript:void(0);" onclick="addNewInstallmentPayment(this)" title="增加新的分期付款" class="zmdi zmdi-plus-circle text-custom" style="font-size:24px;"></a>
                   		<a href="javascript:void(0);" onclick="deleteInstallmentPayment(this)" title="删除" class="zmdi zmdi-minus-circle text-custom" style="font-size:24px;"></a>
						</span>
                    </div>
                 
                </div>
                //-->
            </script>
					<script type="text/template" id="payment-month-tpl">//<!--
                <div class="row form-inline" id="payment-month">
					<div class="form-group">
							<label>比例：</label>
							<div class="input-group">
							<input type="text" value="" class="form-control  number payPercentage" onchange="updatePayment(this);" style="width:60px;">
							<span class="input-group-addon bootstrap-touchspin-postfix">%</span></div>
					</div>
					<div class="form-group">
                        <label>付款金额：</label>
                        <input type="text" class="form-control  number  required payment_amount" id="payment_month_amount" size="10"
                        value="{{row.payment_month_amount}}"/>
                    </div>
                    <div class="form-group">
                        <label>付款方式：</label>
                        <c:forEach items="${fns:getDictList('oa_payment_method')}" var="dict" varStatus="s">
                            <span class="radio radio-custom radio-inline" style="padding-left:2px">
                                <input id="payment_month_paymentMethod${s.index+1}" name="payment_month_paymentMethod" type="radio"
                                       value="${dict.value}" data-value="{{row.payment_month_paymentMethod}}" checked>
                                <label for="payment_month_paymentMethod${s.index+1}">${dict.label}</label>
                            </span>
                        </c:forEach>
                    </div>
                    <div class="form-group">
                        <label>{{type}}数：</label>
						<div class="input-group">
                        <input id="payment_month_num" type="text" class="form-control number  required" size="10"
                        value="{{row.payment_month_num}}" style="width:50px;"/><span class="input-group-addon bootstrap-touchspin-postfix">{{type}}</span></div>
                    </div>
                    <div class="form-group">
                        <label>付款日：</label>
                        <input id="payment_month_day" type="text" class="form-control number  required" size="10"
                        value="{{row.payment_month_day}}" style="width:50px;"/>
                    </div>
                    <div class="form-group">
                        <label>起始月：</label>
                        <input id="payment_month_start" type="text" class="form-control number  required" size="10"
                        value="{{row.payment_month_start}}"  style="width:50px;"/>
                    </div>
                </div>
                 //-->
            </script>
					<div id="payment-body" data-idx="1"></div>
					<script type="text/javascript">
					
					function updatePayment(sender){
						var totalAmount = parseFloat($("#amount").val());
                    	var percentage = parseFloat($(sender).val());
                    	if(totalAmount&& percentage) {
                    		$(sender).parent().parent().parent().find(".payment_amount").val((totalAmount * percentage /100).toFixed(2));
                    	}
					}
                $(document).ready(function () {
                	                   
                    $("#btnSubmit, #btnStartAudit").click(function () {
                        $("#paymentDetail").val(JSON.stringify(getPaymentDetail()));
                    });
                    //付款周期
                    $("input[id^='paymentCycle']").change(function () {
                        $("#payment-body").empty();
                        addPaymentRow();
						/*$("#payment-body").find(".required").each(function(){
							$(this).rules("add", {
								required: true
							});
						});*/
                    });

                    if ($('#id').val()!="") {
                        //load payment detail from saved data
                        var paymentDetail = JSON.parse(${fns:toJson(contract.paymentDetail)});
                        var paymentCycle = ${contract.paymentCycle};
                        switch (paymentCycle) {
                            case 1:
                            case 3:
                            case 4:
                                addPaymentRow(paymentDetail);
                                break;
                            case 2:
                                $.each(paymentDetail, function (idx, item) {
                                    addPaymentRow(item, idx + 1);
                                });
                                break;
                        }
                    } else{
                        $("input[id^='paymentCycle']").trigger('change');
                    }
                });

                function addPaymentRow(row,idx){
                    var paymentCycle = $("input[id^='paymentCycle']:checked").val();
                    switch(paymentCycle){
                        case "1":
                                $("#payment-body").append(Mustache.render($("#payment-onetime-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {row:row}));
                            break;
                        case "2":
                                if(!idx)
                                    idx=1;
                                $("#payment-body").append(Mustache.render($("#payment-installment-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {idx:idx, row:row}));
                                idx = idx+1;
                                $("#payment-body").data("idx",idx);
                            break;
                        case "3":
                                $("#payment-body").append(Mustache.render($("#payment-month-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {type:"月",row:row}));
                            break;
                        case "4":
                                $("#payment-body").append(Mustache.render($("#payment-month-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {type:"季",row:row}));
                            break;
                    }
                    $("#payment-body").find("select").each(function () {
                        $(this).val($(this).attr("data-value"));
                    });
                    $("#payment-body").find("input[type='checkbox'], input[type='radio']").each(function () {
                        var ss = $(this).attr("data-value").split(',');
                        for (var i = 0; i < ss.length; i++) {
                            if ($(this).val() == ss[i]) {
                                $(this).attr("checked", "checked");
                            }
                        }
                    });
                }

                function addNewInstallmentPayment(sender){
                    var self = $(sender);
                    var selfRow = self.closest('.row');
                    var idx = parseInt($("#payment-body").data("idx"));

                    selfRow.after(Mustache.render($("#payment-installment-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {idx: idx}));
                    idx = idx+1;
                    $("#payment-body").data("idx",idx);
                }

                function deleteInstallmentPayment(sender){
                    var self = $(sender);
                    var rowCount = $("#payment-body .row").length;
                    if(rowCount>1)
                        self.closest('.row').remove();
                }

                //得到付款明细数据
                function getPaymentDetail(){
                    var paymentCycle = $("input[id^='paymentCycle']:checked").val();
                    var paymentDetail;
                    switch(paymentCycle){
                        case "1":
                                paymentDetail={
                                    payment_onetime_amount:$("#payment-onetime #payment_onetime_amount").val(),
                                    payment_onetime_paymentMethod:$("#payment-onetime input[id^='payment_onetime_paymentMethod']:checked").val(),
                                    payment_onetime_time:$("#payment-onetime #payment_onetime_time").val()
                                };
                            break;
                        case "2":
                            paymentDetail=[];
                            $(".row[id^='payment-installment']").each(function(index, item){
                                var row = $(item);
                                paymentDetail.push({
                                    payment_installment_amount: row.find("input[id^='payment_installment_amount']").val(),
                                    payment_installment_time :row.find("input[id^='payment_installment_time']").val(),
                                    payment_installment_paymentMethod :row.find("input[id^='payment_installment_paymentMethod']:checked").val(),
                                });
                            });
                            break;
                        case "3":
                        case "4":
                            paymentDetail= {
                                payment_month_amount: $("#payment-month #payment_month_amount").val(),
                                payment_month_paymentMethod: $("#payment-month input[id^='payment_month_paymentMethod']:checked").val(),
                                payment_month_num: $("#payment-month #payment_month_num").val(),
                                payment_month_day: $("#payment-month #payment_month_day").val(),
                                payment_month_start: $("#payment-month #payment_month_start").val()
                            };
                            break;
                    }
                    /*console.log(JSON.stringify(paymentDetail));*/
                    return paymentDetail;
                }

                //验证付款金额
                function validationPaymentAmount(){
                    var result = false;
                    var paymentCycle = $("input[id^='paymentCycle']:checked").val();
                    switch(paymentCycle){
                        case "1":
                        	result = parseFloat($("#payment_onetime_amount").val()) >= parseFloat($("#amount").val());
                            break;
                        case "2":
                             var sumAmount = 0.00;
                            $("input[id^='payment_installment_amount']").each(function(idx, item){
                               sumAmount = sumAmount + parseFloat($(item).val());
                            });
                            result = sumAmount >=  parseFloat($("#amount").val());
                            break;
                        case "3":
                        case "4":
                        	result = (parseFloat($("#payment_month_amount").val())* parseFloat($("#payment_month_num").val())) >=  parseFloat($("#amount").val());
                            break;
                    }
                    /*if(!result){
                        $("#paymentMsg").html("付款金额与合同金额不相等,合同金额为:"+ parseFloat($("#amount").val())) ;
                        $("#paymentMsg").show();
                    } else{
                        $("#paymentMsg").hide();
                    }*/

                    return result;
                }
            </script>
				</div>
			</div>

			<!--物流信息-->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">物流信息</h3>
				</div>
				<div class="panel-body form-horizontal" id="ship-collapse">

					<div class="col-sm-12">
					<%--	<div class="form-group">
							<label class="control-label col-sm-2">发货方式：</label>
							<div class="col-sm-9">
								<form:radiobuttons path="shipMode"
									items="${fns:getDictList('oa_ship_mode')}" itemLabel="label"
									itemValue="value" htmlEscape="false" class=""
									element="span class='radio radio-custom radio-inline'" />
							</div>
						</div>--%>
						<div class="form-group">
							<label class="control-label col-sm-2">收货地址：</label>
							<div class="col-sm-6">
								<form:input path="shipAddress" htmlEscape="false"
									class="form-control  " size="60" />
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-sm-2">收货人：</label>
							<div class="col-sm-3">
								<form:input path="shipReceiver" htmlEscape="false"
									class="form-control  " />
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-sm-2">联系电话：</label>
							<div class="col-sm-3">
								<form:input path="shipPhone" htmlEscape="false"
									class="form-control   phone" />
							</div>
						</div>
					<%--	<div class="form-group">
							<label class="control-label col-sm-2">快递单号：</label>
							<div class="col-sm-3">
								<form:input path="shipEms" htmlEscape="false"
									class="form-control  " size="60" />
							</div>
						</div>--%>
					</div>
				</div>
			</div>

			<!--其它-->
			<div class="panel panel-default" id="card_other">
				<div class="panel-heading">
					<h3 class="panel-title">其它</h3>
				</div>
				<div class="panel-body">
					<div class="row form-inline">
						<div class="form-group">
							<label>销售奖金：</label>

							<form:input path="customerCost" htmlEscape="false"
								class="form-control required number " />

						</div>

						<div class="form-group">
						<div class="checkbox checkbox-custom checkbox-circle" style="padding-top:0;">
							<input type="checkbox" value="true" name="isDeduction" id="isDeduction">
							<label for="isDeduction" style="line-height:16px;">是否业绩抵扣</label>
							<input type="hidden" value="on" name="_isDeduction">
							</div>
						</div>
						
						<div class="form-group" id="discount-group">
							<label>抵扣金额：</label>
							<form:input path="discount" htmlEscape="false"
								class="form-control  number " />
						</div>
						<div class="form-group">
							<label>业绩分成比例：</label>
							<div class="input-group">
							<input type="text" value="" class="form-control  number " name="performancePercentage" id="performancePercentage" style="width:60px;">
							<span class="input-group-addon bootstrap-touchspin-postfix">%</span></div>
						</div>
					</div>
				</div>
			</div>

			<!--附件-->
			<div class="panel panel-default" id="card_attachemnts">
				<div class="panel-heading">
					<h3 class="panel-title">附件</h3>
				</div>
				<div class="panel-body" style="padding:0;">
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
				<div class="panel-heading">
				<h3 class="panel-title">备注</h3></div>
				<div class="panel-body">
					<div class="form-group clearfix">
						<div class="col-sm-12">
							<form:textarea path="remark" htmlEscape="false" maxlength="255"
								class="form-control" />
						</div>
					</div>
				</div>
			</div>

			<div class="form-group clearfix hidden">
				<label class="col-sm-3 control-label">合同金额：</label>
				<div class="col-sm-7">
					<form:input path="amount" htmlEscape="false"
						class="form-control  number " />
				</div>
			</div>

			<c:if
				test="${not empty contract.id and not empty contract.act.procInsId}">
				<act:histoicFlow procInsId="${contract.act.procInsId}" />
			</c:if>
			<div class="form-group">
				<div class="text-center">
					<input id="btnCancel" class="btn btn-inverse" type="button" value="返 回"
						onclick="history.go(-1)" />
				
					<shiro:hasPermission name="oa:contract:edit">
						<input id="btnSubmit" class="btn btn-info" type="submit"
							value="保 存" />&nbsp;
					</shiro:hasPermission>

					<shiro:hasPermission name="oa:contract:audit">
						<c:if
							test="${contract.contractType ne '1' and empty contract.act.procInsId}">
							<input id="btnStartAudit" class="btn btn-custom" type="submit"
								value="提交审批" onclick="$('#flag').val('submit_audit');" />&nbsp;
						</c:if>
					</shiro:hasPermission>

					
				</div>
			</div>
	</form:form>
</body>
</html>