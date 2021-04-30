# nth() errors

    Code
      nth(1:10, 12, default = "")
    Error <vctrs_error_incompatible_type>
      Can't convert <character> to <integer>.
    Code
      nth(1:10, c(1, 2))
    Error <rlang_error>
      `n` must be a single integer.
    Code
      nth(1:10, 1.3)
    Error <rlang_error>
      `n` must be a single integer.
    Code
      first(last)
    Error <vctrs_error_scalar_type>
      Input must be a vector, not a function.

