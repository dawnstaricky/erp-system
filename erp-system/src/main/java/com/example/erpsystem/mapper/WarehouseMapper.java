package com.example.erpsystem.mapper;

import com.example.erpsystem.entity.Warehouse;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface WarehouseMapper {
    @Select("SELECT * FROM warehouse WHERE warehouse_code = #{code} AND status = 1")
    Warehouse selectByCode(String code);
//
//    List<Warehouse> getList(String keyword);
//    int insert(Warehouse warehouse);
//    int update(Warehouse warehouse);
//    Warehouse selectById(Long id);
//    int deleteById(Long id);
    /**
     * 分页查询仓库列表
     */
    List<Warehouse> selectList(@Param("keyword") String keyword,
                               @Param("offset") int offset,
                               @Param("pageSize") int pageSize);

    /**
     * 查询仓库总数
     */
    int count(@Param("keyword") String keyword);

    /**
     * 根据ID查询仓库
     */
    Warehouse selectById(@Param("id") Long id);

    /**
     * 新增仓库
     */
    int insert(Warehouse warehouse);

    /**
     * 更新仓库（含停用）
     */
    int updateById(Warehouse warehouse);

    /** 新增：按前缀查最大编码，用于自动生成流水号 */
    String selectMaxCodeByPrefix(@Param("pattern") String pattern);
}