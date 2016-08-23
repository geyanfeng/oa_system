<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>客户评价参数 -- 查看</title>
    <meta name="decorator" content="default"/>
    <style>
        .table th, .table td {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="panel panel-default">
    <div class="panel-heading">客户评价参数 -- 查看</div>
    <div class="panel-body">
        <div class="row">
            <div class="col-sm-4 col-sm-offset-2">
            <c:forEach items="${list}" var="setting">
                <div class="row m-t-10">
                    <div class="col-sm-10">
                            ${setting.evalType.label}
                    </div>
                    <div class="col-sm-2">
                            ${empty setting.value? '0':setting.value}
                    </div>
                </div>
            </c:forEach>
        </div>
        </div>

        <div class="row m-t-20">
            <div class="col-sm-1 col-sm-offset-5">
                <a id="btnEdit"
                   href="${ctx}/oa/customerEvalSetting/edit"
                   class="btn btn-primary waves-effect waves-light input-sm" title="编辑"
                   data-content="新增">编辑&nbsp;<i
                        class="zmdi zmdi-edit"></i></a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
