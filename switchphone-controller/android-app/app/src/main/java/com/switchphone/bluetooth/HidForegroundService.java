package com.switchphone.bluetooth;

import android.app.*;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.os.*;
import com.switchphone.MainActivity;
import com.switchphone.R;

/** Keeps the process foreground only for the bounded pairing/active-control session. No scanning. */
public final class HidForegroundService extends Service {
    public interface Listener { void stop(String reason,boolean error); }
    public final class LocalBinder extends Binder { public HidForegroundService service(){return HidForegroundService.this;} }
    private static final int NOTIFICATION=41;
    private static final String CHANNEL="bluetooth_controller",STOP="com.switchphone.STOP_HID";
    private final Handler main=new Handler(Looper.getMainLooper());
    private final LocalBinder binder=new LocalBinder();
    private Listener listener;
    private String startupError;
    private final Runnable deadline=()->end("Prazo de pareamento encerrado sem conexão do host.",true);
    @Override public void onCreate(){
        super.onCreate();
        try{
            NotificationManager manager=getSystemService(NotificationManager.class);
            manager.createNotificationChannel(new NotificationChannel(CHANNEL,"Conexão do controle",NotificationManager.IMPORTANCE_LOW));
            Notification notification=notification("Pareamento Bluetooth em andamento; aguardando o host.");
            if(Build.VERSION.SDK_INT>=29)startForeground(NOTIFICATION,notification,ServiceInfo.FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE);
            else startForeground(NOTIFICATION,notification);
            main.postDelayed(deadline,120000);
        }catch(RuntimeException e){startupError="Não foi possível manter a sessão Bluetooth: "+e.getClass().getSimpleName();stopSelf();}
    }
    private Notification notification(String text){
        PendingIntent open=PendingIntent.getActivity(this,0,new Intent(this,MainActivity.class).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),PendingIntent.FLAG_IMMUTABLE|PendingIntent.FLAG_UPDATE_CURRENT);
        PendingIntent cancel=PendingIntent.getService(this,1,new Intent(this,HidForegroundService.class).setAction(STOP),PendingIntent.FLAG_IMMUTABLE|PendingIntent.FLAG_UPDATE_CURRENT);
        return new Notification.Builder(this,CHANNEL).setSmallIcon(R.drawable.ic_status_controller).setContentTitle("Nördhub ProController • Bluetooth")
            .setContentText(text).setContentIntent(open).setOngoing(true).setOnlyAlertOnce(true)
            .addAction(new Notification.Action.Builder(null,"Encerrar",cancel).build()).build();
    }
    @Override public IBinder onBind(Intent intent){return binder;}
    @Override public int onStartCommand(Intent intent,int flags,int startId){if(intent!=null&&STOP.equals(intent.getAction()))end("Sessão encerrada pela notificação.",false);return START_NOT_STICKY;}
    public String startupError(){return startupError;}
    public void listen(Listener listener){this.listener=listener;}
    public void deadline(long remaining){main.removeCallbacks(deadline);main.postDelayed(deadline,Math.max(1,remaining));}
    public void connectionStarted(){main.removeCallbacks(deadline);}
    public void connected(){connectionStarted();startForeground(NOTIFICATION,notification("Controle conectado. Encerrar libera os botões."));}
    private void end(String reason,boolean error){Listener current=listener;if(current!=null)current.stop(reason,error);stopSelf();}
    @Override public void onTaskRemoved(Intent rootIntent){end("Sessão encerrada ao fechar o aplicativo.",false);super.onTaskRemoved(rootIntent);}
    @Override public void onDestroy(){main.removeCallbacksAndMessages(null);Listener current=listener;listener=null;if(current!=null)current.stop("Serviço Bluetooth encerrado pelo Android.",true);stopForeground(STOP_FOREGROUND_REMOVE);super.onDestroy();}
}
