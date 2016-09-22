<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商评价管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/assets/star/starrr.css" rel="stylesheet" type="text/css" />
	<script src="${ctxStatic}/assets/star/starrr.js" type="text/javascript"></script>
	   <script src="${ctxStatic}/assets/js/jquery.form.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			 $('.starrr').starrr({
			      change: function(e, value){
			    	 $('#'+$(this).attr('path')).val(value);
			      }
			    });
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
	                                    parent.showTipMsg(result.msg,"success");
	                            } else
	                                showTipMsg(result.msg,"success");

	                            //关闭本窗体
                                if(parent.closeSupplierEvaluatioModal)
                                    parent.closeSupplierEvaluatioModal();
	              
	                        }, beforeSubmit: function () {
	                           
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
	</script>
</head>
<body>
	
	<form:form id="inputForm" modelAttribute="oaPoEvaluate" action="${ctx}/oa/oaPoEvaluate/ajaxSave" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<br><br>
		<form:hidden path="poId"/>
		<div class="form-group">
			<label class="col-xs-3 control-label">发货速度</label>
			<div class="col-xs-6">
				<form:hidden path="shippingSpeed"/>
				 <div class='starrr' path="shippingSpeed"></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-3 control-label">沟通效率</label>
			<div class="col-xs-6">
				<form:hidden path="communicationEfficiency"/>
				 <div class='starrr' path="communicationEfficiency"></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-3 control-label">产品质量</label>
			<div class="col-xs-6">
			    <form:hidden path="productQuality"/>
			     <div class='starrr' path="productQuality"></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-3 control-label">服务态度</label>
			<div class="col-xs-6">
				<form:hidden path="serviceAttitude"/>
				 <div class='starrr' path="serviceAttitude"></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-3 control-label">备注：</label>
			<div class="col-xs-8">
				<form:textarea path="remark" htmlEscape="false" maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="form-actions text-center">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
		</div>
	</form:form>
</body>
</html>