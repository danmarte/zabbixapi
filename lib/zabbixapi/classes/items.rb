class ZabbixApi
  class Items < Basic

    def array_flag
      true
    end

    def method_name
      "item"
    end

    def indentify
      "name"
    end

    def default_options 
      {
        :name => nil,
        :key_ => nil,
        :hostid => nil,
        :delay => 60,
        :history => 60,
        :status => 0,
        :type => 7,
        :snmp_community => '',
        :snmp_oid => '',
        :value_type => 3,
        :data_type => 0,
        :trapper_hosts => 'localhost',
        :snmp_port => 161,
        :units => '',
        :multiplier => 0,
        :delta => 0,
        :snmpv3_securityname => '',
        :snmpv3_securitylevel => 0,
        :snmpv3_authpassphrase => '',
        :snmpv3_privpassphrase => '',
        :formula => 0,
        :trends => 365,
        :logtimefmt => '',
        :valuemapid => 0,
        :delay_flex => '',
        :authtype => 0,
        :username => '',
        :password => '',
        :publickey => '',
        :privatekey => '',
        :params => '',
        :ipmi_sensor => ''
      }
    end

    # Check which keys from n exists in d,
    # then return the matches in a hash.
    def get_pairs(d, n)
      matches = {}
      n.keys.each {|key|
        if d.has_key?(key)
          matches["#{key}"] = d["#{key}"]
        end
      }
      matches
    end

    # this is a different version from the one declared
    # in basic_logic
    def hash_equals?(a, b)
      t = get_pairs(a, b)
      if (b.size > t.size)
        difference = b.to_a - t.to_a
      else
        difference = t.to_a - b.to_a
      end
      difference.size == 0
    end

    def delete(data)
      log "[DEBUG] Call delete with parametrs: #{data.inspect}"

      data_delete = array_flag ? [data] : [key.to_sym => data]
      result = @client.api_request(:method => "#{method_name}.delete", :params => data_delete)
      result['itemids'].keys[0].to_i
    end

    def create_or_update(data)
      log "[DEBUG] Call create_or_update with parameters: #{data.inspect}"

      id = get_id(data)
      #result = @client.api_request(:method => "item.get", :params => { :itemids => data[key.to_sym] })
      #id = nil
      #result.each { |item| id = item[key.to_sym].to_i if item[key.to_sym] == data[key.to_sym] }  

      id ? update(data.merge(key.to_sym => id.to_s)) : create(data)
    end

    def get_full_data(data)
      log "[DEBUG] Call get_full_data with parametrs: #{data.inspect}"

      #if(defined? data['templateids'] && !data['templateids'].nil?)
      if(!data['templateids'.to_sym].nil?)
        params = {
          :filter => { indentify.to_sym => data[indentify.to_sym] },
          :templateids => data[:templateids],
          :output => "extend"
        }
      #elsif(defined? data['hostids'] && !data['hostids'].nil?)
      elsif(!data['hostids'.to_sym].nil?)
        params = {
          :filter => { indentify.to_sym => data[indentify.to_sym] },
          :hostids => data[:hostids],
          :output => "extend"
        }
      else
        params = {
          :filter => { indentify.to_sym => data[indentify.to_sym] },
          :output => "extend"
        }
      end

      @client.api_request(
        :method => "#{method_name}.get",
        :params => params
      )
    end

  end
end
