test_that("nth()", {
  expect_identical(first(1:10), 1L)
  expect_identical(nth(1:10, 1), 1L)

  expect_identical(last(1:10), 10L)
  expect_identical(nth(1:10, -1), 10L)
})

test_that("nth() work for data frames", {
  df <- data.frame(x = 1:10, y = 1:10)
  expect_identical(first(df), vec_slice(df, 1))
  expect_identical(last(df), vec_slice(df, 10))
})

test_that("nth() work lists", {
  lst <- list(a = 1, c = data.frame(x = 1))
  expect_identical(first(lst), list(a = 1))
  expect_identical(last(lst), list(c = data.frame(x = 1)))
})

test_that("nth() works for size 0", {
  expect_identical(nth(integer(), 1), NA_integer_)
  expect_identical(first(integer()), NA_integer_)
  expect_identical(last(integer()), NA_integer_)
})

test_that("nth<-()", {
  x <- c(1, 2)
  nth(x, 1) <- 3
  expect_equal(x, c(3, 2))

  nth(x, -1) <- 4
  expect_equal(x, c(3, 4))

  first(x) <- 5
  expect_equal(x, c(5, 4))

  last(x) <- 6
  expect_equal(x, c(5, 6))
})

test_that("nth<-()", {
  x <- data.frame(x = c(1, 2))
  nth(x, 1) <- data.frame(x = c(3))
  expect_equal(x, data.frame(x = c(3, 2)))

  nth(x, -1) <- data.frame(x = c(4))
  expect_equal(x, data.frame(x = c(3, 4)))

  first(x) <- data.frame(x = c(5))
  expect_equal(x, data.frame(x = c(5, 4)))

  last(x) <- data.frame(x = c(6))
  expect_equal(x, data.frame(x = c(5, 6)))
})

test_that("nth() errors", {
  expect_snapshot(error = TRUE, {
    nth(1:10, 12, default = "")
    nth(1:10, c(1, 2))
    nth(1:10, 1.3)

    first(last)

    x <- 1:4
    nth(x, 5) <- 5
    nth(x, -5) <- 5
    nth(x, 1) <- 1:2

    lst <- list(1, 2)
    nth(lst, 1) <- 3:4

    df <- data.frame(x = 1:3)
    first(df) <- data.frame(x = 5:6)
    first(df) <- data.frame(x = "4")
    first(df) <- data.frame(y = 5)
  })
})
