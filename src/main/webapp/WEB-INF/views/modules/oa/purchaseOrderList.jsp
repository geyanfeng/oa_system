<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnNew").click(function () {
				var frameSrc = "${ctx}/oa/contract/list?contractType=2&status=10&isSelect=true";
				$('#modal iframe').attr("src", frameSrc);
				$('#modal .modal-title').html('选择合同');
				$('#modal').modal({show: true, backdrop: 'static'});
			});
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }

		//关闭框架合同选择框,并设置相关的值
		function closeSelectContractModal(selectedContract) {
			$('#modal').modal('hide');
			window.location = "${ctx}/oa/contract/view?po=true&id="+ selectedContract.id;
		}
	</script>
</head>
<body>
<div class="panel panel-default">
	<div class="panel-heading">订单列表
		<div class="pull-right">
			<c:if test="${empty isSelect}">
				<shiro:hasPermission name="oa:contract:edit">
					<a id="btnNew" href="#" class="btn btn-primary waves-effect waves-light input-sm" title="新增">新增&nbsp;<i
							class="fa fa-plus"></i></a>
				</shiro:hasPermission>
			</c:if>

		</div>
	</div>
	<div class="panel-body">
		<form:form id="searchForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/" method="post" class="breadcrumb form-search form-inline">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>

			<div class="form-group">
				<label>日期：</label>

				<input name="beginCreateDate" type="text" readonly="readonly"
					   maxlength="20"
					   class="form-control Wdate input-sm"
					   value="<fmt:formatDate value="${purchaseOrder.beginCreateDate}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

				-

				<input name="endCreateDate" type="text" readonly="readonly"
					   maxlength="20"
					   class="form-control Wdate input-sm"
					   value="<fmt:formatDate value="${purchaseOrder.endCreateDate}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

			</div>

			<div class="form-group">
				<label>供应商：</label>

				<form:select path="supplier.id" class="select2-container form-control input-sm" id="supplier" cssStyle="width:200px;">
					<form:option value="" label=""/>
					<form:options items="${supplierList}" itemLabel="name"
								  itemValue="id" htmlEscape="false"/>
				</form:select>

			</div>

			<div class="form-group">
				<label>订单状态：</label>
				<form:select path="status" class="select2-container form-control input-sm" cssStyle="width:100px;">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('oa_po_status')}"
								  itemLabel="label"
								  itemValue="value" htmlEscape="false"/>
				</form:select>

			</div>


			<button id="btnSubmit" class="btn btn-primary input-sm" type="submit" value="查询">
				查询<i class="fa fa-search"></i>
			</button>
		</form:form>
		<sys:message content="${message}"/>
		<table id="contentTable" class="table table-striped table-condensed table-hover">
			<thead>
			<tr>
				<th class="sort-column createDate">日期</th>
				<th class="sort-column no">订单号</th>
				<th class="sort-column contract.no">合同号</th>
				<th>收货类型</th>
				<th class="sort-column address">地址</th>
				<th class="sort-column a9.name">供应商</th>
				<th class="sort-column amount">订单金额</th>
				<th class="sort-column status">订单状态</th>
				<%-- <th>更新时间</th>--%>
				<shiro:hasPermission name="oa:purchaseOrder:edit">
					<th>操作</th>
				</shiro:hasPermission>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${page.list}" var="purchaseOrder">
				<tr data-json='${fns:toJson(purchaseOrder)}'>
					<td>
						<fmt:formatDate value="${purchaseOrder.createDate}" pattern="yyyy-MM-dd"/>
					</td>
					<td>${purchaseOrder.no}</td>
					<td>${purchaseOrder.contract.no}</td>
					<td>
							${fns:getDictLabel(purchaseOrder.addressType, 'oa_po_address_type', '')}
					</td>
					<td>
							${purchaseOrder.address}
					</td>
					<td>
							${purchaseOrder.supplier.name}
					</td>
					<td>
							<fmt:formatNumber type="number" value="${purchaseOrder.amount}" maxFractionDigits="2"/>
					</td>
					<td>
							${fns:getDictLabel(purchaseOrder.status, 'oa_po_status', '')}
					</td>
					<td>
						<shiro:hasPermission name="oa:purchaseOrder:view">
							<a href="${ctx}/oa/purchaseOrder/view?id=${purchaseOrder.id}">查看</a>
						</shiro:hasPermission>
						<shiro:hasPermission name="oa:purchaseOrder:edit">
							<a href="${ctx}/oa/purchaseOrder/form?id=${purchaseOrder.id}">修改</a>
							<a href="${ctx}/oa/purchaseOrder/delete?id=${purchaseOrder.id}"
							   onclick="return confirmx('确认要删除该订单吗吗？', this.href)">删除</a>
						</shiro:hasPermission>
					</td>

				</tr>
			</c:forEach>
			</tbody>
		</table>
		${page}
	</div>
</div>

<div id="modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
	 aria-hidden="true" style="display: none;">
	<div class="modal-dialog modal-full">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
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
</body>
</html>