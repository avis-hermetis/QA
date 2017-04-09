# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#window.Vote ?= {}

#Vote.renderRating = (e, date, status, xhr) ->
  #e.preventDefault()
  #data = $.parseJSON(xhr.responseText)
 # $(this).hide

#$(document)
  #.on 'ajax:success', '.vote-up, .vote-down', Vote.renderRating

ready ->
  xhr = XMLHttpRequest()
  data = JSON.parse(xhr.responseText)

  $(".vote-up-#{data.class.name.downcase}-#{data.id}").bind 'ajax:success', (e, data, status, xhr) ->
    $(this).hide()
    $(".vote-up-#{data.class.name.downcase}-#{data.id}").show
    $(".vote-rating").attr(data.rating)
  $(".vote-down-#{data.class.name.downcase}-#{data.id}").bind 'ajax:success', (e, data, status, xhr) ->
    $(this).hide()
    $(".vote-up-#{data.class.name.downcase}-#{data.id}").show
    $(".vote-rating p").attr(data.rating)
