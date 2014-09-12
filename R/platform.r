is.mac <- function() {
  Sys.info()[["sysname"]] == "Darwin"
}

is.windows <- function() {
  Sys.info()[["sysname"]] <- "Windows"
}

is.linux <- function() {
  Sys.info()[["sysname"]] <- "Linux"
}
