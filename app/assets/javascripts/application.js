// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require swfobject
//= require jquery.uploadify
//= require jquery.dataTables
//= require jquery.easing
//= require jquery.bxSlider
//= require_tree .

var goTo = function(url) {
    window.location.href = url;
}

$(function(){
  $('#slider').bxSlider({
    auto: true,
    pager: true,
    autoHover: true
  });
});

$(document).ready(function() {
    $('.ranking-table-active').dataTable( {
      "oLanguage":{ 
        "sProcessing":   "Proszę czekać...",
        "sLengthMenu":   "Pokaż _MENU_ pozycji",
        "sZeroRecords":  "Nie znaleziono żadnych pasujących wpisów",
        "sInfo":         "Pozycje od _START_ do _END_ ze _TOTAL_",
        "sInfoEmpty":    "Pozycji 0 z 0 dostępnych",
        "sInfoFiltered": "(filtrowanie spośród _MAX_ dostępnych pozycji)",
        "sInfoPostFix":  "",
        "sSearch":       "Szukaj:",
        "sUrl":          "",
        "oPaginate": {
          "sFirst":    "Pierwsza",
          "sPrevious": "Poprzednia",
          "sNext":     "Następna",
          "sLast":     "Ostatnia"
        }
      },
        "bPaginate": true,
        "bLengthChange": true,
        "bFilter": true,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": true,
        "aaSorting": [ [0,'asc'] ]
              
    } );
} );
