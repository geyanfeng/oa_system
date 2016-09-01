<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商评价管理</title>
	<meta name="decorator" content="default"/>
	<link href="${ctxStatic}/assets/star/starrr.css" rel="stylesheet" type="text/css" />
	<script src="${ctxStatic}/assets/star/starrr.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			 $('.starrr').starrr({
			      change: function(e, value){
			        if (value) {
			          
			        } else {
			          
			        }
			      }
			    });
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
	</script>
</head>
<body>
	
	<form:form id="inputForm" modelAttribute="oaPoEvaluate" action="${ctx}/oa/oaPoEvaluate/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<br><br>
		
		<div class="form-group">
			<label class="col-md-2 control-label">发货速度</label>
			<div class="col-md-4">
				<form:hidden path="shippingSpeed"/>
				 <div class='starrr' id='star1'></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">沟通效率</label>
			<div class="col-md-4">
				<form:hidden path="communicationEfficiency"/>
				 <div class='starrr' id='star1'></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">产品质量</label>
			<div class="col-md-4">
			    <form:hidden path="productQuality"/>
			     <div class='starrr' id='star1'></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">服务态度</label>
			<div class="col-md-4">
				<form:hidden path="serviceAttitude"/>
				 <div class='starrr' id='star1'></div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-2 control-label">备注：</label>
			<div class="col-md-4">
				<form:textarea path="remark" htmlEscape="false" maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
		</div>
	</form:form>
</body>
</html>