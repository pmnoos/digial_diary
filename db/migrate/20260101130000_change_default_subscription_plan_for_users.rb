class ChangeDefaultSubscriptionPlanForUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :subscription_plan, from: "free_trial", to: "monthly"
  end
end
