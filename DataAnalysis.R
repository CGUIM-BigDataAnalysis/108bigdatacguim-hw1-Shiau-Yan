#108-2 大數據分析方法 作業一
#B0644243_蕭泊諺

###比較104年度和107年度大學畢業者的薪資資料

# 資料匯入與處理
library(jsonlite)
library(dplyr)
data104_1<-fromJSON("http://ipgod.nchc.org.tw/dataset/b6f36b72-0c4a-4b60-9254-1904e180ddb1/resource/63ecb4a9-f634-45f4-8b38-684b72cf95ba/download/0df38b73f75962d5468a11942578cce5.json")
data107_1<-fromJSON("C:/Users/user/Desktop/data_107.json")
data104_1$大職業別 <- gsub("部門","",data104_1$大職業別)
data104_1$大職業別<- gsub("、","_",data104_1$大職業別)
data104_1$大職業別<- gsub("營造業","營建工程",data104_1$大職業別)
data104_1$大職業別<- gsub("醫療保健服務業","醫療保健業",data104_1$大職業別)
data107_1$大職業別<- gsub("出版、影音製作、傳播及資通訊服務業","資訊及通訊傳播業",data107_1$大職業別)
data104_1$`大學-薪資_104`<-data104_1$`大學-薪資`
data107_1$`大學-薪資_107`<-data107_1$`大學-薪資`
data104_1<-select(data104_1,年度:大職業別,starts_with("大學-薪資_"))
data107_1<-select(data107_1,年度:大職業別,starts_with("大學-薪資_"))
knitr::kable(data104_1)
knitr::kable(data107_1)
#join
data104_107_join<-cbind(data104_1,data107_1)
knitr::kable(data104_107_join)
MainTypeJobName<-data104_107_join[-grep("-",data104_107_join$大職業別),]
data104_107_join<-data104_107_join[grep("-",data104_107_join$大職業別),]
data104_107_join$`大學-薪資_104`<-gsub("—|…","2",data104_107_join$`大學-薪資_104`)
data104_107_join$`大學-薪資_107`<-gsub("—|…","1",data104_107_join$`大學-薪資_107`)
data104_107_join[,3]<-as.numeric(data104_107_join[,3])
data104_107_join[,6]<-as.numeric(data104_107_join[,6])


# 107年度薪資較104年度薪資高的職業有哪些?
#按照提高比例由大到小排序(3分)，呈現前十名的資料(2分)
data104_107_join$rate<-(data104_107_join$`大學-薪資_107`-data104_107_join$`大學-薪資_104`)/data104_107_join$`大學-薪資_104`*100
data104_107_order<-data104_107_join[order(data104_107_join$rate, decreasing = T),]
data104_107_order[1:10,]
knitr::kable(data104_107_order)
knitr::kable(data104_107_order[1:10,])
#用文字說明結果
#前10名薪資提高比例皆大於8%，成長後的薪水卻不是最高的，以銷售或專業人員居多，前10名各行業都有，唯獨教育服務業佔了3個名次。


# 提高超過5%的的職業有哪些? 
data104_107_join<-data104_107_join[,c(2,3,6,7)]
rate_bigger_than5<-filter(data104_107_join,rate>5)
knitr::kable(rate_bigger_than5)


# 主要的職業種別是哪些種類呢?
MainTypeJobName[,3]<-as.numeric(MainTypeJobName[,3])
MainTypeJobName[,6]<-as.numeric(MainTypeJobName[,6])
MainTypeJobName$rate<-(MainTypeJobName$`大學-薪資_107`-MainTypeJobName$`大學-薪資_104`)/MainTypeJobName$`大學-薪資_104`*100
MainTypeJobName<-MainTypeJobName[,c(2,3,6,7)]
knitr::kable(MainTypeJobName)




### 男女同工不同酬現況分析

# 資料匯入與處理
library(jsonlite)
library(dplyr)
data104_2<-fromJSON("http://ipgod.nchc.org.tw/dataset/b6f36b72-0c4a-4b60-9254-1904e180ddb1/resource/63ecb4a9-f634-45f4-8b38-684b72cf95ba/download/0df38b73f75962d5468a11942578cce5.json")
data107_2<-fromJSON("C:/Users/user/Desktop/data_107.json")
data104_2<-select(data104_2,`大學-女/男`,starts_with("大職業別"))
data107_2<-select(data107_2,`大學-女/男`,starts_with("大職業別"))
data104_2<-data104_2[grep("-",data104_2$大職業別),]
data107_2<-data107_2[grep("-",data107_2$大職業別),]
data104_2$`大學-女/男`<-gsub("—|…","-1",data104_2$`大學-女/男`)
data107_2$`大學-女/男`<-gsub("—|…","-1",data107_2$`大學-女/男`)
data104_2$`大學-女/男`<-as.numeric(data104_2$`大學-女/男`)
data107_2$`大學-女/男`<-as.numeric(data107_2$`大學-女/男`)


