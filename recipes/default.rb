suite_path     = node["simple_cuke"]["suite_path"]
handler_path   = node['chef_handler']['handler_path']
reporters_path = File.join(handler_path, "reporters")

cookbook_file File.join(handler_path, "verify_handler.rb") do
  source "verify_handler.rb"
end.run_action(:create)

chef_handler "VerifyHandler" do
  source File.join(handler_path, "verify_handler.rb")
  action :enable
  arguments :suite_path     => suite_path,
            :reporters_path => reporters_path,
            :node_roles     => node.roles,
            :all_roles      => search(:role, "name:*").map{ |role| role.name },
            :reporter       => :console
end

remote_directory reporters_path do
  source 'reporters'
  purge true
  recursive true
end

remote_directory suite_path do
  source 'suite'
  purge true
  recursive true
end