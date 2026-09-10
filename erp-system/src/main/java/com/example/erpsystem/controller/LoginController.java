package com.example.erpsystem.controller;

import com.example.erpsystem.common.Result;
import com.example.erpsystem.entity.LoginDTO;
import com.example.erpsystem.entity.User;
import com.example.erpsystem.service.UserService;
import com.example.erpsystem.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class LoginController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody LoginDTO loginDTO) {
        User user = userService.login(loginDTO.getUsername(), loginDTO.getPassword());
        if (user != null) {
            List<String> roles = userService.selectRoleCodesByUserId(user.getId());
            // 生成Token
            String token = jwtUtil.generateToken(
                    user.getUsername(),
                    user.getId(),
                    user.getRealName(),
                    roles
            );

            // 返回给前端的数据
            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("tokenHead", "Bearer ");  // 前端请求时要拼在Token前面的前缀
            data.put("userId", user.getId());
            data.put("username", user.getUsername());
            data.put("realName", user.getRealName());
            data.put("roles", roles); // 前端存到userInfo.roles数组
            data.put("role", roles.get(0)); // 兼容原有单角色逻辑，取第一个

            return Result.success(data);
        } else {
            return Result.error(401, "用户名或密码错误");
        }
    }

    @GetMapping("/login")
    public Result<Map<String, Object>> login(@RequestParam String username,
                                             @RequestParam String password) {
        User user = userService.login(username, password);
        if (user != null) {
            List<String> roles = userService.selectRoleCodesByUserId(user.getId());
            // 生成Token
            String token = jwtUtil.generateToken(
                    user.getUsername(),
                    user.getId(),
                    user.getRealName(),
                    roles
            );

            // 返回给前端的数据
            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("tokenHead", "Bearer ");  // 前端请求时要拼在Token前面的前缀
            data.put("userId", user.getId());
            data.put("username", user.getUsername());
            data.put("realName", user.getRealName());
            data.put("roles", roles); // 前端存到userInfo.roles数组
            data.put("role", roles.get(0)); // 兼容原有单角色逻辑，取第一个

            return Result.success(data);
        } else {
            return Result.error(401, "用户名或密码错误");
        }
    }

    // 获取当前用户信息（供前端调用）
    @GetMapping("/info")
    public Result<Map<String, Object>> info(HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        List<String> roles = (List<String>) request.getAttribute("roles");

        Map<String, Object> data = new HashMap<>();
        data.put("username", username);
        data.put("roles", roles);
        // 可以根据需要补充更多信息
        return Result.success(data);
    }

    @GetMapping("/test")
    public Result<String> test(HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        return Result.success("你好，" + username + "！Token验证通过。");
    }
}