#104到107年度的大學畢業薪資資料，哪些行業男生薪資比女生薪資多?
#依照差異大小由大到小排序(3分)，呈現前十名的資料(2分)
data104_2_1<-data104_2[data104_2$`大學-女/男`<100,]
data107_2_1<-data107_2[data107_2$`大學-女/男`<100,]
data104_2_1<-data104_2[data104_2$`大學-女/男`>0,]
data107_2_1<-data107_2[data107_2$`大學-女/男`>0,]
#104
data104_2_low<-data104_2_1[order(data104_2_1$`大學-女/男`, decreasing = F),]
data104_2_low[1:10,]
knitr::kable(data104_2_low[1:10,])
#107
data107_2_low<-data107_2_1[order(data107_2_1$`大學-女/男`, decreasing = F),]
data107_2_low[1:10,]
knitr::kable(data107_2_low[1:10,])


#哪些行業女生薪資比男生薪資多? 
#依據差異大小由大到小排序(3分)，呈現前十名的資料(2分)
data104_2_2<-data104_2[data104_2$`大學-女/男`>=100,]
data107_2_2<-data107_2[data107_2$`大學-女/男`>=100,]
#104
data104_2_high<-data104_2_2[order(data104_2_2$`大學-女/男`, decreasing = T),]
data104_2_high[1:10,]
knitr::kable(data104_2_high[1:10,])
#107
data107_2_high<-data107_2_2[order(data107_2_2$`大學-女/男`, decreasing = T),]
data107_2_high[1:10,]
knitr::kable(data107_2_high[1:10,])
#並用文字說明結果(10分)
#男女同工不同酬的問題仍然存在,並且透過資料分析發現其嚴重性,不過可以看出3年間女性的薪資不斷的爬升，大家有在重視並解決這個問題，107年也至少有8項行業達到男女薪水平等，甚至女性較高



### 研究所薪資差異
#哪個職業別念研究所最划算 (研究所學歷薪資與大學學歷薪資增加比例最多)? 
library(jsonlite)
data107_3<-fromJSON("C:/Users/user/Desktop/data_107.json")
data107_3<-data107_3[,c(2,11,13)]
data107_3$`大學-薪資`<-gsub("—|…","-1",data107_3$`大學-薪資`)
data107_3$`研究所-薪資`<-gsub("—|…","-1",data107_3$`研究所-薪資`)
data107_3$`大學-薪資`<-as.numeric(data107_3$`大學-薪資`)
data107_3$`研究所-薪資`<-as.numeric(data107_3$`研究所-薪資`)
data107_3$rate<-(data107_3$`研究所-薪資`-data107_3$`大學-薪資`)/data107_3$`大學-薪資`*100
data107_3<-data107_3[-grep("-",data107_3$大職業別),]
data107_3<-data107_3[order(data107_3$rate,decreasing = T),]
knitr::kable(data107_3)
top10_salary<-data107_3[1:10,]
knitr::kable(top10_salary)
#並用文字說明結果(10分)
#從分析上來看，前十項薪資增加的出路偏向服務業及工科，讀研究所後做服務業最划算，而與資管較相關的行業則是資通訊服務業及醫療保健業



###自己有興趣的職業別薪資狀況分析
data107_4<-fromJSON("C:/Users/user/Desktop/data_107.json")
data107_4<-data107_4[,c(2,11,13)]
data107_4$`大學-薪資`<-gsub("—|…","-1",data107_4$`大學-薪資`)
data107_4$`研究所-薪資`<-gsub("—|…","-1",data107_4$`研究所-薪資`)
data107_4$`大學-薪資`<-as.numeric(data107_4$`大學-薪資`)
data107_4$`研究所-薪資`<-as.numeric(data107_4$`研究所-薪資`)
#列出自己有興趣的職業別，呈現相對應的大學畢業薪資與研究所畢業薪資(5分)
jobs_interested<-filter(data107_4,大職業別 %in% c("出版、影音製作、傳播及資通訊服務業","服務業","醫療保健業","批發及零售業","金融及保險業"))
knitr::kable(jobs_interested)
#請問此薪資與妳想像中的一樣嗎?(5分)
#大學與想像中的差不多,但是研究所薪水覺得有些少XD
#研究所薪資與大學薪資差多少呢?(5分) 
jobs_interested$salary_differ<-jobs_interested$`研究所-薪資`-jobs_interested$`大學-薪資`
knitr::kable(jobs_interested)
#會因為這樣改變心意，決定念/不念研究所嗎?
#其實不會,因為覺得研究所可以學到更多東西,也覺得可以學得更深入，研究所畢業也代表對其領域有一定的專業知識與了解。




