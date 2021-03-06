
## set your working directory to the local difrectory where you have PASSNYC data
## Calculating correlation btw first 10 columns of the dataset. 

getwd()
setwd("C:\\Users\\vsm397\\Desktop\\Vir's Personal documents\\Pred Modeling (MSBA)\\NYC Schools Data")

df_regis = read.csv('D5 SHSAT Registrations and Testers.csv', header = T)
df_expl = read.csv('2016 School Explorer.csv', header = T)

## names of al the columns
names_of_cols <- names(df_expl)

## Converting categorical variables to factors
cat_cols <- c('SED.Code','Location.Code', 'District', 'Zip', 'Grades', 'Grade.Low', 'Grade.High','Community.School.')

for (i in cat_cols)
{
  #print(i)
  df_expl[, i] = as.factor(df_expl[, i])
  
}

## Columns selected for first round of estimating correlation

col_for_corr = c("Economic.Need.Index", "School.Income.Estimate", "Percent.ELL", "Percent.Asian",
                 "Percent.Black", "Percent.Hispanic", "Percent.Black...Hispanic", "Percent.White",
                 "Student.Attendance.Rate", "Percent.of.Students.Chronically.Absent", "Rigorous.Instruction.Rating")
df_for_corr_2 = df_expl[, col_for_corr]

df_for_corr_2 = df_for_corr_2[complete.cases(df_for_corr_2), ]  ## Removes NA values
df_for_corr_2= df_for_corr_2[(df_for_corr_2$School.Income.Estimate != 'N/A'), ] ## Remove NA values written as 'N/A'
df_for_corr_2= df_for_corr_2[(df_for_corr_2$Economic.Need.Index != 'N/A'), ] ## Remove NA values written as 'N/A'
df_for_corr_2= df_for_corr_2[(df_for_corr_2$ != 'N/A'), ] ## Remove NA values written as 'N/A'

df_for_corr_2$School.Income.Estimate = (as.character(df_for_corr_2$School.Income.Estimate)) ## Converting from factor to character
#Removing any non-numeric character from 'School Income Estimate' column
df_for_corr_2$School.Income.Estimate = as.numeric(gsub("[^0-9\\.]", "", df_for_corr_2$School.Income.Estimate) ) #Regular expression
df_for_corr_2$Economic.Need.Index= as.numeric(as.character(df_for_corr_2$Economic.Need.Index))

## Removing '%' symbol from the end of cell value and converting it to numeric

for ( j in 3:10)
{
  df_for_corr_2[, j] = as.numeric(sub("%","",df_for_corr_2[,j]))/100
}

corr_mat = cor(df_for_corr_2)
summary(df_for_corr_2)

##Cleaning the main dataframe
major_cities <- c("NEW YORK", "BRONX", "BROOKLYN", "STATEN ISLAND")
df_major_cities <- df_expl[(df_expl$City %in% major_cities),]

cols_to_clean <- c( "Rigorous.Instruction..", "Collaborative.Teachers.." ,
                    "Supportive.Environment..", "Trust..",
                    "Strong.Family.Community.Ties..", "Effective.School.Leadership.."
)

## clean the data by removing 'N/A' values
df_major_cities <- df_major_cities[complete.cases(df_major_cities), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.ELL != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.Asian != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.Black != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.Hispanic != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.Black...Hispanic != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.White != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Student.Attendance.Rate != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Percent.of.Students.Chronically.Absent != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Rigorous.Instruction.. != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Collaborative.Teachers.. != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Supportive.Environment.. != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Effective.School.Leadership.. != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Strong.Family.Community.Ties.. != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Trust.. != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Rigorous.Instruction.Rating != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Collaborative.Teachers.Rating != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Supportive.Environment.Rating != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Effective.School.Leadership.Rating != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Strong.Family.Community.Ties.Rating != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Trust.Rating != "N/A"), ]
df_major_cities <- df_major_cities[(df_major_cities$Student.Achievement.Rating != "N/A"), ]

