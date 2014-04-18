require "simpletax/version"
require 'oauth2'

module SimpleTax
  BASE_API        = 'https://secure.gosimpletax.com/api/v2/uk'.freeze
  OAUTH_AUTHZ_URL = 'https://secure.gosimpletax.com/o/authorize/'.freeze
  OAUTH_TOKEN_URL = 'https://secure.gosimpletax.com/o/token/'.freeze

  class Error < Exception
    def initialize status
      super "ServerError #{status}"
    end
  end

  class ServerError < Exception; end
  class NoAccessError < Exception; end

  class Client
    attr_reader :redirect_url, :token, :api_endpoint

    def initialize(options={})
      @api_endpoint = options[:site]          || BASE_API
      @redirect_url = options[:redirect_url]  || raise("Redirect URL needed")
      client_id     = options[:client_id]     || raise("client_id needed")
      client_secret = options[:client_secret] || raise("client_secret needed")
      @client = OAuth2::Client.new(
        client_id,
        client_secret,
        site: api_endpoint,
        authorize_url: OAUTH_AUTHZ_URL,
        token_url: OAUTH_TOKEN_URL
      )
    end

    def authorize_url
      @client.auth_code.authorize_url(redirect_uri: redirect_url)
    end

    def fetch_token(code)
      @token = @client.auth_code.get_token(code, redirect_uri: redirect_url)
    end

    def add_income(amount, optionals={})
      requires_token!
      description = optionals[:description] || ''
      date        = optionals[:date]        || today
      date        = format_date(date)

      data = json_body value: amount, date: date, reference: description
      parse_response token.post(url('/incomes'), body: data)
    end

    def add_expense(amount, optionals={})
      requires_token!
      description = optionals[:description] || ''
      date        = optionals[:date]        || today
      date        = format_date(date)

      data = json_body value: amount, date: date, reference: description
      parse_response token.post(url('/expenses'), body: data)
    end

    private

    def json_body params
      MultiJson.dump fields: params
    end

    def url(path)
      "#{api_endpoint}#{path}"
    end

    def requires_token!
      raise 'Token needed' unless @token
    end

    def format_date(date)
      date.to_date.strftime('%d/%m/%Y')
    end

    def today
      Date.today
    end

    def parse_response resp
      if resp.status >= 400
        parse_error resp
      else
        resp.parsed
      end
    end

    def parse_error resp
      status = resp.status
      if status >= 500
        raise ServerError.new status
      else
        raise NoAccessError.new status
      end
    end
  end
end
