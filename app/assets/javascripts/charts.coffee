# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


drawChart = (graph_values) ->
  # Create the data table.
  data = new google.visualization.DataTable()
  data.addColumn('date', 'Date')
  data.addColumn('number', 'CAC40')
  data.addColumn('number', 'AI')
  data.addColumn('number', 'RENAULT')
  data.addColumn('number', 'QUANTUM')
  
  for i in [0...graph_values.length]
    date = new Date(graph_values[i][0])
    console.log( graph_values[i][0])
    console.log( date )
    cac_value = graph_values[i][1]
    ai_value = graph_values[i][2]
    rno_value = graph_values[i][3]
    qtm_value = graph_values[i][4]
    data.addRow([date,cac_value,ai_value,rno_value, qtm_value])

  options = {
    vAxes:
      0: logScale: false
      1: logScale: false
      2: logScale: false
    series:
       0: targetAxisIndex:0
       1: targetAxisIndex:0
       2: targetAxisIndex:0
       3: targetAxisIndex:0
    widht: 1000
    height: 1000
  }

  chart = new google.visualization.LineChart(document.getElementById('chart_div'))
  chart.draw(data, options)

px1 = ->
  $.ajax
   url: '/charts/px1'
   type: 'GET'
   data: {}
   dataType: 'json'
   error: (jqXHR, textStatus, errorThrown) ->
     console.log("error" + jqXHR + textStatus + errorThrown)
   success: (data, textStatus, jqXHR) ->
     #console.log("success" + data)
     drawChart(data)

$ ->
  # Load the Visualization API and the corechart package.
  # Callback that creates and populates a data table,
  # instantiates the pie chart, passes in the data and
  # draws it.

  google.charts.load 'current', 'packages': [ 'corechart' ]
  # Set a callback to run when the Google Visualization API is loaded.
  google.charts.setOnLoadCallback px1 #drawChart
