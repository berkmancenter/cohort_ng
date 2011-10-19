jQuery.noConflict();

jQuery(document).ready(function(){
  jQuery.ajaxPrefilter(function(options, originalOptions, xhr){
    var token = jQuery('meta[name="csrf-token"]').attr('content');
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  });
  jQuery('.actions').css('min-height', jQuery('.main').height());
  jQuery('.accordion').accordion();
  jQuery.updateLists('contact');
  jQuery.updateLists('document');
  jQuery.updateLists('note');
  //    jQuery.updateLists('tag');
  jQuery.observeDialogForm('a.dialog-form');
  jQuery.observeDialogShow('a.dialog-show');
  jQuery.observeListPagination();
  //    jQuery.observeListItems();
  jQuery.observeDestroyControls();

  jQuery('.tabs').tabs({
    ajaxOptions: {
      cache: false,
      dataType: 'html',
      beforeSend: function(){
        jQuery.showGlobalSpinnerNode();
      },
      complete: function(){
        jQuery.hideGlobalSpinnerNode();
      },
      error: function(xhr,textStatus,errorStr){
        jQuery.showMajorError(textStatus);
      }
    }
  });
  
  jQuery('.quick_search_tag').tagSuggest({
    url: jQuery.rootPath() + 'contact_query/autocomplete_tags',
    delay: 500
  });
  jQuery('#quick_search_submit').click(function(e){
    e.preventDefault();
    // goes into #quick_search_results
    jQuery.ajax({
      cache: false,
      dataType: 'html',
      url: jQuery.rootPath() + 'contact_query/tag_contacts_by_name/' + encodeURI(jQuery('#quick_search_tag').val()),
      beforeSend: function(){
        jQuery.showGlobalSpinnerNode();
      },
      error: function(jqXHR, textStatus, errorThrown){
        jQuery.showMajorError(textStatus);
      },
      complete: function(){
        jQuery.hideGlobalSpinnerNode();
      },
      success: function(html){
        jQuery('#quick_search_results').html(html);
      }
    });
  });

  jQuery('.select_for_contact_cart').live({
    click: function(e){
      e.preventDefault();
      var contact_cart_id = jQuery(this).attr('id').split('-')[1];
      var contact_id = jQuery.data(document.body, 'selected_contact_id');
      jQuery.ajax({
        cache: false,
        type: 'POST',
        dataType: 'html',
        data: {contact_id: contact_id},
        url: jQuery.rootPath() + 'contact_carts/' + contact_cart_id + '/add_contact',
        beforeSend: function(){
          jQuery.showGlobalSpinnerNode();
        },
        success: function(message){
          jQuery('#add-contact-to-list').html(message);
          window.setTimeout(function(){
            jQuery('#add-contact-to-list').dialog('close').remove();
          }, 1200);
        },
        error: function(xhr){
          jQuery.showMajorError(xhr);
        },
        complete: function(){
          jQuery.hideGlobalSpinnerNode();
        }
      });

    }
  });

  jQuery('.add_to_list').live({
    click: function(e){
      e.preventDefault();
      var contactId = jQuery('.bt-active').closest('li').attr('class').split('-')[1];
      jQuery.data(document.body, 'selected_contact_id', contactId);
      // Open a dialog to select the list.
      var dialog = jQuery('<div id="add-contact-to-list"><h1>Contact lists</h1><div class="subtabs"><ul><li><a href="/contact_cart_query/yours">Mine</a></li><li><a href="/contact_cart_query/all">All</a></li><li><a href="/contact_cart_query/your_private">Private</a></li></ul></div></div>');
      jQuery(dialog).dialog({
        title: 'Add "'+ jQuery('li.contact-' + contactId + ' .dialog-show').html() + '" to a contact list',
        modal: true,
        position: 'top'
      });
      jQuery(dialog).dialog('open');
      jQuery(dialog).find('.subtabs').tabs({
        ajaxOptions: {
          cache: false,
          dataType: 'html',
          data: {select_for_contact_cart: 1}
        }
      });

    }
  });

  jQuery('.control').live({
    click: function(e){
      e.preventDefault();
      var id = jQuery(this).attr('id');
      jQuery(this).bt({
        trigger: 'none',
        contentSelector: jQuery('#' + id + '-target'),
        textzIndex: 101,
        boxzIndex: 100,
        wrapperzIndex: 99,
        closeWhenOthersOpen: true
      });
      jQuery(this).btOn();
    }
  });

});
