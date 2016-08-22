<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>人员参数 -- 编辑</title>
    <meta name="decorator" content="default"/>
    <style>
        .table th, .table td {
            text-align: center;
        }
    </style>
</head>
<body>
<form:form id="inputForm" modelAttribute="setting" action="${ctx}/oa/peoplesetting/save" method="post" role="form">
    <div class="panel panel-default">
        <div class="panel-heading">人员参数 -- 编辑</div>
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-8 col-sm-offset-2">
                    <table id="contentTable" class="table">
                        <thead>
                        <tr>
                            <th class="hidden"></th>
                            <th>销售</th>
                            <th>商务</th>
                            <th>技术</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${list}" var="peopleSetting" varStatus="settingIdx">
                            <tr>
                                <td class="hidden">
                                    <input name="peopleSettingCollocations[${settingIdx.index}].id" value="${peopleSetting.id}"
                                           class="hidden">
                                </td>
                                <td>
                                    <input name="peopleSettingCollocations[${settingIdx.index}].saler" value="${peopleSetting.saler.id}"
                                           class="hidden">
                                        ${peopleSetting.saler.name}
                                </td>
                                <td>
                                    <select name="peopleSettingCollocations[${settingIdx.index}].businessPerson"
                                            data-value="${peopleSetting.businessPerson}"
                                            class="form-control input-block required input-sm" style="width: 150px;">
                                        <c:forEach items="${businessPeopleList}" var="dict">
                                            <option value="${dict.id}">${dict.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select name="peopleSettingCollocations[${settingIdx.index}].artisan"
                                            data-value="${peopleSetting.artisan}"
                                            class="form-control input-block required input-sm" style="width: 150px;">
                                        <c:forEach items="${artisanList}" var="dict">
                                            <option value="${dict.id}">${dict.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-1 col-sm-offset-8">
                    <button id="btnEdit" type="submit" class="btn btn-primary waves-effect waves-light input-sm"
                            title="保存" data-content="保存">保存&nbsp;<i class="fa fa-save"></i></button>
                </div>
                <div class="col-sm-1">
                    <a id="btnReturn"
                       href="#" onclick="history.go(-1)"
                       class="btn btn-primary waves-effect waves-light input-sm" title="返回"
                       data-content="返回">返回&nbsp;<i
                            class="ti-back-left"></i></a>
                </div>
            </div>
        </div>
    </div>
</form:form>
<script>
    $(function(){
        $("select").each(function () {
            $(this).val($(this).attr("data-value")).trigger("change");
        });
    });
</script>
</body>
</html>
