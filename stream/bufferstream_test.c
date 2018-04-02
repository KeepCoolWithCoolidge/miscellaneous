#include "stream.h"
#include "bufferstream.h"
#include "stdio.h"
#include "stdlib.h"

int main() {
  char * myData = malloc(2500);
  struct Stream * myBufferStream;
  char read_char;
  long read_long;

  bufferstream_init(myBufferStream, myData, 2500);
  bufferstream_write_char(myBufferStream, 'a');
  bufferstream_write_long(myBufferStream, 500L);
  bufferstream_write_char(myBufferStream, 'b');
  bufferstream_write_char(myBufferStream, 'c');
  bufferstream_write_char(myBufferStream, 'd');
  stream_zero(myBufferStream);
  read_char = bufferstream_read_char(myBufferStream);
  printf("%c\n", read_char);
  read_long = bufferstream_read_long(myBufferStream);
  printf("%ld\n", read_long);
  read_char = bufferstream_read_char(myBufferStream);
  printf("%c\n", read_char);
  read_char = bufferstream_read_char(myBufferStream);
  printf("%c\n", read_char);
  read_char = bufferstream_read_char(myBufferStream);
  printf("%c\n", read_char);
  free(myData);
}