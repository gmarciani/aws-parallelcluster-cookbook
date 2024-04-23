# frozen_string_literal: true
#
# Copyright:: 2013-2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.

unified_mode true
default_action :setup

property :nvidia_enabled, [true, false, nil]

action :setup do
  return unless _nvidia_dcgm_enabled

  # Add NVIDIA repo for fabric manager and datacenter-gpu-manager
  # nvidia_repo 'add nvidia repository' do
  #   action :add
  # end

  # package 'datacenter-gpu-manager' do
  #   retries 3
  #   retry_delay 5
  #   version package_version
  # end

  action_install_package

  # nvidia_repo 'remove nvidia repository' do
  #   action :remove
  # end
end

def _nvidia_enabled
  nvidia_enabled.nil? ? ['yes', true].include?(node['cluster']['nvidia']['enabled']) : nvidia_enabled
end