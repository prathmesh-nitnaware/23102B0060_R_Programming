# ------------------------------------------------------------------
# Synthetic stand-in for the UCI Online Retail dataset.
# ONLY used to test the pipeline when the real dataset is unavailable.
# Same columns as the real data. NOT for your final submission results.
# ------------------------------------------------------------------
generate_synthetic_retail <- function(n_customers = 3000, seed = 42) {
  set.seed(seed)
  # latent behaviour groups: share, invoices/yr, items/invoice, price, recency scale (days)
  grp <- data.frame(
    share = c(0.10, 0.30, 0.35, 0.25),
    inv   = c(25, 7, 3, 1.3),
    items = c(14, 9, 7, 5),
    price = c(3.5, 3.0, 2.8, 3.2),
    rec   = c(15, 60, 120, 250)
  )
  g <- sample(1:4, n_customers, replace = TRUE, prob = grp$share)
  start <- as.POSIXct("2010-12-01 08:00:00", tz = "UTC")
  end   <- as.POSIXct("2011-12-09 17:00:00", tz = "UTC")
  rows <- vector("list", n_customers)
  for (i in seq_len(n_customers)) {
    p <- grp[g[i], ]
    n_inv <- max(1, rpois(1, p$inv))
    last  <- end - as.numeric(rexp(1, 1 / p$rec)) * 86400
    last  <- max(last, start + 86400)
    dts   <- sort(start + runif(n_inv) * as.numeric(difftime(last, start, units = "secs")))
    inv_ids <- paste0(sample(500000:580000, n_inv))
    rows[[i]] <- do.call(rbind, lapply(seq_len(n_inv), function(j) {
      k <- max(1, rpois(1, p$items))
      data.frame(
        InvoiceNo = inv_ids[j],
        StockCode = sample(paste0("2", 1000:1400), k, replace = TRUE),
        Description = "SYNTHETIC ITEM",
        Quantity = pmax(1, round(rlnorm(k, log(6), 0.8))),
        InvoiceDate = dts[j],
        UnitPrice = round(rlnorm(k, log(p$price), 0.5), 2),
        CustomerID = 12000 + i,
        Country = sample(c("United Kingdom","Germany","France","EIRE"), 1, prob = c(.9,.04,.03,.03)),
        stringsAsFactors = FALSE)
    }))
  }
  df <- do.call(rbind, rows)
  can <- sample(nrow(df), round(0.02 * nrow(df)))
  df$InvoiceNo[can] <- paste0("C", df$InvoiceNo[can]); df$Quantity[can] <- -df$Quantity[can]
  df$CustomerID[sample(nrow(df), round(0.25 * nrow(df)))] <- NA
  bad <- sample(nrow(df), 200); df$UnitPrice[bad] <- 0
  df$StockCode[sample(nrow(df), 100)] <- "POST"
  dup <- df[sample(nrow(df), 500), ]; df <- rbind(df, dup)
  df[order(df$InvoiceDate), ]
}
