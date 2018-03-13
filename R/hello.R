# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


comp_env <- list2env(list(completer=NULL), parent = emptyenv());



.onAttach <- function(libname, pkgname){

  if(requireNamespace("utils", quietly = FALSE)){
    comp_env$completer <- utils::rc.getOption("custom.completer")


    rc.options("custom.completer"= DDcompletor)

  }
  if(requireNamespace("DeclareDesign", quietly = FALSE)){
    DeclareDesign::declare_design # suppresses NOTES
  }
  else {
    warning("Could not find DeclareDesign package - you may want to install it or detach ddcomplete")
  }

}


.onDetach <- function(libPath){
  rc.options(custom.completer = comp_env$completer)
}

# Sneaks around import checks ? see also jimhest/completeme on github
complete_token <- get(".completeToken", asNamespace("utils"))



DDcompletor <- function(CompletionEnv){

  on.exit(    rc.options("custom.completer"= DDcompletor) )
  rc.options(custom.completer=comp_env$completer)
  ret <- complete_token() #fills in CompletionEnv data




  if(is.character(CompletionEnv$fguess) && length(CompletionEnv$fguess) > 0 && !any(grepl("handler", CompletionEnv$linebuffer))){
    FUN <- get0(CompletionEnv$fguess, asNamespace("DeclareDesign"), mode = "function")

    if(is.function(FUN) && inherits(FUN, "declaration")){

      h <- eval(formals(FUN)$handler, environment(FUN))

      h <- union(names(formals(FUN)), names(formals(h)))

      h <- setdiff(h, "data")


      CompletionEnv$comps = paste0(h, "=")

      ## TODO port to startsWith
      if(length(CompletionEnv$token) == 1 && nchar(CompletionEnv$token) > 0){
        w <- regexpr(CompletionEnv$token, h) == 1
        if(sum(w) == 1) {
          CompletionEnv$comps = h[w]

          return(h[w])

        }
      }

      return(h)
    }
  }

  ret
}



