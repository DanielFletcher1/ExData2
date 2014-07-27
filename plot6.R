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

## subset the onroadNEI data down to Baltimore City and LA County data

onroadBaltimore <- onroadNEI[onroadNEI$fips == "24510",]
onroadLAC <- onroadNEI[onroadNEI$fips == "06037",]

## sum the emissions from motor vehicles in Baltimore City and LA County per year

onroadBaltimoreSum <- aggregate(Emissions ~ year, onroadBaltimore, sum)
onroadLACSum <- aggregate(Emissions ~ year, onroadLAC, sum)

## load ggplot2 package and install gridExtra

library(ggplot2)
install.packages("gridExtra")
library(gridExtra)

## plot the Baltimore City and LA County motor vehicle emissions
## the extra () cause the plots to print immediately

png(file = "plot6.png", width = 500, height = 900)
p1 <- qplot(x = year, y = Emissions, data = onroadBaltimoreSum, geom = c("point", "smooth"),
            formula = y ~ x,
            main = "Motor vehicle Emissions in Baltimore City from 1999 - 2008",
            ylab = "Sum of Emissions in tons") + theme(plot.title = element_text(face = "bold"))
p2 <- qplot(x = year, y = Emissions, data = onroadLACSum, geom = c("point", "smooth"),
            formula = y ~ x,
            main = "Motor vehicle Emissions in LA County from 1999 - 2008",
            ylab = "Sum of Emissions in tons") + theme(plot.title = element_text(face = "bold"))
grid.arrange(p1, p2, nrow = 2)
dev.off()