#include <string.h>
#include "postgres.h"
#include "fmgr.h"
#include "libpq/pqformat.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

typedef struct {
	char name[256];
	char content[1024];
} File;

PG_FUNCTION_INFO_V1(file_in);

Datum file_in(PG_FUNCTION_ARGS) {
	File *result = palloc(sizeof *result);
	char *str = PG_GETARG_CSTRING(0);

	if (sscanf(str, "[%[^]]] %[^\n]", result->name, result->content) != 2) {
		ereport(ERROR,
			(errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
			 errmsg("invalid input syntax for type file: \"%s\"", str)));
	}

	PG_RETURN_POINTER(result);
}

PG_FUNCTION_INFO_V1(file_out);

Datum file_out(PG_FUNCTION_ARGS) {
	File *file = (File *) PG_GETARG_POINTER(0);
	char *result = psprintf("[%s] %s", file->name, file->content);
	PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(file_recv);

Datum file_recv(PG_FUNCTION_ARGS) {
	StringInfo buf = (StringInfo) PG_GETARG_POINTER(0);
	File* result = palloc(sizeof *result);

	strncpy(result->name, pq_getmsgstring(buf), 255);
	strncpy(result->content, pq_getmsgstring(buf), 1023);
	PG_RETURN_POINTER(result);
}

PG_FUNCTION_INFO_V1(file_send);

Datum file_send(PG_FUNCTION_ARGS) {
	File *file = (File *) PG_GETARG_POINTER(0);
	StringInfoData buf;

	pq_begintypsend(&buf);
	pq_sendstring(&buf, file->name);
	pq_sendstring(&buf, file->content);
	PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}
