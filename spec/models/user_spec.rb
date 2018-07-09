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
    let(:companya) { create(:company, custom_data: ['custom']) }
    let(:companyb) { create(:company, custom_data: ['custom']) }

    let(:user) { create(:user, company: company) }
  end
end
