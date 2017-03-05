#
#   Copyright (C) 2016 Red Hat, Inc.
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
# Author: Giulio Fidente <gfidente@redhat.com>
#
# == Class: cephir::profile::mds
#
# Profile for a Ceph mds
#
class cephir::profile::mds {
  require ::cephir::profile::base

  class { '::cephir::mds':
    public_addr => $cephir::profile::params::public_addr,
  }

  if !empty($cephir::profile::params::mds_key) {
    cephir::key { "mds.${::hostname}":
      cap_mon      => 'allow profile mds',
      cap_osd      => 'allow rwx',
      cap_mds      => 'allow',
      inject       => true,
      keyring_path => "/var/lib/ceph/mds/ceph-${::hostname}/keyring",
      secret       => $cephir::profile::params::mds_key,
      user         => 'ceph',
      group        => 'ceph'
    }
  }
}
