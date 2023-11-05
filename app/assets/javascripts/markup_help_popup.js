$(document).ready(function() {
  $('.markup-help-popup-link').on("click", function(e){
    var dialog = document.getElementById(e.target.dataset["target"]);
    dialog.showModal();
    e.preventDefault();
  });
  $('.markup-help-popup-close').on("click", function(e) {
    e.target.closest('dialog').close();
  });
  $('.markup-help-popup').on("click", function(e) {
    if (e.target == e.currentTarget) {
      e.target.close();
    }
  });
});
