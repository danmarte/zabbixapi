class ZabbixApi
  class HostInterfaces < Basic

    def array_flag
      true
    end

    def method_name
      "hostinterface"
    end

    def indentify
      "hostinterface"
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
  end
end
