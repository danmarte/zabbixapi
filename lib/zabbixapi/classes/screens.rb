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
      graphids    = data[:graphids]
      valign      = data[:valign]  || 0
      halign      = data[:halign]  || 0
      rowspan     = data[:rowspan] || 0
      colspan     = data[:colspan] || 0
      hsize       = data[:hsize]   || (graphids.size < 3 ? graphids.size : 3)
      vsize       = data[:vsize]   || ((graphids.size / hsize) + (graphids.size % hsize))
      height      = data[:height]  || 100 # default 100
      width       = data[:width]   || (hsize.to_i < 3) ? 500 : 400  # default 500

      screenid    = get_id(:name => screen_name)

      unless screenid
        # Create screen
        graphids.each_with_index do |graphid, index|
          screenitems << {
            :resourcetype => 0,
            :resourceid   => graphid,
            :x            => (index % hsize).to_i,
            :y            => (index % graphids.size/hsize).to_i,
            :valign       => valign,
            :halign       => halign,
            :rowspan      => rowspan,
            :colspan      => colspan,
            :height       => height,
            :width        => width
          }
        end
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
