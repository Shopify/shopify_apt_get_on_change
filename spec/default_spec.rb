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

  it 'should execute nothing' do
    execute = chef_run.execute('apt-get-update')
    expect(execute).to do_nothing
  end

  it 'should have the right command for execute resource' do
    execute = chef_run.execute('apt-get-update')
    expect(execute.command).to eq 'apt-get -q update'
  end

  it 'should not send a nil event to datadog' do
    expect(chef_run).to_not run_ruby_block('datadog')
  end
end

describe 'shopify_apt_get_on_change_test::datadog' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['shopify_apt_get_on_change'])
                        .converge(described_recipe)
  end

  it 'should create version file with right content' do
    expect(chef_run).to\
      create_file('/etc/example.app/version').with_content('1.2')
  end

  it 'should do nothing if not notified' do
    block = chef_run.ruby_block('datadog')
    expect(block).to do_nothing
  end

  it 'should notify datadog ruby block that an update has occured' do
    file = chef_run.file('/etc/example.app/version')
    expect(file).to notify('ruby_block[datadog]').to(:run).immediately
  end

  it 'should send the event if notified' do
    datadog_block = chef_run.ruby_block('datadog')
    expect(datadog_block.only_if.first.evaluate).to be_truthy
  end
end

describe 'shopify_apt_get_on_change_test::datadog_noname' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['shopify_apt_get_on_change'])
                        .converge(described_recipe)
  end

  it 'should create version file with right content' do
    expect(chef_run).to\
      create_file('/etc/example.app/version').with_content('1.2')
  end

  it 'should notify datadog ruby block that an update has occured' do
    file = chef_run.file('/etc/example.app/version')
    expect(file).to notify('ruby_block[datadog]').to(:run).immediately
  end

  it 'should not send the event when notified if the name field is missing' do
    datadog_block = chef_run.ruby_block('datadog')
    expect(datadog_block.only_if.first.evaluate).to be_falsey
  end
end

describe 'shopify_apt_get_on_change_test::datadog_notext' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['shopify_apt_get_on_change'])
                        .converge(described_recipe)
  end

  it 'should create version file with right content' do
    expect(chef_run).to\
      create_file('/etc/example.app/version').with_content('1.2')
  end

  it 'should notify datadog ruby block that an update has occured' do
    file = chef_run.file('/etc/example.app/version')
    expect(file).to notify('ruby_block[datadog]').to(:run).immediately
  end

  it 'should not send the event when notified if the text field is missing' do
    datadog_block = chef_run.ruby_block('datadog')
    expect(datadog_block.only_if.first.evaluate).to be_falsey
  end
end

describe 'push_to_datadog' do
  # mock out the datadog statsd
  let(:statsd) { double('statsd') }
  before do
    allow(statsd).to receive(:event)
    allow(Datadog::Statsd).to receive(:new).and_return(statsd)
  end

  it 'should send the event to datadog' do
    expect(statsd).to\
      receive(:event).with('name', 'text', aggregation_key: 'key')

    push_to_datadog(name: 'name', text: 'text', key: 'key')
  end
end
