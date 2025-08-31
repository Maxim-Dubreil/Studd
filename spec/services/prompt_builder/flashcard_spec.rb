require 'rails_helper'

RSpec.describe PromptBuilder::Flashcard do
  let(:content) { "La photosynthèse est le processus par lequel les plantes convertissent la lumière du soleil en énergie." }
  let(:count) { 5 }
  let(:flashcard_builder) { described_class.new(content, count) }

  describe 'constants' do
    it 'has a SYSTEM_PROMPT constant' do
      expect(described_class::SYSTEM_PROMPT).to be_a(String)
      expect(described_class::SYSTEM_PROMPT).to include('expert en création de flash-cards')
    end

    it 'has an EXAMPLE_JSON constant' do
      expect(described_class::EXAMPLE_JSON).to be_a(String)
      expect(described_class::EXAMPLE_JSON).to include('flashcards')
    end
  end

  describe '#initialize' do
    it 'sets content and count' do
      expect(flashcard_builder.instance_variable_get(:@content)).to eq(content)
      expect(flashcard_builder.instance_variable_get(:@count)).to eq(count)
    end

    it 'uses default count when not provided' do
      default_builder = described_class.new(content)
      expect(default_builder.instance_variable_get(:@count)).to eq(10)
    end
  end

  describe '#build' do
    let(:result) { flashcard_builder.build }

    it 'returns an array of messages' do
      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
    end

    it 'includes system message with correct role and content' do
      system_message = result.first
      expect(system_message[:role]).to eq("system")
      expect(system_message[:content]).to eq(described_class::SYSTEM_PROMPT)
    end

    it 'includes user message with correct role' do
      user_message = result.last
      expect(user_message[:role]).to eq("user")
      expect(user_message[:content]).to be_a(String)
    end

    it 'includes the provided content in user message' do
      user_message = result.last
      expect(user_message[:content]).to include(content)
    end

    it 'includes the requested count in user message' do
      user_message = result.last
      expect(user_message[:content]).to include(count.to_s)
    end

    it 'includes the example JSON in user message' do
      user_message = result.last
      expect(user_message[:content]).to include(described_class::EXAMPLE_JSON)
    end

    it 'includes difficulty levels in user message' do
      user_message = result.last
      expect(user_message[:content]).to include('easy')
      expect(user_message[:content]).to include('medium')
      expect(user_message[:content]).to include('hard')
    end
  end

  describe 'example JSON validity' do
    it 'contains valid JSON in EXAMPLE_JSON' do
      expect { JSON.parse(described_class::EXAMPLE_JSON) }.not_to raise_error
    end

    it 'has required structure in example JSON' do
      parsed = JSON.parse(described_class::EXAMPLE_JSON)
      expect(parsed).to have_key('flashcards')
      expect(parsed['flashcards']).to be_an(Array)
    end

    it 'has required fields in flashcard objects' do
      parsed = JSON.parse(described_class::EXAMPLE_JSON)
      flashcard = parsed['flashcards'].first
      expect(flashcard).to have_key('question')
      expect(flashcard).to have_key('answer')
      expect(flashcard).to have_key('difficulty')
      expect(flashcard).to have_key('tags')
    end
  end
end
