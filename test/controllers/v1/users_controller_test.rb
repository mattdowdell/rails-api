require 'test_helper'

module V1
  class UsersControllerTest < ActionController::TestCase
    ##
    # Data for creating new users.
    ##
    CREATE_DATA = {
      name: 'Bob',
      email: 'bob@example.com',
      password: 'password'
    }.freeze

    ##
    # Test success of the `create` method.
    ##
    test 'create success' do
      data = create_data
      expected = {
        result: 'success'
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling of the `create` method for missing `token` parameter.
    ##
    test 'create missing token' do
      data = create_data
      data.delete(:token)

      expected = {
        error: 112,
        message: 'Invalid or missing token.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for missing `name` parameter.
    ##
    test 'create name missing' do
      data = create_data
      data.delete(:name)

      expected = {
        error: 103,
        message: '"name" can\'t be blank.',
        user_message: 'Name can\'t be blank.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for too long `name` parameter.
    ##
    test 'create name too long' do
      data = create_data
      data[:name] = 'x' * 256

      expected = {
        error: 103,
        message: '"name" is too long (maximum is 255 characters).',
        user_message: 'Name is too long (maximum is 255 characters).',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for missing `email` parameter.
    ##
    test 'create email missing' do
      data = create_data
      data.delete(:email)

      expected = {
        error: 103,
        message: '"email" is too short (minimum is 3 characters).',
        user_message: 'Email address is too short (minimum is 3 characters).',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for invalid `email` parameter.
    ##
    test 'create email invalid' do
      data = create_data
      data[:email] = 'invalid'

      expected = {
        error: 103,
        message: '"email" is invalid.',
        user_message: 'Email address is invalid.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for too long `email` parameter.
    ##
    test 'create email too long' do
      data = create_data
      data[:email] = 'x@' + ('y' * 254)

      expected = {
        error: 103,
        message: '"email" is too long (maximum is 255 characters).',
        user_message: 'Email address is too long (maximum is 255 characters).',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for too short `email` parameter.
    ##
    test 'create email too short' do
      data = create_data
      data[:email] = '@'

      expected = {
        error: 103,
        message: '"email" is too short (minimum is 3 characters).',
        user_message: 'Email address is too short (minimum is 3 characters).',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for an in-use `email` parameter.
    ##
    test 'create email in use' do
      user = User.first!
      data = create_data
      data[:email] = user.email

      expected = {
        error: 103,
        message: '"email" is already in use.',
        user_message: 'Email address is already in use.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for missing `password` parameter.
    ##
    test 'create password missing' do
      data = create_data
      data.delete(:password)

      expected = {
        error: 103,
        message: '"password" can\'t be blank.',
        user_message: 'Password can\'t be blank.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for too short `password` parameter.
    ##
    test 'create password too short' do
      data = create_data
      data[:password] = 'x'

      expected = {
        error: 103,
        message: '"password" is too short (minimum is 8 characters).',
        user_message: 'Password is too short (minimum is 8 characters).',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method for too long `password` parameter.
    ##
    test 'create password too long' do
      data = create_data
      data[:password] = 'x' * 73

      expected = {
        error: 103,
        message: '"password" is too long (maximum is 72 characters).',
        user_message: 'Password is too long (maximum is 72 characters).',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of the `create` method with the `password` parameter at the upper limit.
    ##
    test 'create success password upper limit' do
      data = create_data
      data[:password] = 'x' * 72

      expected = {
        result: 'success'
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of the `login` method.
    ##
    test 'login success' do
      data = login_data

      expected = {
        result: 'success'
      }

      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `login` method with a missing `token` parameter.
    ##
    test 'login missing token' do
      data = login_data
      data.delete(:token)

      expected = {
        error: 112,
        message: 'Invalid or missing token.',
        status: 400
      }

      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `login` method with a missing `email` parameter.
    ##
    test 'login email missing' do
      data = login_data
      data.delete(:email)

      expected = {
        error: 104,
        message: '"email" not found.',
        status: 400
      }

      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `login` method with a not found `email` parameter.
    ##
    test 'login email not found' do
      data = login_data
      data[:email] = 'not_found'

      expected = {
        error: 104,
        message: '"email" not found.',
        status: 400
      }

      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `login` method with a missing `password` parameter.
    ##
    test 'login password missing' do
      data = login_data
      data.delete(:password)

      expected = {
        error: 102,
        message: 'Invalid or missing value for "password".',
        user_message: 'Incorrect or missing password.',
        status: 400
      }

      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `login` method with an incorrect `password` parameter.
    ##
    test 'login password incorrect' do
      data = login_data
      data[:password] = 'incorrect'

      expected = {
        error: 102,
        message: 'Invalid or missing value for "password".',
        user_message: 'Incorrect or missing password.',
        status: 400
      }

      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of the `login` with an existing valid session.
    ##
    test 'login existing session' do
      data = login_data
      expected = {
        result: 'success'
      }

      post :login, body: data.to_json
      data = add_token data
      post :login, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of the `logout` method.
    ##
    test 'logout success' do
      post(:login, body: login_data.to_json)

      user = User.find_by_email! CREATE_DATA[:email]
      assert_equal user.session_token, cookies.signed[:session]

      post :logout
      assert response.cookies['session'].nil?
    end

    ##
    # Test success of the `logout` method with a missing session token.
    ##
    test 'logout missing session' do
      post :logout

      assert response.cookies['session'].nil?
    end

    ##
    # Test success of the `logout` method with an invalid session token.
    ##
    test 'logout invalid session' do
      cookies[:session] = 'invalid'

      post :logout

      assert response.cookies['session'].nil?
    end

    ##
    # Test success of the `show` method.
    ##
    test 'show success' do
      expected = {
        name: CREATE_DATA[:name],
        email: CREATE_DATA[:email]
      }

      post :login, body: login_data.to_json
      post :show

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling of the `show` method when not logged in.
    ##
    test 'show not logged in' do
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      post :show

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of the `update` method.
    ##
    test 'update success' do
      new_name = 'Example'
      data = add_token name: new_name
      expected = {
        name: new_name
      }

      post :login, body: login_data.to_json
      post :update, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling of the `update` method with a non-whitelisted attribute.
    ##
    test 'update non-whitelisted attribute' do
      data = add_token invalid: 'invalid'
      expected = {
        error: 111,
        message: 'Unable to update attribute "invalid".',
        status: 400
      }

      post :login, body: login_data.to_json
      post :update, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `update` method with an invalid `name` attribute.
    ##
    test 'update invalid name' do
      data = add_token name: 'x' * 256
      expected = {
        error: 110,
        message: '"name" is too long (maximum is 255 characters).',
        user_message: 'Name is too long (maximum is 255 characters).',
        status: 400
      }

      post :login, body: login_data.to_json
      post :update, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `update` method when not logged in.
    ##
    test 'update not logged in' do
      data = add_token
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      post :update, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `update` method with a missing `token` attribute.
    ##
    test 'update missing token' do
      new_name = 'Example'
      data = { name: new_name }
      expected = {
        error: 112,
        message: 'Invalid or missing token.',
        status: 400
      }

      post :login, body: login_data.to_json
      post :update, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    private

    ##
    #
    ##
    def create_data
      data = CREATE_DATA.deep_dup
      data = add_token data

      return data
    end

    ##
    # Helper method for creating a new user.
    ##
    def create_user!
      data = CREATE_DATA.deep_dup
      User.create! data
    end

    ##
    # Helper method for getting data for the `login` method.
    ##
    def login_data
      create_user!

      data = CREATE_DATA.deep_dup
      data = add_token data
      data.delete(:name)

      return data
    end
  end
end
