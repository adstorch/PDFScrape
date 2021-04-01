# load packages and adjust Java space -----------------------------------------------------------
options(java.parameters = "-Xmx8000m")

packages <- c("tabulizer",
              "stringr")

if (!require(install.load)) {
  install.packages("install.load")
}

install.load::install_load(packages)

# scrape SAR data from CSS Annual Reports *Java must be installed* --------
## path (URL) to the CSS Annual Report file has to be updated mannually as file name conventions are not consistent from report-to-report
cssAnnRep.file <- "https://www.fpc.org/documents/CSS/2019-CSS-Report-Fix.pdf"

## create variables to identify page references (the first two page numbers will have to be updated as new CSS Annual Reports are published *page numbers are not consistent from report-to-report)
sarLGR_CRM.pr <- 459
sarLGR_GRA_agg.pr <- 358
sarLGR_GRA_grr.pr <- sarLGR_GRA_agg.pr+4
sarLGR_GRA_imn.pr <- sarLGR_GRA_grr.pr+2
sarLGR_GRA_sfs.pr <- sarLGR_GRA_imn.pr+2
sarLGR_GRA_mfs.pr <- sarLGR_GRA_sfs.pr+2
sarLGR_GRA_usr.pr <- sarLGR_GRA_mfs.pr+2

## SAR (LGR-Col. R. Mouth) data scraped from CSS Annual Report (e.g., Table B.126 in the 2019 CSS Annual Report)
### extract the table from the pdf stored in the Global Environment
#### in the call, page numbers are identified in variables above (e.g., sarLGR_GRA_agg.pr)
sarLGR_CRM.tbl <- extract_tables(cssAnnRep.file, pages=sarLGR_CRM.pr,output = "data.frame")

### remove extraneous rows and subset columns (migration year and LGR-CRM SARs)
sarLGR_CRM.dat <- head(tail(data.frame(sarLGR_CRM.tbl[[1]]),-2),-2)[,c(1,7)]

### rename field headings
names(sarLGR_CRM.dat) <- c("migYr",
                           "sarLGR_CRM")

### convert SAR values to numeric proportions
sarLGR_CRM.dat$sarLGR_CRM <- as.numeric(str_sub(sarLGR_CRM.dat$sarLGR_CRM,1,4))/100
