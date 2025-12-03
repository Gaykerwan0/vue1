package com.youlai.boot.operation.service;

import com.youlai.boot.common.model.Option;
import com.youlai.boot.operation.model.form.ReplenishForm;
import com.youlai.boot.operation.model.form.StockAdjustForm;
import com.youlai.boot.operation.model.query.RepositoryStockQuery;
import com.youlai.boot.operation.model.query.SalesStatisticsQuery;
import com.youlai.boot.operation.model.vo.RepositoryStockVO;
import com.youlai.boot.operation.model.vo.SalesStatisticsVO;

import java.util.List;

public interface OperationSalesService {

    List<SalesStatisticsVO> listSalesStatistics(SalesStatisticsQuery queryParams);

    boolean replenishStock(ReplenishForm formData);

    List<Option<Long>> listProductOptions();

    List<Option<Long>> listStationOptions();

    List<RepositoryStockVO> listRepositoryStocks(RepositoryStockQuery queryParams);

    boolean setStock(StockAdjustForm formData);
}
