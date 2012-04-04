class TagsController < BaseController
  def index
    breadcrumbs.add('Tags', tags_path)
    @tags = ActsAsTaggableOn::Tag.all
    @tags = @tags.sort_by{|t| t.hierarchical_name(' :: ')}
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    breadcrumbs.add('Tags', tags_path)
    breadcrumbs.add(@tag.hierarchical_name, tag_path(@tag))
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
