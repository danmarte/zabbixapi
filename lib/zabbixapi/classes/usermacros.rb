class ZabbixApi
  class Usermacros < Basic
    def array_flag
      true
    end

    def indentify
      "macro"
    end

    def method_name
      "usermacro"
    end

    def create(data)
      log "[DEBUG] Call create with parameters: #{data.inspect}"
      request(data, "usermacro.create", "hostmacroids")
    end

    def create_global(data)
      log "[DEBUG] Call create_global with parameters: #{data.inspect}"
      request(data, "usermacro.createglobal", "globalmacroids")
    end

    def get(data)
      log "[DEBUG] Call get with parameters: #{data.inspect}"
      request(data, "usermacro.get", "hostmacroid")
    end

    def delete(data)
      log "[DEBUG] Call delete with parameters: #{data.inspect}"
      request(data, "usermacro.delete", "hostmacroids")
    end

    def delete_global(data)
      log "[DEBUG] Call delete_global with parameters: #{data.inspect}"
      request(data, "usermacro.deleteglobal", "globalmacroids")
    end

    def update(data)
      log "[DEBUG] Call update with parameters: #{data.inspect}"
      request(data, "usermacro.update", "hostmacroids")
    end

    def update_global
      log "[DEBUG] Call update_global with parameters: #{data.inspect}"
      request(data, "usermacro.updateglobal", "globalmacroids")
    end

    private
      def request(data, method, result_key)
        result = @client.api_request(:method => method, :params => data)
        if method == 'usermacro.get'
          result.empty? ? nil : result
        else
          result.empty? ? nil : result[result_key][0].to_i
        end
      end

  end
end
