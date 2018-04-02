#include "stream.h"

void stream_init(Stream * self, void * buffer, unsigned int length) {
  self->position = 0;
  self->length = length;
  self->data = (char *)buffer;
}

void stream_rewind(Stream * self, unsigned int amount) {
  self->position -= amount;
}

void stream_fastforward(Stream * self, unsigned int amount) {
  self->position += amount;
}

void stream_zero(Stream * self) {
  self->position = 0;
}