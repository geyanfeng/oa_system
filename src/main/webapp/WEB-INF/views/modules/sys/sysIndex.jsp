<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>${fns:getConfig('productName')}</title>
<meta name="decorator" content="blank" />
</head>
<BODY class="fixed-left">
	<!-- Begin page -->
	<DIV id="wrapper">
		<!-- Top Bar Start -->
		<DIV class="topbar">
			<!-- LOGO -->
			 <!-- LOGO -->
                <div class="topbar-left">
                    <div class="text-center"  style="padding-top:10px;height:40px;">
                        <a href="${ctx}" class="logo" target="mainFrame">
                           <span><img src="${ctxStatic}/images/logo.png" alt="logo" style="height: 26px;vertical-align:0px;"></span>
                            <i class="zmdi zmdi-toys icon-c-logo"></i><span>Born to be pround</span>
                          
                        </a>
                    </div>
                </div>
			<!-- Button mobile view to collapse sidebar menu -->
			<%--<div class="topbar-left">
				<div class="text-center">
					<a href="${ctx}?login" class="logo" >
						<i class="zmdi zmdi-toys icon-c-logo"></i><span>首页</span>
						<!--<span><img src="assets/images/logo.png" alt="logo" style="height: 20px;"></span>-->
					</a>
				</div>
			</div>--%>
			<DIV class="navbar navbar-default" role="navigation">
				
				<DIV class="container">
					<DIV>
						<DIV class="pull-left">
							<BUTTON
								class="button-menu-mobile open-left waves-effect waves-light">
								<I class="zmdi zmdi-menu"></I>
							</BUTTON>
							<SPAN class="clearfix"></SPAN>
						</DIV>
					<%--	<FORM class="navbar-left app-search pull-left hidden-xs"
							role="search">
							<INPUT class="form-control" type="text" placeholder="Search..."
								value=""><A
								href="http://coderthemes.com/flacto_1.1/layout_2_green/"><I
								class="fa fa-search"></I></A>
						</FORM>--%>
						<UL class="nav navbar-nav navbar-right pull-right">
							<LI>
								<!-- Notification -->
								<DIV class="notification-box">
									<UL class="list-inline m-b-0">
										<LI><A class="right-bar-toggle"
											href="javascript:void(0);" title="提醒"><I
												class="zmdi zmdi-notifications-none"></I> </A>
											<DIV class="noti-dot">
												<SPAN class="dot"></SPAN> <SPAN class="pulse"></SPAN>
											</DIV></LI>
									</UL>
								</DIV> <!-- End Notification bar -->
							</LI>
							<LI>
								<DIV class="notification-box">
									<UL class="list-inline m-b-0">
										<LI><A class="right-bar-todo"
											href="javascript:void(0);" target="mainFrame" title="待办事项"><i class="zmdi zmdi-hourglass-outline"></I> </A>
											<DIV class="noti-dot">
												<SPAN class="dot"></SPAN> <SPAN class="pulse"></SPAN>
											</DIV></LI>
									</UL>
								</DIV>				
							</LI>
							
						
                          	
							<LI class="dropdown user-box"><A
								class="dropdown-toggle profile "
								aria-expanded="true"
								href="#"
								data-toggle="dropdown"><i class="fa fa-user" style="font-size:24px;line-height:60px;"></i>

								</A>
								<UL class="dropdown-menu">
									<LI><A href="${ctx}/sys/user/info" target="mainFrame"><I
											class="ti-user m-r-5"></I>个人信息</A></LI>
									<LI><A href="${ctx}/sys/user/modifyPwd" target="mainFrame"><I
											class="ti-settings m-r-5"></I>修改密码</A></LI>
									<LI><A href="${ctx}/logout" title="退出登录"><I
											class="ti-power-off m-r-5"></I> 退出</A></LI>
								</UL></LI>
						</UL>
					</DIV>
					<!--/.nav-collapse -->
				</DIV>
			</DIV>
		</DIV>
		<!-- Top Bar End -->
		<!-- ========== Left Sidebar Start ========== -->

		<DIV class="left side-menu">
		<div class="text-center">
                    
                    <div class="user-thumb m-t-20">
                        <A href="${ctx}"><img src="${not empty fns:getUser().photo ? fns:getUser().photo : 'static/images/tx.jpg'}" style="width:65px;height:65px;padding:1px;" class="img-responsive img-circle img-thumbnail"
                             alt="thumbnail"></A>
                    </div>
                    <h5 class="text-uppercase font-bold m-b-0" id="J_name" style="color:white;">Hi<span>, ${fns:getUser().name}</span></h5>
                </div>
			<DIV class="sidebar-inner slimscrollleft">
				<!--- Divider -->
				<DIV id="sidebar-menu" style="padding-top:10px;">
				
					<UL>
					
					    <c:set var="firstMenu" value="true"/>
					   
						<c:forEach items="${fns:getMenuList()}" var="menu" varStatus="idxStatus">
							<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
								<li class="has_sub ${not empty firstMenu && firstMenu ? ' active' : ''}">
									  <A class="waves-effect ${not empty firstMenu && firstMenu ? ' active' : ''}"
							href="${not empty menu.href ? ctx : ''}${not empty menu.href ? menu.href : 'javascript:void(0);'}" target="${not empty menu.target ? menu.target : 'mainFrame'}"><I class="zmdi zmdi-${not empty menu.icon ? menu.icon : 'view-dashboard'} ti-share"></I><SPAN>${menu.name}</SPAN></A>
										   <UL>
							<c:forEach items="${menuList}" var="menu2">
							
						     <c:if test="${menu2.parent.id eq menu.id&&menu2.isShow eq '1'}">	
						      <li>						 
										<A data-href=".menu3-${menu2.id}" href="${not empty menu2.href ? ctx : ''}${not empty menu2.href ? menu2.href : 'javascript:void(0);'}"  class="waves-effect" target="${not empty menu2.target ? menu2.target : 'mainFrame'}"><SPAN>${menu2.name}</SPAN> </A>
										<UL class="menu3"><c:forEach items="${menuList}" var="menu3">
								          <c:if test="${menu3.parent.id eq menu2.id&&menu3.isShow eq '1'}">	
								            <li>						 
										      <A data-href=".menu3-${menu3.id}" href="${fn:indexOf(menu3.href, '://') eq -1 ? ctx : ''}${not empty menu3.href ? menu3.href : '/404'}" class="waves-effect" target="${not empty menu3.target ? menu3.target : 'mainFrame'}"><SPAN>${menu3.name}</SPAN> </A>
										
								             </li>
								         </c:if>
							             </c:forEach></UL>
								</li>
								</c:if>
							</c:forEach>
						 </UL>
						 
								</li>
								
								<c:set var="firstMenu" value="false"/>
							</c:if>
						</c:forEach>
	
					<DIV class="clearfix"></DIV>
				</DIV>
				<DIV class="clearfix"></DIV>
			</DIV>
		</DIV>
		<!-- Left Sidebar End -->
		<!-- ============================================================== -->
		<!-- Start right Content here -->
		<!-- ============================================================== -->

		<DIV class="content-page">
			<!-- Start content -->
			<DIV class="content">
				<DIV class="container">
					<!-- Page-Title -->
					<iframe id="mainFrame" name="mainFrame" scrolling="auto" frameborder="no" src="${ctx}/oa/home"
						width="100%"></iframe>
				</DIV>
				<!-- container -->
			</DIV>
			<!-- content -->
			<FOOTER class="footer">
				${fns:getConfig('productName')}
			</FOOTER>
		</DIV>
		<!-- ============================================================== -->
		<!-- End Right content here -->
		<!-- ============================================================== -->
		<!-- Right Sidebar -->
		<DIV class="side-bar right-bar">
			<A class="right-bar-toggle" href="javascript:void(0);"><I
				class="zmdi zmdi-close-circle-o"></I> </A>
			<H4>消息提醒</H4>
			<DIV class="notification-list nicescroll">
				<UL class="list-group list-no-border user-list" id="ul-alert">
				</UL>
				<div style="float: right;margin-right: 20px;"><a href="#" title="删除全部" onclick="deleteAlert(this,'');" style="font-size:25px"><i class="zmdi zmdi-delete"></i></a></div>
			</DIV>
		</DIV>
		<!-- /Right-bar -->
		<div id="commonModal" class="modal fade" tabindex="-1" role="dialog"
			 aria-labelledby="myModalLabel" aria-hidden="true"
			 style="display: none;">
			<div class="modal-dialog modal-full">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">×</button>
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
	</DIV>
	<!-- END wrapper -->
	  <script src="${ctxStatic}/assets/js/detect.js"></script>
        <script src="${ctxStatic}/assets/js/fastclick.js"></script>
        <script src="${ctxStatic}/assets/js/jquery.slimscroll.js"></script>
        <script src="${ctxStatic}/assets/js/jquery.blockUI.js"></script>
        <script src="${ctxStatic}/assets/js/waves.js"></script>
        <script src="${ctxStatic}/assets/js/wow.min.js"></script>
        <script src="${ctxStatic}/assets/js/jquery.nicescroll.js"></script>
        <script src="${ctxStatic}/assets/js/jquery.scrollTo.min.js"></script>

  <!-- App js -->
        <script src="${ctxStatic}/assets/js/jquery.core.js"></script>
        <script src="${ctxStatic}/assets/js/jquery.app.js"></script>
	<script src="${ctxStatic}/assets/js/iframeResizer.min.js" type="text/javascript"></script>
	<script type="text/template" id="alertTpl">//<!--
		{{#alertList}}
		<LI class="list-group-item user-list-item">
				<DIV class="avatar">
					<i class="zmdi zmdi-comment" style="font-size:20px"></i>
				</DIV>
				<DIV class="user-desc">
					<SPAN class="name" title="{{title}}">{{title}}</SPAN>
					<SPAN class="desc">{{content}}</SPAN>
					<SPAN class="time">{{createDate}}</SPAN>
					<a href="#" title="删除" onclick="deleteAlert(this,'{{id}}');"><i class="zmdi zmdi-minus-circle-outline" style="float: right;font-size: 18px;"></i></a>
				</DIV>
		</LI>
		{{/alertList}}
	//-->
	</script>
	<script type="text/template" id="todoTpl">//<!--
		{{#todoList}}
		<LI class="list-group-item">
		<a href="{{href}}" class="user-list-item" target="mainFrame">
				<DIV class="avatar">
					<i class="zmdi zmdi-comment" style="font-size:20px"></i>
				</DIV>
				<DIV class="user-desc">
					<SPAN class="name" title="{{no}}">{{no}}</SPAN>
					<SPAN class="desc">{{contract_name}}  -> {{taskName}}</SPAN>
					<SPAN class="time">{{taskCreateDate}}</SPAN>
				</DIV>
		</LI>
		{{/todoList}}
	//-->
	</script>
	<script type="text/javascript">
		var frameResizer = $('#mainFrame').iFrameResize([{log: true, minHeight:700, scrolling:true }]);
		var mainFrame = document.getElementById("mainFrame");
		//$(mainFrame).height($(window).height()-190);

      
		var resizefunc = [];
		var ctx = "${ctx}";
		
		$(".menu3").each(function(){
			 var dec=$(this).html().replace(/[ ]/g,"").replace(/[\r\n]/g,"").replace(/[\t]/g,"");
			 if(dec==""){
			 $(this).remove();
			 }
			})

	</script>
</BODY>
</html>