<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>销售奖金调整确认</title>
    <meta name="decorator" content="default" />
    <style>
        /*.form-group, label, input[type=text],input[type=number], .col-sm-5 {
            padding: 0px !important;
        }*/

        .modal input{
            width: 100px !important;
        }
        .modal .row{
            margin-top:10px;
        }
        .modal .row .form-group:not(:first-child){
            margin-left:40px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(
                function() {
                    $("select").select2({ allowClear: true});
                    $("#btnExport").click(
                            function() {
                                top.$.jBox.confirm("确认要导出合同列表吗？", "系统提示", function(
                                        v, h, f) {
                                    if (v == "ok") {
                                        $("#searchForm").attr("action",
                                                "${ctx}/oa/contract/export");
                                        $("#searchForm").submit();
                                    }
                                }, {
                                    buttonsFocus : 1
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
    </script>
</head>
<body>
<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">
    销售奖金调整确认
</h2>
<div class="panel panel-default">
    <div class="panel-body">
        <form:form id="searchForm" modelAttribute="contract"
                   action="${ctx}/oa/oaCommission/editList" method="post"
                   class="breadcrumb form-search form-inline">
            <input id="pageNo" name="pageNo" type="hidden"
                   value="${page.pageNo}" />
            <input id="pageSize" name="pageSize" type="hidden"
                   value="${page.pageSize}" />
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}"
                           callback="page();" />
            <!--过滤条件-->
            <div class="form-group m-r-10">
                <label>日期：</label>
                <div class="input-group">
                    <input name="beginCreateDate" type="text" readonly maxlength="20"
                           class="form-control" size="10"
                           value="<fmt:formatDate value="${contract.beginCreateDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                </div>


                <div class="input-group">
                    <input name="endCreateDate" type="text" readonly maxlength="20"
                           class="form-control" size="10"
                           value="<fmt:formatDate value="${contract.endCreateDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
						<span class="input-group-addon bg-custom b-0 text-white"><i
                                class="ti-calendar"></i></span>
                </div>
            </div>
            <div class="form-group m-r-10">
                <label>销售：</label>
                <form:select path="createBy.id" class="input-small form-control" id="createBy"
                             cssStyle="width: 150px">
                    <form:option value="" label="" />
                    <form:options items="${salerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false" />
                </form:select>

            </div>
            <div class="form-group m-r-10">
                <label>客户：</label>

                    <%--<sys:treeselect id="customer" name="customer.id" value="${contract.customer.id}"
                                labelName="customer.name" labelValue="${contract.customer.name}"
                                title="客户" url="/oa/customer/treeData" cssClass="input-small input-sm"
                                allowClear="true" notAllowSelectParent="true" buttonIconCss="input-sm"/>--%>
                <form:select path="customer.id" class="input-small form-control"
                             id="customer" cssStyle="width: 150px">
                    <form:option value="" label="" />
                    <form:options items="${customerList}" itemLabel="name"
                                  itemValue="id" htmlEscape="false" />
                </form:select>

            </div>


            <div class="form-group">
                <button id="btnSubmit" class="btn btn-custom" type="submit"
                        value="查询">
                    筛&nbsp;&nbsp;选</button>
            </div>
        </form:form>
        <sys:message content="${message}" />
        <table id="contentTable"
               class="table table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th class="sort-column no">合同编号</th>
                <th class="sort-column a9.name">客户</th>
                <th class="sort-column name">合同名称</th>
                <th class="sort-column customerCost">销售奖金</th>
                <th class="sort-column stockInAmount">滞库金额</th>
                <th class="sort-column returningAmount">退货费用</th>
                <th class="sort-column discount">额外费用</th>
                <th class="sort-column performancePercentage">业绩分成比例(%)</th>
                <th>小计</th>
                <%-- <th>更新时间</th>--%>
                <shiro:hasPermission name="oa:contract:edit">
                    <th>操作</th>
                </shiro:hasPermission>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="contract">
                <tr>
                    <input type="hidden" value="${contract.id}"/>
                    <td><a href="${ctx}/oa/contract/view?id=${contract.id}">
                            ${contract.no} </a></td>
                    <td>${contract.customer.name}</td>
                    <td>${contract.name}</td>
                    <td><fmt:formatNumber type="number" value="${contract.customerCost}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${contract.stockInAmount}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${contract.returningAmount}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${contract.discount}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${contract.performancePercentage}" maxFractionDigits="2" /></td>
                    <td><fmt:formatNumber type="number" value="${(empty contract.customerCost?0:contract.customerCost) + (empty contract.stockInAmount?0:contract.stockInAmount) + (empty contract.returningAmount?0:contract.returningAmount) + (empty contract.discount?0:contract.discount)}" maxFractionDigits="2" /></td>

                    <td><shiro:hasPermission name="oa:oaCommission:edit">
                            <a href="javascript:void(0)" title="编辑"><i
                                    class="fa fa-pencil m-r-5"></i></a>
                            <a href="javascript:void(0)" title="查看"><i
                                    class="fa fa-file-text"></i></a>
                    </shiro:hasPermission> </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        ${page}
    </div>
</div>


<div id="modal-edit" class="modal fade" tabindex="-1"
     role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
     style="display: none;">
    <div class="modal-dialog" style="width:550px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">×
                </button>
                <h4 class="modal-title">编辑</h4>
            </div>
            <div class="modal-body">
            	<div class="col-sm-12 m-b-20">
                <div class="row form-inline">
                    <div class="form-group">
                        <label class="control-label">销售奖金:</label>
                        <input id="customerCost" type="number" class="form-control">
                    </div>
                </div>

                <div id="div-bonus_record">

                </div>

                <hr/>
                <div class="row form-inline">
                    <div class="form-group">
                        <label class="control-label">滞库金额:</label>
                        <input id="stockInAmount" type="number" class="form-control">
                    </div>

                    <div class="form-group">
                        <label class="control-label">退货费用:</label>
                        <input id="returningAmount" type="number" class="form-control">
                    </div>
                </div>
                <div class="row form-inline">
                    <div class="form-group">
                        <label class="control-label">额外费用:</label>
                        <input id="discount" type="number" class="form-control">
                    </div>

                    <div class="form-group">
                        <label class="control-label">业绩分成比例:</label>
                        <input id="performancePercentage" type="number" class="form-control"> %
                    </div>
                </div>
				</div>
            </div>
            <div class="text-center">
                <button type="button" class="btn btn-inverse" data-dismiss="modal">返回</button>
                <button type="button" class="btn btn-custom" id="modal-btnSubmit">确认
                </button>
            </div>
        </div>
    </div>
    <script type="text/template" id="tpl-bonus-edit">//<!--
            <div class="row form-inline">
                    <div class="form-group">
                        <label class="control-label">奖金金额:</label>
                        <input name="bonus" type="number" class="form-control" value="{{row.bonus}}">
                    </div>
                    <div class="form-group">
                        <label class="control-label">发放日期:</label>
                        <div class="input-group">
                            <input name="bonusDate" id="bonusDate_{{idx}}" type="text" readonly="readonly" class="form-control" value="{{row.bonusDate}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                            <span class="input-group-addon bg-custom b-0 text-white"  onclick="WdatePicker({el:'bonusDate_{{idx}}',dateFmt:'yyyy-MM-dd',isShowClear:false});"><i class="ti-calendar"></i></span>
                        </div>
                    </div>
                    <div class="form-group pull-right">
  				   		<a href="javascript:void(0);" onclick="addNewBonusRecord(this);" title="增加" class="zmdi zmdi-plus-circle text-custom" style="font-size:24px;"></a>
                   		<a href="javascript:void(0);" onclick="deleteBonusRecord(this);" title="删除" class="zmdi zmdi-minus-circle text-custom" style="font-size:24px;"></a>
                    </div>
                </div>
    //-->
    </script>
    <script>
        $(function(){
            //显示编辑页面
            $("#contentTable tbody tr").find("td:last").find("a:first").click(function(e){
                var row = $(this).closest("tr");
                var modal = $('#modal-edit');
                modal.modal({
                    show : true,
                    backdrop : 'static'
                });
                var e = window.event || arguments.callee.caller.arguments[0];
                var top = e.clientY;
                modal.css('top',top>200 ? (top-200): top );

                var contractId = row.find("input:hidden").val(),
                        customerCost =  row.find("td:eq(3)").html(),
                        stockInAmount =  row.find("td:eq(4)").html(),
                        returningAmount =  row.find("td:eq(5)").html(),
                        discount =  row.find("td:eq(6)").html(),
                        performancePercentage =  row.find("td:eq(7)").html();
                customerCost = customerCost.length>0? parseFloat(customerCost.replace(new RegExp(",","g"),"")):0;
                stockInAmount = stockInAmount.length>0? parseFloat(stockInAmount.replace(new RegExp(",","g"),"")):0;
                returningAmount = returningAmount.length>0? parseFloat(returningAmount.replace(new RegExp(",","g"),"")):0;
                discount = discount.length>0? parseFloat(discount.replace(new RegExp(",","g"),"")):0;
                performancePercentage = performancePercentage.length>0? parseFloat(performancePercentage.replace(new RegExp(",","g"),"")):0;
                modal.find("#customerCost").val(customerCost);
                modal.find("#stockInAmount").val(stockInAmount);
                modal.find("#returningAmount").val(returningAmount);
                modal.find("#discount").val(discount);
                modal.find("#performancePercentage").val(performancePercentage);

                //清空记录
                $("#div-bonus_record").children().remove();
                //加载已经保存的资金发放记录
                $.getJSON("${ctx}/oa/oaCommission/contract/"+contractId+"/bonusRecord", function(result){
                    if(result && result.length>0){
                        $.each(result, function(idx, item){
                            addNewBonusRecord(null, item);
                        });
                    } else{
                        addNewBonusRecord();
                    }
                });

                //删除保存事件
                modal.find("#modal-btnSubmit").unbind("click");
                //保存
                modal.find("#modal-btnSubmit").click(function(){
                    var submitButton = $(this);
                    submitButton.attr('disabled',"true");
                    loading('正在提交，请稍等...');

                    var data = {
                        customerCost: modal.find("#customerCost").val(),
                        stockInAmount: modal.find("#stockInAmount").val(),
                        returningAmount: modal.find("#returningAmount").val(),
                        discount: modal.find("#discount").val(),
                        performancePercentage: modal.find("#performancePercentage").val(),
                        bonusRecords :[]
                    };
                    modal.find("#div-bonus_record .row").each(function(){
                        var self = $(this);
                        data.bonusRecords.push({
                            contract_id :contractId,
                            bonus : self.find("input[name='bonus']").val(),
                            bonusDate: self.find("input[name='bonusDate']").val()
                        });
                    });

                    $.ajax({
                        type: 'POST',
                        url: "${ctx}/oa/oaCommission/contract/"+contractId,
                        contentType: "application/json;",
                        data: JSON.stringify(data),
                        success: function(data){
                            showTipMsg(data)
                            modal.modal('hide');
                            submitButton.removeAttr("disabled");
                            closeLoading();
                            location.reload();
                        }
                    });
                });

                //判断是否可以编辑
                $.get("${ctx}/oa/oaCommission/status/contract/"+contractId, function(result){
                    if(result!=="1"){
                        modal.find("#customerCost").prop('disabled', true);
                        modal.find("#stockInAmount").prop('disabled', true);
                        modal.find("#returningAmount").prop('disabled', true);
                        modal.find("#discount").prop('disabled', true);
                        modal.find("#performancePercentage").prop('disabled', true);
                    } else{
                        modal.find("#customerCost").prop('disabled', false);
                        modal.find("#stockInAmount").prop('disabled', false);
                        modal.find("#returningAmount").prop('disabled', false);
                        modal.find("#discount").prop('disabled', false);
                        modal.find("#performancePercentage").prop('disabled', false);
                    }
                });
            });
        });

        function addNewBonusRecord(sender, row){
            var idx = $("#div-bonus_record").data("idx");
            if(!idx)
                idx = 0;
            else
                idx  = parseInt(idx);
            if(sender) {
                var self = $(sender);
                var selfRow = self.closest('.row');
                selfRow.after(Mustache.render($("#tpl-bonus-edit").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),{ row: row, idx: idx + 1 }));
            } else{
               $("#div-bonus_record").append(Mustache.render($("#tpl-bonus-edit").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),{ row: row,  idx: idx + 1  }));
            }
            $("#div-bonus_record").data("idx", idx + 1);
        }

        function deleteBonusRecord(sender){
            var self = $(sender);
            var rowCount = $("#div-bonus_record .row").length;
            if(rowCount>1)
                self.closest('.row').remove();
        }
    </script>
</div>

<div id="modal-view" class="modal fade" tabindex="-1"
     role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
     style="display: none;">
    <div class="modal-dialog" style="width:550px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">×
                </button>
                <h4 class="modal-title">编辑</h4>
            </div>
            <div class="modal-body">
            </div>
            <div class="text-center">
                <button type="button" class="btn btn-inverse" data-dismiss="modal">关闭</button>
                </button>
            </div>
        </div>
    </div>
    <script type="text/template" id="tpl-bonus-view">//<!--
            <div class="row">
                   <div class="col-sm-6">奖金金额: {{row.bonus}}</div>
                   <div class="col-sm-6">发放日期: {{row.bonusDate}}</div>
                </div>
    //-->
    </script>
    <script>
        $(function(){
            //显示编辑页面
            $("#contentTable tbody tr").find("td:last").find("a:last").click(function(e){
                var row = $(this).closest("tr");
                var modal = $('#modal-view');
                var contractId = row.find("input:hidden").val();
                modal.modal({
                    show : true,
                    backdrop : 'static'
                });
                var top = window.event.clientY;
                modal.css('top',top>200 ? (top-200): top );

                modal.find(".modal-body").children().remove();
                //加载已经保存的资金发放记录
                $.getJSON("${ctx}/oa/oaCommission/contract/"+contractId+"/bonusRecord", function(result){
                    if(result && result.length>0){
                        $.each(result, function(idx, item){
                            modal.find(".modal-body").append(Mustache.render($("#tpl-bonus-view").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),{ row: item }));
                        });
                    }
                });
            });
        });
    </script>
</div>
</body>
</html>