#ifndef TEST_SERIAL_H
#define TEST_SERIAL_H

typedef nx_struct TestSerialMsg {
  nx_uint16_t seqNum;
  nx_uint16_t ledNum;
  nx_uint16_t sender;
  nx_uint16_t receiver;
} TestSerialMsg;

enum {
  AM_TESTSERIALMSG = 6,
  TIMEOUT = 600,
};

#endif
