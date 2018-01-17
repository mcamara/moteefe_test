require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#start_time_is_in_future' do
    let(:event) { build(:event, start_time: Time.zone.yesterday) }
    before { event.valid? }

    it 'should show an error' do
      expect(event.errors.messages[:start_time]).to eq(['The event should start in the future'])
    end

    it 'should not be valid' do
      expect(event.valid?).to be_falsey
    end
  end

  describe '#end_time_after_start_time' do
    let(:event) { build(:event, start_time: Time.zone.tomorrow, end_time: Time.zone.now + 1.minute) }
    before { event.valid? }

    it 'should show an error' do
      expect(event.errors.messages[:end_time]).to eq(['End time cannot be before the start time'])
    end

    it 'should not be valid' do
      expect(event.valid?).to be_falsey
    end
  end

  describe 'notify user' do
    let!(:search) { create(:search, email: 'blah@bla.com', date: Time.zone.tomorrow, search_params: { name: 'Lorem' }) }

    describe 'with matching search' do
      let(:event) { build(:event, start_time: Time.zone.tomorrow, name: 'Lorem ipsum') }

      it 'creates an email worker' do
        expect(SendEmailWorker).to receive(:perform_async)
        event.save
      end
    end

    describe 'without matching search' do
      let(:event) { build(:event, start_time: Time.zone.tomorrow, name: 'No matching test') }

      it 'creates an email worker' do
        expect(SendEmailWorker).to_not receive(:perform_async)
        event.save
      end
    end
  end
end
