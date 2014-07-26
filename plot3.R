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

baltimoreTypeSum <- aggregate(Emissions ~ year + type, subsetBaltimore, sum)

## load ggplot2 package

library(ggplot2)

## plot the emissions by type

png(file = "plot3.png", width = 800, height = 480)
qplot(x = year, y = Emissions, data = baltimoreTypeSum, geom = c("point", "smooth"),
      formula = y ~ x, color = type,
      main = "Baltimore City Emissions from 1999 - 2008 by type",
      ylab = "Sum of Emissions in tons")
dev.off()