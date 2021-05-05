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
      nth(x, 5) <- 5
    Error <rlang_error>
      `n` is out of bounds
    Code
      nth(x, -5) <- 5
    Error <rlang_error>
      `n` is out of bounds
    Code
      nth(x, 1) <- 1:2
    Error <vctrs_error_assert_size>
      `value` must have size 1, not size 2.
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
      first(df) <- data.frame(x = "4")
    Error <vctrs_error_incompatible_type>
      Can't combine `x$x` <integer> and `value$x` <character>.
    Code
      first(df) <- data.frame(y = 5)

