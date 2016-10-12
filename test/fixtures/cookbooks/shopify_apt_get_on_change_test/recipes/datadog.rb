shopify_apt_get_on_change '/etc/example.app/version' do
  event = {
    name: 'name',
    text: 'text',
    key:  'key'
  }

  version '1.2'
  datadog_event event
end
