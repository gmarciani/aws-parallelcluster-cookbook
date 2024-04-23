# frozen_string_literal: true

provides :install_pyenv
unified_mode true

# Resource:: to create a Python virtual environment for a given user

property :python_version, String
property :prefix, String
property :user_only, [true, false], default: false
property :user, String

default_action :run

action :run do
  #sudo /usr/bin/python3.8 -m venv /opt/parallelcluster/test-venv
  python_version = new_resource.python_version || node['cluster']['python-version']

  # alinux_extras_topic 'python 3.8' do
  #   topic 'python3.8'
  # end


  if new_resource.user_only
    raise "user property is required for resource install_pyenv when user_only is set to true" unless new_resource.user

    pyenv_install 'user' do
      user new_resource.user
      prefix new_resource.prefix if new_resource.prefix
    end
  else
    prefix = new_resource.prefix || node['cluster']['system_pyenv_root']

    directory prefix do
      recursive true
    end

    bash "install python #{python_version}" do
      user 'root'
      group 'root'
      cwd "#{prefix}"
      code <<-VENV
      set -e
      aws s3 cp s3://hgreebe-dependencies/archives/dependencies/python/Python-#{python_version}.tgz Python-#{python_version}.tgz
      tar -xzf Python-#{python_version}.tgz
      cd Python-#{python_version}
      ./configure --prefix=#{prefix}/versions/#{python_version}
      make
      make install
      VENV
    end

    # pyenv_install 'system' do
    #   prefix prefix
    # end

    # Remove the profile.d script that the pyenv cookbook writes.
    # This is done in order to avoid exposing the ParallelCluster pyenv installation to customers
    # on login.
    # file '/etc/profile.d/pyenv.sh' do
    #   action :delete
    # end
  end

  # pyenv_python python_version do
  #   user new_resource.user if new_resource.user_only
  # end
  #
  # pyenv_plugin 'virtualenv' do
  #   git_url 'https://github.com/pyenv/pyenv-virtualenv'
  #   user new_resource.user if new_resource.user_only
  # end
end
