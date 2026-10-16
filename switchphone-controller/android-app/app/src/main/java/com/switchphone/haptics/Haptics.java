package com.switchphone.haptics;

import android.content.Context;
import android.os.VibrationEffect;
import android.os.Vibrator;

/** Local touch feedback only, never game-controlled rumble. */
public final class Haptics {
    private Haptics() {}
    public static void press(Context context, int intensity) {
        if (intensity<=0) return;
        Vibrator vibrator=(Vibrator)context.getSystemService(Context.VIBRATOR_SERVICE);
        if (vibrator!=null && vibrator.hasVibrator()) {
            vibrator.vibrate(VibrationEffect.createOneShot(12,Math.max(1,Math.min(255,intensity*255/100))));
        }
    }
}
