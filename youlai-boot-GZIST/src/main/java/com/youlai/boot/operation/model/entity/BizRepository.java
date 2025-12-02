package com.youlai.boot.operation.model.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.youlai.boot.common.base.BaseEntity;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@TableName("biz_repository")
public class BizRepository extends BaseEntity {

    private Long departmentId;

    private Long productId;

    private Integer currentQuantity;

    private Integer orderQuantityTotal;

    private LocalDateTime orderDateLatest;

    private Long createBy;

    private Long updateBy;
}
