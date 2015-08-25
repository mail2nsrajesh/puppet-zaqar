#
# Unit tests for zaqar::keystone::auth
#

require 'spec_helper'

describe 'zaqar::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'zaqar_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('zaqar').with(
      :ensure   => 'present',
      :password => 'zaqar_password',
      :tenant   => 'foobar'
    ) }

    it { is_expected.to contain_keystone_user_role('zaqar@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('zaqar').with(
      :ensure      => 'present',
      :type        => 'queue',
      :description => 'zaqar queue service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar').with(
      :ensure       => 'present',
      :public_url   => "http://127.0.0.1:8888/",
      :admin_url    => "http://127.0.0.1:8888/",
      :internal_url => "http://127.0.0.1:8888/"
    ) }
  end

  describe 'when overriding public_url, internal_url and admin_url' do
    let :params do
      { :password     => 'zaqar_password',
        :public_url   => 'https://10.10.10.10:8080',
        :admin_url    => 'http://10.10.10.10:8080',
        :internal_url => 'http://10.10.10.10:8080'
      }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar').with(
      :ensure       => 'present',
      :public_url   => "https://10.10.10.10:8080/",
      :internal_url => "http://10.10.10.10:8080/",
      :admin_url    => "http://10.10.10.10:8080/"
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'zaqary' }
    end

    it { is_expected.to contain_keystone_user('zaqary') }
    it { is_expected.to contain_keystone_user_role('zaqary@services') }
    it { is_expected.to contain_keystone_service('zaqary') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/zaqary') }
  end

  describe 'when overriding service name' do
    let :params do
      { :service_name => 'zaqar_service',
        :auth_name    => 'zaqar',
        :password     => 'zaqar_password' }
    end

    it { is_expected.to contain_keystone_user('zaqar') }
    it { is_expected.to contain_keystone_user_role('zaqar@services') }
    it { is_expected.to contain_keystone_service('zaqar_service') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/zaqar_service') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => 'zaqar_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('zaqar') }
    it { is_expected.to contain_keystone_user_role('zaqar@services') }
    it { is_expected.to contain_keystone_service('zaqar').with(
      :ensure      => 'present',
      :type        => 'queue',
      :description => 'zaqar queue service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => 'zaqar_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('zaqar') }
    it { is_expected.not_to contain_keystone_user_role('zaqar@services') }
    it { is_expected.to contain_keystone_service('zaqar').with(
      :ensure      => 'present',
      :type        => 'queue',
      :description => 'zaqar queue service'
    ) }

  end

end
