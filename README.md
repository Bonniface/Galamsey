# Climate Change Impact on Vegetation in Ghana

## Abstract

This study investigates the impact of climate variability on the vegetation condition index (EVI) in the southern part of Ghana. Granger causality tests were conducted to determine the influence of various climate factors on EVI. Vector Autoregressive model was used to check the effect of each climatic condition on EVI, and it was observed that only three climate factors had a significant impact on EVI. Subsequent to this, impulse analysis was done, and the results showed that the strongest negative effects of the climatic conditions on EVI were observed in the ninth, third, and tenth months for maximum temperature, relative precipitation, and evaporation, respectively. The decomposition of predicted variance showed varying degrees of EVI dependence on climatic variables. The findings provide insights for policymakers to develop policies that account for the influence of climatic variability on EVI.

## Keywords

Climate variability, vegetation condition index, EVI, Granger causality test, maximum temperature, relative precipitation, evaporation, policy-making.

## 1. Introduction

This research paper investigates the impact of climate on vegetation in Ghana, emphasizing the significance of climate change in affecting vegetation. While various factors contribute to deforestation, including "Galamsey" activities, this study focuses on climate change as a key factor. By utilizing time series analysis on remotely sensed data, the paper aims to determine the extent to which climate change and "Galamsey" contribute to vegetation loss in Ghana. It explores variations in vegetation due to both factors and establishes their correlation. The study uses satellite imagery and Google Earth Engine to monitor long-term changes and offers comprehensive insights into addressing vegetation loss in Ghana.

### 1.1 Literature

The article discusses various factors contributing to deforestation, with climate change accounting for over half of the changes. Energy consumption choices, urban population growth, agricultural exports, timber harvesting, and fluctuations in temperature and precipitation are among the drivers of forest loss. Dynamic Global Vegetation Models (DGVMs) have been used to understand the impact of climate change on forests, predicting forest attrition in the Amazon and shifts in species concentration. The forest transition theory explains how industrialization and urbanization modify forest cover over time.

## 2. Study Area

The study area is the Republic of Ghana, a West African nation bordered by Ivory Coast, Burkina Faso, and Togo. Ghana encompasses various biomass types, including tropical rainforests and coastal savannas. Experimental plots in cities like Accra, Kumasi, Tamale, and Sekondi-Takoradi are the focus of this research.

![EVI Classification Map](images/Map.png)

## 3. Methodology

### 3.1 Data

Data for this study was primarily gathered from the Ghana Meteorological Agency and the Health Service. It includes meteorological data (rainfall, temperature, humidity), EVI data, and other relevant climate variables. The data underwent preprocessing, including smoothing and normalization, to prepare it for analysis.

### 3.2 Causality

Causality analysis includes Granger causality and instantaneous causality tests to determine the relationship between climate variables and EVI.

### 3.3 Analysis of Impulse Responses

Impulse response analysis examines exogenous and deterministic variables, with the goal of understanding the dynamics of the system.

## 4. Data Analysis and Results

### 4.1 Preliminary Results

Summary statistics for EVI and climate data are presented, demonstrating the range and distribution of variables. Time series plots highlight the seasonal patterns in the data.

![Time Series Plot](/Thesis/images/TimeSeries.png)

### 4.2 Variable Selection

Variable selection involved considering EVI and climate variables, addressing multicollinearity, and ensuring that selected variables explained the target variable effectively.

### 4.3 VAR Estimation

Vector Autoregressive (VAR) models were used with 12 lags to forecast EVI over the next 12 months. The forecasted values, along with 95% confidence intervals, are provided below.

| Month | Forecast | Lower CI | Upper CI |
|-------|----------|----------|----------|
| Feb   | 1.28     | 0.53     | 2.02     |
| Mar   | 0.62     | -0.34    | 1.59     |
| Apr   | 0.77     | -0.25    | 1.81     |
| May   | -0.29    | -1.36    | 0.76     |
| Jun   | -0.41    | -1.49    | 0.68     |
| Jul   | -0.69    | -1.85    | 0.45     |
| Aug   | -0.55    | -1.72    | 0.61     |
| Sep   | -0.39    | -1.52    | 0.74     |
| Oct   | 0.21     | -0.92    | 1.34     |
| Nov   | 0.32     | -0.77    | 1.41     |
| Dec   | 0.54     | -0.52    | 1.60     |
| Jan   | 0.90     | 0.14     | 1.67     |

### 4.4 Impulse Analysis

Impulse response analysis was conducted to understand the immediate and long-term effects of climate variables on EVI.

![Impulse Response](images/ImpulseResponse.png)

## 5. Discussion

The results suggest a significant influence of climate factors on EVI in Ghana. The strongest negative effects on EVI were observed in specific months for maximum temperature, relative precipitation, and evaporation. The decomposition of predicted variance revealed the varying degrees of EVI dependence on climatic variables.

## 6. Conclusion

This research highlights the importance of considering climate variability in understanding the vegetation dynamics in Ghana. The findings provide valuable insights for policymakers and environmentalists to develop strategies that account for the influence of climatic variability on EVI.

