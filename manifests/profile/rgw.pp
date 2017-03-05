#
#  Copyright (C) 2016 Keith Schincke
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
# Author: Keith Schincke <keith.schincke@gmail.com>
#
# == Class: cephir::profile::rgw
#
# Profile for Ceph rgw
#
class cephir::profile::rgw {
  require ::cephir::profile::base
  $rgw_name = $::cephir::profile::params::rgw_name ? {
    undef   => 'radosgw.gateway',
    default => $::cephir::profile::params::rgw_name,
  }
  cephir::rgw { $rgw_name:
    user               => $::cephir::profile::params::rgw_user,
    rgw_print_continue => $::cephir::profile::params::rgw_print_continue,
    frontend_type      => $::cephir::profile::params::frontend_type,
    rgw_frontends      => $::cephir::profile::params::rgw_frontends,
  }
}
