shopify_apt_get_on_change Cookbook
==================

[![Circle CI](https://circleci.com/gh/Shopify/shopify_apt_get_on_change.svg?style=svg&circle-token=521e8dc183ddfe02c8e8dfd0bc2b1ab667337589)](https://circleci.com/gh/Shopify/shopify_apt_get_on_change)

```
shopify_apt_get_on_change '/etc/shackle.d/version' do
  version current_version
end
```

The above example will do `apt-get -q update` whenever `current_version` is different than the content of `/etc/shackle.d/version`
