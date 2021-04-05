
library(data.table)
library(tidyverse)
library(skimr)

# data table basic --------------------------------------------------------

# dt[i, j, by]
# dt 테이블을 사용
# i 를 사용하여 subset 구성 (where)
# j 를 사용하여 columns 선택 (select)
# by 를 사용하여 그룹화


# create data.table -------------------------------------------------------

dt <- data.table(a = c(1, 2),
                  b = c("a", "b"))

df <- data.frame(a = c(1, 2),
                 b = c("a", "b"))

str(df)
str(dt)

as.data.table(df)
setDT(df)
str(df)


# penguins data 사용 --------------------------------------------------------
# data 가져오기
library(ggplot2)
install.packages('GGally')
library(GGally)
ggpairs(penguins)
remotes::install_github("allisonhorst/palmerpenguins")
library(webshot)
library(palmerpenguins)

webshot(url="https://allisonhorst.github.io/palmerpenguins/", selector = "#meet-the-palmer-penguins > p > img", "fig/penguin-species.png")
webshot(url="https://allisonhorst.github.io/palmerpenguins/", selector = "#bill-dimensions > p > img", "fig/penguin-variable.png")

penguins <- penguins

head(penguins)
summary(penguins)


# data 탐색 -----------------------------------------------------------------

# summary
summary(penguins)
skim(penguins)

# na data 확인
is.na(penguins)

# Q1. na가 있는 펭귄은 제거
# 1) na가 1개라도 있는 행 찾기

# 2) 찾은 행 제거


# Subest rows using i -----------------------------------------------------
penguins_dt <- setDT(copy(penguins))
str(penguins_dt)
skim(penguins_dt)

# 행 번호를 이용하여 subset 추출
penguins_dt[1:2, ]
penguins_dt[species == 'Adelie', ]

# i 에서 사용할 수 있는 논리 연산자
# "<", "<=", ">", ">="
# "!", "is.na()", "!is.na()", "%in%" 
# "|", "&", "%like%", "%between%"

penguins_dt[species == 'Adelie' & 
              sex == 'male', ]

# j를 이용한 columns 선택 -------------------------------------------------------

penguins[,2]
penguins[,-2]
penguins_dt[,c(2, 3)]
penguins_dt[,-c(2, 3)]
penguins_dt[,c("bill_length_mm", "bill_depth_mm")]
penguins_dt[,-c("bill_length_mm", "bill_depth_mm")]
penguins_dt[,.(bill_length_mm, bill_depth_mm)]

## summary
penguins_dt[,mean(bill_length_mm)]
penguins_dt[,.(mean(bill_length_mm))]
penguins_dt[,.(mean = mean(bill_length_mm))]
penguins_dt[,.(sum = sum(bill_length_mm))]
penguins_dt[,.(mean = mean(bill_length_mm),
               sum = sum(bill_length_mm))]

# 컬럼간 계산 및 생성
penguins_dt[, bill_length_mean := mean(bill_length_mm, na.rm = T)]

# 동시에 여러 컬럼 생성
# 1)
penguins_dt[,`:=` (bill_depth_mm_mean = mean(bill_depth_mm, na.rm = T), 
                   flipper_length_mean = mean(flipper_length_mm, na.rm = T))]
# 2)
penguins_dt[,c("bill_depth_mean", "flipper_depth_mean") := .(mean(bill_depth_mm),
                                                             mean(flipper_length_mm))]

# 3)
nm <- c("bill_depth_mean", "flipper_depth_mean")
penguins_dt[,nm := .(mean(bill_depth_mm),
                     mean(flipper_length_mm))]

# 여러 컬럼을 사용하여 생성
penguins_dt[,island_sex := paste(island, sex, sep = "_") %>% 
              as.factor()]

# 일부 컬럼 변경
penguins_dt[1, sex := 'female']
penguins_dt[1, sex := 'male']

# 컬럼 삭제
penguins_dt[,island_sex:=NULL]
penguins_dt[,`:=` (bill_length_mean = NULL, 
                   bill_depth_mm_mean = NULL,
                   flipper_length_mean = NULL)]

# 컬럼 type 변경
# 'as.integer', 'as.numeric', 'as.character', 'as.Data' 
str(penguins_dt)
penguins_dt[,year := as.factor(year)]
str(penguins_dt)


# Q2. 펭귄종류에 따라 'bill_length_mm', 'bill_depth_mm', 'flipper_length_mm' 의 평균을 계산하고 출력하시오
# 아래와 같이 출력
# species bill_length_mean bill_length_sd bill_depth_mean bill_depth_sd flipper_length_mean flipper_length_sd
# 1:    Adelie         38.82397       2.662597        18.34726      1.219338            190.1027          6.521825
# 2:    Gentoo         47.56807       3.106116        14.99664      0.985998            217.2353          6.585431
# 3: Chinstrap         48.83382       3.339256        18.42059      1.135395            195.8235          7.131894

