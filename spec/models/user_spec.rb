require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when company does not have custom_data' do
    let(:company) { create(:company, custom_data: []) }
    let(:user) { create(:user, company: company) }

    it 'returns nothing when querying for users custom_attributes' do
      expect(user.custom_attributes).to be_empty
    end
  end

  context 'when company has custom_data' do
    let(:company) { create(:company, custom_data: %w[custom data]) }
    let(:user) { create(:user, company: company) }
    let(:expected_result) { { 'custom' => 'random_info' } }

    subject do
      user.configure_attribute('custom', 'random_info')
    end

    it 'allows user to be updated' do
      expect { subject }.not_to raise_error
    end

    it 'saves the data correctly' do
      subject
      expect(user.formatted_custom_attributes).to be_eql expected_result
    end

    it 'returns the right user when searching' do
      subject
      search = User.search_by company: company, field_name: 'custom', field_value: 'random_info'
      expect(search).to include(user)
    end

    context 'and company tries to save an inexistent custom_data' do
      subject do
        user.configure_attribute('inexistent', 'random_info')
      end

      it 'raises an error' do
        expect { subject }.to raise_error Company::AttributeNotRegisted
      end
    end
  end

  context 'when companies have the same custom_data' do
    let(:company_a) { create(:company, custom_data: ['custom']) }
    let(:company_b) { create(:company, custom_data: ['custom']) }

    let!(:user_a) { create(:user, company: company_a) }
    let!(:user_b) { create(:user, company: company_b) }

    let(:user_a_custom_attribute) { 'user_a_custom' }
    let(:user_b_custom_attribute) { 'user_b_custom' }

    before do
      user_a.configure_attribute('custom', user_a_custom_attribute)
      user_b.configure_attribute('custom', user_b_custom_attribute)
    end

    context 'and company_a searches for their user' do
      subject do
        User.search_by company: company_a, field_name: 'custom', field_value: user_a_custom_attribute
      end
      it 'returns a user' do
        expect(subject).not_to be_empty
      end

      it 'does not include user_b' do
        expect(subject).not_to include(user_b)
      end
    end

    context 'and company_b searches for their user' do
      subject do
        User.search_by company: company_b, field_name: 'custom', field_value: user_b_custom_attribute
      end
      it 'returns a user' do
        expect(subject).not_to be_empty
      end

      it 'does not include user_a' do
        expect(subject).not_to include(user_a)
      end
    end
  end
end
