package com.youlai.boot.operation.service.impl;

import cn.hutool.core.lang.Assert;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.youlai.boot.common.model.Option;
import com.youlai.boot.security.util.SecurityUtils;
import com.youlai.boot.operation.mapper.BizRepositoryMapper;
import com.youlai.boot.operation.model.form.ReplenishForm;
import com.youlai.boot.operation.model.query.RepositoryStockQuery;
import com.youlai.boot.operation.model.query.SalesStatisticsQuery;
import com.youlai.boot.operation.model.vo.RepositoryStockVO;
import com.youlai.boot.operation.model.vo.SalesStatisticsVO;
import com.youlai.boot.operation.service.OperationSalesService;
import com.youlai.boot.products.model.entity.BizProducts;
import com.youlai.boot.products.service.BizProductsService;
import com.youlai.boot.system.model.entity.Dept;
import com.youlai.boot.system.service.DeptService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OperationSalesServiceImpl implements OperationSalesService {

    private static final BigDecimal ONE_HUNDRED = new BigDecimal("100");

    private final BizRepositoryMapper bizRepositoryMapper;
    private final BizProductsService bizProductsService;
    private final DeptService deptService;

    @Override
    public List<SalesStatisticsVO> listSalesStatistics(SalesStatisticsQuery queryParams) {
        normalizeDateRange(queryParams);
        List<SalesStatisticsVO> records = bizRepositoryMapper.listSalesStatistics(queryParams);
        String dateRange = buildDateRangeLabel(queryParams.getStartDate(), queryParams.getEndDate());
        for (SalesStatisticsVO record : records) {
            BigDecimal totalAmount = record.getTotalAmount() == null ? BigDecimal.ZERO : record.getTotalAmount();
            BigDecimal commissionRate = record.getCommissionRate() == null ? BigDecimal.ZERO : record.getCommissionRate();
            BigDecimal commissionAmount = totalAmount
                    .multiply(commissionRate)
                    .divide(ONE_HUNDRED, 2, RoundingMode.HALF_UP);
            record.setCommissionAmount(commissionAmount);
            record.setDateRange(dateRange);
        }
        return records;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean replenishStock(ReplenishForm formData) {
        Assert.notNull(formData.getRepositoryId(), "库存记录ID不能为空");
        Assert.notNull(formData.getQuantity(), "补货数量不能为空");
        Assert.isTrue(formData.getQuantity() > 0, "补货数量必须大于0");
        LocalDateTime now = LocalDateTime.now();
        Long userId = SecurityUtils.getUserId();
        int affected = bizRepositoryMapper.incrementStock(formData.getRepositoryId(), formData.getQuantity(), userId, now);
        Assert.isTrue(affected > 0, "补货失败，记录不存在");
        return true;
    }

    @Override
    public List<Option<Long>> listProductOptions() {
        List<BizProducts> products = bizProductsService.list(new LambdaQueryWrapper<BizProducts>()
                .select(BizProducts::getId, BizProducts::getName)
        );
        return products.stream()
                .map(item -> new Option<>(item.getId(), item.getName()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Option<Long>> listStationOptions() {
        List<Dept> deptList = deptService.list(new LambdaQueryWrapper<Dept>()
                .eq(Dept::getStatus, 1)
                .eq(Dept::getIsDeleted, 0)
                .select(Dept::getId, Dept::getName)
        );
        return deptList.stream()
                .map(item -> new Option<>(item.getId(), item.getName()))
                .collect(Collectors.toList());
    }

    @Override
    public List<RepositoryStockVO> listRepositoryStocks(RepositoryStockQuery queryParams) {
        return bizRepositoryMapper.listRepositoryStocks(queryParams);
    }

    private void normalizeDateRange(SalesStatisticsQuery queryParams) {
        LocalDate startDate = queryParams.getStartDate();
        LocalDate endDate = queryParams.getEndDate();
        if (startDate != null) {
            queryParams.setStartDateTime(startDate.atStartOfDay());
        }
        if (endDate != null) {
            queryParams.setEndDateTime(endDate.atTime(LocalTime.MAX));
        }
    }

    private String buildDateRangeLabel(LocalDate startDate, LocalDate endDate) {
        if (startDate == null && endDate == null) {
            return "";
        }
        String start = startDate != null ? startDate.toString() : "";
        String end = endDate != null ? endDate.toString() : "";
        if (start.isEmpty()) {
            return "截至 " + end;
        }
        if (end.isEmpty()) {
            return start + " 起";
        }
        return start + " 至 " + end;
    }
}
