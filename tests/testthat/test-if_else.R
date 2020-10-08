test_that("result has expected values", {
  expect_equal(if_else(c(TRUE, FALSE, NA), 1, 2), c(1, 2, NA))
  expect_equal(if_else(c(TRUE, FALSE, NA), 1, 2, 3), c(1, 2, 3))
})

test_that("size comes from condition", {
  expect_vector(if_else(rep(TRUE, 3), 1, 1), size = 3)
})

test_that("ptype come from true/false/na", {
  expect_vector(if_else(TRUE, 1L, 1.5), ptype = double())
  expect_vector(if_else(TRUE, 1.5, 1L), ptype = double())
  expect_vector(if_else(TRUE, 1L, 1L, 1.5), ptype = double())
})

test_that("if_else() errors informatively", {
  expect_snapshot(error = TRUE, {
    if_else(TRUE, 1:3, 1)
    if_else(TRUE, 1, 1:3)
    if_else(TRUE, 1, 1, 1:3)
    if_else(c(TRUE, FALSE), 1:3, 1)

    if_else(1, 1, "2")
  })
})
