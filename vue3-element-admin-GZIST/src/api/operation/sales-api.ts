import request from "@/utils/request";

const OPERATION_SALES_BASE_URL = "/api/v1/operation/sales";

const OperationSalesAPI = {
  /** 查询销售统计 */
  getStatistics(queryParams?: SalesStatisticsQuery) {
    return request<any, SalesStatisticsItem[]>({
      url: `${OPERATION_SALES_BASE_URL}/statistics`,
      method: "get",
      params: queryParams,
    });
  },
  /** 查询库存列表 */
  getStocks(queryParams?: RepositoryStockQuery) {
    return request<any, RepositoryStockItem[]>({
      url: `${OPERATION_SALES_BASE_URL}/stock`,
      method: "get",
      params: queryParams,
    });
  },
  /** 补货 */
  replenish(data: ReplenishForm) {
    return request({
      url: `${OPERATION_SALES_BASE_URL}/replenish`,
      method: "post",
      data,
    });
  },
  /** 设置库存 */
  setStock(data: StockAdjustForm) {
    return request({
      url: `${OPERATION_SALES_BASE_URL}/stock/set`,
      method: "post",
      data,
    });
  },
  /** 商品下拉 */
  getProducts() {
    return request<any, OptionType[]>({
      url: `${OPERATION_SALES_BASE_URL}/products`,
      method: "get",
    });
  },
  /** 站点下拉 */
  getStations() {
    return request<any, OptionType[]>({
      url: `${OPERATION_SALES_BASE_URL}/stations`,
      method: "get",
    });
  },
};

export default OperationSalesAPI;

export interface SalesStatisticsQuery {
  productId?: number;
  stationId?: number;
  startDate?: string;
  endDate?: string;
}

export interface RepositoryStockQuery {
  productId?: number;
  stationId?: number;
}

export interface SalesStatisticsItem {
  repositoryId?: number;
  productId?: number;
  stationId?: number;
  productName?: string;
  stationName?: string;
  orderCount?: number;
  totalAmount?: number;
  commissionAmount?: number;
  currentQuantity?: number;
  dateRange?: string;
}

export interface RepositoryStockItem {
  repositoryId?: number;
  productId?: number;
  productName?: string;
  stationId?: number;
  stationName?: string;
  currentQuantity?: number;
  orderQuantityTotal?: number;
  orderDateLatest?: string;
  updateTime?: string;
}

export interface ReplenishForm {
  repositoryId: number;
  quantity: number;
}

export interface StockAdjustForm {
  productId: number;
  stationId: number;
  quantity: number;
}
