rm(list=ls())
gc()
gc(reset = T)
# ctrl + l
getwd()
setwd('C:\\Users\\cokei\\Desktop\\R_study')



# 1.데이터 불러오기 ----
# read.csv

system.time(mydata <- read.csv('my_sample.csv', header = TRUE))
head(mydata)
str(mydata)
gc(reset = T)

# fread
library(data.table)
system.time(mydata <- fread('my_sample.csv', header = TRUE))
head(mydata)
str(mydata)


# 2.데이터 정제 ----
# 2.1 NA처리----
table(is.na(mydata))
head(mydata)
str(mydata)

tmp <- lapply(mydata, function(x) gsub('NULL','0',x))
str(tmp)

# tmp_un <- unlist(tmp)
# head(tmp_un)

tmp_df <- as.data.frame(tmp)
head(tmp_df)

mydata <- as.data.frame(lapply(mydata, function(x) gsub('NULL','0',x)))
head(mydata)


# 2.2 class 변환----
str(mydata)

# for
mydata_f <- mydata
length(colnames(mydata_f))

for( i in 3:16 ) {
  mydata_f[,i] <- as.numeric(mydata_f[,i])
}
str(mydata_f)

head(mydata[mydata$V1 == '8367497' , ])


# dplyr
library(dplyr)
mydata_d <- fread('my_sample.csv', header = TRUE)
head(mydata_d)
str(mydata_d)

mydata_d <- mydata_d %>%
  mutate_at(vars(1:2), as.character) %>% 
  mutate_at(vars(3:16), as.numeric)
str(mydata_d)


# na 변환
na_1 <- mydata_d
head(na_1)
na_1[is.na(na_1) == TRUE] <- 0
head(na_1)


# na 제거
na_2 <- mydata_d
na_2 <- na.omit(na_2)
head(na_2)
table(is.na(na_2))
head(mydata_d)

# sapply

mydata[, sapply(mydata, FUN = "is.character") ] = sapply(
  mydata[, sapply(mydata, FUN = "is.character")],
                                                         FUN = "as.numeric")
str(mydata)

mydata$V1 <- as.character(mydata$V1)
mydata$id <- as.character(mydata$id)
str(mydata)



# 2.3 컬럼명 변경----
colnames(mydata)
names(mydata)

base::names(mydata)


# 직접 변경
mydata_c <- mydata
str(colnames(mydata_c))
colnames(mydata_c)[1] <- 'No'
colnames(mydata_c)

# lapply
colnames(mydata) <- unlist(
  lapply(colnames(mydata), function(x) {gsub("tco_btc_3104_", "", x)})
  )
head(mydata)
str(colnames(mydata))
# tmp <- lapply(colnames(mydata), function(x) {gsub("tco_btc_3104_", "", x)})
# str(tmp)

# 2.4 컬럼 추가 삭제----
# 컬럼 삭제
# data.frame
str(mydata)

mydata_col_1 <- mydata[,-1]
head(mydata_col_1)

which(colnames(mydata) == 'V1')

mydata_col_1 <- mydata[, -c(which(colnames(mydata) %in% c('V1','id')))]
head(mydata_col_1)

tmp <- mydata[,-c(1:3)]
head(tmp)

# 두개 컬럼 지우기


# dplyr
mydata_col_2 <- mydata %>% 
  select(-V1)

head(mydata_col_2)


# 컬럼 추가
tmp <- mydata %>% 
  mutate(TARGET = ifelse(re_1m_u_ct > 0 &
                           re_3m_u_ct > 0,1,0)) %>% 
  select(-V1)

head(tmp)

# 컬럼을 순서대로 정렬

mydata <- tmp %>% 
  select(id, TARGET, everything())
head(tmp)

tmp <- tmp %>% 
  select(id, TARGET, everything())
colnames(tmp)
tmp <-tmp %>% 
  select(id, TARGET, everything(), -lt_u_pg_ds)
colnames(tmp)

# lt_u_pg_ds 컬럼을 제외하고, id, TARGET, 나머지 순으로 정렬하기 

# > colnames(tmp)
# [1] "id"                      "TARGET"                  "re_1m_u_ct"              "re_3m_u_ct"              "re_6m_u_ct"             
# [6] "re_12m_u_ct"             "re_24m_u_ct"             "re_1m_u_am"              "re_3m_u_am"              "re_6m_u_am"             
# [11] "re_12m_u_am"             "re_24m_u_am"             "re_1m_tco_btc_2101_u_ct" "re_3m_tco_btc_2101_u_ct" "re_6m_tco_btc_2101_u_ct"


mydata <- tmp %>% 
  select(id, TARGET, everything())

