#include "stream.h"
#include "bufferstream.h"
#include "stdlib.h"
#include "stdio.h"

void bufferstream_init(Stream * self, void * buffer, unsigned int length)
{
  stream_init(self, buffer, length);
 }

STREAM_FUNCTIONS(buffer, char)
STREAM_FUNCTIONS(buffer, short)
STREAM_FUNCTIONS(buffer, int)
STREAM_FUNCTIONS(buffer, long)