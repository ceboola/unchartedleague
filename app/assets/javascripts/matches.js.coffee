# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.submit_all = () ->
    $(".results_updated_token").html('<div class="flash info"><img src="/img/preloader.gif" alt="..." /></div>')
    $(".edit_match_map").submit()