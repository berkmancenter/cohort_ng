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
    updateContactLists: function(){
        jQuery('.contact-list').each(function(contactListNode){
            var listType = 'recent';
            if(jQuery(this).hasClass('recent')){
                listType = 'recent';
            } else if(jQuery(this).hasClass('yours')){
                listType = 'yours';
            } else if(jQuery(this).hasClass('new')){
                listType = 'new';
            }
            jQuery.ajax({
                dataType: 'script',
                cache: false,
                url: jQuery.rootPath() + 'contact_query/' + listType,
                beforeSend: function(){
                    jQuery('.' + listType).html(jQuery.interiorSpinnerNode(listType));
                },
                error: function(){
                    jQuery('.' + listType).html('There seems to have been a problem! < fail whale >. Please try again later.');
                },
                success: function(html){
                    jQuery('.' + listType).html(html);
                    jQuery.observeListPagination(listType);
                }
            });
        });
    },

    observeListPagination: function(listType){
        jQuery('.' + listType + ' .pagination a').click(function(e){
            e.preventDefault();
            jQuery.ajax({
                type: 'GET',
                url: jQuery(this).attr('href'),
                dataType: 'script',
                beforeSend: function(){
                    jQuery('.' + listType).html(jQuery.interiorSpinnerNode(listType));
                },
                success: function(html){
                    jQuery('.' + listType).html(html);
                    jQuery.observeListPagination(listType);
                }
            });
        });
    }
});
