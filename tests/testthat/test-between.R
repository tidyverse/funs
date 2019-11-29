test_that("respects bounds", {
  expect_equal(between(1:2, 1, 2, bounds = "[]"), c(TRUE, TRUE))
  expect_equal(between(1:2, 1, 2, bounds = "[)"), c(TRUE, FALSE))
  expect_equal(between(1:2, 1, 2, bounds = "(]"), c(FALSE, TRUE))
  expect_equal(between(1:2, 1, 2, bounds = "()"), c(FALSE, FALSE))

  expect_error(between(1:2, 1, 1, bounds = ""), "`bounds`")
})
