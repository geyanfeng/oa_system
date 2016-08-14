<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>采购订单管理</title>
    <meta name="decorator" content="default"/>
    <style>
        html, body{
            background: white;
        }
        #table_po_products>tbody>tr>td{
            border: 1px solid transparent !important;
        }

        hr{
            margin-left: -15px;
            margin-right: -15px;
            margin-top:10px;
            margin-bottom:10px;
        }
        h4{
            margin-right: -15px;
        }
        .row{
            margin-top:5px;
            padding-left: 15px;
        }
    </style>
    <link href="${ctxStatic}/assets/plugins/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.min.css" rel="stylesheet" />
    <script src="${ctxStatic}/assets/plugins/bootstrap-touchspin/dist/jquery.bootstrap-touchspin.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/assets/js/jquery.form.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            //$("#name").focus();
            $("#inputForm").validate({
               /* submitHandler: function(form){
                    loading('正在提交，请稍等...');
                    form.submit();
                },*/
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

            $("#inputForm").ajaxForm({success:function(result){
                var status= result.status;
                if(status!="1") return;
                if(parent.closeCustomerModal)
                    parent.closeCustomerModal(result.data);
            }, beforeSubmit: function () {
                $("#paymentDetail").val(JSON.stringify(getPaymentDetail()));
            }});
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
            if(!parent.getModal)return;
            var modal = parent.getModal();
            modal.find('iframe').attr("src", frameSrc);
            modal.find('.modal-title').html('增加供应商');
            modal.modal({show: true, backdrop: 'static'});
        }

        //关闭增加
        function closeSupplierModal(supplier){
            if(!parent.getModal)return;
            var modal = parent.getModal();
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
<div class="container">
<form:form id="inputForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/ajaxSave" method="post" >
    <form:hidden path="id"/>
    <form:hidden path="contract.id"/>
    <sys:message content="${message}"/>
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
							<td>
								<input  id="purchaseOrderProductList{{idx}}_name" name="purchaseOrderProductList[{{idx}}].name" type="hidden" value="{{row.name}}" maxlength="100" class="form-control required input-sm"  style="display: inline-block;"/>
								{{row.name}}
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_num" name="purchaseOrderProductList[{{idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control number input-block required input-sm" onchange="updatePriceAmount(this);" style="display:inline-block"/>
							</td>
							<td>
							    {{row.unitName}}
								<input id="purchaseOrderProductList{{idx}}_unit" name="purchaseOrderProductList[{{idx}}].unit" type="hidden" value="{{row.unitId}}"/>
							</td>
							<td>
								<input id="purchaseOrderProductList{{idx}}_price" name="purchaseOrderProductList[{{idx}}].price" type="text" value="{{row.price}}" class="form-control number input-block required input-sm" onchange="updatePriceAmount(this);" style="display:inline-block"/>
							</td>
							<td>元</td>
							<shiro:hasPermission name="oa:contract:edit"><td class="text-center" width="10">
								{{#delBtn}}<a href="#" class="on-default remove-row" onclick="delRow(this, '#purchaseOrderProductList{{idx}}', '{{row.contractProductId}}')"  title="删除"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>
						//-->
        </script>
        <script type="text/javascript">
            var poProductRowIdx = 0, poProductTpl = $("#poProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            $(document).ready(function () {
                var data = ${fns:toJson(contract.purchaseOrderProductList)};
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
                $(list + idx).find("input[name$='.num'],input[name$='.price']").TouchSpin({
                    buttondown_class: "btn btn-custom",
                    buttonup_class: "btn btn-custom",
                    max:100000000000
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
                    num: data.num,
                    unit: data.unit,
                    unitName: $.trim(data.unitName),
                    maxNum: data.maxNum
                }
                addRow('#purchaseOrderProductList', poProductRowIdx, poProductTpl, row);
                poProductRowIdx = poProductRowIdx + 1;
            }

            function removeProduct(id){
                var deleteRow = $("#purchaseOrderProductList tr[data-contractProductId='"+id+"']");
                deleteRow.remove();
            }

            function updatePriceAmount(){}
        </script>
    </div>

    <hr>

    <!--供应商-->
    <div class="row">
            供应商：
            <form:select path="supplier.id" class="form-control required input-sm" id="supplier" cssStyle="width:300px;">
                <form:option value="" label=""/>
                <form:options items="${supplierList}" itemLabel="name"
                              itemValue="id" htmlEscape="false"/>
            </form:select>
            <a href="#" onclick="addSupplier(this)" title="新增供应商" class="zmdi zmdi-plus-circle text-success" style="margin-left:10px;font-size:25px;"></a>
    </div>

    <hr>

    <!--付款信息-->
    <h4>付款信息</h4>
    <form:hidden path="paymentDetail"/>
    <div id="payment-body" data-idx="1"></div>

    <div class="row">
     帐期点数:&nbsp;
        <form:input path="paymentPointnum" htmlEscape="false" maxlength="255" class="form-control required input-sm" cssStyle="width:100px; display:inline;" onchange="updateRll();"/>
    </div>

    <div class="row">
        帐期日利率:
        <span id="rll"></span>
    </div>
    <script type="text/template" id="paymentTpl">//<!--
    <div class="row" style=" margin-left:-10px; margin-top:10px;" id="payment-installment_{{idx}}">
        <div style="background: #f5f5f5;width:80%;float:left; padding: 10px;">
            <div>
            付款金额：
                    <input type="text" class="form-control required number input-sm" id="payment_installment_amount_{{idx}}"
                           value="{{row.payment_installment_amount}}" style="display: inline;width:100px;"/>
            账期：
                    <input id="payment_installment_time_{{idx}}" type="text" class="form-control required number input-sm"
                           value="{{row.payment_installment_time}}" style="display: inline;width:100px;" onchange="updateRll()"/>
            </div>
            <div style="padding-top: 10px;">
                <span style="margin-right:17px;">付款方式：</span>
                <c:forEach items="${fns:getDictList('oa_payment_method')}" var="dict" varStatus="s">
                                    <span class="radio radio-success radio-inline" style="padding-left:2px">
                                        <input id="payment_installment_paymentMethod_{{idx}}_${s.index+1}" name="payment_installment_paymentMethod_{{idx}}" type="radio"
                                               value="${dict.value}" data-value="{{row.payment_installment_paymentMethod}}" ${s.index eq 0? "checked":""}>
                                        <label for="payment_installment_paymentMethod_{{idx}}_${s.index+1}">${dict.label}</label>
                                    </span>
                    </c:forEach>
            </div>
        </div>
        <div class="pull-right">
            <a href="#" onclick="addNewInstallmentPayment(this)" title="增加新的分期付款" class="zmdi zmdi-plus-circle text-success" style="font-size:25px;"></a>
            <a href="#" onclick="deleteInstallmentPayment(this)" title="删除" class="zmdi zmdi-minus-square text-success" style="font-size:25px;"></a>
        </div>
    </div>
    //-->
    </script>
    <script>
        $(function(){
            addNewInstallmentPayment();

            $("#btnSubmit").click(function () {
                $("#paymentDetail").val(JSON.stringify(getPaymentDetail()));
            });
        });

        function addNewInstallmentPayment(sender){
            var tpl= $("#paymentTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            var idx=1;
            if(sender) {
                var self = $(sender);
                var selfRow = self.closest('.row');
                idx = parseInt($("#payment-body").data("idx"));
                selfRow.after(Mustache.render(tpl, {idx: idx}));
            } else{
                $("#payment-body").append(Mustache.render(tpl, {idx: 1}));
            }
            idx = idx+1;
            $("#payment-body").data("idx",idx);
        }

        function deleteInstallmentPayment(sender){
            var self = $(sender);
            var rowCount = $("#payment-body .row").length;
            if(rowCount>1)
                self.closest('.row').remove();
        }

        function updateRll(){
            var rll = 0 ;
            var paymentPointNum = $('#paymentPointnum').val();
            if(!paymentPointNum || paymentPointNum.length==0) return;
            var timeFields = $("input[id^='payment_installment_time']");
            if(timeFields.length > 0 ){
                $.each(timeFields, function (idx,item) {
                   var time = $(item).val();
                    if(time && time.length > 0){
                        rll = rll +  parseInt(paymentPointNum) /parseInt(time);
                    }
                });
            }

            $("#rll").html(rll.toFixed(2));
        }

        function getPaymentDetail() {
            var paymentDetail =[];
            $(".row[id^='payment-installment']").each(function(index, item){
                var row = $(item);
                paymentDetail.push({
                    payment_installment_amount: row.find("input[id^='payment_installment_amount']").val(),
                    payment_installment_time :row.find("input[id^='payment_installment_time']").val(),
                    payment_installment_paymentMethod :row.find("input[id^='payment_installment_paymentMethod']:checked").val(),
                });
            });
            return paymentDetail;
        }
    </script>

    <hr>

    <!--发货信息-->
    <h4>发货信息</h4>
    <div class="row">
        预计到货时间 :
       <form:input path="shipDate" htmlEscape="false" maxlength="255" class="form-control required input-sm" cssStyle="width:100px; display:inline;"/>
        天
    </div>
    <div class="row">
        收货方 :&nbsp;&nbsp;&nbsp;
        <form:select path="companyName" class="form-control required input-sm" cssStyle="width:300px;">
            <form:option value="" label=""/>
            <form:options items="${fns:getDictList('oa_company_name')}" itemLabel="label"
                          itemValue="value" htmlEscape="false"/>
        </form:select>
    </div>

    <hr>
    <!--备注信息 -->
     <h4>备注</h4>
    <form:input path="remark" htmlEscape="false" maxlength="255" class="form-control input-sm"/>

    <div class="row pull-right">
        <input id="btnCancel" class="btn" type="button" value="取 消" onclick=""/>
        <shiro:hasPermission name="oa:purchaseOrder:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
    </div>
</form:form>
</div>
</body>
</html>