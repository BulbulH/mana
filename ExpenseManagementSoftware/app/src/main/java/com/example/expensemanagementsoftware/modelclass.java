package com.example.expensemanagementsoftware;

public class modelclass {

    String date;
    String money;

    public modelclass(String date, String money) {
        this.date = date;
        this.money = money;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getDate() {
        return date;
    }

    public String getMoney() {
        return money;
    }
}
