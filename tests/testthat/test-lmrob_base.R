if (suppressWarnings(
  require("testthat") &&
  require("ggeffects") &&
  require("sjmisc") &&
  require("robustbase")
)) {

  context("ggeffects, lmrob")

  data(efc)
  m1 <- lmrob(neg_c_7 ~ c12hour + e42dep + c161sex + c172code, data = efc)

  test_that("ggpredict, lmrob", {
    pr <- ggpredict(m1, "c12hour")
    expect_equal(pr$predicted[1], 11.02581, tolerance = 1e-4)
  })

  test_that("ggeffect, lmrob", {
    pr <- ggeffect(m1, "c12hour")
    expect_equal(pr$predicted[1], 11.02581, tolerance = 1e-4)
  })

  test_that("ggemmeans, lmrob", {
    expect_error(ggemmeans(m1, "c12hour"))
  })
}
