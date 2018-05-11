#' Convert a Unix time to a timestamp
#'
#' @param posix a vector of integer numbeer of seconds since Unix Epoch
#'
#' @return a POSIXct object
#' @export
#'
#' @examples
#' fromUnixTime(1501668000)
#'
fromUnixTime <- function(posix) {
  as.POSIXct(posix, origin = "1970-01-01", tz = "UTC")
}


#' Template for retrieving data from PRU databases
#'
#' You have to look at the code, save it as your own function with your own
#' SQL query and details.
#' It uses the following packages:
#' * `ROracle` (and hence `DBI`);
#' * `parsedate` as an example to parse input datetime params
#' * `withr` to manage locally set environment variables
#' * `tibble` to return a nice dataframe
#' Change according to your needs.
#'
#' @param wef start date[time], i.e. '2018-01-23 15:34'
#' @param til end date[time] (excluded)
#'
#' @return a tibble of data
#' @export
#'
#' @examples
#' \dontrun{
#' retrieve_data_from_db('2018-01-23 15:34', '2018-01-25')
#' }
retrieve_data_from_db <- function(wef, til) {


  # DB parameters from environment variables.
  # YMMV, for other possibilities see
  # http://db.rstudio.com/best-practices/managing-credentials/
  usr <- Sys.getenv("PRU_DEV_USR")
  pwd <- Sys.getenv("PRU_DEV_PWD")
  dbn <- Sys.getenv("PRU_DEV_DBNAME")

  # interval of interest
  wef <- parsedate::parse_iso_8601(wef)
  til <- parsedate::parse_iso_8601(til)

  # NOTE: for real code you should perform a semantic check on the dates,
  #       i.e. verify that `wef < til`

  # format timestamp for Oracle
  wef <- format(wef, format = "%Y-%m-%dT%H:%M:%SZ")
  til <- format(til, format = "%Y-%m-%dT%H:%M:%SZ")


  # NOTE: to be set before you create your ROracle connection!
  # See http://www.oralytics.com/2015/05/r-roracle-and-oracle-date-formats_27.html
  tz <- "UTC"

  # set `TZ` and `ORA_SDTZ` environment variables witin the scope of the function
  withr::local_envvar(c("TZ" = tz, "ORA_SDTZ" = tz))

  # This is for Oracle, in case of other DB, change accordingly.
  drv <- DBI::dbDriver("Oracle")
  con <- ROracle::dbConnect(drv, usr, pwd, dbname = dbn)

  # Note: use TO_DATE() for passing timestamps in the right format.
  sqlq_flows <- "SELECT TO_CHAR(F.LOBT, 'YYYY') AS YEAR,
      COUNT(FLT_UID) NB_OF_FLIGHT,
      A1.EC_ISO_CT_CODE DEP_ISO_COUNTRY_CODE,
      A2.EC_ISO_CT_CODE DES_ISO_COUNTRY_CODE
    FROM SWH_FCT.FAC_FLIGHT F,
      SWH_FCT.DIM_AIRPORT A1,
      SWH_FCT.DIM_AIRPORT A2,
      SWH_FCT.DIM_AIRCRAFT_TYPE AC
    WHERE
      A1.SK_AP_ID = F.SK_ADEP_ID
      AND A2.SK_AP_ID   = F.SK_ADES_ID
      AND F.LOBT       >= TO_DATE(?WEF, 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')
      AND F.LOBT        < TO_DATE(?TIL, 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')
      AND (A1.EC_ISO_CT_CODE != '##' AND A2.EC_ISO_CT_CODE != '##')
      AND F.AIRCRAFT_TYPE_ICAO_ID = AC.ICAO_TYPE_CODE
      AND (F.ICAO_FLT_TYPE != 'M')
      AND SUBSTR(AC.ICAO_DESC,1,1) != 'H'
    GROUP BY A1.EC_ISO_CT_CODE,
      A1.ISO_CT_CODE,
      A2.EC_ISO_CT_CODE,
      TO_CHAR(F.LOBT,'YYYY')"

  # safe interpolation of SQL strings.
  query_flows <- DBI::sqlInterpolate(con, sqlq_flows, WEF = wef, TIL = til)

  # send the query to the DB...
  fltq  <- ROracle::dbSendQuery(con, query_flows)
  # ...and retrieve all (`n = -1`) the rows
  flows <- ROracle::fetch(fltq, n = -1)
  flows <- tibble::as_tibble(flows)

  # close the connection with the DB
  ROracle::dbDisconnect(con)

  return(flows)
}
