package com.wy.todo_backend.item.dao;

import com.wy.todo_backend.item.entity.Item;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

@Mapper
public interface ItemMapper {

    int createNewItem(Item item);

    int createNewRelation(@Param("user_id") int user_id, @Param("item_id") int item_id);

    List<Item> getAll(int user_id);

    List<Item> getItems(@Param("user_id") int user_id, @Param("status") int status);

    int markComplete(int item_id);

    int setFinished(@Param("finished_time") Date finished_time, @Param("item_id") int item_id);
}
