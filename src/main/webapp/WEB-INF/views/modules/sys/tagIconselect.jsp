<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>图标选择</title>
	<meta name="decorator" content="blank"/>
    <style type="text/css">
    	.page-header {clear:both;margin:0 20px;padding-top:20px;}
		.the-icons {padding:25px 10px 15px;list-style:none;}
		.the-icons li {float:left;width:22%;line-height:25px;margin:2px 5px;cursor:pointer;}
		.the-icons i {margin:1px 5px;font-size:16px;} .the-icons li:hover {background-color:#efefef;}
        .the-icons li.active {background-color:#0088CC;color:#ffffff;}
        .the-icons li:hover i{font-size:20px;}
    </style>
    <script type="text/javascript">
	    $(document).ready(function(){
	    	$("#icons li").click(function(){
	    		$("#icons li").removeClass("active");
	    		$("#icons li i").removeClass("icon-white");
	    		$(this).addClass("active");
	    		$(this).children("i").addClass("icon-white");
	    		$("#icon").val($(this).text());
	    	});
	    	$("#icons li").each(function(){
	    		if ($(this).text()=="${value}"){
	    			$(this).click();
	    		}
	    	});
	    	$("#icons li").dblclick(function(){
	    		top.$.jBox.getBox().find("button[value='ok']").trigger("click");
	    	});
	    });
    </script>
</head>
<body>
<input type="hidden" id="icon" value="${value}" />
<div id="icons">
		
	     
                                                            <h4 class="page-header m-t-0">33 New Icons in 2.2</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-group"></i> <span>group</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-rss"></i> <span>rss</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shape"></i> <span>shape</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-spinner"></i> <span>spinner</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-ungroup"></i> <span>ungroup</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-500px"></i> <span>500px</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-8tracks"></i> <span>8tracks</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-amazon"></i> <span>amazon</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-blogger"></i> <span>blogger</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-delicious"></i> <span>delicious</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-disqus"></i> <span>disqus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flattr"></i> <span>flattr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flickr"></i> <span>flickr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-github-alt"></i> <span>github-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-old"></i> <span>google-old</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-linkedin"></i> <span>linkedin</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-odnoklassniki"></i> <span>odnoklassniki</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-outlook"></i> <span>outlook</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-paypal-alt"></i> <span>paypal-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pinterest"></i> <span>pinterest</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-playstation"></i> <span>playstation</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-reddit"></i> <span>reddit</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-skype"></i> <span>skype</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-slideshare"></i> <span>slideshare</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-soundcloud"></i> <span>soundcloud</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tumblr"></i> <span>tumblr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-twitch"></i> <span>twitch</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-vimeo"></i> <span>vimeo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-whatsapp"></i> <span>whatsapp</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-xbox"></i> <span>xbox</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-yahoo"></i> <span>yahoo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-youtube-play"></i> <span>youtube-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-youtube"></i> <span>youtube</span>
                                                                </li>

                                                           </ul>

                                                        
                                                            <h4 class="page-header">Web Application</h4>
                                                            <ul class="the-icons">
                                                                <li>
                                                                    <i class="zmdi zmdi-3d-rotation"></i> <span>3d-rotation</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airplane-off"></i> <span>airplane-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airplane"></i> <span>airplane</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-album"></i> <span>album</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-archive"></i> <span>archive</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment-account"></i> <span>assignment-account</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment-alert"></i> <span>assignment-alert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment-check"></i> <span>assignment-check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment-o"></i> <span>assignment-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment-return"></i> <span>assignment-return</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment-returned"></i>
                                                                    <span>assignment-returned</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-assignment"></i> <span>assignment</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-attachment-alt"></i> <span>attachment-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-attachment"></i> <span>attachment</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-audio"></i> <span>audio</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-badge-check"></i> <span>badge-check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-balance-wallet"></i> <span>balance-wallet</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-balance"></i> <span>balance</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-battery-alert"></i> <span>battery-alert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-battery-flash"></i> <span>battery-flash</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-battery-unknown"></i> <span>battery-unknown</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-battery"></i> <span>battery</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bike"></i> <span>bike</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-block-alt"></i> <span>block-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-block"></i> <span>block</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-boat"></i> <span>boat</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-book-image"></i> <span>book-image</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-book"></i> <span>book</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bookmark-outline"></i> <span>bookmark-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bookmark"></i> <span>bookmark</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brush"></i> <span>brush</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bug"></i> <span>bug</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bus"></i> <span>bus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cake"></i> <span>cake</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-car-taxi"></i> <span>car-taxi</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-car-wash"></i> <span>car-wash</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-car"></i> <span>car</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-giftcard"></i> <span>card-giftcard</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-membership"></i> <span>card-membership</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-travel"></i> <span>card-travel</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card"></i> <span>card</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-case-check"></i> <span>case-check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-case-download"></i> <span>case-download</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-case-play"></i> <span>case-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-case"></i> <span>case</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cast-connected"></i> <span>cast-connected</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cast"></i> <span>cast</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-chart-donut"></i> <span>chart-donut</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-chart"></i> <span>chart</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-city-alt"></i> <span>city-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-city"></i> <span>city</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-close-circle-o"></i> <span>close-circle-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-close-circle"></i> <span>close-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-close"></i> <span>close</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cocktail"></i> <span>cocktail</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-code-setting"></i> <span>code-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-code-smartphone"></i> <span>code-smartphone</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-code"></i> <span>code</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-coffee"></i> <span>coffee</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-bookmark"></i>
                                                                    <span>collection-bookmark</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-case-play"></i>
                                                                    <span>collection-case-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-folder-image"></i>
                                                                    <span>collection-folder-image</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-image-o"></i> <span>collection-image-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-image"></i> <span>collection-image</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-1"></i> <span>collection-item-1</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-2"></i> <span>collection-item-2</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-3"></i> <span>collection-item-3</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-4"></i> <span>collection-item-4</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-5"></i> <span>collection-item-5</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-6"></i> <span>collection-item-6</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-7"></i> <span>collection-item-7</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-8"></i> <span>collection-item-8</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-9-plus"></i>
                                                                    <span>collection-item-9-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item-9"></i> <span>collection-item-9</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-item"></i> <span>collection-item</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-music"></i> <span>collection-music</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-pdf"></i> <span>collection-pdf</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-plus"></i> <span>collection-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-speaker"></i> <span>collection-speaker</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-text"></i> <span>collection-text</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-collection-video"></i> <span>collection-video</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-compass"></i> <span>compass</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cutlery"></i> <span>cutlery</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-delete"></i> <span>delete</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dialpad"></i> <span>dialpad</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dns"></i> <span>dns</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-drink"></i> <span>drink</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-edit"></i> <span>edit</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-email-open"></i> <span>email-open</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-email"></i> <span>email</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-eye-off"></i> <span>eye-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-eye"></i> <span>eye</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-eyedropper"></i> <span>eyedropper</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-favorite-outline"></i> <span>favorite-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-favorite"></i> <span>favorite</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-filter-list"></i> <span>filter-list</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-fire"></i> <span>fire</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flag"></i> <span>flag</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flare"></i> <span>flare</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flash-auto"></i> <span>flash-auto</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flash-off"></i> <span>flash-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flash"></i> <span>flash</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flip"></i> <span>flip</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flower-alt"></i> <span>flower-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flower"></i> <span>flower</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-font"></i> <span>font</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-fullscreen-alt"></i> <span>fullscreen-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-fullscreen-exit"></i> <span>fullscreen-exit</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-fullscreen"></i> <span>fullscreen</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-functions"></i> <span>functions</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gas-station"></i> <span>gas-station</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gesture"></i> <span>gesture</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-globe-alt"></i> <span>globe-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-globe-lock"></i> <span>globe-lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-globe"></i> <span>globe</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-graduation-cap"></i> <span>graduation-cap</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-group"></i> <span>group</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-home"></i> <span>home</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hospital-alt"></i> <span>hospital-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hospital"></i> <span>hospital</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hotel"></i> <span>hotel</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hourglass-alt"></i> <span>hourglass-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hourglass-outline"></i> <span>hourglass-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hourglass"></i> <span>hourglass</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-http"></i> <span>http</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-image-alt"></i> <span>image-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-image-o"></i> <span>image-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-image"></i> <span>image</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-inbox"></i> <span>inbox</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-invert-colors-off"></i> <span>invert-colors-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-invert-colors"></i> <span>invert-colors</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-key"></i> <span>key</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-label-alt-outline"></i> <span>label-alt-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-label-alt"></i> <span>label-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-label-heart"></i> <span>label-heart</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-label"></i> <span>label</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-labels"></i> <span>labels</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-lamp"></i> <span>lamp</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-landscape"></i> <span>landscape</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-layers-off"></i> <span>layers-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-layers"></i> <span>layers</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-library"></i> <span>library</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-link"></i> <span>link</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-lock-open"></i> <span>lock-open</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-lock-outline"></i> <span>lock-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-lock"></i> <span>lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mail-reply-all"></i> <span>mail-reply-all</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mail-reply"></i> <span>mail-reply</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mail-send"></i> <span>mail-send</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mall"></i> <span>mall</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-map"></i> <span>map</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-menu"></i> <span>menu</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-money-box"></i> <span>money-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-money-off"></i> <span>money-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-money"></i> <span>money</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-more-vert"></i> <span>more-vert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-more"></i> <span>more</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-movie-alt"></i> <span>movie-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-movie"></i> <span>movie</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-nature-people"></i> <span>nature-people</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-nature"></i> <span>nature</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-navigation"></i> <span>navigation</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-open-in-browser"></i> <span>open-in-browser</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-open-in-new"></i> <span>open-in-new</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-palette"></i> <span>palette</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-parking"></i> <span>parking</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-account"></i> <span>pin-account</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-assistant"></i> <span>pin-assistant</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-drop"></i> <span>pin-drop</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-help"></i> <span>pin-help</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-off"></i> <span>pin-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin"></i> <span>pin</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pizza"></i> <span>pizza</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plaster"></i> <span>plaster</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-power-setting"></i> <span>power-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-power"></i> <span>power</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-print"></i> <span>print</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-puzzle-piece"></i> <span>puzzle-piece</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-quote"></i> <span>quote</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-railway"></i> <span>railway</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-receipt"></i> <span>receipt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-refresh-alt"></i> <span>refresh-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-refresh-sync-alert"></i> <span>refresh-sync-alert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-refresh-sync-off"></i> <span>refresh-sync-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-refresh-sync"></i> <span>refresh-sync</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-refresh"></i> <span>refresh</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-roller"></i> <span>roller</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-ruler"></i> <span>ruler</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-scissors"></i> <span>scissors</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-screen-rotation-lock"></i>
                                                                    <span>screen-rotation-lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-screen-rotation"></i> <span>screen-rotation</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-search-for"></i> <span>search-for</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-search-in-file"></i> <span>search-in-file</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-search-in-page"></i> <span>search-in-page</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-search-replace"></i> <span>search-replace</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-search"></i> <span>search</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-seat"></i> <span>seat</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-settings-square"></i> <span>settings-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-settings"></i> <span>settings</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shape"></i> <span>shape</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shield-check"></i> <span>shield-check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shield-security"></i> <span>shield-security</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shopping-basket"></i> <span>shopping-basket</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shopping-cart-plus"></i> <span>shopping-cart-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shopping-cart"></i> <span>shopping-cart</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sign-in"></i> <span>sign-in</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sort-amount-asc"></i> <span>sort-amount-asc</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sort-amount-desc"></i> <span>sort-amount-desc</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sort-asc"></i> <span>sort-asc</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sort-desc"></i> <span>sort-desc</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-spellcheck"></i> <span>spellcheck</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-spinner"></i> <span>spinner</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-storage"></i> <span>storage</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-store-24"></i> <span>store-24</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-store"></i> <span>store</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-subway"></i> <span>subway</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sun"></i> <span>sun</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tab-unselected"></i> <span>tab-unselected</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tab"></i> <span>tab</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tag-close"></i> <span>tag-close</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tag-more"></i> <span>tag-more</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tag"></i> <span>tag</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-thumb-down"></i> <span>thumb-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-thumb-up-down"></i> <span>thumb-up-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-thumb-up"></i> <span>thumb-up</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-ticket-star"></i> <span>ticket-star</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-toll"></i> <span>toll</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-toys"></i> <span>toys</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-traffic"></i> <span>traffic</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-translate"></i> <span>translate</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-triangle-down"></i> <span>triangle-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-triangle-up"></i> <span>triangle-up</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-truck"></i> <span>truck</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-turning-sign"></i> <span>turning-sign</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-ungroup"></i> <span>ungroup</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wallpaper"></i> <span>wallpaper</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-washing-machine"></i> <span>washing-machine</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-window-maximize"></i> <span>window-maximize</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-window-minimize"></i> <span>window-minimize</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-window-restore"></i> <span>window-restore</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wrench"></i> <span>wrench</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-zoom-in"></i> <span>zoom-in</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-zoom-out"></i> <span>zoom-out</span>
                                                                </li>

                                                             </ul>
                                                        
                                                            <h4 class="page-header">Notifications</h4>
                                                            <ul class="the-icons">
                                                                <li>
                                                                    <i class="zmdi zmdi-alert-circle-o"></i> <span>alert-circle-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alert-circle"></i> <span>alert-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alert-octagon"></i> <span>alert-octagon</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alert-polygon"></i> <span>alert-polygon</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alert-triangle"></i> <span>alert-triangle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-help-outline"></i> <span>help-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-help"></i> <span>help</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-info-outline"></i> <span>info-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-info"></i> <span>info</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-notifications-active"></i>
                                                                    <span>notifications-active</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-notifications-add"></i> <span>notifications-add</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-notifications-none"></i> <span>notifications-none</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-notifications-off"></i> <span>notifications-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-notifications-paused"></i>
                                                                    <span>notifications-paused</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-notifications"></i> <span>notifications</span>
                                                                </li>

                                                            </ul>
                                                        
                                                            <h4 class="page-header">Person</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-account-add"></i> <span>account-add</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-box-mail"></i> <span>account-box-mail</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-box-o"></i> <span>account-box-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-box-phone"></i> <span>account-box-phone</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-box"></i> <span>account-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-calendar"></i> <span>account-calendar</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-circle"></i> <span>account-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account-o"></i> <span>account-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-account"></i> <span>account</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-accounts-add"></i> <span>accounts-add</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-accounts-alt"></i> <span>accounts-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-accounts-list-alt"></i> <span>accounts-list-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-accounts-list"></i> <span>accounts-list</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-accounts-outline"></i> <span>accounts-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-accounts"></i> <span>accounts</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-face"></i> <span>face</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-female"></i> <span>female</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-male-alt"></i> <span>male-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-male-female"></i> <span>male-female</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-male"></i> <span>male</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mood-bad"></i> <span>mood-bad</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mood"></i> <span>mood</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-run"></i> <span>run</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-walk"></i> <span>walk</span>
                                                                </li>

                                                           </ul>
                                                        
                                                            <h4 class="page-header">File</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-box"></i> <span>cloud-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-circle"></i> <span>cloud-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-done"></i> <span>cloud-done</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-download"></i> <span>cloud-download</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-off"></i> <span>cloud-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-outline-alt"></i> <span>cloud-outline-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-outline"></i> <span>cloud-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud-upload"></i> <span>cloud-upload</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-cloud"></i> <span>cloud</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-download"></i> <span>download</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-file-plus"></i> <span>file-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-file-text"></i> <span>file-text</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-file"></i> <span>file</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-folder-outline"></i> <span>folder-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-folder-person"></i> <span>folder-person</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-folder-star-alt"></i> <span>folder-star-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-folder-star"></i> <span>folder-star</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-folder"></i> <span>folder</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gif"></i> <span>gif</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-upload"></i> <span>upload</span>
                                                                </li>

                                                             </ul>
                                                        
                                                            <h4 class="page-header">Editor</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-border-all"></i> <span>border-all</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-bottom"></i> <span>border-bottom</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-clear"></i> <span>border-clear</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-color"></i> <span>border-color</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-horizontal"></i> <span>border-horizontal</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-inner"></i> <span>border-inner</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-left"></i> <span>border-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-outer"></i> <span>border-outer</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-right"></i> <span>border-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-style"></i> <span>border-style</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-top"></i> <span>border-top</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-border-vertical"></i> <span>border-vertical</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-copy"></i> <span>copy</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop"></i> <span>crop</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-align-center"></i>
                                                                    <span>format-align-center</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-align-justify"></i>
                                                                    <span>format-align-justify</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-align-left"></i> <span>format-align-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-align-right"></i> <span>format-align-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-bold"></i> <span>format-bold</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-clear-all"></i> <span>format-clear-all</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-clear"></i> <span>format-clear</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-color-fill"></i> <span>format-color-fill</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-color-reset"></i> <span>format-color-reset</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-color-text"></i> <span>format-color-text</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-indent-decrease"></i>
                                                                    <span>format-indent-decrease</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-indent-increase"></i>
                                                                    <span>format-indent-increase</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-italic"></i> <span>format-italic</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-line-spacing"></i>
                                                                    <span>format-line-spacing</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-list-bulleted"></i>
                                                                    <span>format-list-bulleted</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-list-numbered"></i>
                                                                    <span>format-list-numbered</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-ltr"></i> <span>format-ltr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-rtl"></i> <span>format-rtl</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-size"></i> <span>format-size</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-strikethrough-s"></i>
                                                                    <span>format-strikethrough-s</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-strikethrough"></i>
                                                                    <span>format-strikethrough</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-subject"></i> <span>format-subject</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-underlined"></i> <span>format-underlined</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-valign-bottom"></i>
                                                                    <span>format-valign-bottom</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-valign-center"></i>
                                                                    <span>format-valign-center</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-format-valign-top"></i> <span>format-valign-top</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-redo"></i> <span>redo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-select-all"></i> <span>select-all</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-space-bar"></i> <span>space-bar</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-text-format"></i> <span>text-format</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-transform"></i> <span>transform</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-undo"></i> <span>undo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wrap-text"></i> <span>wrap-text</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Comment</h4>
                                                            <ul class="the-icons">
                                                                <li>
                                                                    <i class="zmdi zmdi-comment-alert"></i> <span>comment-alert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-alt-text"></i> <span>comment-alt-text</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-alt"></i> <span>comment-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-edit"></i> <span>comment-edit</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-image"></i> <span>comment-image</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-list"></i> <span>comment-list</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-more"></i> <span>comment-more</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-outline"></i> <span>comment-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-text-alt"></i> <span>comment-text-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-text"></i> <span>comment-text</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment-video"></i> <span>comment-video</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comment"></i> <span>comment</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-comments"></i> <span>comments</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Form</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-check-all"></i> <span>check-all</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-check-circle-u"></i> <span>check-circle-u</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-check-circle"></i> <span>check-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-check-square"></i> <span>check-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-check"></i> <span>check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-circle-o"></i> <span>circle-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-circle"></i> <span>circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dot-circle-alt"></i> <span>dot-circle-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dot-circle"></i> <span>dot-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-minus-circle-outline"></i>
                                                                    <span>minus-circle-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-minus-circle"></i> <span>minus-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-minus-square"></i> <span>minus-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-minus"></i> <span>minus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus-circle-o-duplicate"></i>
                                                                    <span>plus-circle-o-duplicate</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus-circle-o"></i> <span>plus-circle-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus-circle"></i> <span>plus-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus-square"></i> <span>plus-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus"></i> <span>plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-square-o"></i> <span>square-o</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-star-circle"></i> <span>star-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-star-half"></i> <span>star-half</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-star-outline"></i> <span>star-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-star"></i> <span>star</span>
                                                                </li>

                                                           </ul>

                                                        
                                                            <h4 class="page-header">Hardware</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-bluetooth-connected"></i>
                                                                    <span>bluetooth-connected</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bluetooth-off"></i> <span>bluetooth-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bluetooth-search"></i> <span>bluetooth-search</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bluetooth-setting"></i> <span>bluetooth-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-bluetooth"></i> <span>bluetooth</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-add"></i> <span>camera-add</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-alt"></i> <span>camera-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-bw"></i> <span>camera-bw</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-front"></i> <span>camera-front</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-mic"></i> <span>camera-mic</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-party-mode"></i> <span>camera-party-mode</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-rear"></i> <span>camera-rear</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-roll"></i> <span>camera-roll</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera-switch"></i> <span>camera-switch</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-camera"></i> <span>camera</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-alert"></i> <span>card-alert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-off"></i> <span>card-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-sd"></i> <span>card-sd</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-card-sim"></i> <span>card-sim</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-desktop-mac"></i> <span>desktop-mac</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-desktop-windows"></i> <span>desktop-windows</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-device-hub"></i> <span>device-hub</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-devices-off"></i> <span>devices-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-devices"></i> <span>devices</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dock"></i> <span>dock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-floppy"></i> <span>floppy</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gamepad"></i> <span>gamepad</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gps-dot"></i> <span>gps-dot</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gps-off"></i> <span>gps-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gps"></i> <span>gps</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-headset-mic"></i> <span>headset-mic</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-headset"></i> <span>headset</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-input-antenna"></i> <span>input-antenna</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-input-composite"></i> <span>input-composite</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-input-hdmi"></i> <span>input-hdmi</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-input-power"></i> <span>input-power</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-input-svideo"></i> <span>input-svideo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-keyboard-hide"></i> <span>keyboard-hide</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-keyboard"></i> <span>keyboard</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-laptop-chromebook"></i> <span>laptop-chromebook</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-laptop-mac"></i> <span>laptop-mac</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-laptop"></i> <span>laptop</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mic-off"></i> <span>mic-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mic-outline"></i> <span>mic-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mic-setting"></i> <span>mic-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mic"></i> <span>mic</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-mouse"></i> <span>mouse</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-network-alert"></i> <span>network-alert</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-network-locked"></i> <span>network-locked</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-network-off"></i> <span>network-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-network-outline"></i> <span>network-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-network-setting"></i> <span>network-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-network"></i> <span>network</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-bluetooth"></i> <span>phone-bluetooth</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-end"></i> <span>phone-end</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-forwarded"></i> <span>phone-forwarded</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-in-talk"></i> <span>phone-in-talk</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-locked"></i> <span>phone-locked</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-missed"></i> <span>phone-missed</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-msg"></i> <span>phone-msg</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-paused"></i> <span>phone-paused</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-ring"></i> <span>phone-ring</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-setting"></i> <span>phone-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone-sip"></i> <span>phone-sip</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-phone"></i> <span>phone</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-portable-wifi-changes"></i>
                                                                    <span>portable-wifi-changes</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-portable-wifi-off"></i> <span>portable-wifi-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-portable-wifi"></i> <span>portable-wifi</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-radio"></i> <span>radio</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-reader"></i> <span>reader</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-remote-control-alt"></i> <span>remote-control-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-remote-control"></i> <span>remote-control</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-router"></i> <span>router</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-scanner"></i> <span>scanner</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-android"></i> <span>smartphone-android</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-download"></i>
                                                                    <span>smartphone-download</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-erase"></i> <span>smartphone-erase</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-info"></i> <span>smartphone-info</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-iphone"></i> <span>smartphone-iphone</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-landscape-lock"></i>
                                                                    <span>smartphone-landscape-lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-landscape"></i>
                                                                    <span>smartphone-landscape</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-lock"></i> <span>smartphone-lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-portrait-lock"></i>
                                                                    <span>smartphone-portrait-lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-ring"></i> <span>smartphone-ring</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-setting"></i> <span>smartphone-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone-setup"></i> <span>smartphone-setup</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-smartphone"></i> <span>smartphone</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-speaker"></i> <span>speaker</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tablet-android"></i> <span>tablet-android</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tablet-mac"></i> <span>tablet-mac</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tablet"></i> <span>tablet</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tv-alt-play"></i> <span>tv-alt-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tv-list"></i> <span>tv-list</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tv-play"></i> <span>tv-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tv"></i> <span>tv</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-usb"></i> <span>usb</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-videocam-off"></i> <span>videocam-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-videocam-switch"></i> <span>videocam-switch</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-videocam"></i> <span>videocam</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-watch"></i> <span>watch</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi-alt-2"></i> <span>wifi-alt-2</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi-alt"></i> <span>wifi-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi-info"></i> <span>wifi-info</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi-lock"></i> <span>wifi-lock</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi-off"></i> <span>wifi-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi-outline"></i> <span>wifi-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wifi"></i> <span>wifi</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Directional</h4>
                                                            <ul class="the-icons">


                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-left-bottom"></i> <span>arrow-left-bottom</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-left"></i> <span>arrow-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-merge"></i> <span>arrow-merge</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-missed"></i> <span>arrow-missed</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-right-top"></i> <span>arrow-right-top</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-right"></i> <span>arrow-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrow-split"></i> <span>arrow-split</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-arrows"></i> <span>arrows</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-down-circle"></i> <span>caret-down-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-down"></i> <span>caret-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-left-circle"></i> <span>caret-left-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-left"></i> <span>caret-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-right-circle"></i> <span>caret-right-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-right"></i> <span>caret-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-up-circle"></i> <span>caret-up-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-caret-up"></i> <span>caret-up</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-chevron-down"></i> <span>chevron-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-chevron-left"></i> <span>chevron-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-chevron-right"></i> <span>chevron-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-chevron-up"></i> <span>chevron-up</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-forward"></i> <span>forward</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-long-arrow-down"></i> <span>long-arrow-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-long-arrow-left"></i> <span>long-arrow-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-long-arrow-return"></i> <span>long-arrow-return</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-long-arrow-right"></i> <span>long-arrow-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-long-arrow-tab"></i> <span>long-arrow-tab</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-long-arrow-up"></i> <span>long-arrow-up</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-rotate-ccw"></i> <span>rotate-ccw</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-rotate-cw"></i> <span>rotate-cw</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-rotate-left"></i> <span>rotate-left</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-rotate-right"></i> <span>rotate-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-square-down"></i> <span>square-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-square-right"></i> <span>square-right</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-swap-alt"></i> <span>swap-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-swap-vertical-circle"></i>
                                                                    <span>swap-vertical-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-swap-vertical"></i> <span>swap-vertical</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-swap"></i> <span>swap</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-trending-down"></i> <span>trending-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-trending-flat"></i> <span>trending-flat</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-trending-up"></i> <span>trending-up</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-unfold-less"></i> <span>unfold-less</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-unfold-more"></i> <span>unfold-more</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Map (aliases)</h4>
                                                            <ul class="the-icons">
                                                                <li>
                                                                    <i class="zmdi zmdi-directions-bike"></i> zmdi-directions-bike
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-boat"></i> zmdi-directions-boat
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-bus"></i> zmdi-directions-bus
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-car"></i> zmdi-directions-car
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-railway"></i> zmdi-directions-railway
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-run"></i> zmdi-directions-run
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-subway"></i> zmdi-directions-subway
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions-walk"></i> zmdi-directions-walk
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-directions"></i> zmdi-directions
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-layers-off"></i> zmdi-layers-off
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-layers"></i> zmdi-layers
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-activity"></i> zmdi-local-activity
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-airport"></i> zmdi-local-airport
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-atm"></i> zmdi-local-atm
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-bar"></i> zmdi-local-bar
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-cafe"></i> zmdi-local-cafe
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-car-wash"></i> zmdi-local-car-wash
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-convenience-store"></i> zmdi-local-convenience-store
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-dining"></i> zmdi-local-dining
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-drink"></i> zmdi-local-drink
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-florist"></i> zmdi-local-florist
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-gas-station"></i> zmdi-local-gas-station
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-grocery-store"></i> zmdi-local-grocery-store
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-hospital"></i> zmdi-local-hospital
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-hotel"></i> zmdi-local-hotel
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-laundry-service"></i> zmdi-local-laundry-service
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-library"></i> zmdi-local-library
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-mall"></i> zmdi-local-mall
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-movies"></i> zmdi-local-movies
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-offer"></i> zmdi-local-offer
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-parking"></i> zmdi-local-parking
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-pharmacy"></i> zmdi-local-pharmacy
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-phone"></i> zmdi-local-phone
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-pizza"></i> zmdi-local-pizza
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-activity"></i> zmdi-local-activity
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-post-office"></i> zmdi-local-post-office
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-printshop"></i> zmdi-local-printshop
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-see"></i> zmdi-local-see
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-shipping"></i> zmdi-local-shipping
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-store"></i> zmdi-local-store
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-taxi"></i> zmdi-local-taxi
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-local-wc"></i> zmdi-local-wc
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-map"></i> zmdi-map
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-my-location"></i> zmdi-my-location
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-nature-people"></i> zmdi-nature-people
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-nature"></i> zmdi-nature
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-navigation"></i> zmdi-navigation
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-account"></i> zmdi-pin-account
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-assistant"></i> zmdi-pin-assistant
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-drop"></i> zmdi-pin-drop
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-help"></i> zmdi-pin-help
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin-off"></i> zmdi-pin-off
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pin"></i> zmdi-pin
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-traffic"></i> zmdi-traffic
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">View</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-apps"></i> <span>apps</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-grid-off"></i> <span>grid-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-grid"></i> <span>grid</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-agenda"></i> <span>view-agenda</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-array"></i> <span>view-array</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-carousel"></i> <span>view-carousel</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-column"></i> <span>view-column</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-comfy"></i> <span>view-comfy</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-compact"></i> <span>view-compact</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-dashboard"></i> <span>view-dashboard</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-day"></i> <span>view-day</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-headline"></i> <span>view-headline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-list-alt"></i> <span>view-list-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-list"></i> <span>view-list</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-module"></i> <span>view-module</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-quilt"></i> <span>view-quilt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-stream"></i> <span>view-stream</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-subtitles"></i> <span>view-subtitles</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-toc"></i> <span>view-toc</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-web"></i> <span>view-web</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-view-week"></i> <span>view-week</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-widgets"></i> <span>widgets</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Date / Time</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-alarm-check"></i> <span>alarm-check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alarm-off"></i> <span>alarm-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alarm-plus"></i> <span>alarm-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alarm-snooze"></i> <span>alarm-snooze</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-alarm"></i> <span>alarm</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-calendar-alt"></i> <span>calendar-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-calendar-check"></i> <span>calendar-check</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-calendar-close"></i> <span>calendar-close</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-calendar-note"></i> <span>calendar-note</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-calendar"></i> <span>calendar</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-time-countdown"></i> <span>time-countdown</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-time-interval"></i> <span>time-interval</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-time-restore-setting"></i>
                                                                    <span>time-restore-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-time-restore"></i> <span>time-restore</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-time"></i> <span>time</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-timer-off"></i> <span>timer-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-timer"></i> <span>timer</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Social</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-android-alt"></i> <span>android-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-android"></i> <span>android</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-apple"></i> <span>apple</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-behance"></i> <span>behance</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-codepen"></i> <span>codepen</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dribbble"></i> <span>dribbble</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-dropbox"></i> <span>dropbox</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-evernote"></i> <span>evernote</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-facebook-box"></i> <span>facebook-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-facebook"></i> <span>facebook</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-github-box"></i> <span>github-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-github"></i> <span>github</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-drive"></i> <span>google-drive</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-earth"></i> <span>google-earth</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-glass"></i> <span>google-glass</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-maps"></i> <span>google-maps</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-pages"></i> <span>google-pages</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-play"></i> <span>google-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-plus-box"></i> <span>google-plus-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-plus"></i> <span>google-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google"></i> <span>google</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-instagram"></i> <span>instagram</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-language-css3"></i> <span>language-css3</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-language-html5"></i> <span>language-html5</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-language-javascript"></i>
                                                                    <span>language-javascript</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-language-python-alt"></i>
                                                                    <span>language-python-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-language-python"></i> <span>language-python</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-lastfm"></i> <span>lastfm</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-linkedin-box"></i> <span>linkedin-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-paypal"></i> <span>paypal</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pinterest-box"></i> <span>pinterest-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pocket"></i> <span>pocket</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-polymer"></i> <span>polymer</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-rss"></i> <span>rss</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-share"></i> <span>share</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-stackoverflow"></i> <span>stackoverflow</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-steam-square"></i> <span>steam-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-steam"></i> <span>steam</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-twitter-box"></i> <span>twitter-box</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-twitter"></i> <span>twitter</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-vk"></i> <span>vk</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wikipedia"></i> <span>wikipedia</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-windows"></i> <span>windows</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-500px"></i> <span>500px</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-8tracks"></i> <span>8tracks</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-amazon"></i> <span>amazon</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-blogger"></i> <span>blogger</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-delicious"></i> <span>delicious</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-disqus"></i> <span>disqus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flattr"></i> <span>flattr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flickr"></i> <span>flickr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-github-alt"></i> <span>github-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-google-old"></i> <span>google-old</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-linkedin"></i> <span>linkedin</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-odnoklassniki"></i> <span>odnoklassniki</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-outlook"></i> <span>outlook</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-paypal-alt"></i> <span>paypal-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pinterest"></i> <span>pinterest</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-playstation"></i> <span>playstation</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-reddit"></i> <span>reddit</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-skype"></i> <span>skype</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-slideshare"></i> <span>slideshare</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-soundcloud"></i> <span>soundcloud</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tumblr"></i> <span>tumblr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-twitch"></i> <span>twitch</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-vimeo"></i> <span>vimeo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-whatsapp"></i> <span>whatsapp</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-xbox"></i> <span>xbox</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-yahoo"></i> <span>yahoo</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-youtube-play"></i> <span>youtube-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-youtube"></i> <span>youtube</span>
                                                                </li>

                                                             </ul>

                                                        
                                                            <h4 class="page-header">Image</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-aspect-ratio-alt"></i> <span>aspect-ratio-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-aspect-ratio"></i> <span>aspect-ratio</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-blur-circular"></i> <span>blur-circular</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-blur-linear"></i> <span>blur-linear</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-blur-off"></i> <span>blur-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-blur"></i> <span>blur</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-2"></i> <span>brightness-2</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-3"></i> <span>brightness-3</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-4"></i> <span>brightness-4</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-5"></i> <span>brightness-5</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-6"></i> <span>brightness-6</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-7"></i> <span>brightness-7</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-auto"></i> <span>brightness-auto</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-brightness-setting"></i> <span>brightness-setting</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-broken-image"></i> <span>broken-image</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-center-focus-strong"></i>
                                                                    <span>center-focus-strong</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-center-focus-weak"></i> <span>center-focus-weak</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-compare"></i> <span>compare</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-16-9"></i> <span>crop-16-9</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-3-2"></i> <span>crop-3-2</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-5-4"></i> <span>crop-5-4</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-7-5"></i> <span>crop-7-5</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-din"></i> <span>crop-din</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-free"></i> <span>crop-free</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-landscape"></i> <span>crop-landscape</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-portrait"></i> <span>crop-portrait</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-crop-square"></i> <span>crop-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-exposure-alt"></i> <span>exposure-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-exposure"></i> <span>exposure</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-filter-b-and-w"></i> <span>filter-b-and-w</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-filter-center-focus"></i>
                                                                    <span>filter-center-focus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-filter-frames"></i> <span>filter-frames</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-filter-tilt-shift"></i> <span>filter-tilt-shift</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-gradient"></i> <span>gradient</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-grain"></i> <span>grain</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-graphic-eq"></i> <span>graphic-eq</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hdr-off"></i> <span>hdr-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hdr-strong"></i> <span>hdr-strong</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hdr-weak"></i> <span>hdr-weak</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hdr"></i> <span>hdr</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-iridescent"></i> <span>iridescent</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-leak-off"></i> <span>leak-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-leak"></i> <span>leak</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-looks"></i> <span>looks</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-loupe"></i> <span>loupe</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-panorama-horizontal"></i>
                                                                    <span>panorama-horizontal</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-panorama-vertical"></i> <span>panorama-vertical</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-panorama-wide-angle"></i>
                                                                    <span>panorama-wide-angle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-photo-size-select-large"></i>
                                                                    <span>photo-size-select-large</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-photo-size-select-small"></i>
                                                                    <span>photo-size-select-small</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-picture-in-picture"></i> <span>picture-in-picture</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-slideshow"></i> <span>slideshow</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-texture"></i> <span>texture</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tonality"></i> <span>tonality</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-vignette"></i> <span>vignette</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-wb-auto"></i> <span>wb-auto</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Audio / Video</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-eject-alt"></i> <span>eject-alt</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-eject"></i> <span>eject</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-equalizer"></i> <span>equalizer</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-fast-forward"></i> <span>fast-forward</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-fast-rewind"></i> <span>fast-rewind</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-forward-10"></i> <span>forward-10</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-forward-30"></i> <span>forward-30</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-forward-5"></i> <span>forward-5</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hearing"></i> <span>hearing</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pause-circle-outline"></i>
                                                                    <span>pause-circle-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pause-circle"></i> <span>pause-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-pause"></i> <span>pause</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-play-circle-outline"></i>
                                                                    <span>play-circle-outline</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-play-circle"></i> <span>play-circle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-play"></i> <span>play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-playlist-audio"></i> <span>playlist-audio</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-playlist-plus"></i> <span>playlist-plus</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-repeat-one"></i> <span>repeat-one</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-repeat"></i> <span>repeat</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-replay-10"></i> <span>replay-10</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-replay-30"></i> <span>replay-30</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-replay-5"></i> <span>replay-5</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-replay"></i> <span>replay</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-shuffle"></i> <span>shuffle</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-skip-next"></i> <span>skip-next</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-skip-previous"></i> <span>skip-previous</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-stop"></i> <span>stop</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-surround-sound"></i> <span>surround-sound</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tune"></i> <span>tune</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-volume-down"></i> <span>volume-down</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-volume-mute"></i> <span>volume-mute</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-volume-off"></i> <span>volume-off</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-volume-up"></i> <span>volume-up</span>
                                                                </li>

                                                            </ul>

                                                        
                                                            <h4 class="page-header">Numbers</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-n-1-square"></i> <span>n-1-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-n-2-square"></i> <span>n-2-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-n-3-square"></i> <span>n-3-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-n-4-square"></i> <span>n-4-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-n-5-square"></i> <span>n-5-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-n-6-square"></i> <span>n-6-square</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-neg-1"></i> <span>neg-1</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-neg-2"></i> <span>neg-2</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus-1"></i> <span>plus-1</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-plus-2"></i> <span>plus-2</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sec-10"></i> <span>sec-10</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-sec-3"></i> <span>sec-3</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-zero"></i> <span>zero</span>
                                                                </li>

                                                             </ul>

                                                        
                                                            <h4 class="page-header">Other</h4>
                                                            <ul class="the-icons">

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-flat-angled"></i>
                                                                    <span>airline-seat-flat-angled</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-flat"></i> <span>airline-seat-flat</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-individual-suite"></i> <span>airline-seat-individual-suite</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-legroom-extra"></i> <span>airline-seat-legroom-extra</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-legroom-normal"></i> <span>airline-seat-legroom-normal</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-legroom-reduced"></i> <span>airline-seat-legroom-reduced</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-recline-extra"></i> <span>airline-seat-recline-extra</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airline-seat-recline-normal"></i> <span>airline-seat-recline-normal</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-airplay"></i> <span>airplay</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-closed-caption"></i> <span>closed-caption</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-confirmation-number"></i>
                                                                    <span>confirmation-number</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-developer-board"></i> <span>developer-board</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-disc-full"></i> <span>disc-full</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-explicit"></i> <span>explicit</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flight-land"></i> <span>flight-land</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flight-takeoff"></i> <span>flight-takeoff</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flip-to-back"></i> <span>flip-to-back</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-flip-to-front"></i> <span>flip-to-front</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-group-work"></i> <span>group-work</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hd"></i> <span>hd</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-hq"></i> <span>hq</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-markunread-mailbox"></i> <span>markunread-mailbox</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-memory"></i> <span>memory</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-nfc"></i> <span>nfc</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-play-for-work"></i> <span>play-for-work</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-power-input"></i> <span>power-input</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-present-to-all"></i> <span>present-to-all</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-satellite"></i> <span>satellite</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-tap-and-play"></i> <span>tap-and-play</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-vibration"></i> <span>vibration</span>
                                                                </li>

                                                                <li>
                                                                    <i class="zmdi zmdi-voicemail"></i> <span>voicemail</span>
                                                                </li>

                                                             </ul>
	<br/><br/>
</div>
</body>