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

        <div class="layui-form-item layui-hide" id="imgDiv">
            <label class="layui-form-label">封面图<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <input type="file" name="file" class="layui-upload-file" lay-title="上传一张图片">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">预览</label>
            <div class="layui-input-block" id="preview">
                <div class="preview" >
                    <img class="imgClass" src=""><br>
                    <button type="button" onclick="deleteImg(this)" imgUrl="{{imgUrl}}" class="layui-btn layui-btn-danger"><i class="layui-icon">&#xe640;</i>删除</button>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">banner类型<span class="font-red">*</span></label>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required" lay-filter="type">
                    <option value="">选择banner类型</option>
                    <option value="0">首页Banner</option>
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
            <label class="layui-form-label">公司 </label>
            <div class="layui-input-block">
                <input type="text" name="companyName" value="{{banner.companyName}}" disabled autocomplete="off" class="layui-input" maxlength="50">
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
        YZ.ajaxRequestData("post", false, YZ.ip + "/companyBanner/queryBannerById", {bannerId : $scope.bannerId} , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                $scope.banner = result.data;
                $("#LAY_demo1").html($scope.banner.context);
                $(".imgClass").attr('src',YZ.ipImg+"/"+result.data.imgUrl);
            }
        });

        layui.use(['form', 'layedit', 'laydate', 'upload', 'layedit'], function() {
            var form = layui.form(),
                    layer = layui.layer,
                    layedit = layui.layedit
                    ,$ = layui.jquery,
                    laydate = layui.laydate;


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


                    $("#imgUrl").val(res.data.url);
                    var html = '<div class="preview">' +
                            '<img src="' + YZ.ipImg + '/' + res.data.url + '"><br>' +
                            "<button type=\"button\" class=\"layui-btn layui-btn-danger\" imgUrl=\"" + res.data.url + "\" onclick=\"deleteImg(this)\"><i class=\"layui-icon\">&#xe640;</i>删除</button></div>";

                    $("#preview").html(html);
                    $("#preview").parent().show();
                    $("#imgDiv").hide('slow');
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
                YZ.ajaxRequestData("post", false, YZ.ip + "/companyBanner/updateCompanyBanner", data.field , null , function(result) {
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
//        var url = $(object).attr("imgUrl");
//        var imgUrls = $("#imgUrl").val().split(",");
//        for (var i = 0; i < imgUrls.length; i++) {
//            if (imgUrls[i] == url) {
//                imgUrls.splice(i, 1);
//                $(object).parent().fadeOut();
//                break;
//            }
//        }
        $("#preview").html("");
        $("#preview").parent().hide();
        $("#imgUrl").val("");
        $("#imgDiv").show('slow');
    }

</script>
</body>
</html>
