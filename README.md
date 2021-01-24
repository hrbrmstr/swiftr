
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/swiftr.svg?branch=master)](https://travis-ci.org/hrbrmstr/swiftr)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# swiftr

Seamless R and Swift Integration

## Description

eamless R and Swift Integration

## What’s Inside The Tin

The following functions are implemented:

-   `add_registration_glue`: This examines a package swift file and
    builds the necessary registration glue code

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/swiftr.git")
# or
remotes::install_gitlab("hrbrmstr/swiftr")
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

## swiftr Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
|:-----|---------:|-----:|----:|-----:|------------:|-----:|---------:|-----:|
| R    |        3 | 0.38 |  87 | 0.46 |          32 | 0.34 |       15 | 0.17 |
| Rmd  |        1 | 0.12 |   8 | 0.04 |          15 | 0.16 |       28 | 0.33 |
| SUM  |        4 | 0.50 |  95 | 0.50 |          47 | 0.50 |       43 | 0.50 |

clock Package Metrics for swiftr

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
