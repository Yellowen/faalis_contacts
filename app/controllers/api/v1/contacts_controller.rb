class API::V1::ContactsController < Faalis::APIController
  before_filter :build_resource, :only => :create
  load_and_authorize_resource :except => [:destory]

  # GET /api/v1/contacts
  def index
    respond_with(@contacts)
  end

  def create
    
    if @contact.save
      respond_with(@contact)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @contact.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_with(@contact)
  end

  def update
    

    if @contact.update(resource_params)
      respond_with(@contact)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @contact.errors}, :status => :unprocessable_entity }
      end
    end
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
    params.require(:contact).permit(:id, :contact, :prefix, :first_name, :middle_name, :last_name, :suffix, :organization, :is_organization)
  end

end
