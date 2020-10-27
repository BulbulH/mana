package com.example.expensemanagementsoftware.ui.SavingTargat;

import android.content.SharedPreferences;
import android.database.Cursor;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProviders;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.expensemanagementsoftware.DatabaseHelper;
import com.example.expensemanagementsoftware.DatePickerHelper;
import com.example.expensemanagementsoftware.R;
import com.example.expensemanagementsoftware.RecyllerViewAdaptar;
import com.example.expensemanagementsoftware.modelclass;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import static android.content.Context.MODE_PRIVATE;

public class SavingTargat extends Fragment {

    private SavingTargatViewModel savingtarget;
    SharedPreferences pref;
    SharedPreferences.Editor editor;

    EditText targetAmount;
    Button setTargateButtonID;
    TextView targetAmountDetails;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        pref = getContext().getSharedPreferences("MyPref", MODE_PRIVATE);
        editor = pref.edit();
        savingtarget =
                ViewModelProviders.of(this).get(SavingTargatViewModel.class);
        final View root = inflater.inflate(R.layout.fragment_saving_target, container, false);

        targetAmount= root.findViewById(R.id.targetAmount);
        setTargateButtonID=root.findViewById(R.id.setTargateButtonID);
        targetAmountDetails=root.findViewById(R.id.targetAmountDetails);


        targetAmountDetails.setText(pref.getString("SavingTarget", ""));

        setTargateButtonID.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v)
            {
                editor.putString("SavingTarget",targetAmount.getText().toString());
                editor.apply();
                targetAmountDetails.setText(pref.getString("SavingTarget", ""));
            }
        });



        return root;

    }


}