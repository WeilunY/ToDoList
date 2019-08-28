package com.wy.todo_backend.user.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserLoginMapper {

    int verifyUser(@Param("email") String email, @Param("password") String password);

    int getID(@Param("email") String email, @Param("password") String password);
}
