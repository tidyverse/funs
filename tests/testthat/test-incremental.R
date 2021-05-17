test_that("incremental_*()", {
  batman <- c(NA, NA, NA, NA, NA)
  expect_true(all(is.na(incremental_all(batman))))
  expect_true(all(is.na(incremental_any(batman))))

  # normal usecases
  expect_identical(
    incremental_all(c(TRUE, NA, FALSE, NA)),
    c(TRUE, NA, FALSE, FALSE)
  )

  expect_identical(
    incremental_all(c(FALSE, NA, TRUE)),
    c(FALSE, FALSE, FALSE)
  )

  expect_identical(
    incremental_all(c(NA, TRUE)),
    c(NA, NA)
  )

  expect_identical(
    incremental_all(c(NA, FALSE)),
    c(NA, FALSE)
  )

  expect_identical(
    incremental_any(c(TRUE, NA, FALSE)),
    c(TRUE, TRUE, TRUE)
  )

  expect_identical(
    incremental_any(c(FALSE, NA, TRUE)),
    c(FALSE, NA, TRUE)
  )

  # scalars
  expect_true(is.na(incremental_all(NA)))
  expect_true(is.na(incremental_any(NA)))
  expect_true(incremental_all(TRUE))
  expect_false(incremental_all(FALSE))
  expect_true(incremental_any(TRUE))
  expect_false(incremental_any(FALSE))

  # degenerate cases
  expect_identical(
    incremental_all(logical()),
    logical()
  )

  expect_identical(
    incremental_any(logical()),
    logical()
  )

  # behaviour of degenerate logical vectors mimics that of base R functions
  x <- as.raw(c(2L, 9L, 0L))
  class(x) <- "logical"
  expect_identical(incremental_all(x), x == TRUE)
  expect_identical(incremental_any(x), c(TRUE, TRUE, TRUE))
})

test_that("incremental_*() errors", {
  expect_snapshot(error = TRUE, {
    incremental_all(1)
    incremental_any(1)
  })
})
