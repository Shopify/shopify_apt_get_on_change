shopify_apt_get_on_change '/etc/example.app/version' do
  version '1.2'
  on_update -> { puts 'Hello world!' }
end
