jQuery.noConflict();

jQuery(document).ready(function(){
    jQuery('.actions').css('min-height', jQuery('.main').height());
    jQuery('.accordion').accordion();
    jQuery.updateLists('contact');
    jQuery.updateLists('note');
    jQuery.observeDialogForm('a.dialog-form');
    jQuery.observeDialogShow('a.dialog-show');
    jQuery.observeListPagination();
    jQuery.observeListItems();
    jQuery.observeDestroyControls();
});
