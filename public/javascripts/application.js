jQuery.noConflict();

jQuery(document).ready(function(){
    jQuery('.actions').css('min-height', jQuery('.main').height());
    jQuery('.accordion').accordion();
    jQuery.updateLists('contact');
    jQuery.updateLists('note');
    jQuery.observeDialogItem('a.dialog');

});
