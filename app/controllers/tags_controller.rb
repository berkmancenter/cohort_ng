class TagsController < BaseController
  def index
    breadcrumbs.add('Tags', tags_path)
    @tags = ActsAsTaggableOn::Tag.where(:ancestry => nil)
    @tags = @tags.sort_by{|t| t.hierarchical_name(' :: ')}
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    breadcrumbs.add('Tags', tags_path)
    breadcrumbs.add(@tag.hierarchical_name, tag_path(@tag))
    render :layout => ! request.xhr?
  end

  def children
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @children = @tag.children
    respond_to do|f|
      f.html{ render :layout => ! request.xhr? }
    end
  end

  def merge
    tag = ActsAsTaggableOn::Tag.find(params[:id])
    new_tag = ActsAsTaggableOn::Tag.find(params[:new_tag_id])
    contacts_to_reindex = []
    tag.taggings.each do |tg|
      contacts_to_reindex << tg.taggable.id
      if tg.taggable.tags.include?(new_tag)
        tg.destroy
      else
        tagging = ActsAsTaggableOn::Tagging.new(:taggable => tg.taggable, :tag => new_tag, :context => 'tags')
        tagging.save
        tg.destroy
      end
    end
    Contact.where(:id => contacts_to_reindex).solr_index
    new_tag.solr_index
    if params[:delete].to_i == 1
      # Hasta la vista, baby.
      tag.destroy
    else
      # Just reindex.
      tag.solr_index
    end
    flash[:notice] = 'Merged.'
    redirect_to acts_as_taggable_on_tag_path(new_tag) and return
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
    tag = ActsAsTaggableOn::Tag.find(params[:id])
    contacts_to_reindex = tag.taggings.collect{|tg| tg.taggable.id}
    tag.destroy
    Contact.where(:id => contacts_to_reindex).solr_index
    flash[:notice] = 'We deleted that tag.'
    redirect_to tags_path and return
  end

end
