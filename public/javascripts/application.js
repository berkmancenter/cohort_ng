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
      // So here's where we'll get the contact id and the contact list id and then do the dirty work
    }
  });

  jQuery('.add_to_list').live({
    click: function(e){
      e.preventDefault();
      var contactId = jQuery('.bt-active').closest('li').attr('class').split('-')[1];
      // Open a dialog to select the list.
      var dialog = jQuery('<div><h1>Contact lists</h1><div class="subtabs"><ul><li><a href="/contact_cart_query/yours">Mine</a></li><li><a href="/contact_cart_query/all">All</a></li><li><a href="/contact_cart_query/your_private">Private</a></li></ul></div></div>');
      jQuery(dialog).dialog({
        modal: true,
        position: 'top'
      });
      jQuery(dialog).dialog('open');
      jQuery(dialog).find('.subtabs').tabs({
        ajaxOptions: {
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
