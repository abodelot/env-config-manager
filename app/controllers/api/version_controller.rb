class Api::VersionController < Api::BaseController

  # GET /api/version
  def show
    version_string = "#{APP_VERSION[:major]}.#{APP_VERSION[:minor]}.#{APP_VERSION[:patch]}"
    if APP_VERSION[:extra].present?
      version_string += "~#{APP_VERSION[:extra]}"
    end
    api_response({:version => version_string})
  end
end
