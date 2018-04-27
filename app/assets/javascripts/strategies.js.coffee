# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
    makeGraph = (data) ->
        # json = JSON.parse(data)
        # json = data
        options =
            title: data["title"]["text"]
            chart:
                renderTo: "chart"
                type: "line"
                width: "640"
                height: "480"
            tooltip:
                pointFormat: data["tooltip"]["pointFormat"]
                shared: true
                useHTML: true
                style: {margin: 0}
            xAxis:
                title: data["xAxis"]["title"]
                categories: data["xAxis"]["categories"]
            yAxis:
                title: data["yAxis"]["title"]
            series: [{}]
        console.log(options)
        i = 0
        len = data["series"].length
        while i < len
            options.series[i] = {}
            options.series[i].name = data["series"][i]["name"]
            options.series[i].data = data["series"][i]["data"]
            i++
        chart = new Highcharts.Chart(options)
        return
    
    id = $("#strategy_id").val()
    $(window).on "load", ->
        authenticity_token = $("#authenticity_token").val()
        unless id?
          return
        $.ajax(
          url: id + "/paint.js"
          type: "GET"
          dataType: "json"
          data:
            id: id
            authenticity_token: authenticity_token
        ).done((data, status, xhr) ->
          console.log("1")
          console.log data
          makeGraph(data)
          return
        ).fail (xhr, status, error) ->
          alert "Error Occured(" + error + ")"
          return
  
        return
      $("#strategy_range").on "input", ->
          $('#range_val').html($(this).val());
          return
      $("#strategy_range").on "change", ->
          range = $(this).val()
          $.ajax(
              url: "/strategies/" + id + ".js"
              type: "PATCH"
              dataType: "json"
              data:
                  id: id
                  strategy:
                      range: range
          ).done((data, status, xhr) ->
              console.log("2")
              console.log data
              makeGraph(data)
              return
          ).fail (xhr, status, error) ->
              alert "Error Occured(" + error + ")"
              return
          return
      $("#strategy_sigma").on "input", ->
          $('#sigma_val').html($(this).val());
          return
      $("#strategy_sigma").on "change", ->
          sigma = $(this).val()
          $.ajax(
              url: "/strategies/" + id + ".js"
              type: "PATCH"
              dataType: "json"
              data:
                  id: id
                  strategy:
                      sigma: sigma
          ).done((data, status, xhr) ->
              console.log("3")
              console.log data
              makeGraph(data)
              return
          ).fail (xhr, status, error) ->
              alert "Error Occured(" + error + ")"
              return
          return
      $("#strategy_draw_type").on "change", ->
          chk = $(this).is(":checked") ? "1" : "0"
          $.ajax(
              url: "/strategies/" + id + ".js"
              type: "PATCH"
              dataType: "json"
              data:
                  id: id
                  strategy:
                      draw_type: (if chk then "1" else "0")
          ).done((data, status, xhr) ->
              console.log("4")
              console.log data
              makeGraph(data)
              return
          ).fail (xhr, status, error) ->
              alert "Error Occured(" + error + ")"
              return
  
          return
    return

