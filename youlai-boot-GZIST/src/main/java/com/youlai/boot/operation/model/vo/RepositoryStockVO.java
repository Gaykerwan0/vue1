package com.youlai.boot.operation.model.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RepositoryStockVO {

    private Long repositoryId;

    private Long productId;

    private String productName;

    private Long stationId;

    private String stationName;

    private Integer currentQuantity;

    private Integer orderQuantityTotal;

    private LocalDateTime orderDateLatest;
}
