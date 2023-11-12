# test/controllers/patients_controller_test.rb
require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Patient.destroy_all
  end

  test 'should get index' do
    assert_equal 0, Patient.count
  
    get '/patients'
  
    assert_response :not_found
  
    patients = create_patients(3)
  
    get '/patients'
  
    assert_response :ok
  
    assert_equal patients.count, JSON.parse(response.body).count
  
    patients.each do |patient|
      assert_includes response.body, patient.name
    end
  end

  test 'should show patient' do
    patient = create_patient
    get "/patients/#{patient.id}"
    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal 'Test Patient', response_data['name']

    get "/patients/#{123}"
    assert_response :not_found
  end

  test 'should create patient' do
    patient_params = {
      patient: {
        name: 'John Doe',
        birth_date: '1990-01-01',
        phone: '+1234567890',
        email: 'john.doe@example.com'
      }
    }

    post '/patients', params: patient_params
    assert_response :created

    response_data = JSON.parse(response.body)
    assert_equal 'Patient created successfully', response_data['message']
    assert_equal 'John Doe', response_data['patient']['name']
  end

  test 'should update patient' do
    patient = create_patient
    updated_name = 'Updated Name'

    patch "/patients/#{patient.id}", params: { patient: { name: updated_name } }
    assert_response :success

    updated_patient = Patient.find(patient.id)
    assert_equal updated_name, updated_patient.name
  end

  test 'should destroy patient' do
    patient = create_patient

    assert_difference('Patient.count', -1) do
      delete "/patients/#{patient.id}"
    end

    assert_response :no_content
  end

  test 'should get recommendations for a patient' do
    patient = create_patient

    consultation_request = ConsultationRequest.create(patient_id: patient.id, text: 'Testing consultation request')

    post "/consultation_requests/#{consultation_request.id}/recommendations"
    post "/consultation_requests/#{consultation_request.id}/recommendations"
    post "/consultation_requests/#{consultation_request.id}/recommendations"

    get "/patients/#{patient.id}/recommendations"

    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal 3, response_data['recommendations'].length
  end

  private

  def create_patient
    Patient.create(name: 'Test Patient', birth_date: '1990-01-01', phone: '+1234567890', email: 'test@example.com')
  end

  def create_patients(count)
    patients = []
    count.times do |i|
      patients << Patient.create(name: "Patient #{i + 1}", birth_date: '1990-01-01', phone: "+123456789#{i}", email: "patient#{i + 1}@example.com")
    end
    patients
  end
end
