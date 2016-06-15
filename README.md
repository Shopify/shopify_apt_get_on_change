shopify_apt_get_on_change Cookbook
==================

[![Circle CI](https://circleci.com/gh/Shopify/shopify_apt_get_on_change.svg?style=svg&circle-token=b415fe807f3b637707e50a345c4e1c6cf6383da0)](https://circleci.com/gh/Shopify/shopify_apt_get_on_change)

```
shopify_apt_get_on_change '/etc/shackle.d/version' do
  version current_version
end
```

The above example will do `apt-get -q update` whenever `current_version` is different than the content of `/etc/shackle.d/version`
