class ContactMesController < ApplicationController
	def create
    contact_me = ContactMe.new(contact_me_params)

    if contact_me.save
      redirect_to root_path
    else
      redirect_to root_path, flash: { error: contact_me.errors.messages }
    end
  end

  private

  def contact_me_params
    params.require(:contact_me).permit(:name, :email, :content)
  end
end
