package com.youlai.boot.devenv.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

import com.youlai.boot.devenv.entity.ShopUser;

@Tag(name = "参数测试接口")
@RestController
@RequestMapping("/api/shopping/parameters")
public class ParametersOfController {

    // 1. 请求参数接收 (@RequestParam)
    // 访问方式: http://localhost:8080/js/parameters/request?page=1&size=10&keyword=测试
    @GetMapping("/request")
    public String getRequestParameters(
            @RequestParam(defaultValue = "100") int page,
            @RequestParam(required = false) Integer size,
            @RequestParam("keyword") String searchKeyword) {
        return String.format("请求参数 - 页码: %d, 每页大小: %s, 关键词: %s",
                page, size == null ? "默认" : size, searchKeyword);
    }

    // 2. 请求头参数接收 (@RequestHeader)
    // 访问方式: 带Header信息的GET请求
    //
    // Header: Token: abc123, User-Agent: Mozilla/5.0
    @GetMapping("/header")
    public String getHeaderParameters(
            @RequestHeader(value = "Token", required = true) String token,
            @RequestHeader("User-Agent") String userAgent) {
        return String.format("请求头参数 - Token: %s, 浏览器信息: %s", token, userAgent);
    }

    // 3. Cookie参数接收 (@CookieValue)
    // 访问方式: 带Cookie的GET请求
    // Cookie: sessionId=xyz789; theme=dark
    @GetMapping("/cookie")
    public String getCookieParameters(
            @CookieValue("sessionId") String sessionId,
            @CookieValue(value = "theme", defaultValue = "light") String theme) {
        return String.format("Cookie参数 - SessionID: %s, 主题: %s", sessionId, theme);
    }

    // 4. 表单参数接收 (通过实体类)
    // 访问方式: POST请求，Content-Type: application/x-www-form-urlencoded
    // 表单字段: id=2&username=formUser&age=25
    @PostMapping("/form")
    public String getFormParameters(ShopUser user) {
        return String.format("表单参数 - 用户信息: ID=%d, 用户名=%s, 年龄=%d",
                user.getId(), user.getUsername(), user.getBirthday());
    }

    // 当请求到达时，Spring Boot会自动将JSON映射到User类的属性上（要求属性名与JSON键名一致）
    @PostMapping("/formbody")
    public String getRequestBodyParameters(@RequestBody ShopUser user) {
        return String.format("表单JSON参数 - 用户信息: ID=%d, 用户名=%s, 年龄=%d",
                user.getId(), user.getUsername(), user.getBirthday());
    }

    // 5. 动态复杂参数接收 (Map)
    // 访问方式: POST请求，Content-Type: application/x-www-form-urlencoded
    // 表单字段: anyKey1=value1&anyKey2=value2&anyKey3=value3
    @PostMapping("/map")
    public String getMapParameters(@RequestParam Map<String, Object> params) {
        StringBuilder result = new StringBuilder("Map接收参数: ");
        params.forEach((key, value) -> result.append(key).append("=").append(value).append("; "));
        return result.toString();
    }

    // 6. 路径参数接收 (@PathVariable)
    // 访问方式: http://localhost:8080/js/parameters/path/1001/zhagnsan
    @GetMapping("/path/{id}/{name}")
    public String getPathParameters(
            @PathVariable("id") Long userId,
            @PathVariable String name) {
        return String.format("路径参数 - ID: %d, 姓名: %s", userId, name);
    }

    // 7. 矩阵变量接收 (@MatrixVariable)
    // 示例：访问路径 /cars/123;color=red;year=2023
    @GetMapping("/cars/{carId}")
    public String getCar(
            @PathVariable Long carId,
            @MatrixVariable String color,  // 直接接收矩阵变量
            @MatrixVariable Integer year
    ) {
        return "Car ID: " + carId + ", Color: " + color + ", Year: " + year;
    }

    // 多值矩阵变量示例：/fruits;names=apple,banana,orange
    @GetMapping("/{fruits}")
    public String getFruits(@MatrixVariable(value = "names", pathVar = "fruits") List<String> fruitnames) {
        return "Fruits: " + String.join(",", fruitnames);
    }
}

