class WebClientController < ApplicationController
  before_action :set_web_client
  before_action :set_contact, only: [:add_another, :ignore_another]

  def show
  end

  def add
    handle_action(:added)
    render :action_handeled
  end

  def ignore
    handle_action(:ignored)
    render :action_handeled
  end

  def unsubscribe
    handle_action(:unsubscribed)
    render :action_handeled
  end

  def subscribe
    handle_action(:ignored)
    redirect_to web_client_path
  end

  def add_another
    WebClient::AddContact.new(@contact).do
    render json: { status: 'feature in progress' }
  end

  def ignore_another
    WebClient::IgnoreContact.new(@contact).do
    redirect_to web_client_path
  end

  private

  def handle_action(action)
    @web_client.do(action)
  end

  def set_web_client
    @web_client = WebClientDecorator.decorate(WebClient::ActionHandler.new(params[:id]))
    raise WebClient::NotFound unless @web_client.valid?
  end

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end
end
