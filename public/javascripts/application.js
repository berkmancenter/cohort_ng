jQuery.noConflict();

jQuery(document).ready(function(){

    jQuery('.actions').css('min-height', jQuery('.main').height());
    jQuery('.accordion').accordion();

    jQuery('a.dialog').click(function(e){
        e.preventDefault();
        jQuery.ajax({
            cache: false,
            dataType: 'script',
            url: jQuery(this).attr('href'),
            success: function(html){
                var dialogNode = jQuery('<div></div>');
                jQuery(dialogNode).append(html);

                jQuery(dialogNode).find('form input.create').click(function(e){
                    e.preventDefault();
                    jQuery(dialogNode).find('form').ajaxSubmit({
                        dataType: 'script',
                        success: function(){
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
                    height: 400
                });
            }

        });

    });
    
    jQuery('.datepicker').datepicker({
        changeMonth: true,
        changeYear: true,
        minDate: "-100Y",
        dateFormat: 'yy-mm-dd'
    });

});


