//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-notify
//= require_self

$(document).ready(function () {
  document.getElementById('got_it').addEventListener('click', function (event) {
    document.getElementById('notification').style.display = 'none';
    event.preventDefault();
  });
});