species <- penguins_dt[,species %>% unique]
copy_penguins_dt <- copy(penguins_dt)

result <- data.table()

for (sp in species) {

}
result


# Group according to by ---------------------------------------------------

penguins_dt[,mean(bill_length_mm), by = .(species)]
penguins_dt[,bill_length_mean := mean(bill_length_mm), by = .(species)]

penguins_dt[,`:=` (bill_depth_mean = mean(bill_depth_mm),
                   flipper_depth_mean = mean(flipper_length_mm)),
            by = .(species)]

penguins_dt[,mean(bill_length_mean), by=.(body_mass_g >= 4000, species)]
penguins_dt %>% setcolorder(c("species", "island", "sex", "year"))
penguins_dt
penguins_dt[,length(bill_length_mean), by = .(species:year)]


# Q2. 펭귄종류, 성별에 따라 'bill_length_mm', 'bill_depth_mm', 'flipper_length_mm' 의 min, mean, max를 가지는 테이블을 만드시오
#     'bill_length_min', 'bill_length_mean', 'bill_length_median', 'bill_length_max'와 같이생성

# species    sex   species bill_length_min bill_length_mean bill_length_max bill_depth_min bill_depth_mean
# 1:    Adelie female    Adelie            32.1         37.25753            42.2           15.5        17.62192
# 2:    Adelie   male    Adelie            34.6         40.39041            46.0           17.0        19.07260
# 3:    Gentoo female    Gentoo            40.9         45.56379            50.5           13.1        14.23793
# 4:    Gentoo   male    Gentoo            44.4         49.47377            59.6           14.1        15.71803
# 5: Chinstrap female Chinstrap            40.9         46.57353            58.0           16.4        17.58824
# 6: Chinstrap   male Chinstrap            48.5         51.09412            55.8           17.5        19.25294
# bill_depth_max flipper_length_min flipper_length_mean flipper_length_max
# 1:           20.7                172            187.7945                202
# 2:           21.5                178            192.4110                210
# 3:           15.5                203            212.7069                222
# 4:           17.3                208            221.5410                231
# 5:           19.4                178            191.7353                202
# 6:           20.8                187            199.9118                212

copy_penguins_dt <- copy(penguins_dt)

result <- data.table()

for (sp in species) {

}
# Join table --------------------------------------------------------------

penguins_info <- data.table(species = c('Adelie', 'Gentoo', 'Chinstrap', 'etc'),
                            species_a = c('Adelie', 'Gentoo', 'Chinstrap', 'etc'),
                            korean = c('아델리 펭귄', '전투 펭귄', '턱끈 펭귄', 'etc'),
                            info = c('각진 머리와 작은 부리 때문에 알아보기 쉽다.',
                                     '머리에 모자처럼 둘러져 있는 하얀 털 때문에 알아보기가 쉽다.',
                                     '목에서 머리 쪽으로 이어지는 검은 털이 눈에 띈다.',
                                     'etc'))

penguins_info[penguins_dt, on=.(species)]

penguins_dt[penguins_info,, 
            on = .(species)]

penguins_info[penguins_dt[,.(species, island, sex)], on = .(species)]
penguins_info[penguins_dt[,.(species, island, sex)], on = .(species_a = species)]
            

# Advanced ----------------------------------------------------------------

# .N, .SD, .I, .GRP, .BY

# number of last row (.N)
penguins_dt[.N]
penguins_dt[, .N]
penguins_dt[, .N, by=.(species)]
penguins_dt[, group_ID := seq_len(.N), by=.(species)]

# grouping_number (.I)
penguins_dt[,.I]
penguins_dt[,.I[1], by=.(species)]

# Subset of Data (.SD)
penguins_dt[,.SD]
penguins_dt[,.SD[1]]
penguins_dt[,.SD[[1]]]
penguins_dt[,.SD, .SDcols = c('island', 'sex')]
penguins_dt[,.SD, .SDcols =! c('island', 'sex')]
penguins_dt[,lapply(.SD, min)), 
.SDcols = c('bill_length_mm', 'bill_depth_mm', 'flipper_length_mm')]

penguins_dt[,lapply(.SD, function(x) return(list(min = min(x), mean = mean(x), max = max(x)))) %>% unlist() %>% as.list(), 
            .SDcols = c('bill_length_mm', 'bill_depth_mm', 'flipper_length_mm'),
            by = .(species:sex)]

# Group number (.GRP)
penguins_dt[,grp := .GRP, by=species]

# .BY 
penguins_dt[,switch(.BY[[1]] %>% as.character(),
                    'Adelie' = 'A',
                    'Chinstrap' = 'G',
                    'Gentoo' = 'C'), by=.(species)]

