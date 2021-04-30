# if_else() errors informatively

    Code
      if_else(1:2, 1:3, 1)
    Error <vctrs_error_incompatible_size>
      Can't recycle `condition` (size 2) to match `true` (size 3).
    Code
      if_else(1, 1, "2")
    Error <vctrs_error_incompatible_type>
      Can't combine `true` <double> and `false` <character>.

