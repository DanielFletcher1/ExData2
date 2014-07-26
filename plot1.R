## download and unzip the FNEI data

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              "FNEI_data.zip")
unzip("FNEI_Data.zip")

## read in the data

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## sum the emissions per year

emissionsSum <- aggregate(Emissions ~ year, NEI, sum)

## plot the decrease in emissions

png(file = "plot1.png")
plot(emissionsSum, type = "b", ylab = "Sum of Emissions in tons")
title("Over 52% reduction in Emissions from 1999 - 2008")
dev.off()

## for reference, here's the 52+ percent change for years 1999 v. 2008:

firstYearEmissions <- emissionsSum[emissionsSum$year == 1999, "Emissions"]
lastYearEmissions <- emissionsSum[emissionsSum$year == 2008, "Emissions"]
(lastYearEmissions - firstYearEmissions)/firstYearEmissions ## -0.5275847