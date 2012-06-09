#include "TestSerial.h"

configuration TestSerialAppC {}
implementation {
  components TestSerialC as App, LedsC, MainC;
  components SerialActiveMessageC as AMSerial;
  components BlockingActiveMessageC;
  components ActiveMessageC as AMRadio;
  components new TimerMilliC() as AnyTimer;
  components PrintfC;

  App.Boot -> MainC.Boot;
  
  App.BlockingAMControl -> BlockingActiveMessageC;
  App.SerialControl  -> AMSerial;
  App.SerialSend 	 -> AMSerial;
  App.SerialReceive  -> AMSerial.Receive;
  App.SerialPacket 	 -> AMSerial;
  App.SerialAMPacket -> AMSerial;
  
  App.RadioControl 	-> AMRadio;
  App.RadioSend 	-> AMRadio;
  App.RadioReceive 	-> AMRadio.Receive;
  App.RadioPacket 	-> AMRadio;
  App.RadioAMPacket -> AMRadio;
  
  App.AnyTimer	-> AnyTimer;
  
  App.Leds 	-> LedsC;

  components new BlockingAMSenderC(220) as BlockingAMSender0;
  components new BlockingAMReceiverC(220) as BlockingAMReceiver0;  
  components new ThreadC(300) as RadioSendThread0;
  components new ThreadC(300) as RadioReceiveThread0;
  
  App.RadioSendThread0 -> RadioSendThread0;
  App.RadioReceiveThread0 -> RadioReceiveThread0;
  App.BlockingAMSend0 -> BlockingAMSender0;
  App.BlockingReceive0 -> BlockingAMReceiver0;
}
