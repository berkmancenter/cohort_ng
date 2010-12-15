jQuery.noConflict();

jQuery(document).ready(function(){
    jQuery('.actions').css('min-height', jQuery('.main').height());
    jQuery('.accordion').accordion();
    jQuery.updateLists('contact');
    jQuery.updateLists('note');
    jQuery.observeDialogItem('a.dialog');
    if(jQuery('#tag_contexts-index')){
      jQuery.observeListItems('tag_context','all');
      jQuery.observeDestroyControls('.tag_context-list.all a.delete','tag_context');
    }

});
