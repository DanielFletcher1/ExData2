## download and unzip the FNEI data

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              "FNEI_data.zip")
unzip("FNEI_Data.zip")

## read in the data

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset the data, so only Baltimore City remains (fips == "24510")

subsetBaltimore <- NEI[NEI$fips == "24510",]

## sum the emissions per year for Baltimore City

baltimoreSum <- aggregate(Emissions ~ year, subsetBaltimore, sum)

## plot the decrease in emissions

png(file = "plot2.png")
plot(baltimoreSum, type = "b", ylab = "Sum of Emissions in tons")
title("Over 43% reduction in Baltimore City Emissions from 1999 - 2008
      \n(red best-fit line shows significant overall decrease, despite 2005)", cex.main = 1)
abline(lm(baltimoreSum$Emissions ~ baltimoreSum$year), col="red")
dev.off()

## for reference, here's the 43+ percent change for years 1999 v. 2008:

firstYearEmissions <- baltimoreSum[baltimoreSum$year == 1999, "Emissions"]
lastYearEmissions <- baltimoreSum[baltimoreSum$year == 2008, "Emissions"]
(lastYearEmissions - firstYearEmissions)/firstYearEmissions ## -0.431222