package com.youlai.boot.devenv.controller;

import com.youlai.boot.core.web.Result;
import com.youlai.boot.devenv.entity.Goods;
import com.youlai.boot.devenv.entity.Order;
import com.youlai.boot.devenv.mapper.GoodsMapper;
import com.youlai.boot.devenv.mapper.OrderMapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Tag(name = "12. 商品接口")
@RestController
@RequestMapping("/api/shopping/goods")
public class GoodsController {

    @Autowired
    private GoodsMapper goodsMapper;

    @Autowired
    private OrderMapper orderMapper;

    // 创建商品
    @Operation(summary = "商品创建")
    @PostMapping
    public Map<String, Object> createGoods(@RequestBody Goods goods) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = goodsMapper.insert(goods);
            if (rows > 0) {
                result.put("success", true);
                result.put("msg", "商品创建成功");
                result.put("data", goods);
            } else {
                result.put("success", false);
                result.put("msg", "商品创建失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "创建商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据ID查询商品
    @Operation(summary = "根据ID查询商品")
    @GetMapping("/{id}")
    public Map<String, Object> getGoodsById(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            Goods goods = goodsMapper.selectById(id);
            if (goods != null) {
                result.put("success", true);
                result.put("data", goods);
            } else {
                result.put("success", false);
                result.put("msg", "商品不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "查询商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据ID, 查询订单
    @Operation(summary = "根据商品ID查询所有订单")
    @GetMapping("/{id}/orders")
    public Map<String, Object> getOrdersById(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            Goods goods = goodsMapper.selectById(id);
            if (goods != null && goods.getId() != null) {
                List<Order> orders = orderMapper.selectByGid(goods.getId());
                if(orders != null){
                    result.put("success", true);
                    result.put("data", orders);
                }
                else{
                    result.put("success", false);
                    result.put("msg", "订单不存在");
                }
            } else {
                result.put("success", false);
                result.put("msg", "商品不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "查询订单时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 查询所有商品
    @GetMapping
    public Map<String, Object> getAllGoods() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Goods> goodsList = goodsMapper.selectList(null);
            result.put("success", true);
            result.put("data", goodsList);
            result.put("total", goodsList.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "查询商品列表时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 查询所有商品
    @GetMapping(value = "/countorders")
    public Map<String, Object> getAllGoodsWithStatistics() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<Goods> goodsList = goodsMapper.selectGoodsWithOrderCount();
            result.put("success", true);
            result.put("data", goodsList);
            result.put("total", goodsList.size());

        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "查询商品列表时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 分页查询商品
    @GetMapping("/page")
    public Map<String, Object> getGoodsByPage(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {
        Map<String, Object> result = new HashMap<>();
        try {
            Page<Goods> page = new Page<>(current, size);
            goodsMapper.selectPage(page, null);
            result.put("success", true);
            result.put("data", page.getRecords());
            result.put("total", page.getTotal());
            result.put("pages", page.getPages());
            result.put("current", page.getCurrent());
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "分页查询商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据分类查询商品
    @GetMapping("/category/{category}")
    public Map<String, Object> getGoodsByCategory(@PathVariable String category) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<Goods> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("category", category);
            List<Goods> goodsList = goodsMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", goodsList);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "根据分类查询商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据价格范围查询商品
    @GetMapping("/price-range")
    public Map<String, Object> getGoodsByPriceRange(
            @RequestParam BigDecimal minPrice,
            @RequestParam BigDecimal maxPrice) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<Goods> queryWrapper = new QueryWrapper<>();
            queryWrapper.between("price", minPrice, maxPrice);
            List<Goods> goodsList = goodsMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", goodsList);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "根据价格范围查询商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 模糊查询商品
    @Operation(summary = "根据商品名称进行模糊查询商品")
    @GetMapping("/search")
    public Map<String, Object> searchGoodsByName(@RequestParam String name) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<Goods> queryWrapper = new QueryWrapper<>();
            queryWrapper.like("name", name);
            List<Goods> goodsList = goodsMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", goodsList);
            result.put("total", goodsList.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "模糊查询商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 更新商品
    @PutMapping("/{id}")
    public Map<String, Object> updateGoods(@PathVariable String id, @RequestBody Goods goods) {
        Map<String, Object> result = new HashMap<>();
        try {
            goods.setId(id);
            int rows = goodsMapper.updateById(goods);
            if (rows > 0) {
                result.put("success", true);
                result.put("msg", "商品更新成功");
                result.put("data", goodsMapper.selectById(id));
            } else {
                result.put("success", false);
                result.put("msg", "商品不存在或更新失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "更新商品时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 删除商品
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteGoods(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = goodsMapper.deleteById(id);
            if (rows > 0) {
                result.put("success", true);
                result.put("msg", "商品删除成功");
            } else {
                result.put("success", false);
                result.put("msg", "商品不存在或删除失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "删除商品时发生错误: " + e.getMessage());
        }
        return result;
    }
}