## convert categorical variables to numeric (Rigorous Instruction Rating)
temporary_vector_ri <- as.character(df_major_cities$Rigorous.Instruction.Rating)
temporary_vector_ri[ temporary_vector_ri=="Meeting Target"] <- 3
temporary_vector_ri[ temporary_vector_ri=="Approaching Target"] <- 2
temporary_vector_ri[ temporary_vector_ri=="Exceeding Target"] <- 4
temporary_vector_ri[ temporary_vector_ri=="Not Meeting Target"] <- 1
df_major_cities$Rigorous_Instruction_Numeric = temporary_vector_ri

## convert categorical variables to numeric (Collaborative Teachers Rating)
temporary_vector_ct <- as.character(df_major_cities$Collaborative.Teachers.Rating)
temporary_vector_ct[ temporary_vector_ct=="Meeting Target"] <- 3
temporary_vector_ct[ temporary_vector_ct=="Approaching Target"] <- 2
temporary_vector_ct[ temporary_vector_ct=="Exceeding Target"] <- 4
temporary_vector_ct[ temporary_vector_ct=="Not Meeting Target"] <- 1
df_major_cities$Colaborative.Teachers.Numeric = temporary_vector_ct

## convert categorical variables to numeric (Supportive Environment Rating)
temporary_vector_se <- as.character(df_major_cities$Supportive.Environment.Rating)
temporary_vector_se[ temporary_vector_se=="Meeting Target"] <- 3
temporary_vector_se[ temporary_vector_se=="Approaching Target"] <- 2
temporary_vector_se[ temporary_vector_se=="Exceeding Target"] <- 4
temporary_vector_se[ temporary_vector_se=="Not Meeting Target"] <- 1
df_major_cities$Supportive.Environment.Numeric = temporary_vector_se

## convert categorical variables to numeric (Effective School Leadership Rating)
temporary_vector_esl <- as.character(df_major_cities$Effective.School.Leadership.Rating)
temporary_vector_esl[ temporary_vector_esl=="Meeting Target"] <- 3
temporary_vector_esl[ temporary_vector_esl=="Approaching Target"] <- 2
temporary_vector_esl[ temporary_vector_esl=="Exceeding Target"] <- 4
temporary_vector_esl[ temporary_vector_esl=="Not Meeting Target"] <- 1
df_major_cities$Effective.School.Leadership.Numeric = temporary_vector_esl

## convert categorical variables to numeric (Strong Family-Community Ties Rating)
temporary_vector_sfct <- as.character(df_major_cities$Strong.Family.Community.Ties.Rating)
temporary_vector_sfct[ temporary_vector_sfct=="Meeting Target"] <- 3
temporary_vector_sfct[ temporary_vector_sfct=="Approaching Target"] <- 2
temporary_vector_sfct[ temporary_vector_sfct=="Exceeding Target"] <- 4
temporary_vector_sfct[ temporary_vector_sfct=="Not Meeting Target"] <- 1
df_major_cities$Strong.Family.Community.Ties.Rating = temporary_vector_sfct

## convert categorical variables to numeric (Trust Rating)
temporary_vector_t <- as.character(df_major_cities$Rigorous.Instruction.Rating)
temporary_vector_t[ temporary_vector_t=="Meeting Target"] <- 3
temporary_vector_t[ temporary_vector_t=="Approaching Target"] <- 2
temporary_vector_t[ temporary_vector_t=="Exceeding Target"] <- 4
temporary_vector_t[ temporary_vector_t=="Not Meeting Target"] <- 1
df_major_cities$Trust.Numeric = temporary_vector_t

## convert categorical variables to numeric (Student Achievement Rating)
temporary_vector_sa <- as.character(df_major_cities$Rigorous.Instruction.Rating)
temporary_vector_sa[ temporary_vector_sa=="Meeting Target"] <- 3
temporary_vector_sa[ temporary_vector_sa=="Approaching Target"] <- 2
temporary_vector_sa[ temporary_vector_sa=="Exceeding Target"] <- 4
temporary_vector_sa[ temporary_vector_sa=="Not Meeting Target"] <- 1
df_major_cities$Student.Achievement.Numeric = temporary_vector_sa


