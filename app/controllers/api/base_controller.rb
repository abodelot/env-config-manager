class Api::BaseController < ApplicationController

  # Catch exceptions and render error message
  [
    [ActiveRecord::RecordNotFound, -1],
    [ArgumentError,                -2]
  ].each do |klass, code|
    rescue_from klass, :with => lambda { |arg| exception_handler(arg, code) }
  end

  skip_before_filter :verify_authenticity_token

  # Allow cross-domain request (CORS)

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  protected

  def api_response(data)
    data.merge!(:code => '1') if !data.key?(:code)
    respond_to do |format|
      format.json { render :json => data }
      format.xml { render :xml => data }
    end
  end

  private

  def exception_handler(exception, code)
    api_response(:message => "#{exception.message}", :code => code)
  end
end
