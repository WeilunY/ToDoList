package com.wy.todo_backend.user.dao;

import com.wy.todo_backend.user.entity.User;
import com.wy.todo_backend.user.entity.UserSafe;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {

    int checkExist(String email);

    int checkExistId(int id);

    int createNewUser(@Param("username") String username, @Param("password") String password, @Param("email") String email);

    UserSafe getUser(int id);

    int updateUser(User user);
}
