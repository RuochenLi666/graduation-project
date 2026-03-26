<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-cn">

<head>
	<%@ include file="../../static/head.jsp"%>
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
						<h3 class="block-title">骑手详情</h3>
					</div>
					<div class="col-md-6">
						<ol class="breadcrumb">
							<li class="breadcrumb-item">
								<a href="${pageContext.request.contextPath}/index.jsp"><span class="ti-home"></span></a>
							</li>
							<li class="breadcrumb-item"><span>骑手管理</span></li>
							<li class="breadcrumb-item active"><span>骑手详情</span></li>
						</ol>
					</div>
				</div>
			</div>

			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<div class="widget-area-2 lochana-box-shadow">
							<h3 class="widget-title">骑手信息</h3>
							<form id="addOrUpdateForm">
								<div class="form-row">
									<input id="updateId" name="id" type="hidden">
									<div class="form-group col-md-6">
										<label>用户名</label>
										<input id="username" name="username" class="form-control" readonly>
									</div>
									<div class="form-group col-md-6">
										<label>姓名</label>
										<input id="xingming" name="xingming" class="form-control" readonly>
									</div>
									<div class="form-group col-md-6">
										<label>头像</label>
										<div><img id="touxiangImg" src="" width="100" height="100"></div>
									</div>
									<div class="form-group col-md-6">
										<label>手机号</label>
										<input id="phone" name="phone" class="form-control" readonly>
									</div>
									<div class="form-group col-md-6">
										<label>状态</label>
										<input id="status" name="status" class="form-control" readonly>
									</div>
									<div class="form-group-1 col-md-6 mb-3" style="display: flex;flex-wrap: wrap;">
										<button id="exitBtn" type="button" class="btn btn-primary btn-lg">返回</button>
									</div>
								</div>
							</form>
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
	<script>
		<%@ include file="../../utils/menu.jsp"%>
		<%@ include file="../../static/setMenu.js"%>
		<%@ include file="../../utils/baseUrl.jsp"%>

		var tableName = "qishou";
		var ruleForm = {};

		function getDetails() {
			var id = window.sessionStorage.getItem("id");
			if(id != null && id != "" && id != "null"){
				window.sessionStorage.removeItem('id');
				$.ajax({
	                type: "GET",
	                url: baseUrl + "qishou/info/" + id,
	                beforeSend: function(xhr) {xhr.setRequestHeader("token", window.sessionStorage.getItem('token'));},
	                success: function(res){
	                	if(res.code == 0){
	                		ruleForm = res.data;
							$('#username').val(ruleForm.username);
							$('#xingming').val(ruleForm.xingming || '');
							$('#phone').val(ruleForm.phone || '');
							$('#status').val(ruleForm.status || '空闲');
							if(ruleForm.touxiang) $('#touxiangImg').attr('src', baseUrl + ruleForm.touxiang);
		    			}else if(res.code == 401){
		    				<%@ include file="../../static/toLogin.jsp"%>
		    			}else{
						 	alert(res.msg);
						}
	                },
	            });
			}
		}

		function exit(){
			window.sessionStorage.removeItem("id");
			window.location.href = "list.jsp";
		}

		$(document).ready(function() {
			$('.dropdown-menu h5').html(window.sessionStorage.getItem('username')+'('+window.sessionStorage.getItem('role')+')');
			$('.sidebar-header h3 a').html(projectName);
			setMenu();
			$('#exitBtn').on('click', function(e) {
			    e.preventDefault();
				exit();
			});
			getDetails();
			<%@ include file="../../static/myInfo.js"%>
		});
		<%@ include file="../../static/logout.jsp"%>
	</script>
</body>
</html>
