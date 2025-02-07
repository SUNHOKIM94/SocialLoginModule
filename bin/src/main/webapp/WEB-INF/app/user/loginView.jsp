<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>통합로그인</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta name="format-detection" content="telephone=no, address=no, email=no"/>
    <meta name="title" content="통합로그인">
    <meta name="keywords" content="통합로그인">
    <link href="<c:url value='/resources/user/images/logo/favicon.ico'/>" rel="icon"/>
    <link rel="stylesheet" href="<c:url value='/resources/nfec/css/common.css'/>" type="text/css"/>
    <link rel="stylesheet" href="<c:url value='/resources/nfec/css/content.css'/>" type="text/css"/>
</head>
<body>
<div id="wrap" class="login">
    <div id="container">
        <div class="w50_box">
            <div style="text-align: center;">
                <br><br>
                <img src="<c:url value='/resources/nfec/images/logo_zeus.png'/>" alt="" height="36.41" width="138">
                <br><br><br><br>
            </div>
            <div class="w50">
                <form id="loginForm" name="loginForm" method="post" autocomplete="off" class="form_login">
                    <fieldset>
                        <legend>로그인 폼</legend>
                        <div class="tit_box">
                            <h2 class="tit">회원 로그인</h2>
                        </div>
                        <div class="login_inp">
                            <label class="login_window" style="display:block">
                                <span class="blind">아이디</span>
                                <input type="text" class="inp" id="login_id" name="login_id" placeholder="아이디"
                                       autofocus/>
                            </label>
                            <label class="login_window" style="display:block">
                                <span class="blind">비밀번호</span>
                                <input type="password" class="inp" id="login_pwd" name="login_pwd" placeholder="비밀번호"
                                       autocomplete="off"/>
                            </label>
                            <p id="password_fail" class="f_red"
                               style="margin-top:10px; margin-bottom:20px;"></p>
                        </div>
                        <div class="save_box">
                            <label><input type="checkbox" id="idSaveCheck"> 아이디 저장</label>
                        </div>
                        <button type="button" onclick="loginProc()" class="btn_login" style="display:block">로그인</button>
                    </fieldset>
                </form>
                <div class="find_info">
                    <a href="https://zeus.go.kr/user/provision" class="btn_find">회원가입</a>
                    &nbsp;/&nbsp;<a href="https://zeus.go.kr/user/findUserId" class="btn_find">아이디 찾기</a>
                    &nbsp;/&nbsp;<a href="https://zeus.go.kr/user/findPassword" class="btn_find">비밀번호 찾기</a>
                </div>
            </div>
            <div class="w50">

                <div class="sns_login">
                    <a href="javascript:;" onclick="loginNaver();"><img
                            src="<c:url value='/resources/nfec/images/social/naver.png'/>" alt="" width="50"
                            height="50"></a>
                    <a href="javascript:;" onclick="loginKakao();"><img
                            src="<c:url value='/resources/nfec/images/social/kakao.png'/>" alt="" width="50"
                            height="50"></a>
                    <a href="javascript:;" onclick="loginGoogle();"><img
                            src="<c:url value='/resources/nfec/images/social/google.png'/>" alt="" width="50"
                            height="50"></a>
                </div>
            </div>
        </div>
    </div>
</div>
<footer id="footer">
    Copyright &copy; 2016 National Research Facilities &amp; Equipment Center. All rights reserved.
</footer>

<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/crypto/seed.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/crypto/pad-ansix923-min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/util/common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/login/login.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/client/passninx-client-5.0.js'/>"></script>

