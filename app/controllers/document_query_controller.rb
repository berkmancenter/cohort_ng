class DocumentQueryController < ApplicationController
  def new
  end

  def recent
  end

  def yours
  end

  def contact
    @documents = Document.paginate(:conditions => ['contact_id = ?', params[:id]], :order => 'created_at', :page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js {
        render :partial => "shared/contact_document_list"
      }
      format.html {
        render :partial => "shared/contact_document_list", :layout => ! request.xhr? 
      }
    end
  end

end
