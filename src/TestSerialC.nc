#include "AM.h"
#include "TestSerial.h"

module TestSerialC
{
  uses
  {
    interface Boot;
    interface BlockingStdControl as BlockingRadioAMControl;
    interface BlockingStdControl as BlockingSerialAMControl;

    interface Thread as RadioReceiveThread;
    interface BlockingAMSend as BlockingRadioAMSend0;
    interface BlockingReceive as BlockingRadioReceive0;
    interface Packet as RadioPacket0;
	interface AMPacket as RadioAMPacket0;
    
    interface Thread as SerialReceiveThread;
    interface BlockingAMSend as BlockingRadioAMSend1;
    interface BlockingAMSend as BlockingSerialAMSend1;
    interface BlockingReceive as BlockingSerialReceive1;
    interface Packet as SerialPacket1;
	interface AMPacket as SerialAMPacket1;
	interface Packet as RadioPacket1;
	interface AMPacket as RadioAMPacket1;
 
    interface Leds;
  }
}

implementation
{

	message_t msgRadioReceiveThread;
	message_t msgSerialReceiveThread;
	message_t msgReflectSerialReceiveThread;
	TestSerialMsg* msgPtr;
  
	uint16_t localSeqNumber = 0; ///< stores the msg sequence number
  
  	/*
	*	Starts Threads.
	*/ 
	event void Boot.booted() {
    	call RadioReceiveThread.start(NULL);
    	call SerialReceiveThread.start(NULL);
  
 	}

	/*
  	*	Waits to receive a message over radio and 
  	*	if necessary the message will be forwarded over radio
  	*	or Leds will be toggled.
  	*	Checks seqNum to avoid duplicates.
  	*/
  	event void RadioReceiveThread.run(void* arg) {
    	call BlockingRadioAMControl.start();
    	for(;;) {
      		  		      		      
	      	// wait for message some milli seconds, timeout is necessary to unblock radio for the other thread
		    if(call BlockingRadioReceive0.receive(&msgRadioReceiveThread, TIMEOUT) == SUCCESS)
	  		{
	   			TestSerialMsg* payload = (TestSerialMsg*)(call RadioPacket0.getPayload(&msgRadioReceiveThread, sizeof (TestSerialMsg))); // jump to starting pointer
		
				
				// check seq
				if(payload->seqNum > localSeqNumber){
				
					localSeqNumber = payload->seqNum;
				
					// check receiver
					if(payload->receiver == TOS_NODE_ID){
					
						// Switch Leds
						call Leds.set(payload->ledNum);
						
		    		}
		    		else
		    		{
		    			//forward message
		    			call BlockingRadioAMSend0.send(AM_BROADCAST_ADDR, &msgRadioReceiveThread , sizeof(TestSerialMsg));
		    			call Leds.led0Toggle();
		    		}
	    		
	    		}
	    	
		    }
    	}
  	}
  	
  	/*
  	*	Waits to receive a message over serial and 
  	*	if necessary the message will be forwarded over radio
  	*	or Leds will be toggled.
  	*	Checks seqNum to avoid duplicates.
  	*/
  	event void SerialReceiveThread.run(void* arg) {
  	   	call BlockingSerialAMControl.start();
		call BlockingRadioAMControl.start();
		
    	for(;;) {
    	    	
    		if(call BlockingSerialReceive1.receive(&msgSerialReceiveThread, TIMEOUT) == SUCCESS)
	    	{	
	    	   	TestSerialMsg *payload = (TestSerialMsg*)(call SerialPacket1.getPayload(&msgSerialReceiveThread, sizeof (TestSerialMsg))); // jump to starting pointer
				
				// check seq
				if(payload->seqNum > localSeqNumber){
					
					localSeqNumber = payload->seqNum;
					
					// check receiver
					if(payload->receiver == TOS_NODE_ID){
						
						// Switch Leds
						call Leds.set(payload->ledNum);
						
	    			}
	    			else
	    			{
	    				//forward message
	    				call BlockingRadioAMSend1.send(AM_BROADCAST_ADDR, &msgSerialReceiveThread , sizeof(TestSerialMsg));
	    			}
	    			
	    			// reflect message
	    			msgPtr = (TestSerialMsg*)(call SerialPacket1.getPayload(&msgReflectSerialReceiveThread, sizeof (TestSerialMsg)));
					msgPtr->seqNum = payload->seqNum;
					msgPtr->ledNum = payload->ledNum;
					msgPtr->sender = 0;
					msgPtr->receiver = payload->receiver;
	    			call BlockingSerialAMSend1.send(99, &msgReflectSerialReceiveThread , sizeof(TestSerialMsg));
	    			
	    		}
	    
	    	}
      		
    	}
  	}
  
 
}
