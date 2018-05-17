# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValkyrieControllerBehaviors do
  before(:all) do
    class CommonController < ApplicationController
      include ValkyrieControllerBehaviors
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('CommonController')
  end

  let(:controller) { CommonController.new }
  let(:error_message) { 'This needs to be define in the class including this module' }

  describe '#change_set_class' do
    it 'raises an error' do
      expect { controller.change_set_class }.to raise_error(StandardError, error_message)
    end
  end

  describe '#resource_class' do
    it 'raises an error' do
      expect { controller.resource_class }.to raise_error(StandardError, error_message)
    end
  end

  describe '#respond_success' do
    it 'raises an error' do
      expect { controller.respond_success(nil) }.to raise_error(StandardError, error_message)
    end
  end

  describe '#respond_error' do
    it 'raises an error' do
      expect { controller.respond_error(nil, nil) }.to raise_error(StandardError, error_message)
    end
  end
end
