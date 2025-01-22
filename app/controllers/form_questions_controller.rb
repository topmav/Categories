class FormQuestionsController < ApplicationController
    before_action :set_category
  
    def create
      @form_question = @category.form_questions.build(question_params)
      if @form_question.save
        render json: { success: true, id: @form_question.id }
      else
        render json: { success: false, error: @form_question.errors.full_messages.join(", ") }
      end
    end
  
    def update
      @form_question = @category.form_questions.find(params[:id])
      if @form_question.update(question_params)
        render json: { success: true }
      else
        render json: { success: false, error: @form_question.errors.full_messages.join(", ") }
      end
    end
  
    def destroy
      @form_question = @category.form_questions.find(params[:id])
      if @form_question.destroy
        render json: { success: true }
      else
        render json: { success: false, error: "Failed to delete question" }
      end
    end
  
    private
  
    def set_category
      @category = Category.find(params[:category_id])
    end
  
    def question_params
      params.require(:form_question).permit(:question, :question_type, :reasoning)
    end
  end