package com.youlai.boot.devenv.entity;

import com.baomidou.mybatisplus.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@TableName("t_goods")
public class Goods {

    @TableId(type = IdType.ASSIGN_UUID)
    private String id;

    @TableField("category")
    private String category;

    @TableField("name")
    private String name;

    @TableField("made_address")
    private String madeAddress;

    @TableField("price")
    private BigDecimal price;

    @TableField(exist = false)
    private List<Order> orders;

    @TableField(exist = false)
    private int orderCount;
    // 构造方法
    public Goods() {}

    public Goods(String category, String name, String madeAddress, BigDecimal price) {
        this.category = category;
        this.name = name;
        this.madeAddress = madeAddress;
        this.price = price;
    }

    // Getter和Setter方法
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMadeAddress() {
        return madeAddress;
    }

    public void setMadeAddress(String madeAddress) {
        this.madeAddress = madeAddress;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    @Override
    public String toString() {
        return "Goods{" +
                "id='" + id + '\'' +
                ", category='" + category + '\'' +
                ", name='" + name + '\'' +
                ", madeAddress='" + madeAddress + '\'' +
                ", price=" + price +
                '}';
    }
}