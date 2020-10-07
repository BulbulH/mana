package com.example.expensemanagementsoftware;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;



public class DatabaseHelper extends SQLiteOpenHelper {

    private static final String DBNAME="UserDatabase.db";
    private static final String TABILENAME="UserTabile";
    private static final String ID="id";
    private static final String DATE="date";
    private static final String MONEY="expanse";


    public DatabaseHelper(@Nullable Context context) {
        super(context, DBNAME, null, 1);
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL("CREATE TABLE "+TABILENAME+" ("+ID+" INTEGER PRIMARY KEY AUTOINCREMENT ," +
                ""+DATE+" TEXT NOT NULL,"+MONEY+" VARCHAR NOT NULL)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {

    }
    public long insertData(String date, String money){
        SQLiteDatabase sqLiteDatabase= this.getWritableDatabase();
        ContentValues contentValues=new ContentValues();
        contentValues.put(DATE,date);
        contentValues.put(MONEY,money);
       return sqLiteDatabase.insert(TABILENAME, null, contentValues);
    }

    public Cursor getAllData(String StartDate, String EndDate){
        SQLiteDatabase sqLiteDatabase= this.getWritableDatabase();
        return sqLiteDatabase.rawQuery("SELECT * " +
                "FROM " +TABILENAME+
                " WHERE date("+DATE+") BETWEEN date('"+StartDate+"') AND date('"+EndDate+"')", null);
    }

}
