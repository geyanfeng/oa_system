<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>修改密码</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				$("#oldPassword").focus();
				$("#inputForm")
						.validate(
								{
									rules : {},
									messages : {
										confirmNewPassword : {
											equalTo : "输入与上面相同的密码"
										}
									},
									submitHandler : function(form) {
										loading('正在提交，请稍等...');
										form.submit();
									},
									errorContainer : "#messageBox",
									errorPlacement : function(error, element) {
										$("#messageBox").text("输入有误，请先更正。");
										if (element.is(":checkbox")
												|| element.is(":radio")
												|| element.parent().is(
														".input-append")) {
											error.appendTo(element.parent()
													.parent());
										} else {
											error.insertAfter(element);
										}
									}
								});
			});
</script>
</head>
<body>

	<form:form id="inputForm" modelAttribute="user"
		action="${ctx}/sys/user/modifyPwd" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<div class="row">
			<div class="col-sm-12">
				<div class="card-box">
					<h4 class="header-title m-t-0 m-b-30">修改密码</h4>
					<div class="row">
						<div class="col-md-12">
							<div class="p-20">
								<div class="form-group">
									<label class="col-md-2 control-label">旧密码 <span
											class="help-inline"><font color="red">*</font> </span></label>
									<div class="col-md-3">
										<input id="oldPassword" name="oldPassword" type="password"
											value="" maxlength="50" minlength="3"
											class="required form-control" /> 
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-2 control-label">新密码 <span
											class="help-inline"><font color="red">*</font> </span></label>
									<div class="col-md-3">
										<input id="newPassword" name="newPassword" type="password"
											value="" maxlength="50" minlength="3" class="required  form-control" />
									</div>
								</div>
								<div class="form-group">
									<label class="col-md-2 control-label">确认新密码 <span
											class="help-inline"><font color="red">*</font> </span></label>
									<div class="col-md-3">
										<input id="confirmNewPassword" name="confirmNewPassword"
											type="password" value="" maxlength="50" minlength="3"
											class="required  form-control" equalTo="#newPassword" />
									</div>
								</div>
								 <div class="form-group m-b-0">
                                                    <div class="col-sm-offset-3 col-sm-9">
                                                      <button id="btnSubmit" type="submit" class="btn btn-success waves-effect waves-light m-l-10 btn-md">保 存</button>
                                                    </div>
                                                </div>
								
							</div>
						</div>
						<!-- end col -->
					</div>
					<!-- end row -->
				</div>
			</div>
			<!-- end col -->
		</div>


	</form:form>
</body>
</html>