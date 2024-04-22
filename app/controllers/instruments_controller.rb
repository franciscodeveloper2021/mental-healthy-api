class InstrumentsController < ApplicationController

  def initialize
    super

    @service = UseCases::Instruments::CrudInstrumentService.new
  end

  def index
    instruments = @service.index.includes(:questions)

    instrument_data = instruments.map do |instrument|
      {
        instrument: instrument,
        questions: instrument.questions
      }
    end

    render json: instrument_data, status: :ok
  end

  def show
    instrument = @service.show(params[:id])

    render json: { instrument: instrument, questions: instrument.questions }, status: :ok
  end

  def create
    instrument = @service.create(instrument_params)

    render json: instrument, status: :created
  end

  def update
    updated_instrument = @service.update(params[:id], instrument_params)

    render json: updated_instrument, status: :ok
  end

  def destroy
    instrument = @service.destroy(params[:id])

    render json: { message: I18n.t("warnings.destroyed", record: instrument[:title]) }, status: :ok
  end

  private

  def instrument_params
    params.require(:instrument).permit(:title, :description)
  end
end
