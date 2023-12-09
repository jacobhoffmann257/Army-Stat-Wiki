class UnitKeywordsController < ApplicationController
  def index
    matching_unit_keywords = UnitKeyword.all

    @list_of_unit_keywords = matching_unit_keywords.order({ :created_at => :desc })

    render({ :template => "unit_keywords/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_unit_keywords = UnitKeyword.where({ :id => the_id })

    @the_unit_keyword = matching_unit_keywords.at(0)

    render({ :template => "unit_keywords/show" })
  end

  def create
    the_unit_keyword = UnitKeyword.new
    the_unit_keyword.unit_id = params.fetch("query_unit_id")
    the_unit_keyword.keyword_id = params.fetch("query_keyword_id")

    if the_unit_keyword.valid?
      the_unit_keyword.save
      redirect_to("/unit_keywords", { :notice => "Unit keyword created successfully." })
    else
      redirect_to("/unit_keywords", { :alert => the_unit_keyword.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_unit_keyword = UnitKeyword.where({ :id => the_id }).at(0)

    the_unit_keyword.unit_id = params.fetch("query_unit_id")
    the_unit_keyword.keyword_id = params.fetch("query_keyword_id")

    if the_unit_keyword.valid?
      the_unit_keyword.save
      redirect_to("/unit_keywords/#{the_unit_keyword.id}", { :notice => "Unit keyword updated successfully."} )
    else
      redirect_to("/unit_keywords/#{the_unit_keyword.id}", { :alert => the_unit_keyword.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_unit_keyword = UnitKeyword.where({ :id => the_id }).at(0)

    the_unit_keyword.destroy

    redirect_to("/unit_keywords", { :notice => "Unit keyword deleted successfully."} )
  end
end
