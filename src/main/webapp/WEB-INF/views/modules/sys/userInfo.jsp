<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>个人信息</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				$("#inputForm")
						.validate(
								{
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

	<div class="row">
		<div class="col-lg-12">

			<ul class="nav nav-tabs">
				<li role="presentation" class="active"><a
					href="${ctx}/sys/user/info">个人信息</a></li>
				<li role="presentation"><a href="${ctx}/sys/user/modifyPwd">修改密码</a>
				</li>

			</ul>
			<div class="tab-content">
				<div role="tabpanel" class="tab-pane fade in active" id="home1">
					<form:form id="inputForm" modelAttribute="user"
						action="${ctx}/sys/user/info" method="post"
						class="form-horizontal">
						<%--
		<form:hidden path="email" htmlEscape="false" maxlength="255" class="input-xlarge form-control"/>
		<sys:ckfinder input="email" type="files" uploadPath="/mytask" selectMultiple="false"/> --%>
						<sys:message content="${message}" />
						<div class="form-group">
							<label class="col-md-2 control-label">头像:</label>
							<div class="col-md-4">
								<form:hidden id="nameImage" path="photo" htmlEscape="false"
									maxlength="255" class="input-xlarge form-control" />
								<sys:ckfinder input="nameImage" type="images"
									uploadPath="/photo" selectMultiple="false" maxWidth="100"
									maxHeight="100" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">归属公司:</label>
							<div class="col-md-4">
								<label class="control-label">${user.company.name}</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">归属部门:</label>
							<div class="col-md-4">
								<label class="control-label">${user.office.name}</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">姓名:</label>
							<div class="col-md-4">
								<form:input path="name" htmlEscape="false" maxlength="50"
									class="required form-control" readonly="true" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">邮箱:</label>
							<div class="col-md-4">
								<form:input path="email" htmlEscape="false" maxlength="50"
									class="email form-control" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">电话:</label>
							<div class="col-md-4">
								<form:input path="phone" class="form-control" htmlEscape="false" maxlength="50" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">手机:</label>
							<div class="col-md-4">
								<form:input path="mobile" class="form-control" htmlEscape="false" maxlength="50" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">备注:</label>
							<div class="col-md-4">
								<form:textarea path="remarks" htmlEscape="false" rows="3"
									maxlength="200" class="form-control" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">用户类型:</label>
							<div class="col-md-4">
								<label class="control-label">${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">用户角色:</label>
							<div class="col-md-4">
								<label class="control-label">${user.roleNames}</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">上次登录:</label>
							<div class="col-md-6">
								<label class="control-label">IP:
									${user.oldLoginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate
										value="${user.oldLoginDate}" type="both" dateStyle="full" />
								</label>
							</div>
						</div>
						<div class="form-group m-b-0">
									<div class="col-sm-offset-3 col-sm-9">
										<button id="btnSubmit" type="submit"
											class="btn btn-success waves-effect waves-light m-l-10 btn-md">保
											存</button>
									</div>
								</div>
					</form:form>
				</div>
				<div role="tabpanel" class="tab-pane fade" id="profile1">
					
				</div>

			</div>
		</div>
		<!-- end col -->
	</div>


</body>
</html>