class ZabbixApi
  class Screens < Basic

    # extracted from frontends/php/include/defines.inc.php
    #SCREEN_RESOURCE_GRAPH => 0,
    #SCREEN_RESOURCE_SIMPLE_GRAPH => 1,
    #SCREEN_RESOURCE_MAP => 2,
    #SCREEN_RESOURCE_PLAIN_TEXT => 3,
    #SCREEN_RESOURCE_HOSTS_INFO => 4,
    #SCREEN_RESOURCE_TRIGGERS_INFO => 5,
    #SCREEN_RESOURCE_SERVER_INFO => 6,
    #SCREEN_RESOURCE_CLOCK => 7,
    #SCREEN_RESOURCE_SCREEN => 8,
    #SCREEN_RESOURCE_TRIGGERS_OVERVIEW => 9,
    #SCREEN_RESOURCE_DATA_OVERVIEW => 10,
    #SCREEN_RESOURCE_URL => 11,
    #SCREEN_RESOURCE_ACTIONS => 12,
    #SCREEN_RESOURCE_EVENTS => 13,
    #SCREEN_RESOURCE_HOSTGROUP_TRIGGERS => 14,
    #SCREEN_RESOURCE_SYSTEM_STATUS => 15,
    #SCREEN_RESOURCE_HOST_TRIGGERS => 16

    def method_name
      "screen"
    end

    def indentify
      "name"
    end

    def delete(data)
      result = @client.api_request(:method => "screen.delete", :params => [data])
      result.empty? ? nil : result['screenids'][0].to_i
    end

    def get_or_create_for_host(data)
      log "[DEBUG] Call get_or_create_for_host with parameters: #{data.inspect}"

      screenitems = []
      screen_name = data[:screen_name]
      
      # Check if the screen already exists
      screenid   = get_id(:name => screen_name)
      
      unless screenid
        # if the screen didn't exist then we have to create it
        valign  = data[:valign]  || 0
        halign  = data[:halign]  || 0
        rowspan = data[:rowspan] || 0
        colspan = data[:colspan] || 0

        graphs_and_screens = Array.new
      
        # Clasify graphids by addind a type
        if(!data[:graphids].nil?)
          data[:graphids].compact.each { |graph|
            graphs_and_screens.push({'type' => 0, 'id' => graph})
          }
        end
        
        # Clasify screenids by addind a type
        if(!data[:screenids].nil?)
          data[:screenids].compact.each { |screen|
            graphs_and_screens.push({'type' => 8, 'id' => screen})
          }
        end        
        
        # Set the horizontal and vertical size of the screenids
        hsize = data[:hsize]   || (graphs_and_screens.size < 3 ? graphs_and_screens.size : 3)
        vsize = data[:vsize]   || ((graphs_and_screens.size / hsize) + (graphs_and_screens.size % hsize))
        
        graphs_and_screens.each_with_index do |graph, index|
          
          if(graph['type']==0)
            width  = data[:width]   || ((hsize.to_i < 3) ? 600 : 400)
            height = data[:height]  || 100
          else
            width   = nil
            height  = nil
          end
          
          # Let's align the graphs in a smarter way.
          # Center => 0
          # Left   => 1
          # Right  => 2
          if (data[:halign].nil? && graphs_and_screens.size > 1)
            halign = ((index % hsize).to_i == 0 ? 2 : 1)
          end

          # Add each element to the screen array
          screenitems << {
            :resourcetype => graph['type'],
            :resourceid   => graph['id'],
            :x            => (index % hsize).to_i,
            :y            => (index % graphs_and_screens.size/hsize).to_i,
            :valign       => valign,
            :halign       => halign,
            :rowspan      => rowspan,
            :colspan      => colspan,
            :height       => height,
            :width        => width
          }
        end
        
        # Create the screen
        screenid = create(
          :name        => screen_name,
          :hsize       => hsize,
          :vsize       => vsize,
          :screenitems => screenitems
        ) 
      end
      screenid
    end


  end
end
