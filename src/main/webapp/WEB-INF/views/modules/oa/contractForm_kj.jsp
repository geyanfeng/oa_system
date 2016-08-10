<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>合同管理</title>
    <meta name="decorator" content="default"/>
    <style>
        #payment-collapse .row .form-group{
            margin-left:20px;
        }

        .row.form-inline{
            margin-bottom:10px;
        }
        .row.form-inline .form-group{
            margin-left:20px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                rules: {
                    name: {remote: "${ctx}/oa/contract/checkName?oldName=" + encodeURIComponent('${contract.name}')}
                },
                messages: {
                    name: {remote: "合同名称已存在"}
                },
                submitHandler: function (form) {
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
                }
            });
            //changeContractType();//如果从合同列表中新合同时, 初始化时加载合同类型

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

            //清除modal中的内容
            $('#modal').on('hidden.bs.modal', function(){
                $(this).find('iframe').html("");
                $(this).find('iframe').attr("src", "");
            });
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
            window.location.replace("${ctx}/oa/contract/form?contractType="+contractType_value);
        }

        //更改客户
        function changeCustomer(sender) {
            var self = $(sender);
            $('#invoiceCustomerName').val(self.select2('data').text);
        }


        //增加客户
        function addCustomer(sender){
            var frameSrc = "${ctx}/oa/customer/form?fromModal=1";
            $('#modal iframe').attr("src", frameSrc);
            $('#modal .modal-title').html('增加客户');
            $('#modal').modal({show: true, backdrop: 'static'});
        }

        //关闭增加
        function closeCustomerModal(){
            $('#modal').modal('hide');
            $.get('${ctx}/oa/customer/treeData',function(data){
                $('#customer').children().remove();
                $("#customer").append("<option value='' selected='selected'></option>");
                $.each(data,function(idx, item){
                    $("#customer").append("<option value='"+item.id+"'>"+item.name+"</option>");
                });
            });
        }
    </script>
