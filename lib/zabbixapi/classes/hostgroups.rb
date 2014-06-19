class ZabbixApi
  class HostGroups < Basic

    def array_flag
      true
    end

    def method_name
      "hostgroup"
    end

    def indentify
      "name"
    end

    def key
      "groupid"
    end

    def get_hosts(data)
      log "[DEBUG] Call get_hosts with parametrs: #{data.inspect}"

      @client.api_request(
        :method => "#{method_name}.get",
        :params => {
          :filter => {
            indentify.to_sym => data[indentify.to_sym]
          },
          :selectHosts => [:hostid,:name]
          #:output => [:hostid]
        }
      )
    end

  end
end
