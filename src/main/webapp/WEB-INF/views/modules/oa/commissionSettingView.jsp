<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>佣金参数 -- 查看</title>
    <meta name="decorator" content="default"/>
    <style>
        .row {
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="panel panel-default">
    <div class="panel-heading">佣金参数 -- 查看</div>
    <div class="panel-body">
        <div class="col-sm-6">
            <!--提成系数SCC设置-->
            <h4 class="text-custom">提成系数SCC设置</h4>
            <div class="row">
                <div class="col-sm-10">
                    完成毛利GP情况
                </div>
                <div class="col-sm-2">
                    参数
                </div>
            </div>
            <c:forEach items="${list1}" var="setting">
                <div class="row">
                    <div class="col-sm-10">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                            ${empty setting.avalue? '0':setting.avalue}
                    </div>
                </div>
            </c:forEach>

            <!--税收点数TR与调整系数AC设置-->
         <%--   <h4 class="text-custom">税收点数TR与调整系数AC设置</h4>
            <div class="row">
                <div class="col-sm-8">
                    产品组
                </div>
                <div class="col-sm-2">
                    税收点数TR
                </div>
            </div>
            <c:forEach items="${list2}" var="setting">
                <div class="row">
                    <div class="col-sm-8">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                            ${empty setting.avalue? '0':setting.avalue}
                    </div>
                </div>
            </c:forEach>


            <!--调整系数AC与激励系数EC设置-->
            <h4 class="text-custom">调整系数AC与激励系数EC设置</h4>
            <div class="row">
                <div class="col-sm-8">
                    产品组
                </div>
                <div class="col-sm-2">
                    调整系数AC
                </div>
                <div class="col-sm-2">
                    激励系数EC
                </div>
            </div>
            <c:forEach items="${list3}" var="setting">
                <div class="row">
                    <div class="col-sm-8">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                            ${empty setting.avalue? '0':setting.avalue}
                    </div>
                    <div class="col-sm-2">
                            ${empty setting.bvalue? '0':setting.bvalue}
                    </div>
                </div>
            </c:forEach>--%>


            <!--账期点数PCC设置-->
            <h4 class="text-custom">账期点数PCC设置</h4>
            <div class="row">
                <div class="col-sm-8">
                    账期PC
                </div>
                <div class="col-sm-2">
                    账期点数PCC
                </div>
            </div>
            <c:forEach items="${list4}" var="setting">
                <div class="row">
                    <div class="col-sm-8">
                            ${setting.fkey.label}
                    </div>
                    <div class="col-sm-2">
                            ${empty setting.avalue? '0':setting.avalue}
                    </div>
                </div>
            </c:forEach>



            <div class="row m-t-20">
                <div class="col-sm-1 col-sm-offset-10">
                    <a id="btnEdit"
                       href="${ctx}/oa/commissionSetting/edit"
                       class="btn btn-primary waves-effect waves-light input-sm" title="编辑"
                       data-content="新增">编辑&nbsp;<i
                            class="zmdi zmdi-edit"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
