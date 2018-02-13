package com.magic.ereal.web.controller;

import com.magic.ereal.business.service.UsersStatisticsThreeService;
import com.magic.ereal.web.util.ViewData;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 *
 * @author lzh
 * @create 2017/6/2 10:36
 */
@RestController
@RequestMapping("ust")
public class UsersStatisticsThreeController extends BaseController {

    @Resource
    private UsersStatisticsThreeService usersStatisticsThreeService;


//    public ViewData save(){
//        try {
//
//        } catch (Exception e) {
//            logger.error("服务器超时，操作失败",e);
//        }
//    }

}
