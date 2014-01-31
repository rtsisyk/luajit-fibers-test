#include <stddef.h>
#include <stdint.h>
#include <assert.h>

enum { TBUF_CAPACITY = 4096 };

struct tbuf {
	/* Used space in the buffer. */
	uint32_t size;
	/* Total allocated buffer capacity. */
	uint32_t capacity;
	/* Allocated buffer. */
	char data[TBUF_CAPACITY];
};

extern struct tbuf tbuf;

static inline struct tbuf *
tbuf_new(void)
{
	tbuf.size = 0;
	tbuf.capacity = TBUF_CAPACITY;
	return &tbuf;
}

static inline void
tbuf_ensure(struct tbuf *buf, size_t size)
{
	(void) buf;
	(void) size;
	assert(size < TBUF_CAPACITY);
}
