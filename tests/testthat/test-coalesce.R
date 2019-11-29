test_that("empty call returns NULL", {
  expect_equal(coalesce(), NULL)
})

test_that("performs vectorised replacement", {
  expect_equal(coalesce(NA, 1:2), 1:2)
  expect_equal(coalesce(c(NA, NA), 1), c(1, 1))
})

test_that("terminates early if no missing", {
  expect_equal(coalesce(1:3, 1:3), 1:3)
})
