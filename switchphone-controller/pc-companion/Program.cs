using System;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;
using System.IO;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Collections.Generic;

namespace Nordhub.ProController {
 public sealed class MainForm:Form {
  readonly ComboBox devices=new ComboBox();readonly Label status=new Label(),activity=new Label();readonly Button start=new Button(),stop=new Button();
  readonly System.Windows.Forms.Timer timer=new System.Windows.Forms.Timer(),retry=new System.Windows.Forms.Timer();Bridge bridge;WifiReceiver wifi;
  readonly Button startWifi=new Button();readonly Label pairing=new Label(),addresses=new Label();readonly CheckBox mouse=new CheckBox(),motion=new CheckBox();long ticks;
  readonly NotifyIcon tray=new NotifyIcon();bool exiting,autoConnect=true;long changes;XboxReport previous;
  public MainForm(bool startInTray){
   Text="Nördhub ProController • PC";ClientSize=new Size(620,570);MinimumSize=new Size(636,609);StartPosition=FormStartPosition.CenterScreen;
   BackColor=Color.FromArgb(9,10,18);ForeColor=Color.FromArgb(238,232,255);Font=new Font("Segoe UI",10);
   try{Icon=Icon.ExtractAssociatedIcon(Application.ExecutablePath);}catch{}
   Label title=new Label{Text="Nördhub ProController",Font=new Font("Segoe UI",21,FontStyle.Bold),ForeColor=Color.FromArgb(168,140,255),Location=new Point(22,20),Size=new Size(570,42)};Controls.Add(title);
   Label intro=new Label{Text="Escolha Bluetooth ou Wi-Fi local → Xbox para jogos Steam e fora da Steam",Location=new Point(24,70),Size=new Size(570,45)};Controls.Add(intro);
   devices.DropDownStyle=ComboBoxStyle.DropDownList;devices.Location=new Point(24,120);devices.Size=new Size(430,30);Controls.Add(devices);
   Button scan=new Button{Text="Atualizar lista",Location=new Point(466,118),Size=new Size(130,32)};scan.Click+=(s,e)=>RefreshDevices();Controls.Add(scan);
   start.Text="Iniciar Bluetooth";start.Location=new Point(24,169);start.Size=new Size(245,42);start.BackColor=Color.FromArgb(168,140,255);start.ForeColor=Color.FromArgb(9,10,18);start.FlatStyle=FlatStyle.Flat;start.Click+=(s,e)=>StartBridge();Controls.Add(start);
   stop.Text="Encerrar";stop.Location=new Point(283,169);stop.Size=new Size(130,42);stop.Enabled=false;stop.Click+=(s,e)=>{autoConnect=false;StopBridge("Encerrado. O controle virtual foi removido.");};Controls.Add(stop);
   Button copy=new Button{Text="Copiar diagnóstico",Location=new Point(425,169),Size=new Size(171,42)};copy.Click+=(s,e)=>Clipboard.SetText(Diagnostic());Controls.Add(copy);
   status.Location=new Point(24,228);status.Size=new Size(570,48);status.ForeColor=Color.FromArgb(0,198,255);Controls.Add(status);
   activity.Location=new Point(24,285);activity.Size=new Size(570,42);activity.ForeColor=Color.FromArgb(180,177,195);Controls.Add(activity);
   Label wifiTitle=new Label{Text="Wi-Fi / Wireless • mesma rede do celular",Location=new Point(24,340),Size=new Size(570,28),ForeColor=Color.FromArgb(168,140,255)};Controls.Add(wifiTitle);
   startWifi.Text="Iniciar Wi-Fi local";startWifi.Location=new Point(24,374);startWifi.Size=new Size(210,36);startWifi.Click+=(s,e)=>StartWifi();Controls.Add(startWifi);
   Button copyCode=new Button{Text="Copiar código",Location=new Point(248,374),Size=new Size(160,36)};copyCode.Click+=(s,e)=>{if(wifi!=null)Clipboard.SetText(wifi.Code);};Controls.Add(copyCode);
   addresses.Location=new Point(24,416);addresses.Size=new Size(570,40);addresses.Text="Inicie Wi-Fi para mostrar IP, porta e código de pareamento.";Controls.Add(addresses);
   pairing.Location=new Point(24,460);pairing.Size=new Size(570,30);pairing.Font=new Font("Consolas",15,FontStyle.Bold);pairing.ForeColor=Color.FromArgb(168,140,255);Controls.Add(pairing);
   mouse.Text="Permitir touchpad como mouse";mouse.Location=new Point(24,500);mouse.Size=new Size(300,28);Controls.Add(mouse);mouse.CheckedChanged+=(s,e)=>{try{if(wifi!=null)wifi.AllowMouse=mouse.Checked;}catch(Exception ex){StopBridge(ex.Message);}};
   motion.Text="Movimento DSU (emulador)";motion.Location=new Point(328,500);motion.Size=new Size(275,28);Controls.Add(motion);motion.CheckedChanged+=(s,e)=>{if(wifi!=null)wifi.EnableMotion(motion.Checked);};
   Controls.Add(new Label{Text="Escolher uma conexão encerra a outra. Sem servidor na internet.",Location=new Point(24,535),Size=new Size(570,28)});
   tray.Icon=Icon??SystemIcons.Application;tray.Text="Nördhub ProController";tray.Visible=true;
   ContextMenuStrip menu=new ContextMenuStrip();menu.Items.Add("Abrir",null,(s,e)=>{Show();WindowState=FormWindowState.Normal;Activate();});menu.Items.Add("Desconectar",null,(s,e)=>{autoConnect=false;StopBridge("Encerrado manualmente.");});menu.Items.Add("Sair",null,(s,e)=>{exiting=true;Close();});tray.ContextMenuStrip=menu;tray.DoubleClick+=(s,e)=>{Show();WindowState=FormWindowState.Normal;Activate();};
   timer.Interval=16;timer.Tick+=(s,e)=>TickBridge();
   retry.Interval=2000;retry.Tick+=(s,e)=>{if(bridge==null&&wifi==null&&autoConnect){RefreshDevices();StartKnownDevice();}};retry.Start();
   FormClosing+=(s,e)=>{if(!exiting&&e.CloseReason==CloseReason.UserClosing){e.Cancel=true;Hide();return;}retry.Stop();StopBridge(null);tray.Dispose();};
   Shown+=(s,e)=>{StartKnownDevice();if(startInTray)Hide();};RefreshDevices();
  }
  void StartKnownDevice(){int count=0;foreach(object item in devices.Items){string name=item.ToString();if(name.IndexOf("SwitchPhone",StringComparison.OrdinalIgnoreCase)>=0||name.IndexOf("rdhub",StringComparison.OrdinalIgnoreCase)>=0)count++;}if(count==1)StartBridge();}
  void RefreshDevices(){
   if(bridge!=null||wifi!=null)return;devices.Items.Clear();
   try{foreach(Joystick.Device device in Joystick.List())devices.Items.Add(device);
    for(int i=0;i<devices.Items.Count;i++){string name=devices.Items[i].ToString();if(name.IndexOf("SwitchPhone",StringComparison.OrdinalIgnoreCase)>=0||name.IndexOf("rdhub",StringComparison.OrdinalIgnoreCase)>=0){devices.SelectedIndex=i;break;}}
    if(devices.SelectedIndex<0&&devices.Items.Count==1)devices.SelectedIndex=0;
    status.Text=devices.Items.Count==0?"Conecte o app no modo PC e clique em Atualizar lista.":"Selecione o gamepad do celular e inicie antes de abrir o jogo.";
    activity.Text="Requer Windows x64, .NET Framework 4.8 e driver ViGEmBus compatível já instalado.";
   }catch(Exception ex){status.Text=ex.Message;}
  }
  void StartBridge(){
   if(bridge!=null)return;if(devices.SelectedItem==null){status.Text="Escolha o gamepad Bluetooth do celular.";return;}
   try{StopBridge(null);bridge=new Bridge((Joystick.Device)devices.SelectedItem);bridge.Tick();changes=0;previous=bridge.Last;autoConnect=true;start.Enabled=false;startWifi.Enabled=true;devices.Enabled=false;stop.Enabled=true;timer.Start();status.Text="Controle Xbox ativo • jogador "+(bridge.XboxIndex+1)+". Abra o jogo e teste os comandos.";}
   catch(Exception ex){autoConnect=false;StopBridge(ex.Message);}
  }
  static string LocalAddresses(){List<string> values=new List<string>();foreach(NetworkInterface net in NetworkInterface.GetAllNetworkInterfaces())if(net.OperationalStatus==OperationalStatus.Up)foreach(UnicastIPAddressInformation item in net.GetIPProperties().UnicastAddresses)if(item.Address.AddressFamily==AddressFamily.InterNetwork&&WifiReceiver.Local(item.Address)&&!IPAddress.IsLoopback(item.Address))values.Add(item.Address.ToString());return values.Count==0?"Nenhum IPv4 local ativo; conecte o PC à rede.":"IPv4 do PC: "+string.Join(" / ",values.ToArray())+" • porta UDP 26761";}
  void StartWifi(){if(wifi!=null)return;autoConnect=false;StopBridge(null);try{wifi=new WifiReceiver(26761);wifi.AllowMouse=mouse.Checked;wifi.EnableMotion(motion.Checked);addresses.Text=LocalAddresses();pairing.Text=wifi.Code;changes=ticks=0;previous=new XboxReport();startWifi.Enabled=false;stop.Enabled=true;timer.Start();status.Text="Wi-Fi aguardando celular. No app: PC → Wi-Fi / Wireless.";}catch(Exception ex){StopBridge(ex.Message);}}
  void TickWifi(){try{wifi.Tick();XboxReport r=wifi.Last;if(!previous.Equals(r)){changes++;previous=r;}if(++ticks%15==0){VirtualXbox.XboxState output;uint code=VirtualXbox.XInputGetState(wifi.XboxIndex,out output);status.Text="Wi-Fi • "+(wifi.Connected?"celular autenticado":"aguardando celular, Xbox neutro")+" • jogador "+(wifi.XboxIndex+1);status.ForeColor=wifi.Connected?Color.FromArgb(0,198,255):Color.FromArgb(255,205,110);tray.Text=wifi.Connected?"Nördhub • Xbox ativo":"Nördhub • aguardando celular, Xbox neutro";activity.Text="Entrada: "+r.Buttons.ToString("X4")+" • sticks "+r.LeftX+", "+r.LeftY+" / "+r.RightX+", "+r.RightY+" • LT/RT "+r.LeftTrigger+"/"+r.RightTrigger+Environment.NewLine+"XInput: "+(code==0?output.Gamepad.Buttons.ToString("X4"):"indisponível ("+code+")")+" • "+wifi.MotionStatus;if(ticks%120==0)SaveDiagnostic();}}catch(Exception ex){StopBridge(ex.Message);}}
  string Diagnostic(){return status.Text+Environment.NewLine+activity.Text+Environment.NewLine+"Relatórios: "+(wifi!=null?wifi.Reports:bridge!=null?bridge.Reports:0)+" • mudanças: "+changes+Environment.NewLine+"Código de pareamento não incluído.";}
  void TickBridge(){
   if(wifi!=null){TickWifi();return;}if(bridge==null)return;
   try{
    bridge.Tick();if(!previous.Equals(bridge.Last)){changes++;previous=bridge.Last;}
    if(bridge.Reports%20==0){
     XboxReport r=bridge.Last;VirtualXbox.XboxState output;uint code=VirtualXbox.XInputGetState(bridge.XboxIndex,out output);
     status.Text="Xbox ativo • jogador "+(bridge.XboxIndex+1)+". "+bridge.SourceStatus;
     status.ForeColor=bridge.SourceAvailable?Color.FromArgb(0,198,255):Color.FromArgb(255,205,110);
     tray.Text=bridge.SourceAvailable?"Nördhub • Xbox ativo":"Nördhub • aguardando celular, Xbox neutro";
     activity.Text="Entrada celular: "+r.Buttons.ToString("X4")+" • sticks "+r.LeftX+", "+r.LeftY+" / "+r.RightX+", "+r.RightY+Environment.NewLine+"Saída XInput: "+(code==0?output.Gamepad.Buttons.ToString("X4")+" • sticks "+output.Gamepad.LeftX+", "+output.Gamepad.LeftY+" / "+output.Gamepad.RightX+", "+output.Gamepad.RightY:"indisponível ("+code+")");
     if(bridge.Reports%120==0)SaveDiagnostic();
    }
   }
   catch(Exception ex){StopBridge(ex.Message);}
  }
  void SaveDiagnostic(){
   try{
    string target=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"bridge-status.txt"),temporary=target+".tmp";
    File.WriteAllText(temporary,DateTime.Now.ToString("s")+Environment.NewLine+Diagnostic());
    if(File.Exists(target))File.Replace(temporary,target,null);else File.Move(temporary,target);
   }
   catch(IOException){}catch(UnauthorizedAccessException){}
  }
  void StopBridge(string message){timer.Stop();Bridge old=bridge;WifiReceiver oldWifi=wifi;bridge=null;wifi=null;string cleanupError=null;try{if(old!=null)old.Dispose();}catch(Exception ex){cleanupError=ex.Message;}try{if(oldWifi!=null)oldWifi.Dispose();}catch(Exception ex){cleanupError=ex.Message;}if(cleanupError!=null)message=(message==null?"":message+" ")+cleanupError;pairing.Text="";startWifi.Enabled=true;start.Enabled=true;devices.Enabled=true;stop.Enabled=false;tray.Text="Nördhub • Xbox encerrado";if(message!=null)status.Text=message;activity.Text="Nenhum controle Xbox virtual ativo neste auxiliar.";SaveDiagnostic();}
 }
 static class Program {
  [STAThread] static void Main(string[] args){
   bool created;using(Mutex single=new Mutex(true,"Local\\NordhubProControllerPc",out created)){if(!created)return;
   Application.EnableVisualStyles();Application.SetCompatibleTextRenderingDefault(false);Application.Run(new MainForm(Array.IndexOf(args,"--tray")>=0));}
  }
 }
}
