class ChargesController < ApplicationController
  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
    
    # Where the real magic happens
    charge = Stripe::Subscription.create(
      customer: customer.id, # Note -- this is NOT the user_id in your app
      :items => [
        {
          :plan => "BLOCIPREM",
        },
      ],
    )

    current_user.charge_id = charge.id
    current_user.update_attribute :standard, false
    current_user.update_attribute :premium, true

    flash[:notice] = "Thanks for supporting Blocipedia, #{current_user.email}! Feel free to create all the private wikis you can dream up!"
    redirect_to welcome_index_path 

    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end

  def new
    @amount = 1500
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.email}",
      amount: @amount
    }
  end

  def destroy
    @sub = Stripe::Subscription.retrieve(current_user.charge_id)
    @private_wikis = Wiki.where(:user_id => current_user.id)

    if @sub
      current_user.charge_id = ""
      current_user.update_attribute :standard, true
      current_user.update_attribute :premium, false
      @private_wikis.each {|wiki| wiki.update_attribute :private, false}
      flash[:notice] = "\"#{current_user.email}\" was downgraded successfully. Sorry to see you go!"
      redirect_to welcome_index_path
      @sub.delete
    else
      flash.now[:alert] = "There was an error downgrading."
      redirect_to welcome_index_path
    end
  end
end
