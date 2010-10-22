jQuery.noConflict();

jQuery(document).ready(function(){
    jQuery('.actions').css('min-height', jQuery('.main').height());
    jQuery('.accordion').accordion();
    jQuery.updateContactLists();
    jQuery('a.dialog').click(function(e){
        e.preventDefault();
        jQuery.ajax({
            cache: false,
            dataType: 'script',
            url: jQuery(this).attr('href'),
            beforeSend: function(){
              jQuery.showGlobalSpinnerNode();
            },
            error: function(xhr){
              jQuery.hideGlobalSpinnerNode();
              jQuery.showMajorError(xhr); 
            },
            success: function(html){
                jQuery.hideGlobalSpinnerNode();
                var dialogNode = jQuery('<div></div>');
                jQuery(dialogNode).append(html);

                jQuery(dialogNode).find('form input.create').click(function(e){
                    e.preventDefault();
                    jQuery(dialogNode).find('form').ajaxSubmit({
                        dataType: 'script',
                        success: function(){
                            jQuery.updateContactLists();
                            jQuery(dialogNode).dialog('close');
                        },
                        error: function(xhr){
                            jQuery('#error').show().html(xhr.responseText);
                        }
                    });
            
                });
                jQuery(dialogNode).dialog({
                    show: 'explode',
                    hide: 'explode',
                    modal: true,
                    width: 500,
                    height: 400,
                    open: function(){
                        jQuery.initDateControl();
                    },
                    close: function(){
                        jQuery(dialogNode).remove();
                    }
                });
            }
        });
    });

});
