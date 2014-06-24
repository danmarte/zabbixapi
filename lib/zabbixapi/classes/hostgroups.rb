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
        }
      )
    end

    def get_hosts_ids(data)
      log "[DEBUG] Call get_hosts_ids with parametrs: #{data.inspect}"
      
      ids = Array.new
      results = get_hosts(data)
      results[0]['hosts'].each { |host|
        ids.push(host['hostid']) 
      }
      ids
    end

  end
end
