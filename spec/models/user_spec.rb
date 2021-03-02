require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid required attributes' do
    user = described_class.new(
      displayName: 'rubens silva',
      email: 'rubinho2@gmail.com',
      password: '123456'
    )
    expect(user).to be_valid
  end

  it 'is not valid without a displayName' do
    user = described_class.new(
      email: 'rubinho2@gmail.com',
      password: '123456'
    )
    expect(user).to be_invalid
  end

  it 'is not valid with a displayName shorter than 8 characters' do
    user = described_class.new(
      displayName: 'rubens',
      email: 'rubinho2@gmail.com',
      password: '123456'
    )
    expect(user).to be_invalid
  end

  it 'is not valid without an email' do
    user = described_class.new(
      displayName: 'rubens silva',
      password: '123456'
    )
    expect(user).to be_invalid
  end

  it 'is not valid with an email lacking the username' do
    user = described_class.new(
      displayName: 'rubens silva',
      email: 'rubinho2',
      password: '123456'
    )
    expect(user).to be_invalid
  end

  it 'is not valid with an email lacking the domain' do
    user = described_class.new(
      displayName: 'rubens silva',
      email: '@gmail.com',
      password: '123456'
    )
    expect(user).to be_invalid
  end

  it 'is not valid without a password' do
    user = described_class.new(
      email: 'rubinho2@gmail.com',
      displayName: 'rubens silva'
    )
    expect(user).to be_invalid
  end

  it 'is not valid with a password shorter than 6 characters' do
    user = described_class.new(
      email: 'rubinho2@gmail.com',
      displayName: 'rubens silva',
      password: '12345'
    )
    expect(user).to be_invalid
  end
end
