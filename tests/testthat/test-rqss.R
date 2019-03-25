if (suppressWarnings(
  require("testthat") &&
  require("ggeffects") &&
  require("quantreg")
)) {

  context("ggeffects, quantreg")

  set.seed(123)
  n <- 200
  x <- sort(rchisq(n, 4))
  z <- exp(rnorm(n)) + x
  y <- log(x) + .1 * (log(x)) ^ 2 + z / 4 +  log(x) * rnorm(n) / 4

  dat <- data.frame(x, y, z)
  m1 <- rqss(y ~ qss(x,constraint="I") + z, data = dat)

  test_that("ggpredict, rq", {
    pr <- ggpredict(m1, "x [.5:13 by=.5]")
    expect_equal(pr$predicted[1], 0.765705, tolerance = 1e-4)
  })
}