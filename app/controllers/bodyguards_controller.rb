class BodyguardsController < ApplicationController
  def index
    matching_bodyguards = Bodyguard.all

    @list_of_bodyguards = matching_bodyguards.order({ :created_at => :desc })

    render({ :template => "bodyguards/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_bodyguards = Bodyguard.where({ :id => the_id })

    @the_bodyguard = matching_bodyguards.at(0)

    render({ :template => "bodyguards/show" })
  end

  def create
    the_bodyguard = Bodyguard.new
    the_bodyguard.leader_id = params.fetch("query_leader_id")
    the_bodyguard.unit_id = params.fetch("query_unit_id")

    if the_bodyguard.valid?
      the_bodyguard.save
      redirect_to("/bodyguards", { :notice => "Bodyguard created successfully." })
    else
      redirect_to("/bodyguards", { :alert => the_bodyguard.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_bodyguard = Bodyguard.where({ :id => the_id }).at(0)

    the_bodyguard.leader_id = params.fetch("query_leader_id")
    the_bodyguard.unit_id = params.fetch("query_unit_id")

    if the_bodyguard.valid?
      the_bodyguard.save
      redirect_to("/bodyguards/#{the_bodyguard.id}", { :notice => "Bodyguard updated successfully."} )
    else
      redirect_to("/bodyguards/#{the_bodyguard.id}", { :alert => the_bodyguard.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_bodyguard = Bodyguard.where({ :id => the_id }).at(0)

    the_bodyguard.destroy

    redirect_to("/bodyguards", { :notice => "Bodyguard deleted successfully."} )
  end
end
