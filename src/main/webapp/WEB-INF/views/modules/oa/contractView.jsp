
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>查看合同</title>
    <meta name="decorator" content="default"/>
    <style>
        .panel-body .row{
            padding: 10px;
            margin:0;
        }
        .panel-body .row:not(:last-child){
            border-bottom: 1px solid #dcdcdc;
        }
        .panel .panel-body {
        	padding:0;
        }
        .productChildTable>tbody>tr>td{
            border: 1px solid transparent !important;
        }
        .div_bill {position: absolute; right: 10px;top: 100px;z-index:1040;}
        html,body{
            background: #FFF;
        }
        /*a.anchor {
            display: block;
            position: relative;
            top: -150px;
            visibility: hidden;
        }*/
        .table tr th:nth-child(2),.table tr td:nth-child(2){
        	padding-left:20px;
        }
        .table{
        	margin-bottom:0;
        }
        th,td{text-align:left;}
        ol li{float:left;padding-right:30px;}
    </style>
    <script>
        function getModal(){
            return $('#modal');
        }

        function disableButtons(){
            $("#btnSubmit").attr("disabled","disabled");
            $("#btnUnAudit").attr("disabled","disabled");
        }

        function enableButtons(){
            $("#btnSubmit").removeAttr("disabled");
            $("#btnUnAudit").removeAttr("disabled");
        }

        $(function(){
            if(parent.mainFrame){
                if(parent.window)
                    $(parent.window).scroll( function(){
                        if(parent&& parent.window)
                            $('.navbar').css('top', parent.window.document.body.scrollTop);
                });
            }
            //清除modal中的内容
            $('#modal').on('hidden.bs.modal', function(){
                $(this).find('iframe').html("");
                $(this).find('iframe').attr("src", "");
            });


            //新建订单通过参数newpo来控制,如:contract/view?newpo=true
            if("${param.newpo}"!=""){
                openModalFromUrl("选择合同","${ctx}/oa/contract/contractSelectList?targetType=4&status=10" , true );
            }

            //编辑订单
            if("${param.po}"!="" && "${param.poid}"!=""){
                editPo("${param.poid}");
            }

            $("#inputForm").submit(function(){
                disableButtons();
            });

            $.validator.addMethod("val-comment", function(value) {
                return !($('#flag').val() === "no" && value==="");
            }, "请输入驳回信息");
            $.validator.addMethod("valiateBackAmount", function(value) {
                return valiateBackAmount();
            }, "退款金额不能大于付款金额");
            //表单验证
            $("#inputForm").validate({
                rules: {
                    <c:if test="${contract.act.taskDefKey eq 'verify_ship'}">
                    shipMode:{
                        required: true
                    },
                    </c:if>
                    "act.comment":  "val-comment",
                    backAmount:  "valiateBackAmount"
                },
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');

                    if("${contract.act.taskDefKey}" == "finish"){
                        if($("#row-attachment-1 ol li a").length == 0 || $("#row-attachment-3 ol li a").length == 0){
                            showTipMsg("请上传合同文本和签收单","error");
                            closeLoading();
                            enableButtons();
                            return;
                        }
                    }
                    form.submit();
                },
                invalidHandler: function(){
                    enableButtons();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if(element.prop("id")== 'act.comment'){
                        error.appendTo(element.closest(".panel").find(".panel-heading"));
                    }
                    else if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });

        function closeSelectContractModal(selectedContract){
            getCommonModal().modal('hide');
            window.location = "${ctx}/oa/contract/view?po=true&id="+ selectedContract.id;
        }
    </script>
</head>
<body>

<c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
    <script src="${ctxStatic}/assets/plugins/jquery-ui/jquery-ui.min.js"></script>
    <div class="col-sm-5 div_bill" id="panel_po" style="display: none;width:500px;">
        <div class="panel panel-default">
            <div class="panel-heading" style="text-align: center;"><span style="font-size:16px;">采购下单</span>
                <div class="pull-right">
                    <a href="javascript:void(0);" onClick="openOrClosePOPanel()" style="color:#797979;"><i class="glyphicon glyphicon-remove"></i></a>
                </div>
            </div>
            <div class="panel-body" style="padding:0;">
                <iframe id="poFrame" name="poFrame" scrolling="auto" frameborder="no" src="${ctx}/oa/purchaseOrder/form?contract.id=${contract.id}&fromModal=1" width="100%" height="400"></iframe>
            </div>
        </div>
    </div>
    <script>
	$(window).bind('beforeunload',function(){return '您输入的内容尚未保存，确定离开此页面吗？';});
	</script>
    <script>
        $( function() {
            //$( "#panel_po" ).draggable();
            if(parent.mainFrame){
                if(parent.window)
                    $(parent.window).scroll(  function(){
                        if(parent&& parent.window) {
                            var winHeight = $(parent.window).height(), winWidth = $(parent.window).width(), divHeight = $("#panel_po").height(), divWidth = $("#panel_po").width();
                            $("#panel_po").css('top', parent.window.document.body.scrollTop + $('.navbar').height()); //控制上下位置
                            $("#panel_po").attr('left', (winWidth - divWidth - 300 - 20)); //控制横向位置
                        }
                });
            } else{
                $(parent).scroll( function(){
                    var winHeight = $(window).height(), winWidth = $(window).width(), divHeight =  $("#panel_po").height(), divWidth = $("#panel_po").width();
                    $("#panel_po").css('top',document.body.scrollTop + $('.navbar').height()); //控制上下位置
                    $("#panel_po").attr('left',document.body.scrollLeft + (winWidth - divWidth - 20)); //控制横向位置
                });
            }
            if(parent.mainFrame) {
                if(parent.window)
                    $(parent.window).trigger('scroll');
            } else{
                $(window).trigger('scroll');
            }
        });
        //关闭采购下单panel
        function openOrClosePOPanel(){
            if($("#panel_po").is(":hidden")){
            	openPoPanel();
            }else
            	closePoPanel();
        }
        
        function closePoPanel(){
        	$("#panel_po").animate({right:'-' + $("#panel_po").width() + 'px'},'5000',function(){
        		$("#panel_po" ).fadeOut();
        	
        	});
        }

        //打开采购下单的panel
        function openPoPanel(){
        	$('#poFrame').css({'height':$(top.window).height() * 0.8 + 'px'});
        	$("#panel_po").css({'right': '-' + $("#panel_po").width() + 'px'});
        	$("#panel_po").show();
        	$("#panel_po").animate({right:'0px'},'5000');
        }
    </script>
</c:if>

<form:form id="inputForm" modelAttribute="contract" action="${ctx}/oa/contract/audit?sUrl=${sUrl}" method="post" role="form" onsubmit="$(window).unbind('beforeunload');">
<form:hidden path="id"/>
<form:hidden path="act.taskId"/>
<form:hidden path="act.taskName"/>
<form:hidden path="act.taskDefKey"/>
<form:hidden path="act.procInsId"/>
<form:hidden path="act.procDefId"/>
<form:hidden id="flag" path="act.flag"/>
<sys:message content="${message}"/>
<div id="navbar">
    <div class="collapse navbar-collapse bs-js-navbar-scrollspy">
        <ul class="nav navbar-nav">
            <li><a href="#panel-1" class="on">合同信息</a></li>
            <li><a href="#panel-2">开票信息</a></li>
            <li><a href="#panel-3">销售清单</a></li>
            <li><a href="#panel-9">采购订单列表</a></li>
            <li><a href="#panel-4">收款信息</a></li>
            <li><a href="#panel-5">收货信息</a></li>
            <li id="li-other"><a href="#panel-6">其它信息</a></li>
            <li><a href="#panel-7">附件</a></li>
            <li><a href="#panel-8">操作信息</a></li>
        </ul>
    </div>
</div>

<div class="col-sm-12">
	<div class="container">
    <div class="row m-b-20" style="margin-top: 80px !important;">
        <div class="col-sm-3">
            合同编号：${contract.no}
        </div>
        <div class="col-sm-3">
            合同名称：${contract.name}
        </div>
        <div class="pull-right">
            合同状态: <span class="label label-${fns:getDictRemark(contract.status,"oa_contract_status","warning")}" style="font-size:16px;color:#000;">${fns:getDictLabel(contract.status, "oa_contract_status","" )}</span>
        </div>
    </div>
	</div>
    <!--合同信息-->
    <a class="anchor" name="panel-1"></a>
    <div class="panel panel-default" id="panel-baseInfo">
        <div class="panel-heading"><h3 class="panel-title">合同信息
            <div class="pull-right">
                <a data-toggle="collapse" href="#card-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div>
            </h3>
        </div>
        <div class="panel-body panel-collapse collapse in" id="card-collapse">
            <div class="row">
                <div class="col-sm-3">
                    合同编号：${contract.no}
                </div>
                <div class="col-sm-3">
                    合同名称：${contract.name}
                </div>
                <div class="col-sm-3">
                    合同类别：${fns: getDictLabel(contract.contractType,"oa_contract_type","")}
                </div>
                <div class="col-sm-3">
                    父级合同：${contract.parentName}${not empty contract.parentNo? "(":""}${contract.parentNo}${not empty contract.parentNo? ")":""}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    客户名称：${contract.customer.name}
                </div>
                <div class="col-sm-6">
                    客户评分：${contract.customer.evaluate}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    创建人：${contract.createBy.name}
                </div>
                <div class="col-sm-3">
                    创建时间：<fmt:formatDate value="${contract.createDate}" pattern="yyyy-MM-dd"/>
                </div>
                <div class="col-sm-3">
                    商务协同：${contract.businessPerson.name}
                </div>
                <div class="col-sm-3">
                    <font style="color:red">技术协同：</font>
                    <c:choose>
                        <c:when test="${contract.act.taskDefKey eq 'split_po'}">
                            <form:select path="artisan.id" id="artisan"  class="form-control required" cssStyle="width:100px;">
                                <form:option value="" label="" />
                                <form:options items="${artisanList}"
                                              itemLabel="name" itemValue="id" htmlEscape="false" />
                            </form:select>
                        </c:when>
                        <c:otherwise>
                            ${contract.artisan.name}
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-3">
                    合同总金额：<font style="color:red">
                    <fmt:formatNumber type="number" value="${contract.amount}" maxFractionDigits="2" /></font>
                </div>
                <div class="col-sm-3">
                    采购总金额：<font style="color:red">
                    <fmt:formatNumber type="number" value="${contract.cost}" maxFractionDigits="2" /></font>
                </div>
                <div class="col-sm-3">
                    进销差价：<font style="color:red">
                    <fmt:formatNumber type="number" value="${contract.amount-contract.cost}" maxFractionDigits="2" /></font>
                </div>
            </div>
            <c:if test="${contract.cost ne 0 || not empty contract.stockInAmount || not empty contract.extraAmount}">
                <div class="row">
                    <c:if test="${contract.cost ne 0}">
                        <div class="col-sm-3">
                            毛利：<font style="color:red">
                            <fmt:formatNumber type="number"
                                              value="${contract.amount - (not empty contract.cost ? contract.cost : 0) - (not empty contract.customerCost ? contract.customerCost * 1.1 : 0)}"
                                              maxFractionDigits="2" /></font>
                        </div>
                        <div class="col-sm-3">
                            毛利率：<font style="color:red">
                            <fmt:formatNumber type="number"
                                              value="${contract.amount eq 0 || (contract.amount - contract.cost - contract.customerCost * 1.1) eq 0 ? 0: ((contract.amount - (not empty contract.cost ? contract.cost : 0) - (not empty contract.customerCost ? contract.customerCost * 1.1 : 0))/contract.amount)*100}"
                                              maxFractionDigits="2" />%</font>
                        </div>
                    </c:if>
                    <c:if test="${not empty contract.stockInAmount}">
                        <div class="col-sm-3" style="color:red">
                            滞库金额：
                            <fmt:formatNumber type="number" value="${contract.stockInAmount}" maxFractionDigits="2" />
                        </div>
                    </c:if>
                    <c:if test="${not empty contract.extraAmount}">
                        <div class="col-sm-3" style="color:red">
                            额外成本：
                            <fmt:formatNumber type="number" value="${contract.extraAmount}" maxFractionDigits="2" />
                        </div>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>

    <!--开票信息-->
    <a class="anchor" name="panel-2"></a>
    <div class="panel panel-default" id="panel-invoice">
        <div class="panel-heading"><h3 class="panel-title">开票信息
            <div class="pull-right">
                <a data-toggle="collapse" href="#invoice-collapse" class="" aria-expanded="true"><i
                        class="zmdi zmdi-minus"></i></a>
            </div></h3>
        </div>
        <div class="panel-body" id="invoice-collapse">
            <div class="row">
                <div class="col-sm-12">
                    发票类型：${fns:getDictLabel(contract.invoiceType,"oa_invoice_type" ,"" )}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    客户名称：${contract.invoiceCustomerName}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    纳税人识别码：${contract.invoiceNo}
                </div>
                <div class="col-sm-4">
                    开户行：${contract.invoiceBank}
                </div>
                <div class="col-sm-4">
                    银行帐号：${contract.invoiceBankNo}
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    我司抬头：${fns:getDictLabel(contract.companyName,"oa_company_name","")}
                </div>
                <div class="col-sm-4">
                    地址：${contract.invoiceAddress}
                </div>
                <div class="col-sm-4">
                    电话：${contract.invoicePhone}
                </div>
            </div>
        </div>
    </div>

    <!--销售清单-->
    <a class="anchor" name="panel-3"></a>
    <div class="panel panel-default" id="card_products">
        <div class="panel-heading"><h3 class="panel-title">销售清单
            <c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true' || (not empty is_recall && is_recall eq true)}">
                <span id="productMsg" style="display:none" class="label label-danger"></span>
            <div class="pull-right">
                <a href="javascript:" class="btn btn-custom" id="btnSetProductCanEdit"><i class="zmdi zmdi-edit"></i>&nbsp;编辑</a>
                <a href="javascript:" class="btn btn-primary" onClick="openPoPanel();"><i class="fa fa-folder-open-o"></i>&nbsp;打开下单</a>
            </div>
            </c:if>
            </h3>
        </div>
        <div class="panel-body panel-collapse collapse in" id="products-collapse">
            <table id="contentTable" class="table table-condensed">
                <thead>
                <tr role="row">
                    <th class="hidden"></th>
                    <th>名称</th>
                    <th>销售价格</th>
                    <th>数量</th>
                    <th>单位</th>
                    <th>金额</th>
                    <th>备注</th>
                </tr>
                </thead>
                <tbody id="contractProductList">
                </tbody>
            </table>
            <script type="text/template" id="contractProductTpl">//<!--
						<tr id="contractProductList{{idx}}" row="row" data-idx={{idx}} data-id="{{row.id}}">
							<td class="hidden">
								<input id="contractProductList{{idx}}_id" name="contractProductList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="contractProductList{{idx}}_sort" name="contractProductList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="contractProductList{{idx}}_delFlag" name="contractProductList[{{idx}}].delFlag" type="hidden" value="0"/>
								<input id="contractProductList{{idx}}_name" name="contractProductList[{{idx}}].name" type="hidden" value="{{row.name}}"/>
								<input id="contractProductList{{idx}}_price" name="contractProductList[{{idx}}].price" type="hidden" value="{{row.price}}"/>
								<input id="contractProductList{{idx}}_num" name="contractProductList[{{idx}}].num" type="hidden" value="{{row.num}}"/>
								<input id="contractProductList{{idx}}_unit" name="contractProductList[{{idx}}].unit" type="hidden" value="{{row.unit}}"/>
								<input id="contractProductList{{idx}}_amount" name="contractProductList[{{idx}}].amount" type="hidden" value="{{row.amount}}"/>
								<input id="contractProductList{{idx}}_remark" name="contractProductList[{{idx}}].remark" type="hidden" value="{{row.remark}}"/>
								<input id="contractProductList{{idx}}_hasSendNum" name="contractProductList[{{idx}}].hasSendNum" type="hidden" value="{{row.hasSendNum}}"/>
								<input id="contractProductList{{idx}}_serviceFlag" name="contractProductList[{{idx}}].serviceFlag"  type="hidden" value="{{row.serviceFlag}}"/>
							</td>
							<td>
								<span>{{row.name}}</span>
								<c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
                                    <select id="contractProductList{{idx}}_productType" name="contractProductList[{{idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required input-sm" style="width: 40%;display: inline-block;" onchange="checkService(this);">
                                        <c:forEach items="${productTypeList}" var="dict">
                                            <option value="${dict.id}">${dict.name}</option>
                                        </c:forEach>
                                    </select>
							        <a href="javascript:" class="fa fa-plus" onclick="addNewChildRow(this,'{{row.productType.id}}')"></a>
							        <span style="{{serviceSpanStyle}}" id="contractProductList{{idx}}_serviceFlag_span"><input type="checkbox" value=1 {{serviceChecked}} onclick="selectServiceFlag(this);"/>续约合同</span>
                                </c:if>
							</td>
							<td style="vertical-align:middle;">
								{{row.price}}
							</td>
							<td style="vertical-align:middle;">
								{{row.num}}
							</td>
							<td style="vertical-align:middle;">
							    {{row.unitName}}
							</td>
							<td style="vertical-align:middle;">
								{{row.amount}}
							</td>
							<td style="vertical-align:middle;">
								{{row.remark}}
							</td>
						</tr>
						<tr>
							<td colspan=6 style="padding-left: 40px;">
							 <table class="table table-condensed productChildTable" id="contractProductList{{idx}}_childTable" style="width: 600px;">
							    <thead>
							     <th class="hidden"></th>
								    <th>子项/类别</th>
								    <th>数量</th>
								    <th>单位</th>
							    </thead>
								<tbody id="contractProductList{{idx}}_child">

								  </tbody>
								</table>
							</td>
						<tr>
						//-->
            </script>
            <script type="text/template" id="contractProductViewTpl">//<!--
						<tr id="contractProductList{{idx}}" row="row" data-idx={{idx}} data-id="{{row.id}}">
							<td class="hidden">

							</td>
							<td>	
							    <c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
							        <div class="checkbox checkbox-custom"><input type="checkbox" onchange="selectProduct(this, '{{row.id}}')">
                                </c:if>
								<label>{{row.name}}</label>
								
								 <span style="margin-left:50px;">{{row.productType.name}}</span>
                                <span style="margin-left:50px;">{{isServiceText}}</span>
								<c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}"></div></c:if>
							</td>
							<td style="vertical-align:middle;">
								{{row.price}}
							</td>
							<td style="vertical-align:middle;">
								{{row.num}}
							</td>
							<td style="vertical-align:middle;">
							    {{row.unitName}}
							</td>
							<td style="vertical-align:middle;">
								{{row.amount}}
							</td>
							<td style="vertical-align:middle;">
								{{row.remark}}
							</td>
						</tr>
						<tr>
							<td colspan=6 style="padding-left: 40px;">
							 <table class="table table-condensed" id="contractProductList{{idx}}_childTable" style="width: 600px;">
							    <thead>
							     <th class="hidden"></th>
								    <th>子项/类别</th>
								    <th>数量</th>
								    <th>单位</th>
							    </thead>
								<tbody id="contractProductList{{idx}}_child">

								  </tbody>
								</table>
							</td>
						<tr>
						//-->
            </script>
            <script type="text/template" id="contractProductChildTpl">//<!--
						<tr id="childProductList{{idx}}_{{child_idx}}" row="row" data-id="{{row.id}}" data-parentid = "{{row.parentId}}">
							<td class="hidden">
								<input id="childProductList{{idx}}_{{child_idx}}_id" name="contractProductList[{{idx}}].childs[{{child_idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_sort" name="contractProductList[{{idx}}].childs[{{child_idx}}].sort" type="hidden" value="{{row.sort}}"/>
								<input id="childProductList{{idx}}_{{child_idx}}_delFlag" name="contractProductList[{{idx}}].childs[{{child_idx}}].delFlag" type="hidden" value="0"/>
								<input id="childProductList{{idx}}_{{child_idx}}_hasSendNum" name="contractProductList[{{idx}}].childs[{{child_idx}}].hasSendNum" type="hidden" value="{{row.hasSendNum}}"/>
							</td>
							<td>
								<input id="childProductList{{idx}}_{{child_idx}}_name" name="contractProductList[{{idx}}].childs[{{child_idx}}].name" type="text" value="{{row.name}}" maxlength="100" class="form-control required input-sm"  style="width: 50%;display: inline-block;"/>
								<select id="childProductList{{idx}}_{{child_idx}}_productType" name="contractProductList[{{idx}}].childs[{{child_idx}}].productType" data-value="{{row.productType.id}}" class="form-control input-block required input-sm"  style="width: 40%;display: inline-block;">
									<c:forEach items="${productTypeList}" var="dict">
										<option value="${dict.id}">${dict.name}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="childProductList{{idx}}_{{child_idx}}_num" name="contractProductList[{{idx}}].childs[{{child_idx}}].num" type="text" value="{{row.num}}" maxlength="10" class="form-control number input-block required input-sm" />
							</td>
							<td>
								<select id="childProductList{{idx}}_{{child_idx}}_unit" name="contractProductList[{{idx}}].childs[{{child_idx}}].unit" data-value="{{row.unit}}" class="form-control input-block required input-sm">
									<c:forEach items="${fns:getDictList('oa_unit')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td class="text-center" width="10">
								{{#delBtn}}<a href="javascript:void(0);" class="on-default remove-row" onclick="delRow(this, '#childProductList{{idx}}_{{child_idx}}')"  title="删除"><i class="fa fa-trash-o"></i></a>{{/delBtn}}
							</td>
						</tr>
						//-->
            </script>
            <script type="text/template" id="contractProductChildViewTpl">//<!--
						<tr id="childProductList{{idx}}_{{child_idx}}" row="row" data-id="{{row.id}}" data-parentid = "{{row.parentId}}">
							<td class="hidden">
							</td>
							<td>
							    <c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
							        <div class="checkbox checkbox-custom"><input type="checkbox" onchange="selectProduct(this, '{{row.id}}')">
                                </c:if>
								<label style="display:inline-block;width:100px;">{{row.name}}</label>
								<span style="margin-left:50px">{{row.productType.name}}</span>
								<c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
							        </div>
                                </c:if>
							</td>
							<td>
								{{row.num}}
							</td>
							<td>
								{{row.unitName}}
							</td>
						</tr>
						//-->
            </script>
            <script type="text/javascript">
                var contractProductRowIdx = 0, contractProductTpl = $("#contractProductTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),
                        contractProductViewTpl = $("#contractProductViewTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "")
                var childRowIdx = 0, contractProductChildTpl = $("#contractProductChildTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),
                        contractProductChildViewTpl = $("#contractProductChildViewTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                var unitList = ${fns:getDictListJson('oa_unit')};
                var productTypeList = ${fns:toJson(productTypeList)};
                var isEdit = false;
                var contractProductList = ${fns:toJson(contract.contractProductList)};

                $(document).ready(function () {
                   loadProducts(contractProductList);

                    $("#btnSetProductCanEdit").click(function () {
                        //保存数据并重新加载数据
                        if(isEdit){
                            if(!getSaveProducts())
                                return;
                            else{
                                $.ajax(
                                        {
                                            type: 'POST',
                                            url: "${ctx}/oa/contract/${contract.id}/saveProduct",
                                            contentType: "application/json;",
                                            data: JSON.stringify(contractProductList),
                                            success: function () {
                                                loadProductsFromServer();//从服务器加载产品数据
                                            },
                                            error: function (a) {
                                                showTipMsg(a, "error");
                                            }
                                        });
                            }
                        } else{
                            //检查是否已经有订单了
                            if("${is_recall}" !="true" && poList && poList.length>0)
                            {
                                showTipMsg("已经下过采购订单了,不能编辑!", "error");
                                return;
                            }
                            $("#btnSetProductCanEdit").html("<i class='fa fa-save'></i>&nbsp;保存");
                        }
                        isEdit = !isEdit;

                        if(isEdit){
                            loadProductsAfterClear(contractProductList);
                        }
                    });
                });

                function loadProducts(data){
                    contractProductList=data;
                    for (var i = 0; i < data.length; i++) {
                        data[i].unitName = "";
                        for(var j = 0; j<unitList.length; j++){
                            if(data[i].unit!= "" && unitList[j].value == data[i].unit)
                            {
                                data[i].unitName = unitList[j].label;
                                break;
                            }
                        }

                        addRow('#contractProductList', contractProductRowIdx, isEdit?contractProductTpl:contractProductViewTpl, data[i]);

                        //子产品表body Selector
                        var childTableBodySelector = '#contractProductList' + contractProductRowIdx + '_child';
                        if (data[i].childs) {
                            //如果子产品数大于0, 显示子产品表
                            if(data[i].childs.length > 0){
                                $(childTableBodySelector).closest('td').show();
                            }
                            for (var j = 0; j < data[i].childs.length; j++) {
                                data[i].childs[j].unitName = "";
                                for(var m = 0; m<unitList.length; m++){
                                    if(data[i].childs[j].unit!= "" && unitList[m].value == data[i].childs[j].unit)
                                    {
                                        data[i].childs[j].unitName = unitList[m].label;
                                        break;
                                    }
                                }
                                addChildRow(childTableBodySelector, contractProductRowIdx, j, isEdit? contractProductChildTpl: contractProductChildViewTpl, data[i].childs[j],null);
                            }
                        } else{
                            //如果子产品数等于于0, 隐藏子产品表
                            $(childTableBodySelector).closest('td').hide();
                        }

                        contractProductRowIdx = contractProductRowIdx + 1;
                    }

                    <c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
                    //如果是拆分po,过滤已经下过的产品
                    for (var i = 0; i < data.length; i++) {
                        var existChildCount = 0;
                        if (data[i].childs) {
                            for (var j = 0; j < data[i].childs.length; j++) {
                                if(data[i].childs[j].hasSendNum >= data[i].childs[j].num){
                                    $("tr[data-id="+data[i].childs[j].id+"] input:checkbox").closest("div").removeClass("checkbox");
                                    $("tr[data-id="+data[i].childs[j].id+"] input:checkbox").closest("div").removeClass("checkbox-custom");
                                    $("tr[data-id="+data[i].childs[j].id+"] input:checkbox").remove();
                                } else{
                                    existChildCount = existChildCount + 1;
                                }
                            }
                           /* if(existChildCount == 0)*/
                            $("tr[data-id="+data[i].id+"] input:checkbox").closest("div").removeClass("checkbox");
                            $("tr[data-id="+data[i].id+"] input:checkbox").closest("div").removeClass("checkbox-custom");
                            $("tr[data-id="+data[i].id+"] input:checkbox").remove();
                                //$("tr[data-id="+data[i].id+"]").next().remove();
                        } else{
                            if(data[i].hasSendNum >= data[i].num){
                                $("tr[data-id="+data[i].id+"] input:checkbox").closest("div").removeClass("checkbox");
                                $("tr[data-id="+data[i].id+"] input:checkbox").closest("div").removeClass("checkbox-custom");
                                $("tr[data-id="+data[i].id+"] input:checkbox").remove();
                                /!*$("tr[data-id="+data[i].id+"]").next("tr").remove();*!/
                            }
                        }
                    }
                    </c:if>
                }

                function addRow(list, idx, tpl, row) {
                    <%--<c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
                        row.json = JSON.stringify(row);
                    </c:if>--%>
                    $(list).append(Mustache.render(tpl, {
                        idx: idx, delBtn: true, row: row, unitList:unitList, isServiceText: function(){
                            return row.serviceFlag == 1? "续约合同":"";
                        }, serviceChecked: function(){
                            return row.serviceFlag == 1? "checked":"";
                        },serviceSpanStyle: function(){
                            return row.serviceFlag == 1? "":"display:none";
                        }
                    }));
                    $(list + idx).find("select").each(function () {
                        $(this).val($(this).attr("data-value"));
                        $(this).select2();
                    });
                    $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                        var dataValue = $(this).attr("data-value")
                        if(dataValue) {
                            var ss = dataValue.split(',');
                            for (var i = 0; i < ss.length; i++) {
                                if ($(this).val() == ss[i]) {
                                    $(this).attr("checked", "checked");
                                }
                            }
                        }
                    });
                }

                function addChildRow(list, idx, child_idx, tpl, row,productTypeId) {
                  /*  <c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
                    if(row)
                        row.json = JSON.stringify(row);
                    </c:if>*/
                    $(list).append(Mustache.render(tpl, {
                        idx: idx, child_idx: child_idx, delBtn: true, row: row
                    }));
                    $(list + "_" + child_idx).find("select").each(function () {
                        $(this).val($(this).attr("data-value"));
                        $(this).select2();
                    });
                    $(list + "_" + child_idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                        var dataValue = $(this).attr("data-value")
                        if(dataValue) {
                            var ss = dataValue.split(',');
                            for (var i = 0; i < ss.length; i++) {
                                if ($(this).val() == ss[i]) {
                                    $(this).attr("checked", "checked");
                                }
                            }
                        }
                    });
                    if(productTypeId){
                    	$("#childProductList"+idx +"_"+ child_idx +"_productType").val(productTypeId);
                    }
                    
                }

                function addNewChildRow(sender,productTypeId) {
                    var parentRow = $(sender).closest('tr');
                    var parentIdx = parentRow.data('idx');
                    var childTable = $('#contractProductList' + parentIdx + '_childTable');
                    var childIdx = childTable.find('tr').length;

                    //显示子产品表
                    $('#contractProductList' + parentIdx + '_child').closest('td').show();

                    var productTypeGroup = parentRow.find("input[id$='productTypeGroup']").val();
                    addChildRow('#contractProductList' + parentIdx + '_child', parentIdx, childIdx, contractProductChildTpl,null,productTypeId);
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

                function selectProduct(sender, id){
                    loading('正在执行，请稍等...');
                    var self = $(sender);
                    var checked = self.is(':checked');
                    var poFrameWin = document.getElementById("poFrame").contentWindow;
                    //var data = JSON.parse(dataString);
                    var data={};
                    if(contractProductList && contractProductList.length>0) {
                        $.each(contractProductList, function (idx, product) {
                            if (product.id == id) {
                                data = product;
                                return;
                            }
                            if(product.childs && product.childs.length>0) {
                                $.each(product.childs, function (idx, childProduct) {
                                    if (childProduct.id == id) {
                                        data = childProduct;
                                        return;
                                    }
                                });
                            }
                        });
                    }
                    if(checked){
                        //检测是否设置产品类型
                        if(!data.childs){
                            if(!data.productType){
                                showTipMsg("没有设置产品类型, 不能下单", "error");
                                self.prop("checked","");
                                closeLoading();
                                return;
                            }
                        }
                    }
                    if(checked){
                        if(data.childs){
                            if(poFrameWin.addProduct){
                                $.each(data.childs, function(idx, item){
                                    $("#card_products tr[data-id='"+ item.id +"'] input:checkbox").prop("checked","checked");
                                    $("#card_products tr[data-id='"+ item.id +"'] input:checkbox").trigger('change');
                                    poFrameWin.addProduct(item);
                                });
                            }
                        } else {
                            if(poFrameWin.addProduct) {
                                poFrameWin.addProduct(data);
                            } else
                                self.prop("checked","");
                        }
                    } else{
                        if(data.childs) {
                            $.each(data.childs, function(idx, item){
                                if(poFrameWin.removeProduct){
                                    $("#card_products tr[data-id='"+ item.id +"'] input:checkbox").prop("checked","");
                                    poFrameWin.removeProduct(item.id);
                                }
                            });
                        } else{
                            if(poFrameWin.removeProduct){
                                poFrameWin.removeProduct(data.id);
                            } else
                                self.prop("checked","checked");
                        }
                    }
                    if($("#panel_po").is(":hidden"))
                    	openOrClosePOPanel();

                    closeLoading();
                }

                function unSelectProduct(id){
                    $("#card_products tr[data-id='"+ id +"'] input:checkbox").prop("checked","");
                    var parentId = $("#card_products tr[data-id='"+ id +"']").data("parentid");
                    if(parentId)
                        $("#card_products tr[data-id='"+ parentId +"'] input:checkbox").prop("checked","");
                }

                function loadProductsAfterClear(data){
                    $('#contractProductList').empty();
                    loadProducts(data);
                }

                //从服务器重新加载销售清单数据
                function loadProductsFromServer(){
                    $.getJSON("${ctx}/oa/contract/get?id=${contract.id}", function(result){
                        contractProductList=result.data.contractProductList;
                        loadProductsAfterClear(contractProductList);
                        $("#btnSetProductCanEdit").html("<i class='fa fa-save'></i>&nbsp;编辑");;
                    });
                }

                //当在拆分po阶段 ajax方式保存编辑的销售清单
                function getSaveProducts(){
                    //得到每一行编辑的产品信息
                    function getProduct(tr, tdPref){
                        var product = {
                            id: tr.find("#" + tdPref + "id").val(),
                            sort: tr.find("#" + tdPref + "sort").val(),
                            delFlag: tr.find("#" + tdPref + "delFlag").val(),
                            productType: {},
                            name: tr.find("#" + tdPref + "name").val(),
                            price: tr.find("#" + tdPref + "price").val(),
                            num: tr.find("#" + tdPref + "num").val(),
                            unit: tr.find("#" + tdPref + "unit").val(),
                            amount: tr.find("#" + tdPref + "amount").val(),
                            remark: tr.find("#" + tdPref + "remark").val(),
                            hasSendNum: tr.find("#" + tdPref + "hasSendNum").val(),
                            serviceFlag: tr.find("#" + tdPref + "serviceFlag").val()
                        };
                        product.productType.id=tr.find("#" + tdPref + "productType").val();
                        product.productType.name=tr.find("#" + tdPref + "productType").find("option:selected").text();
                        return product;
                    }
                    //检查数据
                    function checkData(tr, tdPref, type){
                        switch (type){
                            case 0:
                                if(!(tr.find("#" + tdPref + "productType").length > 0 && tr.find("#" + tdPref + "productType").val()))
                                    return false;
                                break;
                            case 1:
                                if(!(tr.find("#" + tdPref + "name").length > 0 && tr.find("#" + tdPref + "name").val()))
                                    return false;
                                if(!(tr.find("#" + tdPref + "productType").length > 0 && tr.find("#" + tdPref + "productType").val()))
                                    return false;
                                if(!(tr.find("#" + tdPref + "num").length > 0 && tr.find("#" + tdPref + "num").val()))
                                    return false;
                                if(!(tr.find("#" + tdPref + "unit").length > 0 && tr.find("#" + tdPref + "unit").val()))
                                    return false;
                                if(!(tr.find("#" + tdPref + "num").length > 0 && isNum(tr.find("#" + tdPref + "num").val())))
                                    return false;
                                break;
                        }
                        return true;
                    }

                    var productList = [], validateResult = true;
                    $("#contractProductList>tr[id^=contractProductList]").each(function(idx, item){
                        if(!validateResult){
                            return false;
                        }
                        var parentTrId = $(item).prop("id");
                        var parentTdPref = parentTrId+"_";
                        validateResult= checkData($(item), parentTdPref, 0);
                        if(!validateResult){
                            return false;
                        }
                        var product = getProduct($(item), parentTdPref);
                        product.childs = [];
                        $("#"+ parentTdPref +"child>tr").each(function(childIdx, childItem){
                            if(!validateResult){
                                return false;
                            }
                            var childTrId = $(childItem).prop("id");
                            var childTdPref = childTrId+"_";
                            validateResult= checkData($(childItem), childTdPref, 1);
                            if(!validateResult){
                                return false;
                            }
                            var childProduct = getProduct($(childItem), childTdPref);
                            product.childs.push(childProduct);
                        });

                        productList.push(product);
                    });
                    if(!validateResult){
                        $("#productMsg").html("请检查数据!");
                        $("#productMsg").show();
                        return false;
                    } else{
                        $("#productMsg").hide();
                    }

                    contractProductList = productList;
                    return true;
                }

                //检查是否数字
                function isNum(a)
                {
                    var reg = /[1-9]\d*/;
                    return reg.test(a);
                }

                //检查是否为服务
                function checkService(sender){
                    var self= $(sender);
                    var selectedText = self.find("option:selected").text();
                    if(selectedText.indexOf("自有服务")>=0){
                        self.closest('tr').find("[id$='serviceFlag_span']").show();
                    } else{
                        self.closest('tr').find("[id$='serviceFlag_span']").hide();
                    }
                }

                function selectServiceFlag(sender){
                    var self= $(sender);
                    self.closest('tr').find("input[name$='.serviceFlag']").val(self.is(':checked')?1:0);
                }
            </script>
        </div>
    </div>

    <!--采购订单列表-->
    <a class="anchor" name="panel-9"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">采购订单列表</h3></div>
        <div class="panel-body">
            <table id="poTable" class="table table-striped table-condensed table-hover">
                <thead>
                <tr role="row">
                	<th class="hidden"></th>
                    <th>采购订单编号</th>
                    <th>状态</th>
                    <th>供应商</th>
                    <th>金额</th>
                    <th>帐期</th>
                    <th>帐期点数</th>
                    <th>帐期日利率(%)</th>
                    <th>退款金额</th>
                    <th>滞库金额</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="poBody">
                </tbody>
            </table>
            <script type="text/template" id="poViewTpl">//<!--
						<tr role="row" data-id="{{row.id}}">
							<td class="hidden"></td>
							<td>
							   <a href="${ctx}/oa/purchaseOrder/view?id={{row.id}}">{{row.no}}</a>
							</td>
							<td>
							    {{row.statusLabel}}
							</td>
							<td>
								{{row.supplier.name}}
							</td>
							<td>
								{{row.amount}}
							</td>
							<td>
                                {{row.zq}}
							</td>
							<td>
								{{row.paymentPointnum}}
							</td>
							<td>
                                {{row.zqrll}}
							</td>
							<td>
                                {{row.refundMainAmount}}
							</td>
							<td>
                                {{row.stockInAmount}}
							</td>
							<td>
							    <c:if test="${contract.act.taskDefKey eq 'split_po' || param.po eq 'true'}">
							        {{#row.isDisplayModifyBtn}}
							            <a href="javascript:void(0);" onclick="editPo('{{row.id}}')" title="编辑" class="zmdi zmdi-edit text-success" style="font-size:25px;"></a>
							         {{/row.isDisplayModifyBtn}}
							         {{#row.isDisplayDeleteBtn}}
							            <a href="javascript:void(0);" onclick="return confirmx('确认要删除该订单吗？', function(){deletePo('{{row.id}}');})" title="删除" class="zmdi zmdi-minus-square text-success" style="font-size:25px;"></a>
							         {{/row.isDisplayDeleteBtn}}
                                     {{#row.isDisplayTBtn}}
							            <a href="javascript:void(0);" title="退款确认" onclick="showPoTKTHUI(this, '{{row.id}}', 1);" class="text-success">退</a>
							            <a href="javascript:void(0);" title="转入库存" onclick="showPoTKTHUI(this, '{{row.id}}', 2);" class="text-success">库</a>
							         {{/row.isDisplayTBtn}}
							    </c:if>
							</td>
						</tr>
						//-->
            </script>
            <script>
                var poList = [] ;
                var poStatusList = ${fns:getDictListJson('oa_po_status')};
                $(function(){
                    loadPoList();
                });
                function loadPoList(){
                    $("#poBody").empty();
                    var poViewTpl = $("#poViewTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    if("${contract.id}" == "") return;
                    $.getJSON("${ctx}/oa/purchaseOrder/poList/contract/${contract.id}",
                            function(data){
                                poList = data;
                                $.each(data, function(idx, po){
                                    calcPoZq(po);
                                    po.payFinish = true;
                                    po.isPay = false;
                                    if(po.purchaseOrderFinanceList.length>0){
                                        $.each(po.purchaseOrderFinanceList, function(findex, finance){
                                           if(finance.status == 2)
                                               po.isPay = true;
                                            if(finance.status == 1)
                                                po.payFinish = false;
                                        });
                                    }
                                    for(var j = 0; j<poStatusList.length; j++){
                                        if(po.status!= "" && po.status == poStatusList[j].value)
                                        {
                                            po.statusLabel = poStatusList[j].label;
                                            break;
                                        }
                                    }
                                    po.isDisplayModifyBtn = !po.payFinish;
                                    po.isDisplayDeleteBtn = !po.isPay;
                                    po.isDisplayTBtn = po.isPay;
                                    if((po.refundMainAmount && po.refundMainAmount > 0) || (po.stockInAmount && po.stockInAmount > 0))
                                        po.isDisplayTBtn = false;
                                    if(po.amount==0) {
                                        po.isDisplayTBtn = false;
                                        po.isDisplayModifyBtn = true;
                                        po.isDisplayDeleteBtn = true;
                                    }
                                    addRow("#poBody", idx,poViewTpl,po );
                                });

                    });
                }

                function deletePo(id){
                    var purchaseOrder = {
                        id: id
                    }
                    $.get("${ctx}/oa/purchaseOrder/delete", purchaseOrder , function(){
                        for(var i=0;i<poList.length;i++){
                            if(poList[i].id == id){
                                poList.splice(i, 1);
                            }
                        }
                        $("#poBody tr[data-id='"+id+"']").remove();
                        loadProductsFromServer();//从服务器加载采购产品, 因为要重新已下载数量;
                    });
                }

                function editPo(id){
                    var src = "${ctx}/oa/purchaseOrder/form?id="+ id +"&contract.id=${contract.id}&fromModal=1";
                    $("#poFrame").attr("src", src);
                    openPoPanel();
                }
            </script>
        </div>
    </div>

    <!--收款信息-->
    <a class="anchor" name="panel-4"></a>
    <div class="panel panel-default" id="panel-payment">
        <div class="panel-heading"><h3 class="panel-title">收款信息</h3></div>
        <div class="panel-body panel-collapse collapse in" id="payment-collapse">
            <div class="row">
                <div class="col-sm-12">
                    收款周期：${fns:getDictLabel(contract.paymentCycle,"oa_payment_cycle" ,"" )}
                </div>
            </div>

            <div id="payment-body" data-idx="1">
                <table class="table table-striped table-condensed">
                    <thead>
                    <tr row="row">
                        <th class="hidden"></th>
                        <th>收款次数</th>
                        <th>收款金额</th>
                        <th>收款方式</th>
                        <th>收款条件</th>
                        <th>状态</th>
                        <th>开票时间</th>
                        <th>预计收款时间</th>
                        <th>实际收款时间</th>
                    </tr>
                    </thead>
                    <tbody >
                    <c:forEach items="${contract.contractFinanceList}" var="finance" varStatus="status">
                        <tr row="row">
                            <td class="hidden"></td>
                            <td>${status.count}</td>
                            <td><fmt:formatNumber type="number" value="${finance.amount}" maxFractionDigits="2" /></td>
                            <td>${fns:getDictLabel(finance.payMethod, "oa_payment_method" ,"银行转帐" )}</td>
                            <td>${finance.payCondition eq 0 ? '预付':'后付'}</td>
                            <td>${finance.status eq 1 ? '未开票': finance.status eq 2 ? '已开票':'已收款'}</td>
                            <td><fmt:formatDate value="${finance.billingDate}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${finance.planPayDate}" pattern="yyyy-MM-dd" /></td>
                            <td><fmt:formatDate value="${finance.payDate}" pattern="yyyy-MM-dd" /></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
         <%--   <script type="text/template" id="payment-onetime-tpl">//<!--
                <div class="row" id="payment-onetime">
                    <div class="col-sm-3">付款金额：{{row.payment_onetime_amount}}</div>
                    <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                    <div class="col-sm-3">账期：{{row.payment_onetime_time}}</div>
                    <div class="col-sm-3">付款条件：{{row.payCondition}}</div>
                </div>
                    //-->
            </script>
            <script type="text/template" id="payment-installment-tpl">//<!--
                <div class="row" id="payment-installment_{{idx}}">
                    <div class="col-sm-3">付款金额：{{row.payment_installment_amount}}</div>
                    <div class="col-sm-3">账期：{{row.payment_installment_time}}</div>
                    <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                    <div class="col-sm-3">付款条件：{{row.payCondition}}</div>
                </div>
                //-->
            </script>
            <script type="text/template" id="payment-month-tpl">//<!--
                <div class="row" id="payment-month">
                    <div class="col-sm-3">付款金额：{{row.payment_month_amount}}</div>
                    <div class="col-sm-3">付款方式：{{row.paymentMethod}}</div>
                    <div class="col-sm-2">{{type}}数：{{row.payment_month_num}} 个{{type}}</div>
                    <div class="col-sm-2">付款日：{{row.payment_month_day}}</div>
                    <div class="col-sm-2">起始月：{{row.payment_month_start}}</div>
                </div>
                 //-->
            </script>
            <script type="text/javascript">
                $(document).ready(function () {
                    if ($('#id').val()!="") {
                        //load payment detail from saved data
                        var paymentDetail = JSON.parse(${fns:toJson(contract.paymentDetail)});
                        var paymentCycle = ${contract.paymentCycle};
                        var paymentMethod = ${fns:getDictListJson("oa_payment_method")};
                        switch (paymentCycle) {
                            case 1:
                                 for(i=0;i<paymentMethod.length;i++){
                                     if(paymentMethod[i].value == paymentDetail.payment_onetime_paymentMethod)
                                     {
                                         paymentDetail.paymentMethod= paymentMethod[i].label;
                                         break;
                                     }
                                 }
                                 if(paymentDetail.payment_onetime_payCondition == 1){
                                     paymentDetail.payCondition = "后付";
                                 } else{
                                     paymentDetail.payCondition = "预付";
                                 }
                                addPaymentRow(paymentCycle, paymentDetail);
                                break;
                            case 2:
                                $.each(paymentDetail, function (idx, item) {
                                    for(i=0;i<paymentMethod.length;i++){
                                        if(paymentMethod[i].value == item.payment_installment_paymentMethod)
                                        {
                                            item.paymentMethod= paymentMethod[i].label;
                                            break;
                                        }
                                    }
                                    if(item.payment_installment_payCondition == 1){
                                        item.payCondition = "后付";
                                    } else{
                                        item.payCondition = "预付";
                                    }
                                    addPaymentRow(paymentCycle, item, idx + 1);
                                });
                                break;
                            case 3:
                            case 4:
                                for(i=0;i<paymentMethod.length;i++){
                                    if(paymentMethod[i].value == paymentDetail.payment_month_paymentMethod)
                                    {
                                        paymentDetail.paymentMethod= paymentMethod[i].label;
                                        break;
                                    }
                                }
                                addPaymentRow(paymentCycle, paymentDetail);
                                break;
                        }
                    }
                });

                function addPaymentRow(paymentCycle,row,idx){
                    switch(paymentCycle) {
                        case 1:
                            $("#payment-body").append(Mustache.render($("#payment-onetime-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {row: row}));
                            break;
                        case 2:
                            if (!idx)
                                idx = 1;
                            $("#payment-body").append(Mustache.render($("#payment-installment-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                                idx: idx,
                                row: row
                            }));
                            idx = idx + 1;
                            $("#payment-body").data("idx", idx);
                            break;
                        case 3:
                            $("#payment-body").append(Mustache.render($("#payment-month-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                                type: "月",
                                row: row
                            }));
                            break;
                        case 4:
                            $("#payment-body").append(Mustache.render($("#payment-month-tpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""), {
                                type: "季",
                                row: row
                            }));
                            break;
                    }
                }
            </script>--%>
        </div>
    </div>
	<style>
	.c_radio label{line-height:16px;}
	</style>

    <!--退预付款-->
    <c:if test="${not empty is_recall && is_recall eq true && isShowTYFKSection eq true}">
        <div class="panel panel-default">
            <div class="panel-heading"><h3 class="panel-title">退预付款</h3></div>
            <div class="panel_body">
                <div class="row form-inline" style="margin-top: 10px;margin-bottom: 10px;">
                    <div class="col-sm-2">
                        <div class="checkbox checkbox-custom checkbox-circle" style="padding-top:0;">
                            <input type="checkbox" value="true" id="isBackAmount">
                            <label for="isBackAmount" style="line-height:16px;">退预付款</label>
                        </div>
                    </div>
                    <div class="col-sm-4" id="backPayMethod-group">
                        <label class="control-label">退款方式：</label>
                        <form:radiobuttons path="backPayMethod"
                                           items="${fns:getDictList('oa_payment_method')}"
                                           itemLabel="label" itemValue="value" htmlEscape="false" class=""
                                           element="span class='radio radio-custom radio-inline'" />
                    </div>
                    <div class="form-group" id="backAmount-group">
                        <label>退款金额：</label>
                        <form:input path="backAmount" htmlEscape="false"
                                    class="form-control  number input-sm" />
                    </div>
                </div>
            </div>
         </div>
        <script>
            $(function(){
                $("#isBackAmount").change(function(){
                    if($(this).prop('checked')) {
                        $("#backAmount-group").show();
                        $("#backPayMethod-group").show();
                    }
                    else {
                        $("#backAmount").val("");
                        $("#backAmount-group").hide();
                        $("#backPayMethod-group").hide();
                    }
                });
                $("#isBackAmount").trigger('change');
                $("input[name=backPayMethod]:eq(1)").prop("checked",'checked');
            });

            //验证退预付款金额
            function valiateBackAmount(){
                if(!$("#isBackAmount").prop('checked')) return true;
                if($("#backAmount").val().length==0)return true;
                var fkTotalAmount = ${fkTotalAmount};
                return fkTotalAmount>=parseFloat($("#backAmount").val());
            }
        </script>
    </c:if>

    <!--物流信息-->
    <a class="anchor" name="panel-5"></a>
    <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title">收货信息</h3></div>
        <div class="panel-body panel-collapse collapse in" id="ship-collapse">
            <c:choose>
                <c:when test="${contract.act.taskDefKey eq 'verify_ship' or contract.act.taskDefKey eq 'split_po'}">
                    <div class="row">
                        <div class="col-sm-12">
                            <label class="control-label">发货方式：
                                <c:if test="${contract.act.taskDefKey eq 'verify_ship'}"><span class="help-inline"><font color="red">*</font> </span></c:if> </label>
                            <form:radiobuttons path="shipMode" items="${fns:getDictList('oa_ship_mode')}"
                                               itemLabel="label" itemValue="value" htmlEscape="false" class=""
                                               element="span class='radio radio-custom radio-inline c_radio'"/>

                        </div>
                    </div>
                    <div class="row form-inline">
                    	<div class="col-sm-12">
                        <div class="form-group m-r-5">
                            <label class="control-label">收货地址：</label>
                            <form:input path="shipAddress" htmlEscape="false" class="form-control  input-sm" size="60"/>
                        </div>
                        <div class="form-group m-r-5">
                            <label class="control-label">收货人：</label>
                            <form:input path="shipReceiver" htmlEscape="false" class="form-control  input-sm"/>
                        </div>
                        <div class="form-group">
                            <label class="control-label">联系电话：</label>
                            <form:input path="shipPhone" htmlEscape="false" class="form-control  input-sm phone"/>
                        </div>
						</div>
                    </div>
                    <div class="row form-inline">
                    	<div class="col-sm-12">
                        <div class="form-group">
                            <label class="control-label">快递单号：</label>
                            <form:input path="shipEms" htmlEscape="false" class="form-control  input-sm" size="60"/>
                        </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <div class="col-sm-6">
                            发货方式：${fns:getDictLabel(contract.shipMode, "oa_ship_mode","" )}
                        </div>
                    </div>
                    <div class="row ">
                        <div class="col-sm-4">
                            收货地址：${contract.shipAddress}
                        </div>
                        <div class="col-sm-4">
                            收货人：${contract.shipReceiver}
                        </div>
                        <div class="col-sm-4">
                           联系电话：${contract.shipPhone}
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            快递单号：${contract.shipEms}
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <script>
        function getShipAddress(){
            return "${contract.shipAddress}";
        }
    </script>

    <!--其它-->
    <div id="div-other">
        <a class="anchor" name="panel-6"></a>
        <div class="panel panel-default">
            <div class="panel-heading"><h3 class="panel-title">其它</h3></div>
            <div class="panel-body">
                <div class="row" style="color:red;">
                    <div class="col-sm-3">
                        销售奖金：${contract.customerCost}
                    </div>
                    <div class="col-sm-3">
                        额外费用：${contract.discount}
                    </div>
                    <div class="col-sm-3">
                        备注：${contract.discountRemark}
                    </div>
                    <div class="col-sm-3">
                        业绩分成比例：${contract.performancePercentage}%
                    </div>
       <%--             <c:if test="${contract.act.taskDefKey eq 'cso_audit'}">
                        <div class="form-group">
                            <label class="control-label">业绩分成比例：</label>
                            <form:input path="performancePercentage" htmlEscape="false" class="form-control  number input-sm"/>%
                        </div>
                    </c:if>--%>
                </div>
            </div>
        </div>
    </div>
    <script>
        var isShowOtherInfo  = false;

        <c:if test="${fns:getUser().id eq contract.createBy.id}">
            isShowOtherInfo = true;
        </c:if>
        <shiro:hasAnyRoles name="cfo,cso">
            isShowOtherInfo = true;
        </shiro:hasAnyRoles>

        if(isShowOtherInfo){
            $("#li-other,#div-other").show();
        } else {
            $("#li-other,#div-other").hide();
        }
    </script>

    <!--附件-->
    <a class="anchor" name="panel-7"></a>
    <div class="panel panel-default" id="card_attachemnts">
        <div class="panel-heading"><h3 class="panel-title">附件</h3></div>
        <div class="panel-body">
            <table id="attchmentTable" class="table table-striped table-condensed">
                <thead>
                <tr role="row">
                    <th class="hidden"></th>
                    <th style="padding-left:20px;width:300px;">附件类型</th>
					<th style="padding-left:30px;">文件名</th>
					<th style="text-align:center;width:200px;">创建时间</th>
                </tr>
                </thead>
                <tbody id="attchmentList">
                <c:forEach items="${contract.contractAttachmentList}" var="attachment" varStatus="status">
                    <tr row="row" id="row-attachment-${attachment.type}">
                        <td class="hidden">
                            <input id="contractAttachmentList${status.index}_id"
                                   name="contractAttachmentList[${status.index}].id" type="hidden"
                                   value="${attachment.id}"/>
                        </td>
                        <td>
                                ${fns:getDictLabel(attachment.type, 'oa_contract_attachment_type', '')}
                            <a href="javascript:void(0);" title="上传文档" class="fa fa-cloud-upload text-custom" style="margin-left:10px;font-size:18px;"
                               onclick="files${status.index}FinderOpen();"></a>
                            <input id="contractAttachmentList${status.index}_type"
                                   name="contractAttachmentList[${status.index}].type" type="hidden"
                                   value="${attachment.type}"/>
                        </td>
                        <td>
                            <form:hidden id="files${status.index}"
                                         path="contractAttachmentList[${status.index}].files" htmlEscape="false"
                                         maxlength="2000" class="form-control"/>
                            <sys:myckfinder delConfirm="true" input="files${status.index}" type="files" uploadPath="/oa/contract"
                                            selectMultiple="true"/>
                        </td>
                        <td style="text-align:center;">
                            <fmt:formatDate value="${attachment.updateDate}" pattern="yyyy-MM-dd"/>
                        </td>
                    </tr>

                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <shiro:lacksRole name="businesser">
    <script>
        $(function(){
            //如果合同已完成移除删除按钮
            if("${contract.status}" == "100"){
                $("#attchmentTable ol li").each(function(){
                    $(this).find("a:eq(1)").remove();
                });

                $("#attchmentTable .fa-cloud-upload").each(function(){
                    $(this).remove();
                });
            }
        });
    </script>
    </shiro:lacksRole>

    <!--备注-->
    <div class="panel panel-default" id="card_other">
        <div class="panel-heading"><h3 class="panel-title">备注</h3></div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-12">
                    ${contract.remark}
                </div>
            </div>
        </div>
    </div>

    <a class="anchor" name="panel-8"></a>
    <c:if test="${(not empty contract.id and not empty contract.act.procInsId) or (not empty contract.act.taskId)}">
        <act:histoicFlow procInsId="${contract.act.procInsId}"/>
    </c:if>

    <!--您的意见和建议-->
    <c:if test="${contract.act.taskDefKey eq 'saler_audit' ||
                    contract.act.taskDefKey eq 'artisan_audit' ||
                    contract.act.taskDefKey eq 'cso_audit' ||
                    contract.act.taskDefKey eq 'verify_receiving'}">
        <div class="panel panel-default" id="comment_other">
            <div class="panel-heading"><h3 class="panel-title">您的意见和建议</h3></div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-sm-12">
                        <form:textarea path="act.comment" class="form-control" rows="5"/>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <div class="form-group clearfix hidden">
        <label class="col-sm-3 control-label">合同状态：</label>
        <div class="col-sm-7">
            <form:select path="status" class="form-control col-md-12 input-sm">
                <form:option value="" label=""/>
                <form:options items="${fns:getDictList('oa_contract_status')}" itemLabel="label" itemValue="value"
                              htmlEscape="false"/>
            </form:select>
        </div>
    </div>

    <div class="form-group">
        <div class="text-center">
				<input id="btnCancel" class="btn btn-inverse" type="button" value="返 回" onClick="history.go(-1)"/>
                <shiro:hasAnyRoles name="businesser">
                    <c:if test="${empty contract.act.taskDefKey}">
                            <input id="btnSubmit" class="btn btn-custom" type="submit" value="保存附件" onClick="$('#flag').val('save_attachment')"/>
                    </c:if>
                </shiro:hasAnyRoles>
                <c:if test="${contract.contractType ne '1' and not empty contract.id}">
                    <c:set var="submitText" value="提交"/>
                    <c:if test="${empty contract.act.procInsId}">
                        <c:set var="submitText" value="提交审批"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'split_po'}">
                        <c:set var="submitText" value="提交审核"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'contract_edit'}">
                        <c:set var="submitText" value="确认修改"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'business_person_createbill'}">
                        <c:set var="submitText" value="确认下单"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'verify_ship'}">
                        <c:set var="submitText" value="确认发货"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'cw_kp' || contract.act.taskDefKey eq 'cw_kp2'}">
                        <c:set var="submitText" value="确认开票"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'verify_sk' || contract.act.taskDefKey eq 'verify_sk2'}">
                        <c:set var="submitText" value="确认收款"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'finish'}">
                        <c:set var="submitText" value="确认合同完成"/>
                    </c:if>

                    <c:if test="${contract.act.taskDefKey eq 'can_invoice' || contract.act.taskDefKey eq 'can_invoice2'}">
                        <c:set var="submitText" value="确认可以开票"/>
                    </c:if>
                    <c:choose>
                        <c:when test="${empty contract.act.procInsId ||
                                            contract.act.taskDefKey eq 'split_po' ||
                                            contract.act.taskDefKey eq 'contract_edit' ||
                                            contract.act.taskDefKey eq 'business_person_createbill' ||
                                            contract.act.taskDefKey eq 'verify_ship' ||
                                            contract.act.taskDefKey eq 'cw_kp' ||
                                            contract.act.taskDefKey eq 'cw_kp2' ||
                                            contract.act.taskDefKey eq 'verify_sk' ||
                                            contract.act.taskDefKey eq 'verify_sk2' ||
                                            contract.act.taskDefKey eq 'finish' ||
                                            contract.act.taskDefKey eq 'can_invoice' ||
                                            contract.act.taskDefKey eq 'can_invoice2'}">
                            <input id="btnSubmit" class="btn btn-custom" type="submit" value="${submitText}" onClick="$('#flag').val('submit_audit')"/>&nbsp;
                        </c:when>
                        <c:when test="${not empty contract.act.taskDefKey}">                          
                            <input id="btnUnAudit" class="btn btn-info" type="submit" value="驳 回" onClick="$('#flag').val('no')"/>
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="同 意" onClick="$('#flag').val('yes')"/>
                        </c:when>
                    </c:choose>


                    <%--<c:if test="${empty contract.act.procInsId}">
                        <input id="btnCancel" class="btn btn-custom" type="submit" value="提交"
                               onclick="$('#flag').val('submit_audit')"/>&nbsp;
                    </c:if>
                    <c:if test="${not empty contract.act.taskId and contract.act.taskDefKey ne 'end' and contract.act.taskDefKey ne 'submit_audit'}">
                        <input id="btnSubmit" class="btn btn-custom" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
                        <input id="btnSubmit" class="btn btn-info" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
                    </c:if>--%>
                </c:if>
        </div>
    </div>
    </form:form>

    <%--选择框架合同的modal--%>
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

    <!--转入库存和退款确认-->
    <div id="modal-PoTKTH" class="modal fade" tabindex="-1"
         role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
         style="display: none;">
        <div class="modal-dialog" style="width:500px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-hidden="true">×</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <table id="table-poTKTH" class="table table-striped table-condensed table-hover">
                        <thead>
                        <tr role="row">
                            <th class="hidden"></th>
                            <th>退货条目</th>
                            <th>退货数量</th>
                            <th>单位</th>
                            <th>单价</th>
                            <th>小计</th>
                        </tr>
                        </thead>
                        <tbody id="body-poTKTH">
                        </tbody>
                    </table>
                    <div>
                        <span class="total_label">总计</span>: <span class="total" style="color:red;"></span>
                        <span class="total_sf_label">实退金额: </span>
                        <input id="total_sf" type="text" class="form-control number input-block required input-sm" style="display: inline-block; width:100px;"/>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn inverse" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-info waves-effect waves-light submit-poTKTH">确定</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/template" id="tpl-PoTKTH">//<!--
        <tr>
            <td class="hidden">
                <input id="PoTKTH{{idx}}_name" type="hidden" value="{{row.name}}"/>
                <input id="PoTKTH{{idx}}_unit" type="hidden" value="{{row.unit}}"/>
                <input id="PoTKTH{{idx}}_price" type="hidden" value="{{row.price}}"/>
                <input id="PoTKTH{{idx}}_amount" type="hidden" value="{{row.amount}}"/>
                <input id="PoTKTH{{idx}}_productType" type="hidden" value="{{row.productType.id}}"/>
            </td>
            <td>
                {{row.name}}
            </td>
            <td>
                {{#row.isShowNumEdit}}
                    <input id="PoTKTH{{idx}}_num" type="text" value="{{row.num}}" class="form-control number input-block required" style="width:80px;" onchange="tkThUpdateAmount(this);"/>
                {{/row.isShowNumEdit}}
                {{#row.isShowNum}}
                    <input id="PoTKTH{{idx}}_num" type="hidden" value="{{row.num}}"/>
                    {{row.num}}
                {{/row.isShowNum}}
            </td>
            <td>
                {{row.unitName}}
            </td>
            <td>
                {{row.price}}
            </td>
             <td>
                {{row.amount}}
            </td>
        </tr>//-->
    </script>
    <script>
        function showPoTKTHUI(sender, po_id, type){
            var tpl = $("#tpl-PoTKTH").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, ""),
                top = window.event.clientY,
                    totalAmount = 0,
                    fkSumAmount = 0;//已付款总金额

            $("#body-poTKTH").empty();//清空数据

            var modal = $('#modal-PoTKTH');
            modal.css('top',top>200 ? (top-200): top );

            if(type == 1) {//退款确认
                modal.find(".modal-title").html("退款确认");
                modal.find("#table-poTKTH  thead td:eq(1)").html("退货条目");
                modal.find("#table-poTKTH  thead td:eq(2)").html("退货数量");
                modal.find(".total_label").html("应退金额");
                modal.find(".total_sf_label").show();
                modal.find("#total_sf").show();
            }
            else {//转入库存
                modal.find(".modal-title").html("转入库存");
                modal.find("#table-poTKTH  thead td:eq(1)").html("入库条目");
                modal.find("#table-poTKTH  thead td:eq(2)").html("入库数量");
                modal.find(".total_label").html("总计");
                modal.find(".total_sf_label").hide();
                modal.find("#total_sf").hide();
            }

            modal.find(".submit-poTKTH").data("type", type);
            modal.find(".submit-poTKTH").data("poId", po_id);
            //删除保存事件
            modal.find(".submit-poTKTH").unbind("click");
            modal.find(".submit-poTKTH").click(function(){
                loading('正在提交，请稍等...');

                if(modal.find('input').hasClass("error"))return;
                if(type == 1) {//退款确认
                    var amount = parseFloat(modal.find("#total_sf").html());
                    if (amount > fkSumAmount) {
                        showTipMsg("退款金额不能大于已付款金额, 已付款金额为:" + fkSumAmount, "error");
                        return;
                    }
                }
                modal.find(".submit-poTKTH").attr('disabled',"true");
                var type = $(this).data("type"), poid = $(this).data("poId");
                var dataList = [];
                $("#body-poTKTH tr").each(function(idx, item){
                    var row = $(item);
                    var data = {
                        name: row.find("input[id$='name']").val(),
                        num: row.find("input[id$='num']").val(),
                        unit: row.find("input[id$='unit']").val(),
                        price: row.find("input[id$='price']").val(),
                        amount: row.find("input[id$='amount']").val(),
                        productType: row.find("input[id$='productType']").val()
                    }
                    dataList.push(data);
                })
                if(type == 1){
                    var data={
                        amount: $("#modal-PoTKTH").find("#total_sf").val(),
                        refundDetailList: dataList
                    }
                    $.ajax({
                        type: 'POST',
                        url: "${ctx}/oa/refund/" + poid + "/save",
                        contentType: "application/json;",
                        data: JSON.stringify(data),
                        success: function(data){
                            showTipMsg(data)
                            $('#modal-PoTKTH').modal('hide');
                            modal.find(".submit-poTKTH").removeAttr("disabled");
                            loadPoList();
                            closeLoading();
                        }
                    });
                } else{
                    $.ajax({
                        type: 'POST',
                        url: "${ctx}/oa/stockin/" + poid + "/save",
                        contentType: "application/json;",
                        data: JSON.stringify(dataList),
                        success: function(data){
                            showTipMsg(data)
                            $('#modal-PoTKTH').modal('hide');
                            modal.find(".submit-poTKTH").removeAttr("disabled");
                            loadPoList();
                            closeLoading();
                        }
                    });
                }
            });

            $.each(poList, function(index, po){
                if(po.id == po_id){
                    var productList = po.purchaseOrderProductList;
                    $.each(productList, function(pIdx, product){
                        for(var j = 0; j<unitList.length; j++){
                            if(unitList[j].value == product.unit)
                            {
                                product.unitName = unitList[j].label;
                                break;
                            }
                        }
                        product.isShowNumEdit = (type != 1);
                        product.isShowNum = !product.isShowNumEdit;
                        $("#body-poTKTH").append(Mustache.render(tpl, { row: product, idx: pIdx }));
                        totalAmount+=product.amount;
                    });
                    //得到已付款总金额
                    if(po.purchaseOrderFinanceList && po.purchaseOrderFinanceList.length > 0){
                        $.each(po.purchaseOrderFinanceList, function(pIdx, finance){
                            if(finance.status == 2){
                                fkSumAmount += finance.amount;
                            }
                        });
                    }
                }
            });
            modal.find(".total").html(totalAmount);
            modal.find("#total_sf").val(totalAmount);

            modal.modal({
                show : true,
                backdrop : 'static'
            });
        }

        function tkThUpdateAmount(sender){
            var self = $(sender),
                    row = self.closest("tr"),
                    num = parseInt(self.val()),
                    price = parseFloat(row.find("td:eq(4)").html()),
                    amount = (num*price).toFixed(2);
            row.find("td:eq(5)").html(amount);
            row.find("input[id$='amount']").val(amount);

            totalAmount = 0;
            $("#body-poTKTH tr").each(function(idx,row){
                var amount = parseFloat($(row).find("td:eq(5)").html());
                totalAmount+=amount;
            });
            $('#modal-PoTKTH').find(".total").html(totalAmount);
            $('#modal-PoTKTH').find("#total_sf").val(totalAmount);
        }
        $(function(){
            $('#mainFrame',top.document).parent().parent().css({paddingTop:'3px'});
            $(top.document).scroll(function(){
                var _height = $(this).scrollTop();
                $('#navbar').css({position:'absolute',top:_height + 'px'});
            });
        });
    </script>
</body>
</html>