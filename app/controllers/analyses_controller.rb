class AnalysesController < ApplicationController
  before_action :set_person, only: [:show]

  def index
    @people = Person.all
  end

  def show
    @analysis = Analysis.find_or_create_by(person: @person)
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end
end
