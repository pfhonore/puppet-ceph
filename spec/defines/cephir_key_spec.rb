#
# Copyright (C) 2014 Catalyst IT Limited.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# Author: Ricardo Rocha <ricardo@catalyst.net.nz>
#

require 'spec_helper'

describe 'cephir::key' do

  shared_examples_for 'cephir key' do

    describe "with custom params" do

      let :title do
        'client.admin'
      end

      let :params do
        {
          :secret  => 'supersecret',
          :user    => 'nobody',
          :group   => 'nogroup',
          :cap_mon => 'allow *',
          :cap_osd => 'allow rw',
          :inject  => true,
        }
      end

      it {
        is_expected.to contain_exec('cephir-key-client.admin').with(
          'command' => "/bin/true # comment to satisfy puppet syntax requirements\nset -ex\nceph-authtool /etc/ceph/cephir.client.admin.keyring --name 'client.admin' --add-key 'supersecret' --cap mon 'allow *' --cap osd 'allow rw' "
        )
        is_expected.to contain_file('/etc/ceph/cephir.client.admin.keyring').with(
          'owner'                   => 'nobody',
          'group'                   => 'nogroup',
          'mode'                    => '0600',
          'selinux_ignore_defaults' => true,
        )
        is_expected.to contain_exec('cephir-injectkey-client.admin').with(
           'command' => "/bin/true # comment to satisfy puppet syntax requirements\nset -ex\nceph    auth import -i /etc/ceph/cephir.client.admin.keyring"
        )
      }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'cephir key'
    end
  end
end

# Local Variables:
# compile-command: "cd ../.. ;
#    bundle install ;
#    bundle exec rake spec
# "
# End:
