<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>选择抄送人</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mui/css/mui.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mui/css/mui.indexedlist.css">
    <style>
        .userHead{border-radius: 50%;width: 40px;height: 40px;}
        .mui-table-view-cell.mui-checkbox input[type=checkbox], .mui-table-view-cell.mui-radio input[type=radio]{top: 16px;}
        .hint{color: #5FB878;font-size: 12px;}
    </style>
</head>
<body ng-app="webApp">
<header class="mui-bar mui-bar-nav">
    <h1 class="mui-title">选择抄送人</h1>
    <a id='done' class="mui-btn mui-btn-link mui-pull-right mui-btn-blue">完成</a>
</header>
<div class="mui-content"  ng-controller="selectUserCtr" ng-cloak>
    <div id='list' class="mui-indexed-list" style="height: 510px !important;">
        <div class="mui-indexed-list-search mui-input-row mui-search">
            <input type="text" class="mui-input-clear mui-indexed-list-search-input" placeholder="搜索抄送人或公司或部门" style="border: none">
        </div>
        <div class="mui-indexed-list-bar" style="display: none;">
            <a>A</a>
            <a>B</a>
            <a>C</a>
            <a>D</a>
            <a>E</a>
            <a>F</a>
            <a>G</a>
            <a>H</a>
            <a>I</a>
            <a>J</a>
            <a>K</a>
            <a>L</a>
            <a>M</a>
            <a>N</a>
            <a>O</a>
            <a>P</a>
            <a>Q</a>
            <a>R</a>
            <a>S</a>
            <a>T</a>
            <a>U</a>
            <a>V</a>
            <a>W</a>
            <a>X</a>
            <a>Y</a>
            <a>Z</a>
        </div>
        <div class="mui-indexed-list-alert"></div>
        <div class="mui-indexed-list-inner">
            <div class="mui-indexed-list-empty-alert">没有找到抄送人</div>
            <ul class="mui-table-view">
                <li ng-show="userList.length == 0"><div class="mui-indexed-list-empty-alert" style="display: block;">没有找到相关人员</div></li>
                <li ng-repeat="user in userList" class="mui-table-view-cell mui-indexed-list-item mui-checkbox mui-left">
                    <input type="checkbox" value="{{user.id}}"/>
                    <img ng-if="user.avatar == null" class="userHead" src="<%=request.getContextPath()%>/resources/img/0.jpg">
                    <img ng-if="user.avatar != null" class="userHead" src="<%=imgPath%>/{{user.avatar}}">
                    {{user.name}}
                    <span class="hint">(
                        <span ng-if="user.companyName != null && user.companyName != ''">{{user.companyName}}</span>
                        --{{user.departmentName}})
                    </span>
                </li>
            </ul>
        </div>
    </div>
</div>

<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/mui.indexedlist.js"></script>

<script>

    var workDiaryId = YZ.getUrlParam("workDiaryId");
    var workDiaryIdStatus = YZ.getUrlParam("workDiaryIdStatus");

    var webApp=angular.module('webApp',[]);
    webApp.controller("selectUserCtr", function($scope,$http,$timeout){
        $scope.userList = null;
        YZ.ajaxRequestData("get", false, YZ.ip + "/user/queryUserByCompany", {companyId:YZ.getUserInfo().companyId}, null , function(result){
            if(result.flag == 0 && result.code == 200){
                $scope.userList = result.data;
                for (var i = 0; i < $scope.userList.length; i++) {
                    if ($scope.userList[i].id == YZ.getUserInfo().id) {
                        $scope.userList.splice(i,1); // 排除自己
                    }
                }
            }
        });
    });

    mui.init();
    mui.ready(function() {
        var header = document.querySelector('header.mui-bar');
        var list = document.getElementById('list');
        var $done = $("#done");
        //calc hieght
        list.style.height = (document.body.offsetHeight - header.offsetHeight) + 'px';
        //create
        window.indexedList = new mui.IndexedList(list);
        //done event
        $done.on("click", function () {
            var checkboxArray = [].slice.call(list.querySelectorAll('input[type="checkbox"]'));
            var checkedValues = [];
            var checkIds = []; // 存放已选userID
            checkboxArray.forEach(function(box) {
                if (box.checked) {
                    checkedValues.push(box.parentNode.innerText);
                    checkIds.push(box.value);
                }
            });
            //提交
            var html = '<form class="layui-form layui-form-pane" action="">' +
                    '<div class="layui-form-item layui-form-text">' +
                    '<label class="layui-form-label">备注</label>' +
                    '<div class="layui-input-block">' +
                    '<textarea type="text" id="notes" autocomplete="off" placeholder="请输入备注" class="layui-input" maxlength="60"></textarea>' +
                    '</div>' +
                    '</div>' +
                    '</form>';
            YZ.formPopup(html, "请填写备注信息", ["500px", "300px"], function () {
                var arr = {
                    id : workDiaryId,
                    status : workDiaryIdStatus,
                    notes : $("#notes").val(),
                    userIds : checkIds.toString()
                }
                YZ.ajaxRequestData("get", false, YZ.ip + "/workDiary/updateWorkDiaryStatus", arr, null , function(result){
                    if(result.flag == 0 && result.code == 200){
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    }
                });
            }, function () {});
            /*if (checkIds.length > 0) {
             //mui.alert('你选择了userId: ' + checkIds);



             } else {
             mui.alert('你没选择任何抄送人');
             }*/
        });
        /*done.addEventListener('tap', function() {

        }, false);*/
        /*mui('.mui-indexed-list-inner').on('change', 'input', function() {
            var count = list.querySelectorAll('input[type="checkbox"]:checked').length;
            var value = count ? "完成(" + count + ")" : "完成";
            done.innerHTML = value;
            if (count) {
                if (done.classList.contains("mui-disabled")) {
                    done.classList.remove("mui-disabled");
                }
            } else {
                if (!done.classList.contains("mui-disabled")) {
                    done.classList.add("mui-disabled");
                }
            }
        });*/
    });


</script>
</body>
</html>
