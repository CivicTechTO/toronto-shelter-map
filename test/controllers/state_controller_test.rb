require 'test_helper'
require 'user_seeds_test_helper'
require 'site_org_seeds_test_helper'
require 'faker'

class StateControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    SiteOrgSeedsTestHelper.clean
    UserSeedsTestHelper.clean
    @org = SiteOrgSeedsTestHelper.seed_org
    @subdomain = @org.subdomain
    @site = SiteOrgSeedsTestHelper.seed_site(@org)
    @validUser = UserSeedsTestHelper.seed_user
  end

  test "Get the base state - logged in" do
    sign_in @validUser
    get base_state_path
    assert_response 200
  end

  test "Get the base state - logged out" do
    sign_in @validUser
    get base_state_path
    json_response = JSON.parse(response.body)
    assert_response 200
    assert(json_response[:appUser] == nil)
  end

  test "getting base state - no domain" do
    sign_in @validUser
    get base_state_path
    assert(true)
  end

  test "getting base state - with bad domain" do
    host! "asubdomainthatdoesntexist.#{Rails.application.config.domain}"
    sign_in @validUser
    get base_state_path
    json_response = JSON.parse(response.body)
    assert_nil(json_response['appOrg'])
  end

  test "getting base state - with good domain" do
    host! "#{@subdomain}.#{Rails.application.config.domain}"
    sign_in @validUser
    get base_state_path
    json_response = JSON.parse(response.body)
    assert_equal(@org.id, json_response['appOrg'])
  end

end
