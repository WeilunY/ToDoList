package com.wy.todo_backend.user.service;

import com.wy.todo_backend.user.dao.UserMapper;
import com.wy.todo_backend.user.entity.User;
import com.wy.todo_backend.user.entity.UserSafe;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;


@Service
public class UserService {

    @Resource
    private UserMapper userMapper;

    public int createNewUser(String username, String password, String email){

        // check exist
        if (userMapper.checkExist(email) > 0){
            return 0;
        } else {
            // return 1 if success
            return userMapper.createNewUser(username, password, email);
        }
    }

    public UserSafe getUser(int id){
        return userMapper.getUser(id);
    }

    public int updateUser(User user) {
        if(userMapper.checkExistId(user.getId()) == 0){
            return -1;
        }
        return userMapper.updateUser(user);
    }
}
