package com.youlai.boot.devenv.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.youlai.boot.devenv.entity.Goods;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface GoodsMapper extends BaseMapper<Goods> {

    @Select("SELECT g.*, COUNT(o.id) as order_count FROM t_goods g LEFT JOIN t_order o ON g.id = o.goods_id GROUP BY g.id")
    @Results({
            @Result(column = "id", property = "id"),
            @Result(column = "name", property = "name"),
            @Result(column = "made_address", property = "madeAddress"),
            @Result(column = "price", property = "price"),
            @Result(column = "order_count", property = "orderCount")
    })
    List<Goods> selectGoodsWithOrderCount();
}

