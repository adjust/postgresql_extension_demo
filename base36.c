#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(base36_encode);
Datum
base36_encode(PG_FUNCTION_ARGS)
{
    int32 arg = PG_GETARG_INT32(0);
    char base36[36] = "0123456789abcdefghijklmnopqrstuvwxyz";

    /* max 6 char + '\0' */
    char *buffer = palloc(7 * sizeof(char));
    unsigned int offset = sizeof(buffer);
    buffer[--offset] = '\0';

    do {
        buffer[--offset] = base36[arg % 36];
    } while (arg /= 36);


    PG_RETURN_TEXT_P(cstring_to_text(&buffer[offset]));
}