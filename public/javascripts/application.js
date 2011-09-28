jQuery.noConflict();

jQuery(document).ready(function(){
    jQuery('.actions').css('min-height', jQuery('.main').height());
    jQuery('.accordion').accordion();
    jQuery.updateLists('contact');
    jQuery.updateLists('document');
    jQuery.updateLists('note');
//    jQuery.updateLists('tag');
    jQuery.observeDialogForm('a.dialog-form');
    jQuery.observeDialogShow('a.dialog-show');
    jQuery.observeListPagination();
    jQuery.observeListItems();
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
      separator: ',',
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

    jQuery('.control').click(function(e){
      // TODO!

    });

});
