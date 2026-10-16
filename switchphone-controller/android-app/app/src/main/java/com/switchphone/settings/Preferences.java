package com.switchphone.settings;

import android.content.Context;
import android.content.SharedPreferences;

public final class Preferences {
    private final SharedPreferences store;
    public Preferences(Context context) { store=context.getSharedPreferences("controller",Context.MODE_PRIVATE); }
    public boolean nintendo() { return store.getInt("protocol",1)==1; }
    public int switchTest() { int value=store.getInt("switchTest",0);return value>=0&&value<=4?value:0; }
    public int layout() { return store.getInt("layout",0); }
    public int deadZone() { return store.getInt("deadZone",12); }
    public int sensitivity() { return store.getInt("sensitivity",100); }
    public int vibration() { return store.getInt("vibration",35); }
    public void put(String key, int value) { store.edit().putInt(key,value).apply(); }
}
