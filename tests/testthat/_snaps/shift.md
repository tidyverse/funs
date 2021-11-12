# shift() errors

    Code
      (expect_error(lead(1:10, -1)))
    Output
      <error/rlang_error>
      Error in `lead()`: `n` must be positive.
    Code
      (expect_error(lag(1:10, -1)))
    Output
      <error/rlang_error>
      Error in `lag()`: `n` must be positive.
    Code
      (expect_error(lead(1:10, 1:2)))
    Output
      <error/rlang_error>
      Error in `lead()`:
        `n` must be a single positive number.
      Caused by error in `vec_assert()`:
        `n` must have size 1, not size 2.
    Code
      (expect_error(lag(1:10, 1:2)))
    Output
      <error/rlang_error>
      Error in `lag()`:
        `n` must be a single positive number.
      Caused by error in `vec_assert()`:
        `n` must have size 1, not size 2.
    Code
      (expect_error(lead(1:10, "a")))
    Output
      <error/rlang_error>
      Error in `lead()`:
        `n` must be a single positive number.
      Caused by error in `stop_vctrs()`:
        Can't convert `n` <character> to <integer>.
    Code
      (expect_error(lag(1:10, "a")))
    Output
      <error/rlang_error>
      Error in `lag()`:
        `n` must be a single positive number.
      Caused by error in `stop_vctrs()`:
        Can't convert `n` <character> to <integer>.
    Code
      (expect_error(shift(1:10, "a")))
    Output
      <error/rlang_error>
      Error in `shift()`:
        `n` must be a single positive number.
      Caused by error in `stop_vctrs()`:
        Can't convert `n` <character> to <integer>.
    Code
      (expect_error(lead(1:10, 1, order_by = 1)))
    Output
      <error/rlang_error>
      Error in `lead()`:
        `order_by` must match the size of `x`.
      Caused by error in `vec_assert()`:
        `order_by` must have size 10, not size 1.
    Code
      (expect_error(lag(1:10, 1, order_by = 1)))
    Output
      <error/rlang_error>
      Error in `lag()`:
        `order_by` must match the size of `x`.
      Caused by error in `vec_assert()`:
        `order_by` must have size 10, not size 1.
    Code
      (expect_error(shift(1:10, 1, order_by = 1)))
    Output
      <error/rlang_error>
      Error in `shift()`:
        `order_by` must match the size of `x`.
      Caused by error in `vec_assert()`:
        `order_by` must have size 10, not size 1.
    Code
      (expect_error(lag(c("1", "2", "3"), default = FALSE)))
    Output
      <error/rlang_error>
      Error in `lag()`:
        `default` must be a scalar compatible with <character>.
      Caused by error in `stop_vctrs()`:
        Can't convert `default` <logical> to <character>.
    Code
      (expect_error(lag(c("1", "2", "3"), default = character())))
    Output
      <error/rlang_error>
      Error in `lag()`:
        `default` must be a scalar compatible with <character>.
      Caused by error in `vec_assert()`:
        `default` must have size 1, not size 0.
    Code
      (expect_error(lag(c("1", "2", "3"), default = c("a", "b"))))
    Output
      <error/rlang_error>
      Error in `lag()`:
        `default` must be a scalar compatible with <character>.
      Caused by error in `vec_assert()`:
        `default` must have size 1, not size 2.

