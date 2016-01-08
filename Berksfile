def fixture(name)
  cookbook "omnibus_#{name}", path: "test/fixtures/cookbooks/omnibus_#{name}"
end

source 'https://supermarket.chef.io'

cookbook 'remote_install', git: 'git@github.com:chef-cookbooks/remote_install.git'

metadata

group :integration do
  cookbook 'apt'
  cookbook 'fancy_execute'
  cookbook 'freebsd'
  cookbook 'yum-epel'
  fixture 'build'
end
