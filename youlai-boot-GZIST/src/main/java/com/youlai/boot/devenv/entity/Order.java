package com.youlai.boot.devenv.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;

@TableName("t_order")
public class Order {

    @TableId(type = IdType.ASSIGN_UUID)
    private String id;

    @TableField("goods_id")
    private String goodsId;

    @TableField(value = "order_time", fill = FieldFill.INSERT)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime orderTime;

    @TableField("total")
    private Integer total;

    @TableField("uid")
    private String uid;

    @TableField(exist = false)
    private ShopUser user;

    @TableField(exist = false)
    private Goods goods;


    // 构造方法
    public Order() {}

    public Order(String goodsId, Integer total, String uid) {
        this.goodsId = goodsId;
        this.total = total;
        this.uid = uid;
    }

    // Getter和Setter方法
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(String goodsId) {
        this.goodsId = goodsId;
    }

    public LocalDateTime getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(LocalDateTime orderTime) {
        this.orderTime = orderTime;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public ShopUser getUser() {
        return user;
    }

    public void setUser(ShopUser user) {
        this.user = user;
    }

    public Goods getGoods() {
        return goods;
    }

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id='" + id + '\'' +
                ", goodsId='" + goodsId + '\'' +
                ", orderTime=" + orderTime +
                ", total=" + total +
                ", uid='" + uid + '\'' +
                '}';
    }
}
