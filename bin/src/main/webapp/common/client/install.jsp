<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	String link_url = request.getParameter( "link_url" );
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<title>Pass-Ni NX Client 설치</title>
	<meta charset="utf-8" />
	<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
	
	<link href="<c:url value='/resources/user/images/logo/favicon.ico'/>" rel="icon" />
	<link href="<c:url value='/resources/user/css/install.css'/>" rel="stylesheet" />
	
</head>
<body>

	<div id="member-login" class="agree">
	    <header>
	    </header>
	    <section>
	        <h2>Pass-Ni NX Client 설치</h2>
	        <h2><img id="loading-image" src="loading.gif" alt="Pass-Ni NX Client Install ..." /></h2>
	        <div class="text">
	        	<p>■ WEB 시스템과 C/S시스템의 SSO 연동을 위해 <span>"Pass-Ni NX Client"</span> 프로그램을 설치합니다.</p>
	            <p>■ 다운로드된 폴더로 이동하여  <span id="filename">"passninx40_setup.exe"</span> 프로그램을 실행하여 설치를 진행합니다.</p>
	            <p>■ <span>Windows의 PC 보호(보안 경고)</span> 화면이 표시되면  <span>"실행"</span>을 클릭합니다. <span>"실행 안함"</span>을 클릭할 경우 정상적인 연동이 불가능합니다.</p>
	            <p>■ 프로그램의 설치가 완료되면 자동으로 이전 화면으로 이동합니다. 이전 화면으로 이동 하지 않을 경우 <span>"이전 화면"</span>버튼을 클릭하십시요.</p>
	            <p>■ 사용자의 컴퓨터 및 네트워크의 상황에 따라 다운로드에  많은 시간이 소요되는 경우 <span>"프로그램 다운로드"</span>버튼을 클릭하여 수동으로 다운로드받아 설치하여 주십시요.</p>
	        </div>
	        <div class="btn">
	            <a href="javascript:download();" class="btn-type-skyblue">프로그램 다운로드</a>
	            
	            <%
	            	if( link_url == null || "popup".equals( link_url )) {
	            %>
	            		<a href="javascript:fnLink();" class="btn-type-gray">닫기</a>
	            <%
	            	} else {
	            %>
	            		<a href="javascript:fnLink();" class="btn-type-gray">이전 화면</a>
	            <%
	            	}
	            %>
	        </div>
	    </section>
	</div>
	
	<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/user/js/client/passninx-client-5.0.js'/>"></script>
	
	<script type="text/javascript">
		var link_url = '<%=link_url%>';
		var installFlag = false;
		
		$(function() {
			
			$('#filename').html('"' + NX_FILE_NAME + '"');
			
			download();
			setTimeout( function() { check(); }, 2000 );
		});
		
		function check() {
			
			if(!installFlag) {
				checkRequest(CLIENT_URL + 'init');
				
				setTimeout( function() { check(); }, 2000 );
			}
		}
		
		function checkRequest(url) {
			
			$.ajax({
				url : url,
				type : 'post',
				dataType : 'json',
				async : true,
				success : function(responseData) {
					checkResponse(responseData);
					console.log(responseData);
				},
				error : function() {
					checkResponse('error');
				}
			});
		}
		
		function checkResponse(res_data) {
			
			if(!installFlag) {
				
				if(res_data != 'error') {

					if(res_data.result != '') {
						installFlag = true;

						if(link_url == 'popup') {
							alert( 'Pass-Ni NX Client 설치가 완료되었습니다.\n\n화면을 닫습니다.' );
							
						} else {
							alert( 'Pass-Ni NX Client 설치가 완료되었습니다.\n\n이전 화면으로 이동합니다.' );
						}
						
						fnLink();
					}
				}
			}
		}
		
		function download() {
			
			var tempForm = $('<form/>', {
				'action' : '<c:url value="/user/login/client/download"/>',
				'method' : 'POST'
			}).append($("<input/>", {
				'type' : 'hidden',
				'name' : 'file_name',
				'value' : NX_FILE_NAME
			})).appendTo('body').submit();
			
			//location.href = NX_FILE_NAME;
			//location.href = "<c:url value='/usr/redcross/login/download'/>";
		}
		
		function fnLink() {
			
			if(link_url == 'popup') {
				self.close();
				
			} else {
				location.href = link_url;
			}
		}
	
	</script>

</body>
</html>