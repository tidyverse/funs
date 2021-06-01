# shift() errors

    Code
      x <- 1:10
      lead(x, -1)
    Error <rlang_error>
      `n` must be positive.
    Code
      lag(x, -1)
    Error <rlang_error>
      `n` must be positive.
    Code
      lead(x, "a")
    Error <vctrs_error_incompatible_type>
      Can't convert `n` <character> to <integer>.
    Code
      lag(x, "a")
    Error <vctrs_error_incompatible_type>
      Can't convert `n` <character> to <integer>.
    Code
      lead(x, 1, order_by = 1)
    Error <vctrs_error_assert_size>
      `order_by` must have size 10, not size 1.
    Code
      lag(x, 1, order_by = 1)
    Error <vctrs_error_assert_size>
      `order_by` must have size 10, not size 1.
    Code
      lag(c("1", "2", "3"), default = FALSE)
    Error <vctrs_error_incompatible_type>
      Can't convert `default` <logical> to <character>.
    Code
      lag(c("1", "2", "3"), default = character())
    Error <vctrs_error_assert_size>
      `default` must have size 1, not size 0.
    Code
      lag(c("1", "2", "3"), default = c("a", "b"))
    Error <vctrs_error_assert_size>
      `default` must have size 1, not size 2.

