#TODO: This is still coded to an absolute path that may not match in a replication.
getProject <- function(filepath)
{
  return(strsplit(filepath, "/")[[1]][6])
}

drawMRRBoxplot <- function(data, title, ylabel, output_file)
{
  plot_out = ggplot(data, aes(x = variable, y = value, fill = variable)) + 
    geom_boxplot() +  
    scale_fill_manual(values=cbbPalette) + 
    theme(axis.text.x = element_text(size=14, face = "bold"), 
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=12),
          axis.title.y = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") +
    ylab(ylabel) + 
    ggtitle(title)
  print(plot_out)
  ggsave(plot_out, file = output_file, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
}

drawMRRViolin <- function(data, title, ylabel, output_file)
{
  plot_out = ggplot(data, aes(x = variable, y = value, fill = variable)) + 
    geom_violin() +  
    scale_fill_manual(values=cbbPalette) + 
    theme(axis.text.x = element_text(size=14, face = "bold"), 
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=12),
          axis.title.y = element_text(size=14),
          panel.grid.major.y = element_line(colour = "#f1f1f1", size = 1),
          panel.background = element_rect(fill = "white"),
          legend.position="none") +
    ylab(ylabel) + 
    ggtitle(title)
  print(plot_out)
  ggsave(plot_out, file = output_file, height = 13.2, width = 19.05, units = 'cm', dpi = 600)
}