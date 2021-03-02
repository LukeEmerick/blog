require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  it 'is valid with valid required attributes' do
    post = described_class.new(
      user: user,
      title: '7 clickbaits titles that will get you the most engagement out of your post base',
      content: 'did you see what I did there?'
    )
    expect(post).to be_valid
  end

  it 'is not valid without an user' do
    post = described_class.new(
      title: '7 clickbaits titles that will get you the most engagement out of your post base',
      content: 'did you see what I did there?'
    )
    expect(post).to be_invalid
  end

  it 'is not valid without a title' do
    post = described_class.new(
      user: user,
      content: 'did you see what I did there?'
    )
    expect(post).to be_invalid
  end

  it 'is not valid without content' do
    post = described_class.new(
      user: user,
      title: '7 clickbaits titles that will get you the most engagement out of your post base'
    )
    expect(post).to be_invalid
  end
end
