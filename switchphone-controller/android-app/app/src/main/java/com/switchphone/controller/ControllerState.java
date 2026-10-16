package com.switchphone.controller;

/** Shared logical controls. Positional face buttons are mapped by the visible layout. */
public final class ControllerState {
    public static final int SOUTH=0, EAST=1, WEST=2, NORTH=3, L=4, R=5, ZL=6, ZR=7,
        MINUS=8, PLUS=9, HOME=10, CAPTURE=11, L3=12, R3=13;
    private int buttons, hat=8;
    private final byte[] axes = new byte[4];
    public synchronized void set(int index, boolean down) {
        if (index < 0 || index > 13) throw new IllegalArgumentException("Button index");
        if (down) buttons |= 1 << index; else buttons &= ~(1 << index);
    }
    public synchronized void replace(int buttons, int hat, float lx, float ly, float rx, float ry) {
        if ((buttons & ~0x3fff) != 0 || hat < 0 || hat > 8) throw new IllegalArgumentException("State");
        this.buttons=buttons; this.hat=hat;
        axes[0]=axis(lx); axes[1]=axis(ly); axes[2]=axis(rx); axes[3]=axis(ry);
    }
    private static byte axis(float value) {
        if (!Float.isFinite(value)) return 0;
        return (byte)Math.round(Math.max(-1, Math.min(1,value))*127);
    }
    public synchronized void clear() { buttons=0; hat=8; java.util.Arrays.fill(axes,(byte)0); }
    /** Generic diagnostic HID only: buttons LE16, four signed axes, hat 0..7 or neutral 8. */
    public synchronized byte[] report() {
        return new byte[] {(byte)buttons,(byte)(buttons>>8),axes[0],axes[1],axes[2],axes[3],(byte)hat};
    }
    public static float filterAxis(float value, float deadZone, float sensitivity) {
        float magnitude=Math.min(1,Math.abs(value));
        if (magnitude<=deadZone) return 0;
        return Math.copySign(Math.min(1,(magnitude-deadZone)/(1-deadZone)*sensitivity),value);
    }
}
