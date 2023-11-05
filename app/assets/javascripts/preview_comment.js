$(document).ready(function() {
  $('.preview-comment-link').on("click", function(e) {
    var lnk = e.currentTarget;
    var preview_url = lnk.dataset.previewUrl;
    var comment_form_selector = lnk.dataset.targetForm;

    $.post(preview_url, $(comment_form_selector).serialize());
    e.preventDefault();
  });
});
