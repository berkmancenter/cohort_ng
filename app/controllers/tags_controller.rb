class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
    @tags = @tags.sort_by{|t| t.hierarchical_name(' :: ')}
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
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
