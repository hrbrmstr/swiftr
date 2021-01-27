#' Define an R Function with a Swift Implementation
#'
#' Dynamically define an R function with Swift source code. Compiles and links
#' a shard library with bindings to the Swift function then defines an R function
#' that uses `.Call` to invoke the library.
#'
#' @param code Source code for the Swift function definition.
#' @param env Environment where the R functions and modules should be made available.
#' @param imports Character vector of Swift frameworks to import.
#' @param cache_dir Directory to use for caching shared libraries. The default
#'        value of [tempdir()] results in the cache being valid only for the current
#'        R session. Pass an alternate directory to preserve the cache across R sessions.
#' @note Remember that the function need to be `public` and that you need to put
#'       the required `@@_cdecl ("…")` decorator before the function definition.
#' @export
swift_function <- function(code, env = globalenv(), imports = c("Foundation"), cache_dir = tempdir()) {

  arch <- sprintf("--%s", Sys.info()["machine"])

  swiftc <- Sys.which("swiftc")

  bridging_header <- system.file("include", "swift-r-glue.h", package = "swiftr")

  source_file <- basename(tempfile(fileext = ".swift"))

  module_name <- sprintf("swiftr_%s", digest::digest(code))

  writeLines(
    text = c(
      sprintf("import %s", imports),
      code
    ),
    con =  file.path(cache_dir, source_file)
  )

  wd <- getwd()
  on.exit(setwd(wd))

  setwd(cache_dir)

  stdout <- tempfile(fileext = ".out")
  stderr <- tempfile(fileext = ".err")

  # preflight to get info

  system2(
    command = swiftc,
    args = c(
      "-I/Library/Frameworks/R.framework/Headers",
      "-F/Library/Frameworks",
      "-framework", "R",
      "-import-objc-header", bridging_header,
      "-parseable-output",
      "-print-ast",
      file.path(cache_dir, source_file)
    ),
    stdout = stdout,
    stderr = stderr
  ) -> res

  if (res == 0) {

    stri_replace_all_regex(
      readLines(stderr, warn=FALSE),
      pattern = "^([[:digit:]]+)$",
      replacement = ',"$1":'
    ) -> l
    l[1] <- stri_replace_first_regex(l[1], "^,", "{")
    writeLines(c(l, "}"), stderr)

    preflight <- jsonlite::fromJSON(stderr, simplifyDataFrame = FALSE)

    system2(
      command = swiftc,
      args = c(
        "-I/Library/Frameworks/R.framework/Headers",
        "-F/Library/Frameworks",
        "-framework", "R",
        "-emit-library",
        "-module-name", module_name,
        "-import-objc-header", bridging_header,
        "-parseable-output",
        file.path(cache_dir, source_file)
      ),
      stdout = stdout,
      stderr = stderr
    ) -> res

    if (res == 0) {

      stri_replace_all_regex(
        readLines(stderr, warn=FALSE),
        pattern = "^([[:digit:]]+)$",
        replacement = ',"$1":'
      ) -> l
      l[1] <- stri_replace_first_regex(l[1], "^,", "{")
      writeLines(c(l, "}"), stderr)

      postflight <- jsonlite::fromJSON(stderr, simplifyDataFrame = FALSE)

      code <- unlist(stri_split_lines(preflight[[4]]$output, omit_empty = TRUE))

      func <- grep("^[[:space:]]*public[[:space:]]+func[[:space:]]+", code, value = TRUE)

      stri_match_first_regex(
        str = func,
        pattern = "
          ^[[:space:]]*
          public
          [[:space:]]+
          func
          [[:space:]]+
          ([^\\(]+)
        ",
        opts_regex = stri_opts_regex(comments = TRUE)
      ) -> fname

      fname <- fname[,2]

      params <- stri_replace_first_regex(func, "^[^\\(]+\\(", "")
      params <- stri_replace_last_regex(params, "\\).*$", "")
      params <- stri_replace_all_regex(params, "_[[:space:]]+", "")
      params <- unlist(stri_split_regex(params, ",[[:space:]]*"))
      params <- stri_match_first_regex(params, "([^:]+):")[,2]

      try(dyn.unload(file.path(cache_dir, sprintf("lib%s.dylib", module_name))), silent=TRUE)
      dyn.load(file.path(cache_dir, sprintf("lib%s.dylib", module_name)))

      rsrc_fil <- tempfile(fileext = ".R")

      paste0(c(
        sprintf(
          "%s <- function(%s) {",
          fname,
          ifelse(is.na(params[1]), "", paste0(params, collapse = ", "))
        ),
        sprintf(
          '  .Call("%s"%s%s)',
          fname,
          ifelse(is.na(params[1]), "", ", "),
          ifelse(is.na(params[1]), "", paste0(params, collapse = ", "))
        ),
        "}"),
        collapse = "\n"
      ) -> ƒ

      eval(parse(text = ƒ), envir = env)

      # list(
      #   fname = fname,
      #   params = params,
      #   pre = preflight,
      #   post = postflight
      # )

    } else {

      message("COMPILATION ERROR")

      # cat(readLines(stderr))

    }

  } else {

    message("SYNTAX ERROR")

    # cat(readLines(stderr))

  }

}