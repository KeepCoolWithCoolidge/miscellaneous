#ifndef BUFFERSTREAM_H
#define BUFFERSTREAM_H

#include "stream.h"

void bufferstream_init(Stream * self, void * buffer, unsigned int length);
STREAM_PROTOTYPES(buffer, char)
STREAM_PROTOTYPES(buffer, short)
STREAM_PROTOTYPES(buffer, int)
STREAM_PROTOTYPES(buffer, long)

#endif