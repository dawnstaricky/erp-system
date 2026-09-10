package com.example.erpsystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
@MapperScan("com.example.erpsystem.mapper")
public class ErpSystemApplication {

    public static void main(String[] args) {

        SpringApplication.run(ErpSystemApplication.class, args);
        //ConfigurableApplicationContext context = SpringApplication.run(ErpSystemApplication.class, args);
        //UserService userService = context.getBean(UserService.class);
        //userService.printEncodedPassword();
    }

}
