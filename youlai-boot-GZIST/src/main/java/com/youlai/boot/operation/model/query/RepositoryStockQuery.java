package com.youlai.boot.operation.model.query;

import lombok.Data;

/**
 * 商品库存查询条件
 */
@Data
public class RepositoryStockQuery {

    /** 商品ID */
    private Long productId;

    /** 站点ID */
    private Long stationId;
}
