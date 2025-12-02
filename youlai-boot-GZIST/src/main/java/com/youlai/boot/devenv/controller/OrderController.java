package com.youlai.boot.devenv.controller;

import com.youlai.boot.devenv.entity.Order;
import com.youlai.boot.devenv.mapper.OrderMapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Tag(name = "订单接口")
@RestController
@RequestMapping("/api/shopping/orders")
public class OrderController {

    @Autowired
    private OrderMapper orderMapper;

    // 创建订单
    @PostMapping
    public Map<String, Object> createOrder(@RequestBody Order order) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = orderMapper.insert(order);
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "订单创建成功");
                result.put("data", order);
            } else {
                result.put("success", false);
                result.put("message", "订单创建失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "创建订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据ID查询订单
    @GetMapping("/{id}")
    public Map<String, Object> getOrderById(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            Order order = orderMapper.selectById(id);
            if (order != null) {
                result.put("success", true);
                result.put("data", order);
            } else {
                result.put("success", false);
                result.put("message", "订单不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "查询订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 查询所有订单
    @GetMapping
    public Map<String, Object> getAllOrders() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Order> orders = orderMapper.selectList(null);
            result.put("success", true);
            result.put("data", orders);
            result.put("total", orders.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "查询订单列表时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 分页查询订单
    @GetMapping("/page")
    public Map<String, Object> getOrdersByPage(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {
        Map<String, Object> result = new HashMap<>();
        try {
            Page<Order> page = new Page<>(current, size);
            orderMapper.selectPage(page, null);
            result.put("success", true);
            result.put("data", page.getRecords());
            result.put("total", page.getTotal());
            result.put("pages", page.getPages());
            result.put("current", page.getCurrent());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "分页查询订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据用户ID查询订单
    @GetMapping("/user/{uid}")
    public Map<String, Object> getOrdersByUserId(@PathVariable String uid) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("uid", uid);
            List<Order> orders = orderMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", orders);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "根据用户ID查询订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据商品ID查询订单
    @GetMapping("/goods/{goodsId}")
    public Map<String, Object> getOrdersByGoodsId(@PathVariable String goodsId) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("goods_id", goodsId);
            List<Order> orders = orderMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", orders);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "根据商品ID查询订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据时间范围查询订单
    @GetMapping("/time-range")
    public Map<String, Object> getOrdersByTimeRange(
            @RequestParam String startTime,
            @RequestParam String endTime) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
            queryWrapper.between("order_time", startTime, endTime);
            List<Order> orders = orderMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", orders);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "根据时间范围查询订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 更新订单
    @PutMapping("/{id}")
    public Map<String, Object> updateOrder(@PathVariable String id, @RequestBody Order order) {
        Map<String, Object> result = new HashMap<>();
        try {
            order.setId(id);
            int rows = orderMapper.updateById(order);
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "订单更新成功");
                result.put("data", orderMapper.selectById(id));
            } else {
                result.put("success", false);
                result.put("message", "订单不存在或更新失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "更新订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 删除订单
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteOrder(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = orderMapper.deleteById(id);
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "订单删除成功");
            } else {
                result.put("success", false);
                result.put("message", "订单不存在或删除失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "删除订单时发生错误: " + e.getMessage());
        }
        return result;
    }
}
