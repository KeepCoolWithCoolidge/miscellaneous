#ifndef STREAM_H
#define STREAM_H

#define STREAM_FUNCTIONS(STREAM_TYPE, DATA_TYPE) void STREAM_TYPE ## stream_write_ ## DATA_TYPE(Stream * self, DATA_TYPE value) { \
                                                   *(DATA_TYPE *)(self->data + self->position) = value; \
                                                   self->position += sizeof(DATA_TYPE);\
                                                 } \
                                                 \
                                                 void STREAM_TYPE ## stream_write_u ## DATA_TYPE(Stream * self, unsigned DATA_TYPE value) { \
                                                   *(DATA_TYPE *)(self->data + self->position) = value; \
                                                   self->position += sizeof(unsigned DATA_TYPE);\
                                                 } \
                                                 DATA_TYPE STREAM_TYPE ## stream_read_ ## DATA_TYPE(Stream * self) { \
                                                   DATA_TYPE read_ ## DATA_TYPE; \
                                                   read_ ## DATA_TYPE = *(DATA_TYPE *)(self->data + self->position); \
                                                   self->position += sizeof(DATA_TYPE);\
                                                   return read_ ## DATA_TYPE; \
                                                 } \
                                                 \
                                                 unsigned DATA_TYPE STREAM_TYPE ## stream_read_u ## DATA_TYPE(Stream * self) { \
                                                   DATA_TYPE read_u ## DATA_TYPE; \
                                                   read_u ## DATA_TYPE = *(unsigned DATA_TYPE *)(self->data + self->position); \
                                                   return read_u ## DATA_TYPE;\
                                                 }

#define STREAM_PROTOTYPES(STREAM_TYPE, DATA_TYPE) void STREAM_TYPE ## stream_write_ ## DATA_TYPE(Stream * self, DATA_TYPE value); \
                                                  void STREAM_TYPE ## stream_write_u ## DATA_TYPE(Stream * self, unsigned DATA_TYPE value); \
                                                  DATA_TYPE STREAM_TYPE ## stream_read_ ## DATA_TYPE(Stream * self); \
                                                  unsigned DATA_TYPE STREAM_TYPE ## stream_read_u ## DATA_TYPE(Stream * self);

typedef struct Stream {
  char * data;
  unsigned int position;
  unsigned int length;

} Stream;

void stream_init(Stream  * self, void * buffer, unsigned int length);
void stream_rewind(Stream * self, unsigned int amount);
void stream_fastforward(Stream * self, unsigned int amount);
void stream_zero(Stream * self);

#endif 