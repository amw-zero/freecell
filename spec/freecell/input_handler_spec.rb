RSpec.describe Freecell::InputHandler do
  let(:input_handler) { described_class.new }

  describe '.move_complete' do
    subject { input_handler.move_complete }

    context 'when a move has not been received' do
      it { is_expected.to be false }
    end

    context 'when a single move has been received' do
      before do
        input_handler.handle_key('a')
        input_handler.handle_key('b')
      end

      it { is_expected.to be true }
    end

    context 'when a key is received after a move was received' do
      before do
        input_handler.handle_key('a')
        input_handler.handle_key('b')
        input_handler.handle_key('c')
      end

      it { is_expected.to be false }
    end
  end

  describe '.current_move' do
    subject { input_handler.current_move }

    context 'when a move has not been received' do
      it { is_expected.to be_nil }
    end

    context 'when a single move has been received' do
      before do
        input_handler.handle_key('a')
        input_handler.handle_key('b')
      end

      it { is_expected.to eq 'ab' }
    end

    context 'when a single move has been received to the last cascade' do
      before do
        input_handler.handle_key('a')
        input_handler.handle_key('h')
      end

      it { is_expected.to eq 'ah' }
    end

    context 'when a key is receieved after a move was received' do
      before do
        input_handler.handle_key('a')
        input_handler.handle_key('b')
        input_handler.handle_key('c')
      end

      it { is_expected.to be_nil }
    end

    context 'when a special character is received' do
      subject(:current_move) { input_handler.current_move }

      before do
        input_handler.handle_key('a')
        input_handler.handle_key(Freecell::ASCIIBytes::CARRIAGE_RETURN)
      end

      it 'sanitizes the character to its ASCII byte' do
        expect(current_move).to eq "a\n"
      end
    end
  end
end
