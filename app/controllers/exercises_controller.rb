class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  
  def index
    @exercises = current_user.exercises
    @friends = current_user.friends
    set_current_room
    @message = Message.new
  end
  
  def show
  end
  
  def new
    @exercise = current_user.exercises.new
  end
  
  def create
    @exercise = current_user.exercises.find_by(workout_date: params[:exercise][:workout_date])
    
    if @exercise
      @exercise.update(exercise_params)
      flash[:notice] = "Exercise has been updated"
      redirect_to [current_user, @exercise]
    else
      @exercise = current_user.exercises.new(exercise_params)
    
      if @exercise.save
        flash[:notice] = "Exercise has been created"
        redirect_to [current_user, @exercise]
      else
        flash.now[:alert] = "Exercise has not been created"
        render :new
      end
    end
  end
    
    
  
  def edit
  end
  
  def update
    if @exercise.update(exercise_params)
      flash[:notice] = 'Exercise has been updated'
      redirect_to [current_user, @exercise]
    else
      flash[:alert] = 'Exercise has not been updated'
      render :edit
    end
  end
  
  def destroy
    @exercise.destroy
    flash[:notice] = "Exercise has been deleted"
    redirect_to user_exercises_path(current_user)
  end
  
  private
  
  def set_exercise
    @exercise = current_user.exercises.find_by(id: params[:id]) 
  end
  
  def set_current_room
    if params[:roomId]
      @room = Room.find_by(id: params[:roomId])
    else
      @room = current_user.room
    end
    session[:current_room] = @room.id if @room
  end
  
  def exercise_params
    params.require(:exercise).permit(:duration_in_min, :workout, :workout_date, :user_id)
  end
  
end