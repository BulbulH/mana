package com.example.expensemanagementsoftware;

import android.app.DatePickerDialog;
import android.content.Context;
import android.view.View;
import android.widget.DatePicker;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class DatePickerHelper {

    private final Calendar calendar = Calendar.getInstance();
    private final String dateFormat = "yyyy-MM-dd";
    private TextView textView = null;

    public DatePickerHelper(final Context context, TextView textView) {
        this.textView = textView;

        // Setup on click listener if the TextView is not null
        if (textView != null) {
            textView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    getDatePickerDialog(context).show();
                }
            });
        }
    }

    /**
     * Return a new date picker listener tied to the specified TextView field
     * @return
     */
    private DatePickerDialog.OnDateSetListener getOnDateSetListener() {
        return new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear,
                                  int dayOfMonth) {
                calendar.set(Calendar.YEAR, year);
                calendar.set(Calendar.MONTH, monthOfYear);
                calendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);

                SimpleDateFormat sdf = new SimpleDateFormat(dateFormat, Locale.US);
                textView.setText(sdf.format(calendar.getTime()));
            }
        };
    }

    /**
     * Return new DatePickerDialog for field
     * @param context
     * @return
     */
    private DatePickerDialog getDatePickerDialog(Context context) {
        return new DatePickerDialog(context, getOnDateSetListener(), calendar
                .get(Calendar.YEAR), calendar.get(Calendar.MONTH),
                calendar.get(Calendar.DAY_OF_MONTH));
    }

}