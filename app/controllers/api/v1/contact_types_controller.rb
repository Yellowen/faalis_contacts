class API::V1::ContactTypesController < Faalis::APIController
  before_filter :build_resource, :only => :create
  load_and_authorize_resource :except => [:destory]

  # GET /api/v1/contact_types
  def index
    respond_with(@contact_types)
  end

  def create

    if @contact_type.save
      respond_with(@contact_type)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @contact_type.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_with(@contact_type)
  end

  def update


    if @contact_type.update(resource_params)
      respond_with(@contact_type)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @contact_type.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    ids = params[:id].split(",")
    @contact_types = ContactType.where(:id => ids)
    authorize! :destroy, @contact_types
    @contact_types.destroy_all
  end

  def build_resource
    @contact_type = ContactType.new(resource_params)
  end

  def resource_params
    params.require(:contact_type).permit(:id, :name)
  end

end
