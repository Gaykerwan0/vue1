package com.youlai.boot.devenv.config;


import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
//
//@Component
//public class OrdersMetaDataHandler implements MetaObjectHandler {
//
//    @Override
//    public void insertFill(MetaObject metaObject) {
//        this.strictInsertFill(metaObject, "orderTime", LocalDateTime.class, LocalDateTime.now());
//    }
//
//    @Override
//    public void updateFill(MetaObject metaObject) {
//        // 更新时不填充orderTime
//    }
//}