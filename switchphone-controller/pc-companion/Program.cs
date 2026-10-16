using System;
using System.Drawing;
using System.Windows.Forms;

namespace Nordhub.ProController {
 public sealed class MainForm:Form {
  readonly ComboBox devices=new ComboBox();readonly Label status=new Label(),activity=new Label();readonly Button start=new Button(),stop=new Button();
  readonly Timer timer=new Timer();Bridge bridge;
  public MainForm(){
   Text="Nördhub ProController • PC";ClientSize=new Size(620,350);MinimumSize=new Size(636,389);StartPosition=FormStartPosition.CenterScreen;
   BackColor=Color.FromArgb(9,10,18);ForeColor=Color.FromArgb(238,232,255);Font=new Font("Segoe UI",10);
   try{Icon=Icon.ExtractAssociatedIcon(Application.ExecutablePath);}catch{}
   Label title=new Label{Text="Nördhub ProController",Font=new Font("Segoe UI",21,FontStyle.Bold),ForeColor=Color.FromArgb(168,140,255),Location=new Point(22,20),Size=new Size(570,42)};Controls.Add(title);
   Label intro=new Label{Text="Celular por Bluetooth → controle Xbox para jogos Steam e fora da Steam",Location=new Point(24,70),Size=new Size(570,45)};Controls.Add(intro);
   devices.DropDownStyle=ComboBoxStyle.DropDownList;devices.Location=new Point(24,120);devices.Size=new Size(430,30);Controls.Add(devices);
   Button scan=new Button{Text="Atualizar lista",Location=new Point(466,118),Size=new Size(130,32)};scan.Click+=(s,e)=>RefreshDevices();Controls.Add(scan);
   start.Text="Iniciar controle Xbox";start.Location=new Point(24,169);start.Size=new Size(245,42);start.BackColor=Color.FromArgb(168,140,255);start.ForeColor=Color.FromArgb(9,10,18);start.FlatStyle=FlatStyle.Flat;start.Click+=(s,e)=>StartBridge();Controls.Add(start);
   stop.Text="Encerrar";stop.Location=new Point(283,169);stop.Size=new Size(130,42);stop.Enabled=false;stop.Click+=(s,e)=>StopBridge("Encerrado. O controle virtual foi removido.");Controls.Add(stop);
   status.Location=new Point(24,228);status.Size=new Size(570,48);status.ForeColor=Color.FromArgb(0,198,255);Controls.Add(status);
   activity.Location=new Point(24,285);activity.Size=new Size(570,42);activity.ForeColor=Color.FromArgb(180,177,195);Controls.Add(activity);
   timer.Interval=16;timer.Tick+=(s,e)=>TickBridge();FormClosing+=(s,e)=>StopBridge(null);RefreshDevices();
  }
  void RefreshDevices(){
   if(bridge!=null)return;devices.Items.Clear();
   try{foreach(Joystick.Device device in Joystick.List())devices.Items.Add(device);
    for(int i=0;i<devices.Items.Count;i++){string name=devices.Items[i].ToString();if(name.IndexOf("SwitchPhone",StringComparison.OrdinalIgnoreCase)>=0||name.IndexOf("rdhub",StringComparison.OrdinalIgnoreCase)>=0){devices.SelectedIndex=i;break;}}
    if(devices.SelectedIndex<0&&devices.Items.Count==1)devices.SelectedIndex=0;
    status.Text=devices.Items.Count==0?"Conecte o app no modo PC e clique em Atualizar lista.":"Selecione o gamepad do celular e inicie antes de abrir o jogo.";
    activity.Text="Requer Windows x64, .NET Framework 4.8 e driver ViGEmBus compatível já instalado.";
   }catch(Exception ex){status.Text=ex.Message;}
  }
  void StartBridge(){
   if(devices.SelectedItem==null){status.Text="Escolha o gamepad Bluetooth do celular.";return;}
   try{bridge=new Bridge((Joystick.Device)devices.SelectedItem);bridge.Tick();start.Enabled=false;devices.Enabled=false;stop.Enabled=true;timer.Start();status.Text="Controle Xbox ativo • jogador "+(bridge.XboxIndex+1)+". Abra o jogo e teste os comandos.";}
   catch(Exception ex){StopBridge(ex.Message);}
  }
  void TickBridge(){
   if(bridge==null)return;
   try{bridge.Tick();if(bridge.Reports%20==0){XboxReport r=bridge.Last;VirtualXbox.XboxState output;uint code=VirtualXbox.XInputGetState(bridge.XboxIndex,out output);activity.Text="Entrada celular: "+r.Buttons.ToString("X4")+" • sticks "+r.LeftX+", "+r.LeftY+" / "+r.RightX+", "+r.RightY+Environment.NewLine+"Saída XInput: "+(code==0?output.Gamepad.Buttons.ToString("X4")+" • sticks "+output.Gamepad.LeftX+", "+output.Gamepad.LeftY+" / "+output.Gamepad.RightX+", "+output.Gamepad.RightY:"indisponível ("+code+")");}}
   catch(Exception ex){StopBridge(ex.Message);}
  }
  void StopBridge(string message){timer.Stop();if(bridge!=null){bridge.Dispose();bridge=null;}start.Enabled=true;devices.Enabled=true;stop.Enabled=false;if(message!=null)status.Text=message;}
 }
 static class Program {
  [STAThread] static void Main(){
   Application.EnableVisualStyles();Application.SetCompatibleTextRenderingDefault(false);Application.Run(new MainForm());
  }
 }
}
