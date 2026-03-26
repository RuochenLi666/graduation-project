<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-cn">

<head>
	<%@ include file="../../static/head.jsp"%>
</head>
<style>
	.error{ color:red; }
</style>
<body>
	<div class="loading">
		<div class="spinner">
			<div class="double-bounce1"></div>
			<div class="double-bounce2"></div>
		</div>
	</div>
	<div class="wrapper">
		<div id="contentText">
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
						<h3 class="block-title">骑手管理</h3>
					</div>
					<div class="col-md-6">
						<ol class="breadcrumb">
							<li class="breadcrumb-item">
								<a href="${pageContext.request.contextPath}/index.jsp"><span class="ti-home"></span></a>
							</li>
							<li class="breadcrumb-item"><span>骑手管理</span></li>
							<li class="breadcrumb-item active"><span>编辑骑手</span></li>
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
										<input name="username" id="username" class="form-control" placeholder="用户名（登录账号）">
									</div>
									<div class="form-group col-md-6">
										<label>密码</label>
										<input name="password" id="password" class="form-control" placeholder="密码">
									</div>
									<div class="form-group col-md-6">
										<label>姓名</label>
										<input name="xingming" id="xingming" class="form-control" placeholder="真实姓名">
									</div>
									<div class="form-group col-md-6">
										<label>手机号</label>
										<input name="phone" id="phone" class="form-control" placeholder="手机号">
									</div>
									<div class="form-group col-md-6">
										<label>头像</label>
										<div><img id="touxiangImg" src="" width="100" height="100"></div>
										<div>
											<input type="hidden" id="touxiang" name="touxiang">
											<input type="file" id="touxiangFile" onchange="uploadImg('touxiang')">
										</div>
									</div>
									<div class="form-group col-md-6">
										<label>状态</label>
										<select name="status" id="status" class="form-control">
											<option value="空闲">空闲</option>
											<option value="配送中">配送中</option>
										</select>
									</div>
									<div class="form-group-1 col-md-6 mb-3" style="display: flex;flex-wrap: wrap;">
										<button id="submitBtn" type="button" class="btn btn-primary btn-lg">提交</button>
										<button id="exitBtn" type="button" class="btn btn-primary btn-lg" style="margin-left:10px;">返回</button>
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
	<script src="${pageContext.request.contextPath}/resources/js/vue.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.ui.widget.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.form.js"></script>

	<script>
		<%@ include file="../../utils/menu.jsp"%>
		<%@ include file="../../static/setMenu.js"%>
		<%@ include file="../../utils/baseUrl.jsp"%>

		var tableName = "qishou";
		var pageType = "add-or-update";
		var updateId = "";
		var ruleForm = {};

		function init() {}

		// 图片上传
		function uploadImg(fieldName) {
			var fileInput = document.getElementById(fieldName + 'File');
			var file = fileInput.files[0];
			if (!file) return;
			var formData = new FormData();
			formData.append('file', file);
			$.ajax({
				url: baseUrl + 'file/upload',
				type: 'POST',
				data: formData,
				processData: false,
				contentType: false,
				beforeSend: function(xhr) { xhr.setRequestHeader("token", window.sessionStorage.getItem('token')); },
				success: function(res) {
					if (res.code == 0) {
						$('#' + fieldName).val(res.data);
						$('#' + fieldName + 'Img').attr('src', baseUrl + res.data);
					}
				}
			});
		}

		function getDetails() {
			var id = window.sessionStorage.getItem("id");
			if(id != null && id != "" && id != "null"){
				$("#submitBtn").addClass("修改");
				updateId = id;
				window.sessionStorage.removeItem('id');
				$.ajax({ 
	                type: "GET",
	                url: baseUrl + "qishou/info/" + id,
	                beforeSend: function(xhr) {xhr.setRequestHeader("token", window.sessionStorage.getItem('token'));},
	                success: function(res){           
	                	if(res.code == 0){
	                		ruleForm = res.data;
							fillForm();
		    			}else if(res.code == 401){
		    				<%@ include file="../../static/toLogin.jsp"%>
		    			}else{
						 	alert(res.msg);
						}
	                },
	            });
			}else{
				$("#submitBtn").addClass("新增");
			}
		}

		function fillForm(){
			$('#updateId').val(ruleForm.id);
			$('#username').val(ruleForm.username);
			$('#password').val(ruleForm.password);
			$('#xingming').val(ruleForm.xingming);
			$('#phone').val(ruleForm.phone);
			$('#touxiang').val(ruleForm.touxiang);
			if(ruleForm.touxiang) $('#touxiangImg').attr('src', baseUrl + ruleForm.touxiang);
			$('#status').val(ruleForm.status || '空闲');
		}

		function submit(){
			var data = {
				id: $('#updateId').val() || null,
				username: $('#username').val(),
				password: $('#password').val(),
				xingming: $('#xingming').val(),
				phone: $('#phone').val(),
				touxiang: $('#touxiang').val(),
				status: $('#status').val()
			};
			if(!data.username){ alert('请输入用户名'); return; }
			if(!data.password){ alert('请输入密码'); return; }

			var url = updateId ? 'qishou/update' : 'qishou/save';
			httpJson(url, "POST", data, (res)=>{
				if(res.code == 0){
					alert(updateId ? '修改成功' : '保存成功');
					window.location.href = "list.jsp";
				}else{
					alert(res.msg);
				}
			});
		}

		function exit(){
			window.sessionStorage.removeItem("id");
			window.location.href = "list.jsp";
		}

		$(document).ready(function() {
			$('.dropdown-menu h5').html(window.sessionStorage.getItem('username')+'('+window.sessionStorage.getItem('role')+')');
			$('.sidebar-header h3 a').html(projectName);
			setMenu();
			$('#submitBtn').on('click', function(e) {
				e.preventDefault();
				submit();
			});
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
