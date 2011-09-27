class BaseController < ApplicationController

  def index
  end

  private 
  def negotiate_list_query_response(object_type = 'contact', title = '')
    respond_to do |format|
      format.js { 
        render :partial => "shared/#{object_type}_list", 
        :locals => {:title => title} 
      }
      #TODO - Get this to render the layout. . .odd.
      format.html { 
        render :partial => "shared/#{object_type}_list", 
        :locals => {:title => title}, :layout => ! request.xhr?
      }
    end
  end
end
