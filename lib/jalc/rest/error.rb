# frozen_string_literal: true

require 'faraday'

module JaLC
  module REST
    class Error < StandardError; end

    class HTTPError < Error
      attr_reader :response

      def initialize(msg = nil, response: nil)
        @response = response
        msg ||= response[:body].dig('message', 'errors', 'message') if response && response[:body].respond_to?(:dig)
        msg ||= "the server responded with status #{response[:status]}" if response

        super(msg)
      end

      def inspect
        if response
          %(#<#{self.class} response=#{response.inspect}>)
        else
          super
        end
      end
    end

    class ClientError < HTTPError; end
    class BadRequestError < ClientError; end
    class ResourceNotFound < ClientError; end
    class ServerError < HTTPError; end
    class NilStatusError < ServerError; end
  end
end
