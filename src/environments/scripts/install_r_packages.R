
# Default CRAN repo
local({repos <- getOption("repos")
       repos["CRAN"] <- "https://cloud.r-project.org" 
       options(repos=repos)
})


# Install package for system dependency management
install.packages("rspm")
library(rspm)

rspm::enable()

install.packages(c("devtools", "rjson", "stringi"))

library(rjson)
library(devtools)
library(stringi)

# Read a json list of required packages and install them with ALL SYSTEM DEPENDENCIES.
# Example of package list in `r_packages.json`
install_r_packages <- function(file_name) {
  
  if (!file.exists(file_name)) {
    print("No R packages to install")
    return()
  }
  
  packages <- rjson::fromJSON(file = file_name)
  
  for(package in packages$packages) {
    
    print(paste("Installing ", package$name, "...", sep=''))
    
    package_version <- tolower(stringi::stri_trim_both(package$version))
    if (package_version == "latest") {
      # ref. usage https://www.rdocumentation.org/packages/devtools/versions/1.13.6/topics/install_version
      package_version <- NULL
    } else {
      package$version
    }
    
    devtools::install_version(
      package$name,
      version = package_version
    )
    
  }
}

# Treat first command line argument as file name with dependencies and install requested packages
args <- commandArgs(trailingOnly=TRUE)
install_r_packages(args[1])


