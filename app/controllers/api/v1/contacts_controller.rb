class API::V1::ContactsController < Faalis::APIController
  before_filter :build_resource, :only => :create
  load_and_authorize_resource :except => [:destory]

  # GET /api/v1/contacts
  def index
    respond_with(@contacts)
  end

  def create
    create_or_update(:create)
  end

  def show
    respond_with(@contact)
  end

  def update
    create_or_update(:update)
  end

  def destroy
    ids = params[:id].split(",")
    @contacts = ::Contact.where(:id => ids)
    authorize! :destroy, @contacts
    @contacts.destroy_all
  end

  def build_resource
    @contact = ::Contact.new(resource_params)
  end

  def resource_params
    params.require(:contact).permit(:id, :prefix, :first_name, :middle_name, :last_name, :suffix, :organization, :is_organization)
  end

  private

  def create_or_update(action)
    details = params[:contact][:details] || []
    details_list = []
    details_errors = []
    valid = true

    details.each do |detail|

      contact_detail = ContactDetails.find_or_initialize_by(:detail_field_id => detail[:field],
                                                            :detail_type => detail[:type],
                                                            :detail_value => detail[:value])

      if not contact_detail.valid?
        details_errors << contact_detail.errors
        valid = false
      else
        details_errors << {}
        details_list << contact_detail
      end
    end

    if valid
      details_list.each { |x| x.save }
      @contact.details = details_list
    end

    result = @contact.update(resource_params) if action == :update
    result = @contact.save if action == :create

    if result and valid
      respond_with(@contact)
    else
      errors = get_details_error(@contact, details_errors)
      respond_to do |format|
        format.json { render :json => errors, :status => :unprocessable_entity }
      end
    end


  end

  def get_details_error(contact, gerrors)
    errors = {:fields => contact.errors}
    counter = 0

    contact.details.each do |detail|
      if not detail.errors.empty?
        detail.errors.each do |key, value|
          errors[:fields]["#{key}_#{counter}".to_sym] = value
          if errors[:fields]["#{key}_#{counter}".to_sym].length > 1
            errors[:fields]["#{key}_#{counter}".to_sym].uniq!
          end
        end
      end
      counter += 1
    end

    counter = 0
    gerrors.each do |err|
      err.each do |key, value|
        errors[:fields]["#{key}_#{counter}".to_sym] = value
        if errors[:fields]["#{key}_#{counter}".to_sym].length > 1
            errors[:fields]["#{key}_#{counter}".to_sym].uniq!
        end
      end
      counter += 1
    end
    errors
  end

end
