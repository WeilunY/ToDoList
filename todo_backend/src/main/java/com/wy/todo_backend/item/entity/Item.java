package com.wy.todo_backend.item.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Item {
    private int id;
    private String content;
    private int type;
    private Date create_time;
    private Date finished_time;
}
