package com.example.expensemanagementsoftware.ui.SavingTargat;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class SavingTargatViewModel extends ViewModel {

    private MutableLiveData<String> mText;

    public SavingTargatViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("Saving Tergate");
    }

    public LiveData<String> getText() {
        return mText;
    }
}