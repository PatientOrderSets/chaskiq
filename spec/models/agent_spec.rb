# frozen_string_literal: true

require "rails_helper"

RSpec.describe Agent, type: :model do
  let(:app) do
    FactoryBot.create :app
  end

  let!(:role) do
    app.add_agent({ email: "test@test.cl", first_name: "dsdsa" })
  end

  describe "inbound email" do
    it "mailbox" do
      expect(role.inbound_email_address).to be_present
    end

    it "mailbox" do
      app, agent = App.decode_inbound_address(role.inbound_email_address)
      expect(app).to be_present
      expect(agent).to be_present
    end
  end

  describe "password validation" do
    it "should return a message with missing requirements" do
      agent = Agent.first

      password = "password"
      agent.password = password
      agent.password_confirmation = password
      result = agent.save

      expect(result).to be_falsey
      expect(agent.errors).to include(:password)
      expect(agent.errors.full_messages).to include("Password Complexity requirement not met. Please use: 1 uppercase, 1 digit, 1 special character")

      password = "Password!"
      agent.password = password
      agent.password_confirmation = password
      result = agent.save

      expect(result).to be_falsey
      expect(agent.errors).to include(:password)
      expect(agent.errors.full_messages).to include("Password Complexity requirement not met. Please use: 1 digit")
    end

    it "should return nil when password satisfies requirements" do
      agent = Agent.first

      password = "Password123!"
      agent.password = password
      agent.password_confirmation = password
      result = agent.save

      expect(result).to be_truthy
      expect(agent.errors).to be_blank
    end
  end
end
