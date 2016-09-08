<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>提醒参数 -- 编辑</title>
    <meta name="decorator" content="default"/>
    <style>
        .row {
            margin-top: 10px;
            text-align: center;
        }
        .checkbox{
            padding-left:5px;
        }
        textarea{
            height: 100%;
            width: 100%;
        }
    </style>

    <script>
        $(function(){
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<form:form id="inputForm" modelAttribute="setting" action="${ctx}/oa/alertSetting/save" method="post" role="form">
    <sys:message content="${message}"/>
    <div class="panel panel-default">
        <div class="panel-heading">提醒参数 -- 编辑</div>
        <div class="panel-body">
            <div class="row" style="margin-bottom: 20px;font-weight: 600;">
                <div class="col-sm-1">提醒节点</div>
                <div class="col-sm-4">提醒对象</div>
                <div class="col-sm-2">提醒方式</div>
                <div class="col-sm-1">持续时间</div>
                <div class="col-sm-2">标题</div>
                <div class="col-sm-2">内容</div>
            </div>
            <c:forEach items="${list}" var="setting" varStatus="settingIdx">
                <input type="hidden" name="alertSettingList[${settingIdx.index}].id" value="${setting.id}"/>
                <input type="hidden" name="alertSettingList[${settingIdx.index}].node" value="${setting.node}"/>
                <div class="row">
                    <div class="col-sm-1">${fns: getDictLabel(setting.node, "oa_alert_node" ,"" )}</div>
                    <div class="col-sm-4">
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isSaler[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isSaler" type="checkbox" value="1" <c:if test="${setting.isSaler eq 1}">checked="checked"</c:if>><label for="isSaler[${settingIdx.index}]">销售</label>
                        </span>
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isBusinesser[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isBusinesser" type="checkbox" value="1" <c:if test="${setting.isBusinesser eq 1}">checked="checked"</c:if>><label for="isBusinesser[${settingIdx.index}]">商务</label>
                        </span>
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isTech[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isTech" type="checkbox" value="1" <c:if test="${setting.isTech eq 1}">checked="checked"</c:if>><label for="isTech[${settingIdx.index}]">技术</label>
                        </span>
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isCso[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isCso" type="checkbox" value="1" <c:if test="${setting.isCso eq 1}">checked="checked"</c:if>><label for="isCso[${settingIdx.index}]">销售总监</label>
                        </span>
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isCw[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isCw" type="checkbox" value="1" <c:if test="${setting.isCw eq 1}">checked="checked"</c:if>><label for="isCw[${settingIdx.index}]">财务</label>
                        </span>
                    </div>
                    <div class="col-sm-2">
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isMsg[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isMsg" type="checkbox" value="1" <c:if test="${setting.isMsg eq 1}">checked="checked"</c:if>><label for="isMsg[${settingIdx.index}]">站内通知</label>
                        </span>
                        <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isEmail[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isEmail" type="checkbox" value="1" <c:if test="${setting.isEmail eq 1}">checked="checked"</c:if>><label for="isEmail[${settingIdx.index}]">邮件通知</label>
                        </span>
                        <c:if test="${setting.node eq 'pj'}">
                            <span class="checkbox checkbox-inline checkbox-success ">
                            <input id="isCalendar[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].isCalendar" type="checkbox" value="1" <c:if test="${setting.isCalendar eq 1}">checked="checked"</c:if>><label
                                     for="isCalendar[${settingIdx.index}]">日历提醒</label>
                            </span>
                        </c:if>
                    </div>
                    <div class="col-sm-1">
                        <select id="duration[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].duration" class="form-control input-block required input-sm" style="display: inline-block;padding-left: 0px;padding-right: 0px;">
                            <option value="0" value="1" <c:if test="${setting.duration eq 0}">selected</c:if>>提醒一次</option>
                            <option value="1" <c:if test="${setting.duration eq 1}">selected</c:if>>直到确认</option>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <textarea id="title[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].title" rows="5">${setting.title}</textarea>
                    </div>
                    <div class="col-sm-2">
                        <textarea id="content[${settingIdx.index}]" name="alertSettingList[${settingIdx.index}].content" rows="5">${setting.content}</textarea>
                    </div>
                </div>
            </c:forEach>

            <div class="row m-t-20 pull-right">

                    <button id="btnEdit" type="submit" class="btn btn-primary waves-effect waves-light input-sm"
                            title="保存" data-content="保存">保存&nbsp;<i class="fa fa-save"></i></button>

                    <a id="btnReturn"
                       href="#" onclick="history.go(-1)"
                       class="btn btn-primary waves-effect waves-light input-sm" title="返回"
                       data-content="返回">返回&nbsp;<i
                            class="ti-back-left"></i></a>

            </div>
        </div>
    </div>
</form:form>
</body>
</html>
