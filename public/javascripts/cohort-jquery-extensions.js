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
                }
            });
        });
    },

    observeListItems: function(objectType, listType){
        jQuery('.' + objectType + '-list.' + listType + ' li').bind({
          mouseover: function(e){
            var elId = jQuery(this).attr('id').split('-')[0];
            jQuery(this).append('<span class="floating-control" id="control-' + objectType + '-' + elId + '">edit</a>');
          },
          mouseout: function(e){
            var elId = jQuery(this).attr('id').split('-')[0];
            jQuery('#control-' + objectType + '-' + elId).remove();
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
    }
});
