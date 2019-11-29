test_that("arguments passed along to sample.int()", {
  w <- c(0.5, 0.25, 0.25)
  x <- withr::with_seed(1014, sample(1:3, 5, replace = TRUE, w = w))
  y <- withr::with_seed(1014, base::sample(1:3, 5, replace = TRUE, prob = w))
  expect_equal(x, y)
})
