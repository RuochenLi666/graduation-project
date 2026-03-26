<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-cn">

<head>
	<%@ include file="../../static/head.jsp"%>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/font-awesome.min.css">
</head>
<style>
</style>
<body>
	<div class="loading">
		<div class="spinner">
			<div class="double-bounce1"></div>
			<div class="double-bounce2"></div>
		</div>
	</div>
	<div class="wrapper">
		<div id="content">
			<%@ include file="../../static/topNav.jsp"%>
			<div class="container menu-nav">
				<nav class="navbar navbar-expand-lg lochana-bg text-white">
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
					 aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="ti-menu text-white"></span>
					</button>
					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul id="navUl" class="navbar-nav mr-auto"></ul>
					</div>
				</nav>
			</div>
			<div class="container mt-0">
				<div class="row breadcrumb-bar">
					<div class="col-md-6">
						<h3 class="block-title">我的配送订单</h3>
					</div>
					<div class="col-md-6">
						<ol class="breadcrumb">
							<li class="breadcrumb-item">
								<a href="${pageContext.request.contextPath}/index.jsp"><span class="ti-home"></span></a>
							</li>
							<li class="breadcrumb-item active"><span>我的配送订单</span></li>
						</ol>
					</div>
				</div>
			</div>

			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<div class="widget-area-2 lochana-box-shadow">
							<h3 class="widget-title">配送订单列表</h3>
							<div class="table-responsive mb-3" id="tableDiv">
								<table id="tableId" class="table table-bordered table-striped">
									<thead>
										<tr>
											<th>订单编号</th>
											<th>商品名称</th>
											<th>收货人</th>
											<th>地址</th>
											<th>电话</th>
											<th>配送状态</th>
											<th>操作</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
								<div class="col-md-6 col-sm-3 z-pages" style="flex:none;max-width:inherit;display:flex;">
									<div class="dataTables_length" id="tableId_length">
										<select name="tableId_length" aria-controls="tableId" id="selectPageSize" onchange="changePageSize()">
											<option value="10">10</option>
											<option value="25">25</option>
											<option value="50">50</option>
											<option value="100">100</option>
										</select>
										<span class="text">条每页</span>
									</div>
									<nav aria-label="Page navigation example">
										<ul class="pagination justify-content-end">
											<li class="page-item" id="tableId_previous" onclick="pageNumChange('pre')">
												<a class="page-link" href="#" tabindex="-1">上一页</a>
											</li>
											<li class="page-item" id="tableId_next" onclick="pageNumChange('next')">
												<a class="page-link" href="#">下一页</a>
											</li>
										</ul>
									</nav>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<a id="back-to-top" href="#" class="back-to-top">
		<span class="ti-angle-up"></span>
	</a>
	<%@ include file="../../static/foot.jsp"%>

	<!-- 更新状态弹窗 -->
	<div class="modal fade" id="statusModal" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">更新配送状态</h5>
	        <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
	      </div>
	      <div class="modal-body">
	        <p>订单：<strong id="modal-orderid"></strong></p>
	        <div class="form-group">
	          <label>配送状态</label>
	          <select id="modal-status" class="form-control">
	            <option value="配送中">配送中</option>
	            <option value="已送达">已送达</option>
	          </select>
	        </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" onclick="confirmUpdateStatus()">确认更新</button>
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">取消</button>
	      </div>
	    </div>
	  </div>
	</div>

	<script>
		<%@ include file="../../utils/menu.jsp"%>
		<%@ include file="../../static/setMenu.js"%>
		<%@ include file="../../utils/baseUrl.jsp"%>

		var pageIndex = 1;
		var pageSize = 10;
		var totalPage = 0;
		var dataList = [];
		var currentOrderId = null;

		function changePageSize() {
		    var selection = document.getElementById('selectPageSize');
		    var index = selection.selectedIndex;
			pageSize = selection.options[index].value;
			getDataList();
        }

		function getDataList() {
			http("qishou/myOrders","GET",{
				page: pageIndex,
				limit: pageSize,
			},(res)=>{
				if(res.code == 0){
					clear();
					dataList = res.data.list;
					totalPage = res.data.totalPage;
					for(var i = 0; i < dataList.length; i++){
						var trow = setDataRow(dataList[i], i);
						$('tbody').append(trow);
					}
					pagination();
				}
			});
        }

		function setDataRow(item, number){
			var row = document.createElement('tr');
			row.setAttribute('class','useOnce');

			var orderidCell = document.createElement('td');
			orderidCell.innerHTML = item.orderid || '';
			row.appendChild(orderidCell);

			var goodnameCell = document.createElement('td');
			goodnameCell.innerHTML = item.goodname || '';
			row.appendChild(goodnameCell);

			var consigneeCell = document.createElement('td');
			consigneeCell.innerHTML = item.consignee || '';
			row.appendChild(consigneeCell);

			var addressCell = document.createElement('td');
			addressCell.innerHTML = item.address || '';
			row.appendChild(addressCell);

			var telCell = document.createElement('td');
			telCell.innerHTML = item.tel || '';
			row.appendChild(telCell);

			var statusCell = document.createElement('td');
			var statusColor = item.peisongstatus == '已送达' ? 'badge-success' : item.peisongstatus == '配送中' ? 'badge-warning' : 'badge-secondary';
			statusCell.innerHTML = '<span class="badge ' + statusColor + '">' + (item.peisongstatus || '待分配') + '</span>';
			row.appendChild(statusCell);

			var btnGroup = document.createElement('td');
			if(item.peisongstatus != '已送达'){
				var updateBtn = document.createElement('button');
				updateBtn.setAttribute("type","button");
				updateBtn.setAttribute("class","btn btn-primary btn-sm");
				updateBtn.setAttribute("onclick","openStatusModal(" + item.id + ", '" + item.orderid + "', '" + (item.peisongstatus||'') + "')");
				updateBtn.innerHTML = "更新状态";
				btnGroup.appendChild(updateBtn);
			}
			row.appendChild(btnGroup);
			return row;
		}

		function openStatusModal(orderId, orderid, currentStatus) {
			currentOrderId = orderId;
			$('#modal-orderid').text(orderid);
			if(currentStatus == '配送中'){
				$('#modal-status').val('已送达');
			} else {
				$('#modal-status').val('配送中');
			}
			$('#statusModal').modal('show');
		}

		function confirmUpdateStatus() {
			var newStatus = $('#modal-status').val();
			http("qishou/updateDeliveryStatus","GET",{
				orderId: currentOrderId,
				peisongstatus: newStatus
			},(res)=>{
				if(res.code == 0){
					$('#statusModal').modal('hide');
					alert('状态更新成功');
					getDataList();
				}else{
					alert(res.msg);
				}
			});
		}

		function pageNumChange(val) {
            if(val == 'pre') pageIndex--;
            else if(val == 'next') pageIndex++;
            else pageIndex = val;
			getDataList();
        }

		function pagination() {
			var beginIndex = pageIndex;
			var endIndex = pageIndex;
			var point = 4;
			for(var i=0;i<3;i++){ if(endIndex==totalPage){break;} endIndex++; point--; }
			for(var i=0;i<3;i++){ if(beginIndex==1){break;} beginIndex--; point--; }
			if(point>0){
				while(point>0){ if(endIndex==totalPage){break;} endIndex++; point--; }
				while(point>0){ if(beginIndex==1){break;} beginIndex--; point--; }
			}
			if(pageIndex>1) $('#tableId_previous').show();
			else $('#tableId_previous').hide();
			for(var i=beginIndex;i<=endIndex;i++){
				var pageNum = document.createElement('li');
				pageNum.setAttribute('onclick',"pageNumChange("+i+")");
				if(pageIndex == i) pageNum.setAttribute('class','paginate_button page-item active useOnce');
				else pageNum.setAttribute('class','paginate_button page-item useOnce');
				var pageHref = document.createElement('a');
				pageHref.setAttribute('class','page-link');
				pageHref.setAttribute('href','#');
				pageHref.innerHTML = i;
				pageNum.appendChild(pageHref);
				$('#tableId_next').before(pageNum);
			}
			if(pageIndex < totalPage) $('#tableId_next').show();
			else $('#tableId_next').hide();
		}

		function clear(){
        	var elements = document.getElementsByClassName('useOnce');
        	for(var i = elements.length - 1; i >= 0; i--) {
        	  elements[i].parentNode.removeChild(elements[i]);
        	}
        }

		$(document).ready(function() {
			$('#tableId_previous').attr('class','paginate_button page-item previous');
			$('#tableId_next').attr('class','paginate_button page-item next');
			$('.dropdown-menu h5').html(window.sessionStorage.getItem('username')+'('+window.sessionStorage.getItem('role')+')');
			$('.sidebar-header h3 a').html(projectName);
			setMenu();
			getDataList();
			<%@ include file="../../static/myInfo.js"%>
		});
		<%@ include file="../../static/logout.jsp"%>
	</script>
</body>
</html>
