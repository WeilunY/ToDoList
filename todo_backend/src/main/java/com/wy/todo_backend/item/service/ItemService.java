package com.wy.todo_backend.item.service;

import com.wy.todo_backend.item.dao.ItemMapper;
import com.wy.todo_backend.item.entity.Item;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class ItemService {

    @Resource
    ItemMapper itemMapper;

    /**
     * Create a new Item
     * @param user_id
     * @param content
     * @param type
     * @return
     */
    public int createNewItem(int user_id, String content, int type){

        Date createTime = new Date();

        Item new_item = new Item();

        new_item.setContent(content);
        new_item.setType(type);
        new_item.setCreate_time(createTime);

        itemMapper.createNewItem(new_item);

        int item_id =  new_item.getId();

        return itemMapper.createNewRelation(user_id, item_id);
    }

    /**
     * Get Item with user_id and status
     * @param user_id
     * @param status
     * @return
     */
    public List<Item> getItems(int user_id, int status){

        if(status == 2){
            // for all history
            return itemMapper.getAll(user_id);
        }

        else {
            return itemMapper.getItems(user_id, status);
        }
    }

    public int markComplete(int item_id){
        int status1 = itemMapper.markComplete(item_id);

        Date finishTime = new Date();
        int status2 = itemMapper.setFinished(finishTime, item_id);

        return status1 + status2;
    }
}
