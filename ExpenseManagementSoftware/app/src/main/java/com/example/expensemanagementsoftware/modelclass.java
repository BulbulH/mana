package com.example.expensemanagementsoftware;

public class modelclass {

    String date;
    String money;
    String type;

    public modelclass(String date, String money,String type) {
        this.date = date;
        this.money = money;
        this.type = type;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
