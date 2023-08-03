class ApplicationController < ActionController::API
    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers
  
    private
  
    def cors_set_access_control_headers
      response.headers['Access-Control-Allow-Origin'] = 'http://localhost:3000' # Replace with the URL where your React frontend is running
      response.headers['Access-Control-Allow-Methods'] = 'POST, PUT, PATCH, DELETE, GET, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Authorization'
    end
  
    def cors_preflight_check
      if request.method == 'OPTIONS'
        headers['Access-Control-Allow-Origin'] = 'http://localhost:3000' # Replace with the URL where your React frontend is running
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, PATCH, DELETE, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Authorization'
        headers['Access-Control-Max-Age'] = '1728000'
        render plain: '', status: 204
      end
    end
  end
  