</head>
<body>
<%--<ul class="nav nav-tabs">
    <li><a href="${ctx}/oa/contract/">合同列表</a></li>
    <li class="active"><a href="${ctx}/oa/contract/form?id=${contract.id}">合同<shiro:hasPermission name="oa:contract:edit">${not empty contract.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="oa:contract:edit">查看</shiro:lacksPermission></a></li>
</ul><br/>--%>

<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/save" method="post" role="form">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>
<div class="col-sm-12">

    <!--合同信息-->
    <div class="panel panel-default">
        <div class="panel-heading">合同信息
            <div class="pull-right">
                <a data-toggle="collapse" href="#card-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div>
        </div>
        <div class="panel-body panel-collapse collapse in" id="card-collapse">
            <div class="row form-inline">
                <div class="form-group">
                    <label class="control-label"><span class="help-inline"><font
                            color="red">*</font> </span>合同类型：</label>
                    <form:select path="contractType" class="form-control required input-sm"
                                 onchange="changeContractType()" cssStyle="width:200px;">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('oa_contract_type')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
                <div class="form-group ">
                    <label class="control-label"><span class="help-inline"><font
                            color="red">*</font> </span>客&nbsp;&nbsp;户：</label>
                    <form:select path="customer.id" class="form-control required input-sm" cssStyle="width:200px;"
                                 id="customer"
                                 onchange="changeCustomer(this)">
                        <form:option value="" label=""/>
                        <form:options items="${customerList}" itemLabel="name"
                                      itemValue="id" htmlEscape="false"  />
                    </form:select>
                    <a href="#" onclick="addCustomer(this)" title="新增客户" class="zmdi zmdi-plus-circle text-success" style="margin-left:10px;font-size:25px;"></a>
                </div>
                <div class="form-group ">
                    <label class="control-label"><span class="help-inline"><font
                            color="red">*</font> </span>我司抬头：</label>
                    <form:select path="companyName" class="form-control required input-sm"  cssStyle="width:200px;">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('oa_company_name')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
                <div class="form-group ">
                    <label class="control-label"><span class="help-inline"><font
                            color="red">*</font> </span>有效期：</label>
                    <input name="expiryDate" type="text" readonly="readonly" maxlength="20"  cssStyle="width:200px;"
                           class="form-control Wdate required input-sm"
                           value="<fmt:formatDate value="${contract.expiryDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

                </div>
               <%-- <div class="form-group ">
                    <label class="control-label" for="no"><span class="help-inline"><font
                            color="red">*</font> </span>合同号：</label>
                    <form:input path="no" htmlEscape="false" maxlength="100"
                                class="form-control required input-sm"  cssStyle="width:200px;"/>
                </div>
                <div class="form-group ">
                    <label class="control-label"><span class="help-inline"><font color="red">*</font> </span>合同名称：</label>
                    <form:input path="name" htmlEscape="false" maxlength="255"
                                class="form-control required input-sm"  cssStyle="width:200px;"/>
                </div>

            </div>--%>
        </div>

    </div>
    </div>

    <!--开票信息-->
    <div class="panel panel-default">
        <div class="panel-heading">开票信息
            <div class="pull-right">
                <a data-toggle="collapse" href="#invoice-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div>
        </div>
        <div class="panel-body form-horizontal" id="invoice-collapse">
            <div class="col-sm-6">
                <div class="form-group clearfix">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>发票类型：</label>
                    <div class="col-sm-7">
                        <form:radiobuttons path="invoiceType" items="${fns:getDictList('oa_invoice_type')}"
                                           itemLabel="label" itemValue="value" htmlEscape="false" class=""
                                           element="span class='radio radio-success radio-inline'"/>
                    </div>
                </div>
                <div class="form-group clearfix" id="field-invoiceCustomerName">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>发票客户名称：</label>
                    <div class="col-sm-7">
                        <form:input path="invoiceCustomerName" htmlEscape="false" maxlength="255"
                                    class="form-control input-sm required"/>
                    </div>
                </div>
                <div class="form-group clearfix" id="field-invoiceNo">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>发票税务登记号：</label>
                    <div class="col-sm-7">
                        <form:input path="invoiceNo" htmlEscape="false" maxlength="255"
                                    class="form-control input-sm required"/>
                    </div>
                </div>
                <div class="form-group clearfix" id="field-invoiceBank">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>开户行：</label>
                    <div class="col-sm-7">
                        <form:input path="invoiceBank" htmlEscape="false" maxlength="255"
                                    class="form-control input-sm required"/>
                    </div>
                </div>
                <div class="form-group clearfix" id="field-invoiceBankNo">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>银行帐号：</label>
                    <div class="col-sm-7">
                        <form:input path="invoiceBankNo" htmlEscape="false" maxlength="255"
                                    class="form-control input-sm required"/>
                    </div>
                </div>
                <div class="form-group clearfix" id="field-invoiceAddress">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>地址：</label>
                    <div class="col-sm-7">
                        <form:input path="invoiceAddress" htmlEscape="false" maxlength="1000"
                                    class="form-control input-sm required"/>
                    </div>
                </div>
                <div class="form-group clearfix" id="field-invoicePhone">
                    <label class="col-sm-3 control-label"><span class="help-inline"><font color="red">*</font> </span>电话：</label>
                    <div class="col-sm-7">
                        <form:input path="invoicePhone" htmlEscape="false" maxlength="100"
                                    class="form-control input-sm required"/>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!--附件-->
    <div class="panel panel-default" id="card_attachemnts">
        <div class="panel-heading">附件</div>
        <div class="panel-body">
            <table id="attchmentTable" class="table table-striped table-condensed">
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
                            <input id="contractAttachmentList${status.index}_id"
                                   name="contractAttachmentList[${status.index}].id" type="hidden"
                                   value="${attachment.id}"/>
                        </td>
                        <td>
                                ${fns:getDictLabel(attachment.type, 'oa_contract_attachment_type', '')}
                            <a href="#" title="上传文档" class="zmdi zmdi-upload pull-right"
                               onclick="files${status.index}FinderOpen();"></a>
                            <input id="contractAttachmentList${status.index}_type"
                                   name="contractAttachmentList[${status.index}].type" type="hidden"
                                   value="${attachment.type}"/>
                        </td>
                        <td>
                            <form:hidden id="files${status.index}"
                                         path="contractAttachmentList[${status.index}].files" htmlEscape="false"
                                         maxlength="2000" class="form-control"/>
                            <sys:myckfinder input="files${status.index}" type="files" uploadPath="/oa/contract"
                                            selectMultiple="true"/>
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

    <!--备注-->
    <div class="panel panel-default" id="card_other">
        <div class="panel-heading">备注</div>
        <div class="panel-body">
            <div class="form-group clearfix">
                <div class="col-sm-12">
                    <form:textarea path="remark" htmlEscape="false" maxlength="255"
                                   class="form-control"/>
                </div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="col-sm-offset-4 col-sm-8">

            <shiro:hasPermission name="oa:contract:edit"><input id="btnSubmit"
                                                                class="btn btn-primary waves-effect waves-light"
                                                                type="submit"
                                                                value="保 存"/>&nbsp;
            </shiro:hasPermission>

            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </div>
    </form:form>

    <div id="modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <iframe width="100%" height="500" frameborder="0"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>