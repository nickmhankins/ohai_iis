Ohai.plugin :Iis do
    provides 'iis'
    collect_data :windows do
      require 'win32ole'
      iis Mash.new
      wmi = WIN32OLE.connect("winmgmts:root\\webadministration")
      app_pools = wmi.ExecQuery("select name from applicationpool")
      collection = []
      app_pools.each do |pool|
        collection.push pool.name
      end
      iis[:pools] = collection
    end
  end
  