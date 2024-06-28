# Installing & Loading the package
library(ggplot2)

# read the data
location4 <- "C:/Users/prati/Downloads/archive (5)/Placement_Data_Full_Class.csv" # copy applicable path
placementgg <- read.csv(location4)
head(placementgg)
colnames(placementgg)
str(placementgg)


# Scatter PLOT

base1 <- ggplot(placementgg, aes(x= ssc_p, y = hsc_p))
base1 + geom_point()


# Static
base1 + geom_point(shape = 22, color = "blue", fill = "red", size = 2) # You can add shape,colour,fill,size in geompoint()

# Dynamic - Make the aesthetics vary based on a variable

base1 + geom_point(aes(color = status))

base1 + geom_point()

# using geom_smooth()
base1 + geom_point() + geom_smooth()

base1 + geom_smooth(aes(color = status))


base1 + geom_smooth(aes(linetype = status))

base1 + geom_smooth(aes(group = status , linetype = status))

base1 + geom_smooth(aes(color = status))

base1 + geom_point(aes(colour = status)) + geom_smooth(aes(colour = status))

