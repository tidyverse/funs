test_that("respects bounds", {
  expect_equal(between(1:2, 1, 2, bounds = "[]"), c(TRUE, TRUE))
  expect_equal(between(1:2, 1, 2, bounds = "[)"), c(TRUE, FALSE))
  expect_equal(between(1:2, 1, 2, bounds = "(]"), c(FALSE, TRUE))
  expect_equal(between(1:2, 1, 2, bounds = "()"), c(FALSE, FALSE))
})

test_that("casts `left` and `right` to the type of `x` (#74)", {
  expect_snapshot(error = TRUE, {
    between(1L, 1.5, 2L)
  })
  expect_snapshot(error = TRUE, {
    between(1L, 1L, 2.5)
  })
})

test_that("recycles `left` and `right` to the size of `x` (#74)", {
  expect_snapshot(error = TRUE, {
    between(1:3, 1:2, 1L)
  })
  expect_snapshot(error = TRUE, {
    between(1:3, 1L, 1:2)
  })
})

test_that("propagates missing values in any input", {
  na <- NA_integer_
  expect_identical(between(na, 1L, 2L), NA)
  expect_identical(between(1L, na, 2L), NA)
  expect_identical(between(1L, 1L, na), NA)
})

test_that("can be vectorized along `left` and `right`", {
  expect_identical(between(1:2, c(0L, 4L), 5L), c(TRUE, FALSE))
  expect_identical(between(1:2, 0L, c(0L, 3L)), c(FALSE, TRUE))
})

test_that("validates `bounds`", {
  expect_snapshot(error = TRUE, {
    between(1:2, 1, 1, bounds = "")
    between(1:2, 1, 1, bounds = 1)
  })
})

test_that("dots must be empty", {
  expect_snapshot(error = TRUE, {
    between(1, 0, 1, "[]")
  })
})
