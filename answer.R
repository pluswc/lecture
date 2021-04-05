
library(data.table)
library(tidyverse)
library(skimr)


# Q1. na가 있는 펭귄은 제거
# 1) na가 1개라도 있는 행 찾기
idx <- is.na(penguins) %>% 
  apply(1, sum)
idx > 0
which(idx == 0)
# 2) 찾은 행 제거


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
  result <- rbind(result, copy_penguins_dt[species == sp,
                                           .(species = species[1],
                                             bill_length_mean = mean(bill_length_mm),
                                             bill_length_sd = sd(bill_length_mm),
                                             bill_depth_mean = mean(bill_depth_mm),
                                             bill_depth_sd = sd(bill_depth_mm),
                                             flipper_length_mean = mean(flipper_length_mm),
                                             flipper_length_sd = sd(flipper_length_mm))])
}
result

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
  result <- rbind(result, copy_penguins_dt[species == sp,
                                           .(species = species[1],
                                             bill_length_min = min(bill_length_mm),
                                             bill_length_mean = mean(bill_length_mm),
                                             bill_length_max = max(bill_length_mm),
                                             
                                             bill_depth_min = min(bill_depth_mm),
                                             bill_depth_mean = mean(bill_depth_mm),
                                             bill_depth_max = max(bill_depth_mm),
                                             
                                             flipper_length_min = min(flipper_length_mm),
                                             flipper_length_mean = mean(flipper_length_mm),
                                             flipper_length_max = max(flipper_length_mm)),
                                           by = .(species, sex)])
}
