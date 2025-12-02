package com.youlai.boot.devenv.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;
import java.util.List;

@TableName("t_user")
public class ShopUser {

    @TableId(type = IdType.ASSIGN_UUID)
    private String id;

    @TableField("username")
    private String username;

    @TableField("password")
    private String password;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField("birthday")
    private LocalDateTime birthday;

    @TableField(exist = false)
    private List<Order> orders;

    // 构造方法
    public ShopUser() {}

    public ShopUser(String username, String password, LocalDateTime birthday) {
        this.username = username;
        this.password = password;
        this.birthday = birthday;
    }

    // Getter和Setter方法
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public LocalDateTime getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDateTime birthday) {
        this.birthday = birthday;
    }

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", birthday=" + birthday +
                '}';
    }
}
