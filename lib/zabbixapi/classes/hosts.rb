class ZabbixApi
  class Hosts < Basic

    def array_flag
      true
    end

    def method_name
      "host"
    end

    def indentify
      "host"
    end

    def default_options
      {
        :host => nil,
        :interfaces => [],
        :status => 0,
        :available => 1,
        :groups => [],
        :proxy_hostid => nil
      }
    end

    def unlink_templates(data)
      result = @client.api_request(
        :method => "host.massRemove",
        :params => {
          :hostids => data[:hosts_id],
          :templates => data[:templates_id]
        }
      )
      result.empty? ? false : true
    end

    def create_or_update(data)
      hostid = get_id(:host => data[:host])
      hostid ? update(data.merge(:hostid => hostid)) : create(data)
    end

    # to make delete call idempotent for all resources
    def delete(hostid)
      super(:hostid => hostid)
    end

    def get_items(data)
      log "[DEBUG] Call get_items with parameters: #{data.inspect}"

      result = @client.api_request(
        :method => "host.get",
        :params => {
          :filter => {
            :host => data[:host]
          },
          :selectItems => 'extend'
        }
      )

      result[0]['items'].empty? ? nil : result[0]['items']
    end

  end
end