#convert percents to decimals
df_major_cities$Percent.ELL <- as.numeric(sub("%","",df_major_cities$Percent.ELL))/100
df_major_cities$Percent.Asian <- as.numeric(sub("%","",df_major_cities$Percent.Asian))/100
df_major_cities$Percent.Black <- as.numeric(sub("%","",df_major_cities$Percent.Black))/100
df_major_cities$Percent.Hispanic <- as.numeric(sub("%","",df_major_cities$Percent.Hispanic))/100
df_major_cities$Percent.Black...Hispanic <- as.numeric(sub("%","",df_major_cities$Percent.Black...Hispanic))/100
df_major_cities$Percent.White <- as.numeric(sub("%","",df_major_cities$Percent.White))/100
df_major_cities$Student.Attendance.Rate <- as.numeric(sub("%","",df_major_cities$Student.Attendance.Rate))/100
df_major_cities$Percent.of.Students.Chronically.Absent <- as.numeric(sub("%","",df_major_cities$Percent.of.Students.Chronically.Absent))/100
df_major_cities$Rigorous.Instruction.. <- as.numeric(sub("%","",df_major_cities$Rigorous.Instruction..))/100
df_major_cities$Collaborative.Teachers.. <- as.numeric(sub("%","",df_major_cities$Collaborative.Teachers..))/100
df_major_cities$Supportive.Environment.. <- as.numeric(sub("%","",df_major_cities$Supportive.Environment..))/100
df_major_cities$Effective.School.Leadership.. <- as.numeric(sub("%","",df_major_cities$Effective.School.Leadership..))/100
df_major_cities$Strong.Family.Community.Ties.. <- as.numeric(sub("%","",df_major_cities$Strong.Family.Community.Ties..))/100
df_major_cities$Trust.. <- as.numeric(sub("%","",df_major_cities$Trust..))/100

## Create Dummy Variable for Economic Need Index
dummy_high_eni <- type.convert(df_major_cities$Economic.Need.Index)
dummy_high_eni[dummy_high_eni>=0.85] <- 1
dummy_high_eni[dummy_high_eni<0.85] <- 0
df_major_cities$Economic.Need.Index.Dummy <- dummy_high_eni
dummy_high_eni <- type.convert(df_major_cities$Economic.Need.Index)

## Run Classification Models on Dummy Variable for Economic Need Index
library(kknn)
n <- dim(df_major_cities)[1]
plot(df_major_cities$Percent.Black...Hispanic, df_major_cities$Economic.Need.Index)
plot(df_major_cities$Percent.Black...Hispanic, df_major_cities$Economic.Need.Index)

train <- data.frame(df_major_cities$Percent.Black...Hispanic ,df_major_cities$Economic.Need.Index)
test <- data.frame(df_major_cities$Percent.Black...Hispanic ,df_major_cities$Economic.Need.Index)

MSE <- NULL
kk <- c(100)

for(i in kk)
  
  near = kknn(df_major_cities$Economic.Need.Index~df_major_cities$Percent.Black...Hispanic,train,test,k=i,kernel = "rectangular")
  aux = mean((test[,2]-near$fitted)^2)
  
  MSE = c(MSE,aux)
  
near <- kknn(df_major_cities$Percent.Black...Hispanic~df_major_cities$Economic.Need.Index, train, test, k=60, kernal = "rectangular")

for(i in seq(1,505,by=250)){
  ii = near$C[i,1:2]
  plot(df_major_cities$Percent.Black...Hispanic,df_major_cities$Economic.Need.Index,main=paste("k=",60),pch=19,cex=0.8,col="darkgray")
  lines(test[,1],near$fitted,col=2,lwd=2)
  abline(v=test[i,1],col=2,lty=2)
  points(lstat[ii],medv[ii],pch=19,col="blue")
  cat ("Press [enter] to continue")
  line <- readline()
}

## Out of Sample Prediction

tr <- sample(1:913,700)

train <- train[tr,]
test <- test[-tr,]

out_MSE <- NULL

best = which.min(out_MSE)

plot(log(1/(2:350)),sqrt(out_MSE),xlab="Complexity (log(1/k))",ylab="out-of-sample RMSE",col=4,lwd=2,type="l",cex.lab=1.2)
text(log(1/best),sqrt(out_MSE[best])+0.3,paste("k=",best),col=2,cex=1.2)
text(log(1/2),sqrt(out_MSE[2]),paste("k=",2),col=2,cex=1.2)
text(log(1/354)+0.4,sqrt(out_MSE[345]),paste("k=",345),col=2,cex=1.2)


near = kknn(df_major_cities$Economic.Need.Index~df_major_cities$Percent.Black...Hispanic,train,test,k=42,kernel = "rectangular")

