configuration TestSerialAppC {
}
implementation {
  components MainC, TestSerialC as App,  LedsC;
  components BlockingActiveMessageC;
  components BlockingSerialActiveMessageC;
  App -> MainC.Boot;
  App.BlockingRadioAMControl -> BlockingActiveMessageC;
  App.BlockingSerialAMControl -> BlockingSerialActiveMessageC;
  App.Leds -> LedsC;
  
  components new ThreadC(300) as RadioReceiveThread;
  components new BlockingAMSenderC(6) as BlockingRadioAMSender0;
  components new BlockingAMReceiverC(6) as BlockingRadioReceiver0;
  
  App.RadioReceiveThread -> RadioReceiveThread;
  App.BlockingRadioAMSend0 -> BlockingRadioAMSender0;
  App.BlockingRadioReceive0 -> BlockingRadioReceiver0;
  App.RadioPacket0 -> BlockingActiveMessageC.Packet;
  App.RadioAMPacket0 -> BlockingActiveMessageC.AMPacket;
  
  components new ThreadC(300) as SerialReceiveThread;
  components new BlockingAMSenderC(6) as BlockingRadioAMSender1;
  components new BlockingSerialAMSenderC(6) as BlockingSerialAMSender1;
  components new BlockingSerialAMReceiverC(6) as BlockingSerialReceiver1;
  App.SerialReceiveThread -> SerialReceiveThread;
  App.BlockingRadioAMSend1 -> BlockingRadioAMSender1;
  App.BlockingSerialAMSend1 -> BlockingSerialAMSender1;
  App.BlockingSerialReceive1 -> BlockingSerialReceiver1;
  App.RadioPacket1 -> BlockingActiveMessageC.Packet;
  App.RadioAMPacket1 -> BlockingActiveMessageC.AMPacket;
  App.SerialPacket1 -> BlockingSerialActiveMessageC.Packet;
  App.SerialAMPacket1 -> BlockingSerialActiveMessageC.AMPacket;
  
  
 
}

