## download and unzip the FNEI data

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              "FNEI_data.zip")
unzip("FNEI_Data.zip")

## read in the data

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## use type = "ON-ROAD" to subset the SCC data to observations from motor vehicle sources
## (see pg. 215 of http://www.epa.gov/ttn/chief/net/2011nei/2011_nei_tsdv1_draft2_june2014.pdf
## describing how "ON-ROAD" is made up of motor vehicles - credit Robert McAnany for sharing
## the citation and research)

onroadNEI <- NEI[NEI$type == "ON-ROAD",]

## subset the onroadNEI data down to Baltimore City data

onroadBaltimore <- onroadNEI[onroadNEI$fips == "24510", ]

## sum the emissions from motor vehicles in Baltimore City per year

onroadBaltimoreSum <- aggregate(Emissions ~ year, onroadBaltimore, sum)

## load ggplot2 package

library(ggplot2)

## plot the Baltimore City motor vehicle emissions

png(file = "plot5.png", width = 800, height = 480)
qplot(x = year, y = Emissions, data = onroadBaltimoreSum, geom = c("point", "smooth"),
      formula = y ~ x,
      main = "Motor vehicle Emissions in Baltimore City from 1999 - 2008",
      ylab = "Sum of Emissions in tons") + theme(plot.title = element_text(face = "bold"))
dev.off()
