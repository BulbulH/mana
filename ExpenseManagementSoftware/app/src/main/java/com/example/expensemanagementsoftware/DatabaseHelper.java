package com.example.expensemanagementsoftware;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import androidx.annotation.Nullable;



public class DatabaseHelper extends SQLiteOpenHelper {

    private static final String DBNAME="UserDatabase.db";
    private static final String TABILENAME="UserTabile";
    private static final String ID="id";
    private static final String DATE="date";
    private static final String MONEY="expanse";
    private static final String TYPE="type";


    public DatabaseHelper(@Nullable Context context) {
        super(context, DBNAME, null, 1);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL("CREATE TABLE "+TABILENAME+" ("+ID+" INTEGER PRIMARY KEY AUTOINCREMENT ," +
                ""+DATE+" TEXT NOT NULL,"+MONEY+" VARCHAR NOT NULL ,"+TYPE+" VARCHAR NOT NULL)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {

    }
    public long insertData(String date, String money, String type){
        SQLiteDatabase sqLiteDatabase= this.getWritableDatabase();
        ContentValues contentValues=new ContentValues();
        contentValues.put(DATE,date);
        contentValues.put(MONEY,money);
        contentValues.put(TYPE,type);
       return sqLiteDatabase.insert(TABILENAME, null, contentValues);
    }

    public Cursor getDataByDate(String StartDate, String EndDate){
        SQLiteDatabase sqLiteDatabase= this.getWritableDatabase();
        return sqLiteDatabase.rawQuery("SELECT * " +
                "FROM " +TABILENAME+
                " WHERE date("+DATE+") BETWEEN date('"+StartDate+"') AND date('"+EndDate+"') Order By "+DATE+" DESC", null);
    }

    public Cursor GetAllData(){
        SQLiteDatabase sqLiteDatabase= this.getWritableDatabase();
        return sqLiteDatabase.rawQuery("SELECT * FROM  "+TABILENAME+" Order By "+DATE+" DESC", null );
    }

}
