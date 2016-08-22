<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购订单管理</title>
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
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/purchaseOrder/">采购订单列表</a></li>
		<li class="active"><a href="${ctx}/oa/purchaseOrder/form?id=${purchaseOrder.id}">采购订单<shiro:hasPermission name="oa:purchaseOrder:edit">${not empty purchaseOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:purchaseOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-md-2 control-label">流程实例ID：</label>
			<div class="col-md-4">
				<form:input path="procInsId" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">订单号：</label>
			<div class="col-md-4">
				<form:input path="no" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">合同：</label>
			<div class="col-md-4">
				<form:input path="contract.name" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">公司抬头：</label>
			<div class="col-md-4">
				<form:input path="contract.companyName" htmlEscape="false" maxlength="64" class="form-control required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">供应商：</label>
			<div class="col-md-4">
				<form:input path="supplier.name" htmlEscape="false" maxlength="64" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">付款信息：</label>
			<div class="col-md-4">
				<form:input path="paymentDetail" htmlEscape="false" maxlength="4000" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">帐期点数：</label>
			<div class="col-md-4">
				<form:input path="paymentPointnum" htmlEscape="false" maxlength="10" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">预计到货时间：</label>
			<div class="col-md-4">
				<form:input path="shipDate" htmlEscape="false" maxlength="10" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">备注：</label>
			<div class="col-md-4">
				<form:input path="remark" htmlEscape="false" maxlength="255" class="form-control "/>
			</div>
		</div>
			<div class="control-group">
				<label class="control-label">订单产品明细表：</label>
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr role="row">
								<th class="hidden"></th>
								<th>合同商品</th>
								<th>名称</th>
								<th>商品类型</th>
								<th>价格</th>
								<th>数量</th>
								<th>单位</th>
								<th>金额</th>
								<th>备注</th>
								<th>排序</th>
								<shiro:hasPermission name="oa:purchaseOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="purchaseOrderProductList">
						</tbody>
						<shiro:hasPermission name="oa:purchaseOrder:edit"><tfoot>
							<tr><td colspan="11"><a href="javascript:" onclick="addRow('#purchaseOrderProductList', purchaseOrderProductRowIdx, purchaseOrderProductTpl);purchaseOrderProductRowIdx = purchaseOrderProductRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="purchaseOrderProductTpl">//<!--
						<tr id="purchaseOrderProductList{{idx}}" role="row">
							<td class="hidden">
								<input id="purchaseOrderProductList{{idx}}_id" name="purchaseOrderProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="purchaseOrderProductList{{idx}}_delFlag" name="purchaseOrderProductList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_contractProductId" name="purchaseOrderProductList[{{idx}}].contractProductId" type="text" value="{{row.contractProductId}}" maxlength="64" class="form-control input-block "/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_name" name="purchaseOrderProductList[{{idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="form-control input-block required"/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_productType" name="purchaseOrderProductList[{{idx}}].productType" type="text" value="{{row.productType}}" maxlength="64" class="form-control input-block required"/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_price" name="purchaseOrderProductList[{{idx}}].price" type="text" value="{{row.price}}" class="form-control input-block "/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_num" name="purchaseOrderProductList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control input-block "/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_unit" name="purchaseOrderProductList[{{idx}}].unit" type="text" value="{{row.unit}}" maxlength="2" class="form-control input-block "/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_amount" name="purchaseOrderProductList[{{idx}}].amount" type="text" value="{{row.amount}}" class="form-control input-block "/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_remark" name="purchaseOrderProductList[{{idx}}].remark" type="text" value="{{row.remark}}" maxlength="255" class="form-control input-block "/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_sort" name="purchaseOrderProductList[{{idx}}].sort" type="text" value="{{row.sort}}" maxlength="4" class="form-control input-block required"/>
							</td>
							<shiro:hasPermission name="oa:purchaseOrder:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#purchaseOrderProductList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var purchaseOrderProductRowIdx = 0, purchaseOrderProductTpl = $("#purchaseOrderProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(purchaseOrder.purchaseOrderProductList)};
							for (var i=0; i<data.length; i++){
								addRow('#purchaseOrderProductList', purchaseOrderProductRowIdx, purchaseOrderProductTpl, data[i]);
								purchaseOrderProductRowIdx = purchaseOrderProductRowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
		<div class="form-actions">
			<shiro:hasPermission name="oa:purchaseOrder:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>