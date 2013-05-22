$(document).ready(function(){
  $.ajaxPrefilter(function(options, originalOptions, xhr){
    var token = $('meta[name="csrf-token"]').attr('content');
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  });
  $('.actions').css('min-height', $('.main').height());
  $('.accordion').accordion();
  $.updateLists('contact');
  $.updateLists('document');
  $.updateLists('note');
  //    $.updateLists('tag');
  $.observeDialogForm('a.dialog-form');
  $.observeDialogShow('a.dialog-show');
  $.observeListPagination();
  //    $.observeListItems();
  $.observeDestroyControls();

  $('.tabs').tabs({
    ajaxOptions: {
      cache: false,
      dataType: 'html',
      beforeSend: function(){
        $.showGlobalSpinnerNode();
      },
      complete: function(){
        $.hideGlobalSpinnerNode();
      },
      error: function(xhr,textStatus,errorStr){
        if (xhr.status !== 0 && xhr.readyState !== 0) {
		  $.showMajorError(textStatus);
		}
      }
    }
  });

  $('.button').button();
  
  $('.quick_search_tag,.search_tag,.quick_tag_list').tagSuggest({
    url: $.rootPath() + 'contact_query/autocomplete_tags',
	separator: ', ',
    delay: 500
  });

  $('.quick_contact_form').ajaxForm({
    beforeSerialize: function(arr, $form, options){
      $.mergeContactTagsForSubmit($('.quick_contact_form'));
    },
    success: function(){
      window.location.reload();
    },
    error: function(e){
      console.log(e);
      $('#quick_contact_error').html(e.responseText).show();
    }
  });

  $('#quick_search_submit').click(function(e){
    e.preventDefault();
    // goes into #quick_search_results
    $.ajax({
      cache: false,
      dataType: 'html',
      url: $.rootPath() + 'contact_query/tag_contacts_by_name/' + encodeURI($('#quick_search_tag').val()),
      beforeSend: function(){
        $.showGlobalSpinnerNode();
      },
      error: function(jqXHR, textStatus, errorThrown){
		$.showMajorError(textStatus);
      },
      complete: function(){
        $.hideGlobalSpinnerNode();
      },
      success: function(html){
        $('#quick_search_results').html(html);
      }
    });
  });

  $('.select_for_contact_cart').live({
    click: function(e){
      e.preventDefault();
      var contact_cart_id = $(this).attr('data_contact_cart_id');
      var objectType = $.data(document.body, 'selected_object_type');
      var objectId = $.data(document.body, 'selected_object_id');
      $.ajax({
        cache: false,
        type: 'POST',
        dataType: 'html',
        data: {object_id: objectId, object_type: objectType},
        url: $.rootPath() + 'contact_carts/' + contact_cart_id + '/add_object',
        beforeSend: function(){
          $.showGlobalSpinnerNode();
        },
        success: function(message){
          $('#add-contact-to-list').html(message);
          window.setTimeout(function(){
            $('#add-contact-to-list').dialog('close').remove();
          }, 1200);
        },
        error: function(xhr){
          $.showMajorError(xhr);
        },
        complete: function(){
          $.hideGlobalSpinnerNode();
        }
      });

    }
  });

  $('.add_to_list').live({
    click: function(e){
      e.preventDefault();
      var objectType = $(this).attr('data_object_type');
      var objectId = $(this).attr('data_object_id');
      var objectTitle = $(this).attr('title');
      $.data(document.body, 'selected_object_type', objectType);
      $.data(document.body, 'selected_object_id', objectId);
      // Open a dialog to select the list.
      var dialog = $('<div id="add-contact-to-list"><h1>Contact lists</h1><div class="subtabs"><ul><li><a href="/contact_cart_query/yours">Mine</a></li><li><a href="/contact_cart_query/all">All</a></li><li><a href="/contact_cart_query/your_private">Private</a></li></ul></div></div>');
      $(dialog).dialog({
        title: 'Add "'+ objectTitle + '" to a contact list',
        modal: true,
        position: 'top'
      });
      $(dialog).dialog('open');
      $(dialog).find('.subtabs').tabs({
        ajaxOptions: {
          cache: false,
          dataType: 'html',
          data: {select_for_contact_cart: 1}
        }
      });
    }
  });

  $('.control').live({
    click: function(e){
      e.preventDefault();
      var id = $(this).attr('id');
      $(this).bt({
        trigger: 'none',
        contentSelector: $('#' + id + '-target'),
        textzIndex: 101,
        boxzIndex: 100,
        wrapperzIndex: 99,
        closeWhenOthersOpen: true
      });
      $(this).btOn();
    }
  });

  $('.expand_tag').live({
    click: function(e){
      var node = this;
      $(node).attr('expanded',(($(node).attr('expanded') == undefined) ? 0 : 1));
      e.preventDefault();
      if($(node).attr('expanded') == 0){
        $.ajax({
          cache: false,
          dataType: 'html',
          url: $.rootPath() + 'tags/' + $(this).attr('data_tag_id') + '/children',
          success: function(html){
            $(node).next().after(html);
          }
        });
      }
    }
  });

});

function toggle() {
	var ele = document.getElementById("toggleText");
	var text = document.getElementById("displayText");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Add to Contact List <img src='/images/icons/arrow_right.png' />";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Add to Contact List <img src='/images/icons/arrow_right.png' />";
	}
} 

function toggle1() {
	var ele = document.getElementById("toggleText1");
	var text = document.getElementById("displayText1");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Add Note <img src='/images/icons/arrow_right.png' />";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Add Note <img src='/images/icons/arrow_right.png' />";
	}
}

function toggle2() {
	var ele = document.getElementById("toggleText2");
	var text = document.getElementById("displayText2");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Add Task <img src='/images/icons/arrow_right.png' />";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Add Task <img src='/images/icons/arrow_right.png' />";
	}
}

function toggle3() {
	var ele = document.getElementById("toggleText3");
	var text = document.getElementById("displayText3");
	if(ele.style.display == "block") {
    		ele.style.display = "none";
		text.innerHTML = "Add Tags <img src='/images/icons/arrow_right.png' />";
  	}
	else {
		ele.style.display = "block";
		text.innerHTML = "Add Tags <img src='/images/icons/arrow_right.png' />";
	}
}
