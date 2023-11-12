$(document).ready(function() {
  $('.optional_field').hide();
  $('.optional-field-toggle').on("click", function(e){
    $('.optional_field').fadeToggle();
    e.preventDefault();
  });
});
