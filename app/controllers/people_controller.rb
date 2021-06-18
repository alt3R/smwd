class PeopleController < ApplicationController
  before_action :set_person, except: %i[index new create]
  before_action :vk_attrs, only: [:edit], if: -> { request.get? }

  def index
    @people = Person.all
  end

  def show; end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @person.assign_fields(vk_params) if vk_params.present?
    if @person.update(person_params)
      redirect_to @person
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy

    redirect_to root_path
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:full_name, :birthday, :city, :region, :country)
  end
end
