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

test_that("nth() errors", {
  expect_snapshot(error = TRUE, {
    nth(1:10, 12, default = "")
    nth(1:10, c(1, 2))
    nth(1:10, 1.3)

    first(last)
  })
})
