var index = layer.load(1, {
    shade: [0.1,'#fff'] //0.1透明度的白色背景
});
var menuList = YZ.getLoginUserJurisdiction();
setTimeout(function(){layer.close(index);}, 600);

console.log("*********权限列表***********");
console.log(menuList);
console.log("*********权限列表***********");

var menuArray = [];
for (var i = 0; i < menuList.length; i++) {
    var childrenArray = [];
    for (var j = 0; j < menuList[i].child.length; j++) {
        if (menuList[i].child[j].href != null && menuList[i].child[j].href != "") {
            if (menuList[i].child[j].href == null) {
                menuList[i].child[j].href = "/page/error";
            }
            var childJson = {
                title : menuList[i].child[j].title,
                href : YZ.ip + menuList[i].child[j].href,
            }
            childrenArray.push(childJson);
        }
    }
    if (menuList[i].href == null) {
        menuList[i].href = "/page/error";
    }
    var json = {
        title : menuList[i].title,
        icon : menuList[i].icon,
        spread : menuList[i].spread,
        href : YZ.ip + menuList[i].href,
        children : childrenArray,
    }
    menuArray.push(json);
}
var navs = menuArray;

/*var navs = [{
    "title": "角色管理",
    "icon": "fa-drivers-license",
    "spread": false,
    "href": YZ.ip + "/page/role/list"
}, {
    "title": "公司管理",
    "icon": "fa-asl-interpreting",
    "spread": false,
    "href": YZ.ip + "/page/company/list"
}, {
    "title": "部门管理",
    "icon": "fa-mortar-board",
    "spread": false,
    "href": YZ.ip + "/page/department/list"
}, {
    "title": "用户管理",
    "icon": "fa-group",
    "spread": false,
    "href": YZ.ip + "/page/user/list"
}, {
    "title": "工作类型管理",
    "icon": "fa-random",
    "spread": false,
    "href": YZ.ip + "/page/jobType/list"
}, {
    "title": "事务类型管理",
    "icon": "fa-sitemap",
    "spread": false,
    "href": YZ.ip + "/page/transactionType/list"
},  {
    "title": "传递卡管理",
    "icon": "fa-credit-card",
    "spread": false,
    "href": YZ.ip + "/page/workDiary/list"
},  {
    "title": "项目管理",
    "icon": "fa-object-ungroup",
    "spread": false,
    "children": [{
        "title": "内部项目专业管理",
        //"icon": "fa-newspaper-o",
        "href": YZ.ip + "/page/project/projectMajor/list"
    }, {
        "title": "项目组管理",
        //"icon": "fa-newspaper-o",
        "href": YZ.ip + "/page/project/projectGroup/list"
    }, {
        "title": "内部项目管理",
        //"icon": "fa-newspaper-o",
        "href": YZ.ip + "/page/project/projectInterior/list"
    }, {
        "title": "项目类型管理",
        //"icon": "fa-newspaper-o",
        "href": YZ.ip + "/page/project/projectType/list"
    }, {
        "title": "外部项目管理",
        //"icon": "fa-newspaper-o",
        "href": YZ.ip + "/page/project/projectExternal/list"
    }]
},  {
    "title": "统计管理",
    "icon": "fa-line-chart",
    "spread": false,
    "children": [{
        "title": "个人工作时间",
        //"icon": "fa-podcast",
        "href": YZ.ip + "/page/echars/manHour/workChart"
    }, {
        "title": "个人学习时间",
        //"icon": "fa-podcast",
        "href": YZ.ip + "/page/echars/manHour/studyChart"
    }, {
        "title": "个人运动时间",
        //"icon": "fa-podcast",
        "href": YZ.ip + "/page/echars/manHour/exerciseChart"
    }, {
        "title": "个人工作学习总时间",
        //"icon": "fa-podcast",
        "href": YZ.ip + "/page/echars/manHour/totalChart"
    }, {
        "title": "个人K可比",
        //"icon": "fa-podcast",
        "href": YZ.ip + "/page/echars/personKk/personKkChart"
    }, {
        "title": "团队K总完成率",
        //"icon": "fa-ravelry",
        "href": YZ.ip + "/page/echars/threeDimensional/oneChart"
    }, {
        "title": "团队结项完成率",
        //"icon": "fa-linode",
        "href": YZ.ip + "/page/echars/threeDimensional/twoChart"
    }, {
        "title": "文化工程",
        //"icon": "fa-grav",
        "href": YZ.ip + "/page/echars/threeDimensional/threeChart"
    }, {
        "title": "三维绩效考核得分",
        //"icon": "fa-superpowers",
        "href": YZ.ip + "/page/echars/check/checkChart"
    }, {
        "title": "三维绩效汇总表",
        //"icon": "fa-table",
        "href": YZ.ip + "/page/echars/check/checkTable"
    }

    /!*, {
        "title": "工时统计",
        "icon": "fa-hourglass-2",
        "href": YZ.ip + "/page/echars/workDiary/workingChart"
    }, {
        "title": "破题统计",
        "icon": "fa-heartbeat",
        "href": YZ.ip + "/page/echars/theEssay/theEssayChart"
    }*!/]
},  {
    "title": "荣誉时刻",
    "icon": "fa-database",
    "spread": false,
    "children": [{
        "title": "月度K王",
        //"icon": "fa-anchor",
        "href": YZ.ip + "/page/honorMoment/kWang"
    }, {
        "title": "月度优秀团队",
        //"icon": "fa-window-restore",
        "href": YZ.ip + "/page/honorMoment/goodTeam"
    }, {
        "title": "一真精神奖/优秀执委",
        //"icon": "fa-flag-checkered",
        "href": YZ.ip + "/page/honorMoment/spiritAwards/list"
    }]
},  {
    "title": "三维管理",
    "icon": "fa-wpexplorer",
    "spread": false,
    "children": [{
        "title": "一维管理",
        //"icon": "fa-thermometer-1",
        "href": YZ.ip + "/page/kStatistics/oneDimension/list"
    }, {
        "title": "二维管理",
        //"icon": "fa-thermometer-2",
        "href": YZ.ip + "/page/kStatistics/twoDimension/list"
    }, {
        "title": "三维管理",
        //"icon": "fa-thermometer-3",
        "href": YZ.ip + "/page/kStatistics/threeDimension/list"
    }]
},  {
    "title": "配置管理",
    "icon": "fa-gears",
    "spread": false,
    "children": [{
        "title": "全局配置",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/allConfig"
    }, {
        "title": "目标指标配置",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/secondTarget/list"
    }, {
        "title": "第二维配置",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/secondVeidooConfig"
    }, {
        "title": "第三维配置",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/threeVeidoo/list"
    }, {
        "title": "第三维评分",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/threeVeidooScore/list"
    }, {
        "title": "配置应出勤天数",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/monthDays/list"
    }, {
        "title": "员工出勤情况",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/monthDaysUser/list"
    }, {
        "title": "员工请假情况",
        //"icon": "fa-gear",
        "href": YZ.ip + "/page/config/monthDaysLeave/list"
    }, ]
}, {
    "title": "文章管理",
    "icon": "fa-book",
    "spread": false,
    "children": [{
        "title": "使用协议与隐私政策",
        //"icon": "fa-edit",
        "href": YZ.ip + "/page/agreement/agreementEdit",
    },{
        "title": "关于一真",
        //"icon": "fa-edit",
        "href": YZ.ip + "/page/agreement/aboutEdit",
    }]
}, {
    "title": "Banner管理",
    "icon": "fa-window-maximize",
    "href": YZ.ip + "/page/banner/list",
    "spread": false
}, {
    "title": "权限管理",
    "icon": "fa-shopping-bag",
    "href": YZ.ip + "/page/jurisdiction/add",
    "spread": false
}, {
    "title": "消息管理",
    "icon": "fa-bell",
    "spread": false,
    "children": [{
        "title": "推送消息",
        "href": YZ.ip + "/page/systemInfo/pushMessage",
    }]

}, /!*{
    "title": "授权审批权限",
    "icon": "fa-handshake-o",
    "href": YZ.ip + "/page/accredit/edit",
    "spread": false
}*!/];*/

