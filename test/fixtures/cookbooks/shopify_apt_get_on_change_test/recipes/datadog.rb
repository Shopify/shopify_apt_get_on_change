shopify_apt_get_on_change '/etc/example.app/version' do
  version '1.2'
  datadog_event name: 'name', text: 'text', key: 'key'
end
