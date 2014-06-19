class ZabbixApi
  class HostInterfaces < Basic

    def array_flag
      true
    end

    def method_name
      "hostinterface"
    end

    def indentify
      "hostids"
    end

    def default_options
      {
        :dns => nil,
        :hostid => nil,
        :ip => '127.0.0.1',
        :main => 0,
        :port => nil,
        :type => 1,
        :useip => 1
      }
    end

    def parse_keys(data)
      case data
        when Hash
          data.empty? ? nil : data['interfaceids'][0].to_i
        when TrueClass
          true
        when FalseClass
          false
        else
          nil
      end
    end

    #def unlink_templates(data)
    #  result = @client.api_request(
    #    :method => "host.massRemove",
    #    :params => {
    #      :hostids => data[:hosts_id],
    #      :templates => data[:templates_id]
    #    }
    #  )
    #  result.empty? ? false : true
    #end

    def create_or_update(data)
      hostid = get_id(:host => data[:host])
      hostid ? update(data.merge(:hostid => hostid)) : create(data)
    end

    #def delete(data)
    #  result = @client.api_request(:method => "hostinterface.delete", :params => [data])
    #  result.empty? ? nil : result['interfaceids'][0].to_i
    #end

    def get_full_data(data)
      log "[DEBUG] Call get_full_data with parameters: #{data.inspect}"

      @client.api_request(
        :method => "#{method_name}.get",
        :params => {
           indentify.to_sym => data[indentify.to_sym],
          :output => "extend"
        }
      )
    end

    def exists(data)
      log "[DEBUG] Call exits with parameters: #{data.inspect}"

      @client.api_request(
        :method => "#{method_name}.exists",
        :params => {
           indentify.to_sym => data[indentify.to_sym]
        }
      )
    end

    def get_on_port(data)
      log "[DEBUG] Call get_on_port with parameters: #{data.inspect}"

      port = data[:port]
      tmp = Array.new
      
      result = get_full_data(data)
      result.each { |interface|
        if(interface['port'] == port)
          tmp.push(interface)        
        end
      }

      (tmp.count == 0) ? nil : tmp
    end

    def massadd(hosts,data)
      log "[DEBUG] Call massadd with parameters: #{hosts} --- #{data.inspect}"

      @client.api_request(
        :method => "#{method_name}.massadd",
        :params => {
          :hosts      => hosts,
          :interfaces => data
        }
      )
    end

    def massremove(hosts,data)
      log "[DEBUG] Call massremove with parameters: #{hosts} --- #{data.inspect}"

      @client.api_request(
        :method => "#{method_name}.massremove",
        :params => {
          :hostids    => hosts,
          :interfaces => data
        }
      )
   end

  end
end
