require 'net/http'

class ConsultationRequestsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def create
      @consultation_request = ConsultationRequest.new(consultation_request_params)
  
      if @consultation_request.save
        render json: { message: 'Consultation request created successfully', consultation_request: @consultation_request }, status: :created
      else
        render json: { errors: @consultation_request.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def create_recommendation
      @consultation_request = find_request
    
      request_text = @consultation_request.text
    
      openfda_data = fetch_openfda_data(request_text)

      if openfda_data
        recommendation = Recommendation.new(
          consultation_request_id: @consultation_request.id,
          text: openfda_data
        )
    
        if recommendation.save
          render json: { message: 'Recommendation created successfully', recommendation: recommendation }, status: :created
        else
          render json: { errors: recommendation.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: 'Error' }, status: :unprocessable_entity
      end
    end
    
    private
    
    def find_request
      ConsultationRequest.find_by_id(params[:request_id])
    end
  
    def consultation_request_params
      params.require(:consultation_request).permit(:patient_id, :text)
    end

    def recommendation_params
      params.require(:recommendation).permit(:text)
    end

    def fetch_openfda_data(text_query)
      base_url = 'https://api.fda.gov/drug/event.json'
      search_query = "?search=#{URI.encode_www_form_component("patient.reaction.reactionmeddrapt:#{text_query}")}"
      url = "#{base_url}#{search_query}"
    
      uri = URI(url)
      response = Net::HTTP.get(uri)
      parsed_response = JSON.parse(response)

      # Возвращаем только "results"
      parsed_response["results"].first["patient"]["drug"].first["medicinalproduct"]
    end    
end
  