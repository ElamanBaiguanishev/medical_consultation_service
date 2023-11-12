class PatientsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @patients = Patient.all

    if @patients.any?
      render json: @patients, status: :ok
    else
      render json: { error: 'Patients not found' }, status: :not_found
    end
  end

  def show
    @patient = Patient.find_by_id(params[:id])
  
    if @patient
      render json: @patient, status: :ok
    else
      render json: { error: 'Patient not found' }, status: :not_found
    end
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      render json: { message: 'Patient created successfully', patient: @patient }, status: :created
    else
      render json: { error: @patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @patient = Patient.find_by_id(params[:id])
  
    if @patient
      if @patient.update(patient_params)
        render json: @patient, status: :ok
      else
        render json: { error: @patient.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Patient not found' }, status: :not_found
    end
  end

  def destroy
    @patient = Patient.find_by_id(params[:id])
  
    if @patient
      @patient.destroy
      head :no_content
    else
      render json: { error: 'Patient not found' }, status: :not_found
    end
  end

  def recommendations
    @patient = Patient.find_by_id(params[:id])
  
    if @patient
      @recommendations = @patient.recommendations
      render json: { recommendations: @recommendations }, status: :ok
    else
      render json: { error: 'Patient not found' }, status: :not_found
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :birth_date, :phone, :email)
  end
end
