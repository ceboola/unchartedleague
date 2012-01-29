# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.show_waiting_info = (id) ->
    $(id).html('<div class="flash info"><img src="/img/preloader.gif" alt="..." /></div>')