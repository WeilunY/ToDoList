package com.wy.todo_backend.common;


import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Result implements Serializable {


    private static final long serialVersionUID = 1L;

    /**
     * 状态标志
     */
    private String status;

    /**
     * 状态信息
     */
    private String message;

    /**
     * 数据对象
     */
    private Object data;

    /**
     * 跳转地址
     */
    private String location;

    /**
     * 跳转返回封装
     */
    public static Result location(Object data, String location) {
        return new Result(Status.SUCCESS, null, data == null ? new Object() : data, location);
    }

    /**
     * 数据请求成功返回封装
     */
    public static Result success(Object data, String message) {
        return new Result(Status.SUCCESS, message, data == null ? new Object() : data);
    }

    public static Result success(Object data) {
        return success(data, null);
    }

    public static Result success(List list) {
        Map<String, Object> map = new HashMap<>();
        map.put("data", list);
        return success(map, null);
    }

    public static Result success(String message) {
        return success(null, message);
    }

    /**
     * 登出成功返回封装
     */
    public static Result logout(String message) {
        return success(message);
    }

    public static Result success() {
        return success(null, null);
    }

    /**
     * 错误信息返回封装
     */
    public static Result error(String message) {
        return new Result(Status.ERROR, message, new Object());
    }

    /**
     * 需要登录返回封装
     */
    public static Result login(String message) {
        return new Result(Status.LOGIN, message, new Object());
    }

    public static Result login() {
        return login(null);
    }

    public Result() {
        super();
    }

    public Result(String status) {
        this.status = status;
    }

    public Result(String status, Object data) {
        this.status = status;
        this.data = data;
    }

    public Result(String status, String message) {
        this.status = status;
        this.message = message;
    }

    public Result(String status, String message, Object data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }

    public Result(String status, String message, Object data, String location) {
        super();
        this.status = status;
        this.message = message;
        this.data = data;
        this.location = location;
    }

    public static Result error() {
        return error(null);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }


    public class Status {

        /**
         * 成功
         */
        public static final String SUCCESS = "success";

        /**
         * 失败
         */
        public static final String ERROR = "error";

        /**
         * 跳转
         */
        public static final String LOCATION = "location";

        /**
         * 登录
         */
        public static final String LOGIN = "login";

        /**
         * token过期
         */
        public static final String TOKEN_EXPIRE = "token_expire";

        /**
         * 过期
         */
        public static final String LOGIN_EXPIRE = "login_expire";

    }

}

