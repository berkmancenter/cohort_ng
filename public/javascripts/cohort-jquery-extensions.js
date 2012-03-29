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
    showMajorError: function(error){
        jQuery('<div></div>').html("We're sorry, there appears to have been an error.<br/>" + error).dialog({
            modal: true
        }).dialog('open');
    },
    interiorSpinnerNode: function(spinnerNamespace){
        return jQuery('<img class="spinner-' + spinnerNamespace + '" src="' + jQuery.rootPath() + 'images/ajax-loader.gif" />');
    },
    hideInteriorSpinnerNode: function(spinnerNamespace){
        jQuery('.spinner-' + spinnerNamespace).remove();
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
          var elementId = false;
            if(jQuery(this).hasClass('recent')){
                listType = 'recent';
            } else if(jQuery(this).hasClass('yours')){
                listType = 'yours';
            } else if(jQuery(this).hasClass('tag_contacts')){
                listType = 'tag_contacts';
                elementId = jQuery(this).attr('id').split(/\-/)[1];
            } else if(jQuery(this).hasClass('new')){
                listType = 'new';
            } else if(jQuery(this).hasClass('upcoming')){
                listType = 'upcoming';
            } else if(jQuery(this).hasClass('all_upcoming')){
              listType = 'all_upcoming';
            } else if(jQuery(this).hasClass('contact')){
              listType = 'contact';
              elementId = jQuery(this).attr('id').split(/\-/)[1];
            } else if(jQuery(this).hasClass('all')){
              listType = 'all';
            }
            jQuery.ajax({
              cache: false,
              dataType: 'html',
                url: jQuery.rootPath() + objectType + '_query/' + listType + ((elementId) ? '/' + elementId : '' ),
                beforeSend: function(){
                    jQuery('.' + objectType + '-list.' + listType).html(jQuery.interiorSpinnerNode(listType));
                },
                error: function(jqXHR, textStatus, errorThrown){
                  jQuery('.' + objectType + '-list.' + listType).html('There seems to have been a problem! fail whale here. Please try again later.<br/>Code: ' + textStatus);
                },
                complete: function(){
                  jQuery.hideInteriorSpinnerNode(listType);
                },
                success: function(html){
                  jQuery('.' + objectType + '-list.' + listType).html(html);
                }
            });
        });
    },

    observeDestroyControls: function(){
      jQuery('a.delete').live('click', function(e){
        e.preventDefault();
        jQuery.retainTabStateFromBeautyTip(this);
        var objectType = '';
        var classList = jQuery(this).attr('class').split(/\s+/)
        jQuery(classList).each(function(index, item){
          if(item.match(/^delete\-/i)){
            objectType = item.split('-')[1];
          }
        });
        var destroyUrl = jQuery(this).attr('href');
        var confirmMessage = (jQuery(this).attr('message')) ? jQuery(this).attr('message') : 'Are you sure you want to delete this item?';
        var confirmNode = jQuery('<div><p>' + confirmMessage + '</p></div>');
        jQuery(confirmNode).dialog({
          title: 'Please confirm',
          modal: true,
          buttons: {
            Cancel: function(){
              jQuery(confirmNode).dialog('close');
            },
            'Yes': function(){
              jQuery.ajax({
                cache: false,
                type: 'POST',
                url: destroyUrl,
                dataType: 'html',
                data: {'_method': 'delete'},
                beforeSend: function(){
                  jQuery.showGlobalSpinnerNode();
                },
                error: function(xhr){
                  jQuery.showMajorError(xhr);
                },
                complete: function(){
                  jQuery.hideGlobalSpinnerNode();
                },
                success: function(){
                  jQuery.refreshActiveTabPane();
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

/* 
      observeListItems: function(){
        jQuery('.resultlist li').live('mouseover mouseout', function(e){
          if(e.type == 'mouseover'){
            jQuery(this).addClass('hover');
            jQuery(this).find('.floating-control').show();
          }
          if(e.type == 'mouseout'){
            jQuery(this).removeClass('hover');
            jQuery(this).find('.floating-control').hide();
          }
        });
      },
      */

      observeListPagination: function(){
        jQuery('.pagination a').live('click',function(e){
          var paginationTarget = jQuery(this).closest('.search_results,.ui-widget-content');
          e.preventDefault();
          jQuery.ajax({
            type: 'GET',
            cache: false,
            url: jQuery(this).attr('href'),
            dataType: 'html',
            beforeSend: function(){
              jQuery.showGlobalSpinnerNode();
            },
            error: function(xhr){
              jQuery.showMajorError(xhr);
            },
            complete: function(){
              jQuery.hideGlobalSpinnerNode();
            },
            success: function(html){
              jQuery(paginationTarget).html(html);
            }
          });
        });
      },

      observeDialogShow: function(rootClass){
        jQuery(rootClass).live('click',function(e){
          e.preventDefault();
          var dialogTitle = jQuery(this).attr('title');
          jQuery.retainTabStateFromLink(this);
          jQuery.ajax({
            cache: false,
            dataType: 'html',
            url: jQuery(this).attr('href'),
            beforeSend: function(){
              jQuery.showGlobalSpinnerNode();
            },
            complete: function(){
              jQuery.hideGlobalSpinnerNode();
            },
            error: function(xhr){
              jQuery.showMajorError(xhr);
            },
            success: function(html){
              var dialogNode = jQuery('<div></div>');
              jQuery(dialogNode).append(html);
              jQuery(dialogNode).dialog({
                title: dialogTitle,
//                show: 'explode',
//                hide: 'explode',
                modal: true,
                width: 'auto',
                height: 'auto',
                position: 'top',
                buttons: {
                  Close: function(){
                    jQuery(dialogNode).dialog('close');
                    jQuery(dialogNode).remove();
                  },
                }
              });
              jQuery.retainTabStateFromLink();
              jQuery('.tabs').tabs({
                ajaxOptions: {
                  cache: false,
                  dataType: 'html',
                  beforeSend: function(){
                    jQuery.showGlobalSpinnerNode();
                  },
                  complete: function(){
                    jQuery.hideGlobalSpinnerNode();
                  },
                  error: function(xhr,textStatus,errorStr){
                    jQuery.showMajorError(textStatus);
                  }
                }
              });
            }
          });
        });

      },

      refreshActiveTabPane: function(){
        var modified_object_class =  jQuery.data(document.body,'modified_object_class');
//        console.log('modified_object_class to refresh: ' + modified_object_class);
        if(typeof(modified_object_class) != 'undefined'){
          jQuery('li.' + modified_object_class).closest('.tabs').each(function(){
            var current_index = jQuery(this).tabs('option','selected');
            jQuery(this).tabs('load',current_index);
          });
        }
      },

    retainTabStateFromBeautyTip: function(){
      var targetEl = jQuery('.bt-active');
      var modified_object_class = jQuery(targetEl).closest('li').attr('class');
      // console.log('bt modified_object_class: ' + modified_object_class);
      if(typeof(modified_object_class) != 'undefined'){
        jQuery.data(document.body, 'modified_object_class', modified_object_class);
      }
    },

    retainTabStateFromLink: function(el){
      var modified_object_class = jQuery(el).closest('li').attr('class');
      // console.log('link modified_object_class: ' + modified_object_class);
      if(typeof(modified_object_class) != 'undefined'){
        jQuery.data(document.body, 'modified_object_class', modified_object_class);
      }
    },

    observeDialogForm: function(rootClass){
        jQuery(rootClass).live('click',function(e){
          var dialogTitle = jQuery(this).attr('title');
          e.preventDefault();
          jQuery.retainTabStateFromBeautyTip();
          jQuery.ajax({
            cache: false,
            dataType: 'html',
            url: jQuery(this).attr('href'),
            beforeSend: function(){
                jQuery.showGlobalSpinnerNode();
            },
            complete: function(){
              jQuery.hideGlobalSpinnerNode();
            },
            error: function(xhr){
              jQuery.showMajorError(xhr);
            },
            success: function(html){
                var dialogNode = jQuery('<div></div>');
                jQuery(dialogNode).append(html);

                jQuery(dialogNode).find('.collapsable').each(function(){
                  var toggleControl = jQuery(this).find('legend');
                  var hiddenElements = jQuery(this).find('ol').hide();
                  jQuery(toggleControl).addClass('collapsable-control').click(function(e){
                    e.preventDefault();
                    if(jQuery(hiddenElements).is(':visible')){
                      jQuery(toggleControl).html(jQuery(toggleControl).html().replace('▼','▶'));
                      jQuery(hiddenElements).hide();
                    } else {
                      jQuery(toggleControl).html(jQuery(toggleControl).html().replace('▶','▼'));
                      jQuery(hiddenElements).show();
                    }
                  });
                });
                jQuery(dialogNode).dialog({
//                    show: 'explode',
//                    hide: 'explode',
                    title: dialogTitle,
                    modal: true,
                    width: 600,
                    minWidth: 400,
                    height: 'auto',
                    position: 'top',
                    buttons: {
                        Cancel: function(){
                            jQuery(dialogNode).dialog('close');
                            jQuery(dialogNode).remove();
                        },
                        Submit: function(){
                          if(jQuery(dialogNode).find('form').hasClass('contact')){
                            var tagList = jQuery('#contact_hierarchical_tags_for_edit').val().split(/\s+?,\s+?/);
                            jQuery(dialogNode).find('.existingTags span a').each(function(){
                              tagList.push(jQuery(this).html());
                            });
                            tagList = jQuery.grep(tagList,function(n,i){
                              return(n);
                            });
                            jQuery('#contact_hierarchical_tag_list').val(tagList.join(','));
                          }
                          jQuery(dialogNode).find('form').ajaxSubmit({
                            dataType: 'html',
                            beforeSend: function(){
                              jQuery('.ui-dialog .ui-dialog-buttonset').prepend(jQuery.interiorSpinnerNode('objectEdit'));
                            },
                            success: function(){
                              //jQuery.updateLists('contact');
                              //jQuery.updateLists('note');
                              jQuery(dialogNode).dialog('close');
                              jQuery.refreshActiveTabPane();
                            },
                            complete: function(){
                              jQuery.hideInteriorSpinnerNode('objectEdit');
                            },
                            error: function(xhr){
                              jQuery('#error').show().html(xhr.responseText);
                            }
                          });
                        }
                    },
                    open: function(){
                      jQuery('.existingTags span').bind({
                        click: function(){
                          jQuery(this).hide('slow', function(){jQuery(this).remove()});
                        },
                        mouseover: function(){
                          jQuery(this).css('cursor','pointer');
                        }
                      });
                      jQuery('.tag_list').tagSuggest({
                        url: jQuery.rootPath() + 'contact_query/autocomplete_tags',
                        separator: ', ',
                        delay: 500
                      });
                      jQuery.initDateControl();
                      jQuery(dialogNode).find('input:visible').first().focus();
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
