package com.youlai.boot.devenv.controller;

import com.youlai.boot.devenv.entity.ShopUser;
import com.youlai.boot.devenv.mapper.ShopUserMapper;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/shopping/users")
public class ShopUserController {

    @Autowired
    private ShopUserMapper userMapper;

    // 创建用户
    @PostMapping
    public Map<String, Object> createUser(@RequestBody ShopUser user) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = userMapper.insert(user);
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "用户创建成功");
                result.put("data", user);
            } else {
                result.put("success", false);
                result.put("message", "用户创建失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "创建用户时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据ID查询用户
    @GetMapping("/{id}")
    public Map<String, Object> getUserById(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            ShopUser user = userMapper.selectById(id);
            if (user != null) {
                result.put("success", true);
                result.put("data", user);
            } else {
                result.put("success", false);
                result.put("message", "用户不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "查询用户时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 查询所有用户
    @GetMapping
    public Map<String, Object> getAllUsers() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<ShopUser> users = userMapper.selectList(null);
            result.put("success", true);
            result.put("data", users);
            result.put("total", users.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "查询用户列表时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 查询所有用户
    @GetMapping(value = "/andorders")
    public Map<String, Object> getAllUsersAndOrders() {
        Map<String, Object> result = new HashMap<>();
        try {
            List<ShopUser> users = userMapper.selectAllUserAndOrders();
            result.put("success", true);
            result.put("data", users);
            result.put("total", users.size());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "查询用户列表时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 分页查询用户
    @GetMapping("/page")
    public Map<String, Object> getUsersByPage(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {
        Map<String, Object> result = new HashMap<>();
        try {
            Page<ShopUser> page = new Page<>(current, size);
            userMapper.selectPage(page, null);
            result.put("success", true);
            result.put("data", page.getRecords());
            result.put("total", page.getTotal());
            result.put("pages", page.getPages());
            result.put("current", page.getCurrent());
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "分页查询用户时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 根据用户名查询
    @GetMapping("/username/{username}")
    public Map<String, Object> getUserByUsername(@PathVariable String username) {
        Map<String, Object> result = new HashMap<>();
        try {
            QueryWrapper<ShopUser> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("username", username);
            List<ShopUser> users = userMapper.selectList(queryWrapper);
            result.put("success", true);
            result.put("data", users);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "根据用户名查询用户时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 更新用户
    @PutMapping("/{id}")
    public Map<String, Object> updateUser(@PathVariable String id, @RequestBody ShopUser user) {
        Map<String, Object> result = new HashMap<>();
        try {
            user.setId(id);
            int rows = userMapper.updateById(user);
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "用户更新成功");
                result.put("data", userMapper.selectById(id));
            } else {
                result.put("success", false);
                result.put("message", "用户不存在或更新失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "更新用户时发生错误: " + e.getMessage());
        }
        return result;
    }

    // 删除用户
    @DeleteMapping("/{id}")
    public Map<String, Object> deleteUser(@PathVariable String id) {
        Map<String, Object> result = new HashMap<>();
        try {
            int rows = userMapper.deleteById(id);
            if (rows > 0) {
                result.put("success", true);
                result.put("message", "用户删除成功");
            } else {
                result.put("success", false);
                result.put("message", "用户不存在或删除失败");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "删除用户时发生错误: " + e.getMessage());
        }
        return result;
    }
}
