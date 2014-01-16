class API::V1::ContactDetailsController < Faalis::APIController

  def destroy
    ids = params[:id].split(",")
    @contact_details = ::ContactDetails.where(:id => ids)
    authorize! :destroy, ContactDetails
    @contact_details.destroy_all
  end

  def build_resource
    @contact_details = ::ContactDetails.new(resource_params)
  end

  def resource_params
    params.require(:contact_details).permit(:id, :details_value)
  end

end
