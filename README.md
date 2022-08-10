# Artisanal-Mining-In-Ghana-(Galamsey)
Earth Observation with RGEE in R Studio
![image](https://github.com/Kalong-Code/Artisanal-Mining-In-Ghana-Galamsey/blob/main/Plots/classification.png)
INTRODUCTION
All thing change, but how we respond to change is our responsibility, to fare it or embrasse it. Resisting
change leads to one fiat. Our own extinction. Time is a smybole of freedom and peace
The purpose of this paper is to establish an understanding in time series analysis on remotely sensed data.
Which will introduced us to the fundamentals of time series modeling, including decomposition,
autocorrelation and modeling historical changes in Galamsey Operation in Ghana, the Cause,Dangers and
it’s Environmental impact. Galamsey("gather them and sell"),(OwusuNimo2018) is the term given by local
Ghanaian for illegal small-scale gold mining in Ghana (DavidYawDanquah2019). The major cause of
Galamsey is unemployment among the youth in Ghana(Gracia2018). Young university graduates rarely find
work and when they do it hardly sustains them. The result is that these youth go the extra mile to earn a
living for themselves and their family. Another factor is that lack of job security.
On November 13, 2009 a collapse occurred in an illegal, privately owned mine in Dompoase, in the Ashanti
Region of Ghana. At least 18 workers were killed, including 13 women, who worked as porters for the miners.
Officials described the disaster as the worst mine collapse in Ghanaian history(News2009).
Illegal mining causes damage to the land and water supply(Ansah2017). In March 2017, the Minister of
Lands and Natural Resources, Mr. John Peter Amewu, gave the Galamsey operators/illegal miners a
three-week ultimatum to stop their activities or be prepared to face the law(Allotey2017). The activities by
Galamseyers have depleted Ghana’s forest cover and they have caused water pollution, due to the crude and
unregulated nature of the mining process(Gyekye2021).
Under current Ghanaian constitution, it is illegal to operate as galamseyer.That is to dig on land granted to
mining companies as concessions or licenses and any other land in search for gold. In some cases,
Galamseyers are the first to discover and work extensive gold deposits before mining companies find out and
take over. Galamseyers are the main indicator of the presence of gold in free metallic dust form or they
process oxide or sulfide gold ore using liquid mercury. Between 20,000 to 50,000, including thousands from
China are believed to be engaged in Galamsey in Ghana.But according to the Information Minister 200,000
and nearly 3 million people, recently are now into Galamsey operation and rely on it for their
livelihoods(Burrows2017). Their operations are mostly in the southern part of Ghana where it is believe to
have substantial reserves of gold deposits, usually within the area of large mining companies(Barenblitt2021).
As a group, they are economically disad vantaged. Galamsey settlements are usually poorer than neighboring
agricultural villages. They have high rates of accidents and are exposed to mercury poisoning from their
crude processing methods. Many women are among the workers, acting mostly as porters for the miners.

Background of The Study
As Galamsey is considered an illegal activity, they operations are hidden to the eyes of the authorities.So
locating them is quite tricky ,but with satellite imagery ,it now possible to locate their operating and put an
end to it. One of the features of Google Earth Engine is the ability to access years of satellite imagery without
needing to download, organize, store and process this information. For instance, within the Satellite image
collection, now it possible to access imagery back to the 90’s, allowing us to look at areas of interest on the
map to visualize and quantify how much things has changed over time. With Earth Engine, Google
maintains the data and offers it’s computing power for processing.Users can now access hundreds of time

2


series images and analyze changes across decades using GIS and R or other programming language to
analyze these datasets.

Problem Statement
The Footprint of Galamsey is Spreading at a very faster rate, causing vegetation loss.Other factors
accounting to vegetation loss may largely include climate change,urban and exurban development, bush fires.
But not much works or research has been done to tell the extent to which Galamsey causes vegetation loss.
This research attempts to segregate the variability climate is responsible for in vegetation loss so as to
attribute the residual variability to Galamsey and other related activities such as bush-fires etc.

Research Question
Research Objectives
The purpose is to establish an understanding in time series analysis on remotely sensed data. We will be
introduced to the fundamentals of time series modeling, including decomposition, autocorrelation and
modeling historical changes.
• Perform time series analysis on satellite derived vegetation indices
• Estimate the extent to which Galamsey causes vegetation loss
• Dissociate or single out the variability climate is responsible for in vegetation loss

Significance Of The Study
Scope of The Study
Limitation Of The Study
Time series modeling aims to build an explanatory model of the data without over fitting the problem set, to
use as simple a model as possible while accounting for as much of the data as possible. When breaking down
time series data into component parts, remote sensing data has additional limitations that make this more
challenging. It is almost inevitable that you will not get this same level of precision from remote sensing data.
Additionally, atmospheric conditions can skew the visual results, where the hue of the vegetation changes
drastically from image to image due to atmospheric conditions (fog,ground moisture, cloud cover).
