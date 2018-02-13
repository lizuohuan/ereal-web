<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>团队结项完成率</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .sum-date{font-size: 20px;font-weight: bold;margin-bottom: 10px;}
        .label-date{font-size: 16px;width: 400px;text-align: left;margin: 0 auto}
        .label-date p{margin-bottom: 10px;}
        .label-date p span{float: right;font-weight: bold;line-height: 25px;}

    </style>
<body>

<div class="admin-main">
    <blockquote class="layui-elem-quote">
        <fieldset class="layui-elem-field">
            <legend>高级筛选</legend>
            <div class="layui-field-box layui-form">
                <form class="layui-form" action="" id="formData">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">选择公司</label>
                            <div class="layui-input-block">
                                <select id="companyId" name="companyId" lay-filter="company" lay-search="">
                                    <option value="">选择或搜索公司</option>
                                    <option value="0" disabled>暂无</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择部门</label>
                            <div class="layui-input-block">
                                <select id="departmentId" name="departmentId" lay-filter="departmentId" lay-search="">
                                    <option value="">选择或搜索部门</option>
                                    <option value="0" disabled>暂无</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">时间类型</label>
                            <div class="layui-input-block">
                                <select id="dateType" name="dateType" lay-filter="dateType">
                                    <option value="0">周</option>
                                    <option value="1">月</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">选择时间</label>
                            <div class="layui-input-block">
                                <input class="layui-input" id="date" placeholder="选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button type="button" class="layui-btn" id="search" onclick="passingParameters()"><i class="layui-icon">&#xe615;</i> 搜索</button>
                            <button type="reset" class="layui-btn layui-btn-primary">清空</button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
    </blockquote>

    <fieldset class="layui-elem-field"></button>
        <legend>团队结项完成率统计表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <div id="water" style="width: 100%;height: 100%;min-height: 500px;"></div>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>

    //默认查询当天
    window.onload = function () {
        var date = new Date();
        $("#date").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
    }

    var waterChart = echarts.init(document.getElementById("water")); // 统计图对象
    var option = {} // 统计图配置

    //参数调用
    function passingParameters() {
        var userId = $("#userId").val();
        var date = $("#date").val();
        var companyId = $("#companyId").val();
        var departmentId = $("#departmentId").val();
        var dateType = $("#dateType").val();
        var type = $("#type").val();
        if (userId == "" && companyId == "" && departmentId == "") {
            userId = YZ.getUserInfo().id;
        }
        if (date != "") {
            date = new Date(date);
        }
        else {
            layer.msg('请选择要查询的时间.', {icon: 2, anim: 6});
            return false;
        }
        if (companyId == "") {
            companyId = 0;
        }
        if (departmentId == "") {
            departmentId = 0;
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        bindData(date, dateType, companyId, departmentId, 4);
        setTimeout(function () {layer.close(index);}, 600);
    }

    //默认查询登录人
    bindData(new Date(), 0, 0, YZ.getUserInfo().departmentId, 4);

    /**
     * 后台统计第三维  文化工程
     * companyId、departmentId、userId 三者传一
     * @param type 0：统计团队文化工程得分   1：团队文化工程完成率  2：个人文化工程得分  3： 团队结项完成率 4：团队结项完成率
     * @param date 日期
     * @param dateType 0：周统计   1：月统计
     * @param companyId 公司ID
     * @param departmentId 部门ID
     * @param userId  用户ID
     * @return
     */
    function bindData (date, dateType, companyId, departmentId, type) {
        var userKs = []; //个人K
        var userNames = []; //员工名字
        var arr = {};
        //查看公司
        if (companyId != 0) {
            arr = {
                companyId : companyId,
                date : date,
                dateType : dateType,
                type
            }
        }
        //查看部门
        if (departmentId != 0) {
            arr = {
                departmentId : departmentId,
                date : date,
                dateType : dateType,
                type
            }
        }
        var max = 0;
        YZ.ajaxRequestData("post", false, YZ.ip + "/statistics/queryKCulture", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                for (var i = 0; i < result.data.length; i++) {
                    var userK = result.data[i].userK;
                    userK = userK == null ? 0 : userK + "";
                    if (userK.indexOf(".") != -1) {
                        var nums = userK.split(".");
                        if (nums[1].length > 9) {
                            nums[1] = nums[1].substring(0, 9);
                        }
                        userKs.push(Number(nums[0] + "." + nums[1]));
                    }
                    else {
                        userKs.push(userK);
                    }
                    userNames.push(result.data[i].name);
                }
                //寻找最大的
                for (var i = 0; i < userKs.length; i++) {
                    if (Number(userKs[i]) > max) {
                        max = userKs[i];
                    }
                }
                max = parseInt(YZ.getForTen(max));
                /*userKs.push(20);
                 userNames.push("张三");
                 userKs.push(50);
                 userNames.push("李四");
                 userKs.push(12);
                 userNames.push("王老五");
                 userKs.push(32);
                 userNames.push("张麻子");
                 userKs.push(28);
                 userNames.push("田菜龙");*/

                waterChart.setOption(setToOption(userKs, userNames, "bar", max));
            }
        });
    }

    //TODO 个人、团队、公司
    function setToOption(userKs, dataName, type, max) {
        console.log(userKs);
        console.log(dataName);
        option = {
            title : {
                text: '团队结项完成率统计表',
                x: 'center',
                y: 'top',
                padding: 5,
            },
            tooltip : {
                trigger: 'axis'
            },
            color: ["#8B95C9"],
            legend: {
                orient: 'horizontal',
                x: 'center',
                y: '30px',
                data:['团队结项完成率']
            },
            toolbox: {
                show : true,
                feature : {
                    dataView : {show: true, readOnly: false},
                    magicType : {show: true, type: ['line', 'bar']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            calculable : true,
            xAxis : [
                {
                    type : 'category',
                    axisTick: {
                        alignWithLabel: true
                    },
                    data : dataName
                }
            ],
            yAxis : [
                {
                    type: "value",
                    splitLine: {
                        show: false // y轴背景线条
                    },
                    "axisLine": {
                        show: true  // 左侧竖线线
                    },
                    axisTick: {
                        show: true  //刻度标识
                    },
                    splitArea: {
                        show: false //y轴背景颜色
                    },
                    axisLabel: {
                        formatter : "{value}k", //添加左侧单位
                    },
                }
            ],
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: 50
            }, {
                start: 0,
                end: 10,
                handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                handleSize: '80%',
                handleStyle: {
                    color: '#FFF',
                    shadowBlur: 3,
                    shadowColor: 'rgba(0, 0, 0, 0.6)',
                    shadowOffsetX: 2,
                    shadowOffsetY: 2
                }
            }],
            series : [
                {
                    name:'团队结项完成率',
                    type: type,
                    data: userKs,
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                },
            ]
        };

        return option;
    }



    layui.use(['layer', 'form', 'layedit', 'laydate', 'element'], function() {
        var form = layui.form(),
                layer = layui.layer,
                laydate = layui.laydate;

        getCompanyListType(null, 0);

        //公司过滤器
        form.on('select(company)', function(data){
            console.log(data);
            getDepartmentListType(Number(data.value), null, null, 0);
            $("select[name='userId']").html("<option value=\"\">选择或搜索</option><option value=\"0\" disabled>暂无</option>");
            form.render();
        });

        form.render(); //重新渲染

    });

</script>
</body>
</html>
