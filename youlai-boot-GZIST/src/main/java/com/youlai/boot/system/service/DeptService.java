package com.youlai.boot.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.youlai.boot.system.model.entity.Dept;
import com.youlai.boot.common.model.Option;
import com.youlai.boot.system.model.form.DeptForm;
import com.youlai.boot.system.model.query.DeptQuery;
import com.youlai.boot.system.model.vo.DeptVO;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 部门业务接口
 *
 * @author haoxr
 * @since 2021/8/22
 */
public interface DeptService extends IService<Dept> {
    /**
     * 部门列表
     *
     * @return 部门列表
     */
    List<DeptVO> getDeptList(DeptQuery queryParams);

    /**
     * 部门树形下拉选项
     *
     * @return 部门树形下拉选项
     */
    List<Option<Long>> listDeptOptions();

    /**
     * 新增部门
     *
     * @param formData 部门表单(包含站点地址、类型、销售提成比等信息)
     * @return 部门ID
     */
    Long saveDept(DeptForm formData);

    /**
     * 修改部门
     *
     * @param deptId  部门ID
     * @param formData 部门表单(包含站点地址、类型、销售提成比等信息)
     * @return 部门ID
     */
    Long updateDept(Long deptId, DeptForm formData);

    /**
     * 删除部门
     *
     * @param ids 部门ID，多个以英文逗号,拼接字符串
     * @return 是否成功
     */
    @Transactional
    boolean deleteByIds(String ids);

    /**
     * 获取部门详情
     *
     * @param deptId 部门ID
     * @return 部门详情
     */
    DeptForm getDeptForm(Long deptId);

    /**
     * 根据站点类型查询部门列表
     *
     * @param type 站点类型(水厂、水站、水点)
     * @return 部门列表
     */
    List<DeptVO> getDeptListByType(String type);
    
    /**
     * 批量更新销售提成比例
     *
     * @param deptIds 部门ID列表
     * @param commissionRate 销售提成比例
     * @return 是否成功
     */
    boolean batchUpdateCommissionRate(List<Long> deptIds, BigDecimal commissionRate);
// 示例：Service 层的事务管理


}
