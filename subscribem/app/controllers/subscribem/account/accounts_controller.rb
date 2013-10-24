require_dependency "subscribem/application_controller"

module Subscribem
  class Account::AccountsController < ApplicationController
    before_filter :authenticate_user!
    before_filter :authorize_owner

    def update
      plan_id = account_params.delete(:plan_id)

      if current_account.update_attributes(account_params)
        flash[:success] = "Account updated successfully."

        if plan_id != current_account.plan_id
          redirect_to(plan_account_url(:plan_id => plan_id))
        else
          redirect_to root_url
        end
      else
        flash[:error] = "Account could not be updated."
        render :edit
      end
    end

    def plan
      @plan = Subscribem::Plan.find(params[:plan_id])
    end

    def subscribe
      @plan = Subscribem::Plan.find(params[:plan_id])
      result = Braintree::TransparentRedirect.confirm(request.query_string)

      if result.success?
        current_account.update_column(:plan_id, params[:plan_id])
        subscription_result = Braintree::Subscription.create(
          payment_method_token: result.customer.credit_cards[0].token,
          plan_id: @plan.braintree_id)
        flash[:success] = "You have switched to the '#{@plan.name}' plan."
        redirect_to root_path
      end
    end

    private

    def account_params
      params.require(:account).permit(:name, :plan_id)
    end
  end
end
