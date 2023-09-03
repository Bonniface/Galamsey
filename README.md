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

![EVI Classification Map](/Thesis/images/Map.png)

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

![Impulse Response](/Thesis/images/ImpulseResponse.png)

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

