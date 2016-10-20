<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("select").select2({ allowClear: true});

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
<h2 style="padding-left:20px; font-weight: normal;font-size:18px;">
	采购订单列表
		<div class="pull-right">
			<c:if test="${empty isSelect}">
				<shiro:hasPermission name="oa:purchaseOrder:edit">
					<a id="btnNew" href="#" class="btn btn-primary" title="新增"><i
							class="fa fa-plus m-r-5"></i>新增订单</a>
				</shiro:hasPermission>
			</c:if>

		</div>
</h2>
<div class="panel panel-default">

	<div class="panel-body">
		<form:form id="searchForm" modelAttribute="purchaseOrder" action="${ctx}/oa/purchaseOrder/" method="post" class="breadcrumb form-search form-inline">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>

			<div class="form-group m-r-10">
				<label>日期：</label>
<div class="input-group">
				<input name="beginCreateDate" type="text" readonly="readonly"
					   maxlength="20" size="10"
					   class="form-control"
					   value="<fmt:formatDate value="${purchaseOrder.beginCreateDate}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
					   <span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
</div>
<div class="input-group">


				<input name="endCreateDate" type="text" readonly="readonly"
					   maxlength="20"  size="10"
					   class="form-control"
					   value="<fmt:formatDate value="${purchaseOrder.endCreateDate}" pattern="yyyy-MM-dd"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
					   <span class="input-group-addon bg-custom b-0 text-white"><i
							class="ti-calendar"></i></span>
</div>
			</div>

			<div class="form-group m-r-10">
				<label>供应商：</label>

				<form:select path="supplier.id" class="select2-container form-control" id="supplier" cssStyle="width:200px;">
					<form:option value="" label=""/>
					<form:options items="${supplierList}" itemLabel="name"
								  itemValue="id" htmlEscape="false"/>
				</form:select>

			</div>

			<div class="form-group m-r-10">
				<label>订单状态：</label>
				<form:select path="status" class="select2-container form-control" cssStyle="width:150px;">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('oa_po_status')}"
								  itemLabel="label"
								  itemValue="value" htmlEscape="false"/>
				</form:select>

			</div>


			<button id="btnSubmit" class="btn btn-custom" type="submit" value="查询">
				查询</button>
		</form:form>
		<sys:message content="${message}"/>
		<table id="contentTable" class="table table-striped table-condensed table-hover">
			<thead>
			<tr>
				<th class="sort-column createDate">日期</th>
				<th class="sort-column no">订单号</th>
				<th class="sort-column a10.no">合同号</th>
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
					<td>

							<a href="${ctx}/oa/purchaseOrder/view?id=${purchaseOrder.id}">${purchaseOrder.no}</a>

					</td>
					<td>${purchaseOrder.contract.no}</td>
					<td>
							${purchaseOrder.supplier.name}
					</td>
					<td>
							<fmt:formatNumber type="number" value="${purchaseOrder.amount}" maxFractionDigits="2"/>
					</td>
					<td>
							<c:if test="${purchaseOrder.cancelFlag eq 1}"><del class="text-danger"></c:if>${fns:getDictLabel(purchaseOrder.status, 'oa_po_status', '')}<c:if test="${purchaseOrder.cancelFlag eq 1}"></del></c:if>
					</td>
					<td>
						
						<shiro:hasPermission name="oa:purchaseOrder:edit">
							<c:if test="${purchaseOrder.contract.status le '10'}">
								<a href="${ctx}/oa/contract/view?id=${purchaseOrder.contract.id}&po=true&poid=${purchaseOrder.id}" class="m-r-5" title="修改"><i
								class="fa fa-pencil"></i></a>
								<a href="${ctx}/oa/purchaseOrder/delete?id=${purchaseOrder.id}"
								   onclick="return confirmx('确认要删除该订单吗吗？', this.href)" class="m-r-5" title="删除"><i
								class="fa fa-trash"></i></a>
							</c:if>
						</shiro:hasPermission>
						<shiro:hasRole name="businesser">
						<c:if test="${purchaseOrder.evaluateFlag eq '0'}">
						<a href="#" onclick="supplierEvaluation('${purchaseOrder.id}')" title="供应商评价"><i
								class="zmdi zmdi-flower-alt"></i></a>
						</c:if>
						</shiro:hasRole>
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
  <script type="text/javascript">
  //供应商评价
  function supplierEvaluation(id){
      var frameSrc = "${ctx}/oa/oaPoEvaluate/form?poid=" + id;
      var modal = $('#modal');
      modal.find('.modal-dialog').css({width:'500px'});
      modal.find('.modal-full').removeClass('modal-full');
      modal.find('iframe').attr("src", frameSrc);
      modal.find('.modal-title').html('供应商评价');
      modal.modal({show: true, backdrop: 'static'});
  }
   //关闭框架合同选择框,并设置相关的值
	function closeSupplierEvaluatioModal() {
		$('#modal').modal('hide');
		window.location.reload();
	}
  </script>
</body>
</html>