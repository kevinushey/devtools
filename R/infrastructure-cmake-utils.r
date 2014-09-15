as_cmake_env <- function(name, pkg) {
  paste0("${", toupper(pkg$package), "_", toupper(name), "}")
}

base_cmake_directives <- function(pkg) {
  list(
    cmake_minimum_required = "VERSION 2.8 FATAL_ERROR",
    project = pkg$package
  )
}

package.file <- function(..., package, mustWork = TRUE) {
  result <- setNames(vapply(package, FUN.VALUE = character(1), function(pkg) {
    system.file(..., package = pkg, mustWork = mustWork)
  }), package)
  result[result != ""]
}

cmake_if <- function(platform, code) {
  c(
    paste0("if (", platform, ")"),
    paste0("  ", gsub("\n", "\n  ", code)),
    "endif()"
  )
}

make_directives <- function(list, collapse = FALSE) {
  output <- character(length(list))
  for (i in seq_along(list)) {
    output[[i]] <- paste0(
      names(list)[[i]],
      if (collapse) "(" else "(\n  ",
      paste(list[[i]], collapse = if (collapse) " " else "\n  "),
      if (collapse) ")\n" else "\n)\n"
    )
  }
  output
}

make_file_directive <- function(manipulation, variable, exprs) {
  paste0(
    "file(",
    manipulation, " ",
    variable, "\n  ",
    paste(exprs, collapse = "\n  "),
    "\n)"
  )
}

make_library_directive <- function(name, link, vec) {
  paste0(
    "add_library(",
    name, " ",
    link, "\n  ",
    paste(vec, collapse = "\n  "),
    "\n)\n"
  )
}

make_exe_directive <- function(name, vec) {
  paste0(
    "add_executable(",
    name, "\n  ",
    paste(vec, collapse = "\n  "),
    "\n)\n"
  )
}

add_custom_target <- function(target, command, dir) {
  paste0(
    "add_custom_target(", target,
    "\n  ", "COMMAND ", command,
    "\n  ", "WORKING_DIRECTORY ", dir,
    "\n)"
  )
}

make_set_directives <- function(list) {
  output <- character(length(list))
  for (i in seq_along(list)) {
    output[[i]] <- paste0(
      "set(",
      names(list)[[i]],
      "\n  ",
      paste(list[[i]], collapse = "\n  "),
      "\n)\n"
    )
  }
  output
}
