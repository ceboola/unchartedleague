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
    pager: true
  });
});

//$(document).ready(function() {
//    $('.ranking-table').dataTable( {
//        "bPaginate": false,
//        "bLengthChange": false,
//        "bFilter": false,
//        "bSort": false,
//        "bInfo": false,
//        "bAutoWidth": true,
//        "aaSorting": [ [0,'asc'], [1,'asc'] ]
//    } );
//} );
