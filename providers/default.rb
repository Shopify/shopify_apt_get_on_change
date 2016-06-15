use_inline_resources

action :update do
  execute 'apt-get-update' do
    command 'apt-get -q update'
    action :nothing
  end

  dir = new_resource.base_name.split('/')[0..-2].join('/')
  directory dir

  file new_resource.base_name do
    content new_resource.version
    notifies :run, 'execute[apt-get-update]', :immediately
  end
end
