require 'test_helper'

class ConsultationRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ConsultationRequest.destroy_all
    Recommendation.destroy_all
  end

  test 'should create consultation request' do
    consultation_request_params = {
      consultation_request: {
        patient_id: 980190962,
        text: 'I need a consultation regarding my health.'
      }
    }

    post '/consultation_requests', params: consultation_request_params

    assert_response :created

    assert_equal 1, ConsultationRequest.count

    response_data = JSON.parse(response.body)
    assert_equal 'Consultation request created successfully', response_data['message']
    assert_equal 'I need a consultation regarding my health.', response_data['consultation_request']['text']
  end

  test 'should create recommendation for consultation request' do
    consultation_request = ConsultationRequest.create(patient_id: 980190962, text: 'Testing consultation request')

    post "/consultation_requests/#{consultation_request.id}/recommendations"

    assert_response :created

    assert_equal 1, Recommendation.count

    response_data = JSON.parse(response.body)
    assert_equal 'Recommendation created successfully', response_data['message']
  end
end
