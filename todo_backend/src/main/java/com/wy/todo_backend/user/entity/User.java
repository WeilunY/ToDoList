package com.wy.todo_backend.user.entity;

import lombok.Data;

@Data
public class User {

    private int id;

    private String username;

    private String password;

    private String email;

}
