#include "postgres.h"
#include "fmgr.h"
#include "utils/builtins.h"

PG_FUNCTION_INFO_V1(bigbase36_in);
Datum
bigbase36_in(PG_FUNCTION_ARGS)
{
    int64 result;
    char *bad;
    char *str = PG_GETARG_CSTRING(0);
    result = strtoul(str, &bad, 36);
    if (bad[0] != '\0' || strlen(str)==0)
        ereport(ERROR,
            (
             errcode(ERRCODE_SYNTAX_ERROR),
             errmsg("invalid input syntax for bigbase36: \"%s\"", str)
            )
        );
    if (result < 0)
        ereport(ERROR,
            (
             errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),
             errmsg("negative values are not allowed"),
             errdetail("value %ld is negative", result),
             errhint("make it positive")
            )
        );
    PG_RETURN_INT64(result);
}

PG_FUNCTION_INFO_V1(bigbase36_out);
Datum
bigbase36_out(PG_FUNCTION_ARGS)
{
    int64 arg = PG_GETARG_INT64(0);
    if (arg < 0)
        ereport(ERROR,
            (
             errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),
             errmsg("negative values are not allowed"),
             errdetail("value %ld is negative", arg),
             errhint("make it positive")
            )
        );
    char base36[36] = "0123456789abcdefghijklmnopqrstuvwxyz";

    /* max 13 char + '\0' */
    char buffer[14];
    unsigned int offset = sizeof(buffer);
    buffer[--offset] = '\0';

    do {
        buffer[--offset] = base36[arg % 36];
    } while (arg /= 36);

    PG_RETURN_CSTRING(pstrdup(&buffer[offset]));
}