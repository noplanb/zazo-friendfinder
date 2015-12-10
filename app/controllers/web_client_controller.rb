class WebClientController < ApplicationController
  before_action :set_web_client

  def show
  end

  def add
    handle_action :added
  end

  def ignore
    handle_action :ignored
  end

  def unsubscribe
    handle_action :unsubscribed
  end

  def subscribe
    handle_action nil
    redirect_to web_client_path
  end

  def add_another
    WebClient::AddContact.new(Contact.find(params[:contact_id])).do
    render json: { status: 'feature in progress' }
  end

  private

  def handle_action(action)
    @web_client.do action
  end

  def set_web_client
    @web_client = WebClientDecorator.decorate WebClient::ActionHandler.new(params[:id])
    render :default unless @web_client.valid?
  end
end
