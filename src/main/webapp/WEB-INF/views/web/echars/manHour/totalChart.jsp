<!-- 解决layer.open 不居中问题   -->
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>个人工作学习总时间统计</title>
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
                            <label class="layui-form-label">时间范围</label>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="开始时间" id="startTime">
                            </div>
                            <div class="layui-input-inline">
                                <input class="layui-input" placeholder="结束时间" id="endTime">
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
        <legend>个人工作学习总时间统计表&nbsp;<i class="fa fa-refresh" aria-hidden="true"></i></legend></legend>
        <div class="layui-field-box layui-form">
            <div id="water" style="width: 100%;height: 100%;min-height: 500px;"></div>
        </div>
    </fieldset>
</div>

<!--引入抽取公共js-->
<%@include file="../../common/public-js.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/echarts.min.js"></script>

<script>
    var waterChart = echarts.init(document.getElementById("water")); // 统计图对象
    var option = {} // 统计图配置

    //参数调用
    function passingParameters() {
        var companyId = $("#companyId").val();
        var departmentId = $("#departmentId").val();
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if (startTime == "") startTime = null;
        else startTime = YZ.getTimeStamp(startTime);
        if (endTime == "") endTime = null;
        else endTime = YZ.getTimeStamp(endTime);
        if (companyId == "") {
            companyId = 0;
        }
        if (departmentId == "") {
            departmentId = null;
        }
        var index = layer.load(1, {shade: [0.5,'#eee']});
        bindData(companyId, departmentId, startTime, endTime);
        setTimeout(function () {layer.close(index);}, 600);
    }

    //默认查询登录人
    bindData(YZ.getUserInfo().companyId, null, null, null);

    /**
     * 后台 工时统计
     * @param companyId 分公司ID
     * @param departmentId 部门ID
     * @param type 0:个人工作时间统计  1:个人学习时间统计 2:个人运动时间统计  3:个人工作学习总时间
     */
    function bindData (companyId, departmentId, startTime, endTime) {
        var names = []; //名称
        var userK = []; //分数
        var arr = {
            companyId : companyId,
            departmentId : departmentId,
            type : 3,
            start : startTime,
            end : endTime
        }
        var max = 0;
        YZ.ajaxRequestData("post", false, YZ.ip + "/statistics/statisticsWorkTime", arr , null , function(result) {
            if (result.flag == 0 && result.code == 200) {
                for (var i = 0; i < result.data.length; i++) {
                    names.push(result.data[i].name);
                    userK.push(Number(result.data[i].userK).toFixed(1));
                }
                //寻找最大的
                for (var i = 0; i < userK.length; i++) {
                    if (Number(userK[i]) > max) {
                        max = userK[i];
                    }
                }
                max = parseInt(YZ.getForTen(max));
                waterChart.setOption(setToOption(names, userK, "bar", max));
            }
        });
    }

    function setToOption(names, userK, type, max) {
        option = {
            title : {
                text: '个人工作学习总时间统计表',
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
                data:['个人工作学习总时间']
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
                    data : names
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
                    max: max
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
                    name:'个人工作学习总时间',
                    type: type,
                    data: userK,
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
        var start = {
            max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            min: laydate.now()
            ,max: '2099-06-16 23:59:59'
            ,istoday: false
            ,choose: function(datas){
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        document.getElementById('startTime').onclick = function(){
            start.elem = this;
            laydate(start);
        }
        document.getElementById('endTime').onclick = function(){
            end.elem = this
            laydate(end);
        }

        getCompanyListType(null, YZ.getUserInfo().companyId);
        getDepartmentListType(YZ.getUserInfo().companyId, null, null, 0);

        //公司过滤器
        form.on('select(company)', function(data){
            console.log(data);
            getDepartmentListType(Number(data.value), null, null, 0);
            form.render();
        });

        form.render(); //重新渲染

    });

</script>
</body>
</html>
