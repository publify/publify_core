// Admin javascript manifest
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require popper
//= require bootstrap-sprockets
//= require quicktags
//= require tagmanager
//= require typeahead
//= require sidebar
//= require spinnable
//= require lightbox
//
//= require_self

/* typewatch() borrowed from
 * http://stackoverflow.com/questions/2219924/idiomatic-jquery-delayed-event-only-after-a-short-pause-in-typing-e-g-timew
 */
var typewatch = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  }
})();

function autosave_request(e) {
  $('#article_form').keyup(function() {
    typewatch(function() {
      $.ajax({
        type: "POST",
        url: '/admin/content/autosave',
        data: $("#article_form").serialize()});
    }, 5000)
  });
}

function tag_manager() {
  var tagApi = jQuery("#article_keywords").tagsManager({
    prefilled: $('#article_keywords').val()
  });

  jQuery("#article_keywords").typeahead({
    name: 'tags',
    limit: 15,
    prefetch: '/admin/content/auto_complete_for_article_keywords'
  }).on('typeahead:selected', function (e, d) {
    tagApi.tagsManager("pushTag", d.value);
  });
}

function save_article_tags() {
  $('#article_keywords').val($('#article_form').find('input[name="hidden-article[keywords]"]').val());
}

// From http://www.shawnolson.net/scripts/public_smo_scripts.js
function check_all(checkbox) {
  var form = checkbox.form, z = 0;
  for(z=0; z<form.length;z++){
    if(form[z].type == 'checkbox' && form[z].name != 'checkall'){
      form[z].checked = checkbox.checked;
    }
  }
}

$(document).ready(function() {
  $('#article_form').each(function(e){autosave_request(e)});
  $('#article_form').submit(function(e){save_article_tags()});
  $('#article_form').each(function(e){tag_manager()});
  $('#checkall').click(function(e){check_all(e.target)});

  const lightboxModal = document.getElementById('image-lightbox-modal');
  if (lightboxModal) {
    lightboxModal.addEventListener('show.bs.modal', event => {
      const triggerElem = event.relatedTarget;
      const imageUrl = triggerElem.getAttribute('data-bs-imageurl');
      const imageElem = lightboxModal.querySelector('.modal-body img')
      imageElem.src = imageUrl;
    })
  }
});
