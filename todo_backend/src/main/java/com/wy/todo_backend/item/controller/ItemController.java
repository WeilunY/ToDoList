package com.wy.todo_backend.item.controller;

import com.wy.todo_backend.item.entity.Item;
import com.wy.todo_backend.item.service.ItemService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/item")

public class ItemController {

    @Resource
    ItemService itemService;

    /**
     * Create new item
     * @param item
     * @return
     */
    @PostMapping("/create")
    public int createNewItem(@RequestBody Map<String, Object> item){

        int user_id = (int) item.get("user_id");
        String content = (String) item.get("content");
        int type = (int) item.get("type");

      return itemService.createNewItem(user_id, content, type);


    }


    /**
     * Get list of item
     * @param detail
     * @return
     */
    @PostMapping("/get")
    public List<Item> getItems(@RequestBody Map<String, Integer> detail){

        int user_id = detail.get("user_id");
        int status = detail.get("status");

        return itemService.getItems(user_id, status);

    }


    /**
     * Mark a task as complete
     * @param detail
     * @return
     */
    @PostMapping("/finish")
    public int markComplete(@RequestBody Map<String, Integer> detail) {

        int item_id = detail.get("item_id");

        return itemService.markComplete(item_id);
    }

}
