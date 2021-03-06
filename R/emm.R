#' @title Get marginal effects for model response
#' @name emm
#'
#' @description \code{emm()} is a convenient shortcut to compute the estimated
#'              marginal mean, resp. the marginal effect of the model's response
#'              variable, with all independent variables held constant (at
#'              their \code{\link[sjmisc]{typical_value}}).
#'
#' @inheritParams ggpredict
#'
#' @return A data frame with the marginal effect of the response (\code{predicted}),
#'         \code{std.error} and the confidence intervals \code{conf.low} and
#'         \code{conf.high}. For cumulative link-models, the marginal effect for
#'         each level of the response variable is returned.
#'
#' @details For linear models, the predicted value is the estimated marginal
#'          mean. Else, the predicted value is on the scale of the inverse of
#'          link function.
#'
#'
#' @examples
#' data(efc)
#' fit <- lm(barthtot ~ c12hour + neg_c_7 + c161sex + c172code, data = efc)
#' emm(fit)
#'
#' # Example from ?MASS::polr
#' library(MASS)
#' options(contrasts = c("contr.treatment", "contr.poly"))
#' house.plr <- polr(Sat ~ Infl + Type + Cont, weights = Freq, data = housing)
#' emm(house.plr)
#'
#' @importFrom dplyr select
#' @importFrom purrr map_df
#' @importFrom insight model_info get_data
#' @importFrom sjmisc add_variables round_num typical_value
#' @export
emm <- function(model, ci.lvl = .95, type = c("fe", "re", "fe.zi", "re.zi", "sim", "surv", "cumhaz"), typical = "mean", condition = NULL, ...) {
  # match arguments
  type <- match.arg(type)

  # get model frame
  fitfram <- insight::get_data(model)

  # create data frame
  newdat <- purrr::map_df(fitfram, ~ sjmisc::typical_value(.x, fun = typical))

  # check class of fitted model
  fun <- get_predict_function(model)
  # check model family, do we have count model?
  faminfo <- get_model_info(model)

  # compute predictions here
  preds <-
    select_prediction_method(
      fun,
      model,
      newdat,
      ci.lvl,
      type,
      faminfo,
      ppd = FALSE,
      terms = insight::find_predictors(model, effects = "fixed", component = "conditional", flatten = TRUE),
      typical,
      vcov.fun = NULL,
      vcov.type = NULL,
      vcov.args = NULL,
      condition = condition,
      ...
    )

  # add std.error
  se <- attr(preds, "std.error", exact = TRUE)
  if (!is.null(se)) preds <- sjmisc::add_variables(preds, std.error = se)

  suppressWarnings(
    dplyr::select(
      preds,
      string_one_of(c("predicted", "std.error", "conf.low", "conf.high", "response.level"), colnames(preds))
    ) %>%
      sjmisc::round_num(3)
  )
}
