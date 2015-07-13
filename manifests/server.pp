class zk::server {

    $zk = hiera('zk')

    package { ['zookeeper', 'zookeeperd']:
        ensure  => installed
    }

    $zk.each |$ensemble, $servers| {
        file { "/etc/zookeeper/conf.${ensemble}":
            ensure  => directory
        }

        file { "/etc/zookeeper/conf.${ensemble}/myid":
            content => template('zk/myid.erb'),
            mode    => '0444',
            owner   => 'root',
            group   => 'root'
        }

        file { "/etc/zookeeper/conf.${ensemble}/zoo.cfg":
            content => template('zk/zoo.cfg.erb'),
            mode    => '0444',
            owner   => 'root',
            group   => 'root'
        }

        file { "/etc/zookeeper/conf.${ensemble}/configuration.xsl":
            source  => 'puppet:///modules/zk/configuration.xsl',
            mode    => '0444',
            owner   => 'root',
            group   => 'root'
        }

        file { "/etc/zookeeper/conf.${ensemble}/environment":
            source  => 'puppet:///modules/zk/environment',
            mode    => '0444',
            owner   => 'root',
            group   => 'root'
        }

        file { "/etc/zookeeper/conf.${ensemble}/log4j.properties":
            source  => 'puppet:///modules/zk/log4j.properties',
            mode    => '0444',
            owner   => 'root',
            group   => 'root'
        }

        $servers.each |$server| {
            if $server['host'] == $hostname {
                file { '/etc/alternatives/zookeeper-conf':
                    ensure => link,
                    target => "/etc/zookeeper/conf.${ensemble}"
                }
            }
        }
    }

}
