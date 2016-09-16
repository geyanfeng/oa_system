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
<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">人员参数 -- 查看</h2>
<div class="panel panel-default">
    <div class="panel-body">
        <div class="row">

                <table id="contentTable" class="table table-striped m-0">
                    <thead>
                    <tr>
                        <th>销售</th>
                        <th>商务</th>
                        <th>技术</th>
                        <th>Q1指标</th>
                        <th>Q2指标</th>
                        <th>Q3指标</th>
                        <th>Q4指标</th>
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
                              <td>
                                    ${setting.gpiQ1}
                            </td>
 							 <td>
                                    ${setting.gpiQ2}
                            </td>
                             <td>
                                    ${setting.gpiQ3}
                            </td>
                             <td>
                                    ${setting.gpiQ4}
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

        </div>
		<br/>
        <div class="row text-center">
                <a id="btnEdit"
                   href="${ctx}/oa/peoplesetting/edit"
                   class="btn btn-custom" title="编辑"
                   data-content="新增">编辑</a>
            </div>

    </div>
</div>
</body>
</html>
