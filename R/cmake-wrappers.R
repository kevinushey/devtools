## Wrappers to cmake commands
spaces <- function(n = 2L) {
  paste(rep.int(" ", n), collapse = "")
}

## Generic cmake wrapper
cmake_directive <- function(fn, first = NULL, others = NULL) {
  if (is.null(others)) {
    paste0(fn, "(", paste(first, collapse = " "), ")")
  } else {
    paste0(fn, "(",
           if (!is.null(first)) paste(first, collapse = " "),
           paste(paste("\n", spaces(), others), collapse = ""),
           "\n)")
  }

}

cmake_set <- function(variable, value) {
  cmake_directive("set", variable, value)
}

cmake_project <- function(project) {
  cmake_directive("project", project)
}

cmake_add_library <- function(name, sources, type = "SHARED", exclude_from_all = FALSE) {
  cmake_directive("add_library",
                  c(name, type, if (exclude_from_all) "EXCLUDE_FROM_ALL"),
                  sources)
}

cmake_include_directories <- function(directories) {
  cmake_directive("include_directories", others = directories)
}

cmake_link_directories <- function(directories) {
  cmake_directive("link_directories", others = directories)
}

cmake_link_libraries <- function(libraries) {
  cmake_directive("link_libraries", others = libraries)
}

cmake_add_compile_options <- function(options) {
  cmake_directive("add_compile_options", others = options)
}

cmake_add_definitions <- function(definitions) {
  cmake_directive("add_definitions", others = definitions)
}

cmake_add_custom_target <- function(name, command, dir) {
  cmake_directive("add_custom_target", name, c(
    paste("COMMAND", command),
    paste("WORKING_DIRECTORY", dir)
  ))
}

cmake_file_glob_recurse <- function(name, globs) {
  cmake_directive("file", c("GLOB_RECURSE", name), globs)
}

cmake_file_glob <- function(name, globs) {
  cmake_directive("file", c("GLOB", name), globs)
}

cmake_minimum_required <- function(version, error = "FATAL_ERROR") {
  cmake_directive("cmake_minimum_required", c("VERSION", version, error))
}

cmake_target_link_libraries <- function(target, items) {
  cmake_directive("target_link_libraries", target, others = items)
}

cmake_find_package <- function(package, required = TRUE) {
  first_line <- paste(
    if (required) "REQUIRED"
  )
  cmake_directive("find_package", paste(package, first_line))
}
