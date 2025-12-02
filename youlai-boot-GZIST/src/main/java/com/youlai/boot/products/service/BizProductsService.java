package com.youlai.boot.products.service;

import com.youlai.boot.products.model.entity.BizProducts;
import com.youlai.boot.products.model.form.BizProductsForm;
import com.youlai.boot.products.model.query.BizProductsQuery;
import com.youlai.boot.products.model.vo.BizProductsVO;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 商品供应服务类
 *
 * @author youlaitech
 * @since 2025-11-22 18:22
 */
public interface BizProductsService extends IService<BizProducts> {

    /**
     *商品供应分页列表
     *
     * @return {@link IPage<BizProductsVO>} 商品供应分页列表
     */
    IPage<BizProductsVO> getBizProductsPage(BizProductsQuery queryParams);

    /**
     * 获取商品供应表单数据
     *
     * @param id 商品供应ID
     * @return 商品供应表单数据
     */
     BizProductsForm getBizProductsFormData(Long id);

    /**
     * 新增商品供应
     *
     * @param formData 商品供应表单对象
     * @return 是否新增成功
     */
    boolean saveBizProducts(BizProductsForm formData);

    /**
     * 修改商品供应
     *
     * @param id   商品供应ID
     * @param formData 商品供应表单对象
     * @return 是否修改成功
     */
    boolean updateBizProducts(Long id, BizProductsForm formData);

    /**
     * 删除商品供应
     *
     * @param ids 商品供应ID，多个以英文逗号(,)分割
     * @return 是否删除成功
     */
    boolean deleteBizProducts(String ids);

}
