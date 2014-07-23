class ZabbixApi
  class Graphs < Basic

    def array_flag
      true
    end

    def method_name
      "graph"
    end

    def indentify
      "name"
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

    def get_full_data(data)
      log "[DEBUG] Call get_full_data with parameters: #{data.inspect}"

      params = nil
      if(defined? data['templateids'])
       params = {
         :search => { indentify.to_sym => data[indentify.to_sym] },
         :templateids => data['templateids'.to_sym],
         :output => "extend"
       }
      else
       params = {
         :search => { indentify.to_sym => data[indentify.to_sym] },
         :output => "extend"
       }
      end

      @client.api_request(
        :method => "#{method_name}.get",
        :params => params
      )
    end

    def get_by_host(data)
      log "[DEBUG] Call get_graphs_by_host with parameters: #{data.inspect}"

      @client.api_request(
        :method => "graph.get",
        :params => {
          :hostids => data[:hostids],
          :output => [:name]
        }
      )
    end

    def get_ids_by_host(data)
      log "[DEBUG] Call get_ids_by_host with parameters: #{data.inspect}"

      ids = []
      graphs = Hash.new
      result = get_by_host(:hostids => data[:hostids])
      result.each do |graph|
        num  = graph['graphid']
        name = graph['name']
        graphs[name] = num
        filter = data[:filter]

        unless filter.nil?
          if /#{filter}/ =~ name
            ids.push(graphs[name])
          end
        else
            ids.push(graphs[name])
        end
      end
      ids
    end

    def get_items(data)
      log "[DEBUG] Call get_items with parameters: #{data.inspect}"
      @client.api_request(:method => "graphitem.get", :params => { :graphids => [data], :output => "extend" } )
    end

    def create_or_update(data)
      log "[DEBUG] Call create_or_update with parameters: #{data.inspect}"
      graphid = get_id(:name => data[:name], :templateid => data[:templateid])
      graphid ? _update(data.merge(:graphid => graphid)) : create(data)
    end

    def _update(data)
      log "[DEBUG] Call _update with parameters: #{data.inspect}"
      data.delete(:name)
      update(data)
    end

  end
end
