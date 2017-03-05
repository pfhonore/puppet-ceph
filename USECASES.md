Use Cases
=========

I want to try this module, heard of ceph, want to see it in action
------------------------------------------------------------------

I want to run it on a virtual machine, all in one. The **cephir::repo** class will enable the official ceph repository with the most current branch selected. The **ceph** class will create a configuration file with no authentication enabled. The **cephir::mon** resource configures and runs a monitor to which a **ceph::osd** daemon will connect to provide disk storage backed by the /srv/data folder (note that storing OSD data on an existing filesystem is only recommended for simple tests like this one).

* install puppet and this module and its dependences (see metadata.json)
* paste the snippet above into /tmp/ceph.puppet
* `puppet apply /tmp/ceph.puppet`
* `ceph -s`: it will connect to the monitor and report that the cluster is ready to be used

```
    class { 'cephir::repo': }
    class { 'ceph':
      fsid                       => generate('/usr/bin/uuidgen'),
      mon_host                   => $::ipaddress,
      authentication_type        => 'none',
      osd_pool_default_size      => '1',
      osd_pool_default_min_size  => '1',
    }
    cephir_config {
     'global/osd_journal_size': value => '100';
    }
    cephir::mon { 'a':
      public_addr         => $::ipaddress,
      authentication_type => 'none',
    }
    cephir::osd { '/srv/data': }
```

I want to operate a production cluster
--------------------------------------

_Notice : Please note that the code below is a sample which is not expected to work without further configuration. You will need to at least adapt the hostnames, the IP addresses of the monitor hosts and the OSD disks to your setup._

On all machines:
* install puppet and this module and its dependences (see metadata.json)
* paste the snippet below into /tmp/ceph.puppet

On the monitor hosts:
* `puppet apply /tmp/ceph.puppet` (please note that you will need to run this on all monitor hosts at the same time, as they need to connect to each other to finish setting up)

On all other hosts:
* `puppet apply /tmp/ceph.puppet`

Enjoy your ceph cluster!

```
    $admin_key = 'AQCTg71RsNIHORAAW+O6FCMZWBjmVfMIPk3MhQ=='
    $mon_key = 'AQDesGZSsC7KJBAAw+W/Z4eGSQGAIbxWjxjvfw=='
    $bootstrap_osd_key = 'AQABsWZSgEDmJhAAkAGSOOAJwrMHrM5Pz5On1A=='
    $fsid = '066F558C-6789-4A93-AAF1-5AF1BA01A3AD'

    node /mon[123]/ {
      class { 'cephir::repo': }
      class { 'ceph':
        fsid                => $fsid,
        mon_initial_members => 'mon1,mon2,mon3',
        mon_host            => '<ip of mon1>,<ip of mon2>,<ip of mon3>',
      }
      cephir::mon { $::hostname:
        key => $mon_key,
      }
      Ceph::Key {
        inject         => true,
        inject_as_id   => 'mon.',
        inject_keyring => "/var/lib/ceph/mon/ceph-${::hostname}/keyring",
      }
      cephir::key { 'client.admin':
        secret  => $admin_key,
        cap_mon => 'allow *',
        cap_osd => 'allow *',
        cap_mds => 'allow',
      }
      cephir::key { 'client.bootstrap-osd':
        secret  => $bootstrap_osd_key,
        cap_mon => 'allow profile bootstrap-osd',
      }
    }

    node /osd*/ {
      class { 'cephir::repo': }
      class { 'ceph':
        fsid                => $fsid,
        mon_initial_members => 'mon1,mon2,mon3',
        mon_host            => '<ip of mon1>,<ip of mon2>,<ip of mon3>',
      }
      cephir::osd {
      '<disk1>':
        journal => '<journal for disk1>';
      '<disk2>':
        journal => '<journal for disk2>';
      }
      cephir::key {'client.bootstrap-osd':
         keyring_path => '/var/lib/ceph/bootstrap-osd/ceph.keyring',
         secret       => $bootstrap_osd_key,
      }
    }

    node /client/ {
      class { 'cephir::repo': }
      class { 'ceph':
        fsid                => $fsid,
        mon_initial_members => 'mon1,mon2,mon3',
        mon_host            => '<ip of mon1>,<ip of mon2>,<ip of mon3>',
      }
      cephir::key { 'client.admin':
        secret => $admin_key
      }
    }
```

I want to run benchmarks on three new machines
----------------------------------------------

_Notice : Please note that the code below is a sample which is not expected to work without further configuration. You will need to at least adapt the hostnames, the IP address of the monitor host and the OSD disks to your setup._

There are four machines, 3 OSDs, one of which also doubles as the single monitor and one machine that is the client from which the user runs the benchmark.

On all four machines:
* install puppet and this module and its dependences (see metadata.json)
* paste the snippet below into /tmp/ceph.puppet
* `puppet apply /tmp/ceph.puppet`

On the client:
* `rados bench`
* interpret the results

```
    $fsid = '066F558C-6789-4A93-AAF1-5AF1BA01A3AD'

    node /node1/ {
      class { 'cephir::repo': }
      class { 'ceph':
        fsid                => $fsid,
        mon_host            => '<ip of node1>',
        mon_initial_members => 'node1',
        authentication_type => 'none',
      }
      cephir::mon { $::hostname:
        authentication_type => 'none',
      }
      cephir::osd {
      '<disk1>':
        journal => '<journal for disk1>';
      '<disk2>':
        journal => '<journal for disk2>';
      }
    }

    node /node[23]/ {
      class { 'cephir::repo': }
      class { 'ceph':
        fsid                => $fsid,
        mon_host            => '<ip of node1>',
        mon_initial_members => 'node1',
        authentication_type => 'none',
      }
      cephir::osd {
      '<disk1>':
        journal => '<journal for disk1>';
      '<disk2>':
        journal => '<journal for disk2>';
      }
    }

    node /client/ {
      class { 'cephir::repo': }
      class { 'ceph':
        fsid                => $fsid,
        mon_host            => '<ip of node1>',
        mon_initial_members => 'node1',
        authentication_type => 'none',
      }
    }
```

