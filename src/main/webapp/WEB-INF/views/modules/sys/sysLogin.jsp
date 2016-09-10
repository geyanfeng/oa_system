<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>${fns:getConfig('productName')} 登录</title>
	<meta name="decorator" content="blank"/>
		<style type="text/css">
      .hide {display:none !important;}
      .header{height:80px;padding-top:20px;} .alert{position:relative;width:300px;margin:0 auto;*padding-bottom:0px;}
      label.error{background:none;width:270px;font-weight:normal;color:red;margin:0;}
      #messageBox {border-color:white;background-color: white; padding: 5px; text-align: center;}
	  body{background-image: url("${ctxStatic}/images/login-bg.jpg");background-size:cover;}
			html, body{
				height:100%;
			}
		.wrapper-page{background:rgba(255,255,255,.15);width:420px;padding:10px 20px;margin:0 auto;}
		.card-box{padding:0;}
		.panel-body{padding:0;}
		.form-group{border-bottom:1px solid #dedede;}
		.form-control,.form-control:focus{border:none;}
		.input-group-addon{background:none;border:none;color:#bbb;}
    </style>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#loginForm").validate({
				rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},password: {required: "请填写密码."},
					validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
				},
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#loginError").parent());
				} 
			});
		});
		// 如果在框架或在对话框中，则弹出提示并跳转到首页
		if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
			alert('未登录或登录超时。请重新登录，谢谢！');
			top.location = "${ctx}";
		}
	</script>
</head>
<body>
	<!--[if lte IE 6]><br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->
	<div class="header">
		<div id="messageBox" class="alert alert-danger alert-error ${empty message ? 'hide' : ''}"><button data-dismiss="alert" class="close">×</button>
			<label id="loginError" class="error">${message}</label>
		</div>
	</div>	
	<DIV class="wrapper-page">
		<DIV class="text-center logo-alt-box">
			<div><img src="${ctxStatic}/images/login-logo.png" /></div>
		<div class="logo" style="padding-top:10px;">${fns:getConfig('productName')}</div>
	</DIV>
		<FORM id="loginForm" class="m-b-30" action="${ctx}/login" method="post">
		<DIV class="m-t-20 card-box">			
			<DIV class="panel-body form-horizontal m-t-10">
				
					<DIV class="form-group ">
						<DIV class="col-xs-12 input-group">
							<span class="input-group-addon bootstrap-touchspin-prefix"><i class="fa fa-user"></i></span>
							<INPUT class="form-control" id="username" name="username" type="text"
								placeholder="登录名">
						</DIV>
					</DIV>
					<div class="form-group">
						<DIV class="col-xs-12 input-group">
							<span class="input-group-addon bootstrap-touchspin-prefix"><i class="fa fa-lock"></i></span>
							<INPUT class="form-control" id="password" name="password" type="password"
								placeholder="密码">
						</DIV>
					</DIV>
					<DIV class="form-group" style="border:none;">
						<DIV class="col-xs-12">
							<DIV class="checkbox checkbox-custom">
								<INPUT id="checkbox-signup" type="checkbox" id="rememberMe" name="rememberMe" ${rememberMe ? 'checked' : ''}> <LABEL
									for="checkbox-signup"> 记住我（公共场所慎用） </LABEL>
							</DIV>
						</DIV>
					</DIV>				
					<c:if test="${isValidateCodeLogin}">
					<DIV class="form-group" style="border:none;">
						<DIV class="col-xs-12">
							<div class="validateCode">
							<i class="fa fa-shield"></i>
			                 <label for="validateCode">验证码</label>
			                   <sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;display:inline;"/>
		                     </div>
						</DIV>
					</DIV>
					</c:if>	
			</DIV>	
		</DIV>
		<BUTTON class="btn btn-custom btn-block" type="submit">Login</BUTTON>
		</FORM>
		<!-- end card-box -->
	</DIV>
	
	<script src="${ctxStatic}/flash/zoom.min.js" type="text/javascript"></script>
</body>
</html>