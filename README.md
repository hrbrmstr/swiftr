
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/swiftr.svg?branch=master)](https://travis-ci.org/hrbrmstr/swiftr)
[![Coverage
Status](https://codecov.io/gh/hrbrmstr/swiftr/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/swiftr)
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# swiftr

Seamless R and Swift Integration

## Description

Seamless R and Swift Integration

## What’s Inside The Tin

The following functions are implemented:

-   `add_registration_glue`: This examines a package swift file and
    builds the necessary registration glue code
-   `swift_function`: Define an R Function with a Swift Implementation

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/swiftr.git")
# or
remotes::install_gitlab("hrbrmstr/swiftr")
# or
remotes::install_bitbucket("hrbrmstr/swiftr")
# or
remotes::install_github("hrbrmstr/swiftr")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(swiftr)

# current version
packageVersion("swiftr")
## [1] '0.1.0'
```

``` r
swift_function(
  code = '

func ignored() {
  print("""
this will be ignored by swift_function() but you could use private
functions as helpers for the main public Swift function which will be 
made available to R.
""")
}  

@_cdecl ("read_plist")
public func read_plist(path: SEXP) -> SEXP {
  
  var out: SEXP = R_NilValue
  
  do {
    // read in the raw plist
    let plistRaw = try Data(contentsOf: URL(fileURLWithPath: String(cString: R_CHAR(STRING_ELT(path, 0)))))
  
    // convert it to a PropertyList  
    let plist = try PropertyListSerialization.propertyList(from: plistRaw, options: [], format: nil) as! [String:Any]
    
    // serialize it to JSON
    let jsonData = try JSONSerialization.data(withJSONObject: plist , options: .prettyPrinted)
    
    // setup the JSON string return
    String(data: jsonData, encoding: .utf8)?.withCString { 
      cstr in out = Rf_mkString(cstr) 
    }
    
  } catch {
    debugPrint("\\(error)")
  }
  
  return(out)
  
}
')

read_plist("/Applications/RStudio.app/Contents/Info.plist") %>% 
  jsonlite::fromJSON() %>% 
  str(1)
## List of 32
##  $ CFBundleVersion                      : chr "1.4.1093-1"
##  $ NSPhotoLibraryAddUsageDescription    : chr "R wants write access to the photo library."
##  $ NSHighResolutionCapable              : logi TRUE
##  $ NSCalendarsUsageDescription          : chr "R wants to access calendars."
##  $ CFBundleLongVersionString            : chr "1.4.1093-1"
##  $ NSContactsUsageDescription           : chr "R wants to access contacts."
##  $ CFBundleGetInfoString                : chr "RStudio 1.4.1093-1, © 2009-2020 RStudio, PBC"
##  $ NSPrincipalClass                     : chr "NSApplication"
##  $ NSCameraUsageDescription             : chr "R wants to access the camera."
##  $ NSPhotoLibraryUsageDescription       : chr "R wants to access the photo library."
##  $ CFBundleInfoDictionaryVersion        : chr "6.0"
##  $ NSRemindersUsageDescription          : chr "R wants to access the reminders."
##  $ CFBundleSignature                    : chr "Rstd"
##  $ CFBundleIconFile                     : chr "RStudio.icns"
##  $ LSRequiresCarbon                     : logi TRUE
##  $ LSApplicationCategoryType            : chr "public.app-category.developer-tools"
##  $ CFBundleExecutable                   : chr "RStudio"
##  $ CFBundlePackageType                  : chr "APPL"
##  $ NSAppleScriptEnabled                 : logi TRUE
##  $ CFBundleDocumentTypes                :'data.frame':   16 obs. of  8 variables:
##  $ OSAScriptingDefinition               : chr "RStudio.sdef"
##  $ CSResourcesFileMapped                : logi TRUE
##  $ NSHumanReadableCopyright             : chr "RStudio 1.4.1093-1, © 2009-2020 RStudio, PBC"
##  $ CFBundleDevelopmentRegion            : chr "English"
##  $ CFBundleIdentifier                   : chr "org.rstudio.RStudio"
##  $ NSBluetoothPeripheralUsageDescription: chr "R wants to access bluetooth."
##  $ NSAppleEventsUsageDescription        : chr "R wants to run AppleScript."
##  $ NSLocationWhenInUseUsageDescription  : chr "R wants to access location information."
##  $ CFBundleShortVersionString           : chr "1.4.1093-1"
##  $ NSMicrophoneUsageDescription         : chr "R wants to access the microphone."
##  $ CFBundleName                         : chr "RStudio"
##  $ NSSupportsAutomaticGraphicsSwitching : logi TRUE
```

## swiftr Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
|:-----|---------:|-----:|----:|-----:|------------:|-----:|---------:|-----:|
| R    |        5 | 0.42 | 199 | 0.42 |          69 | 0.36 |       49 | 0.31 |
| Rmd  |        1 | 0.08 |  40 | 0.08 |          27 | 0.14 |       30 | 0.19 |
| SUM  |        6 | 0.50 | 239 | 0.50 |          96 | 0.50 |       79 | 0.50 |

clock Package Metrics for swiftr

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
