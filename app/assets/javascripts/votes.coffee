# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.Vote ?= {}

Vote.renderRating = (e, date, status, xhr) ->
  e.preventDefault()
  data = $.parseJSON(xhr.responseText)
  $(this).hide

$(document)
  .on 'ajax:success', '.vote-up, .vote-down', Vote.renderRating
