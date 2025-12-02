package com.youlai.boot.devenv.mapper;

import com.youlai.boot.devenv.entity.Order;
import com.youlai.boot.devenv.entity.ShopUser;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 */
@Mapper
public interface OrderMapper extends BaseMapper<Order> {

    @Select("select * from t_order where uid = #{uid}")
    List<Order> selectByUid(String uid);

    @Select("select * from t_order where goods_id = #{gid}")
    List<Order> selectByGid(String gid);

    //  查询所有的订单，同时查询订单的的用户
    @Select("select * from t_order")
    @Results(
            {
                    @Result(column = "id",property = "id"),
                    @Result(column = "ordertime",property = "ordertime"),
                    @Result(column = "total",property = "total"),
                    @Result(column = "uid",property = "uid"),
                    @Result(column = "uid",property = "user",javaType = ShopUser.class,
                            one = @One(select = "cn.edu.gzist.cs.demo.devenv.mapper.UserMapper.selectById"))
            }
    )
    List<Order> selectAllOrdersAndUser();
}