class TaskUserConnection < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :user, :task, presence: true
  validates :user_id, uniqueness: { scope: :task_id }

  state_machine :state, initial: :in_progress do
    event :complete do
      transition in_progress: :completed
    end
  end
end
