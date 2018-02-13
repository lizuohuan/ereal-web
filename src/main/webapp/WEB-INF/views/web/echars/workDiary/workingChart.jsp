<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>工时统计</title>
    <!--引入抽取css文件-->
    <%@include file="../../common/public-css.jsp" %>
    <style>
        .sum-time{font-size: 20px;font-weight: bold;margin-bottom: 10px;}
        .label-time{font-size: 16px;width: 400px;text-align: left;margin: 0 auto}
        .label-time p{margin-bottom: 10px;}
        .label-time p span{float: right;font-weight: bold;line-height: 25px;}

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
                            <label class="layui-form-label">选择员工</label>
                            <div class="layui-input-block">
                                <select id="userId" name="userId" lay-search="">
                                    <option value="">选择或搜索员工</option>
                                    <option value="0" disabled>暂无</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">时间类型</label>
                            <div class="layui-input-block">
                                <select id="type" name="type" lay-filter="type">
                                    <option value="0">日</option>
                                    <option value="1">月</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">选择时间</label>
                            <div class="layui-input-block">
                                <input class="layui-input" id="time" placeholder="选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" readonly>
                                <input class="layui-input hide" id="time2" placeholder="选择时间" onfocus="WdatePicker({dateFmt:'yyyy-MM'})" readonly>
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
        <legend>工时统计&nbsp;</legend>
        <div class="layui-field-box layui-form text-center" id="totalsHtml">
            <h3 class="sum-time">本日工作学习总时间：<span id="totals">--</span></h3>
            <div class="label-time">
                <p>学习工时：<span id="studys">--</span></p>
                <p>工作工时：<span id="works">--</span></p>
                <p>运动工时：<span id="sports">--</span></p>
            </div>
        </div>
    </fieldset>

    <fieldset class="layui-elem-field"></button>
        <legend>工时统计表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <div id="water" style="width: 100%;height: 100%;min-height: 500px;"></div>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>

    window.onload = function () {
        var date = new Date();
        $("#time").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
    }

    var waterChart = echarts.init(document.getElementById("water")); // 统计图对象
    var option = {} // 统计图配置

    //参数调用
    function passingParameters() {
        var userId = $("#userId").val();
        var time = $("#time").val();
        var companyId = $("#companyId").val();
        var departmentId = $("#departmentId").val();
        var flag = $("#type").val();
        if (userId == "") {
            userId = 0;
        }
        if (time != "") {
            time = YZ.getTimeStamp(time);
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
        bindData(userId, time, flag, companyId, departmentId);
        setTimeout(function () {layer.close(index);}, 600);
    }

    //默认查询登录人
    bindData(YZ.getUserInfo().id, new Date().getTime(), 0, 0, 0);

    /**
     * 统计日志 工作时长等
     *  userId、companyId、departmentId 不能同时存在 只能单选
     * @param userId 用户ID
     * @param companyId 分公司ID
     * @param departmentId 部门ID
     * @param time 时间 年月日 / 年月 当 flag:0 时，统计年月日 flag:1 统计 年月 不能为空
     * @param flag 当 flag:0 时，统计年月日 flag:1 统计 年月
     * @return
     */
    function bindData (userId, time, flag, companyId, departmentId) {
        var dateStr = new Array(); //时间数组
        var studys = new Array(); //学习工时
        var works = new Array(); //工作工时
        var sports = new Array(); //运动工时
        var totals = new Array(); //总工时
        var userNames = new Array(); //员工名字
        var arr = {};
        //查看公司
        if (companyId != 0 && userId == 0 && departmentId == 0) {
            arr = {
                companyId : companyId,
                time : time,
                flag : flag
            }
        }
        //查看部门
        else if (departmentId != 0 && userId == 0) {
            arr = {
                departmentId : departmentId,
                time : time,
                flag : flag
            }
        }
        //个人参数
        else if (userId != 0) {
            arr = {
                userId : userId,
                time : time,
                flag : flag,
            }
        }
        YZ.ajaxRequestData("post", false, YZ.ip + "/workDiary/countWorkDiary", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                dateStr = result.data.dateStr;
                studys = result.data.studys;
                works = result.data.works;
                sports = result.data.sports;
                totals = result.data.totals;
                userNames = result.data.userNames;
                var sum = 0;
                var studyTime = 0;
                var workTime = 0;
                var sportTime = 0;
                for (var i = 0; i < result.data.entities.length; i++) {
                    if (result.data.entities[i].typeId == 1) {
                        studyTime = result.data.entities[i].time;
                        sum += result.data.entities[i].time;
                    }
                    if (result.data.entities[i].typeId == 2) {
                        workTime = result.data.entities[i].time;
                        sum += result.data.entities[i].time;
                    }
                    if (result.data.entities[i].typeId == 3) {
                        sportTime = result.data.entities[i].time;
                    }
                }
                var isType = flag == 0 ? "日" : "月";
                var html  = "";
                if (companyId != 0 && userId == 0 && departmentId == 0) {
                    html = '<h3 class="sum-time">本' + isType + '工作学习平均总时间：<span>' + sum + 'h</span></h3>' +
                            '<div class="label-time">' +
                            '<p>学习平均工时：<span>' + studyTime + 'h</span></p>' +
                            '<p>工作平均工时：<span>' + workTime + 'h</span></p>' +
                            '<p>运动平均工时：<span>' + sportTime + 'h</span></p>' +
                            '</div>';
                }
                else if (departmentId != 0 && userId == 0) {
                    html = '<h3 class="sum-time">本' + isType + '工作学习平均总时间：<span>' + sum + 'h</span></h3>' +
                            '<div class="label-time">' +
                            '<p>学习平均工时：<span>' + studyTime + 'h</span></p>' +
                            '<p>工作平均工时：<span>' + workTime + 'h</span></p>' +
                            '<p>运动平均工时：<span>' + sportTime + 'h</span></p>' +
                            '</div>';
                }
                else if (userId != 0) {
                    html = '<h3 class="sum-time">本' + isType + '工作学习总时间：<span>' + sum + 'h</span></h3>' +
                            '<div class="label-time">' +
                            '<p>学习工时：<span>' + studyTime + 'h</span></p>' +
                            '<p>工作工时：<span>' + workTime + 'h</span></p>' +
                            '<p>运动工时：<span>' + sportTime + 'h</span></p>' +
                            '</div>';
                }
                $("#totalsHtml").html(html);
            }
        });
        if (departmentId != 0) {
            waterChart.setOption(setToOption(userNames, studys, works, sports, totals, "bar"));
        }
        else{
            waterChart.setOption(setToOption(dateStr, studys, works, sports, totals, "line"));
        }
    }

    //TODO 个人、团队、公司
    function setToOption(dataName, studys, works, sports, totals, type) {
//        console.log(dataName);
//        console.log(studys);
//        console.log(works);
//        console.log(sports);
//        console.log(totals);
//        console.log(type);
        option = {
            title : {
                text: '工时统计表',
                x: 'center',
                y: 'top',
                padding: 5,
            },
            tooltip : {
                trigger: 'axis'
            },
            color: ["#F39996", "#8B95C9", "#EDB579", "#81CEF4"],
            legend: {
                orient: 'horizontal',
                x: 'center',
                y: '30px',
                data:['学习工时','工作工时','运动工时','总工时']
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
                        formatter : "{value}h", //添加左侧单位
                    },
                }
            ],
            dataZoom: [{
                type: 'inside',
                start: 0,
                end: 30
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
                    name:'学习工时',
                    type: type,
                    data: studys,
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    }
                },
                {
                    name:'工作工时',
                    type: type,
                    data: works,
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                },
                {
                    name:'运动工时',
                    type: type,
                    data: sports,
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                },
                {
                    name:'总工时',
                    type: type,
                    data: totals,
                    markLine : {
                        data : [
                            {type : 'average', name : '平均值'}
                        ]
                    }
                }
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

        //部门过滤器
        form.on('select(departmentId)', function(data){
            console.log(data);
            getDepartmentIdUser(Number(data.value), 0);
            form.render();
        });

        //时间类型过滤器
        form.on('select(type)', function(data){
            if (data.value == 0) {
                var date = new Date();
                $("#time").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
                $("#time").show();
                $("#time2").hide();
            }
            else {
                var date = new Date();
                $("#time2").val(date.getFullYear() + "-" + (date.getMonth() + 1));
                $("#time2").show();
                $("#time").hide();
            }
            form.render();
        });

        form.render(); //重新渲染

    });

</script>
</body>
</html>
