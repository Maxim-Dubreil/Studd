class DashboardsController < ApplicationController
  def index
    # Données pour le dashboard - sera remplacé par les vraies données API
    @user = current_user || OpenStruct.new(
      name: "Étudiant Demo", 
      email: "demo@studyapp.com",
      avatar: nil
    )
  end
end
