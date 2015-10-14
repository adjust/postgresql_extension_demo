#ifndef BASE36_H
#define BASE36_H

#include "postgres.h"
#include "utils/builtins.h"
#include "utils/int8.h"
#include "libpq/pqformat.h"
#include <limits.h>

extern const char base36_digits[36];

#define BASE36OUTOFRANGE_ERROR(_str, _typ)                      \
  do {                                                          \
    ereport(ERROR,                                              \
      (errcode(ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE),             \
        errmsg("value \"%s\" is out of range for type %s",      \
          _str, _typ)));                                        \
  } while(0)                                                    \

#define BASE36SYNTAX_ERROR(_str, _typ)                          \
  do {                                                          \
    ereport(ERROR,                                              \
      (errcode(ERRCODE_SYNTAX_ERROR),                           \
      errmsg("invalid input syntax for %s: \"%s\"",             \
             _typ, _str)));                                     \
  } while(0)                                                    \


#endif // BASE36_H
