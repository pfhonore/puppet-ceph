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
# Author: Jan Provaznik <jprovazn@redhat.com>
#
# == Class: cephir::profile::fs
#
# Profile for a Ceph fs
#
class cephir::profile::fs {
  require ::cephir::profile::base

  cephir::fs { $cephir::profile::params::fs_name:
    metadata_pool => $cephir::profile::params::fs_metadata_pool,
    data_pool     => $cephir::profile::params::fs_data_pool,
  }
}
