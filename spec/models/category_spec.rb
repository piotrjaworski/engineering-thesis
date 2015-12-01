require 'rails_helper'

RSpec.describe Category, type: :model do
  before(:each) do
    @category = create(:category)
  end

  describe 'pagination' do
    it 'is set to 20 records per page' do
      expect(Category.per_page).to eq(20)
    end
  end

  describe 'validations' do
    it { should have_many(:topics) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe '.search' do
    it 'returns all matching categories to the query' do
      expect(Category.search('first').count).to eq(1)
    end
  end

  describe 'no_topics?' do
    it 'should returns true if topics are empty' do
      expect(@category.no_topics?).to eq(true)
    end
  end

  describe 'delete' do
    it 'cannot be performed when has assigned topics' do
      @category.topics.create(name: "Topic", description: "Desc")
      expect(@category.destroy).to eq(false)
    end
  end
end
