## download and unzip the FNEI data

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              "FNEI_data.zip")
unzip("FNEI_Data.zip")

## read in the data

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset the SCC data to observations combining coal + combustion (count = 104)

library(sqldf)

coalCombustion <- sqldf(
        paste(
                "SELECT * FROM SCC",
                "WHERE (UPPER(Short_Name) LIKE UPPER('%coal%') OR UPPER(EI_Sector) LIKE UPPER('%coal%')",
                "OR UPPER(SCC_Level_Three) LIKE UPPER('%coal%') OR UPPER(SCC_Level_Four) LIKE UPPER('%coal%'))",
                "AND (UPPER(SCC_Level_One) LIKE UPPER('%combustion%') OR UPPER(SCC_Level_TWo) LIKE UPPER('%combustion%'))"
        )
)

## subset the NEI data to SCCs that match the coalCombustion data SCCs

matchNEI <- NEI[match(coalCombustion$SCC,NEI$SCC), ]

## sum the coal combustion-related emissions per year

coalSum <- aggregate(Emissions ~ year, matchNEI, sum)

## load ggplot2 package

library(ggplot2)

## plot the coal combustion emissions

png(file = "plot4.png", width = 800, height = 480)
qplot(x = year, y = Emissions, data = coalSum, geom = c("point", "smooth"),
      formula = y ~ x,
      main = "Coal combustion-related Emissions in the U.S. from 1999 - 2008",
      ylab = "Sum of Emissions in tons") + theme(plot.title = element_text(face = "bold"))
dev.off()