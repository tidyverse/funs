# if_else() errors informatively

    Code
      if_else(TRUE, 1:3, 1)
    Condition
      Error in `if_else()`:
      ! Can't recycle `true` (size 3) to size 1.
    Code
      if_else(TRUE, 1, 1:3)
    Condition
      Error in `if_else()`:
      ! Can't recycle `false` (size 3) to size 1.
    Code
      if_else(TRUE, 1, 1, 1:3)
    Condition
      Error in `if_else()`:
      ! Can't recycle `na` (size 3) to size 1.
    Code
      if_else(c(TRUE, FALSE), 1:3, 1)
    Condition
      Error in `if_else()`:
      ! Can't recycle `true` (size 3) to size 2.
    Code
      if_else(1, 1, "2")
    Condition
      Error in `if_else()`:
      ! `condition` must be a vector with type <logical>.
      Instead, it has type <double>.

