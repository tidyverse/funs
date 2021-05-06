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
    Code
      x <- 1:4
      nth(x, 1) <- 1:2
    Error <vctrs_error_assert_size>
      `value` must have size 1, not size 2.
    Code
      nth(x, "a") <- 2
    Error <rlang_error>
      `n` must be a single integer.
    Code
      nth(x, 1) <- "a"
    Error <vctrs_error_incompatible_type>
      Can't convert `value` <character> to match type of `x` <integer>.
    Code
      nth(x, 5) <- "a"
    Error <vctrs_error_incompatible_type>
      Can't convert `value` <character> to match type of `x` <integer>.
    Code
      nth(x, 5) <- 7
    Warning <warning>
      Unchanged `x` as `n` is out of bounds
    Code
      lst <- list(1, 2)
      nth(lst, 1) <- 3:4
    Error <vctrs_error_assert_size>
      `value` must have size 1, not size 2.
    Code
      df <- data.frame(x = 1:3)
      first(df) <- data.frame(x = 5:6)
    Error <vctrs_error_assert_size>
      `value` must have size 1, not size 2.
    Code
      first(df) <- data.frame(x = "4", stringsAsFactors = FALSE)
    Error <vctrs_error_incompatible_type>
      Can't convert `value$x` <character> to match type of `x$x` <integer>.
    Code
      first(df) <- data.frame(y = 5)
    Error <vctrs_error_cast_lossy_dropped>
      Can't convert from <data.frame<y:double>> to <data.frame<x:integer>> due to loss of precision.
      Dropped variables: `y`

