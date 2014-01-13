class API::V1::ContactFieldsController < Faalis::APIController
  before_filter :build_resource, :only => :create
  load_and_authorize_resource :except => [:destory]

  # GET /api/v1/contact_fields
  def index
    respond_with(@contact_fields)
  end

  def create

    if @contact_field.save
      respond_with(@contact_field)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @contact_field.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_with(@contact_field)
  end

  def update


    if @contact_field.update(resource_params)
      respond_with(@contact_field)
    else
      respond_to do |format|
        format.json { render :json => {:fields => @contact_field.errors}, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    ids = params[:id].split(",")
    @contact_fields = ::ContactField.where(:id => ids)
    authorize! :destroy, @contact_fields
    @contact_fields.destroy_all
  end

  def build_resource
    @contact_field = ::ContactField.new(resource_params)
  end

  def resource_params
    params.require(:contact_field).permit(:id, :name)
  end

end
