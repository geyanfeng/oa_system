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
    </style>
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
<form:form id="inputForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/save" method="post" >
    <form:hidden path="id"/>
    <sys:message content="${message}"/>
    <div class="form-inline">
        <table class="table table-condensed" id="table_po_products">
            <tbody>
            <tr>
                <td>主机</td>
                <td class="form-inline"><input type="text" class="input-sm form-control" style="width:100px; display:inline-block">台</td>
                <td class="form-inline"><input type="text" class="input-sm form-control"  style="width:100px;display:inline-block">元</td>
            </tr>
            <tr>
                <td>主机</td>
                <td class="form-inline"><input type="text" class="input-sm form-control"  style="width:100px;display:inline-block">台</td>
                <td class="form-inline"><input type="text" class="input-sm form-control"  style="width:100px;display:inline-block">元</td>
            </tr>
            </tbody>
        </table>
    </div>

    <hr>

    <div class="row form-inline">
        <div class="form-group">
            <label class="control-label">供应商：</label>
                <form:select path="supplier.id" class="form-control required input-sm" id="supplier" cssStyle="width:300px">
                    <form:option value="" label=""/>
                    <form:options items="${supplierList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false"/>
                </form:select>
            <a href="#" onclick="addSupplier(this)" title="新增供应商" class="zmdi zmdi-plus-circle text-success" style="margin-left:10px;font-size:25px;"></a>
        </div>
    </div>

</form:form>
</div>
</body>
</html>