test_that("lead() and lag() preserve factors", {
  x <- factor(c("a", "b", "c"))

  expect_equal(levels(lead(x)), c("a", "b", "c"))
  expect_equal(levels(lag(x)), c("a", "b", "c"))
})

test_that("lead() and lag() preserves dates and times", {
  x <- as.Date("2013-01-01") + 1:3
  y <- as.POSIXct(x)

  expect_s3_class(lead(x), "Date")
  expect_s3_class(lag(x), "Date")

  expect_s3_class(lead(y), "POSIXct")
  expect_s3_class(lag(y), "POSIXct")
})

test_that("lead() and lag() work for matrices (#5028)", {
  m <- matrix(1:6, ncol = 2)
  expect_equal(lag(m, 1), matrix(c(NA_integer_, 1L, 2L, NA_integer_, 4L, 5L), ncol = 2))
  expect_equal(lag(m, 1, default = NA), matrix(c(NA_integer_, 1L, 2L, NA_integer_, 4L, 5L), ncol= 2))

  expect_equal(lead(m, 1), matrix(c(2L, 3L, NA_integer_, 5L, 6L, NA_integer_), ncol = 2))
  expect_equal(lead(m, 1, default = NA), matrix(c(2L, 3L, NA_integer_, 5L, 6L, NA_integer_), ncol = 2))
})

test_that("lead() and lag() works on data frames", {
  df <- data.frame(x = 1:2, y = 1:2)
  expect_identical(
    lag(df),
    data.frame(x = c(NA, 1L), y = c(NA, 1L))
  )
  expect_identical(
    lead(df),
    data.frame(x = c(2L, NA), y = c(2L, NA))
  )
})

test_that("shift() checks size of default (#5641)", {
  expect_error(shift(1:10, 1, default = integer()))
})

test_that("shift() casts to type of `x`", {
  expect_identical(
    vec_ptype(shift(1:10, 1, default = NA_real_)),
    integer()
  )

  expect_identical(
    vec_ptype(shift(c(1, 2), 1, default = NA_integer_)),
    numeric()
  )
})

test_that("lag(n=0) is no-op", {
  x <- 1:10
  expect_identical(x, lead(x, 0))
  expect_identical(x, lag(x, 0))
  expect_identical(x, shift(x, 0))
})

test_that("shift() errors", {
  expect_snapshot({
    (expect_error(
      lead(1:10, -1)
    ))
    (expect_error(
      lag(1:10, -1)
    ))
    (expect_error(
      lead(1:10, 1:2)
    ))
    (expect_error(
      lag(1:10, 1:2)
    ))

    (expect_error(
      lead(1:10, "a")
    ))
    (expect_error(
      lag(1:10, "a")
    ))
    (expect_error(
      shift(1:10, "a")
    ))

    (expect_error(
      lead(1:10, 1, order_by = 1)
    ))
    (expect_error(
      lag(1:10, 1, order_by = 1)
    ))
    (expect_error(
      shift(1:10, 1, order_by = 1)
    ))

    (expect_error(
      lag(c("1", "2", "3"), default = FALSE)
    ))
    (expect_error(
      lag(c("1", "2", "3"), default = character())
    ))
    (expect_error(
      lag(c("1", "2", "3"), default = c("a", "b"))
    ))

    # lag(ts(1:10))
  })
})
