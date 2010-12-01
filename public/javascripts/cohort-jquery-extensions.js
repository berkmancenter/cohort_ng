jQuery.extend({
    rootPath: function(){
        return '/'
    },
    showGlobalSpinnerNode: function(){
        jQuery('#spinner').show();
    },
    hideGlobalSpinnerNode: function(){
        jQuery('#spinner').hide();
    },
    showMajorError: function(xhr){
        jQuery('<div></div>').html(xhr.responseText).dialog({
            modal: true
        }).dialog('open');
    },
    interiorSpinnerNode: function(spinnerNamespace){
        jQuery('<img class="spinner-' + spinnerNamespace + '" src="' + jQuery.rootPath() + 'images/ajax-loader.gif" />');
    },
    initDateControl: function(){
        jQuery('.datepicker').datepicker({
            changeMonth: true,
            changeYear: true,
            yearRange: 'c-115:c',
            dateFormat: 'yy-mm-dd'
        });
    },
    updateLists: function(objectType){
        jQuery('.' + objectType + '-list').each(function(listNode){
            var listType = 'recent';
            if(jQuery(this).hasClass('recent')){
                listType = 'recent';
            } else if(jQuery(this).hasClass('yours')){
                listType = 'yours';
            } else if(jQuery(this).hasClass('new')){
                listType = 'new';
            } else if(jQuery(this).hasClass('upcoming')){
                listType = 'upcoming';
            } else if(jQuery(this).hasClass('all_upcoming')){
                listType = 'all_upcoming';
            }
            jQuery.ajax({
                dataType: 'script',
                cache: false,
                url: jQuery.rootPath() + objectType + '_query/' + listType,
                beforeSend: function(){
                    jQuery('.' + objectType + '-list.' + listType).html(jQuery.interiorSpinnerNode(listType));
                },
                error: function(){
                    jQuery('.' + objectType + '-list.' + listType).html('There seems to have been a problem! < fail whale >. Please try again later.');
                },
                success: function(html){
                  jQuery('.' + objectType + '-list.' + listType).html(html);
                  jQuery.observeListPagination(objectType,listType);
                  jQuery.observeListItems(objectType,listType);
                  jQuery.observeDialogItem('.' + objectType + '-list.' + listType +' a.dialog');
                }
            });
        });
    },

    observeListItems: function(objectType, listType){
        jQuery('.' + objectType + '-list.' + listType + ' li').bind({
          mouseover: function(e){
            jQuery(this).find('.floating-control').show();
          },
          mouseout: function(e){
            jQuery(this).find('.floating-control').hide();
          }
        });
    },

    observeListPagination: function(objectType,listType){
        jQuery('.' + objectType + '-list.' + listType + ' .pagination a').click(function(e){
            e.preventDefault();
            jQuery.ajax({
                type: 'GET',
                url: jQuery(this).attr('href'),
                dataType: 'script',
                beforeSend: function(){
                    jQuery('.' + objectType + '-list.' + listType).html(jQuery.interiorSpinnerNode(listType));
                },
                success: function(html){
                    jQuery('.' + objectType + '-list.' + listType).html(html);
                    jQuery.observeListPagination(objectType,listType);
                    jQuery.observeListItems(objectType,listType);
                }
            });
        });
    },
    observeDialogItem: function(rootClass){
        jQuery(rootClass).click(function(e){
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
                jQuery(dialogNode).dialog({
                    show: 'explode',
                    hide: 'explode',
                    modal: true,
                    width: 'auto',
                    height: 'auto',
                    position: 'top',
                    buttons: {
                        Cancel: function(){
                            jQuery(dialogNode).dialog(close);
                            jQuery(dialogNode).remove();
                        },
                        Submit: function(){
                            jQuery(dialogNode).find('form').ajaxSubmit({
                                dataType: 'script',
                                success: function(){
                                    jQuery.updateLists('contact');
                                    jQuery(dialogNode).dialog('close');
                                },
                                error: function(xhr){
                                    jQuery('#error').show().html(xhr.responseText);
                                }
                            });
                        }
                    },
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
    }
});
