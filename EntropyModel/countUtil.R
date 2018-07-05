normalizeCount <- function(data)
{
  data$freq <- data$count/sum(as.numeric(data$count))
	data$percent <- data$freq * 100
	return(data)
}