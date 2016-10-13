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
				function passwordLevel(password) {
					var Modes = 0;
					for (i = 0; i < password.length; i++) {
						Modes |= CharMode(password.charCodeAt(i));
					}
					return bitTotal(Modes);
				}
				//CharMode函数
				function CharMode(iN) {
					if (iN >= 48 && iN <= 57)//数字
						return 1;
					if (iN >= 65 && iN <= 90) //大写字母
						return 2;
					if ((iN >= 97 && iN <= 122) || (iN >= 65 && iN <= 90))
						//大小写
						return 4;
					else
						return 8; //特殊字符
				}
				//bitTotal函数
				function bitTotal(num) {
					modes = 0;
					for (i = 0; i < 4; i++) {
						if (num & 1)
							modes++;
						num >>>= 1;
					}
					return modes;
				}
				$.validator.addMethod("strongPsw", function(value, element) {
					if (passwordLevel(value) == 1) {
						return false;
					}
					return true
				}, "密码必须包含数字、大写字母、小写字母任意两项，长度最少是8位");
				$("#inputForm")
						.validate(
								{
									rules : {},
									messages : {
										newPassword : {
											minlength : "密码必须包含数字、大写字母、小写字母任意两项，长度最少是8位"
										},
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
				<ul class="nav nav-tabs">
					<li role="presentation"><a href="${ctx}/sys/user/info">个人信息</a></li>
					<li role="presentation" class="active"><a
						href="${ctx}/sys/user/modifyPwd">修改密码</a></li>
				</ul>
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane fade" id="home1"></div>
					<div role="tabpanel" class="tab-pane fade in active" id="profile1">

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
												value="" maxlength="50" minlength="8" strongPsw="true"
												class="required  form-control" />
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
											<button id="btnSubmit" type="submit"
												class="btn btn-custom m-l-10 btn-md">保 存</button>
										</div>
									</div>

								</div>

								<!-- end col -->
							</div>
							<!-- end row -->
						</div>
					</div>

				</div>

			</div>
			<!-- end col -->
		</div>


	</form:form>
</body>
</html>