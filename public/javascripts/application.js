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
        error: function(xhr,errorStr,baz){
          jQuery.showMajorError(errorStr);
        }
      }
    }); 
});
