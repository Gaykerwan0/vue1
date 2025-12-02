package com.youlai.boot.operation.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.youlai.boot.operation.model.entity.BizRepository;
import com.youlai.boot.operation.model.query.RepositoryStockQuery;
import com.youlai.boot.operation.model.query.SalesStatisticsQuery;
import com.youlai.boot.operation.model.vo.RepositoryStockVO;
import com.youlai.boot.operation.model.vo.SalesStatisticsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface BizRepositoryMapper extends BaseMapper<BizRepository> {

    List<SalesStatisticsVO> listSalesStatistics(@Param("query") SalesStatisticsQuery queryParams);

    List<RepositoryStockVO> listRepositoryStocks(@Param("query") RepositoryStockQuery queryParams);

    int incrementStock(@Param("repositoryId") Long repositoryId,
                       @Param("quantity") Integer quantity,
                       @Param("updateBy") Long updateBy,
                       @Param("updateTime") LocalDateTime updateTime);
}
