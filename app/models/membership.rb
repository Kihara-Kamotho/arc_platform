class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  scope :ordered, -> { order(created_at: :desc)} 

  # action_cable & turbo_stream for live updates
  after_create_commit -> {
    broadcast_prepend_to 'memberships', partial: 'memberships/membership',
     locals: {membership: self}, target: 'memberships' }
  
  after_update_commit -> { 
    broadcast_update_to 'memberships', partial: 'memberships/updated_membership', 
    locals: { membership: self }, target: self }

  after_destroy_commit -> { broadcast_remove_to 'memberships' }
end
