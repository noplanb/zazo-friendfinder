module PerformAsync
  extend ActiveSupport::Concern

  included do
    def method_missing(method, *args, &block)
      parts = method.to_s.split('_')
      async_method_to_call = parts[0...-1].join('_')
      if parts.last == 'async' && self.class.async_method_allowed?(async_method_to_call) && !async_method_to_call.empty?
        perform_method_async async_method_to_call, args, block
      else
        super
      end
    end

    def perform_method_async(method, *args, callback)
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection { |conn| send(method, args); callback && callback.call }
      end
    end
  end

  module ClassMethods
    def allow_async(*methods)
      @allowed_async_methods = methods
    end

    def allowed_async_methods
      @allowed_async_methods || []
    end

    def async_method_allowed?(method)
      allowed_async_methods.include? method.to_sym
    end
  end
end
