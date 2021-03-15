# dplyr ----------------------------------------------------------------------
library(dplyr)
# select, filter, mutate, group_by, summarise, arrange


# Data Handling --------------------------------------------------------------
# ... 1. 변수명 or 문자열 다루기 ----
library(stringr)
# 문제) Iris Data에서 Width라는 키워드가 들어간 변수명 or Index 추출


# 문제) "I have a beautiful house" 다음 문자열의 모든 공백을 "_"로 바꾸시오


# 문제) "I have a beautiful house"을 공백기준으로 단어로 분할 하시오. 


# 문제) 다음데이터 가맹점명 컬럼에서 특정 "커피"라는 단어를 포함한 데이터만 추출하시오. 

# 문제) "커피그루나루"의 모든 2음절 단어를 추출하시오.
#       결과) 커피, 피그, 그루, 루나, 나루




# 문제) 다음 두 변수명의 합집합을 구하시오. 


# ... 2. Sampling ----  

# 문제) 0~100 사이의 uniform 난수를 100개 생성하시오. 

# 문제) lotto number를 생성하시오. 100000번 생성해서 1~45까지의 빈도를 구하시오.


# 문제) IRIS 데이터의 품종별로 2개씩 샘플을 추출하시오.  



# 문제) Down Sampling & Up Sampling. 


# ... 3. Data Transform ----

# 문제) 모든 연속형 변수를 표준화 (평균=0, std=1)하시오. 


# 문제) IRIS Data를 다음처럼 요약하시오. 

#  Species    Petal.Length Petal.Width Sepal.Length Sepal.Width
#  setosa             1.46       0.246         5.01        3.43
#  versicolor         4.26       1.33          5.94        2.77
#  virginica          5.55       2.03          6.59        2.97


# 문제) 범주형 변수를 더미변수화 시키시오. 


# 문제) Join or merge


# 문제) 1000명의 학생에 대한 0~100점까지의 점수를 난수로 생성해서 (정수)
        # 100~80, 79~60 ...으로 수 우 미 양 가 로 그룹화 하시오. 


# 문제) 다음 데이터를 다음처럼 변환하시오. 
#     Name     Likes    Hates
# 1   Boyd 1,2,4,5,6     2;4;
# 2  Rufus 1,2,4,5,6 1;2;3;4;
# 3   Dana 1,2,3,4,5       2;
# 4 Carole 1,2,4,5,6     1;4;
# 5 Ramona   1,2,5,6   1;2;3;
# 6 Kelley   1,2,5,6     1;4;

#      Name     Likes    Hates Likes_1 Likes_2 Likes_3 Likes_4 Likes_5
# 1:   Boyd 1,2,4,5,6     2;4;       1       2       4       5       6
# 2:  Rufus 1,2,4,5,6 1;2;3;4;       1       2       4       5       6
# 3:   Dana 1,2,3,4,5       2;       1       2       3       4       5
# 4: Carole 1,2,4,5,6     1;4;       1       2       4       5       6
# 5: Ramona   1,2,5,6   1;2;3;       1       2       5       6      NA
# 6: Kelley   1,2,5,6     1;4;       1       2       5       6      NA

# splitstackshape Package

# concat.split(temp, 2)



## Split a vector


# 문제) 다음 데이터를 다음처럼 변환하시오. 

# x y count
# a b 3
# b c 2
# c d 2

# x y
# a b
# a b
# a b
# b c
# b c
# c d
# c d


# ... 4. Repeated Action ----

# 문제) 1부터 100까지의 합을 계산하시오. 


# 문제) A부터 Z까지를 모두 "--"로 연결하여 붙이시오. 



# ... 5. Advanced Dplyr ----

# Chain Operator 



# 문제) IRIS 데이터의 품종별 Sepal.Length값을 표준화 하시오. 

      

# 문제) IRIS데이터에서 연속형 변수만 선택하시오. 

# 문제) IRIS 데이터에서 평균이 3.5이상인 변수만 선택하시오. 


# 문제) IRIS 데이터에서 연속형 변수 중에 모든 변수의 값이 4.5보다 작은 행만 추출하시오.



# 문제) IRIS 데이터의 모든 연속형 변수의 값을 x 10 해서 변환하시오. 



# 문제) IRIS 데이터의 모든 연속형 변수의 평균을 구하시오.  



# 문제) Chain Operation 사용법 


# %<>%
      

# ... 6. Time Series ----



# File Handling  --------------------------------------------------------------

# ... 1. 엑셀 다루기 ---- 

# 문제) IRIS 데이터를 Species 기준으로 분리하여 리스트에 저장하시오.


# 문제) 그 리스트를 엑셀에 시트별로 저장하시오. 



# 문제 "ex_temp.xlsx" 엑셀의 특정영역에 IRIS 데이터를 저장하시오.





# ... 2. 화일 다루기 ----

# 문제) 현재 폴더의 모든 화일 이름을 가져 오시오. 



# 문제) 현재 폴더 밑에 a/b/c 형태로 하위 폴더를 만드시오. 


# 문제) 다음 화일들을 모두 읽어와 한꺼번에 아래로 합치시오  
# rbind1.csv, rbind2.csv,  rbind3.csv




# 문제) 다음 화일들을 모두 읽어와 join 하시오



# Modeling & Machine Learning  --------------------------------------------------------------

# 문제) IRIS 데이터를 7:3을 Train과 Validation으로 나누시오. 


# 문제) IRIS 데이터를 4:3:3을 Train, Validation, Test로 나누시오. 



# 함수를 만들어 두고 쓴다는 것.....!!!


