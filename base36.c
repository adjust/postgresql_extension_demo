#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(base36_in);
Datum
base36_in(PG_FUNCTION_ARGS)
{
    long result;
    char *str = PG_GETARG_CSTRING(0);
    result = strtoul(str, NULL, 36);
    PG_RETURN_INT32((int32)result);
}

PG_FUNCTION_INFO_V1(base36_out);
Datum
base36_out(PG_FUNCTION_ARGS)
{
    int32 arg = PG_GETARG_INT32(0);
    if (arg < 0)
        ereport(ERROR,
            (
             errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),
             errmsg("negative values are not allowed"),
             errdetail("value %d is negative", arg),
             errhint("make it positive")
            )
        );
    char base36[36] = "0123456789abcdefghijklmnopqrstuvwxyz";

    /* max 6 char + '\0' */
    char buffer[7];
    unsigned int offset = sizeof(buffer);
    buffer[--offset] = '\0';

    do {
        buffer[--offset] = base36[arg % 36];
    } while (arg /= 36);

    PG_RETURN_CSTRING(pstrdup(&buffer[offset]));
}