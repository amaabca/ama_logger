# frozen_string_literal: true

FactoryBot.define do
  factory :context, class: OpenStruct do
    invoked_function_arn { 'arn:aws:lambda:us-west-2:111111111111:function:testfunc' }
    aws_request_id { SecureRandom.uuid }
  end
end
