suite_path = node["simple_cuke"]["suite_path"]

cookbook_file File.join(node['chef_handler']['handler_path'], "verify_handler.rb") do
  source "verify_handler.rb"
  action :nothing
end.run_action(:create)

chef_handler "VerifyHandler" do
  source "#{node['chef_handler']['handler_path']}/verify_handler.rb"
  action :enable
  arguments :path => suite_path,
            :node_roles => node.roles,
            :all_roles => search(:role, "name:*").map{ |role| role.name }
end

remote_directory suite_path do
  source 'suite'
  owner 'root'
  group 'root'
  mode "0755"
  recursive true
end