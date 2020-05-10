# NBA-Loan-Prediction
Banking Datasets and Predicting Next Best Action to the Loan

![NBA Banking Concept](https://user-images.githubusercontent.com/8001789/81504093-05d22880-9305-11ea-98e7-c0259cbcb3c7.png)


## Data-Description
| Title                | Description                                                                   |
|----------------------|-------------------------------------------------------------------------------|
| ID                   | Customer ID                                                                   |
| Age                  | Customer's age in   years                                                     |
| Experience           | Years of professional   experience                                            |
| Income               | Annual income of the   customer ()                                        |
| ZIPCode              | Home Address ZIP   code.                                                      |
| Family               | Family size of the   customer                                                 |
| CCAvg                | Avg. spending on   credit cards per month ()                              |
| Education            | Education Level. 1:   Undergrad; 2: Graduate; 3: Advanced/Professional        |
| Mortgage             | Value of house   mortgage if any. ()                                      |
| Personal Loan        | Did this customer   accept the personal loan offered in the last campaign?    |
| Securities   Account | Does the customer   have a securities account with the bank?                  |
| CD Account           | Does the customer   have a certificate of deposit (CD) account with the bank? |
| Online               | Does the customer use   internet banking facilities?                          |
| CreditCard           | Does the customer use   a credit card issued by the bank?                     |

## Environment Set up and Data Import
### Importing and calling libraries
- install.packages("readxl")
- install.packages("caTools")
- install.packages("rpart")
- install.packages("rpart.plot")
- install.packages("rattle")
- install.packages("RColorBrewer")
- install.packages("data.table")
- install.packages("ROCR")
- install.packages("randomForest")
- install.packages("corrplot")
- install.packages("ineq")
- install.packages("ggplot2")
- install.packages("factoextra")
- install.packages("psych")

### Loading all the required libraries
- library(readxl)
- library(caTools)
- library(rpart)
- library(rpart.plot)
- library(rattle)
- library(RColorBrewer)
- library(data.table)
- library(ROCR)
- library(randomForest)
- library(corrplot)
- library(ineq)
- library(ggplot2)
- library(factoextra)
- library(psych)

### Setting up Working Directory and Import Dataset
`> setwd(YOUR_FILEPATH>>)`
`> ntb_data=read_excel("NTB-Bank-DataSet.xlsx',sheet = 2)`

### Run with R
`Predictions-NBA.R`
`RandomForest-B-Data.R`


#### ©️ By Nisal Chandrasekara for BA Assignment CIS-7026


