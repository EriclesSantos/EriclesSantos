package com.switchphone.layouts;

import android.content.Context;
import android.graphics.*;
import android.util.SparseArray;
import android.view.*;
import com.switchphone.controller.ControllerState;
import com.switchphone.settings.Preferences;
import com.switchphone.haptics.Haptics;
import java.util.Collections;
import java.util.List;
import com.switchphone.layouts.ControllerGeometry.Key;

/** Vector controls with independent pointer ownership and no render/update loop. */
public final class ControllerView extends View {
    public static final String[] NAMES={"Nintendo Switch","Xbox","PlayStation"};
    private final Paint paint=new Paint(Paint.ANTI_ALIAS_FLAG);
    private List<Key> keys=Collections.emptyList();
    private ControllerGeometry geometry;
    private final SparseArray<Touch> touches=new SparseArray<>();
    private final ControllerState state;
    private final Preferences prefs;
    private final Runnable changed;
    private final int layout;
    private final boolean preview;
    private boolean inputAvailable;
    private float lx,ly,rx,ry,radius,unit;
    private float leftX,leftY,rightX,rightY;
    private int held,hat=8;
    private int accent;
    private static final class Touch {
        int stick; float x,y;
        Touch(int stick,float x,float y) { this.stick=stick;this.x=x;this.y=y; }
    }
    public ControllerView(Context context,int layout,ControllerState state,Preferences prefs,Runnable changed,boolean preview) {
        super(context);this.layout=layout;this.state=state;this.prefs=prefs;this.changed=changed;this.preview=preview;this.inputAvailable=preview;
        accent=layout==1?Color.rgb(111,238,83):layout==2?Color.rgb(102,166,255):Color.rgb(54,222,241);
        setContentDescription(NAMES[layout]+" controle virtual multitoque");
        setFocusable(true);
        if (!preview) setKeepScreenOn(true);
    }
    public ControllerView(Context context) { this(context,0,new ControllerState(),new Preferences(context),()->{},true); }
    @Override protected void onSizeChanged(int w,int h,int oldw,int oldh) {
        if(!preview)release();
        if(w<=0||h<=0)return;
        geometry=new ControllerGeometry(w,h,layout);keys=geometry.keys;unit=geometry.unit;radius=geometry.radius;
        leftX=geometry.leftX;leftY=geometry.leftY;rightX=geometry.rightX;rightY=geometry.rightY;
    }
    private void text(Canvas c,String s,float x,float y,float size,int color) {
        paint.setColor(color);paint.setTextSize(size);paint.setTypeface(Typeface.create("sans-serif-medium",Typeface.NORMAL));
        paint.setTextAlign(Paint.Align.CENTER);c.drawText(s,x,y-(paint.ascent()+paint.descent())/2,paint);
    }
    @Override protected void onDraw(Canvas canvas) {
        canvas.drawColor(Color.rgb(13,20,29));
        paint.setColor(Color.rgb(20,31,43));canvas.drawRoundRect(8*unit,4*unit,getWidth()-8*unit,getHeight()-4*unit,40*unit,40*unit,paint);
        text(canvas,NAMES[layout].toUpperCase(java.util.Locale.ROOT),getWidth()/2f,28*unit,13*unit,accent);
        for (Key k:keys) {
            boolean down=k.id<14?(held&(1<<k.id))!=0:dpadDown(k.id);
            if (!inputAvailable) {
                paint.setColor(Color.rgb(8,12,17));
                if(k.round) canvas.drawCircle(k.x,k.y,k.w/2+2*unit,paint);
                else canvas.drawRoundRect(k.x-k.w/2-2*unit,k.y-k.h/2-2*unit,k.x+k.w/2+2*unit,k.y+k.h/2+2*unit,10*unit,10*unit,paint);
            }
            int led=keyColor(k.id,k.x);
            paint.setStyle(Paint.Style.STROKE);
            for(int glow=3;glow>=1;glow--){
                paint.setStrokeWidth((2+glow*3)*unit);paint.setColor(led);paint.setAlpha(inputAvailable?(down?32:18):7);shape(canvas,k);
            }
            paint.setAlpha(255);paint.setStyle(Paint.Style.FILL);
            paint.setColor(!inputAvailable?Color.rgb(30,35,43):down?Color.rgb(42,62,76):Color.rgb(23,35,49));
            canvas.save();if(!inputAvailable||down)canvas.translate(0,2*unit);
            shape(canvas,k);
            paint.setStyle(Paint.Style.STROKE);paint.setStrokeWidth((down?3:1.6f)*unit);paint.setColor(led);paint.setAlpha(inputAvailable?255:65);shape(canvas,k);
            paint.setAlpha(255);paint.setStyle(Paint.Style.FILL);
            text(canvas,k.label,k.x,k.y,(k.round?27:14)*unit,!inputAvailable?Color.rgb(118,127,139):k.id<4?led:Color.rgb(233,241,247));
            canvas.restore();
        }
        stick(canvas,leftX,leftY,lx,ly,"L");stick(canvas,rightX,rightY,rx,ry,"R");
        if(!inputAvailable)text(canvas,"CONTROLES INATIVOS • PAREIE O DISPOSITIVO",getWidth()/2f,getHeight()*.98f,10*unit,Color.rgb(137,145,155));
    }
    private void shape(Canvas canvas,Key k){
        if(k.round)canvas.drawCircle(k.x,k.y,k.w/2,paint);
        else canvas.drawRoundRect(k.x-k.w/2,k.y-k.h/2,k.x+k.w/2,k.y+k.h/2,11*unit,11*unit,paint);
    }
    private int keyColor(int id,float x){
        if(layout==0)return x<getWidth()/2f?Color.rgb(54,222,241):Color.rgb(255,88,111);
        if(layout==1)return accent;
        return switch(id){case 0->Color.rgb(100,174,255);case 1->Color.rgb(255,105,133);case 2->Color.rgb(242,137,223);case 3->Color.rgb(93,235,190);default->accent;};
    }
    private boolean dpadDown(int id) {
        return hat!=8 && (id==20&&(hat==7||hat==0||hat==1) || id==21&&(hat>=1&&hat<=3) || id==22&&(hat>=3&&hat<=5) || id==23&&(hat>=5&&hat<=7));
    }
    private void stick(Canvas c,float x,float y,float ax,float ay,String label) {
        paint.setColor(Color.rgb(12,20,29));c.drawCircle(x,y,radius,paint);
        int led=keyColor(14,x);
        paint.setStyle(Paint.Style.STROKE);
        for(int glow=3;glow>=1;glow--){paint.setStrokeWidth((2+glow*3)*unit);paint.setColor(led);paint.setAlpha(inputAvailable?18:7);c.drawCircle(x,y,radius,paint);}
        paint.setAlpha(inputAvailable?255:65);paint.setStrokeWidth(2*unit);paint.setColor(led);paint.setAlpha(inputAvailable?255:65);c.drawCircle(x,y,radius,paint);paint.setAlpha(255);paint.setStyle(Paint.Style.FILL);
        paint.setColor(!inputAvailable?Color.rgb(36,41,48):(ax!=0||ay!=0)?led:Color.rgb(50,70,90));c.drawCircle(x+ax*radius*.43f,y+ay*radius*.43f,radius*.56f,paint);
        text(c,label,x+ax*radius*.48f,y+ay*radius*.48f,15*unit,inputAvailable?Color.WHITE:Color.rgb(100,110,120));
    }
    private int stickAt(float x,float y) {
        if (Math.hypot(x-leftX,y-leftY)<radius*1.1f) return 1;
        if (Math.hypot(x-rightX,y-rightY)<radius*1.1f) return 2;
        return 0;
    }
    @Override public boolean onTouchEvent(MotionEvent event) {
        if (preview) return false;
        if (!inputAvailable) return true;
        getParent().requestDisallowInterceptTouchEvent(true);
        int action=event.getActionMasked(),index=event.getActionIndex();
        if (action==MotionEvent.ACTION_DOWN || action==MotionEvent.ACTION_POINTER_DOWN) {
            int stick=stickAt(event.getX(index),event.getY(index));
            for (int i=0;i<touches.size();i++) if (stick!=0 && touches.valueAt(i).stick==stick) stick=-1;
            touches.put(event.getPointerId(index),new Touch(stick,event.getX(index),event.getY(index)));
            Haptics.press(getContext(),prefs.vibration());
        }
        for (int i=0;i<event.getPointerCount();i++) {
            Touch t=touches.get(event.getPointerId(i)); if (t!=null) {t.x=event.getX(i);t.y=event.getY(i);}
        }
        if (action==MotionEvent.ACTION_UP || action==MotionEvent.ACTION_POINTER_UP) {
            touches.remove(event.getPointerId(index)); if (action==MotionEvent.ACTION_UP) performClick();
        }
        if (action==MotionEvent.ACTION_CANCEL) touches.clear();
        update();return true;
    }
    private void update() {
        held=0;lx=ly=rx=ry=0;boolean up=false,down=false,left=false,right=false;
        for (int i=0;i<touches.size();i++) {
            Touch t=touches.valueAt(i);
            if (t.stick>0) {
                float cx=t.stick==1?leftX:rightX,cy=t.stick==1?leftY:rightY;
                float x=(t.x-cx)/radius,y=(t.y-cy)/radius;
                float length=(float)Math.hypot(x,y); if(length>1) {x/=length;y/=length;}
                x=ControllerState.filterAxis(x,prefs.deadZone()/100f,prefs.sensitivity()/100f);
                y=ControllerState.filterAxis(y,prefs.deadZone()/100f,prefs.sensitivity()/100f);
                if (t.stick==1) {lx=x;ly=y;} else {rx=x;ry=y;}
            } else if (t.stick==0) {
                // D-pad diagonals are reachable within its square footprint.
                float dx=geometry.dpadX,dy=geometry.dpadY,d=geometry.dpadStep;
                if (Math.abs(t.x-dx)<=d*1.48f && Math.abs(t.y-dy)<=d*1.48f) {
                    up|=t.y<dy-d*.40f;down|=t.y>dy+d*.40f;
                    left|=t.x<dx-d*.40f;right|=t.x>dx+d*.40f;
                }
                for (Key k:keys) if (k.id<14 && k.contains(t.x,t.y)) held|=1<<k.id;
            }
        }
        int horizontal=(right?1:0)-(left?1:0),vertical=(down?1:0)-(up?1:0);
        hat=vertical<0?(horizontal<0?7:horizontal>0?1:0):vertical>0?(horizontal<0?5:horizontal>0?3:4):horizontal<0?6:horizontal>0?2:8;
        state.replace(held,hat,lx,ly,rx,ry);changed.run();invalidate();
    }
    public void setInputAvailable(boolean available) { if(inputAvailable==available)return;inputAvailable=available;if(!available)release();invalidate(); }
    public void release() { touches.clear();update(); }
    @Override public boolean performClick() { super.performClick();return true; }
    @Override protected void onDetachedFromWindow() { if (!preview) release();super.onDetachedFromWindow(); }
}
