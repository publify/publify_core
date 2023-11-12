// Show and hide spinners on Ajax requests.
$(document).ready(function(){
  $('#spinner').hide().removeClass("hidden");
  $('form.spinnable').on('ajax:before', function(evt, xhr, status){
    $('#spinner').show();
  });
  $('form.spinnable').on('ajax:complete', function(evt, xhr, status){
    $('#spinner').hide();
  });
});
