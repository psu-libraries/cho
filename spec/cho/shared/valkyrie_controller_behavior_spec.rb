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

  # Below are a set of private methods that the controller is expected to define or override
  #   We are adding tests here to be certain they are still defined and will raise an error
  #   if someone tries to use the controller behaviors without defining them
  describe '#respond_success' do
    it 'raises an error' do
      expect { controller.send(:respond_success, nil) }.to raise_error(StandardError, error_message)
    end
  end

  describe '#respond_error' do
    it 'raises an error' do
      expect { controller.send(:respond_error, nil, nil) }.to raise_error(StandardError, error_message)
    end
  end

  describe '#delete_change_set' do
    it 'raises an error' do
      expect { controller.send(:delete_change_set) }.to raise_error(StandardError, error_message)
    end
  end

  describe '#persister' do
    it 'raises an error' do
      expect { controller.send(:persister) }.to raise_error(StandardError, error_message)
    end
  end

  describe '#view_data' do
    it 'raises an error' do
      expect { controller.send(:view_data, nil) }.to raise_error(StandardError, error_message)
    end
  end

  describe '#success_message' do
    it 'raises an error' do
      expect { controller.send(:success_message) }.to raise_error(StandardError, error_message)
    end
  end
end
