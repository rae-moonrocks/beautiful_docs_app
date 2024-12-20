require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('invalidemail').for(:email) }
  end

  it 'ensures email is case insensitive for uniqueness' do
    create(:user, email: 'Test@Example.com')
    user2 = build(:user, email: 'test@example.com')
    expect(user2).to be_invalid
    expect(user2.errors[:email]).to include('has already been taken')
  end

  describe '#authenticate' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    it 'authenticates with correct email and password' do
      authenticated_user = User.authenticate('test@example.com', 'password')
      expect(authenticated_user).to eq(user)
    end

    it 'returns nil with incorrect email' do
      expect(User.authenticate('wrong@example.com', 'password')).to be_nil
    end

    it 'returns nil with incorrect password' do
      expect(User.authenticate('test@example.com', 'wrongpassword')).to be_nil
    end
  end

  describe '#admin?' do
    let(:user) { build(:user, role: 1) }

    it 'returns true for admin role' do
      expect(user.admin?).to be(true)
    end

    let(:non_admin_user) { build(:user, role: 'user') }

    it 'returns false for non-admin role' do
      expect(non_admin_user.admin?).to be(false)
    end
  end
end
