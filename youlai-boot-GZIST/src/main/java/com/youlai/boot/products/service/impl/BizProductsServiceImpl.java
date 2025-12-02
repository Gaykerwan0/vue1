package com.youlai.boot.products.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.youlai.boot.products.mapper.BizProductsMapper;
import com.youlai.boot.products.service.BizProductsService;
import com.youlai.boot.products.model.entity.BizProducts;
import com.youlai.boot.products.model.form.BizProductsForm;
import com.youlai.boot.products.model.query.BizProductsQuery;
import com.youlai.boot.products.model.vo.BizProductsVO;
import com.youlai.boot.products.converter.BizProductsConverter;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import cn.hutool.core.lang.Assert;
import cn.hutool.core.util.StrUtil;

/**
 * 商品供应服务实现类
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
@Service
@RequiredArgsConstructor
public class BizProductsServiceImpl extends ServiceImpl<BizProductsMapper, BizProducts> implements BizProductsService {

    private final BizProductsConverter bizProductsConverter;

    /**
    * 获取商品供应分页列表
    *
    * @param queryParams 查询参数
    * @return {@link IPage<BizProductsVO>} 商品供应分页列表
    */
    @Override
    public IPage<BizProductsVO> getBizProductsPage(BizProductsQuery queryParams) {
        Page<BizProductsVO> pageVO = this.baseMapper.getBizProductsPage(
                new Page<>(queryParams.getPageNum(), queryParams.getPageSize()),
                queryParams
        );
        return pageVO;
    }
    
    /**
     * 获取商品供应表单数据
     *
     * @param id 商品供应ID
     * @return 商品供应表单数据
     */
    @Override
    public BizProductsForm getBizProductsFormData(Long id) {
        BizProducts entity = this.getById(id);
        return bizProductsConverter.toForm(entity);
    }
    
    /**
     * 新增商品供应
     *
     * @param formData 商品供应表单对象
     * @return 是否新增成功
     */
    @Override
    public boolean saveBizProducts(BizProductsForm formData) {
        BizProducts entity = bizProductsConverter.toEntity(formData);
        return this.save(entity);
    }
    
    /**
     * 更新商品供应
     *
     * @param id   商品供应ID
     * @param formData 商品供应表单对象
     * @return 是否修改成功
     */
    @Override
    public boolean updateBizProducts(Long id,BizProductsForm formData) {
        BizProducts entity = bizProductsConverter.toEntity(formData);
        return this.updateById(entity);
    }
    
    /**
     * 删除商品供应
     *
     * @param ids 商品供应ID，多个以英文逗号(,)分割
     * @return 是否删除成功
     */
    @Override
    public boolean deleteBizProducts(String ids) {
        Assert.isTrue(StrUtil.isNotBlank(ids), "删除的商品供应数据为空");
        // 逻辑删除
        List<Long> idList = Arrays.stream(ids.split(","))
                .map(Long::parseLong)
                .toList();
        return this.removeByIds(idList);
    }

}