table(mydata$TARGET)
table(mydata$TARGET)[2]/nrow(mydata)



# 데이터 탐색 함수
source('func.R')
class(mydata)

mydata_t <- as.data.table(mydata)
head(mydata_t)
str(mydata_t)

tmp <- FINE_cn_fn(mydata_t, 'TARGET', 're_6m_u_ct' , 0, 1, 0.1 );tmp

cn_var <- names(mydata_t[,-c(1,2)])

bind_result <- NULL
 
for (j in 1:length(cn_var)){
  FINE_cn_fn(mydata_t, y = 'TARGET', x = cn_var[j],
             from = 0.1,
             to = 1,
             by = 0.1)
  bind_result <- rbind(bind_result, result)
  print(j)
}

View(bind_result)


# 3. 그래프 그리기 ----
rm(list= ls())
gc()
gc(reset = T)

library(data.table)
library(dplyr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(scales)


# load data
# dt_1 : 2019년 월별 업종별 이용 실적(횟수)

dt_1 <- fread('현황_2019_00.txt', header = TRUE)
head(dt_1)
str(dt_1)

# dt_2 : 2020년 월별 업종별 이용 실적(횟수)
dt_2 <- fread('현황_2020_00.txt', header = TRUE)
head(dt_1)
str(dt_1)

# dt_3 : 업종 분류 기준
dt_3 <- read.csv('join_sample.csv', header = TRUE)
# head(dt_3)
# str(dt_3)
# dt_3 <- na.omit(dt_3)
dt_3 <- dt_3[-272,]


head(dt_1[1,])

tmp <- melt(dt_1, id.vars = 'TCO_BTC')
str(tmp)

tmp <- tmp %>%
  arrange(TCO_BTC) %>% 
  mutate_at('TCO_BTC', as.character)


dt_4 <- tmp %>%
  left_join(dt_3[,c('TCO_BTC','TCO_BTC_NM')], by = 'TCO_BTC') %>%
  select(TCO_BTC, TCO_BTC_NM, everything())


ggplot(data = dt_4[dt_4$TCO_BTC == '1101',], aes(x = variable, y = value, group = FALSE)) +
  geom_line(color = "firebrick") +
  scale_y_continuous(limits = c(0, max(dt_4[dt_4$TCO_BTC == '1101',]$value+1000)),
                     labels = comma) +
  ggtitle(paste0('특급호텔'," (",unique(dt_4$TCO_BTC)[i],")")) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", color = "steelblue", size = 14),
        axis.text.x = element_text(angle = 50, hjust = 1),
        axis.title = element_blank())


# i <- 1
for (i in 1:nrow(dt_3)){
  grp <- ggplot(data = dt_4[dt_4$TCO_BTC == unique(dt_4$TCO_BTC)[i],], aes(x = variable, y = value, group = FALSE)) +
    geom_line() +
    scale_y_continuous(limits = c(0, max(dt_4[dt_4$TCO_BTC == unique(dt_4$TCO_BTC)[i],]$value+1000)))
  
  assign(paste0('G_',i), grp)
}

p <- list()

# for (i in 1:nrow(dt_3)){
for (i in 1:length(unique(dt_4$TCO_BTC))){
  
  p[[i]] <- ggplot(data = dt_4[dt_4$TCO_BTC == unique(dt_4$TCO_BTC)[i],], aes(x = variable, y = value, group = FALSE)) +
    geom_line(color = "firebrick") +
    scale_y_continuous(limits = c(0, max(dt_4[dt_4$TCO_BTC == unique(dt_4$TCO_BTC)[i],]$value+1000)),
                       labels = comma) +
    ggtitle(paste0(unique(dt_4$TCO_BTC_NM)[i]," (",unique(dt_4$TCO_BTC)[i],")")) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold", color = "steelblue", size = 14),
          axis.text.x = element_text(angle = 50, hjust = 1),
          axis.title = element_blank())
}
p[[2]]


# length(unique(dt_4$TCO_BTC))

t1 <- seq(1,263,20)
t2 <- c(seq(20,263,20),263)

# i <- 1
# do.call(grid.arrange,c(p[c(t1[i]:t2[i])], ncol = round(sqrt(t2[i]-t1[i]))))

# lapply : 각각의 '리스트 요소에' 인수로 받은 '함수를 적용'
# do.call : '함수의 인수에' '리스트의 각각 요소를 제공'

for( i in (1:14)){
  ggsave(paste0('~/grp_19_',i,'.png'), do.call(grid.arrange,c(p[c(t1[i]:t2[i])], nrow = round(sqrt(t2[i]-t1[i])))))
}

