require 'chefspec'
require 'chefspec/berkshelf'

describe 'shopify_apt_get_on_change_test::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['shopify_apt_get_on_change'])
                        .converge(described_recipe)
  end

  it 'should update shopify_apt_get_on_change' do
    expect(chef_run).to\
      update_shopify_apt_get_on_change('/etc/example.app/version')
  end

  it 'should create version file with right content' do
    expect(chef_run).to\
      create_file('/etc/example.app/version').with_content('1.2')
  end

  it 'should create file resource that executes apt get update on change' do
    file = chef_run.file('/etc/example.app/version')
    expect(file).to notify('execute[apt-get-update]').to(:run).immediately
  end

  it 'should create file resource that notifies the on_update ruby block' do
    file = chef_run.file('/etc/example.app/version')
    expect(file).to notify('ruby_block[on-update]').to(:run).immediately
  end

  it 'should execute nothing' do
    expect(chef_run.execute('apt-get-update')).to do_nothing
  end

  it 'should not run the ruby block' do
    expect(chef_run.ruby_block('on-update')).to do_nothing
  end

  it 'should have the right command for execute resource' do
    execute = chef_run.execute('apt-get-update')
    expect(execute.command).to eq 'apt-get -q update'
  end

  it 'should not run the ruby block without a handler given' do
    block = chef_run.ruby_block('on-update')
    expect(block.only_if.first.evaluate).to be_falsey
  end
end

describe 'shopify_apt_get_on_change_test::on_update' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['shopify_apt_get_on_change'])
                        .converge(described_recipe)
  end

  it 'should create version file with right content' do
    expect(chef_run).to\
      create_file('/etc/example.app/version').with_content('1.2')
  end

  it 'should do nothing if not notified' do
    block = chef_run.ruby_block('on-update')
    expect(block).to do_nothing
  end

  it 'should notify datadog ruby block that an update has occured' do
    file = chef_run.file('/etc/example.app/version')
    expect(file).to notify('ruby_block[on-update]').to(:run).immediately
  end

  it 'should send the event if notified' do
    block = chef_run.ruby_block('on-update')
    expect(block.only_if.first.evaluate).to be_truthy
  end
end
