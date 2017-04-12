# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".vote-up, .vote-down").bind 'ajax:success', (e, data, status, xhr) ->
    if data.value is 0
      $(this).hide()
    if data.value is -1
      $(this).next(".vote-down").show()
    if data.value is 1
      $(this).prev(".vote-up").show()
    $(this).closest("div.vote-links").prev().children("span.score").text(data.votable.rating)
