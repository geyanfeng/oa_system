<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>采购订单管理</title>
<meta name="decorator" content="default" />
<style>
html, body {
	background: white;
}

#table_po_products>tbody>tr>td {
	border: 1px solid transparent !important;
}

hr {
	margin-left: -15px;
	margin-right: -15px;
	margin-top: 10px;
	margin-bottom: 10px;
}

h4 {
	margin-right: -15px;
}

.row {
	margin-top: 5px;
	padding-left: 15px;
}
</style>
<link
	href="${ctxStatic}/assets/plugins/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.min.css"
	rel="stylesheet" />
<script
	src="${ctxStatic}/assets/plugins/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.min.js"
	type="text/javascript"></script>
<script src="${ctxStatic}/assets/js/jquery.form.js"></script>
<script type="text/javascript">
    function changeSupplier() { 
 	   var selectedValue = $("#supplier").find("option:selected").val();
 	   selectedOpt = $("#"+selectedValue);
 	   if(selectedOpt.attr("shippingSpeed") == null || selectedOpt.attr("shippingSpeed") == "0.0") {
 		   $("#shippingSpeed").html("未评价");
     	   $("#communicationEfficiency").html("未评价");
     	   $("#productQuality").html("未评价");
     	   $("#serviceAttitude").html("未评价"); 
 	   }
 	   else{
 		   $("#shippingSpeed").html(selectedOpt.attr("shippingSpeed"));
     	   $("#communicationEfficiency").html(selectedOpt.attr("communicationEfficiency"));
     	   $("#productQuality").html(selectedOpt.attr("productQuality"));
     	   $("#serviceAttitude").html(selectedOpt.attr("serviceAttitude"));  	   
 	   }
 	
    } 
       
        
        $(document).ready(function() {
            //$("#name").focus();
            changeSupplier();
            $("#inputForm").validate({
                submitHandler: function(form){
                    /*loading('正在提交，请稍等...');
                    form.submit();*/
                    $("#inputForm").ajaxSubmit({
                        success:function(result){
                            var status= result.status;
                            if(status!="1"){
                                if(result.msg)
                                    showTipMsg(result.msg,"error");
                                return;
                            }
                            if(parent){
                                    parent.showTipMsg("订单保存成功","success");
                            } else
                                showTipMsg("订单保存成功","success");

                            if(parent.loadProductsAfterClear){
                                $.getJSON("${ctx}/oa/contract/get?id="+result.contractId, function(result){
                                    parent.loadProductsAfterClear(result.data.contractProductList);
                                    //关闭本窗体
                                    if(parent.openOrClosePOPanel)
                                        parent.openOrClosePOPanel();
                                    location.reload();
                                });
                            }
                            if(parent.loadPoList)
                                    parent.loadPoList();

                        }});
                },
                errorContainer: "#messageBox",
                errorPlacement: function(error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
                        error.appendTo(element.parent().parent());
                    } else if(element.parent().hasClass('bootstrap-touchspin')){
                        error.appendTo(element.closest('td'));
                    }
                    else {
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

        //增加供应商
        function addSupplier(sender){
            var frameSrc = "${ctx}/oa/supplier/form?fromModal=1";
          /*  if(!parent.getModal)return;
            var modal = parent.getModal();
            modal.find('iframe').attr("src", frameSrc);
            modal.find('.modal-title').html('增加供应商');
            modal.modal({show: true, backdrop: 'static'});*/

            openModalFromUrl("增加供应商",frameSrc);
        }

        //关闭增加
        function closeSupplierModal(supplier){
            var modal = getCommonModal();
            modal.modal('hide');
            $.get('${ctx}/oa/supplier/data',function(data){
                $('#supplier').children().remove();
                $("#supplier").append("<option value='' selected='selected'></option>");
                $.each(data,function(idx, item){
                    $("#supplier").append("<option value='"+item.id+"'>"+item.name+"</option>");
                });
                if(supplier && supplier.id)
                    $('#supplier').val(supplier.id).trigger("change");
            });
        }
    </script>
</head>
<body>
	<div class="container" style="padding: 0;">
		<form:form id="inputForm" modelAttribute="purchaseOrder"
			action="${ctx}/oa/purchaseOrder/ajaxSave" method="post">
			<form:hidden path="id" />
			<form:hidden path="contract.id" />
			<sys:message content="${message}" />
			<!--产品-->
			<div class="form-inline">
				<table class="table table-condensed" id="table_po_products">
					<tbody id="purchaseOrderProductList">
					</tbody>
				</table>
				<script type="text/template" id="poProductTpl">//<!--
						<tr id="purchaseOrderProductList{{idx}}" row="row" data-idx={{idx}} data-contractProductId="{{row.contractProductId}}">
							<td class="hidden">
								<input id="purchaseOrderProductList{{idx}}_id" name="purchaseOrderProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="purchaseOrderProductList{{idx}}_sort" name="purchaseOrderProductList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="purchaseOrderProductList{{idx}}_delFlag" name="purchaseOrderProductList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="purchaseOrderProductList{{idx}}_maxNum" name="purchaseOrderProductList[{{idx}}].maxNum" type="hidden" value="{row.maxNum}}"/>
								<input id="purchaseOrderProductList{{idx}}_contractProductId" name="purchaseOrderProductList[{{idx}}].contractProductId" type="hidden" value="{{row.contractProductId}}"/>
							</td>
							<td style="text-align:left;padding-left:15px;">
								<input  id="purchaseOrderProductList{{idx}}_name" name="purchaseOrderProductList[{{idx}}].name" type="hidden" value="{{row.name}}" maxlength="100" class="form-control required input-sm"  style="display: inline-block;"/>
								{{row.name}}
							</td>
							<td width="100">
								<input id="purchaseOrderProductList{{idx}}_num" name="purchaseOrderProductList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control number input-block required input-sm" onchange="updateSumAmount(this);" style="display:inline-block"/>
							</td>
							<td width="20">
							    {{row.unitName}}
								<input id="purchaseOrderProductList{{idx}}_unit" name="purchaseOrderProductList[{{idx}}].unit" type="hidden" value="{{row.unitId}}"/>
							</td>
							<td width="140">
								<input id="purchaseOrderProductList{{idx}}_price" name="purchaseOrderProductList[{{idx}}].price" type="text" value="{{row.price}}" class="form-control number input-block required input-sm" onchange="updateSumAmount(this);" style="display:inline-block"/>
							</td>
							<td width="20">元</td>
							<shiro:hasPermission name="oa:contract:edit"><td class="text-center" width="10">
								{{#delBtn}}<a href="javascript:void(0);" class="on-default remove-row" onclick="delRow(this, '#purchaseOrderProductList{{idx}}', '{{row.contractProductId}}')"  title="删除"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>
						//-->
        </script>
				<script type="text/javascript">
            var poProductRowIdx = 0, poProductTpl = $("#poProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            var sumAmount = ${not empty purchaseOrder.amount? purchaseOrder.amount: 0 };
            $(document).ready(function () {
                var data = ${fns:toJson(purchaseOrder.purchaseOrderProductList)};
                for (var i = 0; i < data.length; i++) {
                    addRow('#purchaseOrderProductList', poProductRowIdx, poProductTpl, data[i]);
                    poProductRowIdx = poProductRowIdx + 1;
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
                $(list + idx).find("input[name$='.price']").TouchSpin({
                    buttondown_class: "btn btn-custom",
                    buttonup_class: "btn btn-custom",
                    max:99999999
                });
                $(list + idx).find("input[name$='.num']").TouchSpin({
                    buttondown_class: "btn btn-custom",
                    buttonup_class: "btn btn-custom",
                    max:row.maxNum
                });
                $(list + idx).find("input[name$='.num']").rules('add', {
                    max: row.maxNum
                });


                //$(list + idx).find('.bootstrap-touchspin').css('width','100px');
            }

            function delRow(obj, prefix, contractProductId) {
                if(parent.unSelectProduct){
                    parent.unSelectProduct(contractProductId);
                }
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

            function addProduct(data){
                if($("#purchaseOrderProductList tr[data-contractProductId='"+data.id+"']").length>0) return;
                var row = {
                    contractProductId: data.id,
                    name: data.name,
                    num: (data.num - data.hasSendNum),
                    unit: data.unit,
                    unitName: $.trim(data.unitName),
                    maxNum: (data.num - data.hasSendNum)
                }
                addRow('#purchaseOrderProductList', poProductRowIdx, poProductTpl, row);
                poProductRowIdx = poProductRowIdx + 1;
            }

            function removeProduct(id){
                var deleteRow = $("#purchaseOrderProductList tr[data-contractProductId='"+id+"']");
                deleteRow.remove();
            }

            //更新总金额
            function updateSumAmount(sender){
                var row = $(sender).closest('tr');
                var price = row.find("input[id$='_price']").val();
                var num = row.find("input[id$='_num']").val();
                if(price && num)
                    sumAmount = sumAmount + price * num;
            }
        </script>
			</div>

			<hr>

			<!--供应商-->
			<div class="row">
				<div class="form-group">
					<table>
					<tr>
						<td width="80" height="40">供应商：</td>
						<td><div class="input-group">
							<form:select path="supplier.id"
								class="form-control required input-sm" id="supplier"
								onchange="changeSupplier();" cssStyle="width:200px;">
								<form:option value="" label="" />

								<form:options items="${supplierList}" itemLabel="name"
									itemValue="id" htmlEscape="false" />

							</form:select>
							<c:forEach var="supplierItem" items="${supplierList}"
								varStatus="status">
								<input id="${supplierItem.id}" type="hidden"
									shippingSpeed="${supplierItem.shippingSpeed}"
									communicationEfficiency="${supplierItem.communicationEfficiency}"
									productQuality="${supplierItem.productQuality}"
									serviceAttitude="${supplierItem.serviceAttitude}">
							</c:forEach>
							<span class="input-group-btn"> <a
								href="javascript:void(0);" onclick="addSupplier(this)"
								title="新增供应商" class="btn btn-sm btn-custom">+</a></span>
						</div></td>
					</tr>
					</table>
				</div>
			</div>


			<div class="row">
				<div class="col-xs-12 form-group">
					<span>发货 <span id="shippingSpeed" style="color: red;">未评价</span>&nbsp;&nbsp;沟通
						<span id="communicationEfficiency" style="color: red;">未评价</span>
						&nbsp;&nbsp;质量 <span id="productQuality" style="color: red;">未评价</span>
						&nbsp;&nbsp;态度 <span id="serviceAttitude" style="color: red;">未评价</span></span>
				</div>
			</div>



			<hr>

			<!--付款信息-->
			<!--todo: 检查付款总金额等于产品总金额之和-->
			<h4 style="padding-left: 15px;">付款信息</h4>
			<div id="payment-body" data-idx="0" class="clearfix"></div>

			<div class="row m-t-10">
				<div class="form-group col-xs-12">
					帐期点数：&nbsp;
					<form:input path="paymentPointnum" htmlEscape="false"
						maxlength="255" class="form-control required input-sm"
						cssStyle="width:100px; display:inline;" onchange="updateRll();" />
				</div>
			</div>

			<div class="row">
				<div class="form-group col-xs-12">
					帐期日利率：<span id="rll"></span>
				</div>
			</div>
			<script type="text/template" id="paymentTpl">//<!--
    <div id="purchaseOrderFinanceList{{idx}}" data-idx="{{idx}}" class="row" style="padding-left:10px;">
        <input id="purchaseOrderFinanceList{{idx}}_id" name="purchaseOrderFinanceList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
        <input id="purchaseOrderFinanceList{{idx}}_sort" name="purchaseOrderFinanceList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
	    <input id="purchaseOrderFinanceList{{idx}}_delFlag" name="purchaseOrderFinanceList[{{idx}}].delFlag" type="hidden" value="0"/>
	    <input id="purchaseOrderFinanceList{{idx}}_planPayDate" name="purchaseOrderFinanceList[{{idx}}].planPayDate" type="hidden" value="{{row.planPayDate}}"/>
	    <input id="purchaseOrderFinanceList{{idx}}_payDate" name="purchaseOrderFinanceList[{{idx}}].payDate" type="hidden" value="{{row.payDate}}"/>
	    <input id="purchaseOrderFinanceList{{idx}}_status" name="purchaseOrderFinanceList[{{idx}}].status" type="hidden" value="{{row.status}}"/>
        <div style="background: #f5f5f5;width:85%;float:left; padding: 10px;" class="div-pay">
			<table>
				<tr>
					<td  width="80">比例：</td>
					<td><input type="text" class="form-control required number input-sm" id="purchaseOrderFinanceList{{idx}}_bl" onchange="updatePayment(this);"
                           value="{{row.bl}}"/></td>
					<td width="80" height="40">付款金额：</td>
					<td><input type="text" class="form-control required number input-sm" id="purchaseOrderFinanceList{{idx}}_amount" name="purchaseOrderFinanceList[{{idx}}].amount"
                        onchange="updatePayment(this);" value="{{row.amount}}" /></td>
					
				</tr>
				<tr>
					<td height="40">付款账期：</td>
					<td><input id="purchaseOrderFinanceList{{idx}}_zq" name="purchaseOrderFinanceList[{{idx}}].zq" type="text" class="form-control required number input-sm"
                           value="{{row.zq}}" onchange="updateRll()"/></td>
					<td>付款条件：</td>
					<td><select id="purchaseOrderFinanceList{{idx}}_payCondition" name="purchaseOrderFinanceList[{{idx}}].payCondition" data-value="{{row.payCondition}}" class="form-control input-block required input-sm">
                    	<option value="0">预付</option>
                    	<option value="1">后付</option>
                	</select></td>
				</tr>
				<tr>
					<td height="40">付款方式：</td>
					<td colspan="3" style="text-align:left;"><c:forEach items="${fns:getDictList('oa_payment_method')}" var="dict" varStatus="s">
                                    <span class="radio radio-custom radio-inline">
                                        <input id="purchaseOrderFinanceList{{idx}}_payMethod_${s.index+1}" name="purchaseOrderFinanceList[{{idx}}].payMethod" type="radio"
                                               value="${dict.value}" data-value="{{row.payMethod}}" ${s.index eq 1? "checked":""}>
                                        <label for="purchaseOrderFinanceList{{idx}}_payMethod_${s.index+1}">${dict.label}</label>
                                    </span>
                    </c:forEach></td>
				</tr>
				<tr id="div-activeData_{{idx}}" style="display:none;">
					<td height="40">生效日期：</td>
					<td colspan="2" style="text-align:left;">
						<div class="input-group">
						<input id="purchaseOrderFinanceList{{idx}}_activeDate" name="purchaseOrderFinanceList[{{idx}}].activeDate" value="{{row.activeDate}}" type="text"
            readonly="readonly" class="form-control input-sm required" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						<span class="input-group-addon bg-custom b-0 text-white btn-sm"><i
							class="ti-calendar"></i></span>
						</div>
                    </td>
					<td></td>
				</tr>
			</table>
        </div>
        <div class="text-center m-r-5">
            <br/><br/><a href="javascript:void(0);" onclick="addNewInstallmentPayment(this)" title="增加新的分期付款" class="zmdi zmdi-plus-circle text-custom" style="font-size:25px;"></a>
            <br/><br/><br/><a href="javascript:void(0);" id="purchaseOrderFinanceList{{idx}}_btnDelete" onclick="deleteInstallmentPayment(this)" title="删除" class="zmdi zmdi-minus-circle text-custom" style="font-size:25px;"></a>
        </div>
    </div>
    //-->
    </script>
			<script>
        $(function(){
            <c:if test="${empty purchaseOrder.id}">
                addNewInstallmentPayment();
            </c:if>
            <c:if test="${not empty purchaseOrder.id}">
                var paymentDetails = ${fns:toJson(purchaseOrder.purchaseOrderFinanceList)};
                for (var i = 0; i < paymentDetails.length; i++) {
                    addNewInstallmentPayment(null, paymentDetails[i]);
                }
            </c:if>
        });

        function addNewInstallmentPayment(sender, row){
            //更新比率
            if(row && row.amount)
                row.bl = ((parseFloat(row.amount)/sumAmount) * 100).toFixed(2);
            var tpl= $("#paymentTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            var idx = 0;
            if($("#payment-body").data("idx")){
                idx = parseInt($("#payment-body").data("idx"));
            }
            if(sender) {
                var self = $(sender);
                var selfRow = self.closest('.row');
                selfRow.after(Mustache.render(tpl, {idx: idx, row: row}));
            } else{
                $("#payment-body").append(Mustache.render(tpl, {idx: idx, row: row}));
            }

            $("input[name='purchaseOrderFinanceList["+ idx +"].payMethod']").change(function () {
                var index = $(this).closest('.row').data("idx");
                var val = $(this).val();
                if(this.checked && val == "3"){
                    $("#div-activeData_"+index).show();
                } else {
                    $("#div-activeData_"+index).hide();
                }
            });
            $("#payment-body .row[data-idx='"+idx+"']").find("select").each(function () {
                if($(this).attr("data-value"))
                    $(this).val($(this).attr("data-value"));
                else
                    $(this).val(0);
            });


            $("#payment-body .row[data-idx='"+idx+"']").find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });

            if(row && row.payMethod == "3"){
                $("#div-activeData_"+ idx).show();
            }

            //如果已付款,设置为只读
            if(row && row.status && row.status==2){
                $("#payment-body .row[data-idx='"+idx+"']").find("input").attr("readonly", "readonly");
                $("#payment-body .row[data-idx='"+idx+"']").find("select").attr("onfocus", "this.defaultIndex=this.selectedIndex;");
                $("#payment-body .row[data-idx='"+idx+"']").find("select").attr("onchange", "this.selectedIndex=this.defaultIndex;");
                $("#payment-body .row[data-idx='"+idx+"']").find(".div-pay").css("background","#f5cccc");
                $("#payment-body .row[data-idx='"+idx+"']").find("a[id$='btnDelete']").remove();
            }

            idx = idx+1;
            $("#payment-body").data("idx",idx);
        }

        function deleteInstallmentPayment(sender){
            var self = $(sender);
            var rowCount = $("#payment-body .row").length;
            if(rowCount>1){
                var row = self.closest('.row');
                var id = row.find("input[id$='"+ row.prop("id") +"_id']").val();
                if(id && id.length>0)
                    row.hide();
                else
                    row.remove();
            }
        }

        function updateRll(){
            var rll = 0 ;
            var paymentPointNum = $('#paymentPointnum').val();
            if(!paymentPointNum || paymentPointNum.length==0) return;
            var timeFields = $("#payment-body").find("input[id$='_zq']");
            if(timeFields.length > 0 ){
                $.each(timeFields, function (idx,item) {
                   var time = $(item).val();
                    if(time && time.length > 0 && parseFloat(time)>0){
                        rll = rll +  parseFloat(paymentPointNum) /parseFloat(time);
                    }
                });
            }
            if(parseFloat(paymentPointNum) > ${dayRate}){
            	$('#paymentPointnum').css("color","red");
            }
            else{
            	$('#paymentPointnum').css("color","black");
            }
            

            $("#rll").html(rll.toFixed(2));
        }

        function updatePayment(sender){
            if(!sumAmount) return;

            var row = $(sender).closest('.row');
            var amountField = row.find("input[id$='_amount']");
            var blField = row.find("input[id$='bl']")

            if($(sender).prop("id").indexOf("_amount")>=0){
                blField.val(((parseFloat(amountField.val())/sumAmount) * 100).toFixed(2));
            } else{
                amountField.val((sumAmount * ((parseFloat(blField.val()))/100)).toFixed(2));
            }
        }
    </script>

			<hr>

			<!--发货信息-->
			<h4 style="padding-left: 15px;">发货信息</h4>
			<div class="row">
				<div class="form-group">
					<div class="col-xs-3">预计到货时间 :</div>
					<div class="col-xs-4">
					<form:input path="shipDate" htmlEscape="false" maxlength="255"
						class="form-control required input-sm"
						 />
					
					</div>
					<div class="col-xs-1">天</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group">
					<div class="col-xs-3">收货方 :</div>
					<div class="col-xs-4">
					<form:select path="addressType"
						class="form-control required input-sm">
						<form:option value="" label="" />
						<form:options items="${fns:getDictList('oa_po_address_type')}"
							itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
					</div>
				</div>
			</div>
			<div class="row" id="div_address" style="display: none;">
				<div class="col-xs-12 form-group">
					地址&nbsp;&nbsp; :
					<form:input path="address" htmlEscape="false" maxlength="255"
						class="form-control required input-sm"
						cssStyle="display:inline;width: 300px;" />
				</div>
			</div>
			<script>
        $(function(){
            $("#addressType").change(function(){
                var sVal = $('#addressType').val();
                switch (sVal){
                    case "2":
                            if(parent.getShipAddress)
                            $("#address").val(parent.getShipAddress());
                            $("#div_address").show();
                        break;
                    default:
                         $("#address").val("");
                        $("#div_address").hide();
                        break;
                }
            });
            $("#addressType").trigger("change");
        });
    </script>

			<hr>

			<!--备注信息 -->
			<h4 style="padding-left:15px;">备注</h4>
			<div class="row">
				<div class="form-group col-xs-10">
				<form:input path="remark" htmlEscape="false" maxlength="255"
					class="form-control input-sm" />
				</div>
			</div>

			<div class="row pull-right m-r-10">
				<input id="btnCancel" class="btn btn-inverse" type="button" value="取 消"
					onclick="if(parent.openOrClosePOPanel)parent.openOrClosePOPanel();" />
				<shiro:hasPermission name="oa:purchaseOrder:edit">
					<input id="btnSubmit" class="btn btn-info" type="submit"
						value="保 存" />&nbsp;</shiro:hasPermission>
			</div>
		</form:form>
	</div>
</body>
</html>