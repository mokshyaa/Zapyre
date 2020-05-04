//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require bootstrap-sprockets
//= require_self
//= require jquery.turbolinks

//= require bootstrap/dropdown

$(document).ready(function(){
  setTimeout(function(){
    $('#flash').remove();
  }, 2000);
 })

$(document).ready(function(){
  setTimeout(function(){
  	location.reload();
  }, 30000);
 })

