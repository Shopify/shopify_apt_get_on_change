if defined?(ChefSpec)
  def update_shopify_apt_get_on_change(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('shopify_apt_get_on_change', 'update', resource_name)
  end
end
