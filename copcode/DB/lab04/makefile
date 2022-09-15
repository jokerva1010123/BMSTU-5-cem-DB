MODULES = file

PG_CONFIG = pg_config
PGXS = $(shell $(PG_CONFIG) --pgxs)
INCLUDEDIR = $(shell $(PG_CONFIG) --includedir-server)

include $(PGXS)

.PHONY: all clean

file.so: file.o
	cc -shared -o $@ $^

file.o: file.c
	cc -o $@ -c $^ $(CFLAGS) -I $(INCLUDEDIR)