## 7. References

Please refer to the full research paper for a comprehensive list of references and citations.

---

**Contact Information:**

For inquiries or further information, please contact:

Mr. Boniface Kalong
Email: kalongboniface97@gmail.com
Mobile: +233 50 616 2161

# Artisanal-Mining-In-Ghana-(Galamsey)
Earth Observation with RGEE in R Studio
![image](https://github.com/Kalong-Code/Artisanal-Mining-In-Ghana-Galamsey/blob/main/Plots/classification.png)
## INTRODUCTION
All thing change, but how we respond to change is our responsibility, to fare it or embrasse it. Resisting change leads to one fiat. Our own extinction. Time is a smybole of freedom and peace

The purpose of this paper is to establish an understanding in time series analysis on remotely sensed data. Which will introduced us to the fundamentals of time series modeling, including decomposition, autocorrelation and modeling historical changes in Galamsey Operation in Ghana, the Cause,Dangers and it’s Environmental impact. Galamsey("gather them and sell"),(OwusuNimo2018) is the term given by local
Ghanaian for illegal small-scale gold mining in Ghana (DavidYawDanquah2019). The major cause of Galamsey is unemployment among the youth in Ghana(Gracia2018). Young university graduates rarely find work and when they do it hardly sustains them. The result is that these youth go the extra mile to earn a living for themselves and their family. Another factor is that lack of job security.

On November 13, 2009 a collapse occurred in an illegal, privately owned mine in Dompoase, in the Ashanti Region of Ghana. At least 18 workers were killed, including 13 women, who worked as porters for the miners. Officials described the disaster as the worst mine collapse in Ghanaian history(News2009).

Illegal mining causes damage to the land and water supply(Ansah2017). In March 2017, the Minister of Lands and Natural Resources, Mr. John Peter Amewu, gave the Galamsey operators/illegal miners a three-week ultimatum to stop their activities or be prepared to face the law(Allotey2017). The activities by Galamseyers have depleted Ghana’s forest cover and they have caused water pollution, due to the crude and unregulated nature of the mining process(Gyekye2021).

Under current Ghanaian constitution, it is illegal to operate as galamseyer.That is to dig on land granted to mining companies as concessions or licenses and any other land in search for gold. In some cases,Galamseyers are the first to discover and work extensive gold deposits before mining companies find out and take over. Galamseyers are the main indicator of the presence of gold in free metallic dust form or they process oxide or sulfide gold ore using liquid mercury. Between 20,000 to 50,000, including thousands from China are believed to be engaged in Galamsey in Ghana.But according to the Information Minister 200,000 and nearly 3 million people, recently are now into Galamsey operation and rely on it for their livelihoods(Burrows2017). Their operations are mostly in the southern part of Ghana where it is believe to have substantial reserves of gold deposits, usually within the area of large mining companies(Barenblitt2021).
As a group, they are economically disad vantaged. Galamsey settlements are usually poorer than neighboring agricultural villages. They have high rates of accidents and are exposed to mercury poisoning from their crude processing methods. Many women are among the workers, acting mostly as porters for the miners.

# Background of The Study
As Galamsey is considered an illegal activity, they operations are hidden to the eyes of the authorities.So locating them is quite tricky ,but with satellite imagery ,it now possible to locate their operating and put an end to it. One of the features of Google Earth Engine is the ability to access years of satellite imagery without needing to download, organize, store and process this information. For instance, within the Satellite image collection, now it possible to access imagery back to the 90’s, allowing us to look at areas of interest on the map to visualize and quantify how much things has changed over time. With Earth Engine, Google
maintains the data and offers it’s computing power for processing.Users can now access hundreds of time series images and analyze changes across decades using GIS and R or other programming language to analyze these datasets.

# Problem Statement
The Footprint of Galamsey is Spreading at a very faster rate, causing vegetation loss.Other factors accounting to vegetation loss may largely include climate change,urban and exurban development, bush fires.But not much works or research has been done to tell the extent to which Galamsey causes vegetation loss. This research attempts to segregate the variability climate is responsible for in vegetation loss so as to attribute the residual variability to Galamsey and other related activities such as bush-fires etc.

# Research Question
# Research Objectives
The purpose is to establish an understanding in time series analysis on remotely sensed data. We will be introduced to the fundamentals of time series modeling, including decomposition, autocorrelation and modeling historical changes.

• Perform time series analysis on satellite derived vegetation indices 
• Estimate the extent to which Galamsey causes vegetation loss
• Dissociate or single out the variability climate is responsible for in vegetation loss

# Significance Of The Study
# Scope of The Study
# Limitation Of The Study
Time series modeling aims to build an explanatory model of the data without over fitting the problem set, to use as simple a model as possible while accounting for as much of the data as possible. When breaking down time series data into component parts, remote sensing data has additional limitations that make this more challenging. It is almost inevitable that you will not get this same level of precision from remote sensing data.
Additionally, atmospheric conditions can skew the visual results, where the hue of the vegetation changes drastically from image to image due to atmospheric conditions (fog,ground moisture, cloud cover).
