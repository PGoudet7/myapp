require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "email validation should accept valid adresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "This email address should be valid #{addr.inspect}"
    end
  end
  
  test "email validation should reject invalid adresses" do
    invalid_addresses = %w[user@example,com USER@fooCOM A_US-ER@foo-_bar.org
                         first.last@foo;jp alice+bob@baz!cn]
    invalid_addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "This email address should  not be valid #{addr.inspect}"
    end
  end

  test "email shoud be unique" do
    dup_user = @user.dup
    dup_user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "Password should be present and not blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "Password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    addr = "Foo@Example.coM"
    @user.email = addr
    @user.save
    assert_equal addr.downcase, @user.reload.email
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  

  test "associated microposts should be delete" do
    @user.save
    @user.microposts.create(:content => "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
end
