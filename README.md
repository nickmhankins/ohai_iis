# ohai_iis

Description
===========

This is an Ohai plugin that queries the IIS application pools on a server and creates node attributes of the names.  The node attributes can be found under `node[iis][pools]`

Platform
---------

* Windows


Usage
=====

To use this cookbook, you need to include it in either a run list, or include it in a recipe, like this :
```ruby
include_recipe 'ohai_iis'
```
Then you also need to at it as a dependency in the metadata of the same cookbook as the example above, like this:
```ruby
depends 'ohai_iis'
```

When the recipe is run on a node, it uses the `win32ole` ruby gem to query WMI for the server's application pools.  Once gathered, Ohai will rerun and add these pools to the node attributes, which other recipes can then take advantage of.  For example, scheduling application pools can now be done using the resource `dsc_resource` instead of the buggy `dsc_script` resource:

Here is an excerpt from the `apppools` recipe in `altsrc_webserver`
```ruby
pools = node['iis']['pools']
pools.each do |pool|
  dsc_resource "set app pool scheduling - #{pool}" do
    module_name 'xWebAdministration'
    module_version '1.18.0.0'
    resource 'xWebAppPool'
    property :name, pool.to_s
    property :restartschedule, [schedule.to_s]
    property :restarttimelimit, '00:00:00'
    property :logeventonrecycle, 'Time,Requests,Schedule,Memory,IsapiUnhealthy,OnDemand,ConfigChange,PrivateMemory'
  end
end
```