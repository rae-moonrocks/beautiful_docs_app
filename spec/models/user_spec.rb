require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
         described_class.new(password: "some_password",
                             email: "john@doe.com"
         )
  }

  it 'has fields' do
    expect(subject.password).not_to be(nil)
    expect(subject.email).not_to be(nil)
  end
end
