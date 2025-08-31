require 'rails_helper'

RSpec.describe PromptBuilder::Quiz do
  let(:content) { "Git est un système de contrôle de version distribué." }
  let(:title) { "Test Quiz" }
  let(:quiz_builder) { described_class.new(content, title: title) }

  describe 'constants' do
    it 'has a SYSTEM_PROMPT constant' do
      expect(described_class::SYSTEM_PROMPT).to be_a(String)
      expect(described_class::SYSTEM_PROMPT).to include('expert en création de quiz')
    end

    it 'has an EXAMPLE_JSON constant' do
      expect(described_class::EXAMPLE_JSON).to be_a(String)
      expect(described_class::EXAMPLE_JSON).to include('quizId')
    end
  end

  describe '#initialize' do
    it 'sets content and title' do
      expect(quiz_builder.instance_variable_get(:@content)).to eq(content)
      expect(quiz_builder.instance_variable_get(:@title)).to eq(title)
    end

    it 'uses default title when not provided' do
      default_builder = described_class.new(content)
      expect(default_builder.instance_variable_get(:@title)).to eq("Quiz")
    end
  end

  describe '#build' do
    let(:result) { quiz_builder.build }

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

    it 'includes the example JSON in user message' do
      user_message = result.last
      expect(user_message[:content]).to include(described_class::EXAMPLE_JSON)
    end

    it 'includes instructions about JSON format' do
      user_message = result.last
      expect(user_message[:content]).to include('JSON strict')
    end
  end

  describe 'example JSON validity' do
    it 'contains valid JSON in EXAMPLE_JSON' do
      expect { JSON.parse(described_class::EXAMPLE_JSON) }.not_to raise_error
    end

    it 'has required fields in example JSON' do
      parsed = JSON.parse(described_class::EXAMPLE_JSON)
      expect(parsed).to have_key('quizId')
      expect(parsed).to have_key('title')
      expect(parsed).to have_key('description')
      expect(parsed).to have_key('questions')
    end

    it 'has questions array in example JSON' do
      parsed = JSON.parse(described_class::EXAMPLE_JSON)
      expect(parsed['questions']).to be_an(Array)
      expect(parsed['questions']).not_to be_empty
    end
  end
end
