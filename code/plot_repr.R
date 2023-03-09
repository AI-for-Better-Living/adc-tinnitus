plot_repr = function(df,df1,df0, legend=TRUE, title_xaxis= "time") {
  require(plotly)
  color1 = "rgb(58,95,205)"
  color2 = "rgba(51, 153, 255,0.2)"#"rgba(0,100,80,0.2)"
  color3 = "rgba(200, 200, 200, 0.2)"
  
  vline <- function(x = 0, color = "green") {
    list(
      type = "line",
      y0 = 0,
      y1 = 1,
      yref = "paper",
      x0 = x,
      x1 = x,
      line = list(color = color, dash="dot")
    )
  }
  
  fig = plot_ly(df) %>% 
    layout(xaxis=list(range = c(min(df$save_date)-1,max(df$save_date)+1), 
                      title = title_xaxis),
           yaxis = list(title = "tinnitus severity"))
  
  fig = fig%>% add_trace(df, x=~save, y=df$gt_h, type='scatter', mode='lines', 
                         name = "ground truth thresholds",line = list(color=color3, shape="hv"), opacity = 1,
                         showlegend = FALSE)
  fig = fig%>% add_trace(df, x=~save, y=df$gt_l, type='scatter', mode='lines', 
                         showlegend = FALSE, line = list(color=color3, shape="hv"), opacity = 1)
  fig = fig%>% add_trace(df, x=~save, y=df$gt_h, type='scatter', mode='lines',
                         name = "ground truth", line = list(color=color3, shape="hv"), opacity =0.5,
                         fill = 'tonexty', fillcolor=color3,
                         showlegend = legend)
  fig = fig%>% layout(plot_bgcolor = "#e5ecf6", shapes = list(type = "rect",
                                                              fillcolor = color3,
                                                              line = list(color = color3),
                                                              opacity = 0.2,
                                                              y0 = df$low_quantiles[length(df$user_id)],
                                                              y1 = df$high_quantiles[length(df$user_id)],
                                                              x0 = min(df$save_date) ,
                                                              x1 = max(df$save)))
  
  
  fig = fig%>% add_trace(df, x=~save, y=~high_quantiles, type='scatter', mode='lines', 
                         name="non-extreme values region thresholds",line = list(color=color2, shape="hv"), opacity = 1,
                         showlegend = FALSE)
  fig = fig%>% add_trace(df, x=~save, y=~low_quantiles, type='scatter', mode='lines', 
                         name = "non-extreme values region", line = list(color=color2, shape="hv"), opacity =0.5, 
                         fill = 'tonexty', fillcolor=color2,
                         showlegend = legend)
  fig = fig%>% add_trace(df, x=~save, y=~low_quantiles, type='scatter', mode='lines', 
                         showlegend=FALSE, line = list(color=color2, shape="hv"), opacity =1)
  
  
  fig = fig%>% add_trace(data=df1, x=~save, y=~question2, type = 'scatter', mode = 'markers',
                         marker = list(color=color1, size =6.5, 
                                       line = list(color=color1, width=1)), 
                         name = "triggered tasks",
                         showlegend = legend)
  fig = fig%>% add_trace(data=df0, x=~save, y=~question2, type = 'scatter', mode = 'markers',
                         marker = list(color="rgb(255, 255, 255)", size = 7.5, 
                                       line=list(color=color1, width = 1.5 )), 
                         name='untriggered tasks',
                         showlegend = legend)
  fig = fig%>% add_trace(data = df, x=~save, y=~question2, type='scatter', mode='lines',
                         name="quantity of interest", line = list(color=color1),
                         showlegend = legend)
  
  fig = fig %>%  layout(
    yaxis = list(
      range=c(0,1)
    )
  )
  
  return(fig)
}

# Input
#   df = dataframe with 9 columns: user_id
#                       save (time of the tinnitus severity sample)
#                       save_id
#                       question2 (tinnitus severity values)
#                       high_quantiles (higher thresholds)
#                       low_quantiles (lower thresholds)
#                       triggers (0 for untriggered and 1 for triggered tasks)
#                       gt_h (higher threshold of the ground truth)
#                       gt_l (lower threshold of the ground truth)
#   df0 = subset of untriggered tasks in df
#   df1 = subset of triggered tasks in df
#   legend = logical value for plotting the legend 
#   title_axis = title of the plot on the x axis
#   
# Output
#   fig = graph representing the data, the triggers, the non-extreme value region 
#         and the groung truth
