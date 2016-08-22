<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>人员参数 -- 查看</title>
    <meta name="decorator" content="default"/>
    <style>
        .table th, .table td {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="panel panel-default">
    <div class="panel-heading">人员参数 -- 查看</div>
    <div class="panel-body">
        <div class="row">
            <div class="col-sm-8 col-sm-offset-2">
                <table id="contentTable" class="table">
                    <thead>
                    <tr>
                        <th>销售</th>
                        <th>商务</th>
                        <th>技术</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${list}" var="setting">
                        <tr>
                            <td>
                                    ${setting.saler.name}
                            </td>
                            <td>
                                    ${setting.businessPerson.name}
                            </td>
                            <td>
                                    ${setting.artisan.name}
                            </td>

                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-1 col-sm-offset-9">
                <a id="btnEdit"
                   href="${ctx}/oa/peoplesetting/edit"
                   class="btn btn-primary waves-effect waves-light input-sm" title="编辑"
                   data-content="新增">编辑&nbsp;<i
                        class="zmdi zmdi-edit"></i></a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
