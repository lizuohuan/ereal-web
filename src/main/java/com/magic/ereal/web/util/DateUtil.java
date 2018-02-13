package com.magic.ereal.web.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 时间格式化工具
 * Created by Eric Xie on 2017/4/24 0024.
 */
public class DateUtil {

    /**
     * 将 时间戳 格式化成 指定格式 时间
     * @return
     */
    public static String dateFortimestamp(long timestamp,String format) throws Exception{
        if(0 == timestamp){
            timestamp = System.currentTimeMillis();
        }
        DateFormat dateFormat = new SimpleDateFormat(format);
        return dateFormat.format(new Date(timestamp));
    }


    public static Date strToDate(String dataStr,String format){
        DateFormat dateFormat = new SimpleDateFormat(format);
        try {
            return dateFormat.parse(dataStr);
        } catch (ParseException e) {
            e.printStackTrace();
            return new Date();
        }
    }

    public static Date dateFortimestamp(long timestamp,String format,Integer flag){
        if(0 == timestamp){
            timestamp = System.currentTimeMillis();
        }
        DateFormat dateFormat = new SimpleDateFormat(format);
        return strToDate(dateFormat.format(new Date(timestamp)),format);
    }





}
