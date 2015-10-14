#include "base36.h"

PG_MODULE_MAGIC;

const char base36_digits[36] = "0123456789abcdefghijklmnopqrstuvwxyz";

PG_FUNCTION_INFO_V1(base36_in);
Datum
base36_in(PG_FUNCTION_ARGS)
{
    long result;
    char *bad;
    char *str = PG_GETARG_CSTRING(0);
    result = strtol(str, &bad, 36);
    if (result < INT_MIN || result > INT_MAX)
        BASE36OUTOFRANGE_ERROR(str, "base36");

    if (bad[0] != '\0' || strlen(str)==0)
        BASE36SYNTAX_ERROR(str,"base36");

    PG_RETURN_INT32((int32)result);
}

PG_FUNCTION_INFO_V1(base36_out);
Datum
base36_out(PG_FUNCTION_ARGS)
{
    int32 arg = PG_GETARG_INT32(0);
    bool  neg = false;

    if (arg < 0)
    {
        arg = -arg;
        neg = true;
    }

    /* max 6 char + '\0' + sign*/
    char buffer[8];
    unsigned int offset = sizeof(buffer);
    buffer[--offset] = '\0';

    do {
        buffer[--offset] = base36_digits[arg % 36];
    } while (arg /= 36);

    if (neg)
        buffer[--offset] = '-';

    PG_RETURN_CSTRING(pstrdup(&buffer[offset]));
}

