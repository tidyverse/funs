test_that("performs vectorised replacement", {
  expect_equal(coalesce(NA, 1:2), 1:2)
  expect_equal(coalesce(c(NA, NA), 1), c(1, 1))
})

test_that("terminates early if no missing", {
  expect_equal(coalesce(1:3, 1:3), 1:3)
})

test_that("only updates entirely missing matrix rows", {
  x <- c(
    1, NA,
    NA, NA
  )
  x <- matrix(x, nrow = 2, byrow = TRUE)

  y <- c(
    2, 2,
    NA, 1
  )
  y <- matrix(y, nrow = 2, byrow = TRUE)

  expect <- c(
    1, NA,
    NA, 1
  )
  expect <- matrix(expect, nrow = 2, byrow = TRUE)

  expect_identical(coalesce(x, y), expect)
})

test_that("only updates entirely missing data frame rows", {
  x <- data_frame(x = c(1, NA), y = c(NA, NA))
  y <- data_frame(x = c(2, NA), y = c(TRUE, TRUE))

  expect <- data_frame(x = c(1, NA), y = c(NA, TRUE))

  expect_identical(coalesce(x, y), expect)
})

test_that("only updates entirely missing rcrd observations", {
  x <- new_rcrd(list(x = c(1, NA), y = c(NA, NA)))
  y <- new_rcrd(list(x = c(2, NA), y = c(TRUE, TRUE)))

  expect <- new_rcrd(list(x = c(1, NA), y = c(NA, TRUE)))

  expect_identical(coalesce(x, y), expect)
})

test_that("`.ptype` overrides the common type (#64)", {
  x <- c(1L, NA)
  expect_identical(coalesce(x, 99, .ptype = x), c(1L, 99L))
})

test_that("`.size` overrides the common size", {
  x <- 1L

  expect_snapshot(error = TRUE, {
    coalesce(x, 1:2, .size = vec_size(x))
  })
})

test_that("must have at least one non-`NULL` vector", {
  expect_snapshot(error = TRUE, {
    coalesce()
  })
  expect_snapshot(error = TRUE, {
    coalesce(NULL, NULL)
  })
})

test_that("`NULL`s are discarded (#80)", {
  expect_identical(
    coalesce(c(1, NA, NA), NULL, c(1, 2, NA), NULL, 3),
    c(1, 2, 3)
  )
})

test_that("inputs must be vectors", {
  expect_snapshot(error = TRUE, {
    coalesce(1, environment())
  })
})
