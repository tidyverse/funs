# if_else() errors informatively

    Code
      if_else(TRUE, 1:3, 1)
    Error <vctrs_error_incompatible_size>
      Can't recycle input of size 3 to size 1.
    Code
      if_else(TRUE, 1, 1:3)
    Error <vctrs_error_incompatible_size>
      Can't recycle input of size 3 to size 1.
    Code
      if_else(TRUE, 1, 1, 1:3)
    Error <vctrs_error_incompatible_size>
      Can't recycle input of size 3 to size 1.
    Code
      if_else(c(TRUE, FALSE), 1:3, 1)
    Error <vctrs_error_incompatible_size>
      Can't recycle input of size 3 to size 2.
    Code
      if_else(1, 1, "2")
    Error <vctrs_error_assert_ptype>
      `condition` must be a vector with type <logical>.
      Instead, it has type <double>.

