class NotesController < ApplicationController

  def new
    @note = Note.new
    respond_to do|format|
      format.js { render :layout => false}
      format.html {}
    end
  end

end
