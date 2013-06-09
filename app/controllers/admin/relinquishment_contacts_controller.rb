class Admin::RelinquishmentContactsController < Admin::CrudController
  load_and_authorize_resource
  
  respond_to :html, :xml, :json, :csv
  
  # GET /relinquishment_contacts
  # GET /relinquishment_contacts.xml
  def index
    @search = RelinquishmentContact.organization(current_user).search(params[:q])
    @relinquishment_contacts = @search.result.paginate(:page => params[:page], :per_page => 10).order("updated_at DESC")
    @presenter = Admin::RelinquishmentContacts::IndexPresenter.new(current_user)
    respond_with(@relinquishment_contacts) do |format|
      format.html # index.html.erb
      format.csv { render :csv => RelinquishmentContact.organization(current_user),
                          :filename => 'relinquishment_contacts' }
    end
  end

  # GET /relinquishment_contacts/1
  # GET /relinquishment_contacts/1.xml
  def show
    @relinquishment_contact = RelinquishmentContact.find(params[:id])
    @animals = RelinquishmentContact.find(params[:id]).animals
    @relatable_animals = Animal.organization(current_user)
    
    respond_with(@relinquishment_contact)
  end

  # POST /relinquishment_contacts
  # POST /relinquishment_contacts.xml
  def create
    @relinquishment_contact = current_user.organization.relinquishment_contacts.new(params[:relinquishment_contact])
    if @relinquishment_contact.save
      flash[:notice] = 'Relinquishment contact was successfully created.'
    else
      flash[:error] = 'Relinquishment contact was not successfully created.'
    end
    
    respond_with(@relinquishment_contact, :location => admin_relinquishment_contact_path(@relinquishment_contact))
  end
end
