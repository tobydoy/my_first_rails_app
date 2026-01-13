# Monkey patch to fix ActionDispatch compatibility with Ruby 3.3.6
# This fixes the ArgumentError in Rack::File.new and Static.new

module ActionDispatch
  class FileHandler
    def initialize(root, index: "index", headers: {})
      @root          = root.chomp("/").b
      @file_server   = ::Rack::Files.new(@root)
      @index         = index
      @headers       = headers
    end
  end

  class Static
    # Allow both positional and keyword arguments for backward compatibility
    def initialize(app, path, cache_control = nil, index: "index", headers: {})
      @app = app
      # Handle old calling convention with cache_control as third argument
      if cache_control.is_a?(Hash)
        # Old convention: initialize(app, path, headers)
        headers = cache_control
      elsif cache_control.is_a?(String)
        # Very old convention: initialize(app, path, cache_control_value)
        headers = { "Cache-Control" => cache_control }
      end
      @file_handler = FileHandler.new(path, index: index, headers: headers)
    end
  end
end
