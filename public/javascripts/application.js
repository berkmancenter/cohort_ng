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
        $.showMajorError(textStatus);
      }
    }
  });

  $('.button').button();
  
  $('.quick_search_tag').tagSuggest({
    url: $.rootPath() + 'contact_query/autocomplete_tags',
    delay: 500
  });

  $('.search_tag').tagSuggest({
    url: $.rootPath() + 'contact_query/autocomplete_tags',
    separator: ', ',
    delay: 500
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
