exec { "apt-get update":
  path => "/usr/bin",
  require => [
    Exec["add-apt-repository nodejs"],
    File["/etc/apt/sources.list.d/10gen.list"],
  ]
}

exec { "add-apt-repository nodejs":
  command => "/usr/bin/add-apt-repository ppa:chris-lea/node.js",
  require => Package["python-software-properties"],
}

exec { "apt-key 10gen":
  command => "/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10",
}

file { "/etc/apt/sources.list.d/10gen.list":
  content => "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen\n",
  owner   => root,
  group   => root,
  mode    => 0644,
  require => Exec["apt-key 10gen"],
}

package { "python-software-properties" :
  ensure => "0.82.7",
}

package { "nodejs":
  ensure  => "0.10.21-1chl1~precise1",
  require => Exec["apt-get update"],
}

package { "mongodb-10gen":
  ensure => '2.4.6',
  require => Exec["apt-get update"],
}

service { "mongodb":
  ensure => "running",
  require => Package["mongodb-10gen"],
}

