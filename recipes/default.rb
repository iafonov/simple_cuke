suite_path     = node['simple_cuke']['suite_path']
handler_path   = File.join(node['chef_handler']['handler_path'], 'cucumber_handler.rb')
reporters_path = File.join(node['chef_handler']['handler_path'], 'reporters')

directory File.join(node['chef_handler']['handler_path'] do
  action :create
end.run_action(:create)

cookbook_file handler_path do
  source 'cucumber_handler.rb'
end.run_action(:create)

chef_handler 'CucumberHandler' do
  source handler_path
  action 'enable'
  arguments :suite_path     => suite_path,
            :reporters_path => reporters_path,
            :node_roles     => node['roles'],
            :all_roles      => Chef::Config[:solo] ? [] : search(:role, 'name:*').map{ |role| role.name },
            :reporter       => node['simple_cuke']['reporter']
end

remote_directory reporters_path do
  source 'reporters'
  purge true
  recursive true
end

remote_directory suite_path do
  source 'suite'
  recursive true
end

# code borrowed from https://github.com/btm/minitest-handler-cookbook/blob/master/recipes/default.rb
node['recipes'].each do |recipe|
  cookbook_name = recipe.split('::').first
  remote_directory cookbook_name do
    source 'features'
    cookbook cookbook_name
    path "#{suite_path}/features/#{cookbook_name}"
    purge true
    ignore_failure true
  end
end