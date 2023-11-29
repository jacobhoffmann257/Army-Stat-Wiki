class KeywordsController < ApplicationController
  def index
    matching_keywords = Keyword.all

    @list_of_keywords = matching_keywords.order({ :created_at => :desc })

    render({ :template => "keywords/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_keywords = Keyword.where({ :id => the_id })

    @the_keyword = matching_keywords.at(0)

    render({ :template => "keywords/show" })
  end

  def create
    the_keyword = Keyword.new
    the_keyword.name = params.fetch("query_name")

    if the_keyword.valid?
      the_keyword.save
      redirect_to("/keywords", { :notice => "Keyword created successfully." })
    else
      redirect_to("/keywords", { :alert => the_keyword.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_keyword = Keyword.where({ :id => the_id }).at(0)

    the_keyword.name = params.fetch("query_name")

    if the_keyword.valid?
      the_keyword.save
      redirect_to("/keywords/#{the_keyword.id}", { :notice => "Keyword updated successfully."} )
    else
      redirect_to("/keywords/#{the_keyword.id}", { :alert => the_keyword.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_keyword = Keyword.where({ :id => the_id }).at(0)

    the_keyword.destroy

    redirect_to("/keywords", { :notice => "Keyword deleted successfully."} )
  end
end