<script type="text/javascript">

    addEventListener('pageshow', (event) => {

        keyModule.init('<c:url value="/user/login/init"/>');


        var loginId = getCookie("login_id");
        if (loginId) {
            $('#login_id').val(loginId);
            $('#idSaveCheck').prop("checked", true);
        }

    });

    $(function () {

        $('input').keypress(function (e) {
            if (e.keyCode == 13) {
                loginProc();
            }
        });

        $('#login_id').focus();

        var error_code = '${error_code}';

        if (error_code == 'SOCIAL_LOGIN_REGIST') {
            var answer = confirm("등록 된 회원이 없습니다.\n2024.12.20(금) 부로 카카오톡 연동 방식이 변경되었습니다.\n아이디 / 패스워드 로그인 후 개인정보수정 페이지에서\n간편 계정 로그인 연결을 다시 해주시기 바랍니다.\n 회원가입 페이지로 이동하시겠습니까?");
            if (answer == true) {
                location.href = 'https://zeus.go.kr/user/provision';
            }

        } else if (error_code != '') {
            alert('error_code : ' + error_code);
        }


        if ('${client_use_yn}' == 'Y' && !isMobile()) {
            clientModule.init('${server_url}', '${client_secret}');

            // 자동 로그인(NX 클라이언트에서 인증토큰 획득)
            /* var nxc_auth_tk = clientModule.get_token();

            if(nxc_auth_tk != '') {
                var tempForm = $('<form/>', {
                    'action' : '
            <c:url value="/user/login/tokenproc"/>',
						'method' : 'POST'
					}).append($("<input/>", {
						'type' : 'hidden',
						'name' : 'nxc_auth_tk',
						'value' : nxc_auth_tk
					})).appendTo('body');

					tempForm.submit().remove();
				} */
        }
    });

    function loginProc() {

        var response_data = loginModule.auth('<c:url value="/nfec/user/login/auth"/>');

        if (response_data != null) {
            var code = response_data.code;
            var data = response_data.data;
            var message = loginModule.message(response_data);

            if (code == 'SS0001' || code == 'SS0004') {
                $('form[name=loginForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();

            } else if (code == 'SS0005') {
                alert('초기화 된 패스워드 입니다. \n마이페이지에서 패스워드를 변경해주시기 바랍니다.');
                $('form[name=loginForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();

            } else if (code == 'SS0006') {
                alert('오래된 비밀번호를 사용하고 있습니다. \n마이페이지에서 패스워드를 변경해주시기 바랍니다.');
                $('form[name=loginForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();

            } else if (code == 'SS0007') {
                if (data == 'dupAdminBefore') {
                    alert(message);
                    $('#login_id').focus();

                } else {
                    if (confirm(message)) {
                        $('form[name=loginForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();
                    } else {
                        $('#login_id').focus();
                    }
                }

            } else if (code == 'EAU016' || code == 'EAU017' || code == 'EAU018') {
                alert(message);
                location.href = '<c:url value="/user/login/view"/>';

            } else {
                alert(message);
                $('#login_id').focus();
            }
        }
    }

    function fn2ndAuth() {
        var tempForm = $('<form/>', {
            'action': '<c:url value="/twofactor/view"/>',
            'method': 'POST'
        }).append($('<input/>', {
            'type': 'hidden',
            'name': 'user_gubun',
            'value': 'user'
        })).appendTo('body').submit().remove();
    }

    function loginNaver() {
        location.href = "<c:url value='/naver/view'/>";
    }

    function loginGoogle() {
        location.href = "<c:url value='/google/view'/>";
    }

    function loginKakao() {
        location.href = "<c:url value='/kakao/view'/>";
    }

    // 로그인 아이디 저장 관련
    var loginId = getCookie("login_id");  // 쿠키에서 combinedId 값을 가져옴
    if (loginId) {
        $('#login_id').val(loginId);  // 로그인 아이디 설정
    }

    // 쿠키에 값이 있으면 체크박스를 체크 상태로 유지
    if ($('#login_id').val() != "") {
        $('#login_id_saved').attr("checked", true);
    }

    // 아이디 저장 체크박스에 변화가 있을 경우
    $('#idSaveCheck').change(function () {
        var loginId = $('#login_id').val();    // 입력된 로그인 아이디
        if ($('#idSaveCheck').is(":checked")) {
            setCookie("login_id", loginId, 7);  // 7일간 쿠키에 combinedId 저장
        } else {
            deleteCookie("login_id");  // 체크 해제 시 쿠키 삭제
        }
    });

    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("#login_id").keyup(function () { // ID 입력 칸에 ID를 입력할 때
        var loginId = $('#login_id').val();    // 입력된 로그인 아이디

        if ($("#idSaveCheck").is(":checked")) {  // ID 저장 체크박스가 체크된 상태라면
            setCookie("login_id", loginId, 7);   // 7일 동안 쿠키 보관
        }
    });

    //로그인 아이디 저장 관련 끝

    // 쿠키 저장하기
    // setCookie => saveid함수에서 넘겨준 시간이 현재시간과 비교해서 쿠키를 생성하고 지워주는 역할
    function setCookie(cookieName, value, exdays) {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + exdays);
        var cookieValue = escape(value)
            + ((exdays == null) ? "" : "; expires=" + exdate.toGMTString());
        document.cookie = cookieName + "=" + cookieValue;
    }

    // 쿠키 삭제
    function deleteCookie(cookieName) {
        var expireDate = new Date();
        expireDate.setDate(expireDate.getDate() - 1);
        document.cookie = cookieName + "= " + "; expires="
            + expireDate.toGMTString();
    }

    // 쿠키 가져오기
    function getCookie(cookieName) {
        cookieName = cookieName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cookieName);
        var cookieValue = '';
        if (start != -1) { // 쿠키가 존재하면
            start += cookieName.length;
            var end = cookieData.indexOf(';', start);
            if (end == -1) // 쿠키 값의 마지막 위치 인덱스 번호 설정
                end = cookieData.length;
            //console.log("end위치  : " + end);
            cookieValue = cookieData.substring(start, end);
        }
        return unescape(cookieValue);
    }

</script>

</body>
</html>