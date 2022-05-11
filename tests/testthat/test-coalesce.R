test_that("performs vectorised replacement", {
  expect_equal(coalesce(NA, 1:2), 1:2)
  expect_equal(coalesce(c(NA, NA), 1), c(1, 1))
})

test_that("terminates early if no missing", {
  expect_equal(coalesce(1:3, 1:3), 1:3)
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

test_that("must have at least one value", {
  expect_snapshot(error = TRUE, {
    coalesce()
  })
})

test_that("inputs must be vectors", {
  # In particular, disallow `NULL` as an input, which can break the type/size
  # invariant if `.ptype` or `.size` are supplied
  expect_snapshot(error = TRUE, {
    coalesce(NULL)
  })
  expect_snapshot(error = TRUE, {
    coalesce(1, NULL)
  })
  expect_snapshot(error = TRUE, {
    coalesce(1, environment())
  })
})
