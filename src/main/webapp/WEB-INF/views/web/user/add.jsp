<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>添加用户</title>
    <!--引入抽取css文件-->
    <%@include file="../common/public-css.jsp" %>
    <style>
        .roleInfo{width: 100%;min-height:5px;}
        .roleInfo button{margin: 0 10px 10px 0}
    </style>
</head>
<body>
    <div style="margin: 15px;">
        <blockquote class="layui-elem-quote"><i class="fa fa-refresh" aria-hidden="true"></i>&nbsp;表单带有 <span class="font-red">“*”</span> 号的为必填项.</blockquote>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
            <legend>添加用户</legend>
        </fieldset>
        <form class="layui-form" action="" id="formData">

            <div class="layui-form-item">
                <label class="layui-form-label">用户类型<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="userType" lay-verify="required" lay-filter="userType">
                        <option value="">选择用户类型</option>
                        <option value="0">总公司用户</option>
                        <option value="1">分公司用户</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">分配角色<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="roleId" lay-verify="required" lay-search="">
                        <option value="">选择或搜索角色</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">选择后台多角色</label>
                <div class="layui-input-inline" style="width: 500px;">
                    <div class="roleInfo" id="roleInfo"></div>
                    <button type="button" class="layui-btn layui-btn-small layui-btn-normal" onclick="selectRole()">点击选择角色</button>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">选择公司<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="companyId" lay-verify="required" lay-search="" lay-filter="company">
                        <option value="">选择或搜索公司</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <label class="layui-form-label">选择部门<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="departmentId" lay-verify="required" lay-search="">
                        <option value="">选择或搜索部门</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">账号<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="account" lay-verify="required|isNumberChar" placeholder="请输入账号" autocomplete="off" class="layui-input" maxlength="16">
                </div>
                <div class="layui-form-mid layui-word-aux">账号推荐格式:yz+姓名拼音+00001</div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">姓名<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="name" lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input" maxlength="20">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">邮箱<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="email" lay-verify="required|isEmail" autocomplete="off" class="layui-input" placeholder="请输入邮箱" maxlength="50">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">生日<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="birthday" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" onclick="layui.laydate({elem: this})" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">电话号码<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="tel" name="phone" lay-verify="required|phone" autocomplete="off" class="layui-input" placeholder="请输入电话号码" maxlength="11">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">身份属性<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <select name="incumbency" lay-verify="required">
                        <option value="">选择或搜索身份属性</option>
                        <option value="0">实习</option>
                        <option value="1">磨合期</option>
                        <option value="2">正式</option>
                        <option value="3">离职</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">入职时间<span class="font-red">*</span></label>
                <div class="layui-input-inline">
                    <input type="text" name="entryTime" id="entryTime" lay-verify="required" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">转正时间</label>
                <div class="layui-input-inline">
                    <input type="text" name="positiveTime" id="positiveTime" lay-verify="" placeholder="yyyy-mm-dd" autocomplete="off" class="layui-input" readonly>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">薪酬<span class="font-red">*</span></label>
                    <div class="layui-input-inline" style="width: 100px;">
                        <input type="text" name="salary" placeholder="￥" lay-verify="required|isDouble|isZero" onkeyup="YZ.clearNoNum(this)" onblur="YZ.clearNoNum(this)" autocomplete="off" class="layui-input" maxlength="10">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block">
                    <input type="radio" name="sex" value="0" title="男" checked="">
                    <input type="radio" name="sex" value="1" title="女">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">合作状态</label>
                <div class="layui-input-block">
                    <input type="radio" name="infoStatus" value="0" title="合作" checked="">
                    <input type="radio" name="infoStatus" value="1" title="股东">
                </div>
            </div>

            <input type="hidden" name="password">
            <input id="roleIds" name="roleIds" type="hidden">

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
    <script src="<%=request.getContextPath()%>/resources/js/common/jQuery.md5.js"></script>
    <script>
        var form = null;
        layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
            form = layui.form(),
                    layer = layui.layer,
                    laydate = layui.laydate;

            var roleList = [];
            YZ.ajaxRequestData("get", false, YZ.ip + "/role/list", {type : null}, null , function(result){
                if(result.flag == 0 && result.code == 200){
                    for (var i = 0; i < result.data.length; i++) {
                       var json = {
                           id : result.data[i].id,
                           text : result.data[i].roleName

                       }
                        roleList.push(json);
                    }
                }
            });

            var start = {
                //min: laydate.now(),
                max: '2099-06-16 23:59:59'
                ,istoday: false
                ,choose: function(datas){
                    end.min = datas; //开始日选好后，重置结束日的最小日期
                    end.start = datas //将结束日的初始值设定为开始日
                }
            };

            var end = {
                //min: laydate.now(),
                max: '2099-06-16 23:59:59'
                ,istoday: false
                ,choose: function(datas){
                    start.max = datas; //结束日选好后，重置开始日的最大日期
                }
            };

            document.getElementById('entryTime').onclick = function(){
                start.elem = this;
                laydate(start);
            }
            document.getElementById('positiveTime').onclick = function(){
                end.elem = this
                laydate(end);
            }

            //自定义验证规则
            form.verify({
                isEmail: function(value) {
                    if(value.length > 0 && !YZ.isEmail.test(value)) {
                        return "邮箱格式错误";
                    }
                },
                isDouble: function(value) {
                    if(value.length > 0 && !YZ.isDouble.test(value)) {
                        return "请输入一个整数或小数";
                    }
                },
                isZero : function (value) {
                    if(value < 0) {
                        return "不能小于0";
                    }
                },
                isNumberChar : function (value) {
                    console.log(value);
                    if(!YZ.isNumberChar.test(value)) {
                        return "账号格式不对，(3-16位数字和字母组合)";
                    }
                },
            });

            //监听select事件--用户类型过滤器
            form.on('select(userType)', function(data){
                $("#roleInfo").parent().parent().show();
                console.log(data);
                if (Number(data.value) == 0) {
                    getCompanyListType(0, 0);
                    /*$("select[name='companyId']").parent().parent().hide();*/
                    //$("select[name='departmentId']").parent().parent().hide();
                    getDepartmentList(null, 0, 0);
                    $("select[name='companyId']").removeAttr("lay-verify");
                }
                else {
                    getCompanyListType(1, 0);
                    $("select[name='companyId']").attr("lay-verify", "required");
                }
                getRoleListType(Number(data.value), 0);
                form.render('select');
            });
            //公司过滤器
            form.on('select(company)', function(data){
                console.log(data);
                getDepartmentListType(Number(data.value), 1, null, null, 0);
                form.render('select');
            });

            //监听提交
            form.on('submit(demo1)', function(data) {
                data.field.password = $.md5("111111");
                data.field.roleId = Number(data.field.roleId);
                data.field.account = data.field.account.replace(/\ +/g,"");
                data.field.companyId = Number(data.field.companyId);
                data.field.departmentId = Number(data.field.departmentId);
                data.field.birthday = new Date(data.field.birthday);
                data.field.entryTime = new Date(data.field.entryTime);
                if (data.field.positiveTime == "") {
                    delete data.field["positiveTime"];
                }
                else {
                    data.field.positiveTime = new Date(data.field.positiveTime);
                }
                data.field.salary = Number(data.field.salary).toFixed(2);
                console.log(data.field);
                YZ.ajaxRequestData("post", false, YZ.ip + "/user/insert", data.field , null , function(result) {
                    layer.alert('添加用户成功.', {
                        skin: 'layui-layer-molv' //样式类名
                        ,closeBtn: 0
                        ,anim: 3 //动画类型
                    }, function(){
                        //关闭iframe页面
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                        window.parent.closeNodeIframe();
                    });
                });
                return false;
            });
        });

        //选择角色列表--多选
        function selectRole () {
            var type = $("select[name='userType']").val();
            var roleId = $("select[name='roleId']").val();
            layer.open({
                type: 2,
                title: '选择角色',
                shadeClose: true,
                maxmin: true, //开启最大化最小化按钮
                area: ['400px', '500px'],
                scrollbar: false, //屏蔽浏览器滚动条
                content: YZ.ip + "/page/user/selectRole?type=" + type +  "&roleId=" + roleId
            });
        }

        /**
         * 提供给子页面调用获取选择的组员集合信息
         */
        function getIsIframe(roleJson, checkIds) {
            $("#roleIds").val(checkIds); //设置已选组员
            console.log(checkIds);
            var roleList = JSON.parse(roleJson);
            var html = "";
            for (var i = 0; i < roleList.length; i++) {
                html += '<button type="button" class="layui-btn layui-btn-small layui-btn-radius" onclick="deleteRole(' + roleList[i].id + ', this)">' + roleList[i].roleName + '&nbsp;&nbsp;<i class="layui-icon">&#xe640;</i></button>';
            }
            $("#roleInfo").html(html);
            form.render();//重新渲染form
        }

        //删除一个角色
        function deleteRole(id, obj) {
            var index = layer.confirm("是否确认删除？", {
                btn: ['确定','取消'], //按钮
                title : "确认提示",
            }, function(){
                //删除userID
                var roleIds = $("#roleIds").val();
                roleIds = roleIds.split(",");
                for (var i = 0; i < roleIds.length; i++) {
                    if (roleIds[i] == id) {
                        roleIds.splice(i, 1);
                        break;
                    }
                }
                $("#roleIds").val(roleIds);
                layer.close(index);
                $(obj).fadeOut();
            }, function(){});
        }

    </script>
</body>
</html>
