package com.youlai.boot.devenv.mapper;

import com.youlai.boot.devenv.entity.ShopUser;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 */
/*接口的名称通常以表名+Mapper命名*/

@Mapper
public interface ShopUserMapper extends BaseMapper<ShopUser> {

    //  查询用户，根据用户id查询信息
    @Select("select * from t_user where id = #{id}")
    ShopUser selectById(String id);

    //  查询用户及其所有的订单
    @Select("select * from t_user")
    /*如果用了@Results这个注解，所有的字段都要自己手动完成字段到类属性名的映射，即使名称一致*/
    @Results(
            {
                    @Result(column = "id",property = "id"),
                    @Result(column = "username",property = "username"),
                    @Result(column = "password",property = "password"),
                    @Result(column = "birthday",property = "birthday"),
                    @Result(column = "id",property = "orders",javaType = List.class,
                            many = @Many(select = "cn.edu.gzist.cs.demo.devenv.mapper.OrderMapper.selectByUid"))
            }
    )
    List<ShopUser> selectAllUserAndOrders();

    /*↓这些语句也可以都不写，只需要继承一个BaseMapper<实体类>↑，告知其需要操作哪个实体，MybatisPlus会自动根据该实体类找到对应的表，写好增删改查，但前提是类名要与表名保持一致*/
    //  查询所有用户
    @Select("Select * from t_user")
    public List<ShopUser> find();

    /*
     * 可以单独指定要插入的字段，例：
     * @Insert("insert into user (id,username) values(#{id},#{username})")
     * 也可以不指定字段，把后面的值一一传入，但是如果values前面没有指定字段的话，后面就必须把所有字段写全
     * #{}内的名称必须与实体类里面的属性一致，这样就会把外面传入的参数写进对应的属性值中*/

    @Insert("insert into t_user values(#{id},#{username},#{password},#{birthday})")
    public int insertUser(ShopUser user);
}