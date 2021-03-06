get_predictions_glmRob <- function(model, fitfram, ci.lvl, linv, typical, fun, terms, vcov.fun, vcov.type, vcov.args, condition, ...) {
  # does user want standard errors?
  se <- !is.null(ci.lvl) && !is.na(ci.lvl) && is.null(vcov.fun)

  # for models from "robust"-pkg (glmRob) we need to
  # suppress warnings about fake models
  prdat <-
    suppressWarnings(stats::predict(
      model,
      newdata = fitfram,
      type = "link",
      se.fit = se,
      ...
    ))

  # copy predictions
  get_base_fitfram(model, fitfram, linv, prdat, se, ci.lvl, fun, typical, terms, vcov.fun, vcov.type, vcov.args, condition)
}
