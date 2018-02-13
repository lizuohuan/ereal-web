<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加banner</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .preview{height: 250px;width: 400px;margin-right: 10px;margin-bottom: 10px;float: left;text-align: center}
        .preview img{width: 100%;height:210px;border: 1px solid #eee;}

    </style>
</head>
<body ng-app="webApp">
<div style="margin: 15px;">
    <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>添加banner</legend>
    </fieldset>
    <form class="layui-form" action="" id="formData" ng-controller="editBannerCtr" ng-cloak>

        <div class="layui-form-item">
            <label class="layui-form-label">封面图<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="file" name="file" class="layui-upload-file" lay-title="上传一张图片">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">预览</label>
            <div class="layui-input-block" id="preview">
                <div class="preview" ng-repeat="imgUrl in imgUrls">
                    <img src="<%=imgPath%>/{{imgUrl}}"><br>
                    <button type="button" onclick="deleteImg(this)" imgUrl="{{imgUrl}}" class="layui-btn layui-btn-danger"><i class="layui-icon">&#xe640;</i>删除</button>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">banner类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required" lay-filter="type">
                    <option value="">选择banner类型</option>
                    <option value="1">普通</option>
                    <option value="2">审核</option>
                    <option value="3">生日消息</option>
                    <option value="4">统计页Banner</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">标题 <span class="font-red">*</span></label>
            <div class="layui-input-block">
                <input type="text" name="title" value="{{banner.title}}" lay-verify="required" placeholder="请输入标题" autocomplete="off" class="layui-input" maxlength="50">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">内容<span class="font-red">*</span></label>
            <div class="layui-input-block">
                <textarea name="context" class="layui-textarea" id="LAY_demo1" style="display: none"></textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">备注</label>
            <div class="layui-input-block">
                <textarea name="remarks" placeholder="请输入备注" autocomplete="off" class="layui-textarea" maxlength="200">{{banner.remarks}}</textarea>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">排序</label>
            <div class="layui-input-inline">
                <input type="number" value="{{banner.order}}" step="1" name="order" placeholder="请输入一个序号" autocomplete="off" class="layui-input" maxlength="2">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">是否显示</label>
            <div class="layui-input-block">
                <input type="checkbox" name="isShow" lay-skin="switch" title="开关" lay-text="是|否" checked>
            </div>
        </div>


        <input type="hidden" name="imgUrl" id="imgUrl" value="{{banner.imgUrl}}">

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>
<!--引入抽取公共js-->
<%@include file="../common/public-js.jsp" %>
<script>

    var webApp=angular.module('webApp',[]);
    webApp.controller("editBannerCtr", function($scope,$http,$timeout){
        $scope.banner = null; //banner信息
        $scope.bannerId = YZ.getUrlParam("bannerId");
        $scope.imgUrls = []; //存放图片集合
        YZ.ajaxRequestData("post", false, YZ.ip + "/banner/info", {id : $scope.bannerId} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.banner = result.data;
                $scope.imgUrls = $scope.banner.imgUrl.split(",");
                $("#LAY_demo1").html($scope.banner.context);
            }
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    ,$ = layui.jquery,
                    laydate = layui.laydate;

            if ($scope.banner.isShow == 0) {
                $("input[name='isShow']").removeAttr("checked");
            }

            $("select[name='type'] option").each(function () {
                if ($(this).val() == $scope.banner.type) {
                    $(this).attr("selected", true);
                }
                form.render();
            });

            //上传图片
            layui.upload({
                url: YZ.ipImg + "/res/upload" //上传接口
                ,success: function(res){ //上传成功后的回调
                    console.log(res);
                    console.log(res.data.url);
                    /*var imgUrl = $("#imgUrl").val();
                    if (imgUrl.indexOf(",") > 0) {
                        imgUrl += res.data.url + ",";
                        imgUrl = imgUrl.substring(0, imgUrl.length - 1);
                    }
                    else {
                        imgUrl = imgUrl + "," + res.data.url;
                    }
                    $("#imgUrl").val(imgUrl);*/
                    var urls = $("#imgUrl").val().split(",");
                    if (urls[0] == "") {
                        urls = [];
                    }
                    urls.push(res.data.url);
                    $("#imgUrl").val(urls.toString());
                    var html = '<div class="preview">' +
                            '<img src="' + YZ.ipImg + '/' + res.data.url + '"><br>' +
                            "<button type=\"button\" class=\"layui-btn layui-btn-danger\" imgUrl=\"" + res.data.url + "\" onclick=\"deleteImg(this)\"><i class=\"layui-icon\">&#xe640;</i>删除</button></div>";

                    $("#preview").append(html);
                    $("#preview").parent().show();
                    form.render();
                }
            });

            //添加富文本编辑器的上传图片接口
            layedit.set({
                uploadImage: {
                    url: YZ.ipImg + "/res/upload", //上传接口
                    type: 'post', //默认post
                }
            });

            //自定义验证规则
            form.verify({
                isNumber: function(value) {
                    if(value.length > 0 && !YZ.isNumber.test(value)) {
                        return "请输入一个整数";
                    }
                },
            });

            //构建一个默认的编辑器
            var index = layedit.build('LAY_demo1');

            form.render();

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.context = layedit.getContent(index);
                data.field.isShow = data.field.isShow == "on" ? 1 : 0;
                data.field.id = $scope.bannerId;
                if (data.field.imgUrl == "") {
                    layer.msg('请上传封面图片.', {icon: 2,anim: 6});
                    return false;
                }
                if (data.field.context == "") {
                    layer.msg('请输入内容.', {icon: 2,anim: 6});
                    return false;
                }
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/banner/update", data.field , null , function(result) {
                    if (result.flag == 0 && result.code == 200) {
                        layer.alert('修改成功.', {
                            skin: 'layui-layer-molv' //样式类名
                            ,closeBtn: 0
                            ,anim: 4 //动画类型
                        }, function(){
                            //关闭iframe页面
                            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                            parent.layer.close(index);
                            window.parent.closeNodeIframe();
                        });
                    }
                });
                return false;
            });
        });
    });

    //删除图片
    function deleteImg (object) {
        var url = $(object).attr("imgUrl");
        var imgUrls = $("#imgUrl").val().split(",");
        for (var i = 0; i < imgUrls.length; i++) {
            if (imgUrls[i] == url) {
                imgUrls.splice(i, 1);
                $(object).parent().fadeOut();
                break;
            }
        }
        if (imgUrls.length == 0) $("#preview").parent().hide();
        console.log(imgUrls);
        $("#imgUrl").val(imgUrls.toString());
    }

</script>
</body>
</html>
