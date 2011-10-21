class SearchController < ApplicationController
  def index

  end

  def contacts
    qparams = params[:search]
    @contact_query = Sunspot.new_search(Contact)
    @contact_query.build do
      unless qparams[:q].blank?
        any_of do
          [:first_name, :last_name, :email_addresses].each do|col|
            with(col).starting_with(qparams[:q])
          end
        end
      end

      unless qparams[:created_before].blank?
        with(:created_at).less_than(qparams[:created_before])
      end

      unless qparams[:created_after].blank?
        with(:created_at).greater_than(qparams[:created_after])
      end

      unless qparams[:tagged_with].blank?
        qparams[:tagged_with].split(/\s?,\s?/).each do |tval|
          any_of do
            with(:hierarchical_tags).starting_with(tval)
          end
        end
      end

      unless qparams[:exclude_tag].blank?
        qparams[:exclude_tag].split(/\s?,\s?/).each do |tval|
          any_of do
            without(:hierarchical_tags).starting_with(tval)
          end
        end
      end

      with :active, true
      with :deleted, false
      paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
    end
    @contact_query.execute!
    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => 'shared/contact_search_results', :locals => {:contact_query => @contact_query} 
        else 
          render 
        end
      }
      format.js { render :layout => ! request.xhr? }
      format.xml  { render :xml => @contact_query.results }
    end

  end

  def tags
  end

  def notes
  end

  def documents
  end

end
