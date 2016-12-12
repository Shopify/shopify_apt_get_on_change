use_inline_resources

action :update do
  execute 'apt-get-update' do
    command 'apt-get -q update'
    action :nothing
  end

  event = new_resource.datadog_event
  ruby_block 'datadog' do
    block   { push_to_datadog(event) }
    only_if { event && event[:name] && event[:text] }
    action :nothing
  end

  dir = new_resource.base_name.split('/')[0..-2].join('/')
  directory dir

  file new_resource.base_name do
    content new_resource.version
    notifies :run, 'execute[apt-get-update]', :immediately
    notifies :run, 'ruby_block[datadog]', :immediately
  end
end
