$(document).ready(function() {
  $('.optional-field-toggle').on("click", function(e){
    $('.optional_field').fadeToggle();
    e.preventDefault();
  });
});
