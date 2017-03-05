#
#   Copyright (C) 2014 Nine Internet Solutions AG
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
# Author: David Gurtner <aldavud@crimson.ch>
#
# == Class: cephir::profile::base
#
# Base profile to install ceph and configure /etc/ceph/cephir.conf
#
class cephir::profile::base {
  include ::cephir::profile::params

  if ( $cephir::profile::params::manage_repo ) {
    Class['cephir::repo'] -> Class['ceph']

    class { '::cephir::repo':
      release => $cephir::profile::params::release,
    }
  }

  class { '::ceph':
    fsid                          => $cephir::profile::params::fsid,
    authentication_type           => $cephir::profile::params::authentication_type,
    osd_journal_size              => $cephir::profile::params::osd_journal_size,
    osd_max_object_name_len       => $cephir::profile::params::osd_max_object_name_len,
    osd_max_object_namespace_len  => $cephir::profile::params::osd_max_object_namespace_len,
    osd_pool_default_pg_num       => $cephir::profile::params::osd_pool_default_pg_num,
    osd_pool_default_pgp_num      => $cephir::profile::params::osd_pool_default_pgp_num,
    osd_pool_default_size         => $cephir::profile::params::osd_pool_default_size,
    osd_pool_default_min_size     => $cephir::profile::params::osd_pool_default_min_size,
    mon_initial_members           => $cephir::profile::params::mon_initial_members,
    mon_host                      => $cephir::profile::params::mon_host,
    ms_bind_ipv6                  => $cephir::profile::params::ms_bind_ipv6,
    cluster_network               => $cephir::profile::params::cluster_network,
    public_network                => $cephir::profile::params::public_network,
    osd_max_backfills             => $cephir::profile::params::osd_max_backfills,
    osd_recovery_max_active       => $cephir::profile::params::osd_recovery_max_active,
    osd_recovery_op_priority      => $cephir::profile::params::osd_recovery_op_priority,
    osd_recovery_max_single_start => $cephir::profile::params::osd_recovery_max_single_start,
    osd_max_scrubs                => $cephir::profile::params::osd_max_scrubs,
    osd_op_threads                => $cephir::profile::params::osd_op_threads,
    rbd_default_features          => $cephir::profile::params::rbd_default_features,
  }
}
