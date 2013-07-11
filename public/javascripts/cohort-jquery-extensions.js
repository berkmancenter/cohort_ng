$.extend({
  rootPath: function(){
    return '/'
  },
  showGlobalSpinnerNode: function(){
    $('#spinner').show();
  },
  hideGlobalSpinnerNode: function(){
    $('#spinner').hide();
  },
  showMajorError: function(error){
    $('<div></div>').html("We're sorry, there appears to have been an error.<br/>" + error).dialog({
      modal: true,
      width: 600
      }).dialog('open');
  },
  mergeContactTagsForSubmit: function(rootNode){
    // FIXME - there are probably scoping issues in here.
    var tagList = [];
    $(rootNode).find('.tag_list, .quick_tag_list').each(function(){
      tagList = $(this).val().split(/\s+?,\s+?/);
    });
    $(rootNode).find('.existingTags span a').each(function(){
      tagList.push($(this).html());
    });
    console.log(tagList);
    tagList = $.grep(tagList,function(n,i){
      return(n);
    });
    console.log(tagList);
    $(rootNode).find('.hierarchical_tag_list').val(tagList.join(','));
  },
  interiorSpinnerNode: function(spinnerNamespace){
    return $('<img class="spinner-' + spinnerNamespace + '" src="' + $.rootPath() + 'images/ajax-loader.gif" />');
  },
  hideInteriorSpinnerNode: function(spinnerNamespace){
    $('.spinner-' + spinnerNamespace).remove();
  },
  initDateControl: function(){
    $('.datepicker').each(function(){
      var dateRange = ($(this).attr('id').match(/birth/)) ? 'c-115:c' : '-10y:+10y';
      $(this).datepicker({
        changeMonth: true,
        changeYear: true,
        yearRange: dateRange,
        dateFormat: 'yy-mm-dd'
      });
    });
  },
  updateLists: function(objectType){
    $('.' + objectType + '-list').each(function(listNode){
      var listType = 'recent';
      var elementId = false;
      if($(this).hasClass('recent')){
        listType = 'recent';
      } else if($(this).hasClass('yours')){
        listType = 'yours';
      } else if($(this).hasClass('tag_contacts')){
        listType = 'tag_contacts';
        elementId = $(this).attr('id').split(/\-/)[1];
      } else if($(this).hasClass('new')){
        listType = 'new';
      } else if($(this).hasClass('upcoming')){
        listType = 'upcoming';
      } else if($(this).hasClass('all_upcoming')){
        listType = 'all_upcoming';
      } else if($(this).hasClass('contact')){
        listType = 'contact';
        elementId = $(this).attr('id').split(/\-/)[1];
      } else if($(this).hasClass('all')){
        listType = 'all';
      }
      $.ajax({
        cache: false,
        dataType: 'html',
        url: $.rootPath() + objectType + '_query/' + listType + ((elementId) ? '/' + elementId : '' ),
        beforeSend: function(){
          $('.' + objectType + '-list.' + listType).html($.interiorSpinnerNode(listType));
        },
        error: function(jqXHR, textStatus, errorThrown){
          $('.' + objectType + '-list.' + listType).html('There seems to have been a problem! fail whale here. Please try again later.<br/>Code: ' + textStatus);
        },
        complete: function(){
          $.hideInteriorSpinnerNode(listType);
        },
        success: function(html){
          $('.' + objectType + '-list.' + listType).html(html);
        }
      });
    });
  },

  observeDestroyControls: function(){
    $('a.delete').live('click', function(e){
      e.preventDefault();
      //$.retainTabStateFromBeautyTip(this);
      var cmdTabs = $(this).closest('.tabs');
      var objectType = '';
      var classList = $(this).attr('class').split(/\s+/)
      $(classList).each(function(index, item){
        if(item.match(/^delete\-/i)){
          objectType = item.split('-')[1];
        }
      });
      var destroyUrl = $(this).attr('href');
      var redirectTo = $(this).attr('data_redirect_to');
      var confirmMessage = ($(this).attr('message')) ? $(this).attr('message') : 'Are you sure you want to delete this item?';
      var confirmNode = $('<div><p>' + confirmMessage + '</p></div>');
      $(confirmNode).dialog({
        title: 'Please confirm',
        modal: true,
        width: 600,
        buttons: {
          Cancel: function(){
            $(confirmNode).dialog('close');
          },
          'Yes': function(){
            $.ajax({
              cache: false,
              type: 'POST',
              url: destroyUrl,
              dataType: 'html',
            data: {'_method': 'delete'},
            beforeSend: function(){
              $.showGlobalSpinnerNode();
            },
            error: function(xhr){
              $.showMajorError(xhr);
            },
            complete: function(){
              $.hideGlobalSpinnerNode();
            },
            success: function(){
              if(redirectTo != undefined){
                window.location.href = redirectTo;
              } else {
                //$.refreshActiveTabPane();
                $.refreshTabPane(cmdTabs);
                $.updateLists(objectType);
                $(confirmNode).dialog('close');
              }
            }
          });
        }
      },
      close: function(){
        $(confirmNode).remove();
      }
      }).dialog('open');
    });
  },

  /* 
   observeListItems: function(){
     $('.resultlist li').live('mouseover mouseout', function(e){
       if(e.type == 'mouseover'){
         $(this).addClass('hover');
         $(this).find('.floating-control').show();
       }
       if(e.type == 'mouseout'){
         $(this).removeClass('hover');
         $(this).find('.floating-control').hide();
       }
     });
   },
   */

  observeListPagination: function(){
    $('.pagination a').live('click',function(e){
      var paginationTarget = $(this).closest('.search_results,.ui-widget-content');
      e.preventDefault();
      $.ajax({
        type: 'GET',
        cache: false,
        url: $(this).attr('href'),
        dataType: 'html',
        beforeSend: function(){
          $.showGlobalSpinnerNode();
        },
        error: function(xhr){
          $.showMajorError(xhr);
        },
        complete: function(){
          $.hideGlobalSpinnerNode();
        },
        success: function(html){
          $(paginationTarget).html(html);
        }
      });
    });
  },

  observeDialogShow: function(rootClass){
    $(rootClass).live('click',function(e){
      e.preventDefault();
      var dialogTitle = $(this).attr('title');
      var dialogHref = $(this).attr('href');
      $.retainTabStateFromLink(this);
      $.ajax({
        cache: false,
        dataType: 'html',
        url: $(this).attr('href'),
        beforeSend: function(){
          $.showGlobalSpinnerNode();
        },
        complete: function(){
          $.hideGlobalSpinnerNode();
        },
        error: function(xhr){
          $.showMajorError(xhr);
        },
        success: function(html){
          var dialogNode = $('<div class="dialog-show-content"></div>').data('href', dialogHref);
          $(dialogNode).append(html);
          $(dialogNode).dialog({
            title: dialogTitle,
            //                show: 'explode',
            //                hide: 'explode',
            modal: true,
            width: '600',
            height: 'auto',
            position: 'top',
            buttons: {
              Close: function(){
                $(dialogNode).dialog('close');
                $(dialogNode).remove();
              },
            }
          });
          $.retainTabStateFromLink();
          $('.tabs').tabs({
            ajaxOptions: {
              cache: false,
              dataType: 'html',
              beforeSend: function(){
                $.showGlobalSpinnerNode();
              },
              complete: function(){
                $.hideGlobalSpinnerNode();
              },
              error: function(xhr,textStatus,errorStr){
                $.showMajorError(textStatus);
              }
            }
          });
        }
      });
    });

  },

  /**
   * @param {jQuery} tabs The .tabs group to refresh
   */
  refreshTabPane: function( tabs ){
    tabs.each( function() {
      var current_index = $(this).tabs('option','selected');
      $(this).tabs('load',current_index);
    });
  },

  refreshActiveTabPane: function(){
    var modified_object_class =  $.data(document.body,'modified_object_class');
    //        console.log('modified_object_class to refresh: ' + modified_object_class);
    if(typeof(modified_object_class) != 'undefined'){
      $('li.' + modified_object_class).closest('.tabs').each(function(){
        var current_index = $(this).tabs('option','selected');
        $(this).tabs('load',current_index);
      });
    }
  },

  retainTabStateFromBeautyTip: function(){
    var targetEl = $('.bt-active');
    var modified_object_class = $(targetEl).closest('li').attr('class');
    // console.log('bt modified_object_class: ' + modified_object_class);
    if(typeof(modified_object_class) != 'undefined'){
      $.data(document.body, 'modified_object_class', modified_object_class);
    }
  },

  retainTabStateFromLink: function(el){
    var modified_object_class = $(el).closest('li').attr('class');
    // console.log('link modified_object_class: ' + modified_object_class);
    if(typeof(modified_object_class) != 'undefined'){
      $.data(document.body, 'modified_object_class', modified_object_class);
    }
  },

  observeDialogForm: function(rootClass){
    $(rootClass).live('click',function(e){
      var dialogTitle = $(this).attr('title');
      e.preventDefault();
      //$.retainTabStateFromBeautyTip();
      var cmdTabs = $(this).closest('.tabs');
      $.ajax({
        cache: false,
        dataType: 'html',
        url: $(this).attr('href'),
        beforeSend: function(){
          $.showGlobalSpinnerNode();
        },
        complete: function(){
          $.hideGlobalSpinnerNode();
        },
        error: function(xhr){
          $.showMajorError(xhr);
        },
        success: function(html){
          var dialogNode = $('<div></div>');
          $(dialogNode).append(html);

          $(dialogNode).find('.collapsable').each(function(){
            var toggleControl = $(this).find('legend');
            var hiddenElements = $(this).find('ol').hide();
            $(toggleControl).addClass('collapsable-control').click(function(e){
              e.preventDefault();
              if($(hiddenElements).is(':visible')){
                $(toggleControl).html($(toggleControl).html().replace('▼','▶'));
                $(hiddenElements).hide();
              } else {
                $(toggleControl).html($(toggleControl).html().replace('▶','▼'));
                $(hiddenElements).show();
              }
            });
          });
          $(dialogNode).dialog({
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
                $(dialogNode).dialog('close');
                $(dialogNode).remove();
              },
              Submit: function(){
                if($(dialogNode).find('form').hasClass('contact')){
                  $.mergeContactTagsForSubmit(dialogNode);
                }
                $(dialogNode).find('form').ajaxSubmit({
                  dataType: 'html',
                  beforeSend: function(){
                    $('.ui-dialog .ui-dialog-buttonset').prepend($.interiorSpinnerNode('objectEdit'));
                  },
                  success: function(){
                    //$.updateLists('contact');
                    //$.updateLists('note');
                    $(dialogNode).dialog('close');
                    //$.refreshActiveTabPane();
                    $.refreshTabPane(cmdTabs);
                    $('#messages').append('<div class="flash flash-notice">Added that contact.</div>');
                    $('#messages .flash-notice').effect('pulsate').hide('fade');

                    var parentDialogContent = cmdTabs.closest('.dialog-show-content');
                    if ( parentDialogContent.length > 0 ) {
                      $.ajax({
                        cache: false,
                        dataType: 'html',
                        url: parentDialogContent.data('href'),
                        beforeSend: function(){
                          $.showGlobalSpinnerNode();
                        },
                        complete: function(){
                          $.hideGlobalSpinnerNode();
                        },
                        success: function(html){
                          // destroy existing tabs
                          parentDialogContent.find('.tabs').tabs('destroy');

                          // replace html
                          parentDialogContent.html(html);

                          // create new tabs
                          parentDialogContent.find('.tabs').tabs({
                            ajaxOptions: {
                              cache: false,
                              dataType: 'html',
                              beforeSend: function(){
                                $.showGlobalSpinnerNode();
                              },
                              complete: function(){
                                $.hideGlobalSpinnerNode();
                              },
                              error: function(xhr,textStatus,errorStr){
                                $.showMajorError(textStatus);
                              }
                            }
                          });

                        }
                      });
                    }
                  },
                  complete: function(){
                    $.hideInteriorSpinnerNode('objectEdit');
                  },
                  error: function(xhr){
                    $('#error').show().html(xhr.responseText);
                  }
                });
              }
            },
            open: function(){
              $('.existingTags span').bind({
                click: function(){
                  $(this).hide('slow', function(){$(this).remove()});
                },
                mouseover: function(){
                  $(this).css('cursor','pointer');
                }
              });
              $('.tag_list').tagSuggest({
                url: $.rootPath() + 'contact_query/autocomplete_tags',
                separator: ', ',
                delay: 500
              });
              $.initDateControl();
              $(dialogNode).find('input:visible').first().focus();
            },
            close: function(){
              $(dialogNode).remove();
            }
          });
        }
      });
    });
  }
});