ind = order(test[,1])
plot(df_major_cities$Percent.Black...Hispanic,df_major_cities$Economic.Need.Index,main=paste("k=",42),pch=19,cex=0.8,col="darkgray")
lines(test[ind,1],near$fitted[ind],col=2,lwd=2)


## leave one out cross validation
train <- data.frame(df_major_cities$Percent.Black...Hispanic ,df_major_cities$Economic.Need.Index)
test <- data.frame(df_major_cities$Percent.Black...Hispanic ,df_major_cities$Economic.Need.Index)

out_MSE = matrix(0,n,100)

for(j in 1:n){
  
  
  train_i = train[-j,]
  test_i = test[j,]
}
  
for(i in 1:10){
    
    near = kknn(df_major_cities$Economic.Need.Index~df_major_cities$Percent.Black...Hispanic,train_i,test_i,k=i,kernel = "rectangular")
    aux = mean((test_i[,2]-near$fitted)^2)
    
    out_MSE[j,i] = aux
}

cat(j,'\n')


mMSE = apply(out_MSE,2,mean)

plot(log(1/(1:100)),sqrt(mMSE),xlab="Complexity (log(1/k))",ylab="out-of-sample RMSE",col=4,lwd=2,type="l",cex.lab=1.2)
best = which.min(mMSE)
text(log(1/best),sqrt(mMSE[best])+0.1,paste("k=",best),col=2,cex=1.2)
text(log(1/2),sqrt(mMSE[2])+0.3,paste("k=",2),col=2,cex=1.2)
text(log(1/100)+0.4,sqrt(mMSE[100]),paste("k=",100),col=2,cex=1.2)


### k-fold cross validation
kcv = 10
n0 = round(n/kcv,0)

out_MSE = matrix(0,kcv,100)

used = NULL
set = 1:n

for(j in 1:kcv){
  
  if(n0<length(set)){val = sample(set,n0)}
  if(n0>=length(set)){val=set}
  
  train_i = train[-val,]
  test_i = test[val,]
}
  
for(i in 1:5){
near = kknn(df_major_cities$Economic.Need.Index~df_major_cities$Percent.Black...Hispanic,train_i,test_i,k=i,kernel = "rectangular")
aux = mean((test_i[,2]-near$fitted)^2)
  
  out_MSE[j,i] = aux
}    

mMSE = apply(out_MSE,2,mean)

plot(log(1/(1:5)),sqrt(mMSE),xlab="Complexity (log(1/k))",ylab="out-of-sample RMSE",col=4,lwd=2,type="l",cex.lab=1.2,main=paste("kfold(",kcv,")"))
best = which.min(mMSE)
text(log(1/best),sqrt(mMSE[best])+0.1,paste("k=",best),col=2,cex=1.2)
text(log(1/2),sqrt(mMSE[2])+0.3,paste("k=",2),col=2,cex=1.2)
text(log(1/5)+0.4,sqrt(mMSE[100]),paste("k=",5),col=2,cex=1.2)


## treated as a classification problem


    
    near = kknn(df_major_cities$Economic.Need.Index~df_major_cities$Percent.Black...Hispanic,train_i,test_i,k=i,kernel = "rectangular")
    aux = mean((test_i[,2]-near$fitted)^2)
    
    out_MSE[j,i] = aux
}
  
  used = union(used,val)
  set = (1:n)[-used]
  
  cat(j,'\n')
  
}

mMSE = apply(out_MSE,2,mean)

plot(log(1/(1:100)),sqrt(mMSE),xlab="Complexity (log(1/k))",ylab="out-of-sample RMSE",col=4,lwd=2,type="l",cex.lab=1.2,main=paste("kfold(",kcv,")"))
best = which.min(mMSE)
text(log(1/best),sqrt(mMSE[best])+0.1,paste("k=",best),col=2,cex=1.2)
text(log(1/2),sqrt(mMSE[2])+0.3,paste("k=",2),col=2,cex=1.2)
text(log(1/100)+0.4,sqrt(mMSE[100]),paste("k=",100),col=2,cex=1.2)

hist(df_major_cities$Economic.Need.Index, col=5, xlab = ENI)
hist(df_major_cities$Economic.Need.Index.Dummy, add=TRUE, col = 6)