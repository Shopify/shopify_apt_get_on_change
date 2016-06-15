shopify_apt_get_on_change Cookbook
==================

```
shopify_apt_get_on_change '/etc/shackle.d/version' do
  version current_version
end
```

The above example will do `apt-get -q update` whenever `current_version` is different than the content of `/etc/shackle.d/version`