//navs = menuArray;

var tab;

layui.config({
    base: YZ.ip + "/resources/js/common/",
    version: new Date().getTime()
}).use(['element', 'layer', 'navbar', 'tab'], function () {
    var element = layui.element(),
        $ = layui.jquery,
        layer = layui.layer,
        navbar = layui.navbar();
    tab = layui.tab({
        elem: '.admin-nav-card', //设置选项卡容器
        maxSetting: {
        	max: 10,
        	tipMsg: '最多只能打开10个页面.'
        },
        contextMenu: true,
        onSwitch: function (data) {
            /*console.log(data.id); //当前Tab的Id
            console.log(data.index); //得到当前Tab的所在下标
            console.log(data.elem); //得到当前的Tab大容器
            console.log(tab.getCurrentTabId());//当前Tab的Id*/
        }
    });

    //iframe自适应
    if(isFirefox = navigator.userAgent.indexOf("Firefox") > 0){
        $(window).on('resize', function () {
            var $content = $('.admin-nav-card .layui-tab-content');
            $content.height($(document).height() - 147);
            $content.find('iframe').each(function () {
                $(this).height($content.height());
            });
        }).resize();
    }
    else {
        $(window).on('resize', function () {
            var $content = $('.admin-nav-card .layui-tab-content');
            $content.height($(this).height() - 147);
            $content.find('iframe').each(function () {
                $(this).height($content.height());
            });
        }).resize();
    }

    //设置navbar
    navbar.set({
        spreadOne: true,
        elem: '#admin-navbar-side',
        cached: true,
        data: navs
        /*cached:true,
         url: 'datas/nav.json'*/
    });
    //渲染navbar
    navbar.render();
    //监听点击事件
    navbar.on('click(side)', function (data) {
        console.log(data);
        tab.tabAdd(data.field);
        console.log(data.field.href);
        //location.href = data.field.href;
        var index = layer.load(1, {shade: [0.5,'#eee']});
        setTimeout(function () {layer.close(index);}, 600);
    });

    //单击收起菜单
    $('.admin-side-toggle').on('click', function () {
        var sideWidth = $('#admin-side').width();
        if (sideWidth === 200) {
            $('#admin-body').animate({
                left: '0'
            }); //admin-footer
            $('#admin-footer').animate({
                left: '0'
            });
            $('#admin-side').animate({
                width: '0'
            });
        } else {
            $('#admin-body').animate({
                left: '200px'
            });
            $('#admin-footer').animate({
                left: '200px'
            });
            $('#admin-side').animate({
                width: '200px'
            });
        }
    });

    //单击全屏
    $('.admin-side-full').on('click', function () {
        var docElm = document.documentElement;
        //W3C
        if (docElm.requestFullscreen) {
            docElm.requestFullscreen();
        }
        //FireFox
        else if (docElm.mozRequestFullScreen) {
            docElm.mozRequestFullScreen();
        }
        //Chrome等
        else if (docElm.webkitRequestFullScreen) {
            docElm.webkitRequestFullScreen();
        }
        //IE11
        else if (elem.msRequestFullscreen) {
            elem.msRequestFullscreen();
        }
        layer.msg('按Esc即可退出全屏');
    });



    //锁屏
    $(document).on('keydown', function () {
        var e = window.event;
        if (e.keyCode === 76 && e.altKey) {
            //alert("你按下了alt+l");
            lock($, layer);
        }
    });
    $('#lock').on('click', function () {
        lock($, layer);
    });

    //手机设备的简单适配
    var treeMobile = $('.site-tree-mobile'),
        shadeMobile = $('.site-mobile-shade');
    treeMobile.on('click', function () {
        $('body').addClass('site-mobile');
    });
    shadeMobile.on('click', function () {
        $('body').removeClass('site-mobile');
    });
});

