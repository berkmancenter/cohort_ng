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
      jQuery('.datepicker').each(function(){
        var dateRange = (jQuery(this).attr('id').match(/birth/)) ? 'c-115:c' : '-10y:+10y';
        jQuery(this).datepicker({
            changeMonth: true,
            changeYear: true,
            yearRange: dateRange,
            dateFormat: 'yy-mm-dd'
          });
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
            } else if(jQuery(this).hasClass('all')){
              listType = 'all';
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
                  jQuery.observeDestroyControls('.' + objectType + '-list.' + listType +' a.delete',objectType);
                }
            });
        });
    },

    observeDestroyControls: function(rootClass,objectType){
      jQuery(rootClass).click(function(e){
        e.preventDefault();
        var destroyUrl = jQuery(this).attr('href');
        var confirmNode = jQuery('<div><p>Are you sure you want to delete this item?</p></div>');
        jQuery(confirmNode).dialog({
          title: 'Delete this item?',
          modal: true,
          buttons: {
            Cancel: function(){
              jQuery(confirmNode).dialog('close');
            },
            'Yes, delete it': function(){
              jQuery.ajax({
                cache: false,
                type: 'POST',
                url: destroyUrl,
                dataType: 'script',
                data: {'_method': 'delete'},
                beforeSend: function(){
                  jQuery.showGlobalSpinnerNode();
                },
                error: function(xhr){
                  jQuery.hideGlobalSpinnerNode();
                  jQuery.showMajorError(xhr);
                },
                success: function(){
                  jQuery.hideGlobalSpinnerNode();
                  jQuery.updateLists(objectType);
                  jQuery(confirmNode).dialog('close');
                }
              });
            }
          },
          close: function(){
            jQuery(confirmNode).remove();
          }
        }).dialog('open');
      });
    },

    observeListItems: function(objectType, listType){
      var classToObserve = '.' + objectType + '-list.' + listType + ' li';
        jQuery(classToObserve).bind({
          mouseover: function(e){
            jQuery(this).addClass('hover');
            jQuery(this).find('.floating-control').show();
          },
          mouseout: function(e){
            jQuery(this).removeClass('hover');
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
                            jQuery(dialogNode).dialog('close');
                            jQuery(dialogNode).remove();
                        },
                        Submit: function(){
                            jQuery(dialogNode).find('form').ajaxSubmit({
                                dataType: 'script',
                                success: function(){
                                    jQuery.updateLists('contact');
                                    jQuery.updateLists('note');
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
