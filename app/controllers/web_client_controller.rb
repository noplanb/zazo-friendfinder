class WebClientController < ApplicationController
  before_action :set_web_client
  before_action :set_contact, only: [:add_another, :ignore_another]

  def show
    @web_client = WebClientDecorator.decorate(@web_client)
    #@notice = WebClient::ActionHandler::NoticeBuilder.deserialize(flash[:notice]) if flash[:notice]
    @notice = WebClient::ActionHandler::NoticeBuilder.new(:added, :added, :added, contact_name: 'Ivan Kornilov')
  end

  def add
    handle_action(:add)
  end

  def ignore
    handle_action(:ignore)
  end

  def unsubscribe
    handle_action(:unsubscribe)
  end

  def subscribe
    handle_action(:subscribe)
  end

  def add_another
    handle_action(:add, @contact)
  end

  def ignore_another
    handle_action(:ignore, @contact)
  end

  private

  def handle_action(*args)
    @web_client.send(*args)
    redirect_to web_client_path, notice: @web_client.notice
  end

  def set_web_client
    @web_client = WebClient::ActionHandler.new(params[:id])
    raise WebClient::NotFound unless @web_client.valid?
  end

  def set_contact
    @contact = @web_client.owner.contacts.find(params[:contact_id])
  end
end
