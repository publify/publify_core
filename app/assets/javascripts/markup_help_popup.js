$(document).ready(function() {
  $('.markup-help-popup-link').on("click", function(e){
    var dialog = document.getElementById(e.target.dataset["target"]);
    var url = e.target.dataset.url;

    $.ajax({
      url: url,
      type: 'get',
      dataType: 'html',
      success: function(data) {
        dialog.getElementsByClassName("content-target").item(0).innerHTML = data;
        dialog.showModal();
      }
    });
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
