#encoding: utf-8

require 'spec_helper'

describe 'hostinterface' do
  before :all do
    @hostgroup = gen_name 'hostgroup'
    @hostgroupid = zbx.hostgroups.create(:name => @hostgroup)

    @host = gen_name 'host'
    @hostid = zbx.hosts.create(
      :host => @host,
      :interfaces => [
        {
          :type  => 1,
          :main  => 1,
          :ip    => "10.20.48.94",
          :dns   => "",
          :port  => 10050,
          :useip => 1
        }
      ],
      :groups => [:groupid => @hostgroupid]
    )

    @host_array = Array.new
    @hostid_array = Array.new

    @host_array.push({'hostid' => @hostid})
    @hostid_array.push(@hostid)

    @secint = zbx.hostinterfaces.create(
      :hostid => @hostid,
      :dns    => "",
      :ip     => "127.0.0.1",
      :main   => 0,
      :port   => 9998,
      :type   => 1,
      :useip  => 1
    )

    3.times do |i|
      tmp_host = gen_name 'host'
      tmp_host_id = zbx.hosts.create(
        :host => tmp_host,
        :interfaces => [
          {
            :type  => 1,
            :main  => 1,
            :ip    => "10.20.48.9#{i}",
            :dns   => "",
            :port  => 10050,
            :useip => 1
          }
        ],
        :groups => [:groupid => @hostgroupid]
      )
      @host_array.push({'hostid' => tmp_host_id})
      @hostid_array.push(tmp_host_id)
    end

  end

  context 'when we add a second agent interface' do

    describe 'create' do
      it "should return integer id" do
        @secint.should be_kind_of(Integer)
      end
    end

    describe 'get' do
      it "should return array and integer interfaceids" do
        result = zbx.hostinterfaces.get(:hostids => @hostid)
        expect(result).to be_kind_of(Array)
        
        result.each {|interface|
          expect(interface['interfaceid']).to be_kind_of(String)
          expect(interface['interfaceid'].to_i).to be_kind_of(Integer)
        }
      end
    end

    describe 'get_on_port' do
      it "should return array and integer interfaceids" do
        result = zbx.hostinterfaces.get_on_port(:hostids => @hostid, :port => '9998')
        expect(result).to be_kind_of(Array)
        
        result.each {|interface|
          expect(interface['interfaceid'].to_i).to be_kind_of(Integer)
          expect(interface['port'].to_i).to be_kind_of(Integer)
          interface['port'].should eq '9998'
        }
      end
    end


  end

  context 'when interface exists' do

    describe 'exists' do
      it "should return true" do
        zbx.hostinterfaces.exists( :ip => "10.20.48.88" ).should eq true
      end 
    end

    describe 'delete' do
      it "should return hash with ids" do

        tmp_interfaces = zbx.hostinterfaces.get_on_port(:hostids => @hostid, :port => '9998')

        tmp_interfaces.each { |interface|
         expect(
          zbx.hostinterfaces.delete(interface['interfaceid']).to_i
          ).to be_kind_of(Integer)
        }

      end
    end

  end

  context 'when we add three more hosts ' do

    describe 'massadd' do
      it "should return ids of the new interfaces" do

        tmp_interface = { 
          :dns    => "",
          :ip     => "127.0.0.1",
          :main   => 1,
          :port   => 9999,
          :type   => 4,
          :useip  => 1
        }

        result = zbx.hostinterfaces.massadd(
          @host_array,
          tmp_interface
        )
        expect(result).to be_kind_of(Hash)

        result['interfaceids']['interfaceids'].each { |i|
          expect(i.to_i).to be_kind_of(Integer)
        }
      end
    end

    describe 'massremove' do
      it "should return ids of the deleted interfaces" do

        tmp_interface = { 
          :dns    => "",
          :ip     => "127.0.0.1",
          :port   => 9999
        }

        result = zbx.hostinterfaces.massremove(
          @hostid_array,
          tmp_interface
        )
        expect(result).to be_kind_of(Hash)

        result['interfaceids'].each { |i|
          expect(i).to_i.to be_kind_of(Integer)
        }
      end
    end
  end

  context 'After all tests' do
   describe 'delete' do
      it "HOST: Delete" do
        @hostid_array.each { |hostid|  
          zbx.hosts.delete( hostid ).should eq hostid
        }
      end
      it "HOSTGROUP: Delete" do
        zbx.hostgroups.delete( @hostgroupid ).should eq @hostgroupid
      end
    end
  end

end

