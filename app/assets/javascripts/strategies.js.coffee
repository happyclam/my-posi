# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

makeGraph = (data) ->
#    json = JSON.parse(data)
    json = data
#    console.log(json)
    options =
        title: json["options"]["title"]
        chart:
            renderTo: "chart"
            type: "line"
            width: "640"
            height: "480"
        tooltip:
            pointFormat: json["options"]["tooltip"]["pointFormat"]
            shared: true
            useHTML: true
            style: {margin: 0}
        xAxis:
            title: json["options"]["xAxis"]["title"]
            categories: json["options"]["xAxis"]["categories"]
        yAxis:
            title: json["options"]["yAxis"]["title"]
        series: [{}]
    console.log(options)
    i = 0
    len = json["series_data"].length
    while i < len
        options.series[i] = {}
        options.series[i].name = json["series_data"][i]["name"]
        options.series[i].data = json["series_data"][i]["data"]
        i++
    chart = new Highcharts.Chart(options)
    return
    
jQuery ($) ->
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
            makeGraph(data)
            return
        ).fail (xhr, status, error) ->
            alert "Error Occured(" + error + ")"
            return

        return

    return
