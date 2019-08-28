package com.wy.todo_backend.user.controller;

import com.wy.todo_backend.user.service.UserLoginService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.Map;

@RestController
@RequestMapping("/login")
public class UserLoginController {

    @Resource
    UserLoginService userLoginService;

    // verify info and return user_id
    @CrossOrigin(origins = "http://localhost:8081")
    @PostMapping("/verify")
    public int verifyLogin(@RequestBody @NotNull Map<String, String> user) {

        String email= user.get("email");
        String password = user.get("password");

        return userLoginService.verifyUser(email, password);

    }
}
