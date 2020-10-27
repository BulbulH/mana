package com.example.expensemanagementsoftware;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class RecyllerViewAdaptar extends RecyclerView.Adapter<RecyllerViewAdaptar.ViewHolder> {

    private List<modelclass> mData;
    private LayoutInflater mInflater;
    private ItemClickListener mClickListener;

    // data is passed into the constructor
    public RecyllerViewAdaptar(Context context, List<modelclass> data) {
        this.mInflater = LayoutInflater.from(context);
        this.mData = data;
    }

    // inflates the row layout from xml when needed
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.view_item, parent, false);
        return new ViewHolder(view);
    }

    // binds the data to the TextView in each row
    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        /*String animal = mData.get(position);
        holder.myTextView.setText(animal);*/
        holder.date.setText(mData.get(position).date);
        holder.money.setText(mData.get(position).money);
        holder.incomeType.setText(mData.get(position).type);

    }

    // total number of rows
    @Override
    public int getItemCount() {
        return mData.size();
    }


    // stores and recycles views as they are scrolled off screen
    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView date, money, incomeType;

        ViewHolder(View itemView) {
            super(itemView);
            date = itemView.findViewById(R.id.dateID);
            money = itemView.findViewById(R.id.costID);
            incomeType = itemView.findViewById(R.id.incomeType);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            if (mClickListener != null) mClickListener.onItemClick(view, getAdapterPosition());
        }
    }

    // convenience method for getting data at click position
    public modelclass getItem(int id) {
        return mData.get(id);
    }

    // allows clicks events to be caught
    public void setClickListener(ItemClickListener itemClickListener) {
        this.mClickListener = itemClickListener;
    }

    // parent activity will implement this method to respond to click events
    public interface ItemClickListener {
        void onItemClick(View view, int position);
    }
}