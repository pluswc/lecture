
FINE_cn_fn <- function(df, y, x, from, to, by){
  
  # df <- as.data.table(mydata)
  # y <- 'TARGET'
  # x <- 're_6m_u_ct'
  # from <- 0
  # to <- 1
  # by <- 0.1

  
  cuts <- unique(as.numeric(quantile(df[, x, with = F], prob = seq(from, to, by), na.rm = T)))
  
  n <- length(cuts)
  
  tb <- data.frame(matrix(ncol = 14, nrow = n+2))
  
  names(tb) <- c("Cutpoint", "CntRec", "CntGood", "CntBad", "CntCumRec", "CntCumGood",
                 "CntCumBad","PctRec","GoodRate","BadRate","Odds","GBindex", "CTI", "IV")
  
  bins <- vector("character", length = n)
  
  for(i in 1:n){
    bins[i] <- paste("<=", cuts[i], sep = " ")
  }
  
  tb$Cutpoint <- c(bins, "Missing", "Total")
  
  tmp <- 0
  
  for(i in 1:n){
    # i <- 1
    # i <- 2
    tb$CntCumRec[i] <- df[df[[x]] <= cuts[i], .N]
    tmp <- df[df[[x]] <= cuts[i], .N, y]
    
    if(nrow(tmp) == 2){
      tb$CntCumBad[i] <- tmp[tmp[[y]] == 0]$N
      tb$CntCumGood[i] <- tmp[tmp[[y]] == 1]$N
    }
    else if(tmp[, y, with = F] == 1){
      tb$CntCumBad[i] <- 0
      tb$CntCumGood[i] <- tmp[tmp[[y]] == 1]$N
    }
    else if(tmp[, y, with = F] == 0){
      tb$CntCumBad[i] <- tmp[tmp[[y]] == 0]$N
      tb$CntCumGood[i] <- 0
    }
  }

# Missing Value
  # NA 수를 Missing 행에 채워 넣기
  tb$CntRec[n+1] <- sum(is.na(df[, x, with = F]))
  
  # NA가 있다면, Good 수를 카운트하여 Missing 행에 채워넣기
  tb$CntGood[n+1] <- df[which(is.na(df[ , x, with = F])), .N, y][1]$N
  
  # NA가 있다면, Bad수를 카운트하여 Missing 행에 채워넣기
  tb$CntBad[n+1] <- df[which(is.na(df[ ,x, with = F])), .N, y][2]$N
  
  #  첫번째 구간의 누적 건수, 누적 Good 수, 누적 Bad 수는 첫번째 구간의 값과 동일하므로  tb에 채워넣음
  
  tb[1,2] <- tb[1,5]
  tb[1,3] <- tb[1,6]
  tb[1,4] <- tb[1,7]
  
  # 두번째 구간 부터는 전 구간의 누적 건수, 누적 Good 건수, 누적 bad 수를 빼서 해당 구간의 건수 구함
  
  for (i in 2:n){
    tb[i,2] <- tb[i,5] - tb[i-1, 5]
    tb[i,3] <- tb[i,6] - tb[i-1, 6]
    tb[i,4] <- tb[i,7] - tb[i-1, 7]
  }
  
  # Missing 행에 누적 건수 채워넣기
  for (i in 1:3){
    tb[n+1, i+4] <- sum(tb[n+1, i+1], tb[n, i+4], na.rm = T)
  }
  
  # Total 행 값 채우기
  for(i in 1:3){
    tb[n+2, i+1] <- sum(tb[, i+1], na.rm = T)
  }
  
  tb[n+2, 5:7] <- tb[n+1, 5:7]
  
  # 각 구간 비율
  tb[, 8] <- round(tb[, 2]/tb[n+2, 5], 4)
  
  # 각 구간 Good 구성비
  tb[, 9] <- round(tb[, 3]/tb[n+2, 6], 4)
  
  # 각 구간 Bad 구성비
  tb[, 10] <- round(tb[, 4]/tb[n+2, 7], 4)
  
  # Odds
  tb[, 11] <- round(tb[, 3] / tb[, 4], 4)
  
  # GBindex
  G <- tb[, 9]
  B <- tb[, 10]
  
  tb[, 12] <- ifelse(G/B > 1, paste(round(G/B*100,2),"G", sep=""),
                     paste(round(G/B*100,2),"B", sep=""))
  
  # CTI
  tb[, 13] <- round(log(tb[, 10]/tb[, 9]) * (tb[, 10]- tb[, 9]), 4)
  
  # round(log(tb[, 10]/tb[, 9]) * (tb[, 10]- tb[, 9]), 4)
  # 0.7072/0
  
  # IV
  tb[is.infinite(tb[, 13]), 13] <- NA
  
  tb[, 14] <- sum(tb[, 13], na.rm = T)
  
  variable <- rep(x, each = n+2)
  
  result <- cbind(variable, tb)
  
  # Missing Value가 없으면 Missing 행과 Total 행 제거
  if(result[n+1, 3] == 0){
    result1 <- result[-((n+1):(n+2)), ]
    assign("result", result1, envir = .GlobalEnv)
  }
  
  # Missing Value가 있는 경우 Total 행만 제거
  else if(result[n+1, 3] != 0) {
    result2 <- result[-(n+2), ]
    assign("result", result2, envir = .GlobalEnv)
  }
}