var isShowLock = false;
function lock($, layer) {
    localStorage.setItem("isShowLock", true);
    if (isShowLock)
        return;
    var avatar = "";
    if (YZ.getUserInfo().avatar == "" || YZ.getUserInfo().avatar == null) {
        avatar = YZ.ip + "/resources/img/0.jpg";
    }
    else {
        avatar = YZ.ipImg + '/' + YZ.getUserInfo().avatar;
    }
    //自定页
    layer.open({
        title: false,
        type: 1,
        closeBtn: 0,
        anim: 6,
        content: '<div id="lock-temp">' +
        '<div class="admin-header-lock" id="lock-box">' +
        '<div class="admin-header-lock-img">' +
        '<img id="avatar2" src="' + avatar + '" />' +
        '</div>' +
        '<div class="admin-header-lock-name" id="lockUserName">' + YZ.getUserInfo().account + '</div>' +
        '<input type="password" class="admin-header-lock-input" placeholder="输入登录密码解锁." name="lockPwd" id="lockPwd" autocomplete="off" />&nbsp;&nbsp;' +
        '<button class="layui-btn layui-btn-small" id="unlock" style="margin-top: -1px;">解锁</button>' +
        '</div></div>',
        shade: [0.9, '#393D49'],
        success: function (layero, lockIndex) {
            isShowLock = true;
            //给显示用户名赋值
            //绑定解锁按钮的点击事件
            $('button#unlock').on('click', function () {
                var $lockBox = $('div#lock-box');
                var account = $lockBox.find('div#lockUserName').html();
                var pwd = $lockBox.find('input[name=lockPwd]').val();
                if (pwd.length === 0) {
                    layer.msg('请输入密码..', {
                        icon: 2,
                        time: 1000,
                        anim: 6,
                        offset: 't'
                    });
                    $("#lockPwd").focus();
                    return;
                }
                unlock(account, pwd);
            });
            /**
             * 解锁操作方法
             * @param {String} 用户名
             * @param {String} 密码
             */
            var unlock = function (account, pwd) {
                //这里可以使用ajax方法解锁
                var arr = {
                    account : account,
                    password : $.md5(pwd)
                }
                if (arr.password == YZ.getUserInfo().password) {
                    localStorage.removeItem("isShowLock");
                    isShowLock = false;
                    layer.close(lockIndex);
                }
                else {
                    layer.msg("密码错误.", {icon: 2, anim: 6, time: 1000, offset: 't'});
                    return false;
                }
                /*$.ajax({
                    type : "post",
                    url : YZ.ip + "/user/lockPassword",
                    data : arr,
                    headers: {
                        "token" : YZ.getUserInfo() == null ? null : YZ.getUserInfo().token,
                    },
                    success : function (result) {
                        console.log(result);
                        if (result.flag == 0 && result.code == 200) {
                            localStorage.removeItem("isShowLock");
                            isShowLock = false;
                            layer.close(lockIndex);
                        }
                        else {
                            layer.msg(result.msg, {icon: 2, anim: 6, time: 1000, offset: 't'});
                            return false;
                        }
                    }
                });*/
            };
        }
    });
};