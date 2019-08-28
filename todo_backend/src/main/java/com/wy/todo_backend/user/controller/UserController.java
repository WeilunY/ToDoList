package com.wy.todo_backend.user.controller;

import com.wy.todo_backend.user.entity.User;
import com.wy.todo_backend.user.entity.UserSafe;
import com.wy.todo_backend.user.service.UserService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Map;


@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    // create a new user
    @CrossOrigin(origins = "http://localhost:8081")
    @PostMapping("/createUser")
    public int createNewUser(@RequestBody Map<String, String> user){

        String username = user.get("username");
        String password = user.get("password");
        String email = user.get("email");

        return userService.createNewUser(username, password, email);

    }

    @CrossOrigin(origins = "http://localhost:8081")
    @PostMapping("/getUser")
    public UserSafe getUser(@RequestBody Map<String, Integer> user) {

        int id = user.get("id");

        return userService.getUser(id);
    }

    @CrossOrigin(origins = "http://localhost:8081")
    @PostMapping("/updateUser")
    public int updateUser(@RequestBody User user) {

        return userService.updateUser(user);

    }


}
