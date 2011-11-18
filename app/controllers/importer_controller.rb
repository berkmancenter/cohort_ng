class ImporterController < BaseController

  def index
  end

  def upload_file

    session.delete(:imported_file_name)

    uploaded_file = params[:importer][:imported_file]
    throw Exception unless uploaded_file.original_filename.match(/.+\.csv$/i) 

    if ! File.exists?("#{RAILS_ROOT}/tmp/imported_files")
      FileUtils.mkdir_p("#{RAILS_ROOT}/tmp/imported_files")
      FileUtils.chmod 0755, "#{RAILS_ROOT}/tmp/imported_files"
    end
    file_name = "#{RAILS_ROOT}/tmp/imported_files/#{SecureRandom.uuid}"
    FileUtils.cp uploaded_file.tempfile, file_name
    session[:imported_file_name] = file_name
    flash[:notice] = 'Uploaded file.'
    redirect_to(:action => :import)
  rescue
    flash[:error] = "We couldn't accept that file. Please check the format"
    redirect_to(:action => :index)
  end

  def import
    if session[:imported_file_name].nil?
      flash[:notice] = 'Please upload a file first!'
      redirect_to(:action => :index)
    end

    csv = CSV.new(File.open(session[:imported_file_name]), :headers => :first_row, :skip_blanks => true)

    @debug = ''
    i = 0
    import_errors = []
    contact_columns = Contact.bulk_updateable_columns
    while(row = csv.gets)
      if i = 0
        if ! csv.headers.include?('email_addresses')
          flash[:error] = 'Your upload didn\'t include the required "email_addresses" field'
          throw Exception
        end
      end
      logger.warn(row.inspect)

      if row['email_addresses'].blank?
        import_errors << row.inspect
        next
      end

      row['email_addresses'].split(',').each do|email|
        # FIXME - assign email address properly
        contact = Contact.find_or_init_by_email(email)
        contact_columns.each do|col|
          unless row[col].blank?
            contact[col] = row[col]
          end
        end
        contact.hierarchical_tag_list = row['tags']
        contact.save
      end
    end

    flash[:notice] = 'Imported!'
    redirect_to :action => :index

  rescue
    flash[:error] = 'An error! Oh noes!'
    redirect_to(:action => :index)
  end

end
