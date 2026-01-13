ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Fix for Psych aliases in Ruby 3.3.6 - must come before bootsnap
require 'psych'
module Psych
  class << self
    %i[load_file safe_load_file load safe_load].each do |method|
      next unless respond_to?(method)
      alias_method :"original_#{method}", method
      define_method(method) do |*args, **kwargs|
        kwargs[:aliases] = true unless kwargs.key?(:aliases)
        send(:"original_#{method}", *args, **kwargs)
      end
    end
  end
end

require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
