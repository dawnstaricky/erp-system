package com.example.erpsystem.service;

import com.example.erpsystem.entity.SysUserCompanyRole;
import com.example.erpsystem.entity.User;
import com.example.erpsystem.mapper.UserMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    /* ========== 已有方法（保留不动） ========== */

    public User getUserByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    public User login(String username, String password) {
        User user = userMapper.findByUsername(username);
        if (user != null && user.getStatus() != null && user.getStatus() == 1
                && passwordEncoder.matches(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    /* ========== 新增方法 ========== */

    @Transactional
    public void addUser(User user) {
        if (userMapper.findByUsername(user.getUsername()) != null) {
            throw new RuntimeException("用户名已存在");
        }
        user.setPassword(passwordEncoder.encode("123456")); // 默认密码
        if (user.getStatus() == null) user.setStatus(1);
        userMapper.insert(user);
    }

    @Transactional
    public void updateUserInfo(User user) {
        if (user.getId() == null) throw new RuntimeException("用户ID不能为空");
        userMapper.updateById(user);
    }

    @Transactional
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userMapper.selectById(userId);
        if (user == null) throw new RuntimeException("用户不存在");
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("旧密码错误");
        }
        userMapper.updatePassword(userId, passwordEncoder.encode(newPassword));
    }

    @Transactional
    public void updateSelfProfile(User user) {
        User exist = userMapper.selectById(user.getId());
        if (exist == null) throw new RuntimeException("用户不存在");
        // 普通用户只能改这3项，realName/deptId/role 由管理员维护
        exist.setPhone(user.getPhone());
        exist.setEmail(user.getEmail());
        exist.setAvatar(user.getAvatar());
        userMapper.updateById(exist);
    }

    public List<User> getList(String keyword, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return userMapper.selectList(keyword, offset, pageSize);
    }

    public int getCount(String keyword) {
        return userMapper.count(keyword);
    }

    /** 给 Controller 用：按用户名取用户（不返回密码） */
    public User getSafeUserByUsername(String username) {
        User u = userMapper.findByUsername(username);
        if (u != null) u.setPassword(null);
        return u;
    }

    /** 给 Controller 用：按ID取用户（不返回密码） */
    public User getSafeUserById(Long id) {
        User u = userMapper.selectById(id);
        if (u != null) u.setPassword(null);
        return u;
    }

    @Transactional
    public void assignRoles(Long userId, Long companyId, List<Long> roleIds) {
        // 1. 先删掉该用户所有的旧角色
        //userMapper.deleteUserRoles(userId);
        userMapper.deleteUserCompanyRoles(userId, companyId);

        // 2. 如果传了新角色，则插入
        if (roleIds != null && !roleIds.isEmpty()) {
            userMapper.insertUserCompanyRoles(userId, companyId, roleIds);
        }
    }

    public List<String> selectRoleCodesByUserId(Long userId){
        return userMapper.selectRoleCodesByUserId(userId);
    }

    public List<Long> selectRoleIdsByUserId(Long userId){
        return userMapper.selectRoleIdsByUserId(userId);
    }

    public void updateDeptId(Long userId, Long deptId) {
        userMapper.updateDeptId(userId, deptId);
    }

    public List<SysUserCompanyRole> selectCompaniesByUserId(Long userId) {
        return userMapper.selectCompaniesByUserId(userId);
    }
}