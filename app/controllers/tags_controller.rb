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
    original_tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
    new_tag = ActsAsTaggableOn::Tag.find(params[:new_tag_id])



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
  end

end
