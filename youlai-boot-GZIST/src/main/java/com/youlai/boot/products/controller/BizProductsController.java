package com.youlai.boot.products.controller;

import com.youlai.boot.products.service.BizProductsService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.youlai.boot.products.model.form.BizProductsForm;
import com.youlai.boot.products.model.query.BizProductsQuery;
import com.youlai.boot.products.model.vo.BizProductsVO;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.youlai.boot.core.web.PageResult;
import com.youlai.boot.core.web.Result;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

import java.io.Console;

/**
 * 商品供应前端控制层
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Tag(name = "商品供应接口")
@RestController
@RequestMapping("/api/v1/biz-products")
@RequiredArgsConstructor
public class BizProductsController  {

    private final BizProductsService bizProductsService;

    @Operation(summary = "商品供应分页列表")
    @GetMapping("/page")
    @PreAuthorize("@ss.hasPerm('products:biz-products:query')")
    public PageResult<BizProductsVO> getBizProductsPage(BizProductsQuery queryParams ) {
//        println("queryParams = " + queryParams);
        IPage<BizProductsVO> result = bizProductsService.getBizProductsPage(queryParams);
        return PageResult.success(result);
    }

    @Operation(summary = "新增商品供应")
    @PostMapping
    @PreAuthorize("@ss.hasPerm('products:biz-products:add')")
    public Result<Void> saveBizProducts(@RequestBody @Valid BizProductsForm formData ) {
        boolean result = bizProductsService.saveBizProducts(formData);
        return Result.judge(result);
    }

    @Operation(summary = "获取商品供应表单数据")
    @GetMapping("/{id}/form")
    @PreAuthorize("@ss.hasPerm('products:biz-products:edit')")
    public Result<BizProductsForm> getBizProductsForm(
        @Parameter(description = "商品供应ID") @PathVariable Long id
    ) {
        BizProductsForm formData = bizProductsService.getBizProductsFormData(id);
        return Result.success(formData);
    }

    @Operation(summary = "修改商品供应")
    @PutMapping(value = "/{id}")
    @PreAuthorize("@ss.hasPerm('products:biz-products:edit')")
    public Result<Void> updateBizProducts(
            @Parameter(description = "商品供应ID") @PathVariable Long id,
            @RequestBody @Validated BizProductsForm formData
    ) {
        boolean result = bizProductsService.updateBizProducts(id, formData);
        return Result.judge(result);
    }

    @Operation(summary = "删除商品供应")
    @DeleteMapping("/{ids}")
    @PreAuthorize("@ss.hasPerm('products:biz-products:delete')")
    public Result<Void> deleteBizProducts(
        @Parameter(description = "商品供应ID，多个以英文逗号(,)分割") @PathVariable String ids
    ) {
        boolean result = bizProductsService.deleteBizProducts(ids);
        return Result.judge(result);
    }
}
