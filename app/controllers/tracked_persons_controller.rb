class TrackedPersonsController < ApplicationController
  def index
    @tracked_persons = TrackedPerson.all
  end
end
