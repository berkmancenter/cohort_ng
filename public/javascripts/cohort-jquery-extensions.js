jQuery.extend({
    rootPath: function(){
      return '/'
    },
    initDateControl: function(){
        jQuery('.datepicker').datepicker({
            changeMonth: true,
            changeYear: true,
            minDate: "-100Y",
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
            success: function(html){
              jQuery('.contact-list').filter('.' + listType).html(html);
            }
         });
     }); 
    }
});
