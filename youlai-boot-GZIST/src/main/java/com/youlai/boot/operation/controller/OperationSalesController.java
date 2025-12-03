package com.youlai.boot.operation.controller;

import com.youlai.boot.common.model.Option;
import com.youlai.boot.core.web.Result;
import com.youlai.boot.operation.model.form.ReplenishForm;
import com.youlai.boot.operation.model.form.StockAdjustForm;
import com.youlai.boot.operation.model.query.RepositoryStockQuery;
import com.youlai.boot.operation.model.query.SalesStatisticsQuery;
import com.youlai.boot.operation.model.vo.RepositoryStockVO;
import com.youlai.boot.operation.model.vo.SalesStatisticsVO;
import com.youlai.boot.operation.service.OperationSalesService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "运营中心-销售统计接口")
@RestController
@RequestMapping("/api/v1/operation/sales")
@RequiredArgsConstructor
public class OperationSalesController {

    private final OperationSalesService operationSalesService;

    @Operation(summary = "销售统计列表")
    @GetMapping("/statistics")
    public Result<List<SalesStatisticsVO>> listStatistics(SalesStatisticsQuery queryParams) {
        List<SalesStatisticsVO> list = operationSalesService.listSalesStatistics(queryParams);
        return Result.success(list);
    }

    @Operation(summary = "补货库存")
    @PostMapping("/replenish")
    public Result<Void> replenish(@RequestBody @Valid ReplenishForm formData) {
        boolean result = operationSalesService.replenishStock(formData);
        return Result.judge(result);
    }

    @Operation(summary = "商品下拉列表")
    @GetMapping("/products")
    public Result<List<Option<Long>>> listProducts() {
        return Result.success(operationSalesService.listProductOptions());
    }

    @Operation(summary = "站点下拉列表")
    @GetMapping("/stations")
    public Result<List<Option<Long>>> listStations() {
        return Result.success(operationSalesService.listStationOptions());
    }

    @Operation(summary = "库存列表")
    @GetMapping("/stock")
    public Result<List<RepositoryStockVO>> listStocks(RepositoryStockQuery queryParams) {
        return Result.success(operationSalesService.listRepositoryStocks(queryParams));
    }

    @Operation(summary = "设置库存")
    @PostMapping("/stock/set")
    public Result<Void> setStock(@RequestBody @Valid StockAdjustForm formData) {
        return Result.judge(operationSalesService.setStock(formData));
    }
}
