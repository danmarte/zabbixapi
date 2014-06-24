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
      @client.api_request(:method => "graphitem.get", :params => { :graphids => [data], :output => "extend" } )
    end

    def create_or_update(data)
      graphid = get_id(:name => data[:name], :templateid => data[:templateid])
      graphid ? _update(data.merge(:graphid => graphid)) : create(data)
    end

    def _update(data)
      data.delete(:name)
      update(data)
    end

  end
end
